function fname = funcname(stackdel)
% get (caller's) function name.

    if nargin == 0
        stackdel = 0;
    end

    st = dbstack;
    if numel(st) >= (2 + stackdel)
        fname = st(2 + stackdel).name; % todo: look up caller
    else
        fname = 'workspace';
    end
    