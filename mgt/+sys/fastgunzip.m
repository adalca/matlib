function outFileName = fastgunzip(inFileName, outputFolder)
% FASTGUNZIP unzip a file using the system command or MATLAB's gunzip
%   outFileName = fastgunzip(inFileName) attempts to use zcat to perform gunzip 
%   on non-pc systems. If this fails (or using pc), MATLAB's gunzip takes over. 
%   The unzipped file is put in the folder of the gzipped file.
%
%   outFileName = fastgunzip(inFileName, ouputFolder) allows for specific output folder
%   specification.
%
% See Also: gunzip, fastgzip, gzip, ispc, system
%
% Contact: Adrian V. Dalca, adalca@mit.edu, http://adalca.mit.edu
    
    % check inputs
    narginchk(1, 2);

    % get the name and extention of the current file
    [currentOutputFolder, name, ext] = fileparts(inFileName);
    assert(strcmp(ext, '.gz'), 'gunzip input file ext should be <.gz>, found: <%s>', ext);
    if nargin == 1
        outputFolder = currentOutputFolder;
    end
    
    if ~sys.isdir(outputFolder)
        mkdir(outputFolder);
    end
    
    if ~ispc
        % construct output filename
        outFileName = fullfile(outputFolder, name);
    
        % try the system gunzip
        res = system(['zcat ', inFileName, ' > ', outFileName]);
    end
    
    % if the system gunzip failed (or using pc), use matlab's gunzip
    if ispc || res ~= 0
        outFileName = gunzip(inFileName, outputFolder);
        outFileName = outFileName{1};
    end 
end
