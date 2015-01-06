function [funname, fun] = callerFun()

    st = dbstack;
    if numel(st) > 2
        funname = st(3).name; 
        fun = str2func(funname);
    else
        funname = '';
        fun = [];
    end
    