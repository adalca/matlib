function vol = normalizeNii(inputModality, outputModality, normVal)

    % transform volume
    nii = loadNii(inputModality);
    vol = double(nii.img) ./ normVal;

    if max(vol(:)) > 1 || min(vol(:)) < 0
        warning('vol range was [%d, %d]', min(vol(:)), max(vol(:)));
        vol(vol > 1) = 1;
        vol(vol < 0) = 0;
    end

    niinew = make_nii(vol);
    niinew.hdr.dime.pixdim(2:4) = nii.hdr.dime.pixdim(2:4);
    saveNii(niinew, outputModality);
end
