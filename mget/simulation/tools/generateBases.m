function imgs = generateBases(basesIds, outputImSize, initImSize)
% GENERATEBASES generate bases images for the imaging genetics experiment. 
%   imgs = generateBases(basesIds, outputImSize) basesIds is a vector of numbers to
%   assign to the "on" pixels in each basis. outputImSize is the desired output
%   size.
%
%   imgs = generateBases(basesIds, outputImSize, initImSize) specifies an
%   initial image size for the initial canvas on which seeds are inputed. Only
%   use this if you want to play with how the algorithm works.
%
%   Iterative algorithm:
%       choose a seed point (e.g. [1, 1])
%       for all basesIds:
%           get the nearest neighbors of the seed and form an image from them
%           upsample this image
%           
%
%   Example:
%   imgs = generateBases([1, 1, 1, 2, 3], [28, 28]); 
%       Generates 5 images (in a 28x28x5 volume), each representing a basis.
%       For each basis, the "on" voxels will have the number associated with
%       that image (1, 1, 1, 2 or 3)
%
%   File contact: www.mit.edu/~adalca 



    nBases = numel(basesIds);

    % estimate needed size
    if ~exist('initImSize', 'var')
        % 4 because top/bottom shapes only get two rows/cols
        initImSize = [1, 1] * (4 + 3 * (ceil(sqrt(nBases)) - 2));
    end
    
    % initializations
    imgs = zeros([outputImSize, nBases]);
    allSeedsIm = zeros(initImSize);
    seedPt = [1,1];
    
    % generate the bases
    for i = 1:numel(basesIds)
        % prepare the image with a seed at the seed point
        seedIm = zeros(initImSize);
        seedIm(seedPt) = 1;
        
        % get the bw distance from the seed
        seedImDist = bwdist(seedIm);
        
        % the mask should be the points within 1 of the seed
        im = (seedImDist <= 1) * basesIds(i);
        imgs(:,:, i) = imresize(im, outputImSize, 'nearest');
        
        % get next seed point
        if i < numel(basesIds)
            % add up all the seeds up to now
            allSeedsIm = allSeedsIm + seedIm;
            imDist = bwdist(allSeedsIm);
            
            % get the furthest point from any seed
            [~, idx] = max(imDist(:));
            seedPt = ind2sub(initImSize, idx);
        end
    end
