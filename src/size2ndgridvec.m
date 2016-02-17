function q = size2ndgridvec(sz)
% go from a size, to a ndgrid-stacked vec
% sz is a 1-by-nDims vec
% q is a prod(sz)-by-nDims matrix, where the ith column is the ith ndgrid entry

    q = size2ndgrid(sz);
    q = cellfunc(@(x) x(:), q);
    q = cat(2, q{:});
    