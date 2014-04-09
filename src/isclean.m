function isc = isclean(X)

    x = X(:);
    
    isc = ~any(isnan(x)) & all(isfinite(x)) & all(isreal(x));
    
