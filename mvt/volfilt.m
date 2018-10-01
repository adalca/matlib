function fim = volfilt(vol, varargin)
% VOLFILT filter an image with separable filters
%   fim = volfilt(vol, filt1, ...) uses convn to filter the image vol
%   with filters filt1, ..., using one filter in each dimension (thus the
%   number of dimensions in image must match the number of filters. 
%
%   fim = volfilt(vol, filt) uses the filter filt in each dimension of
%   vol.
%
%   fim = volfilt(vol, filt, ..., shape) allows for specifying a shape string 
%	as taken by convn's third parameter.
%
%   Author: Adrian V. Dalca, http://www.mit.edu/~adalca/

    imDims = ndims(vol);
    
    if ischar(varargin{end})
        shape = varargin{end};
        inputFilters = varargin(1:numel(varargin) - 1);
    else
        shape = 'same';
        inputFilters = varargin;
    end
        
    % if only one separable filter provided, assume it is to be used in
    % each dimension.
    onesVec = ones(1, ndims(vol));
    filters = cell(1, imDims);
    if numel(inputFilters) == 1 && imDims > 1
        assert(isvector(inputFilters{1}), 'second input must be a vector');
        for i = 1:ndims(vol)
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
    fim = vol;
    for i = 1:imDims
        fim = convn(fim, filters{i}, shape);
    end     
    
    % this is a lot faster than the following, because it's separable.
%     q = filters{1}; for i = 2:numel(filters), q = bsxfun(@times, q, filters{i}); end
%     fim2 = convn(vol, q, 'valid');
%     assert(all(isclose(fim(:), fim2(:))));
end 

