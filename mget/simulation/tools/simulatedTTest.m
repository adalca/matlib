function [hSorted, hBonferroniSorted, pval] = simulatedTTest(responses, labels, mode)
% run T-Tests on responses based on given labels. 
%   [hSorted, hBonferroniSorted, pval] = simulatedTTest(responses, labels, 'binary') run a 
%       standard ttest2() analysis between the two classes of labels. responses is N x nTests. 
%       labels is N x 1. hSorted are the indexes of all elementes that passed the p-value
%       curoff. hBonferroni also applies bonferroni correction. All outputs are 1 x nTests
%
%   [hSorted, hBonferroniSorted, pval] = simulatedTTest(responses, labels, 'linear') run a 
%       run a linear regression t-test on each combination of responses and labels. 
%       responses is N x nTests, labels is N x nLabels. The regression is respones(:, i) vs
%       labels(:, j), Therefore all outputs are nTests x nLabels.   
%
%   File contact: www.mit.edu/~adalca 


    nTests = size(responses, 2);
    
    % if binary, do a ttest2 on the two groups
    if strcmp(mode, 'binary')
        
        % run t-test for each voxel. 
        resp0 = responses(labels == 0, :);
        resp1 = responses(labels == 1, :);
        [h, p] = ttest2(resp0, resp1);
        
        % bonferroni correction
        hBonf = p < 0.05/nTests; 

        % sort the voxels that survive the null hypothesis based on p-value
        hSorted = findSorted(h, p);
        hBonferroniSorted = findSorted(hBonf, p);
        pval = p;

    % if linear, run linear regression ttest and get a pvalue from the fit.
    elseif strcmp(mode, 'linear')
        nLabels = size(labels, 2);
        
        pval = zeros(nTests, nLabels);
        
        for i = 1:nTests
            for j = 1:nLabels
                st = regstats(labels(:, j), responses(:, i), 'linear', 'tstat');
                pval(i, j) = st.tstat.pval(2);
            end
        end
        
        hSorted = pval < 0.05;
        hBonferroniSorted{i} = pval < 0.05 / (nTests * nLabels);
    end
end



function hFoundSorted = findSorted(h, wt, mode)
% find entries of h and sort them based on weights in wt

    if ~exist('mode', 'var')
        mode = 'ascend';
    end

    hFound = find(h);
    [~, sIdx] = sort(wt(hFound), mode);
    hFoundSorted  = hFound(sIdx);

end
