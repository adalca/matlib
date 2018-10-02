function x = size2sub(volSize)

    y = size2ndgrid(volSize);
    x = cellfun(@(x) x(:), y, 'UniformOutput', false);