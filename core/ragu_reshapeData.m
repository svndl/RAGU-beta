function out = ragu_reshapeData(dataStruct)    
    nGroups = size(dataStruct.cnd1, 2);
    nConditions = size(dataStruct.group1, 2);
    
    for g = 1:nGroups
        groupCell = cat(1, dataStruct.rawData(:, dataStruct.(['group' num2str(g)])));
        out.gmeans{g} = groupCell(:);
    end
    for c = 1:nConditions      
         conditionCell = cat(3, dataStruct.rawData(:, dataStruct.(['cnd' num2str(c)])));
         out.cmeans{c} = conditionCell(:);
    end      
    out.means = cellfun(@(x) nanmean(x, 3), dataStruct.rawData, 'uni', false);    
end