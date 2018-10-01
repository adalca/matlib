function is = isconsecutive(fileRange)
	is = all(diff(fileRange) == 1);
end