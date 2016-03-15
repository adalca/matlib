function view2D(images, varargin)
% Visualize multiple 2D images in subplots
%   view2D(images) visualize multiple images into subplots. If images is an image, this is roughly
%   equivalent to imagesc(images). However, th emore interesting case is when images is a cell of
%   images. By default, view2D computes and uses an appropriate subplot grid (according to your
%   sceen dimensions, as determined by get(0, 'Screensize') ). 
%
%   view2D(images, param, value, ...) allows for the following param/value pairs:
%       'subgrid': vector with two elements specifying the subgrid dimensions (e.g. [2, 3]). By
%       default, this is determined based on your current screensize.
%       'caxis': the color axis.
%       'titles': a cell array with as many elements as images, determining the titles of each
%       image.
%
% See/Merge with subplotImages in mivt
%
% Contact: adalca.mit.edu

    % parse inputs
    [images, nRows, nCols, inputs] = parseinputs(images, varargin{:});

    % open figure
    if isscalar(inputs.figureHandle) && inputs.figureHandle == -1
        figuresc();
    else
        figure(inputs.figureHandle);
    end
    for i = 1:numel(images)
        
        % determine appropriate subplot
        subplot(nRows, nCols, i);
        
        % show image
        imagesc(images{i});
        
        % some cleaning for images.
        axis off;
        axis equal;
        
        % fix color range
        if numel(inputs.caxis) == 2
            caxis(inputs.caxis);
        end
        
        % display title.
        title(inputs.titles{i})
    end
    
    drawnow();

end

function [images, nRows, nCols, inputs] = parseinputs(images, varargin)

    if isnumeric(images)
        images = {images};
    end

    p = inputParser();
    p.addRequired('images', @(x) iscell(x));
    p.addParameter('subgrid', -1, @isnumeric)
    p.addParameter('caxis', -1);
    p.addParameter('titles', repmat({''}, [1, numel(images)]), @iscell);
    p.addParameter('figureHandle', -1);
    p.parse(images, varargin{:});
    
    if isscalar(p.Results.subgrid) && p.Results.subgrid == -1
        [nRows, nCols] = subgrid(numel(images));
    else
        nRows = p.Results.subgrid(1);
        nCols = p.Results.subgrid(2);
    end
    
    inputs = p.Results;
end
