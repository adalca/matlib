function idx = idxOfType(typeClass, str, typesVector, varargin)
% returns the indexes in typesVector of the type "str" from class
% typeClass. TypeClass can be something like @voxelType or @geneticsType

    % get the ids (numbers) of the types specified in str.
    id = struct2array(typeClass(str, varargin{:}));
    
    % get a logical vector of whether the ids match the types vector
    idx = ismember(typesVector, id)';
end