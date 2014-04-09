function varargout = vecNormLogSpace(logw, dim, norm_type)
% takes logw as input (as opposed to w);
% 	subtracts the mean along the appropriate dimension before exponentiating and computing the norm
%   this is to add stabillity to very small numbers
%	

    if nargin == 2
        warning('default is norm_type == 1');
        norm_type = 1;
    end

    assert(norm_type == 1, 'only tested for L1');

    % subtract the minimum
    m = max(logw, [], dim);
    
    logwprime = bsxfun(@minus, logw, m);
    
    varargout = cell(nargout, 1);
    [varargout{:}] = vecNorm(exp(logwprime), dim, norm_type);
	
	varargout{1} = bsxfun(@times, varargout{1}, exp(m));
	
    