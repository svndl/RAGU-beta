function [es, mmap] = OLESC(in, Design, nFlag)

    in_s = squeeze(mean(in, 1));
    Design = normr((Design(:) - mean(Design))');

    LMap(1,:,:) = Design * in_s;
    if nFlag
        disp('Dissimilarity not inplemented for continuous predictors');
    end

    es = sqrt(sum(LMap.*LMap, 3));

    mmap = repmat(LMap,[size(in, 1) size(in, 2) 1]);
end