function [rangeStart, rangeEnd] = subRange(smallSize, center)
% obtain the range of a subvolume with the given center.
%   [rangeStart, rangeEnd] = subRange(smallSize, center) determines the range of the subvolume
%       whose size is given in smallSize centered in a larger space.
%
%   Example: To determine the range of a subvolume of size [5, 5] and centered at [101, 101] in
%   a larger space:
%       [rangeStart, rangeEnd] = subRange([5, 5], [101, 101]);
%   the rangeStart and rangeEnd are then [99, 99] and [103, 103]
%       
%   See Also: setSubvolume, cropMask
%
%   Author: Adrian Dalca. http://www.mit.edu/~adalca


    rangeStart = round(center - (smallSize-1)/2);
    rangeEnd = rangeStart + smallSize - 1;
end