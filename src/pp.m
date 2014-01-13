function pp(varName)
% PP increment variable in caller workspace
%   pp(varName) will incremember the variable with the given name in the 
%       caller's workspace. In other works, simulates the plus plus (++) operator in C
%
% Example:
%   >> x = 0;
%   >> pp('x');
%   >> x
%   x =
%          1
%
% Warning: Due to the evalin('caller', ...) command, this function is much, much, much slower than
%   just typing x = x + 1 in the caller workspace. However, in situations where the rest of the code
%   takes much longer at any rate, this can be handy (e.g. for complicated functions).
%
% See Also: mm
%
% Contact: http://adalca.mit.edu   

    % setup command
    cmd = sprintf('%s = %s + 1;', varName, varName);

    % run command in caller
    evalin('caller', cmd);