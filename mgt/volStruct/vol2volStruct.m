function volStruct = vol2volStruct(vol, nDims)
% turn volumes into a volstruct for the patch toolbox. nDims is optional - if it
% exists, it should indicate th enumber of dimensions of the actual volume,
% whereas vol could be of dimension nDims (indicating a single feature) or
% dimension nDims + 1 (indicating N features, where N = size(vol, nDims + 1)
    

    % check inputs
    if nargin == 1
        nDims = ndims(vol);
    end
    nDimsErrMrg = ['nDims should either match the number of dimensiosn of the volume, or one', ...
        'minus that, indicating the last dimension is used as the features'];
    assert(any(nDims == [ndims(vol), ndims(vol)-1]), nDimsErrMrg);
    
    % reshape
    nFeatures = size(vol, nDims+1);
    volStruct.features = reshape(vol, [numel(vol)/nFeatures, nFeatures]);
    
    % compute the size
    inputVolSize = size(vol);
    volStruct.volSize = inputVolSize(1:nDims);