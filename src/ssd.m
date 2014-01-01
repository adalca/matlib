function dst = ssd(v1, v2)
% sum of squared difference

    ds = (v1 - v2) .^ 2;
    dst = sum(ds);
    