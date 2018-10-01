v1 = volresize(double(n1.img), [35 40, 26]);
w = arrayfunc(@(x) volblur(randn(size(v1)) * 10, 3), 1:3);
wb = invertwarp(w, 'forward');

v1w = volwarp(v1, w, 'forward');
v1wwb = volwarp(v1w, wb, 'forward');
v1ww = volwarp(v1, wb, 'backward');

view3Dopt(v1, v1wwb, v1w, v1ww);

% see the effect of composition of warps
c = composeWarps(w, wb); % interpmethod can be important here!
view3Dopt([w, c])