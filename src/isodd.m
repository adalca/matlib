function b = isodd(x)
% ISODD true if value is odd
%   b = isodd(x) returns true if x is of
%
% See Also: mod
%
% Contact: http://adalca.mit.edu



    b = mod(x, 2) == 1;
    

