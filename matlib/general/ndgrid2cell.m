function x = ndgrid2cell(varargin)

    if nargin == 1 && iscell(varargin{1})
        varargin = varargin{1};
    end

    x = cell(numel(varargin), 1);
    [x{:}] = ndgrid(varargin{:});
