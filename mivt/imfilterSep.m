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

    warning('imfilterSep is being phased out. use volfilt');

    fim = volFilterSet(im, varargin{:});
end 

