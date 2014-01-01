function plotImages(fid, varargin)
% PLOTIMAGES plots several images in subplots.
%   plotimages(fid, im1, imtitle1, ...) plots images im1...imN with titles
%   imtitle1..imtitleN. It finds a reasonable number of rows and columns to
%   use for organizing subplots. 

    % number of images
    nImages = (nargin - 1)/2;
    
    % get an approximate count of rows and columns (subplots) needed
    nRows = round(sqrt(nImages));
    nCols = ceil(nImages/nRows);

    % plot the images in subplots
    figure(fid);
    for i = 1:nImages
        subplot(nRows, nCols, i); 
        imshow(varargin{i*2 - 1})
        title(varargin{i*2});
        axis on;
    end
    
    % let MATLAB plot
    pause(0.1);