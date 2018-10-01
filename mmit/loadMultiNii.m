function [niftis, volumes] = loadMultiNii(files)
% files is a cell array of full path names
%
%   note if you have files as a struct from dir or fulldir, simply try:
%       filesCell = {files.name};
%
% TODO: only compute volumes if nargout == 2

    nFiles = numel(files);

    volumes = cell(nFiles, 1);
    niftis = cell(nFiles, 1);
    for f = 1:nFiles
        filename = files{f};
        nii = loadNii(filename);
        
        niftis{f} = nii;
        volumes{f} = nii.img;
    end
    