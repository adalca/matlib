function vol = volwarp(vol, disp, varargin)
% VOLWARP warp a n-dim volume via displacement fields.
%
% I = volwarp(vol, disp) warp the n-dimentional volume vol according to the displacements in disp.
% disp is a cell array of the size 1xD, where D is the dimension of vol (e.g. 2 for images, 3 for
% structural MRI), and each cell entry is a displacement volume of the same size as vol. The
% displacements specify 'forward' movement, i.e. where each voxel in the volume should move.
%
% I = volwarp(vol, disp, direction) allows direction to be 'backward', indicates that the given
% displacements specify the shift used to get to the current volume, and we want the backwards warp.
% That is, we want newVol such that vol = newVol with displacements. direction can also be
% 'forward', which is then equivalent to volwarp(vol, disp).
% 
% large volwarp execution with 'forward' warps is quite slow. see volwarpForwardApprox() for an
% alternative.
%
% I = volwarp(vol, disp, ..., param, value) allows for the following optional parameter/value pairs:
%   'interpMethod': interpolation method as taken by interpn (if backwards) or griddatan 
%       (if forwards). default: 'linear'
%   'extrapval': extrapolation value (scalar), as taken by interpn (if backwards). default: 0\
%   'nancleanup': 'inpaintn' (default) or 'zeros' on whether to inpaint or 0. 
%       inpainting requires inpaintn, a matlab central function. TODO: replace with functions rather
%       than chars/strings.
%   'selidxout': directly interpolate at only specific points. If this option is specified, there
%       will be no nan-cleanup operation. 
%
% partly inspired by iminterpolate() from demons toolbox by Herve Lombaert
%   (http://www.mathworks.com/matlabcentral/fileexchange/39194-diffeomorphic-log-demons-image-registration)
%
% example 1
%   n = 10;
%   one = ones(n, n);
%   im1 = rand(n, n); 
%   imf = volwarp(im1, {one, one});
%   imo = volwarp(imf, {one, one}, 'backward');
%   figure(); 
%   subplot(1,3,1); imshow(im1); title('original');
%   subplot(1,3,2); imshow(imf); title('all pixels moved by (1, 1)');
%   subplot(1,3,3); imshow(imo); title('backward from second image to get back first (almost)');
%
% example 2
%   n = 10;
%   im1 = zeros(n, n); 
%   im1(3, 3) = 1; % get an image with a bump
%   imf = volwarp(im1, {im1*5, im1*3}); % move the bump by (1, 1)
%   imo = volwarp(imf, {im1*5, im1*3}, 'backward'); % move it back
%   figure(); 
%   subplot(1,3,1); imshow(im1); title('original');
%   subplot(1,3,2); imshow(imf); title('moved bump');
%   subplot(1,3,3); imshow(imo); title('backward from second image to get back first (almost)');
%
% TODO: 
%   - part of this is similar to patchlib.corresp2dist.
%   - explore other Scattered Data Interpolation for forward case:
%       http://www.mathworks.com/help/matlab/scattered-data-interpolation.html
%
% See Also: volwarpForwardApprox
%
% Author: adalca@csail.mit.edu

    % parse inputs
    inputs = parseInputs(vol, disp, varargin{:});

    % get current volume locations grid.
    ranges = size2ndgrid(size(vol));

    % get shifted locations
    corresp = cellfunc(@plus, ranges, disp);

    % warp points via smartly inteprolating image
    % here we're using interpn(givenX, givenY, I, targetX, targetY).
    if strcmp(inputs.dirn, 'forward')
        warning('forward volwarp is now implemented (fast!) in MATLAB''s imwarp() as of R2014b.');
        warning('todo: switch to MATLAB implementation if the right version, else allow use of volwarp heuristic.');
        
        % If the passed displacement is a 'forward' displacement (vol.e. volume is moving by these
        % displacement), then we simply tell interpn that the volume of voxels (vol) is *at* the
        % shifted positions (corresp{:}). This basically shifts the voxels just because of the
        % representation used by interpn. We then ask interpn for the new voxels at the locations
        % given by the standard grid given in (ranges{:}).
        
        % we want to do: 
        % >> vol = interpn(corresp{:}, vol, ranges{:}, inputs.interpMethod, inputs.extrapval); but
        % interpn expects gridded corresp. So instead we'll have to use gridatan(), which is
        % slightly more cumbersome, but still okay. In fact, we use the slightly-modified
        % griddatanx(), whose only modification from griddatan is that in the case of interpolation
        % method of 'nearest', it doesn't "average" the values of duplicate X data, but takes the
        % median.
        c = cellfunc(@(x) x(:), corresp); 
        X1 = cat(2, c{:});
        c = cellfunc(@(x) x(inputs.selidxout(:)), ranges); 
        X2 = cat(2, c{:});
        
        try
            nvol = griddatanx(X1, vol(:), X2, inputs.interpMethod); 
            
        catch except
            
            % Note: we have to use 'QJ' because often times parts of the grid don't move.
            %
            % Explanation from the internets: 
            % Your data is already on a grid, or you have replicate values, or multipally collinear
            % points.
            % Griddata, which is built on Delaunay triangulations, is not designed to work well on
            % this type of data. It IS designed to work on scattered data.
            % 'QJ' randomly joggles the data so the points no longer suffer from the problems which
            % plague griddata. An intersting feature of this is that griddata will now produce
            % subtly different results for your surface when called repeatedly. This happens because
            % the triagulation will change randomly with each call.
            warning(except.message(1:min(80, numel(except.message))));
            nvol = griddatanx(X1, vol(:), X2, inputs.interpMethod, {'QJ'}); 
        end            
        
    else
        % If the passed displacement is a 'backward' displacement (the given volume is the
        % result of having moved voxels by the given displacement, and we want the original volume),
        % we do the opposite: we tell interpn that the volume of voxels (vol) is *at* the grid
        % locations. Now, for a new volume that's the same size as the volumes given in (ranges{:}),
        % we want the values at each of the voxels in the new volume to be the value of vol in the
        % shifted location. In other words, newvol(5, 3) = vol(ranges(5, 3)). So the new vol is the
        % volume that was moved to create vol. This is therefore a backwards transform.
        X2 = cellfunc(@(x) x(inputs.selidxout), corresp);
        nvol = interpn(ranges{:}, vol, X2{:}, inputs.interpMethod, inputs.extrapval); 
    end
    
    if numel(inputs.selidxout) == numel(vol) && all(inputs.selidxout(:)' == 1:numel(vol))
        vol = reshape(nvol, size(inputs.selidxout));
        
        % correct any NANs in the displacements. 
        vol = nancleanup(vol, inputs.nancleanup);
    else
        vol = nvol;
    end
end

function vol = nancleanup(vol, method)
    % correct any NANs in the displacements. 
    % Usually these happen at the edges due to silly interpolations.
    nNANs = sum(isnan(vol(:)));
    if nNANs > 0
        if strcmp(method, 'zeros')
            warning('volwarp: found %d NANs. Transforming them to 0s', nNANs);
            vol(isnan(vol)) = 0;
            
        elseif strcmp(method, 'inpaintn')
            warning('volwarp: found %d NANs. Inpainting them', nNANs);
            vol = inpaintn(vol);
            
        else
            error('unknown nan cleaning method');
        end
    end
end

function inputs = parseInputs(vol, disp, varargin)
% parse inputs according to volwarp signature.

    p = inputParser();
    p.addRequired('vol', @isnumeric);
    p.addRequired('disp', @iscell);
    p.addOptional('dirn', 'forward', @(x) sum(strcmp(x, {'forward', 'backward'})) == 1);
    p.addParameter('interpMethod', 'linear', @ischar); % should be anything interpn allows
    p.addParameter('extrapval', 0, @isscalar);
    p.addParameter('nancleanup', 'inpaintn', @ischar);
    
    % directly interpolate at only specific points, but this is an issue if you need to use interpn
    p.addParameter('selidxout', reshape(1:numel(vol), size(vol)), @isnumeric); 
    
    % parse and save inputs
    p.parse(vol, disp, varargin{:});
    inputs = p.Results;
    
    % check volume and disp dimensionalisites
    volDims = ndims(vol);
    assert(numel(disp) == volDims);
    for i = 1:volDims
        assert(ndims(disp{i}) == volDims, ...
            'disp %d dims (%d) is not the same as vol dims (%d)', i, ndims(disp), volDims);
        assert(all(size(disp{i}) == size(vol)), 'disp %d size is not the same as vol size', i);
    end
    
    if strcmp(inputs.nancleanup, 'inpaintn')
        % see inpaintn by Damien Garcia
        assert(exist('inpaintn') > 0, 'inpaintn.m is required for inpaintn method'); %#ok<EXIST>
    end
end
