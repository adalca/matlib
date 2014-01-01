function frames2vid(path, in_name, nFrames, varargin)
% FRAMES2VID write a video file from frames
%   FRAMES2VID(path, in_name, nFrames) writes a video file from nFrames
%   individual pictures (frames) given by filenames in_name in filepath
%   path. in_name should be a format string with a single '%i' parameter
%   for frame numbering (e.g.: in_name = 'file %i.jpg'). nFrames is the 
%   number of frames
%
%   FRAMES2VID(path, in_name, 'PropertyName', PropertyValue, ...) allows
%   for specifying the following optional parameters:
%
%       height          input and output height. default:1080
%       width           input and output width. default:1920
%       frameRate       video framerate. default:30
%       quality         encryption quality if lossy . default:100
%       oNameBase       base name of output file. default:'outfile'
%       fileext         output file extension. default:'.mp4' (def reqs 2012a, win7)
%       profile         VideoWriter profile. default:'MPEG-4' (def reqs 2012a, win7)
%       reshapeSize     size to reshape the video to
%
%   Author: Adrian V. Dalca, www.mit.edu/~adalca
%   Last Update: April, 2012.

% setup parameter inputs and defaults
p = inputParser;
addRequired(p, 'path',@isstr);               
addRequired(p, 'in_name',@(x) numel(strfind(x, '%i')) == 1);    
addRequired(p, 'nFrames',@isnumeric);        
addParamValue(p, 'oNameBase', 'outfile');
parse(path, in_name, nFrames, varargin{:});

outfile = [p.Results.oNameBase, p.Results.fileext];
files = cell(p.Results.nFrames, 1);
for k = 1 : p.Results.nFrames
    files{k} = [path, filesep, sprintf(p.Results.in_name, k)];
end

images2vid(inputFiles, outfile, varargin{:});
