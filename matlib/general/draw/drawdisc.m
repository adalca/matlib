function imCircle = drawdisc(radius, edgeThickness, varargin)
%TODO - make circle a class. Have all of these parts, as well as a 'mess model'. Randomness
%   with seed so that we can reproduce it. MAINTAIN TIME. (very useful for videos.)
%   - have function that draws it!
%   - have noise model as class?
%   - have have edge as class, which is a circle!
%   - do the same with other elements besides disc. 
%TODO - maybe allow for complex noise model, e.g. type of perlin noise. 

    % parse input
    p = inputParser;
    addRequired(p, 'radius',@isnumeric);               
    addRequired(p, 'edgeThickness',@isnumericunit);    
    addOptional(p, 'circleIntensity',1,@isnumericunit);        
    addOptional(p, 'blurLength',3,@isnumeric);        
    addOptional(p, 'blurSigma',1,@isnumeric);
    addOptional(p, 'doMess',true,@islogical);
    parse(p, radius, edgeThickness, varargin{:});

    % set the length of the side of an image
    imgLen = p.Results.radius*6+1;

    % get the radius transform wrt center
    center = (imgLen + 1) ./ 2;
    [xs, ys] = meshgrid(1:imgLen, 1:imgLen);
    imRadius = sqrt((center - ys).^ 2 + (center - xs) .^2 );
    
    % build an image of the circle with circleIntensity. 
    imCircle = (imRadius <= radius) * p.Results.circleIntensity;
    
    % draw the edge. 
    % To make it as smooth as possible, draw it on both sides of the circle limit, and weight
    % it by inverse distance to this limit. 
    radiusDist = abs(imRadius - p.Results.radius);
    edgePix = (edgeThickness * p.Results.radius / 2);
    imEdge = (radiusDist <= edgePix) .* (edgePix - radiusDist) ./ edgePix;
    
    % combine edge with circle image
    imCircle = max(imCircle, imEdge);

    % create mess in the circle. 
    
    

    % blur the image with imfilterSep. 
    % This is faster than imfilter, conv2, filter2 with 2d-filters, even though
    % filter2 seems to separate the 2d filter?. 
    % see http://www.mathworks.com/matlabcentral/answers/17529
    h = fspecial('gaussian', [1 p.Results.blurLength], p.Results.blurSigma);
    imCircle = imfilterSep(imCircle, h);

end



function bool = isnumericunit(elem)
    bool = isnumeric(elem) && (elem <= 1) && (elem >= 0);
end


function imMess = getMessImg(radius, imgLen, center)
    
    

    % create noisy image. 
    randMess = rand(imgLen, imgLen); 
    h = fspecial('gaussian', [1, 3], 1);
    imRand = imfilterSep(randMess, h);
    
    % build a quick circle
    % choose position
    smallCenter = rand(1, 2) * radius + center;
    smallRadius = radius * unifrnd([0.2, 0.5]);
    % TODO - not hard code!!!
    imSmallDisc = drawdisc(smallRadius, 0, 1, 'blurLength', 10);
    setSubVolumeCenter(z, imSmallDisc, smallCenter);
    
end




