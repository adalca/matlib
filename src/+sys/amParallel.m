function am = amParallel()
% AMPARALLEL true iff parallel pool is open
%   am = amParallel() returns true if and only if parallel pool is open
%
% See Also: matlabpool
%
% Contact: adalca.mit.edu

    am = matlabpool('size') ~= 0;
