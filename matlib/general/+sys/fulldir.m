function varargout = fulldir(path)
% FULLDIR get files and folder with pull path
%   fulldir() list files and folders in current path. Acts the same
%   as dir(), but includes full path for files in d.name.
%
%   d = fulldir() returns attributes about the current path. see dir() for attribute details.
%
%   fulldir(path) allows for specification of the path to list
%
%   d = fulldir(path) allows for specification of the path to return
%
% TODO: if path is a folder without the final filesep, this method fails due to the fileparts call. 
% Perhaps check isdir first?
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
            fprintf('%s\n', d(e).name);
        end
        
    % else, return
    else
        varargout{1} = d;
    end
    
