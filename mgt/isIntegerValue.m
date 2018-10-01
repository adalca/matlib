function is = isIntegerValue(x)
% ISINTEGERVALUE check if variable has integer value
%   is = isIntegerValue(x) will check if x has integer value. 
%       Note, this is different from MATLAB's isinteger, which checks 
%       the class of the variable x against Integer Types (uint8, etc)
%
% See Also isinteger
%
% Contact: http://adalca.mit.edu

    is = mod(x, 1) == 0;
    
