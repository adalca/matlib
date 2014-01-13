%% function [array] = actionSubArray(action,array,startInd,endInd,subArray,dim)
% Preforms a number of function that has to do with extracting and
% inserting subarrays into a subarray of arbitary dimensions
%
% Contact: {klbouman, adalca}@csail.mit.edu

function [array, idxMax] = actionSubArray(action,array,startInd,endInd,subArray,dim)
    
    range = cell(1,length(startInd));
    for i=1:length(startInd)
        range{i} = startInd(i):endInd(i);
    end
    
    switch action
        case 'extract'
            % extract a subarray from a larger array of arbitrary dimension
            array = array(range{:});
            
        case 'insert'
            % insert a subarray into a larger array of arbitrary dimension
            array(range{:}) = subArray;  
            
        case 'add'
            % add a subarray into a larger array of arbitary dimension
            array(range{:}) = double(array(range{:})) + double(subArray);
            
        case 'circInsert'
            % do a circular insert into a larger array
            maxSize = size(array); 
            
            for i=1:length(startInd)
                range{i} = mod(range{i}-1,maxSize(i))+1;
            end
            array(range{:}) = subArray;
            
        case 'concat' 
            % concatanate subarrays of an arbitrary number of dimension along a given dimension
            range{length(s) + 1} = dim;
            array(range{:}) = subArray;
            
        case 'max'
            
            [array(range{:}), idxMax] = max(array(range{:}),double(subArray));
            
        otherwise
            error('unknown method');
    end

end
