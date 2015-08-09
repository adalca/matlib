function restart(varargin)
% retart matlab to a new instance
%   sys.restart() restart matlab to a new instance
%   sys.restart(Param, Value, ...) allows for some options:
%
% Param/Value pairs:
%   'keepvars' logical (default: false), whether to save your variables. 
%
% contact: adalca@csail.mit.edu

    % parse inputs
    p = inputParser();
    p.addParameter('keepvars', false, @islogical);
    p.parse(varargin{:});

    % if keeping variables, need to get a temp file, dump all the (caller's) variables, and 
    % re-load them upon restart
    if p.Results.keepvars
        filename = [tempname, '.mat'];
        
        % save all variables in caller
        str = sprintf('robustSave(''%s'');', filename);
        evalin('caller', str); % save all variables
        
        % need to print the command:
        % !(matlab -r "load(filename)") &
        % but with the right filename
        str = sprintf('!(matlab -r "load(''%s''); delete(''%s'');") &', filename, filename);
        eval(str);
        exit
        
    % if no variable save necessary, just restart (start a new matlab and quit)
    else
        !matlab &
        exit
    end
    