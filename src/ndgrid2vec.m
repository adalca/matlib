function c = ndgrid2vec(varargin)
%
% c is N-by-D where N is the number of elements in each of the ndgrid dimensions

    c = ndgrid2cell(varargin{:});
    c = cellfunc(@(x) x(:), c);
    c = cat(2, c{:});
    