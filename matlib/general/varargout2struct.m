function stout = varargout2struct(fn, args, varargin)
% example: stout = varargout2struct(@sort, {[5, 6, 1, 2, 12]}, 'm', 'mi')
    
    nout = numel(varargin);
    v = cell(nout, 1);
    [v{:}] = fn(args{:});
    
    % deal with cells properly (wrap any cell output in a 1x1 cell, else struct() will build many
    % structs (as many as elements in the cell)
    isc = cellfun(@iscell, v);
    v(isc) = cellfunc(@(x) {x}, v(isc));
    
    % build output structu
    stargs = cell(nout * 2, 1);
    stargs(1:2:end) = varargin;
    stargs(2:2:end) = v;
    stout = struct(stargs{:});
    