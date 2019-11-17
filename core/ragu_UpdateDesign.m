function settings = ragu_UpdateDesign(groupData)
    
    
    nGroups = 1:numel(groupData);
    nConditions = size(groupData{1}, 2);
    nTotalFactors = 2;
    BetweenSubjects = ones(nConditions, nTotalFactors);
    BetweenSubjects(:, 1) = 1:nConditions;
    settings.BetweenSubjects = BetweenSubjects;

    % feature-design ()
    nGroupElems = cell2mat(cellfun(@(x, y)  size(x, 1), groupData, 'uni', false));
    IndFeatureArray = arrayfun(@(x, y) y*ones(x, 1), nGroupElems, nGroups, 'uni', false);
    
    settings.BetweenGroups = cat(1, IndFeatureArray{:});

    settings.DoGroup = numel(nGroups) > 1;
    settings.DoFactor1 = (numel(unique(settings.BetweenSubjects(:, 1))) > 1);
    settings.DoFactor2 = (numel(unique(settings.BetweenSubjects(:, 2))) > 1);
    
    settings.nIterations = 5000;
    
    [NewDesign, iDesign, ~] = ragu_UpdateWithinDesign(settings.BetweenSubjects');
    
    settings.NewDesign = NewDesign';
    settings.iDesign = iDesign;
    
    if (settings.DoFactor1 && settings.DoFactor2)
        if abs(corrcoef(settings.NewDesign(:, 1), settings.NewDesign(:, 2))) > 0.01
            error('Design not orthogonal');
        end
    end
end