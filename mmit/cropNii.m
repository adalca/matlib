function nii = cropNii(nii, croprange, outNii)

    if ischar(nii)
        nii = loadNii(nii);
    end

    vol = nii.img(croprange);
    nii = makeNiiLike(vol, nii);
    
    saveNii(nii, outNii)