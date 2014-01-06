function shiftedVol = shiftVol(vol, shiftStart, interpMethod)
% shift a given volume via interpolation starting at the shiftStart

    assert(all(shiftStart >= 1) && all(shiftStart < size(vol)), ...
        'The start of the shift should be within the size of the volume');

    % check inputs
    narginchk(2, 3);
    if nargin == 2
        interpMethod = 'linear';
    end

    % get n dimensions
    nDims = ndims(vol);

    % get the interpolation range in each dimension
    x = cell(nDims, 1);
    for i = 1:ndims(vol)
        x{i} = shiftStart(i):size(vol, i);
    end

    % obtain a ndgrid (not meshgrid) for each dimension
    xi = cell(1, ndims(vol));
    [xi{:}] = ndgrid(x{:});

    % interpolate
    shiftedVol = interpn(vol, xi{:}, interpMethod);