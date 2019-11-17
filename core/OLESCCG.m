function [es, mmap] = OLESCCG(in, Design, Group, nFlag)

    Group = normr((Group(:) - mean(Group)));
    Design = normr((Design(:) - mean(Design))');

    GroupR  = repmat(Group, [1 size(in, 2) size(in, 3)]);
    DesignR = repmat(Design, [size(in, 1), 1, size(in, 3)]); 

    TotDesignR = DesignR .* GroupR;

    LMap = mean(mean(in.*TotDesignR, 1), 2);

    if nFlag
        disp('Dissimilarity not inplemented for continuous predictors');
    end

% Normalization not implemented

    es = sqrt(LMap.*LMap);
    es = sum(es(:));

    if nargout > 1
        LMapR = repmat(LMap, [size(in, 1) size(in, 2) 1]);
        mmap = LMapR .*TotDesignR;
    end

end