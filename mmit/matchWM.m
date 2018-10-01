function [niiOut, niiSubj, wmSubjInt] = matchWM(subjFile, maskInSubjFile, wmiSrc, outFile)
% MATCHWM heuristic for matching white matter intensities
%   niiOut = matchWM(subjFile, maskInSubjFile, wmiSrc, outFile) matches the
%   white matter intensities in wmiSrc. 
%
%   Take a file (subjFile) that is in subject space, for which we have a registered rough brain mask
%   (maskInSubjFile). We take the intensities of the subjFile within the mask, and assume that the
%   highest mode is the white matter. We find this mode via mean shift (see meanshift()). We now use
%   the expected white matter intensity (wmiSrc) and divide it by the mode estimate. We then
%   multiply this factor with the voxels in the original subject file. The output is saved in
%   outFile.
%
%   Inputs:
%       subjFile - MI input file that's in subject space
%           e.g. 12866_t1_img_prep_bcorr.nii.gz
%       maskInSubjFile - atlas (buckner61) mask file in Subj space
%           e.g. buckner61_fixed_mask_from_seg_binary_IN_RIGID_MI32__10529_t1_img_prep_bcorr-.nii.gz
%       wmi - the intensity of WM cluster in atlas
%           e.g. 121.0683 (preferred) 
%       outFile [optional] - the outputfile 
%           e.g. 11805_t1_img_prep_bcorr_mult.nii.gz
%
%   Output
%       niiOut - the nifti structure of the output file
%
%   See Also: meanShift
%
% Project: Analysis of clinical datasets
% Authors: Adrian Dalca, Ramesh Sridharan
% Contact: {adalca,rameshvs}@csail.mit.edu


    % inputs should be between 3 and 4
    narginchk(3, 4);
    assert(isnumeric(wmiSrc));
    
    % get the mask. If it's a character, assume it's a file, if it's numeric, assume it's the mask
    % volume
    if ischar(maskInSubjFile)
        niiMask = loadNii(maskInSubjFile);
        mask = niiMask.img > 0;
    else
        assert(isnumeric(maskInSubjFile) || islogical(maskInSubjFile));
        mask = maskInSubjFile;
    end
    
    % get the voxels of the subject within the mask
    niiSubj = loadNii(subjFile);
    vox = niiSubj.img(mask);
    
    % force vox to be zero-based and positive float
    vox = double(vox);
    vox = vox - min(vox(:));
    
    % get wm value of subject via mean shift algorithm, assuming the mode is the wm.
    % TODO: maybe output a warning if more than 40% of replicates don't match this mean? implying
    %   there are other strong bumps
    assert(~all(vox(:) == 0), 'all voxels are 0');
    vox = vox(vox > 0);
    wmSubjInt = meanShift(vox(:));
    
    % update the input file's intensities.
    niiOut = niiSubj;
    niiOut.img = double(niiOut.img) * wmiSrc / wmSubjInt;
    
    % save output file
    if exist('outFile', 'var')
        saveNii(niiOut, outFile); %, tempdir, true
    end
end
