function writeRAGUFiles(avgSubjData, strSubjLabel, srcEEGDir)
    strCndLabel = 'C';
    for s = 1:size(avgSubjData, 1)
        for c = 1:size(avgSubjData, 2)
            data = squeeze(avgSubjData(s, c, :, :))';
            f = [strSubjLabel num2str(floor(s/10)) num2str(rem(s, 10)) '_' strCndLabel num2str(c) '.asc'];
            save(fullfile(srcEEGDir, f), 'data', '-ascii');            
        end
    end
end