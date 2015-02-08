function Y = lognormpdf(X, mu, sigma, debug)
% LOGNORMPDF log of normal-pdf
%
%   Y = lognormpdf(X) returns the logarithm of the normal pdf of data X with mean 0 and standard 
%   deviation 1. The computations are done in log space directly. 
%
%   Y = lognormpdf(X, mu, sigma) returns the logarithm of the normal pdf of data X with respect to
%   mean mu and standard deviation sigma. The computations are done in log space directly. 
%
%   Y = lognormpdf(X, mu, sigma, true) also compares the results with exp(normpdf(...));
%
% See Also: normpdf
%
% Contact: adalca@mit.edu

    if nargin < 2
        mu = 0;
    end
    
    if nargin < 3
        sigma = 1;
    end

	% compute log-space norm of pdf.
    t1 = -0.5 * log(2*pi*sigma.^2);
    t2 = -0.5 ./ (sigma.^2) .* ((X - mu).^2);
    Y = t1 + t2;
    
    if nargin == 4 && debug
        % do a rough check. This won't be true especially in the case where we need log computations
        yc = normpdf(X, mu, sigma);
        if ~(max(abs(exp(Y) - yc))./mean([exp(Y(:)); yc(:)]) < 10e-5);
            warning('yc, Y don''t match');
        end
    end
    