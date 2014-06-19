function varargout = whos(varargin)
% WHOS extend matlab whos with several options
%   sys.whos(...) normal call to matlab's whos() function, with new defaults. Specifically, by
%   default variables are sorted by size, and the size is given in human readbale format (see
%   humanReadableBytes());
%
%   sys.whos(..., '-opt', OptName, OptValue) allows for new option names and values
%       'sort' - the sort field, based on the fields of the structure that whos(...) returns. 
%           default is bytes
%
%   S = sys.whos(...) does not print, but return a structure S. For now, this is identical to 
%   matlab's S = whos(...)
%
% TODO: only include parts of the data.
%
% See also: whos
%
% Contact: adalca@csail.mit.edu

    % find option location
    f = find(strcmp('-opt', varargin));
    if numel(f) == 0
        f = numel(varargin) + 1;
    end
    
    % execute whos in caller workspace
    w = whoscallerstr(varargin{1:f-1});
    S = evalin('caller', w);
    
    if nargout == 1
        varargout{1} = S;
        return;
    end
    
    % parse option atguments
    optargs = varargin(f+1:end);
    p = inputParser();
    p.addParamValue('sort', 'bytes', @isstr);
    p.parse(optargs{:});

     % sort
    [~, si] = sort([S.(p.Results.sort)]);
    
    % print in format:
    % Name Size Bytes Class Attributes
    for i = si
        fprintf('%20s', S(i).name);
        fprintf('%30s', sizestr(S(i).size));
        fprintf('%15s', humanReadableBytes(S(i).bytes));
        fprintf('%20s\n', S(i).class);
    end
    
end

function str = whoscallerstr(varargin)
% build the string of the whos() call
    
    str = 'whos(';
    for i = 1:numel(varargin);
        str = sprintf('%s''%s''', str, varargin{i});
        if i < numel(varargin); str = sprintf('%s,', str); end
    end
    str = sprintf('%s);', str);
end

function str = sizestr(sz)
% create a size string of the form S1xS2x...

    str = '';
    for s = 1:numel(sz)
        str = sprintf('%s%d', str, sz(s));
        if s < numel(sz), 
            str = sprintf('%sx', str); 
        end
    end
end
