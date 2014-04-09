function [croppedVol, cropMask, cropArray, bBox] = boundingBox(vol)
%   [croppedVol, cropMask, cropArray, bBox] = boundingBox(vol) compute the bounding box of the 
%       given label map
%
%       croppedVol image cropped by the bounding box.
%       cropMask bounding box mask
%       cropArray is a cell array of size nDims x 1, each entry being the crop range in that
%           dimension.
%       bBox as returned from regionprops
%
%   Contact: adalca@mit.edu

    nDims = ndims(vol);
    
    % prepare structure for regionprops to get the boundingBox
    bwstruct.Connectivity = 3^nDims - 1;
    bwstruct.ImageSize = size(vol);
    bwstruct.NumObjects = 1;
    bwstruct.PixelIdxList = {find(vol > 0)};
    
    % use regionprops to get the boundingBox
    stats = regionprops(bwstruct, 'BoundingBox');
    bBox = stats.BoundingBox;
    clear stats;
    
    % switch x and y values - here matlab puts second dimension first in the style of image
    % treatments, where it puts 'x', which is the second dimension, first.
    [bBox(1), bBox(2)] = switchValues(bBox(1), bBox(2));
    [bBox(nDims + 1), bBox(nDims + 2)] = switchValues(bBox(nDims + 1), bBox(nDims + 2));

    % crop the image  
    rangeStart = floor(bBox(1:nDims));
    rangeWidth = ceil(bBox(nDims+1:end));
    [croppedVol, cropArray] = cropVolume(vol, rangeStart, rangeStart + rangeWidth);

    % get crop mask
    v = false(size(vol));
    v(cropArray{:}) = true;
    cropMask = v;
