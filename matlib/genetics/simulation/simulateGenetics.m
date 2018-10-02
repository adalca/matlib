function genetics = simulateGenetics(nSubjects, nMarkers, shuffle, mafRange)
% SIMULATEGENETICS simulates SNPs based on MAF. 
%   markers = simulateGenetics(nSubjects, nMarkers, shuffle, mafRange)
%   simulates nMarkers SNPs for nSubjects subjects. Currently SNPs
%   illustrated by MAF {0, 1, 2}. nMarkers is the struct described in
%   simulateData. nSubjects is a scalar, shuffle is logical on whether the
%   marker types should be permuted. mafRange [optional] should be a range
%   for MAF sampling (uniformly). default: [0.05, 0.45];
%       
%   output: genetics struct with following fields. nTotalMarkers = sum(nMarkers(:))
%       .markers - nSubjects x nTotalMarkers matrix of MAFs.
%       .markerTypes - 1 x nTotalMarkers vector of the marker type in each
%           genetic position. marker type based on raster index of nMarkers
%       .nMarkers - copy of input nMarkers
%
%   Current simulation:
%       - estimate desired MAF for each location
%       - simulate alleles based on MAF at each location for nSubjects
%       - markers will therefore be {0, 1, 2}, with 0 indicating aa. 
%
%   See Also: simulateData
%
%   File contact: www.mit.edu/~adalca 


    if ~exist('mafRange', 'var')
        mafRange = [0.05, 0.45];
    end

    % input check and useful variables
    assert(nSubjects > 0, 'Number of subjects should not be 0');
    assert(isstruct(nMarkers), 'nMarkers should be a struct');    
    nTotalMarkers = sum(struct2array(nMarkers));   
    
    % decide on the population-wise MAF at each location.
    maf = unifrnd(mafRange(1), mafRange(2), [1, nTotalMarkers]);
    mafrep = repmat(maf, [nSubjects, 1]);

    % draw minor alleles from this population.
    allele1 = rand([nSubjects, nTotalMarkers]) < mafrep;
    allele2 = rand([nSubjects, nTotalMarkers]) < mafrep;
    
    % sum up the minor alleles. here marker = 2 means the individual has 2
    % minor alleles
    genetics.markers = allele1 + allele2;    
    
    
    % create marker type maps (voxel type \in {1..4} )
    assert(isequal(fieldnames(nMarkers), fieldnames(geneticType))); % needs to be same struct
    genetics.markerTypes = explodeCounts(struct2array(nMarkers), shuffle);
    
    genTypes = fieldnames(nMarkers);
    for i = 1:numel(genTypes);
        genetics.(genTypes{i}) = genetics.markerTypes == i;
    end
        
    
    % attach the matrix of number of markers to the genetics struct
    genetics.nMarkers = nMarkers;
end

