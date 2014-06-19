function drawgrid(x, y, varargin)
hold on;
for i = 1:numel(x)
    xi = repmat(x(i), [1, numel(y)]);
    plot(xi, y(:)', varargin{:});
end

for i = 1:numel(y)
    yi = repmat(y(i), [1 numel(x)]);
    plot(x(:)', yi, varargin{:});
end
