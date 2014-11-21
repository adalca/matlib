function s = structrich(varargin)

    args = cell(nargin*2, 1);
    for i = 1:nargin % can't use arrayfunc!
        args{i*2-1} = inputname(i);
        args{i*2} = varargin{i};
    end
    
    s = struct(args{:});
    