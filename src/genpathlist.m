function genpaths = genpathlist(paths)
% run genpath on all paths inside the given path list
%	path list should be in format /path/1;/path/2/etc;/and/so/on
    
    s = strsplit(paths, ';');
    genpaths = '';
    for i = 1:numel(s)
        genpaths = [genpaths, genpath(s{i})];
    end
    