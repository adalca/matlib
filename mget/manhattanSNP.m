function manhattanSNP(prob, chrs)
% MANHATTANSNP chromosome colored manhattan plot of SNP probabilities
%   MANHATTANSNP(prob, chrs) draws a manhattan plot of SNP probabilities <prob> (N x 1), where each 
%   snp chromosome is given in <chrs> (Nx1). SNPs are grouped by chromosome, and SNP probabilities 
%   for the same chromsome are colored together.
%
%   inputs:
%       prob - Nx1 vector of probabilities [0..1] for each SNP
%       chrs - Nx1 vector of chromsomes [1..23] for each SNP
%
%   silly example:   
%       p = rand(1, 30);
%       c = [ones(1, 10), 12*ones(1, 10), 14*ones(1, 10)]
%       manhattanSNP(p, c)



    % check inputs
    narginchk(2, 2);

    % display results in a chromosomal figure
    figure(); clf; hold on;
    
    % some title and label information
    title('Average call probability for genetic variants', 'FontSize', 20);
    xlabel('SNPs (colored by chromosome)', 'FontSize', 20);
    ylabel('Probability', 'FontSize', 20);
    set(gca,'fontsize',14) ;
    axis([0, numel(prob), 0, 1]);
    
    % plot middle line
    plot([0,  numel(prob)], [0.5, 0.5], '--k');
    
    % prepare x ticks and labels
    xTicks = zeros(1, numel(chrs));
    xTickLabels = cell(1, numel(chrs));
    
    % prepare color scheme
    cmap = lines(numel(chrs));
    colorder = randperm(numel(chrs));
    
    % go through chromosomes
    uchrs = unique(chrs);
    for i = 1:numel(uchrs)
        chr = uchrs(i);
        
        % get a new color for this chromosome
        col = cmap(colorder(i),:);
        
        % display this chromosome
        chIdx = find(chrs == chr);
        bar(chIdx, prob(chIdx), 'FaceColor', col, 'EdgeColor', col);
        
        % set the xTick in the middle of the chromosome.
        xTicks(i) = mean(chIdx);
        xTickLabels{i} = sprintf('%i', chr);
    end
    
    % clean up x ticks if two adjacent ticks are too close to each other.
    i = 2;
    while i <= numel(xTicks)
        if (xTicks(i) - xTicks(i-1)) <  numel(prob)/10;
            xTicks(i) = [];
            xTickLabels(i) = [];
        else
            i = i + 1;
        end
    end
    set(gca,'XTick', xTicks, 'XTickLabel', xTickLabels);
    