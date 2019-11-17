function out = ragu_computeMeans(inData, settings)
    
    [~, nConditions, nCh, nSamples] = size(inData.eeg);
    nUniqueSubj = size(inData.avgEEG, 1);
    b = unique(settings.BetweenGroups(~isnan(settings.BetweenGroups))); %Groups
    nGroups = sum(~isnan(b));
    
    % data.all_mu(:, :, rc, :)
    % data.all_s(:, :, rc, :)
    % data.group_mu(:, rc, :)
    % data.group_s(:, rc, :)
    % data.condition_mu(:, rc, :)
    % data.condition_s(:, rc, :)
    %%
    try
        %reshape if no real groups, only sub-groups (same number of subjs for each group)
        meanData = reshape(inData.eeg, [nUniqueSubj nGroups nConditions nCh nSamples]);
        means = squeeze(mean(meanData, 1));
        gfp = sqrt(nanmean(means.^2, 3));

        out.means = squeeze(mean(meanData, 1));
        out.meansGFP = squeeze(gfp);
        out.gmeans = squeeze(mean(out.means, 2));
        out.cmeans = squeeze(mean(out.means, 1));
        
    catch
        % different number of subjects for each 
        for g = 1:nGroups
            currGroup = inData.eeg(settings.BetweenGroups == b(g), :, :, :);
            nSubjsGroup = size(currGroup, 1);
            out.gmeans(g, :, :)  = mean(reshape(currGroup, [nConditions*nSubjsGroup, nCh, nSamples])); 
            out.means(g, :, :, :) = squeeze(mean(currGroup, 1)); 
        end
        out.cmeans = squeeze(mean(out.means, 1));
    end    
end