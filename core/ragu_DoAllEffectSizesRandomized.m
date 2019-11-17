function res = ragu_DoAllEffectSizesRandomized(data, Design, iDesign, Group, DoGroup, DoF1, DoF2, Normalize, ContGroup, ContF1, NoXing)

    % shuffle data
    r_in = zeros(size(data)); 
    for subj = 1:size(data, 1)
        r_in(subj, : , : , :) = data(subj, PermDesign(Design, NoXing), : , :);
    end
    rIndFeat = Group(randperm(numel(Group)));
    res = ragu_DoAllEffectSizes(r_in, Design, iDesign, rIndFeat, DoGroup, DoF1, DoF2, Normalize, ContGroup, ContF1);
end