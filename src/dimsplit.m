function varargout = dimsplit(dim, vol)
% DIMSPLIT inverse of CAT
%   [a, b, c, ...] = dimsplit(dim, vol) split volume vol along dimension dim
%   d = dimsplit(dim, vol) will give a cell d which contains all of the volumes {a, b, c, ...},
%   unless there is only a single volume (i.e. size(vol, dim) == 1), in which case it returns the
%   volume
%
% Example:
%   r = rand(4, 4, 3);
%   [a, b, c] = dimsplit(3, r)
%   results in a, b, and c each being 4x4 random matrices, the three channels of r.
%
% Contact: adalca@

    r = cell(1, ndims(vol));
    for i = 1:ndims(vol)
        if i == dim
            r{i} = ones(1, size(vol, i));
        else
            r{i} = size(vol, i);
        end
    end
    
    b = mat2cell(vol, r{:});
    
    if nargout == 1
        if size(vol, dim) > 1
            varargout{1} = b;
        else
            varargout{1} = b{1};
        end
    else
        varargout = cell(size(vol, dim), 1);
        [varargout{:}] = b{:};
    end
    