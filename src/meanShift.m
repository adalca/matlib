function [bestMean, bestScore, weights, stats] = meanShift(X, varargin)
% MEANSHIFT compute the mean shift estimate 
%   [bestMean, bestScore, weights, stats] = meanShift(X) compute the mean shift estimate of
%   the given vector using a fixed sigma. stats is a structure with
%     stats.scores - the scores of all the replicate
%     stats.means - the mean estiamtes of all the replicates
%     stats.stopIters - the iteration number each replicate stopped on 
%     stats.thr - used threshold
%     stats.sigma - used sigma
%     stats.nRange - used nRange
%     stats.xRange - used xRange (max(x) - min(x))/nRange, for now
%
%   [bestMean, bestScore, weights, stats] = meanShift(X, Param1, Value1, ...) allows from
%   several param/value pairs:
%       'sigma' - the kernel sigma (or h) to be used. 
%           default: bandwidth suggested by Bowman and Azzalini (1997) p.31
%       'nReplicates' - the number of replicates of the method. deault: 10
%       'repMethod' - the replicate initialization method - 
%           'percentiles' (span nReplicates percentiles from 0 to 100) or 'random'. 
%       'thr' - the stopping threshold for mean-shift
%       'maxIters' - the max number of iterations for a meanshift algo
%       'nRange' - the number of points on the support grid of X. This is used for inner product
%           computation of scores.
%
% Authors: Adrian Dalca, Katie Bouman, Ramesh Sridharan 
%   (adalca,klbouman,rameshvs@csail.mit.edu)

    % process inputs
    [X, W, sigma, nReplicates, repMethod, thr, maxIters, nRange] = ...
        checkInputs(X, varargin{:});
    
    % compute the grid and histogram of the points. 
    % This will be used to compute the score of every estimate.
    xRange = linspace(min(X), max(X), nRange);
    xRangeDel = (max(X) - min(X))/(nRange-1);
    xHist = hist(X, xRange);
    
    % Compute initializations
    switch repMethod
        case 'percentiles'
            if nReplicates > 1
                percentiles = linspace(0, 100, nReplicates);
            else
                percentiles = 50;
            end
            inits = prctile(X, percentiles);
        case 'random'
            inits = unifrnd(max(X), min(X), [nReplicates, 1]);
    end
            
    % go through the replicates
    scores = zeros(nReplicates, 1); 
    means = zeros(nReplicates, 1);
    stopIters = inf(nReplicates, 1);
    for i = 1:nReplicates

        % initiate mean estimates and changes
        meanEst = inits(i);
        change = inf(numel(meanEst), 1);

        % start iterations
        iter = 0;
        while (any(change > thr) && iter < maxIters)

            % compute weights
            xDiff = bsxfun(@minus, X, meanEst);
            weights = exp(- 0.5 * (xDiff ./ sigma) .^ 2); 
            weights = weights .* W;
            assert(sum(weights) ~= 0, 'Weights sum is 0. Increase sigma (%f) if appropriate', sigma);

            % compute the new mean estimate
            meanEstOld = meanEst;
            meanEst = sum(weights .* X) ./ sum(weights);

            % update iterations variables
            change = abs(meanEst - meanEstOld);
            iter = iter + 1;
        end
        
        % add to means.
        means(i) = meanEst;
        
        % compute score (inner product of current gaussian guess)
        g = gaussKernel((xRange - meanEst) ./ sigma);
        g = g ./ sum(g);
        scores(i) = sum(xHist .* g .* xRangeDel);
        
        % record the ending iteration
        stopIters(i) = iter;
    end
    
    % get the best score, and the respecitve mean estimate and weights
    [bestScore, mi] = max(scores);
    bestMean = means(mi);
    
    xDiff = bsxfun(@minus, X, bestMean);
    weights = exp(- (xDiff .^ 2) / (2 * sigma ^ 2));
    
    % stats
    stats.scores = scores;
    stats.means = means;
    stats.stopIters = stopIters;
    stats.thr = thr;
    stats.sigma = sigma;
    stats.nRange = nRange;
    stats.xRange = xRange;
end

function [X, W, sigma, nReplicates, repMethod, thr, maxIters, nRange] = checkInputs(varargin)

    p = inputParser();
    p.addRequired('X', @isvector);
    p.addParameter('sigma', -1, @isnumeric);
    p.addParameter('nReplicates', 10, @isnumeric);
    p.addParameter('repMethod', 'percentiles', @(x) strcmp(x, {'percentiles', 'random'}));
    p.addParameter('thr', -1, @isnumeric);
    p.addParameter('maxIters', 100, @isnumeric);
    p.addParameter('weights', [], @isnumeric);
    p.addParameter('nRange', -1, @isnumeric);
    p.parse(varargin{:});
    
    X = double(p.Results.X(:));
    nReplicates = p.Results.nReplicates;
    repMethod = p.Results.repMethod;
    maxIters = p.Results.maxIters;
    
    % proper default for sigma
    sigma = p.Results.sigma;
    if any(strcmp(p.UsingDefaults, 'sigma'))
        
        % optimal bandwidth suggested by Bowman and Azzalini (1997) p.31
        % these next few lines for h are taken from ksr.m, By Yi Cao 
        sigma = median(abs(X-median(X)))/0.6745*(4/3/numel(X))^0.2;
        assert(sigma > 0);
    end
    
    % proper default for thr, this is very heuristicky.
    if any(strcmp(p.UsingDefaults, 'thr'))
        thr = sigma / 100;
    end
    
    % proper default for nRange, this is very heuristicky.
    if any(strcmp(p.UsingDefaults, 'nRange'))
        
        nRange = max(numel(X) / 10, 2);
    end    

    W = p.Results.weights;
    if isempty(W)
        W = ones(size(X));
    end
    
end

function g = gaussKernel(delt)

    g = exp( - 0.5 * delt .^ 2 ) ./ sqrt(2 * pi);
end
