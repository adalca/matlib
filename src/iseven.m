function b = iseven(x)
% ISEVEN true if value is even
%   b = iseven(x) returns true if x is even
%
% See Also: mod
%
% Contact: http://adalca.mit.edu

    b = mod(x, 2) == 0;
    

