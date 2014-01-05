function nii = frames2nii(path, in_name, frames, outfile)
% FRAMES2NII write a nifti file from frames
%   FRAMES2NII(path, in_name, frames) writes a nifti file from frames
%   individual pictures (frames) given by filenames in_name in filepath
%   path. in_name should be a format string with a single '%i' parameter
%   for frame numbering (e.g.: in_name = 'file %i.jpg'). frames is either the 
%   number of frames (starting with 1), or a range of frames. 
%
%   FRAMES2NII(path, in_name, frames, outfile) also write the nifti to
%   outfile. outfile should have '.nii' extension, and the final output
%   file have an additional .gz extension
%
%   Requires: 
%   Matlab NIFTI toolbox (here tested with 2010 version)
%
%   Works with both color and grayscale images. For color images, nii
%   header intent_code is set to 1007 (thanks to Ramesh Sridharan for 
%   finding this out). 
%
%   Example:
%   nii = frames2nii('files1', 'img (%i).jpg', 337, 'z.nii');
%
%   Author: Adrian V. Dalca, www.mit.edu/~adalca
%   Last Update: May, 2012.

% get the frames
if numel(frames) == 1
    frames = 1:frames;
end
nFrames = numel(frames);

% get height and width from first frame
img = imread([path, filesep, sprintf(in_name, 1)]);
height = size(img, 1);
width = size(img, 2);
channels = size(img, 3);
clear img;


% build the nifti volume
gimgs = zeros(height, width, nFrames, 1, channels, 'uint8');
h = waitbar(0,'Starting...');
for i = frames
    index = i - frames(1) + 1;
    gimgs(:,:, index, 1, :) = imread([path, filesep, sprintf(in_name, i)]);
    
	% update progress bar
    waitbar(index/nFrames);
end
close(h)

% build the nifti file
nii = make_nii(gimgs);

if channels == 3
    % need setting for color images
    nii.hdr.dime.intent_code = 1007;
end

% write the nifti to file if required
if exist('outfile', 'var')
    % could use save_nii if want to avoid workign with gz files
    save_niigz(nii, outfile);   
end