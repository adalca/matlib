function view3Dopt(varargin)
% VIEW3DOPT extends/wraps the view3D script with some useful options
%	view3Dopt(X) or view3Dopt(X, 'link') or view3Dopt(X, F) will simply call view3D 
%		with those arguments
%	view3Dopt(..., ParamName, ParamValue) add functioanlity as shown below
%
%   ParamName/ParamValue pairs:
%       tilehorz:boolean, (default:false). if true, will tile multiple viewers horizontally on screen
%       link:boolean (default:true). if true, will link viewers.
%       tilefull:boolean, (default:true). tile (up to 6) on one monitor
%           TODO: Multi-Screen Tile
%       voxMask:mask, (default:none). if true, then the inputs are assumed to be given as 
%           just voxels within some mask
%
% requires: view3D script, ifelse

    % determine the number of inputs for view3D
    f = find(cellfun(@ischar, varargin(2:end)), 1, 'first');
    extraOpts = {};
    if numel(f) == 1
        extraOpts = varargin(f+1:end);

        % if the second input is 'link', it could be due to original link or
        %	due to new link option. figure out which one it is based on the next
        %	input.
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
    p.addParamValue('voxMask', false, @islogical);  % requies maskvox2vol
    p.parse(extraOpts{:});

    vols = varargin{1};
    if ~iscell(vols)
        vols = {vols};
    end
    
    % if given voxMask, then the inputs are assumed to be given as just voxels within that mask, so
    % transform into volumes via maskvox2vol.
    if ~isempty(p.Results.voxMask) && numel(p.Results.voxMask) > 1
        for i = 1:numel(vols)
            vols{i} = maskvox2vol(vols{i}, p.Results.voxMask);
        end
    end
        
    
    
    % display the volumes
    if p.Results.link
        h = view3D(vols, 'link');
    else
        h = view3D(vols);
    end

    % tile horizontally if necessary
    if p.Results.tilehorz
        lastx = 0;
        for i = 1:numel(h)
            if i == 1
                pos = get(h(i), 'Position');
            else
                pos = get(h(i), 'Position');
                pos(1) = lastx + pos(3);
            end

            set(h(i), 'Position', pos);
            lastx = pos(1);
        end
    end
    
    % tile horizontally if necessary
    if p.Results.tilefull
        
        % heuristic... should imrove this. assume no more than 6 images
        if numel(h) > 6, error('need to work on more than 6 fulltile...'); end
        
        titlebarheight = 60;
        screensize = get(0,'ScreenSize');
        winwidth = screensize(3)/3;
        winheight = (screensize(4)-2*titlebarheight)/2; 
        
        for i = 1:numel(h)

            xi = mod(i - 1, 3) + 1;
            xpos = (xi - 1) * winwidth + xi;
            yi = ifelse(i <= 3, 1, 2);
            ypos = screensize(4) - yi * (titlebarheight + winheight);
            
            set(h(i), 'Position', [xpos, ypos, winwidth, winheight]);

        end
    end
       
end