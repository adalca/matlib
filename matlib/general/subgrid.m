function [hei, len] = subgrid(N)
% computation of subgrid, based on the screen size
% See Also view2D

    screensize = get(0, 'Screensize');
    W = screensize(3);
    H = screensize(4);

    hei = max(round(sqrt(N*H/W)), 1);
    len = ceil(N/hei);
end