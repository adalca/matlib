function final = niiOverlapMap(brainNii, mapNii, factors, saveNiiFile)
% NIIOVERLAPMAP overlap a volume nifti with a probability/density map
%   nii = niiOverlapMap(brainNii, mapNii) overlap a volume nifti with a probability/density map
%   nii = niiOverlapMap(brainNii, mapNii, saveNiiFile) also saves the nifti
%
% Author: Adrian Dalca, www.mit.edu/~adalca


    narginchk(3, 4);

    % read bg img
    atlas = loadNii(brainNii);
    atlasVol = double(atlas.img);
    atlasVol = atlasVol - min(atlasVol(:));
    atlasVol = atlasVol ./ max(atlasVol(:));

    % read map
    map = loadNii(mapNii);
    mapVol = map.img;
    mapVol = mapVol - min(mapVol(:));
    mapVol = mapVol ./ max(mapVol(:));
           
    if isempty(factors)
        factors = [0.25, 0.75];
    end
    
    % compute the bg and foreground
    bgimg = repmat(atlasVol * factors(1), [1, 1, 1, 1, 3]);
    yellowimg = repmat(mapVol * factors(2), [1, 1, 1, 1, 3]);
    yellowimg(:,:,:,:,3) = 0;
    
    % finally, compute the sum
    final = make_nii(yellowimg + bgimg);
    final.hdr.dime.pixdim(2:4) = atlas.hdr.dime.pixdim(2:4);
    final.hdr.dime.intent_code = 1007;
    
    % save file
    if nargin == 4
        saveNii(final, saveNiiFile);
    end
	
	% one might display the final nifti as:
%         imshow(flipdim(permute(final.img(:,:,129, 1, :), [2, 1, 5, 3, 4]), 1));
%         imwrite(flipdim(permute(final.img(:,:,129, 1, :), [2, 1, 5, 3, 4]), 1), 'D:\output\agg-yellow_middle.jpg');
    