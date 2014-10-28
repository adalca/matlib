function vol = maskvox2vol(data, mask, func)
%   data is nElems x nSubj
%   mask is size of volume desired, with sum(mask(:)) = nElems
%
%   vol is size of : [size(mask) nSubj]
%
%   Example:
%     data = rand(10, 7);
%     r = randperm(25);
%     mask = [true(1, 10), false(1, 15)];
%     mask = mask(r);
%     mask = reshape(mask, [5, 5])
%     vol = maskvox2vol(data, mask);
%     volnan = maskvox2vol(data, mask, @nan);
%
% Author: adalca@mit.edu

    narginchk(2, 3);
    % processing due to vector vs matrix treatment
    maskSize = ifelse(isvector(mask), numel(mask), size(mask));
    dataSize = size(data);
    volsize = [maskSize, dataSize(2:end)];
    rvolsize = [numel(mask), dataSize(2:end)];
    
    
    % prepare the volume
    if nargin == 3
        rvol = func(rvolsize);
        
    else    
        if islogical(data)
            rvol = false(rvolsize);
%             func = @false;
        else
            rvol = zeros(rvolsize, class(data));
%             func = @zeros;
        end
    end
        
    % TODO: TRY SOLUTION VERY SIMPLE
    % reshape mask to mask(:), then do stuff simply, then reshape vol @ end.
    rmask = repmat(mask(:), [1, dataSize(2:end)]);
    rvol(rmask) = data;
    vol = reshape(rvol, volsize);

    
    %     
%     nDims = ifelse(isvector(mask), 1, ndims(mask));
%     [range, map] = getNdRange(usesize);
%     r = range(1:nDims);
%     map(r{:}, :)
%     
%     range(1) = [];
%     vol(mask, range{:}) = data;
%     
%     
%     
%     if size(data, 2) == 1
%         vol(mask) = data;
%         
%     else
%         
% 
%         % get mask
%         range = cell(nDims + 1, 1);
%         for d = 1:nDims
%             range{d} = 1:size(mask, d);
%         end
% 
%         % put in the volumes
%         for i = 1:size(data, 2)
%             tmpvol = maskvox2vol(data(:, i), mask, func);
% 
%             range{nDims + 1} = i;
%             vol(range{:}) = tmpvol;
%         end
%     end

