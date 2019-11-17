function result = ragu_computeTanova(dataEEG, settings)

    [~, ~, ~, nSamples] = size(dataEEG);
    InData = dataEEG;
    
    if isfield(settings, 'DoGFP')
        if (settings.DoGFP)
            InData = sqrt(mean(InData.^2, 3));
        end
    end
    
    if isfield(settings, 'MeanInterval')
        if (settings.MeanInterval)
            InData = mean(InData, 4);
            nSamples = 1;
        end
    end

    if ~settings.DoGFP && settings.PreNormalize
        InData = NormDimL2(InData, 3);
    end

    TanovaEffectSize = nan*ones(2, 4, nSamples, settings.nIterations);
        
    [callback_fcn, argsIdx] = ragu_GetCallbackMatrix(settings.DoFactor1, settings.DoFactor2, settings.DoGroup);
    result.callbackFcn = callback_fcn;
    args = [{settings.NewDesign}, {settings.iDesign}, {settings.BetweenGroups}, {settings.ContGroup}, {settings.ContF1}];
    
    TanovaEffectSize(:, :, :, 1) = callback_fcn(InData, settings.Normalize, args{argsIdx});
    
    for iter = 2:settings.nIterations
        % shuffle conditions for each subject
        shuffled_cnd = zeros(size(InData)); 
        for j = 1:size(InData, 1)
            shuffled_cnd(j, :, :, :) = InData(j, PermDesign(settings.NewDesign, 0), :, :);
        end
        %newDesignIdx = PermDesign(settings.NewDesign, settings.NoXing);
        % update args
        args{3} = settings.BetweenGroups(randperm(numel(settings.BetweenGroups)));
        TanovaEffectSize(:, :, :, iter) = callback_fcn(shuffled_cnd, settings.Normalize, args{argsIdx});
    end
    
    Rank = (1:settings.nIterations)/settings.nIterations;
    PTanova = ones(size(TanovaEffectSize));
    
    t1 = 1;
    t2 = nSamples;

    if settings.MeanInterval
        t2 = 1;
    end

    for i = 1:2
        for j = 1:4
            for t = t1:t2
                tes_sq = squeeze(TanovaEffectSize(i, j, t, :));
                try
                    if ~isnan(max(tes_sq))
                        [~, order1] = sort(tes_sq, 'descend');
                        PTanova(i, j, t, order1) = Rank;
                    end
                catch
                    fprintf('NaNs at idx %d %d %d \n', i, j, t);
                end
            end
        end
    end

    result.PTanova = PTanova;
    result.TanovaEffectSize = TanovaEffectSize;
    result.Threshold = settings.Threshold;
    
    [result.stt, result.p] = RaguSingleThresholdTest(result);
    result.CritDuration = ones(2,4) * 100000000000000;
    result.TanovaHits = [];
    result.PHitCount = [];
    
    
    if settings.DoGFP
        result.GFPTanovaEffectSize = TanovaEffectSize;
        result.GFPTanova          = PTanova;
        result.CritDurationGFP = ones(2,4) * 1000000000000000;
        result.GFPHits = [];
        result.PHitCountGFP = [];
    end
end
