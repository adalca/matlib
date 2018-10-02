function labels = simulateLabels(images, genetics, weights, labelContrib, labelThr, noiseStd)
% SIMULATELABELS simulate the labels based on genetics and imaging
%   labels = simulateLabels(images, genetics, weights, labelContrib, labelThr, noiseStd)
%   simulates labels, see below for algorithm. labels output is a nSubjects
%   x 1 vector, where nSubjects is derived from images struct.
%
%   Inputs:
%       genetics                imagesstruct as returned by simulateImages
%       genetics                genetics struct as returned by simulateGenetics
%       weights                 weights struct as returned by simulateWeights
%       labelContrib            weight vector of the amount of contibution
%               from each of the 5 categories of relevant markers/voxels.
%       labelThr                threshold for logical label from
%               labelScore. labelScore has mean 0.
%       noiseStd                The standard deviation to the 0-mean noise
%                               to add to images.
%
%   Simulation:
%       For each of the four causitive groups (genetics expressed, genetics
%           not expressed, voxels affected by genetics, random voxels), do:
%       - score weights of contibutions from each marker/voxel * value
%               of marker/voxel.
%       Weight the four different categories based on labelContrib
%       Add noise to the overall score
%       Apply score threshold.
%
%   See Also: simulateData
%
%   File contact: www.mit.edu/~adalca 



    nSubjects = size(images.clean, 1);
    labelScores = zeros(nSubjects, 5);   
    assert(sum(labelContrib) == 1);
    curIdx = 1;
    opt.reverse = false; opt.exact = true;
    
    % genetics: NONEXPR_DIRCAUSAL
    idx = genetics.markerTypes == struct2array(geneticType('NONEXPR_DIRCAUSAL', opt));
    next = sum(idx);
    labelScores(:, 1) = getLocalScore(idx, genetics.markers, curIdx:next, weights.geneticsToLabels);
    curIdx = next + 1;
    
    % genetics: EXPR_DIRCAUSAL_VOXCAUSAL
    idx = genetics.markerTypes == struct2array(geneticType('EXPR_DIRCAUSAL_VOXCAUSAL', opt));
    next = curIdx + sum(idx) - 1;
    labelScores(:, 2) = getLocalScore(idx, genetics.markers, curIdx:next, weights.geneticsToLabels);
    curIdx = next + 1;
    
    % genetics: EXPR_DIRCAUSAL_NONVOXCAUSAL
    idx = genetics.markerTypes == struct2array(geneticType('EXPR_DIRCAUSAL_NONVOXCAUSAL',opt));
    next = curIdx + sum(idx) - 1;
    labelScores(:, 3) = getLocalScore(idx, genetics.markers, curIdx:next, weights.geneticsToLabels);
    curIdx = 1;
    
    % voxels: GENINFL_CAUSAL
    idx = images.voxelTypes == struct2array(voxelType('GENINFL_CAUSAL', opt));
    next = curIdx + sum(idx) - 1;
    labelScores(:, 4) = getLocalScore(idx, images.noisy, curIdx:next, weights.voxelsToLabels);
    curIdx = next + 1;
    
    % voxels: NONGENINFL_CAUSAL
    idx = images.voxelTypes == struct2array(voxelType('NONGENINFL_CAUSAL', opt));
    next = curIdx + sum(idx) - 1;
    labelScores(:, 5) = getLocalScore(idx, images.noisy, curIdx:next, weights.voxelsToLabels);
    
    % sum, add noise, and normalize scores. 
    labelScores = mean(labelScores .* repmat(labelContrib, [nSubjects, 1]), 2);
    labelScores = labelScores - mean(labelScores(:));
    labelScores = labelScores + normrnd(0, noiseStd, [nSubjects, 1]);
    
    % get final logical labels
    labels = labelScores < labelThr; 
end



function score = getLocalScore(signalMap, signalSrc, weightRange, weightSrc)

    assert(sum(signalMap) == numel(weightRange), ...
        sprintf('SignalMap sum:%i, weightRange elements:%i', ...
        sum(signalMap), numel(weightRange)));
    
    if sum(signalMap) > 0
        signal = signalSrc(:, signalMap);
        wts = weightSrc(weightRange);
        score = signal * wts;
    else
        score = 0;
    end
end
