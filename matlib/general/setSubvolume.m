function [vol, rangeStart, rangeEnd] = setSubvolume(vol, subVol, varargin)
% SETSUBVOLUME replace a subvolume of the main volume.
%   [vol, rangeStart, rangeEnd] = setSubvolume(vol, subVol) set the central subvolume of vol 
%       by subVol. vol can be any dimensions, and subVol has to be of the same dimensions.
%       subVol must be smaller than or equal to vol.
%
%   [vol, rangeStart, rangeEnd] = setSubvolume(vol, subVol, center) allows the specification of
%       the subvolume center in the space of the main volume. Must have length(center) ==
%       ndims(vol). 
%       
%   [vol, rangeStart, rangeEnd] = setSubvolume(vol, subVol, rangeStart, rangeEnd) specifies the
%   exact start and end of the subVol in the main volume. Must have length(rangeStart) ==
%   ndims(vol), and the same with rangeEnd. 
%
%   Example: [vol, rangeStart, rangeEnd] = setSubvolume(rand(11,11), zeros(5, 5), [8, 8]);
%       
%	TODO: reconcile with actionSubArray
%
%   See Also: cropMask, subRange
%
%   Author: Adrian Dalca. http://www.mit.edu/~adalca




	% check dimension and size assumption. 
    assert(ndims(vol) >= ndims(subVol), ...
        sprintf('volume dimensions don''t agree: %i vs %i', ndims(vol), ndims(subVol)));
    
    sizeVol = size(vol);
    assert(all(sizeVol(1:ndims(subVol)) >= size(subVol)), ...
        sprintf('imLarge (%ix%ix%i) should be larger than imSmall (%ix%ix%i)', ...
        size(vol), size(subVol)));    

    % get size of subVol in the space of vol
    sizeSubVol = sizeInDim(subVol, ndims(vol));
    
    % parse the inputs and prepare range start and end
    switch nargin
        case 4
            rangeStart = varargin{1};
            rangeEnd = varargin{2};
           
        case 3 % assume varargin{1} is center
            [rangeStart, rangeEnd] = subRange(sizeSubVol, varargin{1});
            
        case 2 % assume no center given, take center of large volume
            [rangeStart, rangeEnd] = subRange(sizeSubVol, sizeVol/2);
            
        otherwise
            error('Number of arguments should be 2, 3 or 4. Given: %i', nargin);
    end

    
    
    % some more checks of expected behavior
    nDims = ndims(vol);
    assert(nDims == numel(rangeStart), ...
        'volume dimensions does not match start vector dimensions');
    assert(nDims == numel(rangeEnd), ...
        'volume dimensions does not match end vector dimensions');
    assert(all(rangeStart <= rangeEnd), ...
        'starting points must be smaller than ending points');
    
    
    
    % obtain the crop ranges, and put them in a cell
    cropArray = cell(1, numel(rangeStart));
    for i = 1:nDims
        cropArray{i} = rangeStart(i):rangeEnd(i);
    end
    
    % crop the array
    vol(cropArray{:}) = subVol;   
end




