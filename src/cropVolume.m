function [croppedVol, cropArray] = cropVolume(vol, rangeStart, rangeEnd)
%   [croppedVol, cropArray] = cropVolume(vol, rangeEnd) assumes rangeStart of [1, 1, 1...]
%   [croppedVol, cropArray] = cropVolume(vol, rangeStart, rangeEnd)
%
%
% crop volume vol according to range indications
% vol - volume, ndims
% rangeStart - nDims x 1
% rangeEnd - nDims x 1
%
% TODO: reconcile with actionSubArray and those functions, cropMask

    nDims = ndims(vol);
    
    if nargin == 2
        rangeEnd = rangeStart;
        rangeStart = ones(1, nDims);
    end
    
    assert(nDims == numel(rangeStart), ...
        'volume dimensions does not match start vector dimensions');
    assert(nDims == numel(rangeEnd), ...
        'volume dimensions does not match end vector dimensions');
    assert(all(rangeStart <= rangeEnd), ...
        'starting points must be smaller than ending points')
    
    % obtain the crop ranges, and put them in a cell
    cropArray = cell(1, numel(rangeStart));
    for i = 1:nDims
        cropArray{i} = rangeStart(i):rangeEnd(i);
    end
   
    % crop the array
    croppedVol = vol(cropArray{:});
        
