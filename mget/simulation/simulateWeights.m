function weights = simulateWeights(nMarkers, nVoxels, varargin)
% SIMULATEWEIGHTS simulates weights for imaging genetics projects
%   weights = simulateWeights(nMarkers, nVoxels) simulates 
%   3 types of weights for the imaging genetics projects. default distribution is set in
%   sampleWeights()
%
%   weights = simulateWeights(nMarkers, nVoxels, distName, arg1, ...) allows for specific distributions
%   for the weight sampling.
%       distName - name of distribution as taken by random(...) in stats toolbox.
%       arg1, ... - arguments as needed by random(...) for selected distribution
%
%       weights.geneticsToCausalVoxels    
%           the weights of the expressed markers (S) for each causal voxel (V). 
%           The weights are normalized per voxel. [S x V]
%       weights.geneticsToNonCausalVoxels    
%           the weights of the expressed markers (S) for each non-causal voxel (V). 
%           The weights are normalized per voxel. [S x V]
%       weights.geneticsToLabels    the weights of all directly-causal markers 
%           for the label. [S x 1] 
%       weights.voxelsToLabels      the weights of all causal voxels [V x 1] 
%
%   See Also: sampleWeights()
%
%   File contact: www.mit.edu/~adalca 



    % initiate options for getting the number of relevant markers/voxels via abstractType
    exactOpt = struct('reverse', false, 'exact', true);

    % weights of makers affecting causal voxels. The weights sum to 1 for each voxel.
    vGened = nElementsOfType(nVoxels, {'GENINFL_CAUSAL'}, exactOpt);
    mCausalThroughImg = nElementsOfType(nMarkers, '_VOXCAUSAL');
    geneticsToCausalVoxels = sampleWeights([mCausalThroughImg, vGened], varargin{:});
%     weights.geneticsToCausalVoxels = normalizeVecs(geneticsToCausalVoxels, 2, 1);
weights.geneticsToCausalVoxels = geneticsToCausalVoxels;
% weights.geneticsToCausalVoxels = normalizeVecs(geneticsToCausalVoxels, 1, 1);    

    % weights of makers affecting nonCausal voxels. The weights sum to 1 for each voxel.
    vGened = nElementsOfType(nVoxels, {'GENINFL_NONCAUSAL'}, exactOpt);
    mNonCausal = nElementsOfType(nMarkers, '_NONVOXCAUSAL');
    geneticsToNonCausalVoxels = sampleWeights([mNonCausal, vGened], varargin{:});
%     weights.geneticsToNonCausalVoxels = normalizeVecs(geneticsToNonCausalVoxels, 2, 1);
weights.geneticsToNonCausalVoxels = geneticsToNonCausalVoxels;
% weights.geneticsToNonCausalVoxels = normalizeVecs(geneticsToNonCausalVoxels, 1, 1);
        
    % weight of markers directly causal to label
    mCausal = nElementsOfType(nMarkers, 'EXPR_DIRCAUSAL');
    geneticsToLabels = sampleWeights(mCausal, varargin{:});
%     weights.geneticsToLabels = normalizeVecs(geneticsToLabels, 2, 1);
weights.geneticsToLabels = geneticsToLabels;

    % weight of voxels effect to label
    vCausal = nElementsOfType(nVoxels, '_CAUSAL');
    voxelsToLabels = sampleWeights(vCausal, varargin{:});
%     weights.voxelsToLabels = normalizeVecs(voxelsToLabels, 2, 1);
weights.voxelsToLabels = voxelsToLabels;


% DEBUG
% load weights weights;
% 
% weights.geneticsToLabels = normalizeVecs(geneticsToLabels, 2, 1);
% weights.voxelsToLabels = normalizeVecs(voxelsToLabels, 2, 1);
% weights.geneticsToNonCausalVoxels = normalizeVecs(weights.geneticsToNonCausalVoxels, 2, 1);
% weights.geneticsToCausalVoxels = normalizeVecs(weights.geneticsToCausalVoxels, 2, 1);

end
