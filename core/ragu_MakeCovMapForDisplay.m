function [cm, gfp] = ragu_MakeCovMapForDisplay(data, WithinPred, BetweenPred)

    gfp = sqrt(mean(data.^2, 3));
    % We center across the conditions and within group
    data = data - repmat(mean(mean(data, 2), 1),[size(data, 1) size(data, 2) 1 1]); 
    
    DubWithin = false;
    if ~isempty(WithinPred)
        DubWithin = true;
        WithinPred = WithinPred - mean(WithinPred);
        WithinPred = repmat(WithinPred', [size(data, 1), 1, 1, size(data, 4)]);
    
    else
        WithinPred = ones(size(gfp));
    end
    
    DubBetween = false;
    if ~isempty(BetweenPred)
        DubBetween = true;
        BetweenPred = BetweenPred - mean(BetweenPred);
        BetweenPred = repmat(BetweenPred, [1, size(data, 2), 1, size(data, 4)]);
    else
        BetweenPred = ones(size(gfp));
    end
    gfp = mean(mean(gfp.*WithinPred.*BetweenPred, 2), 1);
    
    WithinPred  = repmat(WithinPred , [1, 1, size(data, 3), 1]);
    BetweenPred = repmat(BetweenPred, [1, 1, size(data, 3), 1]);
    cm = mean(mean(data.*WithinPred.*BetweenPred, 2), 1);
    
    if DubBetween == true
        cm(2, :, :, :) = -cm(1, :, :, :);
        gfp(2, :, :, :) = - gfp(1, :, :, :);
    end
    
    if DubWithin == true
        cm(:, 2, :, :) = -cm(:, 1, :, :);
        gfp(:, 2, :, :) = -gfp(:, 1, :, :);
    end
end