function h = imageIn3D(img,yloc, varargin)
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/155794

    if nargin == 1
        yloc = 1;
    end
    
    fimg = flipud(img);
    
    % new try
    x = 1:size(fimg, 2);
    y = 1:size(fimg, 1);
    z = yloc;
    [X, Y, Z] = meshgrid(x, y, z);
    h = surf(X, Y, Z, fimg, varargin{:});
    
    view(30,30);
