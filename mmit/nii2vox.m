function voxels = nii2vox(volFile, maskFile)
% get voxels from nii, optionally only within mask if mask is a non-empty string
% voxels returned as a vector.
    
    % take in 1 or 2 values;
    narginchk(1, 2);

    nii = loadNii(volFile);
    voxels = double(nii.img(:));
    if numel(mask) == 1
        maskNii = loadNii(maskFile);
        voxels = voxels(maskNii.img);
    end
    
    assert(all(voxels >= 0), 'Volume has negative values: %s', volFile);
end