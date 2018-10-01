function detectBracketGroups(infolder, varargin)
%
%   Example 
%   detectBracketGroups('E:\path', 'outfolder', 'E:\path\HDR', 'verbose', true);
%
% requires sys.fulldir, verboseIter

    % check inputs
    inputs = parseInputs(infolder, varargin{:});
    
    % get a list of files
    files = sys.fulldir(fullfile(inputs.infolder, '*.JPG'));
    
    % prepare useful structures
    exposures = zeros(numel(files), 1);
    times = zeros(numel(files), 6);
    bracketed = false(numel(files), 1);
    
    % loop over files
    vi = verboseIter(1:numel(files));
    while vi.hasNext()
        i = vi.next();
        
        % get exif info
        e = imfinfo(files(i).name);
        
        % record exposure and times
        exposures(i) = e.DigitalCamera.ExposureBiasValue;
        times(i, :) = datevec(e.DateTime, 'yyyy:mm:dd HH:MM:SS');
        
        % under certain conditions, record as bracketed
        if i > inputs.nBracket
            assert(inputs.nBracket == 3, 'For now, only deadlign with 3 bracketed shots at a time');
            
            notOtherBracket = all(~bracketed(i-2:i));
            rightExposure = exposures(i - 2) > exposures(i - 1) && exposures(i - 2) < exposures(i);
            rightTime = etime(times(i, :), times(i - 2, :)) < inputs.secondsCutoff;
            if notOtherBracket && rightExposure && rightTime
                bracketed(i - 2:i) = true;
                
                % display
                if inputs.verbose
                    fprintf('Detected Group ');
                    filenames = cell(inputs.nBracket, 1);
                    for j = 1:inputs.nBracket
                        [~, filenames{j}, ~] = fileparts(files(i-3+j).name);
                        fprintf('%s ', filenames{j});
                    end
                    fprintf('\n');
                end
            end
        end
    end
    vi.close();
    sum(bracketed)
    
    % copy files
    if ~isempty(inputs.outfolder)
        
        % make output folder if necessary
        if ~isdir(inputs.outfolder)
            mkdir(inputs.outfolder);
        end
        
        % copy JPGs
        if strcmp(inputs.copyformat, 'JPG')
            allfilenames = {files(bracketed).name};
            cellfun(@(x) copyfile(x, inputs.outfolder), allfilenames);
            
        % copy CR2s if they exist
        else
            
            % check that each triplet has CR2s, then copy
            bidx = find(bracketed);
            bidxStep = bidx(1:inputs.nBracket:end);
            vi = verboseIter(bidxStep, true, 'copying');
            while vi.hasNext()
                i = vi.next();
                
                % check that all 3 CR2s exist
                allexist = false(inputs.nBracket, 1);
                cr2files = cell(inputs.nBracket, 1);
                for j = 1:inputs.nBracket
                    ji = i - 1 + j;
                    cr2files{j} = sys.replaceExtension(files(ji).name, 'CR2');
                    allexist(j) = isfile(cr2files{j});
                end 
                
                % copy CR2 is they exist, else copy JPGs
                if allexist(j)
                    cellfun(@(x) copyfile(x, inputs.outfolder), cr2files);
                    
                    if inputs.verbose
                        fprintf('copying CR2s for %s\n', files(i).name);
                    end
                    
                else
                    cellfun(@(x) copyfile(x, inputs.outfolder), {files(i:i+(inputs.nBracket-1)).name});
                    
                    if inputs.verbose
                        fprintf('copying JPGs for %s\n', files(i).name);
                    end
                end
            end
            vi.close();
        end
    end
end


function inputs = parseInputs(infolder, varargin)
    p = inputParser();
    p.addRequired('infolder', @sys.isdir);
    p.addParameter('nBracket', 3, @isnumeric);
    p.addParameter('outfolder', '', @ischar);
    p.addParameter('copyformat', 'CR2', @(x) validatestring(x, {'JPG', 'CR2'}));
%     p.addParameter('recursive', false, @islogical);
    p.addParameter('verbose', false, @islogical);
    p.addParameter('secondsCutoff', 5, @isnumeric);
    p.parse(infolder, varargin{:});
    inputs = p.Results;
end

