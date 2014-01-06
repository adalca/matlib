function c = struct2cellWithNames(s)
% STRUCT2CELLWITHNAMES converts the 1-by-1 structure S (with P fields) into array including field names
%
%   Example:
%   clear s, 
%	s.category = 'tree'; 
%   s.height = 37.4; 
%	s.name = 'birch';
%
%   s = 
%    category: 'tree'
%      height: 37.4000
%        name: 'birch'
%
%   c1 = struct2cell(s)
%   c1 = 
%    'tree'
%    [37.4000]
%    'birch'
%
%   c2 = struct2cellWithNames(s)
%   c2 = 
%     'category'
%     'tree'   
%     'height' 
%     [37.4000]
%     'name'   
%     'birch'  
%
%   so far only works for single structures (i.e. not M-by-N structures S, etc);
%
%   See Also: struct2cell


    assert(length(s) == numel(s));

    ctmp = struct2cell(s);
    f = fieldnames(s);

    c = cell(numel(ctmp) * 2, 1);
    c(1:2:end) = f;
    c(2:2:end) = ctmp;