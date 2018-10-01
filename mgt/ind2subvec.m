function sub = ind2subvec(sz, ind)
    assert(size(ind, 2) == 1, 'need vertical vector');
    assert(max(ind(:)) <= prod(sz), 'ind outside range');
    
    sub = cell(1, numel(sz));
    [sub{:}] = ind2sub(sz, ind(:));
    sub = [sub{:}];
    
    