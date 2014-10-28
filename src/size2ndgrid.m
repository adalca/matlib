function x = size2ndgrid(volSize)
% note: actually returns a cell array, not just first element, like ndgrid() would.
%
% See Also: getNdRange

    x = cell(1, numel(volSize));
    range = getNdRange(volSize);
    [x{:}] = ndgrid(range{:}); 
    
