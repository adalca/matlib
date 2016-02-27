function [Xhat, invBb, newSigma] = inpaintWithGaussConditional(X, mu, covar)
% INPAINTWITHGAUSSCONDITIONAL inpaint missing values of a feature vector given the gaussian
% distribution it's drawn from
%
% Xhat = inpaintWithGaussConditional(X, mu, covar) inpaint missing values of a feature
% vector given the gaussian distribution it's drawn from. 
%
% X is N-by-1, or N-by-P if the same values are missing in all P column vectors. The unknowns values
% are marked as NANs, mu is N-by-1, covar is N-by-N.
%
% Xhat is the same size as X. 
%
% [Xhat, B, newSigma] = inpaintWithGaussConditional(X, mu, covar) also return B = covar(valid,
% valid) and the new Sigma
%
% TODO: compare with pinv, inv. Perhaps return Binv?

    % some input checking
    narginchk(3, 3);
    
    % if X is a matrix, all valid maps must match for this method implementation.
    assert(all(any(isnan(X), 2) == all(isnan(X), 2)));
    
    % check that covariance size makes sense
    assert(ismatrix(covar) && size(covar, 1) == size(covar, 2) && size(covar, 1) == size(X, 1));

    % subtract the mean
    X = bsxfun(@minus, X, mu);
    
    % masks
    invalid = isnan(X(:, 1));
    valid = ~invalid;   

    % prepare useful variables
    b = X(valid, :);    % extract the known features
    B = covar(valid, valid);   % covariance of known features
    C = covar(valid, invalid); % cross-covariance of known to unknown features.
    
    % compute C' * inv(B) * b
    Xhat = X;
    if rank(B) == size(B, 1)
        invBb = B \ b;
    else
        warning('Gaussian Conditional Inpainting: using pinv because of low rank covariance matrix');
        invBb = pinv(B) * b; % This seems to be better than B\b when B is low rank
    end
    Xhat(invalid, :) = C' * invBb; % TODO: compare with pinv, inv. Perhaps return Binv?
    
    % add back the mean
    Xhat = bsxfun(@plus, Xhat, mu);
    
    % make sure the returned X is clean
    assert(isclean(Xhat));
    
    % newSigma of unknowns
    if nargout > 2
        A = covar(invalid, invalid);
        newSigma = A - C' * (B \ C);
    end
end