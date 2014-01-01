function r = randLogical(varargin)
% randbool returns a matrix with boolean values randomly chosen.


%TODO: def of 0.5, but not only
    r = rand(varargin{:}) < 0.5;