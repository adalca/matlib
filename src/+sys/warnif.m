function warnif(cond, varargin)

    if cond
        sys.warn(varargin{:});
    end
end