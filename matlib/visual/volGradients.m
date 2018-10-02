function gradients = volGradients(vol, window, sigma, voxDims, outputType)
% VOLGRADIENTS compute volume gradients
%   gradients = volGradients(vol, window, sigma, voxDims) compute volume gradients of vol using DOG
%   filters and convolutions. window and sigma control the gaussian filter. voxDims are the voxel
%   dimensions.
%       vol the volume (nDims)
%       window should be (nDims x 1)
%       sigma is a scalar in mm
%       voxDims the dimensions of the voxels in mm (nDims x 1)
%
%   gradients = volGradients(vol, window, sigma, voxDims, outputType) specifies an outputt type:
%   'cell' or 'matrix'. If matrix, it will be numel(Vol) x nDims
%
% TODO: sometimes 0 gradients don't end up being 0. Perhaps it has
% to to with the parameters used in some specific cases. unclear. Currently, to fix, we nul any
% gradient under 1e-7

    GRAD_LOW_THR = 1e-7;

    if numel(unique(voxDims)) ~= 1        
        warning('Voxel Dimensions are not isotropic, gradient of volume is tricky');
    end
    
    if ~exist('outputType', 'var')
        outputType = 'cell';
    end
    
    nDims = ndims(vol);

    onesVec = ones(1, nDims);
    gradients = cell(1, nDims);
    
    for i = 1:nDims
        % get a DOG filter.
        filter = fspecial('gaussian', [1, window(i)+2], sigma ./ voxDims(i));
        filter = conv(filter, [-1, 0, 1], 'same');
        filter = filter(2:end-1);
        
        % set the filter in the right direction
        reshapeVec = onesVec;
        reshapeVec(i) = window(i);
        filt = reshape(filter, reshapeVec);
        
        % convolve
        gradients{i} = convn(vol, filt, 'same');
        
        gradients{i}(abs(gradients{i}) < GRAD_LOW_THR) = 0;
    end
    
    % if the output type is a matrix, change the format of gradients
    if strcmp(outputType, 'matrix')
        gradMatrix = zeros(numel(vol), ndims(vol));
        for i = 1:ndims(vol)
            gradMatrix(:, i) = gradients{i}(:);
        end
        gradients = gradMatrix;
    end
end
