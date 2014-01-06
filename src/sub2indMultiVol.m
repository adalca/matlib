function ind = sub2indMultiVol(sizes, volNos, sub)
%   sizes is nVols x nDims
%   volNos is nVoxels x 1
%   sub is nVoxels x nDims
    

    % useful vars
    nVols = max(volNos(:));
    nVoxels = size(sub, 1);
    nDims = size(sub, 2);

    % initialize ind
    ind = zeros(nVoxels, 1);
    for r = 1:nVols
        
        % get mask of whis vol
        mask = volNos == r;
        
        % compute the ind for these entries
        allRefLocCell = mat2cell(sub(mask, :), sum(mask), ones(1, nDims));
        ind(mask) = sub2ind(sizes(r, :), allRefLocCell{:}); 
    end
    