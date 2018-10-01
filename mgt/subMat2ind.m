function ind = subMat2ind(sz, sub)
% works with sub being a matrix, assumes size(sub, 2) is the number of dimensions
    
    subCell = sub2cell(sub);
    ind = sub2ind(sz, subCell{:});
    