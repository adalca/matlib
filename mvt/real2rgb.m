function rgbIm = real2rgb(realIm, dim)
% take real values images (or volumes) and transform them into a positive-values rgb image in [0, 1]

    if ~exist('dim', 'var')
        dim = ndims(realIm) + 1;
    end

    imr = realIm; imr(imr < 0) = 0;
    imb = -realIm; imb(imb < 0) = 0;
    rgbIm = cat(dim, imr, imb, imb);
    rgbIm = 1 - rgbIm ./ max(rgbIm(:));