 function out = ragu_projectRawData(dataTanova, rcWeights)
    
    nGroups = size(dataTanova.rawData, 1);
    nConditions = size(dataTanova.rawData{1}, 2);
    nSubjs = sum(cell2mat(cellfun(@(x) size(x, 1), dataTanova.eegGrouped, 'uni', false)));
    nSamples =  size(dataTanova.eegGrouped{1}, 4);
    % workaround to avoid projecting mean subj data for sensor-space RAGU
    noProjEEG = 0;
    if (~isstruct(rcWeights))
        W_all.W_g = repmat({rcWeights}, [nGroups, 1]);
        W_all.W_c = repmat({rcWeights}, [nConditions, 1]);
        W_all.W_gc = repmat({rcWeights}, [nGroups nConditions]);
        noProjEEG = 1;
    else
        W_all = rcWeights;
    end
    
    nRCs = size(W_all.W_g{1}, 2);
    projectedRCTanova = zeros(nSubjs, ...
        nConditions, nRCs, nSamples);
    
    group_mu = zeros(nGroups, nRCs, nSamples);
    group_s = zeros(nGroups, nRCs, nSamples);
    
    condition_mu = zeros(nConditions, nRCs, nSamples);
    condition_s = zeros(nConditions, nRCs, nSamples);
    
    all_mu = zeros(nGroups, nConditions, nRCs, nSamples);
    all_s = zeros(nGroups, nConditions, nRCs, nSamples);
    
    gfp_group_mu = zeros(nGroups, 1, nSamples);
    gfp_group_s = zeros(nGroups, 1, nSamples);
    
    gfp_condition_mu = zeros(nConditions, 1, nSamples);
    gfp_condition_s = zeros(nConditions, 1, nSamples);
    
    gfp_all_mu = zeros(nGroups, nConditions, 1, nSamples);
    gfp_all_s = zeros(nGroups, nConditions, 1, nSamples);
    
    
    startIdx = 0;
    for g = 1:nGroups
        currGroup = dataTanova.rawData{g};
        groupCell = cat(1, currGroup(:));
        % project group for plotting
        [gfp_group_mu(g, 1, :), gfp_group_s(g, 1, :)] = calcGFPData(currGroup); 
        
        [mG, sG] = rcaProjectmyData(groupCell, W_all.W_g{g});        
        group_mu(g, :, :) = mG';
        group_s(g, :, :) = sG';
        
        nS = size(dataTanova.rawData{g}, 1);
        for c = 1:nConditions
            gcData = dataTanova.rawData{g}(:, c);
            [gfp_all_mu(g, c, 1, :), gfp_all_s(g, c, 1, :)] = calcGFPData(gcData); 
            [mGC, sGC] = rcaProjectmyData(gcData, W_all.W_gc{g, c});
            
            all_mu(g, c, :, :) = mGC';
            all_s(g, c, :, :) = sGC';
                        
            dataToProject = squeeze(dataTanova.eegGrouped{g}(:, c, :, :));
            if (~noProjEEG)
                projResult = rcaProject(dataToProject, W_all.W_gc{g, c});
            else
                projResult = dataToProject;
            end
            %baseline data
            endIdx = startIdx + nS;
            projectedRCTanova(startIdx + 1:endIdx, c, :, :) = baseline3DData(projResult);
        end
        startIdx = endIdx;
    end
    conditionsData = cat(1, dataTanova.rawData{:});
    gfpConditionsData = cat(3, dataTanova.rawData{:});
    for c = 1:nConditions
        [mC, sC] = rcaProjectmyData(conditionsData(:, c), W_all.W_c{c});
        condition_mu(c, :, :) = mC';
        condition_s(c, :, :) = sC';
        [gfp_condition_mu(c, 1, :), gfp_condition_s(c, 1, :)] = calcGFPData(squeeze(gfpConditionsData(:, c, :))); 
        
    end  
    % actual projected data
    out.eeg = projectedRCTanova;
    % plotting
    out.group_mu = group_mu;
    out.group_s = group_s;
    out.condition_mu = condition_mu;
    out.condition_s = condition_s;
    out.all_mu = all_mu;
    out.all_s = all_s;
    
    out.gfp.group_mu = gfp_group_mu;
    out.gfp.group_s = gfp_group_s;
    out.gfp.condition_mu = gfp_condition_mu;
    out.gfp.condition_s = gfp_condition_s;
    out.gfp.all_mu = gfp_all_mu;
    out.gfp.all_s = gfp_all_s;
end
