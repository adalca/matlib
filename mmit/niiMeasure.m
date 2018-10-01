function meas = niiMeasure(measure, varargin)
% NIIMEASURE apply a measure (function) to each nii
%	meas = niiMeasure(measFunc, nii1, ...) apply the function measFunc to 
%	all volumes in the given niftis (that is, measFunc takes in several volumes)
%
% See ALso: labelwiseMeasure, labelwiseNiiMeasure

    niis = varargin;
    
    vols = cell(numel(niis));
    for i = 1:numel(niis)
        nii = loadNii(niis{i});
        vols{i} = nii.img;
    end
    
    meas = measure(vols{:});
    