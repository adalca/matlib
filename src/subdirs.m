function sdirs = subdirs(path)
% SUBDIRS get the current path and all subdirectories
%   sdirs = subdirs(path) returns a cellstr of the current path and all subdirectories
%
% See Also: genpath
%
% Contact: http://adalca.mit.edu

    % get the recursive path string
	recursivepath = genpath(path);
    
    % genpath adds a ';' at the end. This will confuse the strsplit, giving us an empty cell
    % take the last ';' out.
    assert(recursivepath(end) == ';');
	sdirs = strsplit(recursivepath(1:end-1), ';');
    