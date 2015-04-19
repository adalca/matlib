function varargout = clusterGLM(X, Y, K, varargin)
% CLUSTERGLM simultaneous cluster and GLM regression
%   clusterIdx = clusterGLM(X, Y, K) simultaneously cluster and GLM regression fitting on [X, Y],
%   looking for K, each of which is fit to a linear regression.
%
%   clusterIdx = clusterGLM(X, Y, K, clusterParam, clusterVal) allows for several optional inputs
%   (see below)
%
%   [clusterIdx, h] = clusterGLM(...), if verbose == true, h, the handle for the plot, is returned
%
%   inputs:
%       X - Nx1 of independent variable
%       Y - Nx1 of dependent variable
%       K - the number of cluster
%
%   optional clusterParam/clusterVal input pairs:
%       - 'nMaxReps', integer - number of maximum reps for the algorithm. default: 100
%       - 'nXfit', integer - the number of points for evaluating regresison
%       lines and computing inner distances default: 1000
%       - 'verbose', logical - display data at each iteration or not, with
%       1/4-second interruptions
%       - 'link' - a cell of K strings of the link functions for the GLM. 
%       default is {'identity', 'identity', ...}
%       - 'distr' - a cell of K strings of the distr for the GLM. 
%       default is {'normal', 'normal', ...}
%       - 'constant' - 'off' or 'on' whether a constant factor (intercept) should be used. 
%       Passed to GLM via 'constant' 
%
%   Algorithm:
%       similar to k-means, initialize some linear regression lines, 
%       associate each point to a GLM lines based on euclidean distance, and re-fit GLM regressions
%
%   Initialization:
%       current initialization might be limited. Currently, fit one
%       regression line, and slightly alter the slope for different
%       clusters. 
%       TODO: It may be better to choose 2 random points or something like
%       that, although that will be more unstable.
%
%   Example:
%       see testClusterGLM
%
%   TODO:
%       estimate variance by doing weighted estimation. 
%       use variance or std as 'confidence' when assigning points to each cluster.
%
%   Requires: ifelse
%
%   Author: Adrian V. Dalca
%   Edit: July, 2014
    
    % parse inputs
    [X, Y, K, inputs] = parseInput(X, Y, K, varargin{:});
    
    % initialize with several regression lines
    initOffFactors = linspace(0.9, 1.1, K);
    p = glmfit(X, Y, 'normal', 'constant', inputs.constant);
    pfit = repmat(p, [1, K]);
    for i = 1:K
        % using pfit(end, .) since size(pfit, 1) could be 0 or 1
        pfit(end, i) = pfit(end, i) * initOffFactors(i); 
    end
    
    % display if verbose mode
    if inputs.verbose
        h = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
        clf; hold on;
    end
    
    % go through iterations
    for i = 1:inputs.nMaxReps
        
        % hard assignment of points to clusters
        residuals = zeros(K, numel(X));
        for k = 1:K
            link = ifelse(i == 1, 'identity', inputs.link{k});
            yfit = glmval(pfit(:, k), X, link, 'constant', inputs.constant);
            residuals(k, :) = abs(Y - yfit);
        end
        [~, clustIdx] = min(residuals, [], 1);

        % visualize if verbose mode
        if inputs.verbose     
            viewClusters(X, Y, residuals, K, inputs, pfit, i, clustIdx);
        end
		
        % fit regressions
        for k = 1:K
            kc = clustIdx == k;
            
            if sum(kc) > 0
                [pfit(:, k), ~, stats(k)] = glmfit(X(kc), Y(kc), ...
                    inputs.distr{k}, 'link', inputs.link{k}, 'constant', inputs.constant);
            else
                warning('lost a cluster. fitting to entire data');
                pfit(:, k) = glmfit(X(:), Y(:), ...
                    inputs.distr{k}, 'link', inputs.link{k}, 'constant', inputs.constant);
                
                % add some small noise to avoid multiple clusters fitting to same data;
                pfit(:, k) = pfit(:, k) + (rand-0.5) * 0.001 * pfit(:, k); 
            end
        end
        
        % check for convergence
        if i > 1 && all(clustIdx == prevClusterIdx)
            fprintf(1, 'Converged in %d iterations\n', i);
            break;
        end
        prevClusterIdx = clustIdx;
    end
    
    % give warning if quit early
    if ~all(clustIdx == prevClusterIdx)
        assert(i == inputs.nMaxReps);
        fprintf(2, 'Warning: reached maximum repetitions, did not converge\n');
    end
    
    % outputs
    varargout{1} = clustIdx;
    if inputs.verbose
        varargout{2} = h;
        varargout{3} = pfit;
    end
end
    

function [X, Y, K, inputs] = parseInput(X, Y, K, varargin)
    p = inputParser();
    p.addRequired('X', @isnumeric) 
    p.addRequired('Y', @isnumeric)
    p.addRequired('K', @(x) ( isnumeric(x) && x > 1))
    p.addParamValue('nMaxReps', 100, @isnumeric);
    p.addParamValue('nXfit', 1000, @isnumeric);
    p.addParamValue('verbose', true, @islogical);
    p.addParamValue('link', repmat({'identity'}, [1, K]), @iscell);
    p.addParamValue('distr', repmat({'normal'}, [1, K]), @iscell);
    p.addParamValue('constant', 'off', @ischar);
    p.parse(X, Y, K, varargin{:});
    
    inputs = p.Results;
    X = inputs.X;
    Y = inputs.Y;
    K = inputs.K;
end


function viewClusters(X, Y, residuals, K, inputs, pfit, i, clustIdx)

    % x bins for fitting
    xfit = linspace(min(X), max(X), inputs.nXfit);

    clf; cmap = jet(K);
    for k = 1:K
        % plot points and line of kth cluster in first plot
        subplot(1, 2, 1); hold on;
        plot(X(clustIdx == k), Y(clustIdx == k), '.', 'Color', cmap(k, :));
        link = ifelse(i == 1, 'identity', inputs.link{k});
        yfit = glmval(pfit(:, k), xfit, link, 'constant', inputs.constant);
        plot(xfit, yfit, '-', 'Color', cmap(k, :));

        % plot the residuals for the points in the kth cluster in the second plot
        subplot(1, 2, 2); hold on;
        plot(X(clustIdx == k), residuals(k, clustIdx == k)', '.', 'Color', cmap(k, :));
    end
%     pause();
end
