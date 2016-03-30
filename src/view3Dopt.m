function varargout = view3Dopt(varargin)
% VIEW3DOPT extends/wraps the view3D script with some useful options
%   view3Dopt(X) or view3Dopt(X, 'link') or view3Dopt(X, F) will simply call view3D with those
%   arguments
%
%   view3Dopt(V1, V2, ...) displays the given volumes with default tiling and link parameters
%
%   view3Dopt(C) where C = {V1, V2, ...} displays the given volume with the default tiling and link
%   parameters
%
%   view3Dopt(..., ParamName, ParamValue) add functioanlity as shown below
%
%   h = view3Dopt(...) returns the handles of the view windows.
%
%   ParamName/ParamValue pairs:
%       tilehorz:boolean (default:false). if true, tile multiple viewers horizontally on screen
%       link:boolean     (default:true). if true, will link viewers.
%       tilefull:boolean (default:true). tile on one monitor in a semi-smart arrangement
%       monitorId:int    (default:1) the monitor number on which to show these volumes.
%       voxMask:mask, (default:none). if true, then the inputs are assumed to be given as 
%           just voxels within some mask. so v1full = mark(V1) gives an actual 3D volume.
%
% Example:
%   % display 4 volumes v1, v2, v3, v4, tiled in a 2x2 fashion, on the second monitor 
%   view3Dopt({v1, v2, v3, v4}, 'monitorId', 2)
%
% Requires: view3D script (external), ifelse, maskvox2vol if using voxMask
%
% TODO: add support for vols as a struct, where vols has two fields:V and F, to allow for fields
%
% See Also: view3D
%
% Contact: adalca@csail.mit.edu

    % parse inputs to extract volumes and options
    [vols, inputs] = parseinputs(varargin{:});
    nViews = numel(vols);
    
    % if given voxMask, then the inputs are assumed to be given as just voxels within that mask, so
    % transform into volumes via maskvox2vol.
    if ~isempty(inputs.voxMask) && numel(inputs.voxMask) > 1
        for i = 1:numel(vols)
            vols{i} = maskvox2vol(vols{i}, inputs.voxMask);
        end
    end
        
    % display the volumes
    if inputs.link
        h = view3D(vols, 'link');
    else
        h = view3D(vols);
    end

    % tile if necessary
    if inputs.tilehorz || inputs.tilefull
        
        % get tile information (nRows is 1 if tilehorz, empty otherwise)
        nRows = ifelse(inputs.tilehorz, {1}, {});
        tile = tileGrid(nViews, inputs.monitorId, nRows{:});
        
        % get view grid 
        [nfo, tile] = viewGrid(nViews, tile);
        
        % move viewers around.
        for i = 1:nViews
            set(h(i), 'Position', [nfo(i).x, nfo(i).y, tile.winwidth, tile.winheight]);
        end
    end
    
    if nargout > 0
        varargout{1} = h;
    end
end

function [nfo, tile] = viewGrid(nViews, tile)
% compute info struct array nfo, with size(nfo) = nViews, and fields x and y indicating the starting
% position for each window.

    if nargin == 1
        tile = tileGrid(nViews, 1);
    end
    
    % go through the windows.
    nfo(nViews) = struct('x', [], 'y', []);
    for i = 1:nViews
        % compute the x location
        xi = mod(i - 1, tile.nCols) + 1;
        nfo(i).x = tile.xStart - 1 + (xi - 1) * tile.winwidth + xi;
        
        % compute the y location
        yi = ceil(i ./ tile.nCols);
        nfo(i).y = tile.yStart - 1 + tile.height - yi * (tile.titlebarheight + tile.winheight);
    end
end

function tile = tileGrid(nViews, monitorID, nRows)
% output a tile structure for this monitor, with fields 
%   titlebarheight, xStart, yStart, width, height, nRows, nCols, winwidth, winheight.
%
% TODO: take in several monitors at once. Then, simple compute the winwidth and winheight per
% monitor. (to not have windows across monitors. THen you have to smartly iterate
    
    % estimate a height for the titlebar which should be accounted for in the computations. 
    tile.titlebarheight = 60;
    
    % get the size of the screen
    % for a single screen, screensize = get(0,'ScreenSize'); would work
    % but we want to support multiple screens. 
    mp = get(0, 'MonitorPositions');
    screensize = mp(monitorID, :);
    tile.xStart = screensize(1);
    tile.yStart = screensize(2) + (mp(1, 4) - screensize(4) - 1);
    tile.width = screensize(3); % R2014a and earlier would need: - screensize(1) + 1;
    tile.height = screensize(4);  % R2014a and earlier would need: - screensize(2) + 1;

    % compute the number of columns and rows.
    if nargin == 2
        tile.nRows = max(round(sqrt(nViews .* tile.height ./ tile.width)), 1);
    else
        tile.nRows = nRows;
    end
    tile.nCols = ceil(nViews ./ tile.nRows);
    
    % compute the width and height of the windows. 
    tile.winwidth = tile.width / tile.nCols;
    tile.winheight = (tile.height - tile.nRows * tile.titlebarheight) / tile.nRows;    
end

function [vols, inputs] = parseinputs(varargin)
% parse inputs, extracting the volumes vol and the inputs struct for the param/value pairs

    % determine the number of inputs for view3D
    f = find(cellfun(@ischar, varargin(2:end)), 1, 'first');
    extraOpts = {};
    if numel(f) == 1
        extraOpts = varargin(f+1:end);

        % if the second input is 'link', it could be due to original link or
        %    due to new link option. figure out which one it is based on the next
        %    input.
        if f == 1 && strcmp(varargin{2}, 'link')
            if nargin > 2 && ischar(varargin{3})
                extraOpts = varargin(f+2:end);
            elseif nargin == 2
                extraOpts = {};
            end
        end
    end

    % parse parameters
    p = inputParser();
    p.addParamValue('link', true, @islogical);
    p.addParamValue('tilehorz', false, @islogical);
    p.addParamValue('tilefull', true, @islogical);
    p.addParamValue('monitorId', 1, @isscalar);
    p.addParamValue('voxMask', false, @islogical);  % requies maskvox2vol()
    p.parse(extraOpts{:});

    % save input options
    inputs = p.Results;
    
    % if tilehorz is true, then check that 
    if inputs.tilehorz
        if inputs.tilefull
            assert(any(strcmp(p.UsingDefaults, 'tilefull')), ...
                'Please only supply horizontal or full tile, not both');
            inputs.tilefull = false;
        end
    end
    
    % extract volumes.
    if numel(f) == 0 
        f = numel(varargin);
    end
    
    if isnumeric(varargin{1}) || islogical(varargin{1})
        vols = varargin(1:f);
    else
        vols = varargin{1};
    end
    
    % make sure the volumes are in a cell
    if ~iscell(vols)
        vols = {vols};
    end
    
end
