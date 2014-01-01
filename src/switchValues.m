function [v1, v2] = switchValues(val1, val2)
% SWITCHVALUES does a quick switch of the values val1 and val2
%   [v1, v2] = switchValues(val1, val2) switches the values in val1 and
%   val2, i.e. you get v1 = val2, v2 = val1;
%
%   Author: Adrian Dalca. 
%   http://www.mit.edu/~adalca/

    v2 = val1;
    v1 = val2;
    