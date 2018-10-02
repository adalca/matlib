function [vol, mask] = upsampleNii(inNiiFile, outNiiFile, outNiiMaskFile, ...
    interpMethod, fillVal, newVolSize, givenDims)
% upsampling of nii, with rounded dimensions
% TODO: need to combine this with isotropicNIi
    warning('TODO: combine upsampleNii with toIsotropic.m/isotropicNii.m');

    if ~exist('interpMethod', 'var')
        interpMethod = 'linear';
    end
    
    if ~exist('fillVal', 'var')
        fillVal = 0;
    end
    
    if ~exist('givenDims', 'var')
        givenDims = false;
    end
    
    if ischar(inNiiFile)
        nii = loadNii(inNiiFile);
    else
        nii = inNiiFile;
    end
    vol = nii.img;
    
    
    % decide on destination vol size
    if ~exist('newVolSize', 'var')
        dims = nii.hdr.dime.pixdim(2:4);
        mindim = min(dims);
        dims = ceil(dims./mindim);
        dstVolSize = size(nii.img) .* dims;
        
    elseif givenDims
        dims = newVolSize;
        dstVolSize = size(vol) .* dims;
        
    else
        dims = newVolSize ./ size(vol);
        assert(all(isIntegerValue(dims)));
        dstVolSize = newVolSize;
    end
    
    xin = arrayfun(@(x, y) 1:x:y*x, dims, size(nii.img), 'UniformOutput', false);
    xout = arrayfun(@(y) 1:y, dstVolSize, 'UniformOutput', false);
    
    [xin{:}] = ndgrid(xin{:});
    [xout{:}] = ndgrid(xout{:});
    vol = interpn(xin{:}, double(vol), xout{:}, interpMethod, fillVal);
    assert(ndims(vol) == ndims(nii.img), 'output volume has the wrong number of dimensions');
    assert(all(size(vol) == dstVolSize), 'output volume has incorrect size');
    
    idx = sub2ind(size(vol), xin{:});
    mask = false(size(vol));
    mask(idx) = true;
    
    prevdims = nii.hdr.dime.pixdim(2:4);
    if exist('outNiiFile', 'var') && ~isempty(outNiiFile)
        nii = makeNiiLike(vol, nii);
        nii.hdr.dime.pixdim(2:4) = prevdims ./ dims;
        saveNii(nii, outNiiFile);
    end
    
    if exist('outNiiMaskFile', 'var') && ~isempty(outNiiMaskFile)
        nii = makeNiiLike(mask, nii);
        nii.hdr.dime.pixdim(2:4) = prevdims ./ dims;
        nii.img = logical(nii.img);
        saveNii(nii, outNiiMaskFile);
    end
    
