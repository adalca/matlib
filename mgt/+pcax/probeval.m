function ret = probeval(vox, meanVox, sigmas, L, meanStdVols, mask, name, lambda)
% evaluate probability under pca model and with normal (gaussian) model of projection

    ret.vox = vox;

    % get the probability under the pca model
    if nargin == 8
        [ret.logp, ret.scores] = pcax.prob(meanVox, sigmas, vox, L, lambda);
    else
        [ret.logp, ret.scores] = pcax.prob(meanVox, sigmas, vox, L);
    end
    
    % reconstruct the volume from the pca projection
    ret.recon = within([0, 1], pcax.recon(L, ret.scores, meanVox));
    
    % compute the cost under a gaussian model for the projection
    ret.logn = sum(log(normpdf(ret.recon, vox, meanStdVols)));
    
    % compute 3D volumes
    ret.vol = maskvox2vol(ret.vox, mask);
    ret.reconvol = maskvox2vol(ret.recon, mask);
    
    % print if verbose
    fprintf('%s: logp = %f, logn = %f\n', name, ret.logp, ret.logn);
    
    
end
