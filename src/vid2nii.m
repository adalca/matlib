function nii = vid2nii(videoFile, outfile)
% VIDEO2NII write a nifti file from frames
%   VIDEO2NII(videoFile) writes a nifti file from video file videoPath.
%   The file uses VideoReader class to open video files -- see the help
%   file for that class for supported formats. 
%
%   VIDEO2NII(videoFile, outfile) also write the nifti to
%   outfile. outfile should have '.nii' extension, and the final output
%   file have an additional .gz extension
%
%   Requires: 
%   Matlab NIFTI toolbox (here tested with 2010 version)
%
%   Unfinished (TODO):
%   (I belive) video is required to be color (3 channels). 
%
%   Example:
%   nii = video2nii('video.mp4', 'timelapse.nii');
%
%   See Also:
%   VideoReader
%
%   Author: Adrian V. Dalca, http://adalca.mit.edu
%   Last Update: May, 2012.


% open the video and get the height and width
vr = VideoReader(videoFile);
nFrames = vr.NumberOfFrames;
height = vr.Height;
width = vr.Width;
channels = 3;   %TODO: can we get this from vr struct?

% build the nifti volume
gimgs = zeros(height, width, nFrames, 1, channels, 'uint8');
for i = 1:nFrames
    gimgs(:,:, i, 1, :) = read(vr, i);
end

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
