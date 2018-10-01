function [labelMasks, selLabels] = nii2labelMasks(labelFile, selLabels)
% NII2LABELMASKS extract label masks from a label file
%   [labelMasks, selLabels] = nii2labelMasks(labelFile) load a nifti label file with N labels and
%   compute N logical masks (of the same size as the initial volume), one for each label, with true
%   where the label exists. selLabels is a vector of the found labels. 
%
%   [labelMasks, selLabels] = nii2labelMasks(labelNii) behaves the same, but accepts a nifti
%   structure as returned by loadNii.
%
%   [labelMasks, selLabels] = nii2labelMasks(..., selLabels) only computes and returns the 
%       masks (and labels) for the labels given in the 1xM vector selLabels;
%
%   See Also: loadNii
%   
%   Author: Adrian V. Dalca, adalca.mit.edu


    narginchk(1, 2);

    % load necessary label files and take out the volumes
    if ischar(labelFile)
        labelNii = loadNii(labelFile);
    else
        % assuming PARC_FILE is a nii struct
        assert(isstruct(labelFile), 'labelFile should be a string or a nifti struct');
        labelNii = labelFile;
    end
    labelImg = labelNii.img;
    
    % find the labels that exist
    if ~exist('selLabels', 'var')
        selLabels = unique(labelImg(:));
    end
    nLabels = numel(selLabels);
    
    % compute the labelMasks
    labelMasks = cell(1, nLabels);
    for i = 1:nLabels
        labelMasks{i} = labelImg(:) == selLabels(i);
    end
    