function view2D(images, varargin)

    [images, nRows, nCols, inputs] = parseinputs(images, varargin{:});

    figuresc()
    for i = 1:numel(images)
        subplot(nRows, nCols, i);
        imagesc(images{i});
        caxis(inputs.caxis);
        title(inputs.titles{i})
        axis off;
        axis equal;
    end

end


function [images, nRows, nCols, inputs] = parseinputs(images, varargin)

    if isnumeric(images)
        images = {images};
    end

    p = inputParser();
    p.addRequired('images', @(x) iscell(x));
    p.addParameter('subgrid', -1, @isnumeric)
    p.addParameter('caxis', [0, 1]);
    p.addParameter('titles', repmat({''}, [1, numel(images)]), @iscell);
    p.parse(images, varargin{:});
    
    if isscalar(p.Results.subgrid) && p.Results.subgrid == -1
        [nRows, nCols] = subgrid(numel(images));
    else
        nRows = p.Results.subgrid(1);
        nCols = p.Results.subgrid(2);
    end
    
    inputs = p.Results;
end

function [hei, len] = subgrid(N)

    screensize = get(0, 'Screensize');
    W = screensize(3);
    H = screensize(4);

    hei = ceil(sqrt(N*H/W));
    len = ceil(N/hei);
end
