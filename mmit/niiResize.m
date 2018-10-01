function hrnii = niiResize(niiInputFile, niiOutputFile, varargin)
% NIIRESIZE
%   hrnii = niiResize(niiInputFile, niiOutputFile)
%   hrnii = niiResize(niiInputFile, niiOutputFile, method)

    error('unfinished, look @ toIsotropic');

    % read low res input file
    nii = loadNii(niiInputFile);
    
    % get the pixdim, and the upsampling factor
    pixdim = nii.hdr.dime.pixdim(2:4);
    upsamplefactor = ceil(pixdim);

    % prepare the volume
    vol = double(nii.img);
    vol = vol - min(vol(:));
    
    % resample
    hrVol = volResize(vol); % unfinished.
    
	hrVol(hrVol < 0) = 0;
    
    % prepare the low res nifti
    lrpixdim = pixdim ./ upsamplefactor;
    hrnii = make_nii(hrVol);
    hrnii.hdr.dime.pixdim(2:4) = lrpixdim;
    
    % save the low res
    if exist('niiOutputFile', 'var')
        saveNii(hrnii, niiOutputFile);
    end
    