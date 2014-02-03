function varargout = normhist(varargin)
% behaves like hist(), but bin elements normalized to sum to 1.

    f = find(strcmp('LineSpec', varargin));
    if numel(f) == 1
        linespec = varargin{f + 1};
        varargin = varargin(1:(f-1));
    end
        

    [h1, c] = hist(varargin{:}); 
    h1 = h1 ./ sum(h1); 
    
    varargout = {};
    if nargout == 0
        % just plot normalized hist;    
        if exist('linespec', 'var')
            plot(c, h1, linespec);
        else
            bar(c, h1);
        end
    else
        varargout{1} = h1;
        if nargout == 2
            varargout{2} = c;
        end
    end
    