function dataIdx = ragu_prepForReshape(info)
%% function returns indicies of reshaped by group and condition data
    cndField = 'cnd';
    groupField = 'group';
    nGroups = size(info.subgroupsLabels, 2);
    nConditions = size(info.subcndLabels, 2);
    nTotalCnd = size(info.conditionLabels, 2);
    for nc = 1:nConditions
        cndStr = [cndField num2str(nc)];
        dataIdx.(cndStr) = nc:nConditions:nTotalCnd;        
    end
    for ng = 1:nGroups
        grpStr = [groupField num2str(ng)];
        dataIdx.(grpStr) = (ng - 1)*nConditions + 1:ng*nConditions;        
    end    
end
