function [dst, labels] = dice(vol1, vol2, labels)
% DICE dice metric between two volumes
%   
% [dst, labels] = dice(vol1, vol2) compute the dice metric for each label in the two label volumes
% vol1 and vol2. Volumes should be the same size. dst is a nUniqueLabels-by-1 vector where
% nUniqueLabels is the number of unique labels found in the two volumes, combined. labels is a
% nUniqueLabels-by-1 vector listing the labels used.
% 
% [dst, labels] = dice(vol1, vol2, labels) allows the specification of specific label(s) over which
% the dice metric should be computed. dst is then length(labels)-by-1.
%
% Formula: 
% DICE(label) = 2 * sum(intersection(vol1_label, vol2_label)) ./ (sum(vol1_label) + sum(vol2_label))
%
% Contact: adalca@csail.mit.edu

    % parse inputs
    narginchk(2, 3);
    if nargin < 3 
        labels = unique([vol1(:); vol2(:)]);
    end
    assert((ndims(vol1) == ndims(vol2)) && all(size(vol1) == size(vol2)));

    % go through labels
    dst = zeros(numel(labels), 1);
    for i = 1:numel(labels)
        label = labels(i);
        
        % compute the label masks for this label
        vol1bw = vol1(:) == label;
        vol2bw = vol2(:) == label;
        
        % compute intersection
        intx = vol1bw & vol2bw;
        
        % compute dice
        dst(i) = 2 * sum(intx) ./ (sum(vol1bw) + sum(vol2bw));
    end
    