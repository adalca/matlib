function T = trimarray(X, trimsize, dir)
% opposite of padarray.
% TODO: comments

    % input checking
    narginchk(2, 3);
    if isscalar(trimsize) && ~isvector(X) 
        trimsize(2:ndims(X)) = 0;
%         trimsize = ones(1, ndims(X)) * trimsize; % this would be inconsistent with padarray
    end    
    if ~exist('dir', 'var')
        dir = 'both';
    end
    assert(any(strcmp(dir, {'both', 'pre', 'post'})));

    
    % decide on trimming range based on direction
    switch dir
        case 'both'
            ranges = arrayfunc(@(d) (1+trimsize):(d-trimsize), size(X));
        case 'pre'
            ranges = arrayfunc(@(d) (1+trimsize):d, size(X));
        case 'post'
            ranges = arrayfunc(@(d) 1:(d-trimsize), size(X));
        otherwise
            error('wrong direction');
    end
    
    % trim
    T = X(ranges{:});
