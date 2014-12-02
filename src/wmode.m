function m = wmode(x, w, hBins, dim)
% weighted mode. 
%   m = wmode(x, w), x is n-dim, w is a vector with the 'natural' count of
%   each possible label/value in x. The possible labels are inferred by
%   doing unique(x). The algorithm does a histogram count and divides by
%   the natural count, then takes the max, along appropriate directions.
%
%   m = wmode(x, w, labels) specify the possible labels. labels is a vector
%   the same size as w.
%
%   m = wmode(x, w, labels, dim) specify the dimention along which to do
%   these operations. default dim is 1.
%
% Example:
%   >> v = [1 1 1 1 1 2 2 2 3 3];
%   >> natCounts = [5, 2.9, 7];
%   >> posVals = 1:3;
%   >> m = wmode(v, natCounts, posVals, 2)
%   m = 
%       2
%   
%   >> natCounts = [5, 3.1, 7];
%   >> m = wmode(v, [5, 3.1, 7], [1, 2, 3], 2)
%   m = 
%       1
%
% Contact: adalca@csail

    % inpute checking
    narginchk(2, 4);
    if nargin <= 2
        hBins = unique(x);
    end
    if nargin <= 3
        dim = 1;
    end
    
    % reshape w for quick operation
    wNewSize = ones(1, ndims(x));
    wNewSize(dim) = numel(w);   
    w = reshape(w, wNewSize);
    
    % compute histogram
    h = histc(x, hBins, dim);
    
    % get the maximum weighted count
    [~, mi] = max(bsxfun(@rdivide, h, w), [], dim);
    
    % get the actual winning label/vote/intensity
    m = hBins(mi);
    
