function idx = subvec2ind(sz, sv)
    assert(all(all(bsxfun(@ge, sz, sv))), 'Subscript outside size range');
    svc = mat2cell(sv, size(sv, 1), ones(1, size(sv, 2)));
    idx = sub2indfast(sz, svc{:});
    
