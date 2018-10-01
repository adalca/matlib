function simulationTester(rTests)
% test simulateData simulation strategies.
%   simulationTester(rTests) rTest is an array of test numbers to test.
%   
%   To implement new tests, see prepareCase() below. In summary, one generates the number of
%    of each of genetics and imaging via initType, sets up any other arguments for
%    simulateData, and extracts the ground truth types for genetics and imaging relevant to 
%    the label via typeIdx
%
%   for more details on the simulations, see the documention in simulateData.
%
% See also simulateData, geneticType, voxelType
%
% Author: adalca [at] mit [dot] edu

    % add genpath of current path to include all useful functions. 
    [mFolder, ~, ~] = fileparts(mfilename('fullpath'));
    addpath(genpath(fullfile(mFolder)));
    
    % number of subjects
    nSubjects = 1000;

    % go through all of the tests
    for i = rTests
    
        % setup the case. see prepareCase() for detailed info.
        [nMarkers, nVoxels, args, gtGeneticTypes, gtVoxelTypes, caseTitle] = prepareCase(i);

        % print header
        fprintf(1, '\nCase %i. %s\n', i, caseTitle);
        
        % run simulation
        [images, genetics, labels, weights] = simulateData(nSubjects, nMarkers, nVoxels, args{:});
        
        % analyze results.
        ttestAnalyze(images, genetics, labels, weights, gtGeneticTypes, gtVoxelTypes);
       
    end
end % main function



function [nMarkers, nVoxels, args, gtGeneticTypes, gtVoxelTypes, caseTitle] = prepareCase(i)
% prepare test cases.
%    In summary, one generates the number of of each of genetics and imaging via initType, sets
%    up any other arguments for simulateData, and extracts the ground truth types for genetics
%    and imaging relevant to the label via typeIdx.
%
% genetics order:
% 'NONEXPR_DIRCAUSAL', 'NONEXPR_NONDIRCAUSAL', 'EXPR_DIRCAUSAL_VOXCAUSAL', 
% 'EXPR_DIRCAUSAL_NONVOXCAUSAL', 'EXPR_NONDIRCAUSAL_VOXCAUSAL', 'EXPR_NONDIRCAUSAL_NONVOXCAUSAL'
%
% voxel order
% 'GENINFL_CAUSAL', 'NONGENINFL_CAUSAL', 'GENINFL_NONCAUSAL', 'NONGENINFL_NONCAUSAL'

    exactOpt = struct('reverse', false, 'exact', true);
    switch i
        case 1
            % sanity check: case of genetics to causal voxels, causal voxels to label ONLY, 
            % low noise simulation parameters
            nMarkers = initType(geneticType, [0, 0, 0, 0, 10, 0]);
            nVoxels = initType(voxelType, [10, 0, 0, 90]);
            args = {'imgNoiseStd', 0.01, 'labelNoiseStd', 0.0001, 'labelContrib', [0, 0, 0, 1, 0]};
            gtGeneticTypes = typeIdx(@geneticType, 'EXPR_NONDIRCAUSAL_VOXCAUSAL', exactOpt);
            gtVoxelTypes = typeIdx(@voxelType, 'GENINFL_CAUSAL',exactOpt);
            caseTitle = 'EXPR_NONDIRCAUSAL_VOXCAUSAL:GENINFL_CAUSAL';

        case 2
            % genetics: expr, directly causal, non-causal voxels
            % voxels: non-gen infl, non-causal
            % low noise simulation parameters
            nMarkers = initType(geneticType, [0, 0, 0, 10, 0, 0]);
            nVoxels = initType(voxelType, [0, 0, 0, 100]);
            args = {'imgNoiseStd', 0.01, 'labelNoiseStd', 0.0001, 'labelContrib', [0, 0, 1, 0, 0]};
            gtGeneticTypes = typeIdx(@geneticType, 'EXPR_DIRCAUSAL_NONVOXCAUSAL',exactOpt);
            gtVoxelTypes = []; 
            caseTitle = 'EXPR_DIRCAUSAL_NONVOXCAUSAL:NONGENINFL_NONCAUSAL';

        case 3
            % genetics: expr, directly causal, non-causal voxels
            % voxels: causal voxels
            % low noise simulation parameters
            nMarkers = initType(geneticType, [0, 0, 0, 10, 0, 0]);
            nVoxels = initType(voxelType, [0, 10, 0, 90]);
            args = {'imgNoiseStd', 0.01, 'labelNoiseStd', 0.0001, 'labelContrib', [0, 0, 1, 0, 1]};
            gtGeneticTypes = typeIdx(@geneticType, 'EXPR_DIRCAUSAL_NONVOXCAUSAL',exactOpt);
            gtVoxelTypes = typeIdx(@voxelType, 'NONGENINFL_CAUSAL',exactOpt);
            caseTitle = 'EXPR_DIRCAUSAL_NONVOXCAUSAL:NONGENINFL_CAUSAL';

        otherwise
            error('Case %i not implemented yet!', i);
    end

end


function ttestAnalyze(images, genetics, labels, weights, gtGeneticTypes, gtVoxelTypes)
% analyze and print out information about ttests run on the resulting simulation and expected
% relevant genetics/voxel types. 

    % imaging (voxels) t-test vs label
    [imH, imHBonf, imP] = simulatedTTest(images.noisy, labels, 'binary');
    idx = find(ismember(images.voxelTypes, gtVoxelTypes));
    fprintf(1, 'voxels to label         : intersect %i, union:%i\n', ...
        numel(intersect(idx, imH)), numel(union(idx, imH)));
    fprintf(1, 'voxels to label (bonf)  : intersect %i, union:%i\n', ...
        numel(intersect(idx, imHBonf)), numel(union(idx, imHBonf)));

    % genetics t-test vs label
    [genH, genHBonf, genP] = simulatedTTest(genetics.markers, labels, 'binary');
    idx = find(ismember(genetics.markerTypes, gtGeneticTypes));
    fprintf(1, 'genetics to label       : intersect %i, union:%i\n', ...
        numel(intersect(idx, genH)), numel(union(idx, genH)));
    fprintf(1, 'genetics to label (bonf): intersect %i, union:%i\n', ...
        numel(intersect(idx, genHBonf)), numel(union(idx, genHBonf)));

    % genetics (makers) t-test vs image
    [h, hBonf, pval] = simulatedTTest(genetics.markers, images.noisy, 'linear');
    % TODO - not sure how to print these results. h and hBonf are matrices of SNPs vs Voxels
end



function idx = typeIdx(classType, str, varargin)
% return the indexes of the relevant types of genetics/voxels. Types are specified as
% string/cellstr in str, and the classType is @geneticType or @voxelType.

    idx = struct2array(classType(str, varargin{:}));
end
