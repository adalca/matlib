function dispDashedLine(fid, cRepeat)
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
    if nargin < 2
        cRepeat = 1;
    end
    
    line = ['-----------------------------------------------', ...
        '---------------------------------\n'];
    if cRepeat > 1
        line = repmat(line, [1, cRepeat]);
    end
    
    % Note: this seems faster than repmat, etc.
    fprintf(fid, line);
    
    
