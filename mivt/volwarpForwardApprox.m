function [warpedvol, varargout] = volwarpForwardApprox(vol, warp, varargin)
% VOLWARPFORWARDAPPROX warp volumes with forward warps using a heuristic algorithm.
%
% warpedvol = volwarpForwardApprox(vol, warp) warp vol with the forward (warp->dst) warp "warp".
% vol is an n-dimentional volume, and warp is a n-entry cell, each of which is an n-dimentional
% volume. This function uses a fast approximating heuristic, compared to volwarp() which uses a more
% principled N-D Delaunay triangulation, which is much slower. 
%
% The rough idea is that rather than using the standard operation where for each destination voxel
% we try to determine its value by searching for the nearest neighbors to form a triangulation from,
% we instead ask each initial (source) voxel to move forward (e.g. position 2 --> position 5.3 via a
% +3.3 warp), and then contribute a partial vote (e.g. 0.7 weighted vote to position 5 and 0.3
% weighted vote to position 6) of the initial voxel value. Some destination voxels will be missed
% completely, but we can fill them in at the end if there's few enough of them. This method can be
% 40-200x faster than volwarp.
%
% Missed voxels (voxels with no votes) are filled in with inpaintn or nearest-neighbour heuristic,
% depending on the desired interpolation method.
%
% warpedvol = volwarpForwardApprox(vol, warp, Param, Value, ...) allows for the following
% param/value pairs:
%   nLayers - default:1. This is the number of "layers" (i.e. grid edges in each direction) a
%   forward-transformed voxel looks around. nLayers of one means that a voxel moved to position 5.3
%   only votes for positon 5 and position 6. nLayes of 2 means that voxel votes for position 4, 5,
%   6, 7. This will result in blurrier volumes
%
%   interpMethod - default: exp. options: exp, linear, nearest. Since this is a heuristic, linear
%   here means we use a linear-based weight when voting. However, exp can work much better,
%   especially when nLayers > 0.
%
%   interpParam - default: 2. interpMethod of 'exp' uses exp(-interpParam*dst) to weight voxel votes.
%
% [warpedvol, warpeddst] = volwarpForwardApprox(...) returns the overall weight of the votes at each
% destination location if 'linear' or 'exp' interpMethods are used.
% 
% [warpedvol, ..., votecountvol,  maxWeight] = volwarpForwardApprox(...) allows for additional
% volumes volcountvol (the number of votes contributing to each voxel), and maxWeight (the maximum
% weight contributing to each voxel), but these take extra time to compute and are meant as
% debugging variables only.
%
% TODO: we're currently not voting for some voxels due to the warp field expanding, say. One idea is
% to sub-sample the volume (say, by resizing it to twice its size), as well as the warps. Then, run
% this algorithm and vote. Then, downsample back to the original volume size. This would potentially
% facilitate some votes for those in-between previously missed voxels due to the interpolated warp.
% But I'm not sure how well it would work, how much we'd have to upsample, etc.
%
% TODO: use griddatan instead of interpn?
%
% Requires: mgt toolbox, interpn function
%
% See Also: volwarp, interpn
%
% Contact: adalca@csail.mit.edu
    
    warning('forward volwarp is now implemented (fast!) in MATLAB''s imwarp() as of R2014b.');

    % input parsing
    narginchk(2, inf);
    [vol, warp, opts] = parseInputs(vol, warp, varargin{:});

    % prepare destination locations
    nd = size2ndgrid(size(vol));
    volndgrid = cellfunc(@(x) x(:), nd);
    volndgrid = cat(2, volndgrid{:});
    warpvec = cellfunc(@(x) x(:), warp);
    shifts = cat(2, warpvec{:});
    locDestin = shifts + volndgrid;
    locDestin = max(locDestin, 1);
    locDestin = bsxfun(@min, locDestin, size(vol));
    
    % get the rounded volume cell structure
    [roundedLocs, dstWeights] = prepRoundedLocs(locDestin, opts.nLayers, size(vol));
    
    % prepare final volumes
    warpedvol = zeros(size(vol));
    warpeddst = zeros(size(vol));
    contributingWeight = zeros(size(vol)); 
    if nargout > opts.nargout
        contributingCounts = zeros(size(vol));
        maxWeight = zeros(size(vol)); 
    end
    
    % prepare structure looking through the different 2^ndims floor/ceil combos 
    optgrid = size2ndgrid(opts.nLayers * 2 * ones(1, ndims(vol)));
    optgrid = cellfunc(@(x) x(:), optgrid);
    optgrid = cat(2, optgrid{:});
    
    % go through each 2^ndims combination
    nDimsRngCell = mat2cellsplit(1:ndims(vol));
    for i = 1:size(optgrid, 1);
        % get the right combination of loc/wts
        bin = optgrid(i, :);
        roundedloc = cellfunc(@(r, d) r(:, d), roundedLocs(bin), nDimsRngCell);
        roundedWts = cellfunc(@(r, d) r(:, d), dstWeights(bin), nDimsRngCell);
        
         % get overall weights from distances
        localwt = dst2wt(cat(2, roundedWts{:}), opts.interpMethod, opts.nLayers, opts.interpParam);
        
        % get the linear index of the rounded locaiton
        roundedIdx = sub2ind(size(warpedvol), roundedloc{:});
                  
        % update volumes
        switch opts.interpMethod
            case {'linear', 'exp'}
                % note, we can't just use the following syntax: 
                % >> a(idx) = a(idx) + wts.*vals; 
                % since idx is not unique, i.e. we could ahve
                % >> a([1;1;2]) = a([1;1;2]) + [0.1;0.2;0.1];
                % in which case the first addition doesn't get executed.
                warpedvol = grpIdxOp(warpedvol, roundedIdx, localwt .* vol(:));
                contributingWeight = grpIdxOp(contributingWeight, roundedIdx, localwt);
                
            case 'nearest' 
                % we use a sparse matrix as a quick way to find the smallest distance 
                % within each group of voxels with the same index destination rounded index. 
                
                % get which of the elements in the same destination index group have highest weight
                secSparseIdx = 1:numel(roundedIdx);
                spInvLocWt = sparse(roundedIdx, secSparseIdx, localwt, numel(vol), numel(vol));
                inGrpMaxIdx = full(argmax(spInvLocWt, [], 2));
                uniqRoundedIdx = unique(roundedIdx);
                
                % extract the maximum weights at these maximum weight elements
                sIdx = sub2ind(size(spInvLocWt), uniqRoundedIdx, inGrpMaxIdx(uniqRoundedIdx));
                inGrpMaxWt = full(spInvLocWt(sIdx));
                
                % extract the volume values at these maximum weight elements
                spVol = sparse(roundedIdx, secSparseIdx, vol(:), numel(vol), numel(vol));
                spVolIdx = sub2ind(size(spVol), uniqRoundedIdx, inGrpMaxIdx(uniqRoundedIdx));
                selVol = full(spVol(spVolIdx));
                
                % replace weight and volume values where necessary
                [warpeddst(uniqRoundedIdx), changeMask] = ...
                    max([warpeddst(uniqRoundedIdx), inGrpMaxWt], [], 2);
                warpedvol(uniqRoundedIdx(changeMask == 2)) = selVol(changeMask == 2);
        end
        
        % extra debug variables, computed only if necessary since they take time
        if nargout > opts.nargout
            contributingCounts = grpIdxOp(contributingCounts, roundedIdx, localwt > 0);
            maxWeight = grpIdxOp(maxWeight, roundedIdx, localwt, @(x) max(x, [], 2));
        end
    end
    
    % compute final volume
    switch opts.interpMethod
        case {'linear', 'exp'}
            warpedvol = warpedvol ./ contributingWeight;
            warpedvol(contributingWeight == 0) = nan;
            varargout = {contributingWeight};
            
            % fill in NaNs
            nNans = sum(isnan(warpedvol(:)));
            if nNans > 0
                warning('Forward volwarp heuristic: inpainting %d Nans', nNans)
                warpedvol = inpaintn(warpedvol, 50);
            end
            
        case 'nearest' 
            % fill in NaNs using 'initial guess' bw-dist based from inpaintn
            nanmask = isnan(warpedvol);
            nNans = sum(nanmask(:));
            if nNans > 0
                [~, L] = bwdist(isfinite(warpedvol));
                warpedvol(nanmask) = warpedvol(L(nanmask));
            end
            varargout = {};
    end
    
    % extra debug variables
    if nargout > opts.nargout
        varargout = {varargout{:}, contributingCounts, maxWeight};
    end
end

function wt = dst2wt(dst, interpMethod, nLayers, interpParam)
% transform the distances of grid points to locaitons into weights, based on the interpolation
% method

    narginchk(3, 4);

    switch interpMethod
        case 'linear'
            dst = nLayers - dst;
            dst(abs(dst) < 0) = 0;
            wt = prod(dst, 2);
            assert(max(wt) <= nLayers.^ndims(vol));
            assert(max(wt) >= 0);
        
        case 'exp'
            dst = sqrt(sum(dst .^ 2, 2));
            wt = exp(-interpParam*dst);
            
        case 'nearest'
            % we use a sparse matrix as a quick way to find the smallest distance 
            % within each group of voxels with the same index destination rounded index. 
            % since sparse matrices are 0-based, we will make neeed to make our distance such
            % that "bigger is better" ==> we use exp(-wt)
            dst = sqrt(sum(dst .^ 2, 2));
            wt = exp(-dst);
    end
end

function sumvol = grpIdxOp(vol, idx, vals, op)
    if nargin <= 3
        op = @(x) sum(x, 2);
    end

    sec = 1:numel(idx);
    s = sparse(idx, sec, vals, numel(vol), numel(vol));
    sm = full(op(s));
    sumvol = reshape(op([vol(:), sm]), size(vol));
end

function [roundedLocs, dsts] = prepRoundedLocs(locDestin, nLayers, maxSize)
% prepare the rounded locations (ceil, floor, etc)

    % get rounded locations ready
    roundedLocs = cell(1, nLayers);
    roundedLocs{1} = floor(locDestin);
    roundedLocs{2} = roundedLocs{1} + 1;
    
    for i = 2:nLayers 
        roundedLocs{(i-1) .* 2 + 1} = roundedLocs{1} + i;
        roundedLocs{(i-1) .* 2 + 2} = roundedLocs{2} - i;
    end
    
    % get dimension-specific distances
    dsts = cell(1, nLayers * 2);
    for i = 1:numel(roundedLocs)
        dsts{i} = abs(locDestin - roundedLocs{i});
        
        % "take out" any values beyond volume limits by setting weights to 0.
        map = roundedLocs{i} < 1 | bsxfun(@gt, roundedLocs{i}, maxSize);
        roundedLocs{i}(map) = 1;
        dsts{i}(map) = inf;
    end
end

function [vol, warp, opts] = parseInputs(vol, warp, varargin)
% parse inputs

    p = inputParser();
    p.addRequired('vol', @isnumeric);
    p.addRequired('warp', @iscell);
    p.addParameter('nLayers', 1, @isscalar); % should be 1 is nearest 
    p.addParameter('interpMethod', 'exp', @ischar);
    p.addParameter('interpParam', 2); % 2 is default for 'exp' interpMethod
    p.parse(vol, warp, varargin{:});
    opts.nLayers = p.Results.nLayers;
    opts.interpMethod = p.Results.interpMethod;    
    opts.interpParam = p.Results.interpParam;
    
    switch opts.interpMethod
        case {'linear', 'exp'}
            opts.nargout = 1;
        case 'nearest'
            opts.nargout = 0;
        otherwise
            error('unknown interpolation method');
    end
end
