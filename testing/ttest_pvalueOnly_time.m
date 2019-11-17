function pValue = ttest_pvalueOnly_time(cellArray)
    RC = 1;
    meanVals = cellfun(@(x) squeeze(nanmean(squeeze(x(:, RC, :)), 2)), cellArray, 'uni', false);
    
    arrayDiff = cat(2, meanVals{:, 1}) - cat(2, meanVals{:, 2});
    nIters = 5000;
    [~, pValue, ~, ~, ~] = ttest_permute(arrayDiff, nIters);
end