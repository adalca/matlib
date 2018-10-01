function isotropicIm = toIsotropic(anisotropicIm, originalVoxDims, isotropicVoxDim, interpMethod) 
% transform original resolution volume to isotropic volume 
%   isotropicIm = toIsotropic(anisotropicIm, originalVoxDims, isotropicVoxDims, interpMethod) 
%   transforms anisotropic volume to isotropic volume. Original volume of dimensions nDim is assumed to
%   have voxel sizes originalVoxDims (vector of len nDim). New isotropic volume will have
%   isotropicVoxDim (scalar). interpMethod is the interpolation method taken in by interpn
%   (e.g. 'nearest')
%
%   note: yuu can also give isotropicVoxDim a vector of len nDim and it will do the apropriate
%   interpolation (thus just changing voxel dimensions), but behavior has not been tested too
%   well.
%
%   Note: testing assumed isotropicVoxDim is smaller than or equal to originalVoxDims. 
%   e.g. if original is [0.9, 0.9, 1], isotropic should be no larger than 0.9. 
%
%   Author: Adrian Dalca, www.mit.edu/~adalca


    if ~exist('interpMethod', 'var')
        interpMethod = 'linear';
    end

    % setup the points of interpolation
    ratio = originalVoxDims ./ isotropicVoxDim;
    
    % get the interpolation points in each dimensions
    x = cell(1, ndims(anisotropicIm));
    for i = 1:ndims(anisotropicIm)
        % note: logic for 
        % >> nrPts =  round((size(anisotropicIm, i)-1) * ratio(i)) + 1; 
        % versus
        % >> nrPts = round(size(anisotropicIm, i) * ratio(i));
        % if say we want to interpolate 1 : 5 by with ratio of 2, we want 4*2 + 1 points, not 5 * 2;
        x{i} = linspace(1, size(anisotropicIm,i), 1+ round( (size( anisotropicIm, i)-1) * ratio(i)) );
    end
    
    % obtain a ndgrid (not meshgrid) for each dimension
    xi = cell(1, ndims(anisotropicIm));
    [xi{:}] = ndgrid(x{:});
    
    % interpolate
    isotropicIm = interpn(anisotropicIm, xi{:}, interpMethod);
end