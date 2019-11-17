function [es, mmap] = OLES_mat(in, Design, nFlag)
    [nSubjects, ~, nChannels, nSamples] = size(in);
    Level = unique(Design);
    nLevel = numel(Level);

    LMap = zeros(1, nLevel, nChannels, nSamples);

    for l = 1:nLevel
        in_s = in(:, Design == Level(l), :, :);
        nCObs = size(in_s, 1)*size(in_s, 2);
        maps = reshape(in_s, nCObs, nChannels, nSamples);
        LMap(1, l, :, :) = mean(maps, 1); 
    end

    if nFlag == 1
        LMap2 = NormDimL2(LMap, 3);
        es = squeeze(sum(sqrt(sum(LMap2.*LMap2, 3)), 2));
    else
        es = squeeze(sum(sqrt(sum(LMap.*LMap, 3)), 2));
    end

    if nargout > 1
        mmap = zeros(size(in));
        for l = 1:nLevel
            idx = find(Design == Level(l));
            mmap(:, idx, :, :) = repmat(LMap(1, l, :, :),[nSubjects, numel(idx), 1]);        
        end
    end
end