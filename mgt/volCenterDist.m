function dst = volCenterDist(volSize)
% VOLCENTERDIST distance from the center of the volume at every voxel
%   dst = volCenterDist(volSize) distance from the center of the volume at every voxel. dst is
%   a volume of size volSize, (any dimension).
%
% Example for 2D:
%   imagesc(volCenterDist([128, 192]));
%
% Contact: adalca@csail.mit.edu

    center = (volSize + 1)/2;
    nDims = numel(volSize);
    
    % compute the ndgrid
    x = size2ndgrid(volSize);

    % compute the distances from the patch center
    dst = 0;
    for i = 1:nDims
        dst = dst + (x{i} - center(i)).^2;
    end
    dst = sqrt(dst);

end
