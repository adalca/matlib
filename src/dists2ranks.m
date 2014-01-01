function [ranks, aggRanksIdx] = dists2ranks(dst1, dst2, verbose)
% DISTS2RANKS return the joint ranks of elements based on given distances
%
%	TODO: allow many distances

    nSubjects = numel(dst1);

    % sort
    [~, d1Idx] = sort(dst1, 'ascend');
    [~, d2Idx] = sort(dst2, 'ascend');
    
    % join ranks
    ranks = zeros(nSubjects, 2);
    for i = 1:nSubjects
        ranks(i, 1) = find(d2Idx == i);
        ranks(i, 2) = find(d1Idx == i);
    end

    % aggregate ranks.
    aggranks = sum(ranks, 2);
    [~, aggRanksIdx] = sort(aggranks, 'ascend');
    
    % plot ranks
    if verbose
        figure(); plot(ranks(:, 1), ranks(:, 2), '.');
    end