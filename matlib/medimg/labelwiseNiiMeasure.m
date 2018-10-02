function distances = labelwiseNiiMeasure(niis, labelMasks, distMethod)
% LABELWISENIIMEASURE - compute a nifti volume measure (e.g. distance, similarity) for each label
%
% distances = labelwiseMeasure(niis, labelMasks, distMethod) compute a measure (e.g.
%   some distance or similarity) among the volumes in the 1xN cell array of nifti filenames niis. 
%   Volumes in niftis can be any dimension/size, but have to have same sizes as each-other. 
%   labelMasks is a 1xM cell array of logical label masks, where each mask is a volume of the same 
%   size as the input  volumes. distMethod is a method handle for a measure that takes N vectors as 
%	input.
%
% See Also: labelwiseMeasure
%
% Author: Adrian Dalca, http://adalca.mit.edu

    vols = cell(numel(niis));
    for i = 1:numel(niis)
        nii = loadNii(niis{i});
        vols{i} = nii.img;
    end
    
    distances = labelwiseMeasure(vols, labelMasks, distMethod);
    