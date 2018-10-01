function c = arrayfunc(varargin)
    c = arrayfun(varargin{:}, 'UniformOutput', false);
    