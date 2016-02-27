function mi = argmax(varargin)
% indices (argument) that maximizes the array.
% idx = argmax(...) is the same as [~, idx] = max(...), but is more useful when passing function
% handles

    [~, mi] = max(varargin{:});
end