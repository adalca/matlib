function str = strtrimchr(str, chr)
% like strtrim but for any given character
    
    m = find(str ~= chr);
    str = str(min(m):max(m));
