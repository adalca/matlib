function colmap = jitter(n, colmapfnc)
% JITTER jitter colormap
%   colmap = jitter(n) return a jitter colormap of size [n x 3]. The jitter colormap will (likely)
%       have distinct colors, with neighburing colors being quite different. 
%
%   colmap = jitter(n, colmapfcn) allows the suer to specify a specific seed colormap function
%       handle, with default being @hsv.
%
%   Algorithm: given a (preferably smooth) colormap as a starting point (default @hsv), jitter
%   reorders the colors by skipping roughly a quarter of the colors. So given hsv(9), jitter would
%   take color numbers, in order, 1, 3, 5, 7, 9, 2, 4, 6, 8.
%
%   Example:
%       colmap = jitter(10);
%       figure(); hold on;
%       for i = 1:10
%           x = sort(rand(20, 1) * 10);
%           y = x .* randi([1, 3]) + randn(20, 1) * 0.5;
%           plot(x, y, '.-', 'color', colmap(i, :));
%       end
%
%   Contact: adalca@csail.mit.edu
    
    % get a 1:n vector
    idx = 1:n;
    
    % roughly compute the quarter mark. in hsv, a quarter is enough to see a significant col change
    m = max(round(0.25 .* n), 1);
    
    % compute a new order, by reshaping this index array as a [m x ?] matrix, then vectorizing in
    % the opposite direction. 
    nElems = ceil(n ./ m) .* m;
    idx = padarray(idx, [0, (nElems - n)], 0, 'post');
    idxmat = reshape(idx, [m, length(idx)/m])';
    idxnew = idxmat(:);
    idxnew(idxnew == 0) = [];
    
    % get colormap and scramble it
    if nargin == 1
        colmapfnc = @hsv;
    end
    colmap = colmapfnc(n);
    colmap = colmap(idxnew, :);
