function sub = ind2subvec(sz, ind)
    assert(size(ind, 2) == 1, 'need vertical vector');

    sub = cell(1, numel(sz));
    [sub{:}] = ind2sub(sz, ind(:));
    sub = [sub{:}];
    
    