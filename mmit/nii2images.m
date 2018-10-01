function selFrames = nii2images(niiFile, filepath, varargin)
% NII2IMAGES - write slices from a nifti file to image on disk
%   selFrames = nii2images(niiFile, filepath) - output slices from a nifti
%       files niiFile to disk. Note the format of filepath below, where %i
%       is a placeholder for a frame
%
%   input options:
%       niiFile - input nifti filename
%       filepath - input path for output images. 
%           format if single volume: /path/to/file_%i.png
%           format if 4D volume: /path/to/file_%s_%i.png
%
%   selFrames = nii2images(... Param, Value)
%        
%   optional inputs (via param, value pairs):
%       maskFile - filename of a mask to overlay on image
%       maskStyle - 'fill' or 'contour' for how to overlay mask
%       slices - an array of slices (3rd dim) to take from the nifti
%       padMidSlices - alternatively, an integer nr of slices to pad the 
%           middle slice (e.g. 5 in a 256^3 image gives 123:133)
%           if neither slices or padMidSlices is provided, all slices will
%           be outputed
%       resample - resample image when output (e.g. 3 for bigger images)
%       volumes
%       imwriteopt
%   
%   Example:
%       nii2images('/path/to/nifti.nii.gz', '/path/to/output/file_%i.png', ...
%           'slices', 143:146, 'resample', 3);
%
%   Requires: 
%       NIFTI toolbox and loadNii
%
%   See Also:
%       loadNii, dataset2images
%
%   Author: Adrian Dalca
%   Last Update: May 2013.

    
    % input parsing
    p = inputParser();
    p.addRequired('niiFile', @(x) (ischar(x) && exist(x, 'file') == 2) || isstruct(x)); 
    p.addRequired('filepath', @checkOutName); 
    p.addParamValue('maskFile', '', @(x) exist(x, 'file') == 2);
    p.addParamValue('maskMatrix', [], @(x) isnumeric(x) || islogical(x));
    isFillOrContour = @(x) strcmp(x, 'fill') || strcmp(x, 'contour');
    p.addParamValue('maskStyle', 'fill', isFillOrContour);
    p.addParamValue('slices', 0, @isnumeric);
    p.addParamValue('volumes', 0, @isnumeric);
    p.addParamValue('padMidSlices', -1, @isscalar);
    p.addParamValue('resample', 1, @isnumeric);
    p.addParamValue('imwriteopt', {}, @iscell);
    isIndexOrSequence = @(x) strcmp(x, 'index') || strcmp(x, 'sequence');
    p.addParamValue('outputNameing', 'index', isIndexOrSequence);
    
    p.parse(niiFile, filepath, varargin{:});
    
    % load nifti file and normalize image!
    if ~isstruct(niiFile)
        nii = loadNii(niiFile);
    else
        nii = niiFile;
    end
    ims = double(nii.img);
    ims = ims./max(ims(:));
    
    % mask
    useMask = false;
    if numel(p.Results.maskFile) > 0
        useMask = true;
        maskNii = loadNii(p.Results.maskFile);
        maskVol = double(maskNii.img);
    end
    
    if numel(p.Results.maskMatrix) > 0
        assert(numel(p.Results.maskFile) == 0);
        useMask = true;
        maskVol = p.Results.maskMatrix;
    end
    
    if useMask
        masks = flipdim(permute(maskVol, [2, 1, 3]), 1);
    end
        
    % get which slices to write
    assert(~(any(p.Results.slices > 0) && p.Results.padMidSlices > -1), ...
        'Please only supply one of slices or padMidSlices');
    
    if any(p.Results.volumes > 0)
        volumes = p.Results.volumes;
    else
        volumes = 1:size(ims, 4);
    end
    
    if any(p.Results.slices > 0)
        slices = p.Results.slices;
    elseif p.Results.padMidSlices > -1
        m = round(size(ims, 3)/2);
        nPadMid = p.Results.padMidSlices;
        slices = (m-nPadMid):(m+nPadMid);
    else
        slices = 1:size(ims, 3);
    end
    
    if slices(end) > size(ims, 3)
        fprintf(2, 'Cropping slices to available size\n');
        slices(slices > size(ims, 3)) = [];
    end
        
    % go through relevant slices
    iscolor = ndims(ims) == 5;
%     assert(~iscolor || size(ims, 4) == 1);
    assert(~(iscolor && useMask)); % don't handle mask cases with color images
    
    selFrames = flipdim(permute(ims(:,:,slices, :, :), [2, 1, 3, 4, 5]), 1);
    
    if useMask
        maskFrames = masks(:,:,slices);
    end
    
    % assume that if more than one volume, we are given %d_%s in the file...
    if numel(volumes) > 1
        assert(numel(strfind(filepath, '%s')) == 1);
    end
    
    % warning - this won't work, except for orig files. 
    for v = 1:numel(volumes)
        
        if numel(volumes) > 1
            thisfilepath = sprintf(filepath, '%d', v);
        else
            thisfilepath = filepath;
        end
        
        
        for i = 1:numel(slices)
            % get and resize image 
            im = selFrames(:, :, i, v, :);
            im = permute(im, [1, 2, 5, 3, 4]);
            im = imresize(im, p.Results.resample);

            % if using mask, get and resize mask, and put it back in im
            if useMask
                mask = maskFrames(:,:,i);
                mask = imresize(mask, p.Results.resample, 'nearest');

                % if just contours.
                if strcmp(p.Results.maskStyle, 'contour')
                    mask = bwdist(mask) == 1;
                end

                % put the mask in the image
                mixedIm = repmat(im, [1, 1, 3]);
                im(mask > 0) = mask(mask > 0);
                mixedIm(:,:,2) = im;
                im = mixedIm;
            end

            % write slice
            if strcmp(p.Results.outputNameing, 'sequence')
                name = sprintf(thisfilepath, i);
            else
                name = sprintf(thisfilepath, slices(i));
            end
            imwrite(im, name, p.Results.imwriteopt{:}); % 'Quality', 100

        end
    end
    
    
end



function t = checkOutName(outName)
    
    t = ischar(outName) && (numel(strfind(outName, '%i')) == 1 || ...
        numel(strfind(outName, '%d')) == 1);
end

