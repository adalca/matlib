function isd = isdir(directory, verbose)
% ISDIR returns whether given filename is a directory (folder)
%   isd = isdir(directory) returns whether the directory exists acording to exist() function. 
%
%   isd = isdir(directory, true) prints out a clean warning if the dir is not found 
%
% See Also: exist
%
% Author: Adrian Dalca

    isd = exist(directory, 'dir') == 7;

    if ~isd && nargin == 2 && verbose
        warning('IO:NOTDIR', 'Missing: %s', directory);
    end
end
