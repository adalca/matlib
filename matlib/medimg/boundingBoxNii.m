function [croppedVol, cropMask, cropArray, bBox] = boundingBoxNii(inFile, outFile, outMask)

    % transform volume
    nii = loadNii(inFile);
    [croppedVol, cropMask, cropArray, bBox] = boundingBox(nii.img);
    
    if nargin > 1 && ~isempty(outFile)
        % prep output
        niinew = make_nii(croppedVol);
        niinew.hdr.dime.pixdim(2:4) = nii.hdr.dime.pixdim(2:4);
        
        % save
        saveNii(niinew, outFile);
    end
    
    if nargin > 2 && ~isempty(outMask)
        % prep output
        niinew = make_nii(cropMask);
        niinew.hdr.dime.pixdim(2:4) = nii.hdr.dime.pixdim(2:4);
        
        % save
        saveNii(niinew, outMask);
    end
end
