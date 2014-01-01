function value = ifelse(condition, valueIfTrue, valueIfFalse, streval)
% IFELSE replicates 'ternary if' from C
%   value = ifelse(condition, valueIfTrue, valueIfFalse) replicates the C "ternary if" operator. 
%   Specifically:
%       value = condition ? valueIfTrue: valueIfFalse
%   meaning valueIFTrue is returned if condition is true, and valueIfFalse is returned otherwise. 
%
%   Note: due to MATLAB execution, the valueIfTrue and valueIfFalse are actually both executed 
%   before the function call (in the caller), but only one is saved to the result. 
%   For example, 
%       value = ifelse(memory > 8, rand(100, 100), rand(10, 10)) 
%   will create both random matrices (in the caller workspace) before calling ifelse. This can
%   sometimes be costly or evan impossible to execute due to dependencies on the condition, and in
%   this case consider using the 4-argument call below.
%
%   value = ifelse(condition, valueIfTrue, valueIfFalse, streval) allows for specifying the values
%   as commands to be evaluated (in caller's workspace). This allows for specifying the value
%   expressions as strings so that they only get executed if needed. For example:
%       value = ifelse(memory > 8, 'rand(100, 100)', 'rand(10, 10)', true);
%   then only the necesary random matrix is created. Also, the calls are evaluated in the caller
%   workspace, so that relevant dependent variables can be used.
%
%   Note: ifelse(cnd, vt, vf, false) is the same as ifelse(cnd, vt, vf)
%
%   Contact: Adrian V. Dalca, http://adalca.mit.edu, adalca@mit.edu

    % check that we have 3 to 4 inputs
    narginchk(3, 4);
    if nargin == 3
        streval = false;
    end
    
    % value = condition ? valueIfTrue: valueIfFalse
    if condition
        if streval
            value = evalin('caller', valueIfTrue);
        else
            value = valueIfTrue;
        end
        
    else
        if streval
            value = evalin('caller', valueIfFalse);
        else
            value = valueIfFalse;
        end
    end
end
