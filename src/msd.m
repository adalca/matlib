function dst = msd(v1, v2, dim)
% mean squared difference
%
% if dim is supplied, it takes msd along that dim. 
% otherwise, it takes ssd accross entire vectorized volumes

    ds = (v1 - v2) .^ 2;

    if exist('dim', 'var')
        dst = mean(ds, dim);
    else
        dst = mean(ds(:));
    end

