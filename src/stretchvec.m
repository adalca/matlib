function vs = stretchvec(v, c)
% stretch a vector by set amounts for each entry in that vector
%   sv = stretchvec(v, c) 
%   
% example:
%   v = [10 56 79]';
%   c = [2, 3, 4]';
%   sv = stretchvec(v, c);
%   sv' 
%   ans =
%       10    10    56    56    56    79    79    79    79
%
% See Also: stretchmat, repmat, unique
%
% contact: adalca@csail.mit.edu

    assert(~any(c == 0), 'Working on 0s... but not yet');

    % perhaps faster method:
    % go from c [2 4 3] to cvec = [1 1 2 2 2 2 3 3 3]
    cvec = zeros(sum(c), 1); % TODO: deal with dimensions
    idxvec = [0; cumsum(c)] + 1;
    cvec(idxvec(1:end-1)) = 1;
    cvec = cumsum(cvec);
    
    % now vs = v(cvec)
    vs = v(cvec);
end
