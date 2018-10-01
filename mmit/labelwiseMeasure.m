function distances = labelwiseMeasure(vols, labelMasks, distMethod)
% LABELWISEMEASURE - compute a volume measure (e.g. distance, similarity) for each label
%   distances = labelwiseMeasure(vols, labelMasks, distMethod) compute a measure (e.g.
%   some distance or similarity) amoung the volumes in the 1xN vols cell array. Volumes can be any 
%   dimension/size, but have to have same sizes as each-other. labelMasks is a
%   1xM cell array of logical label masks, where each mask is a volume of the same size as the input 
%   volumes. distMethod is a method handle for a measure that takes N vectors as input.
%   
% Example:
% distances = labelwiseMeasure({v1, v2}, {lab1, lab2, lab3}, @ssd)
% 	Computes the ssd distance between volumes v1 and v2 in the masks given by the 3 label masks.
%	distances is then 3 x 1.
%
% TODO: for a distance like SSD, it may be useful to do an op before the labels loop, like 
%   diffImg = (im1 - im2) .^2; might be worth comparing runtime.
%
% Author: Adrian Dalca, http://adalca.mit.edu

    % check inputs
    narginchk(3, 3);
    nLabels = numel(labelMasks);
    nVols = numel(vols);
    
    % initialize distances
    distances = zeros(nLabels, 1);
    
    for i = 1:nLabels
        % extract label mask
        iml = labelMasks{i};
        
        % extract volumes in the label masks
        subVols = cell(nVols, 1);
        for v = 1:nVols
            subVols{v} = vols{v}(iml);
        end
        
        % compute the distance
        distances(i) = distMethod(subVols{:});
    end

end
