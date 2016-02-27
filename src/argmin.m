function mi = argmin(varargin)
% indices (argument) that maximizes the array.
% idx = argmin(...) is the same as [~, idx] = min(...), but is more useful when passing function
% handles

    [~, mi] = min(varargin{:});
end