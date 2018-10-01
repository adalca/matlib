function swNii = warpNii(sourceNii, tform, varargin)
% warpNii - similar call as to imwarp, but instead of volumes passed in, can pass in nifti structs
% or nifti filenames
%
% Extra optional parameter:
%   'OutputSave': filename (char) the nifti filename to save the resulted warp nifti to.
%
% tform is src2tgtTform. or filename with var 'tform in it'
%
% TODO: allow saving of nifti


    % process source
    if ischar(sourceNii), sourceNii = loadNii(sourceNii); end
    srcDims = sourceNii.hdr.dime.pixdim(2:4);
    rSource = imref3d(size(sourceNii.img), srcDims(2), srcDims(1), srcDims(3));
    
    % see if target space is given. if it is, we assume it's a nifti struct or filename
    outViewArgIdx = find(strcmp('OutputView', varargin));
    if numel(outViewArgIdx) > 0
        assert(numel(outViewArgIdx) == 1);
        fi = outViewArgIdx+1;
        
        targetNii = varargin{fi};
        if ischar(targetNii), targetNii = loadNii(targetNii); end
        tgtDims = targetNii.hdr.dime.pixdim(2:4);
        rFixed = imref3d(size(targetNii.img), tgtDims(2), tgtDims(1), tgtDims(3));
        varargin{fi} = rFixed;
    end

    % check for output filename.
    outFilename = '';
    outSaveArgIdx = find(strcmp('OutputSave', varargin));
    if numel(outSaveArgIdx) > 0
        outFilename = varargin{outSaveArgIdx+1};
    end
    
    % get tform
    if ischar(tform), load(tform); end
    
    % warp volume
    [sourceWarped, or] = imwarp(sourceNii.img, rSource, tform, varargin{:});
    or
    
    % prepare output nii.
    if numel(outViewArgIdx) > 0
        swNii = makeNiiLike(sourceWarped, targetNii);
    else
        swNii = makeNiiLike(sourceWarped, sourceNii); % not tested;
    end
    
    % save output nii
    if ~isempty(outFilename)
        saveNii(swNii, outFilename);
    end
    