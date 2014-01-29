classdef verboseIter < handle
% verbose iterator from vector 
%	verbose iterator constructed from vector. The verbose iterator automatically displays and updates a waitbar
%
%	Example:
%	v = verboseIter([1, 2, 7, 8])
%	while v.hasNext()
%		[s, i] = vi.next();
%	end
%	v.close();
%
%   See Also: hasNext, next, close
%   
% Project: Analysis of clinical datasets
% Authors: Adrian Dalca, Ramesh Sridharan
% Contact: {adalca,rameshvs}@csail.mit.edu

    properties
        % the vector to iterate over
        vector = [];
        nVector = [];
        
        % the current index
        curIdx = 0;
        
        % the waitbar handle and function message to display
        waitbarHandle = nan;
        funcMsg = '';
        
        % verbose logical
        verbose = true;
    end
    
    methods
        
        function [vi, h] = verboseIter(vector, verbose, funcMsg)
        % the vector to iterate over. 
        % optional: verbose (logical)
        % optional: funcMsg (string) - will be shown in text of waitbar
            
            % verbose defaults to true
            if nargin == 1
                verbose = true;
            end
            
            % extract the last function if no funMsg is provided
            if nargin < 3
                st = dbstack;
                if numel(st) > 1
                    funcMsg = st(2).name; % todo: look up caller
                else
                    funcMsg = '';
                end
            end
            
            % build the waitbar
            if verbose
                h = waitbar(eps, funcMsg);
                vi.waitbarHandle = h;
            end
            
            % populate properties
            vi.vector = vector;
            vi.nVector = numel(vector);
            vi.curIdx = 0;
            vi.funcMsg = funcMsg;
            vi.verbose = verbose;
        end
        
        function [v, idx] = next(obj, msg)
            % if no extra message given, use the funcMsg
            if nargin == 1
                msg = obj.funcMsg;
            end
            
            % first, print the waitbar with the previous 'current' index.
            if obj.verbose
                idx = obj.curIdx;
                frac = idx/obj.nVector;
                waitmsg = sprintf('%s: %d/%d (%3.1f%%) completed.', msg, idx, obj.nVector, frac*100);
                waitbar(frac, obj.waitbarHandle, waitmsg); 
                % TODO: pause to actually show the waitbar, but can this actually slow down the op?
                pause(0.0001);
            end
            
            % get the new index and update the curIdx field
            obj.curIdx = obj.curIdx + 1;
            idx = obj.curIdx;
            v = obj.vector(obj.curIdx);
        end
        
        function close(obj)
            close(obj.waitbarHandle);
            % TODO: pause to actually show the waitbar, but can this actually slow down the op?
            pause(0.0001);
        end
        
        
        function hn = hasNext(obj)
            hn = obj.curIdx < obj.nVector;
        end
        
    end
end