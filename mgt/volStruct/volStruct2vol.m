function vol = volStruct2vol(volStruct)
% return a volStruct to a [volSize nFeatures] volume. 
    
    nFeatures = size(volStruct.features, 2);
    vol = reshape(volStruct.features, [volStruct.volSize, nFeatures]);
end
