function showStruct(ptStruct, prespace)
% prints a struct in a clean fashion
%   showStruct(ptStruct) prints struct ptStruct in a clean fashion. 
%
%   showStruct(ptStruct, prespace) prints struct ptStruct in a clean fashion. prespace
%   is printed ahead of the struct. This form is usually called from within showStruct.
%
% Author: adalca [at] mit [dot] edu



    if ~exist('prespace', 'var')
        prespace = [inputname(1), '.'];
    end

    fn = fieldnames(ptStruct);
    for i = 1:numel(fn);
        if isstruct(ptStruct.(fn{i}))
            showStruct(ptStruct.(fn{i}), [prespace, fn{i}, '.']);
        else 
            fprintf(1, '%s%s = ', prespace, fn{i});
            disp(ptStruct.(fn{i}));
        end
    end
    
end
