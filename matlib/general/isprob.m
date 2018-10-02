function is = isprob(x)
% TODO - check that elements are probabilities.
% TODECIDE - sum? or just each individually?
    
    is = x <= 1 & x >= 0;
    