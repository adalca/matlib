function snps2latex(idsFile, chFile, tauFile, genesFile)
   
    fid = fopen(idsFile);
    idsScan = textscan(fid, '%s\n');
    fclose(fid);
    
    nIDs = numel(idsScan{1});
    idsMat = zeros(nIDs, 1);
    for i = 1:nIDs
        rsID = strtrim(idsScan{1}{i});
        idsMat(i) = str2num(rsID(4:end-1));
    end
    
    
    fid = fopen(chFile);
    chScan = textscan(fid, '%d\n');
    fclose(fid);
    chMat = chScan{1};
    
    fid = fopen(tauFile);
    tauScan = textscan(fid, '%f\n');
    fclose(fid);
    tauMat = tauScan{1};
    
    fid = fopen(genesFile);
    geneScan = textscan(fid, '%d\t%s');
    fclose(fid);
    
    [sTauMat, si] = sort(tauMat, 'descend');
    sIdsMat = idsMat(si);
    sChMat = chMat(si);
    
    
    
    for i = 1:nIDs
        f = find(geneScan{1} == sIdsMat(i));
        gene = geneScan{2}{f};
        fprintf(1, '%20s & %3d & %25s & %10.3f \\\\\n', sprintf('rs%d', sIdsMat(i)), sChMat(i), gene, sTauMat(i));
    end
    


end