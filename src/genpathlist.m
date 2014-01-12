function genpaths = genpathlist(paths)
% GENPATHLIST run genpath on a path string 
% genpaths = genpathlist(paths) run genpath() on all paths inside the given path string
%	path string list should be in format /path/1;/path/2/etc;/and/so/on
%
% See Also: genpath
%
% Contact http://adalca.mit.edu

    % get the different paths in the path string
    s = strsplit(paths, ';');
    
    % compute the genpath for each one and combine
    genpaths = '';
    for i = 1:numel(s)
        genpaths = [genpaths, genpath(s{i})];
    end
    
