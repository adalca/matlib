function genetics = loadPlinkGenetics(dataFileName, setupFileName, nMarkers, nSubjects, shuffle)

    
    disp('loading plink data');

    % check that the simulated data from plink is as we expect it. 
    % read setupFileName .sim
    fid = fopen(setupFileName);    
    assert(fid > 2, 'Could not open file %s (%i)', setupFileName, fid)
    fileScan = textscan(fid, '%d %s %f %f %f %s\n');
    fclose(fid);
    
    % get the number of SNPs and check that the numbers match our nMarkers. 
    nSNPs = fileScan{1};
    nNonCausal = nMarkers.NONEXPR_NONDIRCAUSAL + nMarkers.EXPR_NONDIRCAUSAL_NONVOXCAUSAL;
    switch numel(nSNPs)
        case 2 % assume a 'null' set and a 'snp' set.           
            assert(nNonCausal  == nSNPs(1), '%i %i', nNonCausal, nSNPs(1));
            assert(nMarkers.EXPR_NONDIRCAUSAL_VOXCAUSAL == nSNPs(2));
            
        otherwise
            error('number of SNP categories not implemented yet');
    end
    
    % TODO - update nMarkers, instead of makign sure I agree with it....
    % or if plink data is provided, ignore nMarkers (?). Can't really since
    % want to have some of the non-disease still be relevant to voxels.
    
    
    % load first mat file
    rep = load(dataFileName); % should load variable DataMatrix
    DataMatrix = rep.DataMatrix;
    assert(size(DataMatrix, 1) == nSubjects, ...
        'PLINK Subj: %i, expects Subj: %i', size(DataMatrix, 1), nSubjects);
    
    % create marker type maps (voxel type \in {1..4} )
    assert(isequal(fieldnames(nMarkers), fieldnames(geneticType))); % needs to be same struct
    genetics.markerTypes = explodeCounts(struct2array(nMarkers), shuffle);
    
    % shuffle markers if necessary
    options = struct('reverse', false, 'exact', true);
    relevantIdx = struct2array(geneticType('EXPR_NONDIRCAUSAL_VOXCAUSAL', options));
    genetics.markers = zeros(size(DataMatrix));
    genetics.markers(:, genetics.markerTypes ~= relevantIdx) = ...
        DataMatrix(:, 1:nNonCausal);
    genetics.markers(:, genetics.markerTypes == relevantIdx) = ...
        DataMatrix(:, nNonCausal+1:end);
    
    genTypes = fieldnames(nMarkers);
    for i = 1:numel(genTypes);
        genetics.(genTypes{i}) = genetics.markerTypes == i;
    end
    
    % attach the matrix of number of markers to the genetics struct
    genetics.nMarkers = nMarkers;
    