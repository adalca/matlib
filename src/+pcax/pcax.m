classdef pcax < handle
    % PCAX A helper class for pca work
    % TODO add a tester function that covers all of the functions
    %
    % See Also pca
    
    properties (Constant)
    end
    
    methods (Static)
        Xhat = recon(L, scores, Xbar);
        scores = project(X, L, invCovar, lambda);
        ret = probeval(vox, meanVox, sigmas, L, meanStdVols, mask, name, lambda);
        [p, varargout] = prob(X, mu, sigma, L, lambda);
        walkImages = explorepc(L, scores, pcs, STDs, nStops);
    end
    
end

