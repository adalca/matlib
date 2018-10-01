function vol = perlin(volSize)
% PERLIN volume of perlin noise 
%   vol = perlin(volSize) generate a perlin noise volume of size volSize
%   
%   algorithm adapted from http://nullprogram.com/blog/2007/11/20
%
% Contact: adalca@csail.mit.edu

    % initiate volume
    vol = zeros(volSize);

    % compute the width of the layer
    width = max(volSize); 
    
    % iterations
    i = 0;           
    while width > 3
        i = i + 1;
        
        % get a small random volume
        smallVolSize = ceil(volSize ./ 2^(i-1)) + i;
        smallVolSize = min(smallVolSize, volSize);
        randVol = rand(smallVolSize);
        
        % get the interpolated volumes
        interpVol = volresize(randVol, volSize);
        vol = vol + i * interpVol;
        
        % update width
        width = width - ceil(width./2 - 1);
    end
end
