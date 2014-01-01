function vol = imBlurSep(vol, window, sigma, voxDims)
% IMBLURSEP blur the given volume with separable gaussian filter
% 	vol the volume (nDims)
% 	window should be (nDims x 1)
% 	sigma is a scalar in mm
% 	voxDims the dimensions of the voxels in mm (nDims x 1)
%
% Contact: adalca@mit.edu

    filt = cell(1, ndims(vol));
    onesVec = ones(1, ndims(vol));
    
	if isscalar(sigma)
		sigma = ones(size(voxDims)) * sigma;
	end
	
    for i = 1:ndims(vol)
        filter = fspecial('gaussian', [1, window(i)], sigma(i) ./ voxDims(i));
        reshapeVec = onesVec;
        reshapeVec(i) = window(i);
        filt{i} = reshape(filter, reshapeVec);
    end

    vol = imfilterSep(vol, filt{:});
end