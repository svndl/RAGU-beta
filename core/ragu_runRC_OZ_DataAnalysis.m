function out = ragu_runRC_OZ_DataAnalysis(rawData, info)
    % dataStruct -- raw data (nSubj x NConditions), split indicies 
    % settings -- RC settings: path to load/store results, 
    % channel # for waveform, labels for groups/conditions 

    % for three possible data combinations (Conditions, Groups, CndsxGroups)
    % run RC analysis to obtain 1) RC weights and 2)Average OZ (other
    % channel) data
    % return weights for each cathegory (rc_group, rc_condition, rc_group_cnd)
    % return average waveforms for each dta combination
    
    % run by means
    nGroups = size(rawData, 1);
    nConditions = size(rawData{1}, 2);
    
    %% info.path
    %% info.label
    %% info.ch
    out.W_g = cell(nGroups, 1);
    out.A_g = cell(nGroups, 1);
    
    out.W_c = cell(nConditions, 1);
    out.A_c = cell(nConditions, 1);

    out.W_gc = cell(nGroups, nConditions);
    out.A_gc = cell(nGroups, nConditions);
    
    for g = 1:nGroups
        groupCell = cat(1, rawData{g});
        
        % run RC on group data
        rc_group = ragu_runRCA(cat(1, groupCell(:)), info.path, info.groupLabels{g});
        out.W_g{g} = rc_group.W;
        out.A_g{g} = rc_group.A;    
        for c = 1:nConditions
            gcData = rawData{g}(:, c);
            groupCND_label = strcat(info.groupLabels{g}, info.conditionLabels{c});
            rc_CND = ragu_runRCA(gcData, info.path, groupCND_label);
            out.W_gc{g, c} = rc_CND.W;
            out.A_gc{g, c} = rc_CND.A;
        end      
    end
    conditionsData = cat(1, rawData{:});
    for c = 1:nConditions
        rc_CG = ragu_runRCA(conditionsData(:, c), info.path, info.conditionLabels{c});
        out.W_c{c} = rc_CG.W;
        out.A_c{c} = rc_CG.A;
    end
end