function [grididx, gridsize, gridsubsep] = logical2grid(logicalvol)
    
    nDims = ndims(logicalvol);
    
    gridsubsep = cell(nDims, 1);
    gridsize = zeros(nDims, 1);
    for d = 1:nDims
        fullrange = getNdRange(size(logicalvol));
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
