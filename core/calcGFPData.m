function [mu, s] = calcGFPData(dataCell)

    nsubjs = size(dataCell, 1);
    avgConditions = cell(nsubjs, 1);
    for ns = 1:nsubjs
        avgConditions{ns} = cat(3, dataCell{ns, :});
    end
    
    meanData = cellfun(@(x) nanmean(x, 3), avgConditions, 'uni', false);
    %GFP = cellfun(@(x) sqrt(sum(x.^2, 2)), meanData, 'uni', false);
    GFP = cellfun(@(x) gfpData(x), meanData, 'uni', false);
    catData = cat(3, GFP{:});
    
    mu0 = mean(catData, 3);
    mu = mu0 - mu0(1);
    s = std(catData, [], 3)/(sqrt(size(catData, 3)));   
end