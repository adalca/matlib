function help2htmlFolder(path, docpath)
% HELP2HTMLFOLDER write m-file help to html file for each m-file in given path recursively
%   help2htmlFolder(path, docpath) write m-file help an html file for each m-file in <path>.
%       The html files will be put in <docpath> with the same subdirectory structure as in <path>.
%
% See Also: help2htmlFile
%
% Contact: http://adalca.mit.edu

    % get all the subpaths (including current path)
    sdirs = subdirs(path);
    
    % loop over directories
    for i = 1:numel(sdirs)
        
        % save current directory and compute current doc directory
        curdir = sdirs{i};
        curdocdir = strrep(curdir, path, docpath);
        
        % verify it's a directory
        assert(isdir(curdir), '%s is not a dir', curdir);
        
        % make the doc dir if it's not there yet
        if ~isdir(curdocdir)
            mkdir(curdocdir);
        end

        % get all of the m files
        fileformat = fullfile(curdir, '*.m');
        mFiles = dir(fileformat);
        
        % go through each m-file
        for j = 1:numel(mFiles)
            % extract the filename, and prepare the html name
            filename = fullfile(curdir, mFiles(j).name);
            docname = fullfile(curdocdir, [mFiles(j).name(1:end-2), '.html']);

            % write the help to the html file
            help2htmlFile(filename, docname, mFiles(j).name)
        end
    end
end
