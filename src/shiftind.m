function sind = shiftind(volSize, ind, shiftamt)
% SHIFTIND shift linear indexes in original space
%
% sind = shiftind(volSize, ind, shiftamt)
%
% example: we want to shift the linear indexes of 
%   {(1, 1), (1, 2), (2, 1)} to {(2, 2), (2, 3), (3, 1)}
%
%   sind = shiftind([3, 3], [1 2 4], [1, 1])
%   gives [5, 6, 8], as expected
%
% Contact: adalca at csail

    % input checking
    narginchk(3, 3);
    assert(numel(volSize) == numel(shiftamt));
    sz = size(ind);

    % get subscripts
    sub = ind2subvec(volSize, ind(:));
    
    % shift subscripts
    sub = bsxfun(@plus, sub, shiftamt(:)');
    
    % get shifted linear indexes
    sind = subvec2ind(volSize, sub);
    sind = reshape(sind, sz);
end
