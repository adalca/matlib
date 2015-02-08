function walkImages = explorepc(L, scores, pcs, STDs, nStops)
% EXPLOREPC explore principal components
%   walkImages = explorepc(L, scores, pcs). Explore principal components from pca space L by
%   computing several points in the original space along the direction of the principal components
%   given in pcs. L is PCA space loading images, M x N ('coeff' returned from MATLAB's pca()). 
%   scores is the N x nExperiments scores of this experiment in PCA space. pcs are the indexes of
%   the principal components (e.g. [1,2,3] for the first principal components).
%
%   walkImages = explorepc(L, score, pcs, STDs) - control the number of standard deviations to go
%   along the direction of the pcs. 
%
%   walkImages = explorepc(L, score, pcs, STDs, nStops) - also control the number of data points
%   to interpolate along each directions. 
%
%   If more than one pc is requested, computation is fairly heavy and uses tprod(.) function (via
%   FileExchange). 
%       http://www.mathworks.com/matlabcentral/fileexchange/
%           /16275-tprod-arbitary-tensor-products-between-n-d-arrays/content/tprod.m
%
%   See Also: tprod
%
% Contact: {adalca,rameshvs}@mit.edu

    narginchk(3, 5);
    nargin
    if nargin == 3
        STDs = 3;
    end
    
    if nargin <= 4
        nStops = 21;
    end

    % get centroid of projection and variance along projection
    centroid = mean(scores, 2);
    stdtroid = std(scores, [], 2);

    % linspace for each dimension score between -STDs and STDs stdev's
    l = cell(numel(pcs), 1);
    for i = 1:numel(pcs);
        pc = pcs(i);
        l{i} = linspace(-STDs*stdtroid(pc),+STDs*stdtroid(pc), nStops);
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
        walkImages = tprod(L, [1 -2], vol, [-2, 2:ndims(vol)]);
    else
        walkImages = L * vol;
    end
end
