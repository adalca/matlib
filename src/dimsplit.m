function varargout = dimsplit(dim, vol, opt)
% DIMSPLIT inverse of CAT
%
%   vc = dimsplit(dim, vol) split volume vol along dimension dim, retuning a cell vc which contains
%   all of the appropriate subvolumes such that vol = cat(dim, vc{:});
%
%   [a, b, c, ...] = dimsplit(dim, vol, 'sep') allows for separate outputs [a, b, c, ...] where each
%   output is a separate subvolume, such that vol = cat(dim, a, b, c, ...).
%
% Example:
%   r = rand(4, 4, 3);
%   [a, b, c] = dimsplit(3, r, 'sep')
%   results in a, b, and c each being 4x4 random matrices, the three channels of r.
%
% Contact: adalca@mit

    narginchk(2, 3);
    assert(isscalar(dim), 'only one dimension is supported. usage: dimsplit(dim, vol)');
    
    if nargin == 2
        opt = 'cell';
    end
    assert(ismember(opt, {'sep', 'cell'}), 'dimsplit: third argument must be ''sep'' or ''cell''');
    
    % prepare mat2cell breakup structure
    r = cell(1, ndims(vol));
    for i = 1:ndims(vol)
        if i == dim
            r{i} = ones(1, size(vol, i));
        else
            r{i} = size(vol, i);
        end
    end
    
    % split up
    b = mat2cell(vol, r{:});

    % prepare appripriate output
    if strcmp(opt, 'sep')
        varargout = b;
    else
        varargout{1} = b;
    end
