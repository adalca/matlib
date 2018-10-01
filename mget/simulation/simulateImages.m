function [images, weights] = simulateImages(genetics, weights, inputs, labels) %nSubjects, nVoxels, genetics, weights, noiseStd, shuffle, imBases, labels)
% SIMULATEIMAGES simulates images for imaging genetics 
%   markers = simulateImages(nSubjects, nVoxels, genetics, weights, noiseStd, shuffle) 
%       simulates images, see below for algorithm. 
%
%   Inputs: 
%       nSubjects (scalar)      number of subjects, 
%       nVoxels                 types of voxels Voxels can be influenced by genetics (G)
%            or not and can be causal to the label (Y) or not;
%       genetics                genetics struct as returned by simulateGenetics
%       weights                 weights struct as returned by simulateWeights
%       noiseStd                The standard deviation to the 0-mean noise
%                               to add to images.
%       shuffle                 whether to shuffle the indexes of voxel types or not 
%       
%       
%   output: images struct with following fields. nTotalVoxels = sum(nVoxels(:))
%     .clean        nSubjects x nVoxels the clean (non-noise added) simulated 
%               'images' for each subject
%     .noisy        nSubjects x nVoxels images with added noise
%     .voxelTypes   vector of the type of voxel at each position based on nVoxels raster
%     .nVoxels      copy of input variable
%
%   Current simulation:
%       - create voxels generates from genetisc based on genetic weights of
%       relevant SNPs and their MAF. 
%       - randomly (uniform over 0..1) generate the rest of the pixels
%       - build entire image and add noise. 
%
%   See Also: simulateData
%
%   File contact: www.mit.edu/~adalca 


%     [nSubjects, nVoxels, genetics, weights, noiseStd, shuffle, imBases, labels] = parseInputs(varargin);
    nSubjects = inputs.nSubjects;
    nVoxels = inputs.nVoxels;
    shuffle = inputs.shuffle;

    % some nice option setups
    exactOpt = struct('reverse', false, 'exact', true);
    
    % input check and useful variables
    assert(nSubjects > 0, 'Number of subjects should not be 0');
    assert(isstruct(nVoxels), 'nVoxels should be a struct');    
    
    % is no markers influencing causal voxels, make sure no geninfl_causal voxels
    if nElementsOfType(genetics.nMarkers, {'_VOXCAUSAL'}) == 0;
        assert(nElementsOfType(nVoxels, {'GENINFL_CAUSAL'}, exactOpt) == 0, ...
            'no causal genetics (_VOXCAUSAL) should imply no (GENINFL_CAUSAL) voxels');
    end
    
    if nElementsOfType(genetics.nMarkers, {'_NONVOXCAUSAL'}) == 0;
        assert(nElementsOfType(nVoxels, {'GENINFL_NONCAUSAL'}, exactOpt) == 0, ...
            'no (_NONVOXCAUSAL) genetics should imply no (GENINFL_NONCAUSAL) voxels');
    end
    
    nTotalVoxels = nElementsOfType(nVoxels, {'_'}); % get the number of total voxels
    
   
    

    
    % create voxels generated from expressed genetic markers
    expressedMarkers = idxOfType(@geneticType, '_VOXCAUSAL', genetics.markerTypes);
    genCausalVoxels = genetics.markers(:, expressedMarkers) * weights.geneticsToCausalVoxels;
    
    expressedMarkers = idxOfType(@geneticType, '_NONVOXCAUSAL', genetics.markerTypes);
    genNonCausalVoxels = genetics.markers(:, expressedMarkers) * weights.geneticsToNonCausalVoxels;
    
    % finally, collect the images 
    if numel(inputs.imBases) > 0
        
        % builld images based on map.
        [images, weights] = imagesFromBases(inputs, genCausalVoxels, genNonCausalVoxels, labels, weights);
    else
        
         % create voxel type maps (voxel type \in {1..4} )
        assert(isequal(fieldnames(nVoxels), fieldnames(voxelType)));
        images.voxelTypes = explodeCounts(struct2array(nVoxels), shuffle);
        
         % simluate voxels not generated from genetics
        nonGenVoxels = zeros(nSubjects, nElementsOfType(nVoxels, {'NONGENINFL'}));
    
        images.clean = zeros (length(labels), nTotalVoxels);
        rng = ismember(images.voxelTypes, struct2array(voxelType({'GENINFL_CAUSAL'}, exactOpt)));
        images.clean(:, rng) = genCausalVoxels;
        rng = ismember(images.voxelTypes, struct2array(voxelType({'GENINFL_NONCAUSAL'}, exactOpt)));
        images.clean(:, rng) = genNonCausalVoxels;
        rng = ismember(images.voxelTypes, struct2array(voxelType({'NONGENINFL'})));
        images.clean(:, rng) = nonGenVoxels;
        assert(all(images.clean(:) >= 0 | images.clean(:) <= 1), ...
            sprintf('Voxels outside range: min: %f max %f', min(images.clean(:)), max(images.clean(:))));
        
        % get noisy images
        images.noisy = images.clean + normrnd(0, inputs.imgNoiseStd, [nSubjects, nTotalVoxels]);
    end
    
    
    voxTypes = fieldnames(nVoxels);
    for i = 1:numel(voxTypes);
        images.(voxTypes{i}) = images.voxelTypes == i;
    end
    
    % compact nVoxels into struct
    images.nVoxels = nVoxels;
end



function [images, newWeights] =...
    imagesFromBases(inputs, genCausalVoxels, genNonCausalVoxels, labels, weights)
% TODO AVOID HARDCODED VOXEL TYPES
    sz = size(inputs.imBases);
    nSubjects = length(labels);
    images.clean = zeros (nSubjects, sz(1) * sz(2));
    images.voxelTypes = zeros(sz(1) * sz(2), 1) + 4;
    
    sum(inputs.imBases(:) == 1)
    newWeights.geneticsToCausalVoxels = zeros(size(weights.geneticsToCausalVoxels, 1), sz(1) * sz(2));
    newWeights.geneticsToNonCausalVoxels = zeros(size(weights.geneticsToNonCausalVoxels, 1), sz(1) * sz(2));
    causalIdx = false(sz(1) * sz(2), 1);
    nonCausalIdx = false(sz(1) * sz(2), 1);
    
    c = 1;
    nc = 1;
    for i = 1:size(inputs.imBases, 3)
        im = inputs.imBases(:,:,i);
        m = max(im(:));
        idx = find(im(:) == m)';
        images.voxelTypes(idx) = m;
        switch m
            case 1 % genCausalVoxels
                images.clean(:, idx) = repmat(genCausalVoxels(:, c), [1, numel(idx)]);
                newWeights.geneticsToCausalVoxels(:, idx) = repmat(weights.geneticsToCausalVoxels(:, c), [1, numel(idx)]);
                causalIdx(idx) = true;
                c = c + 1;
                
            case 2 % NonGenCausalVoxels
                caseVal = random(inputs.caseVoxDist{:}, [sum(labels), 1]);
                images.clean(labels, idx) = repmat(caseVal, [1, numel(idx)]);
                controlVal = random(inputs.controlVoxDist{:}, [sum(~labels), 1]);
                images.clean(~labels, idx) = repmat(controlVal, [1, numel(idx)]);
                
            case 3 % genCausalVoxels
                images.clean(:, idx) = repmat(genNonCausalVoxels(:, nc), [1, numel(idx)]);
                newWeights.geneticsToNonCausalVoxels(:, idx) = repmat(weights.geneticsToNonCausalVoxels(:, nc), [1, numel(idx)]);
                nonCausalIdx(idx) = true;
                nc = nc + 1;
            otherwise
                error('incorrect case');
        end
    end

    % get noisy images
    images.noisy = images.clean + normrnd(0, inputs.imgNoiseStd, [nSubjects, sz(1) * sz(2)]); 
    
    % weights
    newWeights.geneticsToCausalVoxels(:, ~causalIdx) = [];
    newWeights.geneticsToNonCausalVoxels(:, ~nonCausalIdx) = [];
    
end
