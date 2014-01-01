function croppedVol = cropVolume(vol, rangeStart, rangeEnd)
%
%
% TODO: reconcile with actionSubArray and those functions

    nDims = ndims(vol);
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
        
