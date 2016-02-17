function dst = ssd(v1, v2, dim)
% sum of squared difference
%
% if dim is supplied, it takes ssd along that dim. 
% otherwise, it takes ssd accross entire vectorized volumes

    ds = (v1 - v2) .^ 2;
    
    if exist('dim', 'var')
        dst = sum(ds, dim);
    else
        dst = sum(ds(:));
    end
    