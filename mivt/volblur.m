function [filtVol, filt]  = volblur(vol, sigma, varargin)
% VOLBLUR blur the given volume with separable gaussian filter
%   filtVol = volblur(vol, sigma) blurs the volume with a gaussian filter with a given standard
%   deviation sigma. sigma can be a scalar or a [1, ndims(vol)] vector.
%
%   filtVol = volblur(vol, sigma, window) specifies the total filter window size. window can be a
%   scalar, or a vector of size [1, ndims(vol)]. Note that window specifies the total window size of
%   the filter, not just half of it. The default is ceil(3*sigma)*2 + 1;
%   
%   'voxDims' - the dimensions of the voxels in mm, again a scalar or [1, ndims(vol)]. default: 1
%   'padType' - 'nn' for nearest neighbour padding, any other string for no padding. default: nn
%
%   TODO: could just allow voxDims and padType as normal inputs, not param/value.?
%
%   See Also: imBlurSep, imfilterSep
%
% Contact: adalca@mit.edu

    % input parsing
    inputs = parseInputs(vol, sigma, varargin{:}); 
    
    % create filters
    filt = cell(1, ndims(vol));
    onesVec = ones(1, ndims(vol));
    for i = 1:ndims(vol)
        filter = gaussianfilter([1, inputs.window(i)], inputs.sigma(i));
        % filterchk = fspecial('gaussian', [1, window(i)], sigma(i) ./ voxDims(i));
        % assert(all(filter == filterchk));        
        reshapeVec = onesVec;
        reshapeVec(i) = inputs.window(i);
        filt{i} = reshape(filter, reshapeVec);
    end

    % filter volume.
    switch inputs.padType
        case 'nn' 
            % if using nearest neighbour padding
            % pad via replicates and crop back after doing the filtering.
            inputVol = padarray(vol, (inputs.window - 1)/2, 'replicate', 'both');
            filtVol = volfilt(inputVol, filt{:}, 'valid');
                
        otherwise
            filtVol = volfilt(vol, filt{:});
    end
    
    assert(all(size(filtVol) == size(vol)));
end

function h = gaussianfilter(window, sigma)
% fast implementation of gaussian filter
% TODO: this only works with window being of size 2!
% TODO: check: this works in 3D?

    siz = (window-1)/2;
    std = sigma;

    [x,y] = meshgrid(-siz(2):siz(2),-siz(1):siz(1));
    arg = -(x.*x + y.*y)/(2*std*std);

    h     = exp(arg);
    h(h<eps*max(h(:))) = 0;

    sumh = sum(h(:));
    if sumh ~= 0,
        h  = h/sumh;
    end;
end

function inputs = parseInputs(vol, sigma, varargin) 
    
    narginchk(2, inf);

    % if numel(varargin) is odd, must have passed in window first.
    if numel(varargin) > 0 && mod(numel(varargin), 2) == 1 
        window = varargin{1};
        varargin = varargin(2:end);
        assert(all(mod(window, 2) == 1));
    end
    
    p = inputParser();
    p.addParameter('voxDims', 1, @isnumeric);
    p.addParameter('padType', 'nn', @ischar);
    p.parse(varargin{:});
    inputs = p.Results;
    
    % change sigma from scalar to vector
    % we need to do this before processing window since window is affected by sigma
    inputs.sigma = sigma;
    if isscalar(sigma)
        inputs.sigma = ones(1, ndims(vol)) * sigma ./ inputs.voxDims;
    end    
    
    % process window
    if ~exist('window', 'var')
        window = ceil(inputs.sigma * 3) * 2 + 1;
    end
    % change window from scalar to vector
    if isscalar(window) 
        window = ones(1, ndims(vol)) * window;
    end
    inputs.window = window;
end
