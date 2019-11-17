function [es,mmap] = OLESGDC(in, Design, Group, nFlag)
    %nSub = size(in,1);
    Level = unique(Group);
    nLevel = numel(Level);

    Design = normr((Design(:) - mean(Design))');

    LMap = zeros(nLevel, size(in, 3));
    for l = 1:nLevel
        in_s = squeeze(mean(in(Group == Level(l), : , :)));
        LMap(l, :) = Design * in_s;
    end

    if nFlag
        disp('Dissimilarity not inplemented for continuous predictors');
    end

    es = sqrt(LMap.*LMap);
    es = sum(es(:));

    if nargout > 1
        mmap = zeros(size(in));
        for l = 1:nLevel
            idx = find(Group == Level(l));
            dmap(1, :, :) = Design' * squeeze(LMap(l, :));
            mmap(idx, :, :) = repmat(dmap,[numel(idx), 1, 1]);
        end
    end
end