function lib = getrows(ptr, var, idx)
% get the rows idx of variable var in mfile pts
    
    assert(isvector(idx));

    % go through blocks
    diffidx = diff(idx(:)');
    diffidx = [diffidx(1) diffidx];
    f = find([1, diff(diffidx)] > 0);
    fprintf('getrows blocks %d\n', numel(f));
    
    
    lib = zeros(length(idx), size(ptr, var, 2)); %#ok<*GTARG>
    
    for i = 1:numel(f)
        % fprintf('getrows %f\n', i ./ numel(f));
        
        if i == numel(f)
            rows = f(i):numel(idx);
        else
            rows = f(i):(f(i+1)-1);
        end
        lib(rows, :) = ptr.(var)(idx(rows), :);
    end
end
