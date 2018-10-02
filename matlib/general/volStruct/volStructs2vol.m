function vol = volStructs2vol(volStructs)
% return several volStructs to a cell array of [volSize nFeatures] volumes. 
%   volStructs can be an array of volStructs or a cell array of volStructs
    
    if isstruct(volStructs)
        volStructs = structArray2cell(volStructs);
    end

    nVols = numel(volStructs);
    vol = cell(nVols, 1);
    for i = 1:nVols
        vol{i} = volStruct2vol(volStructs{i});
    end
end