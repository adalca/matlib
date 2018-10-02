function nii = addNiis(inNiis, outNii)
% assumes all niftis have the same header

    vol = 0;
    for i = 1:numel(inNiis)
        nii = loadNii(inNiis{i});
        vol = vol + nii.img;
    end
    
    nii = makeNiiLike(vol, nii);
    
    if exist('outNii', 'var');
        saveNii(nii, outNii);
    end
end