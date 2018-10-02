function [I, C, Y] = simulateSimpleCausal(N, S, M, selM, labelNoise)
% a "shortcut" function which uses the main simulation for the specific case of
% genetics simulating only causal voxels, and only causal voxels generated via
% genetics influencing the label score
% 
%   e.g. run --- 
%   [I, C, Y] = simulateSimpleCausal(400, 1000, 100, 10, 0.1);


    % prepare the number and type of genetics, voxels, and additional arguments
    nMarkers = initType(geneticType, [0, 0, 0, 0, S, 0]);
    nVoxels = initType(voxelType, [selM, 0, 0, M-selM]);
    args = {'labelNoiseStd', labelNoise, 'labelContrib', [0, 0, 0, 1, 0]};
    
    % run the simulation
    [images, genetics, labels, weights] = simulateData(N, nMarkers, nVoxels, args{:});
    
    % extract which voxels were used (logical vector)
    exactOpt = struct('reverse', false, 'exact', true);
    gtVoxelTypes = typeIdx(@voxelType, 'GENINFL_CAUSAL',exactOpt);
    C = ismember(images.voxelTypes, gtVoxelTypes)';
    
    % clean renaming
    I = images.noisy;
    Y = labels;

    % wC = weights.voxelsToLabels;
    % gtGeneticTypes = typeIdx(@geneticType, 'EXPR_NONDIRCAUSAL_VOXCAUSAL', exactOpt);
    
end 



function idx = typeIdx(classType, str, varargin)
% return the indexes of the relevant types of genetics/voxels. Types are specified as
% string/cellstr in str, and the classType is @geneticType or @voxelType.

    idx = struct2array(classType(str, varargin{:}));
end