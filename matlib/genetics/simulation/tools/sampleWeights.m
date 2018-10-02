function weights = sampleWeights(nWeights, distName, varargin)
% SAMPLEWEIGHTS samples normalized weights from given distribution
%   weights = sampleWeights(nWeights) returns nWeights weights sampled from a uniform 
%   distribution in range 0..1. nWeights is 1xN, where N indicates the desired output
%   dimensions. 
%
%   weights = sampleWeights(nWeights, distName, arg1, ...) returns nWeights normalized weights 
%   sampled from distName distribution.
%       distName - name of distribution as taken by random(...) in stats toolbox.
%       arg1, ... - arguments as needed by random(...) for selected distribution
%
%   Code for Imaging Genetics Project.
%   currently we simply sample weights using the distribution. In the future, we may want to do
%   something more complex in the future. 
%
% See Also: random
%
% Contact: www.mit.edu/~adalca 



    % default behaviour is uniform.
    if nargin == 1
        distName = 'uniform';
        varargin = {0, 1};
        %distName = 'norm';
        %varargin = {0, 1};
    end
    
    % a scalar nWeights should imply a vector of that length, not a matrix
    if numel(nWeights) == 1
        nWeights = [nWeights, 1];
    end

    % compute weight
    weights = random(distName, varargin{:}, nWeights);
    %switch distName
    %    case 'uniform'
    %        % do nothing
    %    case 'norm'
    %        weights = bsxfun(@times, 1./sqrt(sum(weights.^2)), weights) ;  % just to make sure that it is column normalize 
    %end
        
    %if numel(weights) > 0
    %    assert(sum(weights(:)) ~= 0, 'Sum of weights is 0');
    %    weights = weights ./ sum(weights(:));
    %end
end
