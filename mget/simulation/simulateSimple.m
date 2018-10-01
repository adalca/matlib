function [genetics, images, Y, weights] = ...
    simulateSimple(N, S, SCaus, SNonCaus, M, MCaus, MNonCaus, nOnlyCausVox, simOptions)
% simulateSimple simulates the simple case of genetics influencing voxels which
% are further causal to Y, and genetics influencing some voxels which are not
% related to Y. Uses the simulateData()
%
%   inputs: N - nSubjects
%       S - nSNPs. SCaus - nSnps affecting causal voxels. SNonCaus - nSnps
%           affecting non-causal voxels
%       M - nVoxels. MCaus - nVoxels related to Y. MNonCaus - nVoxels not
%           related to Y but influenced by snps.
%
%   outputs: 
%       structG has fields: G, causIdx, nonCausIdx
%       structI has fields: I, causIdx, nonCausIdx
%       Y is labels (N x 1)
%       weights has fields: geneticsToCausalVoxels, geneticsToNonCausalVoxels,
%           geneticsToLabels, voxelsToLabels


    
    

    % prepare the number and type of genetics
    uselessS = S - SCaus - SNonCaus;
    nMarkers = initType(geneticType, [0, uselessS, 0, 0, SCaus, SNonCaus]);
    
    % prepare the number and type of voxels
    uselessM = M - MCaus - MNonCaus;
    nVoxels = initType(voxelType, [MCaus, nOnlyCausVox, MNonCaus, uselessM]);
    
    % set the label contributions [only relevant to geneticsFirst run mode]
    if ~isfield(simOptions, 'labelContrib')
        simOptions.labelContrib = [0, 0, 0, 1, 0];
    end
    
    % run the simulation
    [images, genetics, Y, weights] = simulateData(N, nMarkers, nVoxels, simOptions);
    
    
    
    % Gather results into a format we're happy with in the debugging.
    % TODO - should probably do these directly in simulateData
    
    % useful structure for extracting the right indexes
    exactOpt = struct('reverse', false, 'exact', true);
    
    % extract which voxels were used (logical vector), and setup img struct.
    images.causIdx = idxOfType(@voxelType, 'GENINFL_CAUSAL', images.voxelTypes, exactOpt);
    images.nonCausIdx = idxOfType(@voxelType, 'GENINFL_NONCAUSAL', images.voxelTypes, exactOpt);    
    images.I = images.noisy;
    
    % extract which voxels were used (logical vector), and setup img struct.
    genetics.causIdx = idxOfType(@geneticType, 'EXPR_NONDIRCAUSAL_VOXCAUSAL', genetics.markerTypes, exactOpt);
    genetics.nonCausIdx = idxOfType(@geneticType, 'EXPR_NONDIRCAUSAL_NONVOXCAUSAL', genetics.markerTypes, exactOpt);    
    genetics.G = genetics.markers;
end 

