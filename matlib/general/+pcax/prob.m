function [p, varargout] = prob(X, mu, sigma, L, lambda)
% PROB probability of a data point under a PCA model
%   p = prob(X, mu, sigma, L) computes the probability of data point (in original space) X under the
%   PCA model with loadings L. We assume the loadings were computed with 0-mean images, and
%   therefore if mu ~= 0, we first subtract the mean from all data points X. X is N x nData, my is
%   Nx1, sigma is N x 1 standard deviation. X is then projected onto the PCA space and the
%   probability is computed.
%
%   p = prob(X, mu, sigma, L, []) computes the probability model under the pca model of a
%   regularized-projected data point X, using pcaproject(X, L, invCovar).
%
%   p = prob(X, mu, sigma, L, lambda) computes the probability model under the pca model 
%   of a regularized-projected data point X with parameter lambda
%
%   [p, logp] = prob(...), returns the log probability as well, in which case p is simple
%   computed from exp(logp). Requires lognormpdf(.)
%
%   [p, logp, scores] = prob(...) also returns the scores of the pca projection
%
% See Also: lognormpdf
%
% Contact: {adalca,rameshvs}@mit.edu
    
    narginchk(4, 5);
    varargout = {};
            
    % get the centered data. 
    data = bsxfun(@minus, X, mu);

    % project the data onto the Loadings.
    if nargin == 4
        scores = pcax.project(data, L);
    
    else
        assert(nargin == 5)
        % get the invSIGMA diagonal
        invCovar = 1 ./ sigma.^2;
        
        if isempty(lambda)
            scores = pcax.project(data, L, invCovar);
        else
            scores = pcax.project(data, L, invCovar, lambda);
        end
    end
    
    % compute probability
    if nargout == 1
        p = prod(normpdf(scores, 0, sigma)); 
    end
    
    if nargout >= 2
        logp = sum(lognormpdf(scores, 0, sigma));
        p = exp(logp);
    end
        
    % complete output arguments
    if naroug == 3  
        varargout{2} = scores;
    end
