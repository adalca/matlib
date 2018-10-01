function idx = sub2indfast(sz, varargin)
% computes faster 2d and 3d sub2ind by doing less error checking, which turns out to be costly in
% sub2ind.
    
    switch numel(sz)
        case 2
            idx = sub2ind2d(sz, varargin{:});
        case 3
            idx = sub2ind3d(sz, varargin{:});
        otherwise
            idx = sub2ind(sz, varargin{:});
    end
end

function idx = sub2ind3d(sz, i1, i2, i3)
    idx = i1 + (i2-1)*sz(1) + (i3-1)*sz(1)*sz(2);
end

function idx = sub2ind2d(sz, rows, cols)
    idx = rows + (cols-1)*sz(1);
end
