function isoNii = toIsotropic(nii, isoSize)
% isoNii = toIsotropic(nii)
%  Takes a nifti object with an anisotropic image, and returns
%  a nifti object with the same image resampled to (isoSize)mm isotropic.
% 
%  The output image is always of the same class (uint8, etc) as the input.
%
%  Uses header's pixdim to determine dimensions, but ignores all 
%  other header info

if(~exist('isoSize','var') || isempty(isoSize))
    isoSize = 1;
end

pixdims = nii.hdr.dime.pixdim(2:4);
isoImg = toIsotropic(double(nii.img), pixdims, isoSize*ones(1,3), 'cubic');

isoNii = makeNiiLike(isoImg, nii);
isoNii.hdr.dime.pixdim(2:4) = isoSize;

