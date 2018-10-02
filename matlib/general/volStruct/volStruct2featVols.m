function vols = volStruct2featVols(volStruct)
% transform volStruct into a cell of feature-volumes 
% (i.e. 1 volume for each feature).

    nDims = numel(volStruct.volSize);
    targetVol = volStruct2vol(volStruct);
    vols = num2cell(targetVol, 1:nDims);
    