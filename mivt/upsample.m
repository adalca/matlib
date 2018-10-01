function vol = upsample(vol, ratio, interpMethod)
% warning: this function interpolates in an 'interesting' way
% e.g. scale by 2 does not mean every second element will be the same as the original image elements.
% it forces end elements to match, instead!
% TODO: reconcile with clean-up of imresize/volresizeNd

    if nargin == 2
        interpMethod = 'linear';
    end
    
    % get the interpolation points in each dimensions
    x = cell(1, ndims(vol));
    for i = 1:ndims(vol)
        x{i} = linspace(1, size(vol,i), round(size(vol, i) * ratio(i)));
    end
    
    % obtain a ndgrid (not meshgrid) for each dimension
    xi = cell(1, ndims(vol));
    [xi{:}] = ndgrid(x{:});
    
    % interpolate
    vol = interpn(vol, xi{:}, interpMethod);