function dst = msd(v1, v2)
% mean squared difference

    ds = (v1 - v2) .^ 2;
    dst = mean(ds);
    