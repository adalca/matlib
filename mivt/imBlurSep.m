function [filtVol, filt]  = imBlurSep(vol, window, sigma, voxDims, padType)
% IMBLURSEP blur the given volume with separable gaussian filter
%     vol the volume (nDims)
%     window should be (nDims x 1)
%     sigma is a scalar in mm
%     voxDims [optional] the dimensions of the voxels in mm (nDims x 1)
%    padType [optional] - 'nn' for nearest neighbour padding, any other string for no padding.
%       default: nn
%
% Contact: adalca@mit.edu

    warning('imBlurSep is being phased out. use volblur()');

    % input parsing
    narginchk(3, 5);
    if isscalar(sigma)
        sigma = ones(1, ndims(vol)) * sigma;
    end

    if nargin <= 3
        voxDims = ones(size(window));
    end
    
    if nargin <= 4
        padType = 'nn';
    end
    assert(all(mod(window, 2) == 1));

    [filtVol, filt]  = volblur(vol, sigma, window, 'voxDims', voxDims, 'padType', padType);
end
