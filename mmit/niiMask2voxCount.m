function nVoxels = niiMask2voxCount(nii)
    nVoxels = sum(nii.img(:) > 0);
end

    