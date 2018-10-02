function nElements = nElementsOfType(typeStruct, typeStrings, varargin)
% return the number of elements of the given type in the typeStruct
%   nElements = nElementsOfType(typeStruct, typeStrings) returns the number of elements of types 
%       given by typeStrings (cell of strings) in the typeStruct. 
%
%   nElements = nElementsOfType(typeStruct, typeStrings, opt) returns the number of elements of 
%       types  given by typeStrings (cell of strings) in the typeStruct. opt are the options
%       taken by abstractType()
%
%   Example: 
%       % build a genetics types struct
%       nMarkersStruct = initType(geneticType(), [0, 0, 0, 10, 0, 0]);
%       % get the number of elements that match the type '_VOXCAUSAL'
%       nElementsOfType(nMarkersStruct, {'_VOXCAUSAL'})
%
%   See Also: initType, geneticType, voxelType
%
% Author: adalca [at] mit [dot] edu



    nElements = sum(struct2array(abstractType(typeStruct, typeStrings, varargin{:})));
    
end