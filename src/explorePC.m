function walkImages = explorePC(coeff, score, pcs)
% explore principal component
%
%
% requires tprod.
%   http://www.mathworks.com/matlabcentral/fileexchange/
%      /16275-tprod-arbitary-tensor-products-between-n-d-arrays/content/tprod.m

    nStops = 20;

    % get centroid of projection and variance along projection
    centroid = mean(score, 1);
    stdtroid = std(score, 1);

    % linspace for each dimension score between -3 and 3 stdev's
    l = cell(numel(pcs), 1);
    for i = 1:numel(pcs);
        pc = pcs(i);
        l{i} = linspace(-3*stdtroid(pc),+3*stdtroid(pc), nStops);
    end

    % walk along pcs. Need to build a matrix that is dim {x nStops} ^ #pcs
    %   so if there are 2 pcs, the matrix will be dim x nStops x nStops
    vols = cell(1+numel(pcs), 1);                
    [vols{:}] = ndgrid(centroid, l{:});
    for i = 1:numel(pcs)
        v = vols{i+1}*0;
        v(pcs(i), :) = vols{i+1}(pcs(i), :);
        vols{i+1} = v;
    end
    
    % add
    vol = vols{1};
    for v = 2:numel(vols)
        vol = vol + vols{v};
    end

    % multiply
    if numel(pcs) > 1
        walkImages = tprod(coeff, [1 -2], vol, [-2, 2:ndims(vol)]);
    else
        walkImages = coeff * vol;
    end
end
