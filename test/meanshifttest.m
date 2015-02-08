% test mean shift and plot

%% specific test - two bumps of varying size
fitK = 2;
x11 = normrnd(-0.5, 0.3, [20000, 1]);
x12 = normrnd(0.5, 0.3, [10000, 1]);
x1 = [x11; x12]';
m = meanShift(x1, 'K', fitK);


clf;
interpX = linspace(min(x1), max(x1), 100);
h = hist(x1, interpX); hold on; 
plot(interpX, h, 'r');
for k = 1:fitK
    plot([m(k), m(k)], [0, max(h) + 1]); 
end


%% specific test - two bumps of varying size, small bump on right
fitK = 2;
x11 = normrnd(-0.5, 0.3, [20000, 1]);
x12 = normrnd(0.5, 0.3, [10000, 1]);
x13 = normrnd(-1.5, 0.3, [1000, 1]);
x1 = [x11; x12; x13]';
m = kmeanShift(x1, 'K', fitK, 'nReplicates', 100);


clf;
interpX = linspace(min(x1), max(x1), 100);
h = hist(x1, interpX); hold on; 
plot(interpX, h, 'r');
for k = 1:fitK
    plot([m(k), m(k)], [0, max(h) + 1]); 
end


%%
kMax = 2;
kMin = 2;
nReps = 3;
nRange = 100;
diffs = zeros(1, nReps);

for j = 1:nReps
    k = randi([kMin, kMax], 1);
    randmeans = unifrnd(-1, 1, [k, 1]);
    randstds = unifrnd(0.1, 0.5, [k, 1]);
    randnums = randi([1000, 10000], [k, 1]);

    x = [];
    for i = 1:k
        xk = normrnd(randmeans(i), randstds(i), [randnums(i), 1]);
        x = [x; xk(:)];
    end
    x = x';
    
    [m, s, w, stats] = meanShift(x);

    clf;
    interpX = linspace(min(X), max(X), nRange);
    h = hist(x, interpX); hold on; 
    plot(interpX, h, 'r');
    plot([m, m], [0, max(h) + 1]); 

    % plot clusters
    gmaxvals = zeros(1, k);
    for i = 1:k
        del = (randmeans(i) - interpX) / randstds(i);
        g = gaussKernel(del) .* sep ./ randstds(i);
    %     assert(isclose(sum(g), 1, 0.001));
        s = sum(g);
        g = g * randnums(i);
        gmaxvals(i) = max(g); % want actual prob(g) .* num. g might be cut off so not sum to 1. 
        g = g./ s;
        plot(interpX, g, 'b');
    end

    % compute max k's mean
    [~, mi] = max(gmaxvals);
    plot([randmeans(mi), randmeans(mi)], [0, gmaxvals(mi)], '.'); 
    
    % mean diff
    diffs(j) = (m - randmeans(mi)) ./ randstds(mi);

    if diffs(j) > 1
%         pause();
    end
end

clf; 
msg = 'k in [%d, %d], abs diff / std of true max';
hist(abs(diffs), nReps)
title(sprintf(msg, kMin, kMax))


