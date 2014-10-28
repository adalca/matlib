function varargout = getNdRange(rangeEnds, volSize)
% range = getNdRange(rangeEnds) returns a cell array range:
%   range = {1:rangeEnds(1), 1:rangeEnds(2), ...}
%   useful for indexing into n-arrays of a-priori unknown dimentions
%
% [range, map] = getNdRange(rangeEnds, volSize)
%   returns the range, as well as the boolean map of the range within the larger volume.
%
% TODO: reconcile with cropMask, cropVolume, setSubvolume, etc
%	accept range in the manner of randi's first argument: can have start, or start and end, etc


    range = cell(numel(rangeEnds), 1);
    for i = 1:numel(rangeEnds)
        range{i} = 1:rangeEnds(i);
    end
    varargout{1} = range;
    
    if nargout == 2
        if nargin == 1
            volSize = rangeEnds;
        end
    
        % TODO - this might not be the most efficient...
        map = false(volSize);
        map(range{:}) = true;
        varargout{2} = map;
    end
        

