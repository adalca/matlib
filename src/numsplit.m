function varargout = numsplit(c)
% NUMSPLIT split up a number vector into separate variables
%	[a, b, ...] = numsplit(c) split up a number vector c into separate variables
%
% Example: 
%	>> [a, b] = numsplit([2, 3])
%	a =
%		 2
%	b =
%		 3
%
% This is a more compact way to write 
%	>> d = num2cell(c); [a, b, ...] = d{:}
%
% Contact: adalca@csail.mit.edu

        varargout = num2cell(c);
		