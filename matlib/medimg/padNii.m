function padNii(niiFileName, paddedNiiFileName, maskNiiFileName, padAmountMM, padType)
% PADNII pad a nifti and save the nifti and the relevant mask.
%   padNii(niiFileName, paddedNiiFileName, maskNiiFileName) pad nifti file
%   niiFileName and save the resulting nifti in paddedNiiFileName, and the relevant mask in 
%   maskNiiFileName. default padding is 30 mm.
%
%   padNii(niiFileName, paddedNiiFileName, maskNiiFileName, padAmountMM) allows one to
%   specify the padding amount in mm via padAmountMM.
%
%   padNii(niiFileName, paddedNiiFileName, maskNiiFileName, padAmountMM, padType)
%       padType can be 'both', 'pre', 'post'
%
%   Example arguments:
%   niiFileName = '10529_t1.nii.gz';
%   paddedNiiFileName = 'padded_10529_t1.nii.gz';
%   maskNiiFileName = 'padded_10529_t1_mask.nii.gz';
%   padAmountMM = 30; [default]
%
%   See Also: setSubvolume, makeNiiLike, saveNii, loadNii

% padding amount in mm
if ~exist('padAmountMM', 'var')
    padAmountMM = 30; 
elseif ischar(padAmountMM)
	padAmountMM = str2num(padAmountMM); 
end

if ~exist('padType', 'var')
    padType = 'both'; 
end


% load the nifti
nii = loadNii(niiFileName, tempdir, true);

% get the amount of padding in voxels
pixdim = nii.hdr.dime.pixdim(2:4);
padAmount = ceil(padAmountMM ./ pixdim);
dims = nii.hdr.dime.dim(2:4);
assert(all(size(padAmount) == size(dims)));

switch padType
    case 'both'
        newDims = dims + padAmount * 2;

        % extract the subvolume and mask
        vol = setSubvolume(zeros(newDims), nii.img);
        volMask = setSubvolume(zeros(newDims), ones(dims));
    case 'pre'
        newDims = dims + padAmount;
        vol = setSubvolume(zeros(newDims), nii.img, padAmount + 1, newDims);
        volMask = setSubvolume(zeros(newDims), ones(dims), padAmount + 1, newDims);

    case 'post'
        newDims = dims + padAmount;
        o = ones(1, numel(newDims));
        vol = setSubvolume(zeros(newDims), nii.img, o, dims);
        volMask = setSubvolume(zeros(newDims), ones(dims), o, dims);
        
    otherwise
        error('padNii: Unknown padType');
end

% create the niftis
newNii = makeNiiLike(vol, nii);
newNiiMask = makeNiiLike(volMask, nii);

% save nifties
saveNii(newNii, paddedNiiFileName, tempdir, true)
if ~isempty(maskNiiFileName)
    saveNii(newNiiMask, maskNiiFileName, tempdir, true)
end