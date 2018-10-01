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
% Authors: Adrian Dalca
% Contact: adalca@csail.mit.edu

    properties
        % the vector to iterate over
        vector = [];
        nVector = [];
        
        % the current index
        curIdx = 0;
        
        % the waitbar handle and function message to display
        waitbarHandle = nan;
        funcMsg = '';
        curfrac = -inf;
        
        % verbose values: 0 (none), 1 (waitbar), 2 (text)
        verbose = true;
        verbosefreq = 0.001;
    end
    
    methods
        
        function [vi, h] = verboseIter(vector, verbose, funcMsg)
        % the vector to iterate over. 
        % optional: verbose (logical)
        % optional: funcMsg (string) - will be shown in text of waitbar
            
            % verbose defaults to true
            if nargin == 1
                verbose = 1;
            end
            
            % extract the last function if no funMsg is provided
            if nargin < 3
                funcMsg = funcname(1);
            end
            
            % build the waitbar
            if verbose == 1
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
            idx = obj.curIdx;
            frac = idx/obj.nVector;
            
            if obj.verbose > 0 && frac >= (obj.curfrac + obj.verbosefreq);
                obj.curfrac = frac;
                waitmsg = sprintf('%s: %d/%d (%3.1f%%) completed', ...
                    msg, idx, obj.nVector, frac*100);
                
                if obj.verbose  == 1
                    waitbar(frac, obj.waitbarHandle, waitmsg); 
                    drawnow();
                else
                    assert(obj.verbose == 2)
                    disp(waitmsg);
                end
            end
            
            % get the new index and update the curIdx field
            obj.curIdx = obj.curIdx + 1;
            idx = obj.curIdx;
            v = obj.vector(obj.curIdx);
        end
        
        function close(obj)
            if obj.verbose == 1
                close(obj.waitbarHandle);
                drawnow;
            end
        end
		
        function hn = hasNext(obj)
            hn = obj.curIdx < obj.nVector;
        end
        
    end
end
