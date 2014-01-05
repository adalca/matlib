function isp = isfieldVerbose(params, field, usageMsg)
    isp = isfield(params, field);
    if ~isp
        fprintf(2, 'Field Missing: %s. %s', field, usageMsg);
    end
end