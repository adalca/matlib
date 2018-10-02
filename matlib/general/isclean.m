function isc = isclean(X)
% test if X is finite, real, and not NAN

    x = X(:);
    
    isc = ~any(isnan(x)) & all(isfinite(x)) & all(isreal(x));
    
