function nii = relabelNii(labelFile, newLabels)
% RELABELNII assign new labels to each label of a label file. 
%   nii = relabelNii(labelFile, newLabels) takes in a label (parcellation) file or nifti struct, and
%   re-assigns the existing labels (in increasting order) with the new given labels, and returns a
%   new label nii. 
%
% Example, 
%   /path/file.nii.gz -- a label nifti file with only labels 0 and 1 (i.e a mask)
%   nii = relabelNii('/path/file.nii.gz', [4, 8]); 
%   nii is now a nifti with labels 4 for what used to be 0, and 8 for what used to be 1. 
%
% Project: Analysis of clinical datasets
% Authors: Adrian Dalca, Ramesh Sridharan
% Contact: {adalca,rameshvs}@csail.mit.edu

    % get label masks from the label file or struct
    labelMasks = nii2labelMasks(labelFile);
    nLabels = numel(labelMasks);
    
    % check expected number of labels
    assert(nLabels > 1, 'Did not find any labels');
    assert(nLabels == numel(newLabels), 'Number of labels does not match assignment vector');
    
    % fill the image with a particular value for each label
    nii = make_nii(zeros(size(labelMasks{1})));
    for i = 1:nLabels
        nii.img(labelMasks{i}) = newLabels(i);
    end
end
