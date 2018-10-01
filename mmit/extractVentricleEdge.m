function [ventricleEdge, ventricleMask] = extractVentricleEdge(labelFile, ventricleLabels, edgeDst)
% extractVentricleEdge extract the a map of edge of the ventricles given labels
%
%   inputs:
%       labelFile - label nifti file, or nifti structure 
%       ventricleLabels - a vector of labels assigned to ventricles (usually 1
%           or 2 numbers, e.g. [43, 4] in buckner labeling).
%       edgeDst - distance from edges to include. For example, edgeDst = 1
%           would return a binary image with voxels true 1 voxel away from
%           the edges (on either side of the edge).
%
%   outputs:
%       ventricleMask - binanry mask, the size of the label volume,
%           indicating ventricles.
%       ventricleEdge - binary mask with the ventricle edges.
%
%   Author: adalca @ mit

    if ischar(labelFile)
        labNii = loadNii(labelFile);
    else
        assert(isstruct(labelFile));
        labNii = labelFile;
    end

    
    ventricleMask = false(size(labNii.img));
    
    for l = 1:numel(ventricleLabels)
        ventricleMask = ventricleMask | labNii.img == ventricleLabels(l);
    end

    % get edges per slice!
    ventricleEdge = false(size(labNii.img));
    for i = 1:size(ventricleMask, 3)
        bwVentricleDist = bwdist(ventricleMask(:,:,i)) + bwdist(~ventricleMask(:,:,i));
        ventricleEdge(:,:,i) = abs(bwVentricleDist) <= edgeDst;
    end
