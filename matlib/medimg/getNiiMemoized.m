function [loadedNiis, voxels] = getNiiMemoized(file, volName, loadedNiis, maskVolName)
% get voxels from nii, optionally only within mask if mask is a non-empty string
% loadedNiis is a struct with various volume names. if the given volume name is not loaded, load it
    
    volNii = [];
    
    getMask = exist('maskVolName', 'var') && numel(maskVolName) > 0;
    if getMask, maskNii = []; end
    
    % if there are some previous loaded niis, check if the volume or mask exist
    if numel(loadedNiis) > 0
        if ismember(volName, fieldnames(loadedNiis))
            volNii = loadedNiis.(volName);
        end
    
        if getMask && sum(strcmp(maskVolName, fieldnames(loadedNiis))) == 1
            maskNii = loadedNiis.(maskVolName);
        end
    end
    
    % if not previously loaded, load the volume nii
    if numel(volNii) == 0
        volNii = loadNii(file.(volName));
    end
    
    % if not previously loaded, load the mask nii
    if getMask && numel(maskNii) == 0
        maskNii = loadNii(file.(maskVolName));
    end
     
    % extract voxels
    voxels = double(volNii.img);
    if getMask
        voxels = voxels(maskNii.img);
    end
    assert(min(voxels(:)) >= 0, 'Volume has negative values: %s', file.(volName)); 
    
    % update the loaded niftis
    loadedNiis.(volName) = volNii;
    if getMask
        loadedNiis.(maskVolName) = maskNii;
    end
end
