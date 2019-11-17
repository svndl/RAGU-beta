function dataOut = conditionsToGroups(dataIn, nNewConditions)

    nNewGroups = size(dataIn{1}, 2)/nNewConditions;
    dataOut = cell(1, nNewGroups);
    
    for g = 1:nNewGroups
        dataOut{g} = dataIn{1}(:, nNewConditions*(g - 1) + 1:nNewConditions*g, :, :);       
    end
end