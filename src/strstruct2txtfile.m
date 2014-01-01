function strstruct2txtfile(struc, filename)
% STRSTRUCT2TXTFILE write a structure where all values are strings to text file
% 	strstruct2txtfile(struc, filename) write a structure struc, where all values are strings, 
% to text file
%
% If a struct looks like
%  struc.key1 = 'val1'
%  struc.key2 = 'val2'
%  ...
%
% This will be written to file:
%  key1 = val1
%  key2 = val2
%  ...
%
% All keys and values are treated as strings.
%
% Added functionality 10/9/2012: second parameter can be a fid. 
%
% Contact: adalca@mit.edu

if ischar(filename)
    f = fopen(filename,'w');
else
    assert(isnumeric(filename));
    f = filename;
end
    
    
% TODO check that all values are strings
for fieldName = fieldnames(struc)'
    fprintf(f,'%s = %s\n',char(fieldName), struc.(char(fieldName)));
end

if ischar(filename)
    fclose(f);
end
