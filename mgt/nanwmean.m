function y = nanwmean(x, w, dim)
% weighted mean

    narginchk(1, 3);
    if nargin == 1 || isempty(w)
        w = ones(size(x));
    end

    if ~exist('dim', 'var') || isempty(dim)
        dim = find(size(x) ~= 1, 1);
        
        if isempty(dim), 
            dim = 1; 
        end
    end
    
    nans = isnan(x .* w);
    x(nans) = 0;
    w(nans) = 0;
    
    x = x .* w;
    s = sum(x, dim);
    z = sum(w, dim);
    z(z == 0) = NaN;
    y = s ./ z;
    