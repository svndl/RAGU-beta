function [es,mmap] = OLESCG(in, Design, Group, nFlag)

    Group = normr((Group(:) - mean(Group))');

    dLevel = unique(Design);
    ndLevel = numel(dLevel);

    cm = zeros(ndLevel,size(in,3));

    for l = 1:ndLevel
        in_s = in(:, Design == dLevel(l),:);
        m = squeeze(mean(in_s,2));
        cm(l,:) = Group *m;
    end

    if nFlag
        disp('Dissimilarity not inplemented for continuous predictors');
    end

    % Normalization not implemented

    es = sqrt(cm.*cm);
    es = sum(es(:));

    cmp = zeros(size(in, 1), ndLevel, size(in, 3));
    for s = 1:size(in, 1)
        cmp(s, :, :) = cm * Group(s);
    end

    if nargout > 1
        mmap = zeros(size(in));
        for l = 1:ndLevel
            idx = find(Design == dLevel(l));
            mmap(:,idx,:) = repmat(cmp(:, l, :), [1 numel(idx), 1]);
        end
    end
end