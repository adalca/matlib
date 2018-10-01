function rvol = cleanedge(vol, edgecount, edgefill)
% CLEANEDGE clean the edge of a volume (n-dimensional) by edgecount on all sides using edgefill
%   rvol = CLEANEDGE(vol) clean the edge of a volume (n-dimensional) by 1 on all sides using 0s 
%   rvol = CLEANEDGE(vol, edgecount) specify edge size instead of 1s
%   rvol = CLEANEDGE(vol, edgecount, edgefill) specify the edge values instead of 0s
%
%   Author: Adrian V. Dalca, www.mit.edu/~adalca

    if nargin == 1
        edgecount = 1;
    end
    
    if nargin <= 2
        edgefill = 0;
    end
    
    r = num2cell(1:ndims(vol));
    range = cellfun(@(x) (1+edgecount):(size(vol, x)-edgecount), r, 'UniformOutput', false);
    rvol = ones(size(vol)) * edgefill;
    rvol(range{:}) = vol(range{:});
end
