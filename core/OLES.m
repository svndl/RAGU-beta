function [es, mmap] = OLES(in, Design, nFlag)
    nSub = size(in, 1);
    Level = unique(Design);
    nLevel = numel(Level);

    LMap = zeros(1, nLevel, size(in, 3));

    for l = 1:nLevel
        in_s = in(:, Design == Level(l),:);
        nCObs = size(in_s, 1) * size(in_s, 2);
        maps = reshape(in_s, nCObs, size(in_s, 3));
        LMap(1, l, :) = mean(maps); 
    end

    if nFlag == 1
        LMap2 = NormDimL2(LMap, 3);
        es = sum((sqrt(sum(LMap2.*LMap2, 3))));
    else
        es = sum((sqrt(sum(LMap.*LMap, 3))));
    end

    if nargout > 1
        mmap = zeros(size(in));
        for l = 1:nLevel
            idx = find(Design == Level(l));
            mmap(:, idx, :) = repmat(LMap(1, l, :),[nSub, numel(idx), 1]);        
        end
    end
end