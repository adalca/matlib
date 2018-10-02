function newNii = makeNiiLike(vol, oldNii)
% newNii = makeNiiLike(vol, oldNii)
% Returns a new nifti object that copies datatype and pixdim over from
% oldNii
oldClass = class(oldNii.img);
%newNii = make_nii(cast(vol,oldClass));
newNii = oldNii;		% new line
newNii.img = vol;		% new line
newNii.hdr.dime.dim(2:4) = size(vol); 	% new line
newNii.hdr.dime.pixdim(2:4) = oldNii.hdr.dime.pixdim(2:4);
