function isf = isfile(file, verbose)
% ISFILE returns whether given filename is a file
%	isf = isfile(file) returns whether the file acording to exist() function (this includes
%	searching on the matlab path!). 
%
%   isf = isfile(file, verbose) prints out a clean warning if the file is not found when 
%	verbose == true
%
% See Also: exist
%
% Author: Adrian Dalca

    isc = ischar(file);
    isf = isc && exist(file, 'file') == 2;

    if ~isf && nargin == 2 && verbose
        warning('IO:NOTFILE', 'Missing: %s', file);
    end
end
