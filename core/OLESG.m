function [es, mmap] = OLESG(in, Design, Group, nFlag)

    %nSub = size(in,1);
    Level = unique(Group);
    nLevel = numel(Level);
    dLevel = unique(Design);
    ndLevel = numel(dLevel);

    LMap = zeros(nLevel, ndLevel, size(in, 3));
    for l = 1:nLevel
        for  l2 = 1:ndLevel
            in_s = in(Group == Level(l), Design == dLevel(l2), :);
            nCObs = size(in_s,1) * size(in_s,2);
            maps = reshape(in_s,nCObs,size(in_s,3));
            LMap(l,l2,:) = mean(maps); 
        end
    end

    if nFlag == 1
        LMap2 = NormDimL2(LMap, 3);
        es = sqrt(sum(LMap2.*LMap2, 3));
        es = sum(es(:));
    else
        es = sqrt(sum(LMap.*LMap, 3));
        es = sum(es(:));
    end

    if nargout > 1
        mmap = zeros(size(in));
        for l = 1:nLevel
            idx = find(Group == Level(l));
            for l2 = 1:ndLevel
                idx2 = find(Design == dLevel(l2));
                mmap(idx,idx2,:) = repmat(LMap(l, l2, :),[numel(idx), numel(idx2), 1]);
            end
        end
    end
end