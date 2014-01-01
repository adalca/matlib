function fim = imfilterSep(im, varargin)
% IMFILTERSEP filter an image with separable filters
%   fim = imfilterSep(im, filt1, ...) uses convn to filter the image im
%   with filters filt1, ..., using one filter in each dimension (thus the
%   number of dimensions in image must match the number of filters. 
%
%   fim = imfilterSep(im, filt) uses the filter filt in each dimension of
%   im.
%
%   Contact: Adrian Dalca, adalca.mit.edu

    imDims = ndims(im);
    
    % if only one separable filter provided, assume it is to be used in
    % each dimension.
    onesVec = ones(1, ndims(im));
    filters = cell(1, imDims);
    if nargin == 2 && imDims > 1
        assert(isvector(varargin{1}), 'second input must be a vector');
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

