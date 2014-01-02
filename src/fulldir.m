function d = fulldir(path)
% acts the same as dir, but includes full path for files
% not tested very thoroughly yet.

    [ppath, ~, ~] = fileparts(path);

    d = dir(path);
    
    for e = 1:numel(d)
        d(e).name = fullfile(ppath, d(e).name);
    end
    