function vol = nii2vol(nii)

    if ischar(nii) && sys.isfile(nii)
        nii = loadNii(nii);
    elseif ischar(nii)
        error('%s is not a nifti file', nii);
    else
        assert(isstruct(nii));
    end
    
    vol = nii.img;
    