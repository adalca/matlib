function commentedTxt = commentText(txt, mode)
% COMMENTTEXT add comment flare to text
%   commentedTxt = commentText(text) outputs the given text with added comments.
%
%   commentedTxt = commentText(txt, mode) allows for specifying the comment mode: 
%       'simple' - just add a '%' at the beginning of the txt
%       'padded' - add a line of '%%......%' before and after the txt
%
% Contact: adalca.mit.edu


	if nargin == 1
		mode = 'simple';
	end

	% main comment
	str = sprintf('%% %s', txt);
	
	switch mode
		case 'simple'
			commentedTxt = str;
		case 'padded'
			percLine = sprintf('%c', repmat('%', [1, 80]));
			commentedTxt = sprintf('%s\n%s\n%s\n', percLine, str, percLine);
		otherwise
			error('unknown comment mode');
	end
			
end