function viewNii(nii)
    
    if ischar(nii)
        nii = loadNii(nii);
    else
        assert(isstruct(nii));
    end
    
    if exist('view3D', 'file') == 2
        view3D(nii.img);
    else
        view_nii(nii);
    end
    
