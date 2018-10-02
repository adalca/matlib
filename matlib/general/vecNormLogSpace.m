function varargout = vecNormLogSpace(logw, dim, normType)
% takes logw as input (as opposed to w);
% 	subtracts the mean along the appropriate dimension before exponentiating and computing the norm
%   this is to add stabillity to very small numbers

    if nargin == 2
        warning('default is normType == 1');
        normType = 1;
    end

    assert(normType == 1, 'only tested for L1');

    % subtract the minimum
    m = max(logw, [], dim);
    
    logwprime = bsxfun(@minus, logw, m);
    
    varargout = cell(nargout, 1);
    [varargout{:}] = vecNorm(exp(logwprime), dim, normType);
	
	varargout{1} = bsxfun(@times, varargout{1}, exp(m));
	
    