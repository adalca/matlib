% kernel regression
function [m, interpX] = kernelRegress(X, Y, interpX, h)
% X is Nx1
% Y is NxD, D is dimentionality
    

    assert(size(X, 1) == size(Y, 1));
    dim = size(Y, 2);
    
    if ~exist('interpX', 'var') || isempty(interpX)
        interpX = linspace(min(X), max(X), 100);
    end
    
    if ~exist('h', 'var') 
        % optimal bandwidth suggested by Bowman and Azzalini (1997) p.31
        % these next few lines for h are taken from ksr.m, By Yi Cao 
        hx=median(abs(interpX-median(interpX)))/0.6745*(4/3/numel(interpX))^0.2;
        hy=median(abs(Y-median(Y)))/0.6745*(4/3/numel(Y))^0.2;
        h=sqrt(hy*hx);
        if h<sqrt(eps)*numel(X)
            error('There is no enough variation in the data. Regression is meaningless.')
        end
    end
    
    m = zeros(numel(interpX), dim);
    for i = 1:numel(interpX)
        g = 1/h * gaussKernel((interpX(i) - X) ./ h) ;
        gY = bsxfun(@times, g, Y);
        m(i, :) = sum(gY) ./ sum(g);
    end
end


function g = gaussKernel(delt)

    g = exp( - 0.5 * delt .^ 2 ) ./ sqrt(2 * pi);
end
