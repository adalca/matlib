classdef sys < handle
    % SYS A helper class for helpful system calls
    
    properties (Constant)
    end
    
    methods (Static)
        am = amParallel();
        whos(varargin);
        varargout = fulldir(path);
        sdirs = subdirs(path);
        restart();
        isf = isfile(file, verbose);
        [funname, fun] = callerFun();
        varargout = structmemory(str)
    end
    
end

