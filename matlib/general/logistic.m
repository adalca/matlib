function l = logistic(t, c, sigma, alpha)
% compute the logistic function 
%
% See Algo: logit


    if nargin == 1
        l = 1 ./ (1 + exp(-t));
        
    elseif nargin == 3
        l = 1 ./ (1 + exp(-(t-c)/sigma));
        % this is significantly slower:
        %   l = cdf('logistic', t, c, sigma);
    else
        l = 1 ./ (1 + exp(-(t-c)/sigma)) ;

    end