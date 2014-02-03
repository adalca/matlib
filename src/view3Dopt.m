function view3Dopt(varargin)
% VIEW3DOPT extends the view3D script with various options
%	view3Dopt(X) or view3Dopt(X, 'link') or view3Dopt(X, F) will simply call view3D 
%		with those arguments
%	view3Dopt(..., ParamName, ParamValue) add functioanlity as shown below
%
%   ParamName/ParamValue pairs:
%       tilehorz:boolean, (default:true). if true, will tile multiple viewers horizontally on screen
%       link:boolean (default:true). if true, will link viewers.
%
% requires: view3D script

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
    p.addParamValue('tilehorz', true, @islogical);
    p.parse(extraOpts{:});

    % display the volumes
    if p.Results.link
        h = view3D(varargin{1}, 'link');
    else
        h = view3D(varargin{1});
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
       
end