function vols2niiFiles(vols, niifileTemplate)

    if isnumeric(vols)
        vols = {vols};
    end
    
    for i = 1:numel(vols);
        file = sprintf(niifileTemplate, i);
        
        vol = vols{i};
        nii = make_nii(vol);
        if ndims(vols) == 5
            nii.hdr.dime.intent_code = 1007;
        end
        
        saveNii(nii, file);
    end
    