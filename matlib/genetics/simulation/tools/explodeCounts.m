function longVec = explodeCounts(countVec, shuffle)
% EXPLODECOUNTS create a vector of types
%   longVec = explodeCounts(countVec, shuffle) creates a long vector of
%   types based on the count vector indicateing the count of each type.
%   shuffle is a logical on whether the longVector should permute its
%   entries.
%
%   Example: longVec = explodeCounts([3, 1, 5], false); gives
%       longVec = [1 1 1 2 3 3 3 3 3]
%
%   Contact: www.mit.edu/~adalca 

    % initiate the long vector
    longVec = zeros(1, sum(countVec(:)));
    
    % build the cumulative count vector
    c = zeros(1, numel(countVec) + 1);
    c(2:end) = cumsum(countVec(:));
    
    % populate the long vector
    for i = 1:(numel(c) - 1)
        longVec((c(i)+1):c(i+1)) = i;
    end
    
    % permute long vector entries if required. 
    if shuffle
        longVec = longVec(randperm(sum(countVec(:))));
    end
end

