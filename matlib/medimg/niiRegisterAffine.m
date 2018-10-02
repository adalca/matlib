function [movingRegisteredVol, geomtform, Rfixed, Rmoving] = ...
    niiRegisterAffine(fixedNii, movingNii, varargin)

    % prepare inputs
    [fixedNii, movingNii, inputs] = parseinputs(fixedNii, movingNii, varargin{:});

    % get the volumes
    fixedVol = fixedNii.img;
    movingVol = movingNii.img;
    
    % get the fixed and moving reference objects
    fixedPixDims = num2cell(fixedNii.hdr.dime.pixdim(2:4));
    Rfixed  = imref3d(size(fixedVol),fixedPixDims{:});
    modingPixDims = num2cell(movingNii.hdr.dime.pixdim(2:4));
    Rmoving = imref3d(size(movingVol),modingPixDims{:}); 
    
    % prepare registration configulration
    [optimizer, metric] = imregconfig(inputs.regconfig);
    
    % carry out registration
    geomtform = imregtform(movingVol, Rmoving, fixedVol, Rfixed, inputs.tformtype, ...
        optimizer, metric, inputs.imregtformParamValue{:});
    
    % morph actual volume
    movingRegisteredVol = imwarp(movingVol, Rmoving, geomtform, inputs.interp, ...
        'OutputView', Rfixed, inputs.imwarpParamValue{:});
    
    if ~isempty(inputs.outNii)
        nii = fixedNii;
        assert(all(size(movingRegisteredVol) == size(nii.img)));
        nii.img = movingRegisteredVol;
        saveNii(nii, inputs.outNii);
    end
    
    if ~isempty(inputs.outAffine)
        dlmwrite(inputs.outAffine, geomtform.T, ' ');
    end
end

function [fixedNii, movingNii, inputs] = parseinputs(fixedNii, movingNii, varargin)

    if ischar(fixedNii)
        fixedNii = loadNii(fixedNii);
    end

    if ischar(movingNii)
        movingNii = loadNii(movingNii);
    end
    
    p = inputParser();
    p.addParamValue('regconfig', 'monomodal', @ischar);
    p.addParamValue('tformtype', 'affine', @ischar);
    p.addParamValue('interp', 'bicubic', @ischar);
    p.addParamValue('imregtformParamValue', {}, @iscell);
    p.addParamValue('imwarpParamValue', {}, @iscell);
    p.addParamValue('outNii', '', @ischar);
    p.addParamValue('outAffine', '', @ischar);
    p.parse();
    inputs = p.Results;
    
end
    