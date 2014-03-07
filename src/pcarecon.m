function Xhat = pcarecon(L, scores, Xbar)
% PCARECON reconstruct pca data point 
%   Xhat = pcarecon(L, scores) reconstructs the data point X_hat with given scores for the PCA space 
%       with loadings L. Assumes data X is centered; i.e. if not naturally centered, add X_bar to 
%       get actual image after reconstruction, or pass Xbar. 
%   returns the data points (M x nPoints) in original space.
%
%   Xhat = pcarecon(L, scores, Xbar) pass the mean.
%
%   L is PCA space loading images, M x N ('coeff' returned from MATLAB's pca())
%   scores is the N x nExperiments scores of this experiment in PCA space
%   Xbar (optional) is center of data in M x 1 space. 
%
% Contact: {adalca,rameshvs}@mit.edu

    narginchk(2, 3);
    Xhat = L * scores;
    
    if nargin == 3
        Xhat = Xhat + repmat(Xbar, [1, size(Xhat, 2)]);
    end
