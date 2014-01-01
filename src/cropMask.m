function [cMask, cStart, cEnd] = cropMask(largeSize, smallSize, center)
% CROPMASK small binary mask centered in large image. 
%   [cMask, cStart, cEnd] = cropMask(largeSize, smallSize) returns a binary mask of the
%   size given by largeSize, with true box in the center and false otherwise - essentially a
%   crop mask. The box is of size smallSize. Returns cMask, which is of size largeSize, and
%   cStart and cEnd which are vectors of the same length as the largeSize vector. input vectors
%   should be of the same length N, but N can be anything >= 2.
%       
%   [cMask, cStart, cEnd] = cropMask(largeSize, smallSize, center) centers the true box at
%   location set by center. All three variables should have the same input size.
%
%   Example: [cMask, cStart, cEnd] = cropMask([11, 11], [5, 5]); 
%       
%   See Also: setSubvolume, subRange
%
%   Author: Adrian Dalca. http://www.mit.edu/~adalca


    % check dimensions assumption. 
    assert(all(largeSize >= smallSize), ...
        sprintf('largeSize (%ix%ix%i) should be larger than smallSize (%ix%ix%i)', ...
        largeSize, smallSize));

    % prepare a center
    if ~exist('center', 'var');
        center = round(largeSize/2);
    end
    
    % cMask - mask of C in the latent space
    [cMask, cStart, cEnd] = setSubvolume(false(largeSize), true(smallSize), center);
end
