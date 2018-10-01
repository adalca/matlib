function out = voxelType(varargin)
% return type struct for the voxel types in imaging genetics simulation
%   markerStruct = voxelType() returns entire voxelType struct.
%
%   markerStruct = voxelType(typeNrs) returns voxelType struct with subtypes identified 
%       by values in typeNrs
%
%   markerStruct = voxelType(typeStr) returns voxelType struct with subtypes identified by 
%       typeStr string
%
%   markerStruct = voxelType(typeCellStr) returns voxelType struct with subtypes identified 
%       by typeCellStr cell of strings
%
% See also abstractType, geneticType
%
% Author: adalca [at] mit [dot] edu


    voxelTypes.GENINFL_CAUSAL = 1;
    voxelTypes.NONGENINFL_CAUSAL = 2;
    voxelTypes.GENINFL_NONCAUSAL = 3;
    voxelTypes.NONGENINFL_NONCAUSAL = 4;

    out = abstractType(voxelTypes, varargin{:});
end
        