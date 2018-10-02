function nii2niigz(folder, recurse, preserve)
% NII2NIIGZ gzip nifty files. 
%   nii2niigz(file) gzip given nifty file. the original nifty file is deleted.
%
%   nii2niigz(dir) gzip all nifty files in the given dir. the original nifty files are deleted.
%
%   nii2niigz(..., recurse) allows to recursively look for niftis in the given folder. recurse is
%   false be default.
%
%   nii2niigz(..., recurse, preserve) can specify whether to preserve files (preserve=true) or not
%   (preserve=false, default)
%
% Requires: fulldir, fastgzip, sys.isfile from mgt: https://github.com/adalca/mgt
%
% Author: Adrian Dalca, adalca.mit.edu

    % check inputs
    narginchk(1, 2);
    if nargin < 2
        recurse = false;
    end
    if nargin < 3
        preserve = false;
    end

    % get the file names, whether from a particular passed file or from a folder
    if sys.isfile(folder)
        assert(~recurse, 'cannot recurse if given input is a file');
        names = {folder};
    else
        assert(isdir(folder), '%s is neither a folder nor a file', folder);
        if recurse
            sdirs = sys.subdirs(folder);
        else
            sdirs = {folder};
        end
        
        names = {};
        for i = 1:numel(sdirs)
            d = fulldir(fullfile(sdirs{i}, '*.nii'));
            names = [names, d.name]; %#ok<AGROW>
        end
    end
    
    % go through each file 
    cellfun(@sys.fastgzip, names, 'UniformOutput', false);
    
    % delete if necessary
    if ~preserve
        cellfun(@delete, names, 'UniformOutput', false);
    end
