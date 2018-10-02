function [grididx, gridsize, gridsub] = logical2grid(logicalvol)
% LOGICAL2GRID identify a grid in a logical volume
%   [grididx, gridsize, gridsubsep] = logical2grid(logicalvol) identify a grid in a logical volume.
%   returns grididx: the indexes of the grid in the volumes, gridsize: the size of the grid points,
%   and gridsub: the grid subscripts.
%
% Example:
%   v = logical([0 1 0 1; 0 0 0 0; 0 1 0 1])
%   [grididx, gridsize, gridsub] = logical2grid(v)
%   grididx is then [4, 10; 6 12];
%   gridsize is [2, 2];
%   gridsub is {[], []}
%
%
% Author: adalca@mit
    
    nDims = ndims(logicalvol);
    
    gridsubsep = cell(nDims, 1);
    gridsize = zeros(1, nDims);
    for d = 1:nDims
        fullrange = getNdRange(size(logicalvol));
        erased = zeros(size(logicalvol, d), 1);
        for i = 1:size(logicalvol, d)
            r = fullrange;
            r{d} = i;
            lVals = logicalvol(r{:});
            
            erased(i) = true;
            if ~any(lVals)
                erased(i) = false;
            end
        end
        
        gridsubsep{d} = find(erased)';
        gridsize(d) = numel(gridsubsep{d});
    end

    gridsub = cell(nDims, 1);
    [gridsub{:}] = ndgrid(gridsubsep{:});
    grididx = sub2ind(size(logicalvol), gridsub{:});
    
end
