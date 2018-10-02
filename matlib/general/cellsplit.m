function varargout = cellsplit(c)
% CELLSPLIT split up a cell into separate variables
%	[a, b, ...] = cellsplit(c) split up a cell c into separate variables
%
% Example: 
%	>> [a, b] = cellsplit({2, 3})
%	a =
%		 2
%	b =
%		 3
%
% This is a different way of writing
%	>> [a, b, ...] = c{:}
% but this latter syntax is not possible in more convoluted lines of code 
% (which I don't recomment too much, but sometimes they show up)
%
% Contact: adalca@csail.mit.edu

        varargout = c;
