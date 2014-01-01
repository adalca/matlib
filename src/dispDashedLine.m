function dispDashedLine(fid)
% prints 80 characters
%
%
% Adrian Dalca
% note: this seems faster than repmat, etc.

    fprintf(fid, ['-----------------------------------------------', ...
        '---------------------------------\n']);
    
    