function viewNiiVol(vol, dims)
% VIEWNIIVOL view a volume in a nifti viewer
% 	viewNiiVol(vol) view a volume vol using the view_nii scripts. 
%
% 	viewNiiVol(vol, dims) view the 
% 	dims (length nDims vec) is optional
% - if not provided, ones(1, ndims(vol)) is assumed.
%
%   Requires:
%   load_nii as part of NIFTI library by Jimmy Shen.
% 
%   Example:
%   nii = loadNii('niftyfile.nii.gz'); 
%
%   Contact: Adrian V. Dalca, http://adalca.mit.edu
%   Last Update: December, 2013.

    % if no voxel dimensions are provided, assume isotropic voxels of side 1
    if nargin == 1
        dims = ones(1, ndims(vol));
    else
        assert(numel(dims) == ndims(vol));
    end
    
    % prepare the nifti structure
    nii = make_nii(vol);
    nii.hdr.dime.pixdim(2:4) = dims;
    
    % view the nifti
    view_nii(nii);
    