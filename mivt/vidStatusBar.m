function [video, frames] = vidStatusBar(frames, varargin)
% VIDEOSTATUSBAR mark a video with a status bar
%   video = videoStatusBar(frames, mark1, ...)
%       frames should be a matrix of h x w x 3 x L
%       markX: [start, end, r, g, b]. End might be redundant but it's a nice check

    if isnumeric(frames)
        % split it
        framescell = cell(1, numel(varargin));
        for i = 1:numel(varargin)
            mark = varargin{i};
            framescell{i} = frames(:,:,:,mark(1):mark(2));
        end
        assert(mark(2) == size(frames, 4));
        frames = framescell;
    end
    
    % check input sizes
    assert(numel(varargin) == numel(frames), ...
        '%d, %d', numel(varargin), numel(frames));
    
    [h, w, c, ~] = size(frames{1});
    l = varargin{end}(2);
    assert(c == 3);
    video = zeros(h+1, w, c, l, class(frames{i}));
    for i = 1:numel(varargin)
            mark = varargin{i};
         video(:,:,:,mark(1):mark(2)) = fragmentStatusBar(frames{i}, mark(3:end));
    end
    
end

function fragment = fragmentStatusBar(frames, rgb)
    rgbsplit = repmat(reshape(rgb, [1, 1, 3]), [1, size(frames, 2), 1, size(frames, 4)]);
    
    % need it to be moving, not static!
    fragment = cat(1, rgbsplit, frames);
end
