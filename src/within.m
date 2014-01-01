function cutMat = within(varargin)
% WITHIN cuts off the values of the given matrix.
%   cutMat = within([low, high], mat) returns mat with its values cut off at low and high. In
%       other words, each entry in mat is now in [low, high].
%   cutMat = within(low, high, mat) similar behaviour, but low and high can be matrices, of the
%       same dimension as mat, in which case the operation is done element-wise
%
% Author: Adrian. V. Dalca, www.mit.edu/~adalca  


    % if nr of args is 2, expect ([low, high], mat)
    if nargin == 2
        lh = varargin{1};
        low = lh(1);
        high = lh(2);
        
        mat = varargin{2};
        
    % if nr of args is 3, expect (low, high, mat)
    elseif nargin == 3
        low = varargin{1};
        high = varargin{2};
        assert(numel(low) == numel(high));
        
        mat = varargin{3};
        assert(numel(low) == numel(mat));
    end
    
    % perform the cut off
    cutMat = min(max(low, mat), high);
     