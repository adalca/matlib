function outfile = replaceExtension(infile, newext)

    if numel(newext) == 0 || newext(1) ~= '.'
        newext = ['.' newext];
    end

     [path, filename, ~] = fileparts(infile);
     outfile = fullfile(path, [filename, newext]);
end