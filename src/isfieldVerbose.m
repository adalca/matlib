function isp = isfieldVerbose(params, field, usageMsg)
% ISFIELDVERBOSE do isfieldcheck and complain if false
%   isp = isfieldVerbose(params, field, usageMsg) perform a isfield(params, field) 
%       and if it's false, print out a message according to useageMsg to stderr
%
% Example:
%   >> x = struct();
%   >> is = isfieldVerbose(x, 'notAField', ':(')
%   Field Missing: notAField. :(
%   is =
%        0
%
% See Also: isfield
%
% Contact: http://adalca.mit.edu

    isp = isfield(params, field);
    if ~isp
        fprintf(2, 'Field Missing: %s. %s', field, usageMsg);
    end
end
