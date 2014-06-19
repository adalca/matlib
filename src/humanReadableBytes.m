function [sout, amt, unit] = humanReadableBytes(bytes)

    m = 1024;

    units = {'B', 'kB', 'MB', 'GB', 'TB'};
    
    amt = bytes;
    unit = units{1};
    for i = numel(units):-1:1
        if bytes > m ^ (i - 1)
            amt = bytes ./ m ^ (i-1);
            unit = units{i};
            break;
        end
    end
    
    sout = sprintf('%3.1f %s', amt, unit);
    