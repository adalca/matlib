function g = gaussFilt(sigma, windowsize)
% similar to fspecial('gaussian', params), but allows for a sigma matrix
% 
% give sigmas in matlab order (so first is row, then column, then depth)

% get the zero-mean gaussian filter
dim = size(sigma, 1);
mid = (windowsize - 1)/2;
range = linspace(-mid, mid, windowsize);

% gaussian parameters
mu = zeros(size(windowsize));

% points for gaussian
% could simplify the code (but maybe cost more?) if just did the 3rd
% case, and extracted 1:dim columns. This seems cleaner, though
switch dim
    case 1
        X = range(:);
    case 2
        [x1, x2] = ndgrid(range, range);
        X = [x1(:), x2(:)];
    case 3
        [x1, x2, x3] = ndgrid(range, range, range);
        X = [x1(:), x2(:), x3(:)];
    otherwise
        error('dim must be 1, 2 or 3 %i', dim); 
end

% get the Multivariate Normal PDF values
g = mvnpdf(X,mu,sigma);

% normalize
if dim > 1
    g = reshape(g, repmat(windowsize, [1, dim]));
end
g = g ./ sum(g(:));






