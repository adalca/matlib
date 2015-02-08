function c = cellfunc(varargin)
    c = cellfun(varargin{:}, 'UniformOutput', false);
    