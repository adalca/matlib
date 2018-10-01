function images2folders(PATH, optext)
% moves images to date-named folders based on their imf (exif) info 

if ~exist('optext', 'var')
    optext = '';
else
    optext = [' --- ', optext];
end
    
d = dir(PATH);

for i = 1:numel(d);
    name = fullfile(PATH, d(i).name);
    if exist(name, 'file') ~= 2
        fprintf(1, '%s: not a file\n', name);
        continue;
    end
    
    [fPath, fName, ext] = fileparts(name);
    if strcmp(ext, '.jpg') || strcmp(ext, '.JPG') || strcmp(ext, '.bmp') || strcmp(ext, '.CR2')
        imf = imfinfo(name);
        
        if strcmp(ext, '.CR2')
            imf = imf(1);
        end
        
        if ~isfield(imf, 'DateTime')
            
            if ~isfield(imf, 'DigitalCamera')
                fprintf(1, '%s: not found imf.DateTime field\n', d(i).name);
                continue;
            end
            
            if ~isfield(imf.DigitalCamera, 'DateTimeOriginal')
                fprintf(1, '%s: not found imf.DateTime field\n', d(i).name);
                continue;
            end

            
            imf.DateTime = imf.DigitalCamera.DateTimeOriginal;
        end
        
        date = imf.DateTime;
        if numel(imf.DateTime) == 0
            fprintf(1, '%s: imf.DateTime empty\n', d(i).name);
            continue;
        end
        
        dateStr = imf.DateTime(1:10);
        assert(dateStr(5) == ':');
        dateStr(5) = '_';
        assert(dateStr(8) == ':');
        dateStr(8) = '_';
        
        dateStr = [dateStr, optext];
        if exist(fullfile(PATH, dateStr), 'dir') ~= 7
            mkdir(fullfile(PATH, dateStr));
        end
        movefile(name, fullfile(PATH, dateStr, d(i).name));
       
        cr2name = fullfile(PATH, [fName, '.CR2']);
        if exist(cr2name, 'file') == 2
             movefile(cr2name, fullfile(PATH, dateStr, [fName, '.CR2']));
        end
    end
    
end