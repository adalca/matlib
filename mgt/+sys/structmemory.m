function varargout = structmemory(str)
% display struct along with memory information for each field
% TODO - make this be like fieldnames but fieldsmemory?

    % print info
    szstr = strrep(num2str(size(str)), '  ', 'x');
    s = sprintf('%s struct array with fields:\n', szstr);


    % go through fields    
    fields = fieldnames(str);
    fieldlen = max(cellfun(@numel, fields));
    msg = sprintf('\t%%%ds\t%%15s\n', fieldlen);
    mem = zeros(1, numel(fields));
    for i = 1:numel(fields)
        field = fields{i};
        x = {str.(field)}; %#ok<NASGU>
        whosnfo = whos('x');
        mem(i) = whosnfo.bytes;
        sizestr = humanReadableBytes(mem(i));
        s = [s, sprintf(msg, field, sizestr)];
    end
    
    % TODO: compare totals
%     sum([mem(:).bytes])
%     mem = whos('str');
%     mem.bytes
    
    if nargout == 0
        disp(s);
    else
        varargout{1} = s;
    end
    