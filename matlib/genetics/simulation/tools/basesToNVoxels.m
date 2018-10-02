function nVoxels = basesToNVoxels(imgs)
% NOTE - when using actual imgs as opposed to nVoxels, the last element of
% nVoxels is kind of unuseful. % TODO - think of how to reconcile this.

    nVoxels = voxelType();
    fields = fieldnames(nVoxels);
    x = size(imgs, 1);
    y = size(imgs, 2);
    
    nImgs = zeros(numel(fields), 1);
    nCounts = zeros(numel(fields), 1);
    for i = 1:size(imgs, 3)
        im = imgs(:,:,i);
        m = max(im(:));
        n = sum(im(:) == m);
        
        nImgs(m) = nImgs(m) + 1;
        nCounts(m) = nCounts(m) + n;
    end
    nImgs(end) = x*y - sum(nCounts);
    
    
    for i = 1:numel(fields)              
        nVoxels.(fields{i}) = nImgs(i);
    end