function vol = upsample(vol, ratio)
% TODO: reconcile with clean-up of imresize/volresizeNd
    
    % get the interpolation points in each dimensions
    x = cell(1, ndims(vol));
    for i = 1:ndims(vol)
        x{i} = linspace(1, size(vol,i), round(size(vol, i) * ratio(i)));
    end
    
    % obtain a ndgrid (not meshgrid) for each dimension
    xi = cell(1, ndims(vol));
    [xi{:}] = ndgrid(x{:});
    
    % interpolate
    vol = interpn(vol, xi{:}, 'linear');