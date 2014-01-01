function vol = downsample(vol, filtertype, window, sigma, voxDims, downsampleScale, newSize)
% vol = downsample(vol, filtertype, window, sigma, voxDims, downsampleScale, newSize)
% vol 
%     the volume (nDims)
% filtertype 
%     the filter type call to fspecial, e.g. 'gaussian' or 'sobel'
%     can be 'none' to indicate no filtering
% window
%     should be (nDims x 1). defaults to [3,3,3]
% sigma 
%     scalar in mm (smoothing kernel)
% voxDims 
%     dimensions of the voxels in mm (nDims x 1)
% downsampleScale - scale to dowsample, either a scalar or (nDims x 1)
%     vector. numbers should be between 0 and 1 (e.g. 0.5 indicates
%     downsampling by a factor of 2).
% newsize - specify actual new volume size. downsampleScale must be []
%
%
% Use at own risk - code was c+p from other pieces of code...


origsize = size(vol);

if(~exist('window','var') || isempty(window))
    window = origsize - origsize + 3; % dirty way of getting ndims right
end

if numel(downsampleScale) ~= 0 
    newSize = round(origsize .* downsampleScale);
end

filt = cell(1, ndims(vol));
onesVec = ones(1, ndims(vol));
if ~strcmp(filtertype, 'none')
    for i = 1:ndims(vol)
        % get filter
        filter = fspecial(filtertype, [1, window(i)], sigma ./ voxDims(i));

        % set filter in the right dimension
        reshapeVec = onesVec;
        reshapeVec(i) = window(i);
        filt{i} = reshape(filter, reshapeVec);
    end

    vol = sepfilt(vol, filt{:});
end

%vol = imresize3d(vol, downsampleScale, [], 'linear', 'replicate');
vol = imresize3d(vol, [], newSize, 'linear', 'bound');
end




function fim = sepfilt(im, varargin)
% filter the image with separable filters.
%   fim = sepfilt(im, filt1, ...) uses convn to filter the image im
%   with filters filt1, ..., using one filter in each dimension (thus the
%   number of dimensions in image must match the number of filters. 
%
%   fim = imfilterSep(im, filt) uses the filter filt in each dimension of
%   im.
%
%   function adapted for stroke project
%
%   Author: Adrian V. Dalca, http://www.mit.edu/~adalca/

    imDims = ndims(im);
    
    % if only one separable filter provided, assume it is to be used in
    % each dimension.
    onesVec = ones(1, ndims(im));
    filters = cell(1, imDims);
    if nargin == 2 && imDims > 1
        for i = 1:ndims(im)
            reshapeVec = onesVec;
            reshapeVec(i) = numel(varargin{1});
            filters{i} = reshape(varargin{1}, reshapeVec);
        end     
        
    % otherwise assume we are provided with the right number of filters in
    % the right order. 
    else
        assert(numel(varargin) == imDims);
        filters = varargin;
    end

    
    
    % perform the filtering
    fim = im;
    for i = 1:imDims
        fim = convn(fim, filters{i}, 'same');
    end     
end 

