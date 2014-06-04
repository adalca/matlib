function varargout = rangeCrop(volSize, varargin)
% [x, y, ...] = rangeCrop(volSize, x, y, ...)
%   crops every entry in the given dimenion ranges to match the input volume.
%


    varargout = cell(numel(varargin));
    for i = 1:numel(varargin)
        x = varargin{i};
        x(x > volSize(1)) = [];
        x(x < 1) = [];
        varargout{i} = x;
    end

end