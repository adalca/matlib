function publishMode = isPublishMode()
% ISPUBLISHMODE checklogical if running in publish mode
%   publishMode = isPublishMode() logical if currently running in publish mode
%
% See Also: publish
%
% Contact: http://adalca.mit.edu

    % check if we're in publishing mode
    st = dbstack;
    publishMode = ismember('publish', {st.name});
