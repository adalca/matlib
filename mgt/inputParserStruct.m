classdef inputParserStruct < inputParser
    %inputParserStruct extends the inputParser to allow for 
    %   Required Parameter Values within a struct. 
    %
    %   - use p = inputParserStruct; instead of p.inputParser;
    %   - can use any functions of inputParser
    %   - use p.addRequiredParamValue(struct, ...); instead of p.addParamValue(...);, which
    %   will check for the field existing in the struct before adding the paramater-value pair.
    
    methods
        function obj = addRequiredParamValue(obj, s, field, varargin)
            assert(isfield(s, field), '%s is not a field', field);
            obj.addParamValue(field, s.(field), varargin{:});
        end
    end
end
