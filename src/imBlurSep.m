function filtVol = imBlurSep(vol, window, sigma, voxDims, padType)
% IMBLURSEP blur the given volume with separable gaussian filter
% 	vol the volume (nDims)
% 	window should be (nDims x 1)
% 	sigma is a scalar in mm
% 	voxDims the dimensions of the voxels in mm (nDims x 1)
%	padType - 'nn' for nearest neighbour padding, any other string for no padding
%
% Contact: adalca@mit.edu

    if isscalar(sigma)
        sigma = ones(1, ndims(vol)) * sigma;
    end

    if nargin == 4
        padType = 'zeros';
    end
    assert(all(mod(window, 2) == 1));
    
    volSize = size(vol);
    filt = cell(1, ndims(vol));
    onesVec = ones(1, ndims(vol));
    
    for i = 1:ndims(vol)
        filter = fspecial('gaussian', [1, window(i)], sigma(i) ./ voxDims(i));
        reshapeVec = onesVec;
        reshapeVec(i) = window(i);
        filt{i} = reshape(filter, reshapeVec);
    end

    switch padType
        
		case 'nn' 
            % if using nearest neighbour padding
            % pad via replicates and crop back after doing the filtering.
			inputVol = padarray(vol, (window - 1)/2, 'replicate', 'both');
			filtVol = imfilterSep(inputVol, filt{:}, 'valid');
				
		otherwise
			filtVol = imfilterSep(vol, filt{:});
    end

    assert(all(size(filtVol) == volSize));

end