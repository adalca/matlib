function [boundingBox, varargout] = boundingBox(bwimage)
%   [boundingBox, boxRange, croppedBWImage] = boundingBox(bwimage)
%
%       boundingBox as returned from regionprops
%       boxRange is a cell array of size nDims x 1, each entry being the crop range in that
%           dimension.
%       croppedBWImage image cropped by the bounding box.

    nDims = ndims(bwimage);
    
    % use regionprops to get the boundingBox
    bwstruct.Connectivity = 3^nDims - 1;
    bwstruct.ImageSize = size(bwimage);
    bwstruct.NumObjects = 1;
    bwstruct.PixelIdxList = {find(bwimage > 0)};
    
    stats = regionprops(bwstruct, 'BoundingBox');
    boundingBox = stats.BoundingBox;
    
    % crop the image  
    if nargout > 1 
        rangeStart = floor(stats.BoundingBox(1:nDims));
        rangeWidth = ceil(stats.BoundingBox(nDims+1:end));
        [varargout{2}, varargout{1}] = cropVolume(bwimage, rangeStart, rangeStart + rangeWidth);
    end
    