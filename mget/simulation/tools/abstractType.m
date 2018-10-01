function out = abstractType(typeStruct, varargin)
% return type struct for the voxel or genetic types in imaging genetics simulation
%   markerStruct = voxelType(typeStruct) returns entire struct.
%
%   markerStruct = voxelType(typeStruct, typeNrs) returns struct with subtypes identified 
%       by values in typeNrs
%
%   markerStruct = voxelType(typeStruct, typeStr) returns struct with subtypes identified by 
%       typeStr string
%
%   markerStruct = voxelType(typeStruct, typeCellStr) returns struct with subtypes identified 
%       by typeCellStr cell of strings
%
% See also voxelType, geneticType
%
% Author: adalca [at] mit [dot] edu

    % get the fieldnames (types) and values of the type struct
    types = fieldnames(typeStruct);
    values = struct2array(typeStruct);
    
    % if a single argument is given, return the type array
    if nargin == 1
        out = typeStruct;
        
    % if 2 or 3 arguments are given:
    else
        
        % extract the query array / searchstrings
        query = varargin{1};
        
        if isnumeric(query)
            assert(nargin == 2, 'if argument is numeric, should only have that argument');
            
            for i = 1:numel(query)
                idx = find(values == query(i)); % assumes maybe types not sorted...
                assert(numel(idx) == 1, sprintf('could not find type %i', query(i))); 
                out.(types{idx}) = values(idx);
            end
            
        else
            
            % if it's a single search string, transform it into a cell
            if ischar(query)
                query = {query};
            end

            % if a third argument is provided, it should be the flag determining
            % reversing results (i.e. exclusing types that match strings)
            if nargin == 3
                opt = varargin{2};
                assert(islogical(opt.reverse));
            else
                opt.exact = false;
                opt.reverse = false;
            end
                
            
            assert(iscellstr(query), ...
                sprintf('arg should be a number array, a string or cell of strings. Found:%s', ...
                class(query)));
            
            globalfound = false(numel(values), 1);
            if opt.reverse, globalfound = ~globalfound; end
            for s = 1:numel(query)
                % find the entries that have this string
                if opt.exact
                    found = false(numel(values), 1);
                    for i = 1:numel(values)
                        found(i) = strcmp(types{i}, query{s});
                    end
                else
                    found = ~cellfun('isempty', strfind(types, query{s}));
                end
                
                % if required to reverse results, get all entries without this string
                if opt.reverse
                    globalfound = globalfound & ~found;
                else
                    globalfound = globalfound | found;
                end
            end
            
            % get indexes of results'
            idx = find(globalfound);
            assert(numel(idx) > 0, 'could not find given types');
            
            for i = idx'
                out.(types{i}) = values(i);
            end            
        end
    end
    
end