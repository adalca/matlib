function usrn = usrname()
    [~, whoami] = system('whoami');
    spl = strsplit(whoami, '\');
    usrn = strtrim(spl{end}); 