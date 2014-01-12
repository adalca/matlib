function vec = shiftElements(vec, oldIdx, newIdx)
% SHIFTELEMENTS shift elements in given vector
% vec = shiftElements(vec, oldIdx, newIdx) shift elements in vector vec according 
%   to a index permutation given by oldIdx (the index of the element to be moved)
%   and newIdx (the index where the element should be inserted). The other elements
%   will shift around to allow for this change
%
% Example: put the fifth element in the second position, move everything between 
%   second:fourth position to third:fifth.
%   v = [1 2 3 4 5 6 7], oldIdx = 5, newIdx = 2
%   v = shiftElements(v, oldIdx, newIdx)
%   output: v = [1 5 2 3 4 6 7]
%
% Contact: adalca.mit.edu
    
    % get length of vector
    len = length(vec);

    % compute the index array
    if newIdx > oldIdx
        idx = [1:(oldIdx-1), (oldIdx+1):newIdx, oldIdx, (newIdx + 1):len];
    elseif newIdx < oldIdx
        idx = [1:(newIdx-1), oldIdx, (newIdx):(oldIdx-1), (oldIdx+1):len];
    end
    
    % verify dimensions
    assert(numel(idx) == numel(vec));
    
    % make the modification
    vec = vec(idx);
    
