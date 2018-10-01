function mi = mutualInformation(vec1, vec2, varargin)
% assumes the binning and so on has been done.   
    
    % check inputs
    p = inputParser;
    addRequired(p, 'vec1', @isvector);
    addRequired(p, 'vec2', @isvector);
    addOptional(p, 'bins1', [], @isnumeric);
    addOptional(p, 'bins2', [], @isnumeric);
    addOptional(p, 'mask', true(size(vec1)), @islogical);
    parse(p, vec1, vec2, varargin{:});
    assert(numel(vec1) == numel(vec2), 'Vectors are not the same length');
    inputs = p.Results;
    
    % choose sub-selection of the vectors
    vec1sel = inputs.vec1(inputs.mask(:));
    vec2sel = inputs.vec2(inputs.mask(:));
    
    % get unique bins
    if numel(inputs.bins1) == 0  
        inputs.bins1 = unique(vec1sel);
    end
    if numel(inputs.bins2) == 0  
        inputs.bins2 = unique(vec2sel);
    end
    
    % compute joint and separate probabilities, adding epsilons to avoid issues with zeros
    joint = hist3([vec1sel(:), vec2sel(:)], {inputs.bins1, inputs.bins2});
    jointOrig = joint;
    joint = joint + eps;
    joint = joint ./ sum(joint(:));    
    
    sep1 = hist(vec1sel, inputs.bins1);
    sep2 = hist(vec2sel, inputs.bins2);
    sep = sep1(:) * sep2(:)';
    sepOrig = sep;
    sep = sep + eps;
    sep = sep ./ sum(sep(:));
    
    % make sure that if sep is ~0, then so is joint.
    assert(all(jointOrig(sepOrig(:) == 0) == 0));
    
    % compute mi
    miMat = joint .* log(joint ./ sep);
    mi = sum(miMat(:));
    