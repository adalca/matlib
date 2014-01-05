function [outputMov] = vid2mat(videofile, color)

	if ~exist('color', 'var')
		color = true;
	end

	% initiate video reader and read video
	vidObj = VideoReader(videofile);
	mov = read(vidObj, [1 vidObj.NumberOfFrames]);

	% if not color, 
	if ~color
		outputMov = zeros(size(mov,1),size(mov,2),size(mov,4));
		for i = 1:size(mov,4) 
			outputMov(:,:,i) = rgb2gray(mov(:,:,:,i)); 
		end
	else
		outputMov = mov;
	end
