function res = ragu_CalcCallbackRandomized(data, Normalize, Design, Group, NoXing, callbackFcn, args)

    % shuffle data
    r_in = zeros(size(data)); 
    for subj = 1:size(data, 1)
        r_in(subj, : , : , :) = data(subj, PermDesign(Design, NoXing), : , :);
    end
    % nw independent feature
    rIndFeat = Group(randperm(numel(Group)));
    res = callbackFcn(r_in, Normalize, args{:});
end