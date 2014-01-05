function gimgs = frames2mat(filepath, varargin)
% FRAMES2MAT returns a matrix from frames
%   FRAMES2NII(path) returns a HxWxnFrames matrix from HxW frames
%   given by filenames filepath, which should be a format string with a single '%i' parameter
%   for frame numbering (e.g.: in_name = '/path/to/file/file %i.jpg'). 
%
%   FRAMES2NII(path, param, value, ...) also allows the following optional parameter-value pair
%   inputs:
%       frames - a vector of frame numbers, such as 1:300, to be read. default: attempt to
%           count the number of frames, but numbering has to start at 1.
%       color - logical on whether the ouput matrix has color frames. default: true.
%           if true, return H x W x 3 x nFrames
%           if false, return H x W x nFrames video
%
%   Example:
%   framesMat = frames2nii('/path/to/file/file %i.jpg', 'frames', 337);
%   framesMat will be HxWx337x3
%
%   Author: Adrian V. Dalca, www.mit.edu/~adalca
%   Last Update: May, 2013.

    % setup parameter inputs and defaults
    p = inputParser;
    p.addRequired('filepath', @check_in_name);               
    p.addParamValue('frames', -1, @isnumeric);
    p.addParamValue('color', true, @islogical);
    p.addParamValue('verbose', ispc(), @islogical);
    parse(p, filepath, varargin{:});

    % if windows, make sure you have double slashed for file separators
    if ispc, filepath = strrep(filepath, '\', '\\'); end

    if p.Results.frames > -1
        frames = p.Results.frames;
    else
        searchfile = strrep(filepath, '%i', '*');
        frames = 1:numel(dir(searchfile));
    end
    nFrames = numel(frames);

    % get height and width from first frame
    img = imread(sprintf(filepath, frames(1)));
    height = size(img, 1);
    width = size(img, 2);
    colInput = ndims(img) == 3;
    colOutput = p.Results.color;
    if colOutput && ~colInput
        warning('FRAMES2MAT:COLOR', 'Color output required, but grayscale input found. Switching to B&W output');
        colOutput = false;
    end
    clear img;
    


    % build the mat volume
    channels = ifelse(colOutput, 3, 1);
    gimgs = zeros(height, width, channels, nFrames, 'uint8');

    if p.Results.verbose, h = waitbar(0,'Starting frame reading...'); end
    for i = 1:numel(frames)
        idx = frames(i);
        frame = imread(sprintf(filepath, idx));
        
        if ~colOutput && colInput
            frame = rgb2gray(frame);
        end
        
        gimgs(:,:, :, i) = frame;

        % update progress bar
        if p.Results.verbose, waitbar(i/nFrames, h, sprintf('Loaded %i/%i frames', i, nFrames)); end
    end
    
    if p.Results.verbose
        close(h)
        pause(0.001);
    end
    
    if ~p.Results.color
        gimgs = permute(gimgs, [1 2 4 3]);
    end 
end


function t = check_in_name(in_name)
    %TODO: check substring %i or %u. see strfind
    t = numel(strfind(in_name, '%i')) == 1;
    
end