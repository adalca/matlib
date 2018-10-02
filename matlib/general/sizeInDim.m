function sizeFinal = sizeInDim(vol, dim)
% size of volume in a space of dimension dim (where dim >= ndims(vol)). So if the volume is less
% dimensions that dim, the size will be appended with ones.
%
% Example:
%   r = rand(5, 5);
%   sizeInDim(r, 4)
%   ans =
%          5     5     1     1
%
% Contact: http://adalca.mit.edu

    assert(dim >= ndims(vol));

    sizeFinal = ones(1, dim);
    sizeFinal(1:ndims(vol)) = size(vol);
