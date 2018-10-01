function [str, type, id] = bib2struct(entry)
% BIB2STRUCT convert a bib entry to a struct
%
% [str, type, id] = bib2struct(entry). Entry can be the string of text or a (single-entry) bib file.
%
% Assumes bib format:
%   @type{id, 
%     info1 = {blah},
%       ...
%     info2 = {blah}
%   }

    % if the entry is a file, read it.
    if sys.isfile(entry)
        entry = fileread(entry);
    end

    % check entries
    entryIdx = strfind(entry, sprintf('\n@'));
    assert(numel(entryIdx) < 2, 'bib2struct is currently implemented for single entry');
    assert(numel(entryIdx) == 1, 'bib2struct: count not find entry');
    
    % parse overall structure
    q = regexp(entry, '@([^{]+){([^,]+),(.*)', 'tokens');
    
    assert(~isempty(numel(q)), 'Entry did not have the right structure');
    
    % assign meta info    
    type = q{1}{1};
    id = q{1}{2};
    
    % parse content
    pcontent = parsecontent(q{1}{3});
    names = cellfunc(@(v) v{1}, pcontent);
    data = cellfunc(@(v) v{2}, pcontent);
    
    % build struct
    str = cell2struct(data, names, 2);
end

function pcontent = parsecontent(content)
% to avoid recursive {}, we need to be a little more careful
% otherwise we could do simple stuff like 
% content = regexp(q{1}{3}, '[,\s]*([\w])+\s*=\s*{([^}]*)}', 'tokens');
% or (something like -- this may not work)
% content = regexp(q{1}{3}, '[,\s]*([\w])+\s*=\s*{((?:[^{}]|{[^}]*}}*)}', 'tokens');

    % get all the opening brackets of 'layer 1'
    fo = strfind(content, '{');
    fc = strfind(content, '}');
    
    % compute a layer operator
    layerop = zeros(1, numel(content));
    layerop(fo) = 1;
    layerop(fc) = -1;
    
    % get the layer id at each location
    layerid = cumsum(layerop);
    layerid(fc) = layerid(fc) + 1;
    contentmod = content;
    contentmod(layerid > 1) = '_';
    
    % get info1 = {...} lines
    [st, en] = regexp(contentmod, '[,\s]*([\w])+\s*=\s*{([^}]*)}');
    lines = arrayfunc(@(s,e) content(s:e), st, en);
    
    regexpr = '[,\s]*([\w])+\s*=\s*{(.*)}';
    pcontent = cell(1, numel(st));
    for i = 1:numel(st)
        q = regexp(lines(i), regexpr, 'tokens');
        pcontent(i) = q{1};
    end
end

