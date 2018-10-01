classdef superStruct < handle
%
% TODO: might be similar in concept to dictionary ?
%
%
% Project: Analysis of clinical datasets
% Authors: Adrian Dalca, Ramesh Sridharan
% Contact: {adalca,rameshvs}@csail.mit.edu
    
    
    
    properties
        sStruct;
        sFieldnames;
        nEntries;
    end
    
    
    
    methods
        
        function ss = superStruct(varargin)
            structParams = cell(2*nargin, 1);
            structParams((1:nargin)*2-1) = varargin;
            ss.sStruct = struct(structParams{:});
            ss.sFieldnames = varargin;
            ss.nEntries = 0;
        end
        
        function ss = addEntry(ss, varargin)
            ss.nEntries = ss.nEntries + 1;            
            ss.sStruct(ss.nEntries) = cell2struct(varargin', ss.sFieldnames);
        end
        
        
        function subStruct = getEntries(ss, field, matchList)
            assert(numel(unique(matchList)) == numel(matchList), 'matchList entries are not unique');
            
            % TODO - replace with 
%             idx = strcmp({ss.sStruct.(field)}, matchList);
%             assert(numel(idx) == numel(ss.sStruct));
%             subStruct = ss.sStruct(idx);
            
            subStructSize = 0;
            for i = 1:ss.nEntries
                if ismember(ss.sStruct(i).(field), matchList)
                    subStructSize = subStructSize + 1;
                    subStruct(subStructSize) = ss.sStruct(i);
                end
            end
            assert(subStructSize == numel(matchList));
        end
    end
end