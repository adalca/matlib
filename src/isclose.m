function bool = isclose(var1, var2, dst)
% ISCLOSE returns whether two variables are close to eachother 
%
%   bool = isclose(var1, var2) returns whether var1 is close to var2, i.e.
%   if it is within a distance dst = 1e-5. 
%
%   bool = isclose(var1, var2, dst ) returns whether var1 is close to var2,
%   i.e. if it is within a distance dst. var1 and var should be the same
%   dimension
%
%   Author: Adrian Dalca
%   http://www.mit.edu/~adalca/

    if nargin == 2
        dst = 1e-5;
    end
    
    if ~isscalar(var2)
%         assert(all(size(var1) == size(var2)), '%i, %i\n', size(var1), size(var2));
    end
    isdouble = all(isa(var1(:), 'double')) & all(isa(var1(:), 'double'));
    islogical = all(isa(var1(:), 'logical')) & all(isa(var1(:), 'logical'));
    assert(isdouble | islogical);
    bool = abs(var1 - var2) < dst;