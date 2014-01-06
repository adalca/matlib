function vec = shiftElements(vec, oldIdx, newIdx)
% shiftElements in vector v according to a index permutation
%   e.g. v = [1 2 3 4 5 6 7], oldIdx = 5, newIdx = 2
%   output: v = [1 5 2 3 4 6 7]
    
    len = length(vec);

    if newIdx > oldIdx
        idx = [1:(oldIdx-1), (oldIdx+1):newIdx, oldIdx, (newIdx + 1):len];
    elseif newIdx < oldIdx
        idx = [1:(newIdx-1), oldIdx, (newIdx):(oldIdx-1), (oldIdx+1):len];
    end
    
    assert(numel(idx) == numel(vec));
    
    vec = vec(idx);
    