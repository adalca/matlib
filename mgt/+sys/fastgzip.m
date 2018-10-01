function outFileName = fastgzip(inFileName, outputFolder)
% FASTGZIP gzip a file usint the system gzip or MATLAB's gzip
%   outFileName = fastgzip(filename) attempts to use the system's gzip to perform 
%   the gzip operation on non-pc systems. If this fails (or using pc), MATLAB's gzip 
%   takes over. The zipped file is put in the folder of the input file.
%
%   outFileName = fastgzip(inFileName, ouputFolder) allows for specific output folder
%   specification.
%
% See Also: gzip, fastgunzip, gzip, ispc, system
%
% Contact: Adrian V. Dalca, adalca@mit.edu, http://adalca.mit.edu

    % check inputs
    narginchk(1, 2);

    % get the name and extention of the current file
    [currentOutputFolder, name, ext] = fileparts(inFileName);
    if nargin == 1
        outputFolder = currentOutputFolder;
    end
 
    if ~sys.isdir(outputFolder)
        mkdir(outputFolder);
    end
    
    if ~ispc
        % construct output filename
        outFileName = fullfile(outputFolder, [name, ext, '.gz']);
        
        % try the system gzip
        res = system(['gzip -c ', inFileName, ' > ', outFileName]);
    end
    
    % if the system gzip failed (or using pc), use matlab's gzip
    if ispc || res ~= 0
        outFileName = gzip(inFileName, outputFolder);
        outFileName = outFileName{1};
    end 
end
