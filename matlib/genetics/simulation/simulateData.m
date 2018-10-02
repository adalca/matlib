function [images, genetics, labels, weights] = simulateData(nSubjects, nMarkers, nVoxels, varargin)
% SIMULATEDATA simulates toy data for imaging genetics projects
%   [images, genetics, labels, weights] = simulateData(nSubjects, nMarkers, nVoxels) 
%   simulates the images, labels and genetic markers for the imaging genetics project. 
%   See below for an outline of the generative model for this simulation.
%
%   [imgs, labels, markers, idx] = simulateData(..., optionsStruct) allows for setting
%   optional parameters via the optionsStruct. See below for possible optional parameters and
%   default values.
%
%   [imgs, labels, markers, idx] = simulateData(..., 'optParam', param) allows for setting
%   optional parameters directly. See below for possible optional parameters and default values.
%
%   required parameters:
%       nSubjects   number of subjects
%       nMarkers    struct of numbers of genetic markers for each type. Genetic markers can be
%           expressed in voxels or not and directly causal to label or not. If expressed, the
%           relevant voxels can further be causal to the label or not. available types:
%             nMarkers.NONEXPR_DIRCAUSAL                
%             nMarkers.NONEXPR_NONDIRCAUSAL             
%             nMarkers.EXPR_DIRCAUSAL_VOXCAUSAL             
%             nMarkers.EXPR_DIRCAUSAL_NONVOXCAUSAL
%             nMarkers.EXPR_NONDIRCAUSAL_VOXCAUSAL
%             nMarkers.EXPR_NONDIRCAUSAL_NONVOXCAUSAL 
%       nVoxels     struct of numbers of voxels for each type. voxels can be influenced by genetics
%           or not, and causal to label or not. available types:
%             nVoxels.GENINFL_CAUSAL        1
%             nVoxels.NONGENINFL_CAUSAL     2
%             nVoxels.GENINFL_NONCAUSAL     3
%             nVoxels.NONGENINFL_NONCAUSAL  4
%   Note: see geneticType, voxelType, initType
%      
%   optional parameters. These can be inputted as either one options struct with some subset of these 
%       fields, or as ..., "name", value, ... pairs in the input.
%       imgNoiseStd     image noise std. 
%                       default: 0.0; 
%       labelNoiseStd   label score std. 
%                       default: 0.0;
%       labelContrib    weight of contributions to label from: 
%                       [NONEXPR_DIRCAUSAL, EXPR_DIRCAUSAL_VOXCAUSAL, EXPR_DIRCAUSAL_NONVOXCAUSAL
%                             GENINFL_CAUSAL, NONGENINFL_CAUSAL]. 
%                       default: [1,1,1,1,1]
%       labelThr        threshold for label score. default: 0, as scores are mean-normalized to 0;
%       weightDist      A cell array of the weight distribution and the relevant parameters as
%                       used in random().
%                           firstArg - name of distribution as taken by random(.) in stats toolbox
%                           second+args - arguments as needed by random(.) for selected distribution
%                       default: {'uniform', 0, 1}
%       controlGenDist
%       caseGenDist
%       controlVoxDist
%       caseVoxDist
%       imBases         
%       loadPlink
%       shuffle         whether to shuffle the indexes of marker/voxel types or not 
%                       default:false
%
%   outputs (we use N, V and S to indicate dimensions of matrices being dependent on the
%   correct numbers of subjects, voxels and genetics, respectively. N, V, and S are not set
%   numbers!)
%       images.clean        NxV the clean (non-noisy) simulated 'images' for each subject
%             .noisy        NxV images with added noise
%             .voxelTypes   vector of the type of voxel at each position based on nVoxels raster
%       weights.geneticsToCausalVoxels    SxV expressed markers to causal genetics-influenced voxels
%              .geneticsToNonCausalVoxels SxV expressed markers to non-causal  genetics-infl. voxels
%       	   .geneticsToLabels    Sx1 weights of causal markers 
%              .voxelsToLabels      Vx1 weights of causal voxels
%       genetics.markers    NxS the markers {0, 1, 2} for each subject
%               .markerTypes vector of the type of snps at each position based on nVoxels raster
%       labels              Nx1     the binary label for each subject       
%
%   Pseudocode, 2nd version:
%	- generate weights of each generative process: gen->vox; gen->label; vox->label
%       see simulateWeights for details
%	- generate markers for all subjects in a matrix (NxS).
%       see simulateGenetics for details
%	- generate images for all subjects in a matrix (NxV).
%       see simulateImages for details
%	- generate labels using a weight sum of inner products of images and genetics
%       see simulateLabels for details
%
%   Example:
%       see simulationTester for detailed examples, together with t-tests
%
%   See Also: sampleWeights, simulateWeights, simulateGenetics, simulateImages, simulateLabels,
%       simulatedTTest, simulationTester, geneticType, voxelType
%
%   File contact: www.mit.edu/~adalca 



    % check inputs and set missing parameters 
    inputs = parseInputs(nSubjects, nMarkers, nVoxels, varargin{:});
    

    
    
    switch inputs.runMode
        case 'geneticsFirst'
            disp('genetics generation starting')
            % generates weights
            weights = simulateWeights(inputs.nMarkers, inputs.nVoxels, inputs.weightDist{:});

            % get the genetic markers (NxS). markers \in {0, 1, 2}    
            if numel(inputs.loadPlink) == 0
                genetics = simulateGenetics(inputs.nSubjects, inputs.nMarkers, inputs.shuffle);
            else
                genetics = loadPlinkGenetics(inputs.loadPlink{:}, inputs.nMarkers, ...
                    inputs.nSubjects, inputs.shuffle);
            end 
            genetics.markers = bsxfun(@minus,genetics.markers, mean(genetics.markers));
            
            % generate images (cell #I with imSize entries). images.clean \in [0, 1]
            [images, weights] = simulateImages(genetics, weights, inputs);

            % generate labels for the subjects. 
            labels = simulateLabels(images, genetics, weights, inputs.labelContrib, ...
                inputs.labelThr, inputs.labelNoiseStd);

        case 'labelFirst'
            disp('label generation starting')
            
            % create up with the labels first
            % TODO - put this in simulateLabels for cleanliness?
            nControls = round(inputs.nSubjects/2);
            nCase = nSubjects - nControls;
            labels = [true(nControls, 1); false(nCase, 1)];
            
            % generates weights
            weights = simulateWeights(inputs.nMarkers, inputs.nVoxels, inputs.weightDist{:});
                        
            % get the genetic markers (NxS). markers \in {0, 1, 2}    
            if numel(inputs.loadPlink) == 0
                genetics = simulateGeneticsFromLabel(...
                    inputs.nSubjects, labels, inputs.nMarkers, inputs.shuffle, ...
                    inputs.controlGenDist, inputs.caseGenDist);
            else
                genetics = loadPlinkGenetics(inputs.loadPlink{:}, inputs.nMarkers, ...
                    inputs.nSubjects, inputs.shuffle);
            end
            genetics.markers = bsxfun(@minus,genetics.markers, mean(genetics.markers));

            % generate images (cell #I with imSize entries). images.clean \in [0, 1]
            [images, weights] = simulateImages(genetics, weights, inputs, labels);
            
        otherwise 
            error('invalid running mode');
    end
    
    % doTTest
    if inputs.doTTest(1)
        % G-I T-tests --- this takes a long time!
        figure(108);
        [h, hBonf, pval] = simulatedTTest(genetics.markers, images.noisy, 'linear');
        imshow(h);
    end
    if inputs.doTTest(2)
        figure(107); % TODO maybe 1 plot with 2 bg colors?
        [h, hBonf, pval] = simulatedTTest(genetics.markers, labels, 'binary');
        S = numel(pval);
        subplot(1, 2, 1); plotPredVar(binaryVec([S, 1], h), pval)
        subplot(1, 2, 2); plotPredVar(binaryVec([S, 1], hBonf), pval)
    end
    if inputs.doTTest(3)
        figure(108);
        S = numel(pval);
        [h, hBonf, pval] = simulatedTTest(images.noisy, labels, 'binary');
        subplot(1, 2, 1); plotPredVar(binaryVec([S, 1], h), pval)
        subplot(1, 2, 2); plotPredVar(binaryVec([S, 1], hBonf), pval)
    end
end



function inputs = parseInputs(nSubjects, nMarkers, varargin)
% parse the inputs for this simulation

% TODO - print inputs

    % parse given input
    p = inputParser;
    addRequired(p, 'nSubjects', @isnumeric);
    addRequired(p, 'nMarkers',@isstruct);           % TODO check correct nMarkers
    addOptional(p, 'nVoxels',[], @isstruct);        % TODO check correct nVoxels
    addOptional(p, 'imBases',[], @isnumeric);        
    addOptional(p, 'imgNoiseStd', 0, @isnumeric);  
    addOptional(p, 'labelNoiseStd', 0, @isnumeric);
    addOptional(p, 'labelContrib', [1, 1, 1, 1, 1], @isnumeric);
    addOptional(p, 'labelThr', 0, @isnumeric);
    addOptional(p, 'weightDist', {'norm', 0, 1});
    addOptional(p, 'shuffle', false, @islogical);
    addOptional(p, 'runMode', 'labelFirst', @allowedMode);
    addOptional(p, 'controlGenDist', {'norm', 0, 1}, @isdist);
    addOptional(p, 'caseGenDist', {'norm', 2, 1}, @isdist);
    addOptional(p, 'controlVoxDist', {'norm', -0.1, 1}, @isdist);
    addOptional(p, 'caseVoxDist', {'norm', 0.1, 1}, @isdist);
    addOptional(p, 'doTTest', [false, false, false], @islogical);
    addOptional(p, 'loadPlink', {}, @iscell);
    
    % prepare options
    if nargin == 3
        options = varargin{1};
        f = fieldnames(options);
        args = cell(numel(f) * 2, 1);
        for i = 1:numel(f);
            args{i*2-1} = f{i};
            args{i*2} = options.(f{i});
        end
        
    else
       assert(nargin == 2 || nargin > 3)
       args = varargin;
    end
    
    % prepare inputs
    parse(p, nSubjects, nMarkers, args{:});
    inputs = p.Results;
    
    % check that exactly one of nVoxels or imBases is given. 
    if numel(inputs.imBases) > 0
        assert(numel(inputs.nVoxels) == 0);
        inputs.nVoxels = basesToNVoxels(inputs.imBases);
    else
        assert(isstruct(inputs.nVoxels) && numel(inputs.nVoxels) == 1);
    end


    
    % normalize labelContrib with 1-norm;
    inputs.labelContrib = inputs.labelContrib ./ norm(inputs.labelContrib, 1);

    inputs
end


function res = binaryVec(sz, fill)
    res = zeros(sz);
    res(fill) = 1;
end

function isMode = allowedMode(runMode)
    isMode = ismember(runMode, {'labelFirst', 'geneticsFirst'});
end

function isDistribution = isdist(dist)
    isDistribution = iscell(dist);
    isDistribution = isDistribution && numel(dist) > 0 && ischar(dist{1});
end