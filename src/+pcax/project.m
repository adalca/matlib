function scores = project(X, L, invCovar, lambda)
% PROJECT project data points onto PCA space
%   scores = project(X, L) project data points X onto PCA space defined by loadings L. Assumes 
%       data X is centered! X is data, M x nExperiments where M is dimension (e.g. number of
%       voxels). L is PCA space loading images, M x N ('coeff' returned from MATLAB's pca()). 
%       returns score, the N x nExperiments scores. 
%
%   scores = project(X, L, invCovar) allows for regularized projection. invCovar is the inverse 
%       covariance matrix from the PCA space (diagnoal), N x N (or Nx1 vector representing diagonal)
%       The regulaization factor is estimated as 1 ./ mean(invCovar);
%
%   scores = project(X, L, invCovar, lambda) allows for specification of lambda as well.
%
%   Warning: be careful about centered and non-centered data. We tend to work with centered data,
%   and subtract/add the mean when necessary.
%
%   Example:
%   X = bsxfun(@minus, X,  mean(X, 2))
%   [c, s] = pca(X');
%   z = pcax.project(X, c)';
%   isclose(s, z)'
%
% Contact: {adalca,rameshvs}@mit.edu

    % check inputs
    narginchk(2, 4);
    assert(size(L, 1) == size(X, 1)); 
    assert(isclean(X));

    if nargin == 3 || nargin == 4
        assert(size(invCovar, 1) == size(L, 2) || size(invCovar, 2) == size(L, 2));
        if isvector(invCovar)
            invCovar = diag(invCovar);
        end
    end
    
    if nargin == 3
        assert(size(invCovar, 1) == size(invCovar, 2));
        assert(size(invCovar, 1) == size(L, 2));
        
        warning('estimating lambda')
        lambda = 1./mean(diag(invCovar));
    end
        
    % compute L' * L + sigmainv
    denom = L' * L;
    assert(~any(isnan(denom(:))));
    
    e = eye(size(L, 2));
    if ~all(all(isclose(denom, e))); %all(denom(:) == e(:))
        warning('project: L''L is not identity');
    end
        
    if nargin == 4
        denom = denom + lambda * invCovar;
    end
    assert(~any(isnan(denom(:))));
        
    % do projection, i.e. theta = (L' * L + sigmainv)^{-1} * L' * X
    scores = denom \ (L' * X);
    assert(~any(isnan(scores(:))));
