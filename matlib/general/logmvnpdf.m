function logp = logmvnpdf(x, mu, sigma, sigmainv)
% LOGMVNPDF log of multivariate normal PDF
%   Y = logmvnpdf(x) computes the logarithm of the multivariate normal PDF with zero mean and
%   identity covariance matrix. In essence, this behaves like log(mvnpdf(x)), but works in log space
%   to avoid overflow issues. X is N-by-D, where N is the number of observations, and D is the
%   dimentionality of each observation, or number of features.
%
%   Y = logmvnpdf(x, mu) allows for the specification of the mean. mu can be 1-by-D or N-by-D, where
%   the latter allows each x to have a different mean.
%
%   Y = logmvnpdf(x, mu, sigma) allows for the specification of sigma, which is D-by-D or
%   D-by-D-by-N. 
%
%   Y = logmvnpdf(x, mu, sigma, sigmainv) allows for the specification of the inverse of sigma. This
%   allows logmvnpdf to avoid computing the inverse of sigma (useful, for example, if this function
%   is called multiple times with the same sigma & sigmainv). However, note that it can lead to less
%   stable results, since without specifying sigmainv, logmvnpdf uses the / operator, which is in
%   general more accurate.
%
% built on top of Benjamin Dichter's code @
%   http://www.mathworks.com/matlabcentral/fileexchange/34064-log-multivariate-normal-distribution-function
%
% See Also: mvnpdf, logdet
%
% Contact: adalca@csail.mit.edu

    % parse inputs
    narginchk(1, 4);
    [N, D] = size(x);
    if nargin < 2
        mu = zeros(1, D);
    end
    [uN, uD] = size(mu);
    assert((uN == 1 || uN == N) && uD == D);
    if nargin < 3
        sigma = eye(D);
    end
    [sD1, sD2, sN] = size(sigma);
    assert((sN == 1 || sN == N) && sD1 == D && sD2 == D);
    
    % gaussian constant
    const = -0.5 * D * log(2*pi);

    % (X - mu)
    xc = bsxfun(@minus, x, mu);

    % (X - mu) * inv(sigma)
    if size(sigma, 3) > 1
        xs = zeros(size(xc));
        for n = 1:size(sigma, 3) 
            if nargin < 4
                xs(n, :) = xc(n, :) / sigma(:, :, n);
            else
                xs(n, :) = xc(n, :) * sigmainv(:, :, n);
            end
        end
    else
        if nargin < 4
            xs = xc / sigma;
        else
            xs = xc * sigmainv;
        end
    end
    term1 = -0.5 * sum(xs .* xc, 2); 
    
    term2 = const - 0.5 * logdet(sigma);
    logp = term1 + term2;
end
