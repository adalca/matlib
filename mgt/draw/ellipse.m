function ellipseMask = ellipse(volSize, center, ellipseSize, voxSize)
% within the size of the volume volSize , draw a centered ellipse. 
%   ellipseSize is the size of the ellipse in each dimension. 
%   if voxSize is provided, it is size of the voxel in each dimension in mm
%   , and ellipseSize is taken to mean mm.
% 
%   Example:
%       imshow(ellipse([101, 101], [51, 51], [20, 20], [1, 0.7]));

    narginchk(3, 4);
    if nargin == 3
        voxSize = ones(size(volSize));
    end


    nDims = numel(volSize);
    
    % compute the range of the dimensions
    x = cell(1, nDims);
    for i = 1:nDims
        x{i} = 1:volSize(i);
    end 
    
    % obtain a ndgrid (not meshgrid) for each dimension
    xi = cell(1, nDims);
    [xi{:}] = ndgrid(x{:});
    for i = 1:nDims
        xi{i} = xi{i}(:);
    end
    xiCell = cell2mat(xi);
    
    % get a ball
    centerDistDims = bsxfun(@minus, xiCell, center);
    
    % need to be careful about sizes now...
    centerDistDimsMM = bsxfun(@times, centerDistDims, voxSize);
    
    centerDistDimsMMNorm = bsxfun(@rdivide, centerDistDimsMM.^2, ellipseSize .^ 2);
    
    ellipseMask = sum(centerDistDimsMMNorm, 2) <= 1;
    ellipseMask = reshape(ellipseMask, volSize);




end
