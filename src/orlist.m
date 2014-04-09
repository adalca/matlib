function y = orlist(X, cmd, lst)
    y = cmd(X, lst(1));
    for i = 2:numel(lst)
        y = y | cmd(X, lst(i));
    end
        