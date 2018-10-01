function idx = varsub2ind(refSizes, pIdx, rIdx)
% variable-sized sub2ind. Only works in 2D and assumes that the columns have variable sizes.
%
% Example Structure:
%
%    *************
%    *  * ***** **
%    *  *  ** *  *
%    *  *  **    *
%    *  *  *     *
%    *     *
%
% indexing would be column-wise as usual, so given inputs:
%   pIdx = [1 2 4 6 1 1 ...]'
%   rIdx = [1 1 1 1 2 3 ...]'
% outputs:
%   idx = [1 2 4 6 7 8 ...]'
%
%
% Useful for patchlib in:
%   take the linear index in multiple volumes (of potentially different sizes) and return an index
%   into the vectorized super-volume
%

    idx = pIdx * 0;
    for i = 1:numel(refSizes)
        idx(rIdx == i) = pIdx(rIdx == i) + sum(refSizes(1:i-1));
    end 
    