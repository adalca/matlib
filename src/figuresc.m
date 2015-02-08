function h = figuresc(scx, scy, varargin)
    
    if nargin == 0
        scx = 1;
        scy = 1;
    end
    
    if nargin == 1
        scy = 1;
    end
    
    h = figure('units', 'normalized', 'outerposition', [0 1-scy scx scy]);
    
