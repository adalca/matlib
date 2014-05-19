function dispDashedLine(fid)
% DISPDASHEDLINE prints 80 dash characters and newline
%   dispDashedLine(fid) prints a 80 dashed-characters newline to the given file 
%   identifier
%
% Example:
%   >> dispDashedLine(1)
%   --------------------------------------------------------------------------------
%
% See Also: fopen
%
% Contact: http://adalca.mit.edu

    if nargin == 0
        fid = 1;
    end
    


    % Note: this seems faster than repmat, etc.
    fprintf(fid, ['-----------------------------------------------', ...
        '---------------------------------\n']);
    
    
