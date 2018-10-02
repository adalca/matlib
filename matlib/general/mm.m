function mm(varName)
% MM decrement variable in caller workspace
%   mm(varName) will decremember the variable with the given name in the 
%       caller's workspace. In other works, simulates the minus minus (--) operator in C
%
% Example:
%   >> x = 1;
%   >> mm('x');
%   >> x
%   x =
%          0
%
% Warning: Due to the evalin('caller', ...) command, this function is much, much, much slower than
%   just typing x = x - 1 in the caller workspace. However, in situations where the rest of the code
%   takes much longer at any rate, this can be handy (e.g. for complicated functions).
%
% See Also: pp
%
% Contact: http://adalca.mit.edu   

    % setup command
    cmd = sprintf('%s = %s - 1;', varName, varName);

    % run command in caller
    evalin('caller', cmd);