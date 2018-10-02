function nii = loadNii(filename, tmpFolder, untouch, hdronly)
% loadNii load a nifti / gzipped nifti file
%   nii = loadNii(file) load nii nifti structure from file. 
%   file should have a .nii or nii.gz extension. Uses the system's tempdir to temporarily
%   gunzip files if gz file given
%
%   nii = loadNii(filename, tmpFolder) uses tmpFolder as the temporary folder needed for gunzip
%
%   nii = loadNii(filename, tmpFolder, untouch) determines whether to use the load_untouch_nii
%   version of loader from the NIFTI library. untouch is a logical, defaulting to false;
%
%   Requires:
%   load_nii as part of NIFTI library by Jimmy Shen.
% 
%   Example:
%   nii = loadNii('niftyfile.nii.gz'); 
%
%   Author: Adrian V. Dalca, www.mit.edu/~adalca
%   Last Update: December, 2013.

    % input check
    assert(exist(filename, 'file') == 2, 'File %s does not exist', filename);
    if nargin < 3
        untouch = false;
    end
    if nargin < 4
        hdronly = false;
    end
    
    % support loading untouched nifti
    if untouch
        if hdronly
            load_fcn = @load_untouch_header_only;
        else
            load_fcn = @load_untouch_nii;
        end
    else
        if hdronly
            load_fcn = @load_nii_hdr;
        else
            load_fcn = @load_nii;
        end
    end

    [~, name, ext] = fileparts(filename);
    assert(strcmp(ext, '.nii') || strcmp(ext, '.gz'), ...
        sprintf('unknown extension <%s>. Should be .nii or .gz', ext));

    % if tmpFolder is not provided, use the system's temporary folder
    giventmp = exist('tmpFolder', 'var') && ~isempty(tmpFolder);
    if ~giventmp
        % note just using tempdir can fail when doing operations in parallel using the same file.
        % thus we make a new folder with tempname; 
        tmpFolder = tempname; 
    end
      
    fs = filesep;
    if strcmp(tmpFolder(end), fs)
        
        % Strip the last filesep to be consistent with fileparts behavior
        tmpFolder = tmpFolder(1:end-1); 
    end
    
    % if the filename is a nifti, just load it
    if strcmp(ext, '.nii')
        nii = filename2nii(filename, load_fcn, hdronly);
    
    % else, it should be a gz extension. In this case, unzip the .gz file, extract the nifti
    % filename and load that. Make sure the intermediate nifti file isn't already present
    else
        niiname = [tmpFolder, filesep, name];
        [~, ~, newext] = fileparts(niiname);
        assert(strcmp(newext, '.nii'), 'GZ filename must have a nifti pre-extention (file.nii.gz)');
        
        % if the output dir is not the temp dir, don't overwrite files. 
        if giventmp && ~strcmp(strtrimchr(tmpFolder, filesep), strtrimchr(tempdir, filesep))
            msg = sprintf('%s exists as a file or folder', niiname);
            assert(~(exist(niiname, 'file') > 1), msg);
        end
        
        % unzip the file. Note, this might over-write a nifti with the same name.
        filename = sys.fastgunzip(filename, tmpFolder);
        assert(strcmp(filename, niiname), sprintf(...
            'expected behavior failed. \nfilenames:%s\nniiname:     %s\n', filename, niiname));
        
        % read in the nifti
        nii = filename2nii(filename, load_fcn, hdronly);
    
        % delete the temp nifti file.
        delete(filename);
        if ~giventmp
            rmdir(tmpFolder);
        end
    end
end

function nii = filename2nii(filename, load_fcn, hdronly)
    try
        if hdronly
            nii.hdr = load_fcn(filename);
        else
            nii = load_fcn(filename);
        end
        
    catch e
        warning('Caught error: "%s". Using load_untouch_nii', e.identifier);
        if hdronly 
            e
            error('HDR Only Load Failed. Sorry :(');
        else
            nii = load_untouch_nii(filename);
        end
    end
end

