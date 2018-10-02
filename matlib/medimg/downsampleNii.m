function downsampleNii(inputNii, sampling, outputNii, dorandstart, method, cropVol)

    if ~exist('dorandstart', 'var')
        dorandstart = false;
    end
    
    if ~exist('method', 'var') % should be 'decim', 'nn'
        method = 'decim';
    end
    
    % transform volume
    nii = loadNii(inputNii);
    vol = double(nii.img);

    if ~exist('cropVol', 'var')
        % assert(strcmp(method, 'decim'), 'cropVol is only meant to be used with decim for now');
        cropVol = size(vol);
    end
    
    assert(numel(sampling) == ndims(vol));

    % downsample
    r = cell(1, ndims(vol));
    for i = 1:ndims(vol)
        
        if dorandstart
            randstart = randi([1, sampling(i)-1]);
        else
            randstart = 1;
        end
        
        switch method
            case 'decim'
                assert(isIntegerValue(sampling(i)));
                r{i} = randstart:sampling(i):cropVol(i);
            case 'nn'
               
            otherwise
                error('unknown method');
        end
    end
    
    
    switch method
        case 'decim'
            vol = vol(r{:});
        case 'nn' % meant to be used
            vol = volresize(vol, round(size(vol) ./ sampling), 'nearest');
        otherwise
            error('unknown');
    end

    niinew = make_nii(vol);
    if any(niinew.img(:) > 1)
        warning('Final voxel range failed: larger than 1');
    end
    if any(niinew.img(:) < 0), 
        warning('Final voxel range failed: less than 0');
    end

    dims = nii.hdr.dime.pixdim(2:4);
    % assert(all(dims == dims(1)), 'assuming isotropic vectors');
    dims = dims .* sampling;
    niinew.hdr.dime.pixdim(2:4) = dims;

    saveNii(niinew, outputNii);
end


