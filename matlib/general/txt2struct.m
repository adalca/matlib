function struc = txt2struct(filename)
% struc = txt2struct(filename)
% Takes a file that looks like this:
%  key1 = val1
%  key2 = val2
%  ...
% and returns a struct that looks like
%  struc.key1 = 'val1'
%  struc.key2 = 'val2'
%  ...
% All keys and values are treated as strings.
struc = struct();
f = fopen(filename);

% Code adapted + simplified from stack overflow
% http://stackoverflow.com/questions/10880754/how-to-read-a-structure-from-txt-file-in-matlab
lines = textscan(f, '%s', 'Delimiter',''); 
lines = lines{1};

strings = regexp(lines, '(\w+)\s*[:=]\s*([^%$]*)(?:%[^$]*)?', 'tokens', 'once');
strings = vertcat(strings{:});
for j=1:size(strings,1)
    struc.(strings{j,1}) = strings{j,2};
end
