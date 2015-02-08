function dst = nanssd(v1, v2)
% sum of squared difference

    ds = (v1 - v2) .^ 2;
    dst = nansum(ds);
    