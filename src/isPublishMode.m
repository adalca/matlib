function publishMode = isPublishMode()

    % check if we're in publishing mode
    st = dbstack;
    publishMode = ismember('publish', {st.name});