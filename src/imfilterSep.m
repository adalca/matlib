function fim = imfilterSep(im, varargin)
% IMFILTERSEP filter an image with separable filters
%   fim = imfilterSep(im, filt1, ...) uses convn to filter the image im
%   with filters filt1, ..., using one filter in each dimension (thus the
%   number of dimensions in image must match the number of filters. 
%
%   fim = imfilterSep(im, filt) uses the filter filt in each dimension of
%   im.
%
%   fim = imfilterSep(im, filt, ..., shape) allows for specifying a shape string 
%	as taken by convn's third parameter.
%
%   Author: Adrian V. Dalca, http://www.mit.edu/~adalca/

    imDims = ndims(im);
    
    if ischar(varargin{end})
        shape = varargin{end};
        inputFilters = varargin(1:numel(varargin) - 1);
    else
        shape = 'same';
        inputFilters = varargin;
    end
        
    
    
    % if only one separable filter provided, assume it is to be used in
    % each dimension.
    onesVec = ones(1, ndims(im));
    filters = cell(1, imDims);
    if numel(inputFilters) == 1 && imDims > 1
        assert(isvector(inputFilters{1}), 'second input must be a vector');
        for i = 1:ndims(im)
            reshapeVec = onesVec;
            reshapeVec(i) = numel(inputFilters{1});
            filters{i} = reshape(inputFilters{1}, reshapeVec);
        end     
        
    % otherwise assume we are provided with the right number of filters in
    % the right order. 
    else
        assert(numel(inputFilters) == imDims);
        filters = inputFilters;
    end

    
    
    % perform the filtering
    fim = im;
    for i = 1:imDims
        fim = convn(fim, filters{i}, shape);
    end     
end 

