function d = fulldir(path)
% FULLDIR get files and folder with pull path
%   d = fulldir() get files and folders in current path. Acts the same
%   as d=dir(), but includes full path for files in d.name.
%
%   d = fulldir(path) allows for specification of the path to list
%
% See Also: dir
%
% Contact: http://adalca.mit.edu

    
    % if no argument given, assume present workding directory
    if nargin == 0
        path = pwd;
    end
    
    % get the folder path name
    [ppath, ~, ~] = fileparts(path);
    
    % get the files
    d = dir(path);

    % combine the name of each file with path name
    for e = 1:numel(d)
        d(e).name = fullfile(ppath, d(e).name);
    end
    
    % if no output argument, just list names
    if nargout == 0
        for e = 1:numel(d)
            fprintf(d(e).name);
        end
    end
    
