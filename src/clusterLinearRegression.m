function varargout = clusterLinearRegression(X, Y, K, varargin)
% CLUSTERLINEARREGRESSION simultaneous cluster and linear regression
%   clusterIdx = clusterLinearRegression(X, Y, K) simultaneously
%   cluster and linear regression fitting on [X, Y], looking for K, each of
%   which is fit to a linear regression.
%
%   clusterIdx = clusterLinearRegression(X, Y, K, clusterParam, clusterVal)
%       allows for several optional inputs (see below)
%
%   [clusterIdx, h] = clusterLinearRegression(...), if verbose == true, h,
%       the handle for the plot, is returned.
%
%   inputs:
%       X - Nx1 of independent variable
%       Y - Nx1 of dependent variable
%       K - the number of cluster
%
%   optional Param Value input pairs:
%       'nMaxReps', integer - number of maximum reps for the algorithm. 
%           default: 100
%       'nXfit', integer - the number of points for evaluating regresison
%           lines and computing inner distances
%           default: 1000
%       'verbose', logical - display data at each iteration or not, with
%        1/4-second interruptions
%
%   Algorithm:
%       similar to k-means, initialize some linear regression lines, 
%       associate each point to a regression lines based on euclidean
%       distance, and re-fit regressions.
%
%   Initialization:
%       current initialization might be limited!!! Currently, fit one
%       regression line, and slightly alter the slope for different
%       clusters. 
%       TODO: It may be better to choose 2 random points or something like
%       that, although that will be more unstable.
%
%   Example:
%       x = linspace(0, 1, 100)';
%       r = rand(100, 1);
%       y = zeros(size(x));
%       y(r < 0.5) = -0.1 + 2.0*x(r < 0.5);
%       y(r >= 0.5) = -0.15 + 1.5*x(r >= 0.5);
%       y = y + normrnd(0, 0.1, 100, 1);
%       cIdx = clusterLinearRegression(x, y, 2);
%
%   Author: Adrian V. Dalca
%   Edit: May 5, 2013
    
    % parse inputs
    [X, Y, K, inputs] = parseInput(X, Y, K, varargin{:});
    
    % x bins for fitting
    xfit = linspace(min(X), max(X), inputs.nXfit);
    
    
    % initialize with several regression lines
    initOffFactors = linspace(0.9, 1.1, K);
    p = polyfit(X, Y, 1);
    pfit = repmat(p, [K, 1]);
    for i = 1:K
        pfit(i, 1) = pfit(i, 1) * initOffFactors(i);
    end
    
    % display if verbose
    if inputs.verbose
        h = figure('units', 'pixels', 'outerposition', [0 0 1500 800]);
        clf; hold on;
    end
    
    % go through iterations
    for i = 1:inputs.nMaxReps
        
        % get clusters
        minDists = zeros(K, numel(X));
        for k = 1:K
            yfit = polyval(pfit(k, :), xfit);
            minDists(k, :) = minPairwiseDist(X, Y, xfit, yfit)';
        end
        [~, clusterIdx] = min(minDists, [], 1);
              
        % run regressions
        for k = 1:K
            pfit(k, :) = polyfit(X(clusterIdx == k), Y(clusterIdx == k), 1);
        end
        
        % visualize
        if inputs.verbose
            clf; hold on;
            cmap = jet(K);
            for k = 1:K
                plot(X(clusterIdx == k), Y(clusterIdx == k), ...
                    'o', 'Color', cmap(k, :)); 
                yfit = polyval(pfit(k, :), xfit);
                plot(xfit, yfit, ...
                    '-', 'Color', cmap(k, :)); 
            end
            pause(1/4);
        end
        
        % convergence
        if i > 1 && all(clusterIdx == prevClusterIdx)
            fprintf(1, 'Converged in %d iterations\n', i);
            break;
        end
        prevClusterIdx = clusterIdx;
    end
    
    % give warning if quit early
    if ~all(clusterIdx == prevClusterIdx)
        assert(i == inputs.nMaxReps);
        fprintf(2, 'Warning: reached maximum repetitions, did not converge\n');
    end
    
    % outputs
    varargout{1} = clusterIdx;
    if inputs.verbose
        varargout{2} = h;
    end
end
    

function d1 = minPairwiseDist(X, Y, xfit, yfit)
    pts1 = [X(:), Y(:)];
    pts2 = [xfit(:), yfit(:)];
    d1 = pdist2(pts1, pts2);
    d1 = min(d1, [], 2);
end


function [X, Y, K, inputs] = parseInput(X, Y, K, varargin)
    p = inputParser();
    p.addRequired('X', @isnumeric) 
    p.addRequired('Y', @isnumeric)
    p.addRequired('K', @(x) ( isnumeric(x) && x > 1))
    p.addParamValue('nMaxReps', 100, @isnumeric);
    p.addParamValue('nXfit', 1000, @isnumeric);
    p.addParamValue('verbose', true, @islogical);
    p.parse(X, Y, K, varargin{:});
    
    inputs = p.Results;
    X = inputs.X;
    Y = inputs.Y;
    K = inputs.K;
end