function [grmag, grdir, gdr, vol] = sliceGradients(niiFile)
% return the gradients per slice of the given nifti. Assumes slices are
% taken in the first 2 direction (i.e. slice 1 is (:,:,1);
%   niiFile is the file or nifti structure of interest.
%   returns:
%       grmag - magnitude at each voxel
%       grdir - 2d direction (angle) at each voxel, in radiants (pi), from x line
%       gdr - the reverse direction angle (from -x line)
%
%   See Also: imgradient
%   
%   Project: Analysis of clinical datasets
%   Authors: Adrian Dalca, Ramesh Sridharan
%   Contact: {adalca,rameshvs}@csail.mit.edu

    % get nifti structure
    if ischar(niiFile)
        nii = loadNii(niiFile);
    else
        assert(isstruct(niiFile));
        nii = niiFile;
    end
    
    % volume
    vol = double(nii.img);

    % get magnitude and direction per slices
    grmag = zeros(size(vol));
    grdir = zeros(size(vol));
    for i = 1:size(vol, 3)
        [grmag(:,:,i), grdir(:,:,i)] = imgradient(vol(:,:,i));
    end
    
    % set the direction in pi-space, and get the reverse angle (angle from -x line)
    grdir = grdir / 180*pi;
    gdr = sign(grdir) .* (pi - grdir);
    