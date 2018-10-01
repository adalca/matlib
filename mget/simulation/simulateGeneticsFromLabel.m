function genetics = simulateGeneticsFromLabel(nSubjects, labels, nMarkers, shuffle, controlDist, caseDist)
% wrapper for SIMULATEGENETICS simulates SNPs based on MAF. 
%
%   See Also: simulateData simulateGenetics
%
%   File contact: www.mit.edu/~adalca 



    % input check and useful variables
    assert(nSubjects > 0, 'Number of subjects should not be 0');
    assert(isstruct(nMarkers), 'nMarkers should be a struct');    
    
    nTotalMarkers = sum(struct2array(nMarkers));   
    assert(nTotalMarkers == nMarkers.EXPR_NONDIRCAUSAL_VOXCAUSAL + nMarkers.NONEXPR_NONDIRCAUSAL+ nMarkers.EXPR_NONDIRCAUSAL_NONVOXCAUSAL, ...
        'Label-first currently only allowing this genetics-voxel combination');

    % sample markers from given control/case distributions
    relevantMarkers = nMarkers.EXPR_NONDIRCAUSAL_VOXCAUSAL;
    ccMarkers = zeros(nSubjects, relevantMarkers);
    ccMarkers(labels, :) = sampleDistWithin02([sum(labels), relevantMarkers], controlDist{:});
    ccMarkers(~labels, :) = sampleDistWithin02([sum(~labels), relevantMarkers], caseDist{:});
    
    
    % get the simple /irrelevant makers
    fakeMarkers = nMarkers;
    fakeMarkers.EXPR_NONDIRCAUSAL_VOXCAUSAL = 0;
    irrelevantGenetics = simulateGenetics(nSubjects, fakeMarkers, shuffle);
    
    % combine all of the markers
    assert(~any(ccMarkers(:) == 3));
    
    % create marker type maps (voxel type \in {1..4} )
    assert(isequal(fieldnames(nMarkers), fieldnames(geneticType))); % needs to be same struct
    genetics.markerTypes = explodeCounts(struct2array(nMarkers), shuffle);

    genTypes = fieldnames(nMarkers);
    for i = 1:numel(genTypes);
        genetics.(genTypes{i}) = genetics.markerTypes == i;
    end
    
    % shuffle markers if necessary
    exactOpt = struct('reverse', false, 'exact', true);
    relevantMarkersIdx = struct2array(geneticType('EXPR_NONDIRCAUSAL_VOXCAUSAL', exactOpt));
    genetics.markers = zeros(nSubjects, nTotalMarkers);
    genetics.markers(:, genetics.markerTypes == relevantMarkersIdx) = ccMarkers;
    genetics.markers(:, genetics.markerTypes ~= relevantMarkersIdx) = irrelevantGenetics.markers;

    genetics.nMarkers = nMarkers;
end



function samples = sampleDistWithin02(samplesSize, varargin)
% sample from the given distribution under domain {0, 1, 2}

    % build distribution by sampling from given distribution, but omitting any
    % samples outside of [0, 2]. Then use the resulting distribution to
    % re-sample.
    samples = round(random(varargin{:}, 1000, 1));
    samples(samples < 0 | samples > 2) = [];
    histSamples = hist(samples, 0:2);
    dist = histSamples./sum(histSamples);
    
    % use dahua lin's discretesample code
    samples = discretesample(dist, prod(samplesSize)) - 1; % -1 since indexing at 1 in discre
    samples = reshape(samples, samplesSize); 
end