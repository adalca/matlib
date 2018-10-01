classdef gammadst
    % using b as in wikipedia, which is 1/b from matlab
    
    methods (Static)
        function r = expect(a, b)
		% using b as in wikipedia, which is 1/b from matlab
		
            r = a ./ b;
        end
        
        function r = expectlog(a, b)
		% using b as in wikipedia, which is 1/b from matlab
		
            r = psi(a) - log(b);
        end
        
        function plot(a, b)
		% using b as in wikipedia, which is 1/b from matlab
		
            l = linspace(0, gammadst.expect(a, b)*2, 1000);
            plot(l, pdf('gamma', l, a, 1/b));
        end
        
    end
    
    
end