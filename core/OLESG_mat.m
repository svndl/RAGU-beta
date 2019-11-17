function [es, mmap] = OLESG_mat(in, Design, Group, nFlag)

    [~, ~, nChannels, nSamples] = size(in);
    Level = unique(Group);
    nLevel = numel(Level);
    dLevel = unique(Design);
    ndLevel = numel(dLevel);

    LMap = zeros(nLevel, ndLevel, nChannels, nSamples);
    for l = 1:nLevel
        for  l2 = 1:ndLevel
            in_s = in(Group == Level(l), Design == dLevel(l2), :, :);
            nCObs = size(in_s,1) * size(in_s,2);
            maps = reshape(in_s, nCObs, nChannels, nSamples);
            LMap(l, l2, :, :) = mean(maps); 
        end
    end

    if nFlag == 1
        LMap2 = NormDimL2(LMap, 3);
        es = sqrt(sum(LMap2.*LMap2, 3));
        es = sum(es(:));
    else
        es = sqrt(sum(LMap.*LMap, 3));
        es = squeeze(sum(reshape(es, size(es, 1)*size(es, 2), 1,  nSamples)));
    end

    if nargout > 1
        mmap = zeros(size(in));
        for l = 1:nLevel
            idx = find(Group == Level(l));
            for l2 = 1:ndLevel
                idx2 = find(Design == dLevel(l2));
                mmap(idx, idx2, :, :) = repmat(LMap(l, l2, :, :),[numel(idx), numel(idx2), 1, 1]);
            end
        end
    end
end