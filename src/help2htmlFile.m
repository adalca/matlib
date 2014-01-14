function help2htmlFile(filename, docname, pagetitle)
% HELP2HTMLFILE write m-file help to an html file
%   help2htmlFile(filename, docname) write m-file <filename> help/documentation to html file
%       <docname>
%
%   help2htmlFile(filename, docname, pagetitle) allows you to specify the page title
%
% Inspired by @SamRoberts, via
%   http://stackoverflow.com/questions/7840964/
%       /how-can-one-generate-good-documentation-for-object-oriented-matlab-code
%
% See Also: help2html
%
% Contact: http://adalca.mit.edu

    % default page title
    if nargin == 2
        pagetitle = '';
    end
    
    % verify m-file extension
    [~, ~, ext] = fileparts(filename);
    assert(strcmp(ext, '.m'), 'file is not an m-file');

    % get html string and write it back
    htmlstr = help2html(filename, pagetitle, '-doc');

    % write out the doc to the html file
    fid = fopen(docname, 'w');
    assert(fid > 0, 'Could not open %s for writing', docname);
    fprintf(fid,'%s', htmlstr);
    fclose(fid);
    