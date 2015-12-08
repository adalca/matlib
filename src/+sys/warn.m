function warn(message, varargin)
% adding some functionality on top of MATLAB's warning function. Specifically:
%   - 'singleWarn' Parameter allows for a warning to be executed only once per session, even if the
%   sys.warn() is called many times.
%
%   method still in development and might change. use with caution.
%
% TODO: allow for inputs and treatment in the style of warning() (i.e. sprintf)
%
% See Also: warning
%
% contact: adalca@csail.mit.edu

    [inputs, do] = parseInputs(message, varargin{:});

    if do
        warning(message);
    end
    
end

function [inputs, do] = parseInputs(message, varargin)
    do = true;

    p = inputParser();
    p.addRequired('message', @ischar);
    p.addParameter('singleWarn', false, @islogical);
    p.parse(message, varargin{:});
    
    inputs = p.Results;
    
    if inputs.singleWarn
        d = dbstack();
        msgid = 'msgid';
        for i = 1:size(d)
            msgid = sprintf('%s_%s_%d', msgid, d(i).name, d(i).line);
        end
        
        global sysSingleWarn;
        if isempty(sysSingleWarn)
            sysSingleWarn = containers.Map;
        end
        if ~(sysSingleWarn.isKey(msgid) && sysSingleWarn(msgid))
            sysSingleWarn(msgid) = true; % initiate
        else
            do = false;
        end
    end
end