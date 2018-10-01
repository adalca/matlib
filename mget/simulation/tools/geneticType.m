function markerStruct = geneticType(varargin)
% return type struct for the genetic marker types in imaging genetics simulation
%   markerStruct = geneticType() returns entire geneticType struct.
%
%   markerStruct = geneticType(typeNrs) returns geneticType struct with subtypes identified 
%       by values in typeNrs
%
%   markerStruct = geneticType(typeStr) returns geneticType struct with subtypes identified by 
%       typeStr string
%
%   markerStruct = geneticType(typeCellStr) returns geneticType struct with subtypes identified 
%       by typeCellStr cell of strings
%
% Examples:
%     out = geneticType()
%     out = 
%                      NONEXPR_DIRCAUSAL: 1
%                   NONEXPR_NONDIRCAUSAL: 2
%               EXPR_DIRCAUSAL_VOXCAUSAL: 3
%            EXPR_DIRCAUSAL_NONVOXCAUSAL: 4
%            EXPR_NONDIRCAUSAL_VOXCAUSAL: 5
%         EXPR_NONDIRCAUSAL_NONVOXCAUSAL: 6
% 
%     out = geneticType(2:5)
%     out = 
%                NONEXPR_NONDIRCAUSAL: 2
%            EXPR_DIRCAUSAL_VOXCAUSAL: 3
%         EXPR_DIRCAUSAL_NONVOXCAUSAL: 4
%         EXPR_NONDIRCAUSAL_VOXCAUSAL: 5
%
%     out = geneticType('EXPR_DIRCAUSAL_VOXCAUSAL')
%     out = 
%         EXPR_DIRCAUSAL_VOXCAUSAL: 3
%   
%     out = geneticType({'EXPR_DIRCAUSAL_VOXCAUSAL', 'EXPR_NONDIRCAUSAL_VOXCAUSAL'})
%     out = 
%         EXPR_DIRCAUSAL_VOXCAUSAL: 3
%
% See also abstractType, voxelType
%
% Author: adalca [at] mit [dot] edu



    markerTypes.NONEXPR_DIRCAUSAL = 1;
    markerTypes.NONEXPR_NONDIRCAUSAL = 2;
    markerTypes.EXPR_DIRCAUSAL_VOXCAUSAL = 3;
    markerTypes.EXPR_DIRCAUSAL_NONVOXCAUSAL = 4;
    markerTypes.EXPR_NONDIRCAUSAL_VOXCAUSAL = 5;
    markerTypes.EXPR_NONDIRCAUSAL_NONVOXCAUSAL = 6;

    markerStruct = abstractType(markerTypes, varargin{:});
end
        