function l = logit(p, noninf)
% logit function
% 
%
% TODO: add sigma, mu.
% l = -s * log(1/p - 1) + mu
%
% See Algo: logistic

    assert(all(isprob(p(:))));
    
    % hack
    % p = within([0.01, 0.99], p);
    
    if nargin == 1
        noninf = false;
    end
        

    l = log(p ./ (1 - p));
    
    if noninf
        assert(isa(p, 'double'));
        l(l == -inf) = double(realmin('single'));
        l(l == inf) = double(realmax('single'));
    end 
    assert(isreal(l));
    