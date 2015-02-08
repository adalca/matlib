function l = logistic(t, c, sigma, alpha)



    if nargin == 1
        l = 1 ./ (1 + exp(-t));
        
        
    elseif nargin == 3
        l = 1 ./ (1 + exp(-(t-c)/sigma));
%         l = cdf('logistic', t, c, sigma);    
    else
        l = 1 ./ (1 + exp(-(t-c)/sigma)) ;
        

    end