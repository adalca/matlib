function images2vid(inputFiles, outfile, varargin)
% IMAGES2VID write a video file from frames
%   IMAGES2VID(inputFiles, outfile) writes a video file from image files 
%   given as a cell array inputFiles. 
%   
%   IMAGES2VID(inputFiles, outfile, 'PropertyName', PropertyValue, ...) allows
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

p = inputParser();
addRequired(p, 'inputFiles',@iscell); 
addRequired(p, 'outfile', @isstr); 
addParamValue(p, 'height',1080,@isnumeric);
addParamValue(p, 'width',1920,@isnumeric);
addParamValue(p, 'frameRate',30,@isnumeric);
addParamValue(p, 'quality',100,@isnumeric);
addParamValue(p, 'fileext', '.mp4');          
addParamValue(p, 'profile', 'MPEG-4');        
addParamValue(p, 'reshapeSize', [], @(x) numel(x) == 0 || numel(x) == 2);
addParamValue(p, 'crop', [], @isnumeric); % [ymin, xmin, ymax, xmax]
addParamValue(p, 'croptoratio', false, @islogical); % [ymin, xmin, ymax, xmax]
addParamValue(p, 'align', '', @ischar); % '', or 'consecutive', or 'first'
parse(p, inputFiles, outfile, varargin{:});

nFrames = numel(inputFiles);



% build writer object
writerObj = VideoWriter(outfile, p.Results.profile);
writerObj.FrameRate = p.Results.frameRate;
if strcmp(p.Results.profile, 'MPEG-4') || strcmp(p.Results.profile, 'Motion JPEG AVI')
    writerObj.Quality = p.Results.quality;
end
open(writerObj);

% write
h = waitbar(0,'Starting video frames writing...');
z = zeros(p.Results.height, p.Results.width, 3, 'uint8');
frame = struct('cdata', z, 'colormap', []);

for k = 1 : nFrames
    file = inputFiles{k};
    frame.cdata = imread(file);
    
    imt = frame.cdata;
    if numel(p.Results.crop) == 4
        assert(~p.Results.croptoratio);
        c = p.Results.crop;
        imt = imt(c(1):c(3), c(2):c(4), :);
    end
    
    
    if numel(p.Results.reshapeSize) == 2
        if p.Results.croptoratio
            assert(isempty(p.Results.crop));
            frame.cdata = volcrop(frame.cdata, 'ratio', p.Results.reshapeSize);
        end

        im = zeros(p.Results.reshapeSize(1), p.Results.reshapeSize(2), 3, 'uint8');
        for i = 1:3
            im(:,:,i) = imresize(imt(:,:,i), p.Results.reshapeSize);
        end
        
        frame.cdata = im;
    end
     
    % align. this is quite slow
    if ~strcmp(p.Results.align, '') && k > 1
        [optimizer, metric] = imregconfig('monomodal');
        im1 = frame.cdata;
        im2 = imorig;
        r = imregtform(rgb2gray(im1), rgb2gray(im2), 'rigid', optimizer, metric, 'InitialTransformation', affine2d(eye(3)));
        frame.cdata = imwarp(im1, r, 'OutputView', imref2d(size(im2)));
    end
    
    if size(frame.cdata, 3) == 1
        frame.colormap = gray;
    end
    
    
    if strcmp(p.Results.align, 'first') && k == 1
        imorig = frame.cdata;
    elseif strcmp(p.Results.align, 'consecutive')
        imorig = frame.cdata;
    end
    
    writeVideo(writerObj,frame);
    
    % update progress bar
    waitbar(k/nFrames);
end
close(h)

% close object
close(writerObj);
