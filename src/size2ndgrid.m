function x = size2ndgrid(volSize)
%
%
% See Also: getNdRange

    x = cell(1, numel(volSize));
    range = getNdRange(volSize);
    [x{:}] = ndgrid(range{:}); 
    