function [m, varargout] = intersectm(varargin)
    
    m = mintersect(varargin{:});
    
    varargout = cell(1, nargin);
    for i = 1:nargin
        [~, mi, varargout{i}] = intersect(m, varargin{i});
        assert(numel(m) == numel(mi));
    end
    
