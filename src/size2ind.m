function idx = size2ind(volSize)
    x = size2ndgrid(volSize);
    idx = sub2ind(volSize, x{:});
