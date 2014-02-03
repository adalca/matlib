function g = gaussDist(x, mu, sigma)

    delt = (x - mu) ./ sigma;
    e = exp(- 0.5 * delt .^ 2);
    g = e ./ (sigma * sqrt(2*pi));
    