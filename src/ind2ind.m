function dstInd = ind2ind(srcVolSize, dstVolSize, srcInd)
% IND2IND linear index to linear index in another matrix
%   dstInd = ind2ind(srcVolSize, dstVolSize, srcInd) given a linear index srcInd, which indexes 
%   into a volumes of size srcVolSize, get the respective linear index, for those entries, into a
%   volumes of size dstVolSize. 
%
% Example:
%     % entry (2, 3) in a [10, 10] matrix has linear index 22:
%     srcInd = sub2ind([10, 10], 2, 3)
%     srcInd =
%         22
%
%     % what is the linear index for the same entry, in a [11, 11] matrix?
%     ind2ind([10, 10], [11, 11], srcInd)
%     ans =
%         24
%
%     % let's check:
%     dstInd = sub2ind([11, 11], 2, 3)
%     dstInd =
%         24
%
%     % yey! when is this useful? It's particularly useful when you have a large vector of indexes
%     into the first matrix, which is a submatrix of a bigger matrix, and you want to have those
%     same entries into the larger matrix's linear index
%
% Contact: adalca@csail.mit.edu

    sub = cell(numel(srcVolSize), 1);
    [sub{:}] = ind2sub(srcVolSize, srcInd);
    dstInd = sub2ind(dstVolSize, sub{:});
