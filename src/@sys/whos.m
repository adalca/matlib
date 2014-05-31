function whos(varargin)
% '-opt' for options, the next params are param/value pairs. Also, this implies a new set of
% defaults, so that ever without any param/value pairs, whos behaves differently as long as -opt is
% given
% TODO: add: human readability, etc    
% add: only include parts of data.

    f = find(strcmp('-opt', varargin));
    
    if numel(f) == 0
        w = whoscallerstr(varargin{:});
        evalin('caller', w);
    else
        optargs = varargin(f+1:end);
        p = inputParser();
        p.addParamValue('sort', 'bytes', @isstr);
        p.parse(optargs{:});
        
        w = whoscallerstr(varargin{1:f-1});
        S = evalin('caller', w);
        
        [~, si] = sort([S.(p.Results.sort)]);
%         Name                      Size                     Bytes  Class            Attributes
        for i = si
            fprintf('%20s', S(i).name);
            fprintf('%30s', sizestr(S(i).size));
            fprintf('%15d', S(i).bytes);
            fprintf('%20s\n', S(i).class);
        end
    end
    
end


function str = whoscallerstr(varargin)

    str = 'whos(';
    for i = 1:numel(varargin);
        str = sprintf('%s''%s''', str, varargin{i});
        if i < numel(varargin); str = sprintf('%s,', str); end
    end
    str = sprintf('%s);', str);
end
    
    
    
    

function str = sizestr(sz)

    str = '';
    for s = 1:numel(sz)
        str = sprintf('%s%d', str, sz(s));
        if s < numel(sz), 
            str = sprintf('%sx', str); 
        end
    end
    

end
