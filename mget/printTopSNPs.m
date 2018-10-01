function printTopSNPs(prob, snpIDs, chMAP, thr)
% PRINTTOPSNPS prints the top snps according to given posteriors
%   PRINTTOPSNPS(prob, snpIDs, chMAP, thr) prints the tops snps according to the given
%   posteriors in Nx1 <prob>. <snpIDs> should be a Nx1 cell array of strings and <chMap> 
%   should be a Nx1 vector of chromosomes representing the id and chromosomes of the snps, 
%   respectively. To print the top SNPs, either choose a probability threshold in [0, 1), which
%   prints all SNPs with equal or higher probability, or set thr to an integer to print that
%   many top SNPs.
%
%   Example:
%       prob = [0.1, 0.4, 0.6, 0.9];
%       snpIDs = {'rs101', 'rs102', 'rs103', 'rs104'};
%       chMAP = [1, 1, 2, 7];
%       printTopSNPs(prob, snpIDs, chMAP, 0.5); 
%                 Number of snps with average > 0.5: 2
%                  rank SNPID   prob           RSnr ch
%                     1     4   0.90          rs104  7
%                     2     3   0.60          rs103  2
%       printTopSNPs(prob, snpIDs, chMAP, 3); 
%                 Number of snps with average > 0.5: 3
%                  rank SNPID   prob           RSnr ch
%                     1     4   0.90          rs104  7
%                     2     3   0.60          rs103  2
%                     3     2   0.40          rs102  1



    % if the threshold is [0..1), use it as a threshold on the probabilities. 
    % otherwise, it should be an integers >=1, and we'll print that many top SNPs.
    if thr < 1
        assert(thr >= 0)
        nPass = sum(prob >= thr);
    else
        assert(rem(thr, 1) == 0); % make sure it's an integer
        nPass = thr;
    end
    
    % print table
    [~, s] = sort(prob, 'descend');
    
    fprintf(1, 'Number of snps with average > 0.5: %i\n', nPass);
    fprintf(1, '%5s%6s%7s%15s%3s\n', 'rank', 'SNPID', 'prob', 'RSnr', 'ch');
    for c = 1:nPass
        fprintf(1, '%5i%6i%7.2f%15s%3i\n', ...
            c, s(c), prob(s(c)), snpIDs{s(c)}, chMAP(s(c)));
    end