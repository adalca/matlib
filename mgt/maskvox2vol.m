function vol = maskvox2vol(data, mask, func)
% Create full volumes given a subsample of volume elements (voxels) and the mask of where they
% belong.
%   
% vol = maskvox2vol(data, mask) % given the voxel volumes in data and volume mask, returns a volume
% the same size and shape as "mask" but with the voxels in "data" filled in where mask is true.
%
%   mask is size of volume desired, with sum(mask(:)) = nElems
%   data is nElems x nVols
%   vol is size of : [size(mask) nSubj]
%
% vol = maskvox2vol(data, mask, func) allows for a functional initialization of vol (e.g. using
% nan() instead of zeros() ).
%
%   Example:
%     data = rand(10, 7);
%     r = randperm(25);
%     mask = [true(1, 10), false(1, 15)];
%     mask = mask(r);
%     mask = reshape(mask, [5, 5])
%     volWithZeros = maskvox2vol(data, mask);
%     volWithNans = maskvox2vol(data, mask, @nan);
%
% Author: adalca@mit.edu

    narginchk(2, 3);
    
    % if the data is a vector, and th enumber of elements is equal to the number of true voxels in
    % the mask, then assume the use meant a vertical vector
    if isrow(data) && numel(data) == sum(mask(:)),
        data = data';
    end
    
    % processing due to vector vs matrix treatment
    maskSize = ifelse(isvector(mask), numel(mask), size(mask));
    dataSize = size(data);
    volsize = [maskSize, dataSize(2:end)];
    rvolsize = [numel(mask), dataSize(2:end)];
    
    % prepare the functional initialization
    if nargin == 2 && islogical(data)
        func = @false;
    elseif nargin == 2
        func = @zeros;
    end
    
    % initialize output volume
    rvol = func(rvolsize);
        
    % reshape mask to mask(:), then do stuff simply, then reshape vol @ end.
    rmask = repmat(mask(:), [1, dataSize(2:end)]);
    rvol(rmask) = data;
    vol = reshape(rvol, volsize);
