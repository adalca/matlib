function typeStruct = initType(typeStruct, initVals)
% initiate the genetic/voxelType structure with the given values.
%   typeStruct = initType(typeStruct, initVals) initiate the genetic/voxelType structure with 
%   the given initial values. typeStruct is a struct, initValues are the given. 
%
% genetics order:
% 'NONEXPR_DIRCAUSAL', 'NONEXPR_NONDIRCAUSAL', 'EXPR_DIRCAUSAL_VOXCAUSAL', 
% 'EXPR_DIRCAUSAL_NONVOXCAUSAL', 'EXPR_NONDIRCAUSAL_VOXCAUSAL', 'EXPR_NONDIRCAUSAL_NONVOXCAUSAL'
%
% voxel order
% 'GENINFL_CAUSAL', 'NONGENINFL_CAUSAL', 'GENINFL_NONCAUSAL', 'NONGENINFL_NONCAUSAL'
%
% example: 
%   nMarkers = initType(geneticType(), [0, 0, 0, 10, 0, 0]);
%   nVoxels = initType(voxelType, [0, 10, 0, 90]);
%
% Author: adalca [at] mit [dot] edu


    types = fieldnames(typeStruct);

    if ~exist('initVals', 'var')
        initVals = zeros(numel(types), 1);
    end

    for i = 1:numel(types)
        typeStruct.(types{i}) = initVals(i);
    end
    