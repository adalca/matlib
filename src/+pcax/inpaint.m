function Xhat = inpaint(X, varargin)
% inpaint (recover) missing features in X given a PCA space
%   Xhat = inpaint(X, L, S) inpaint missing features in X given a PCA space via PCA loadings L and
%   PCA eigenvalues S. X should be of size M x nExperiments, L is PCA space loading images, M x N
%   ('coeff' returned from MATLAB's pca()). S is a vector of size N or a diagnoal NxN matrix.
%
%   inpaint(X, C) inpaint missing features in X given a M x M PCA covariance matrix
%
% Algorithm:
%   reconstruct a via p(a|b) ~ N(C' inv(B) b, A - (C' inv(B) C))
%   where a is the vector of missing data and b is the vector of known data
%   and the covariance of [a; b] is block matrix [A C'; C B]
%
%   source: https://gbhqed.wordpress.com/2010/02/21/conditional-and-marginal-distributions-of-a-multivariate-gaussian/ 
%
% Contact: {klbouman,adalca}@csail.mit.edu

    % inputs
    [X, covar] = parseInputs(X, varargin{:});
    
    % masks
    invalid = isnan(X(:, 1));
    valid = ~invalid;   

    % prepare useful variables
    b = X(valid, :);    % extract the known features
    B = covar(valid, valid);   % covariance of known features
    C = covar(valid, invalid); % cross-covariance of known to unknown features.
    
    % compute C' * inv(B) * b
    Xhat = X;
    Xhat(invalid, :) = C' * (B \ b);
    
    assert(isclean(Xhat));
end

function [X, covar] = parseInputs(X, varargin)

    % get covariance
    narginchk(2, 3);
    if nargin == 3
        L = varargin{1};
        S = varargin{2};
        if isvector(S)
            S = diag(S);
        end
        % U * diag(Sigma) * inv(U)
        covar = L * S / L;
    else
        covar = varargin{1};
    end
    
    % if X is a matrix, all valid maps must match for this method implementation.
    assert(all(any(isnan(X), 2) == all(isnan(X), 2)));
    
    % check that covariance size makes sense
    assert(ismatrix(covar) && size(covar, 1) == size(covar, 2) && size(covar, 1) == size(X, 1));
end
