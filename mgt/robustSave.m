function robustSave(varargin)
% try to save as given, and if get sizeTooBigForMATFile warning, try again in -v7.3 mode

    if any(strcmp(varargin, '-v7.3'));
        error('robustSave will try to save without v7.3, otherwise with. Please omit -v7.3 flag');
    end

    % clear last warning
    lastwarn('','')
    
    % try to save 
    cmdStr = sprintf('save(%s%s)', repmat(['''%s'','], 1, numel(varargin) - 1), '''%s''');
    cmd = sprintf(cmdStr, varargin{:});
    disp(cmd)
    evalin('caller', cmd);
    
    % if we get a sizeTooBigForMATFile warning, try -v7.3
    [msg, mi] = lastwarn();
    if strcmp(mi, 'MATLAB:save:sizeTooBigForMATFile')
        warning('ROBUSTSAVE:save:sizeTooBigForMATFile', ...
            'Big File Warning caught during save. trying -v7.3');
        delete(varargin{1});
        
        cmdStr = sprintf('save(%s%s)', repmat(['''%s'','], 1, numel(varargin)), '''%s''');
        cmd = sprintf(cmdStr, varargin{:}, '-v7.3');
        disp(cmd)
        evalin('caller', cmd);
        
    end
       
    % if we got a warning and it wasn't sizeTooBigForMATFile, throw an error
    if ~strcmp(mi, '') && ~strcmp(mi, 'MATLAB:save:sizeTooBigForMATFile')
        error(msg);
    end
     