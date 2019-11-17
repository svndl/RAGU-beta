function ragu_testPermutationOnStudents
    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    %% load sample structure

    experiment = 'FullField';
    group = 'Students';
    analysisType = 'OZ';
    
    
    %% specify design
    savedAnalysisDir = fullfile(curr_path, 'EEG_DATA', experiment);
    savedAnalysisFile = fullfile(savedAnalysisDir, [group experiment '_' analysisType '.mat']);
    load(savedAnalysisFile, 'projectedData', 'settings');
    
    
    dataTanova = projectedData.eeg;
    
    cnd1 = (projectedData.eeg(:, 1, :, :));
    % replace OFF with ON*1.2
    new_cnd2 = bsxfun(@times, 1.2, cnd1);
%     fakeDataTanova = cat(2, cnd1, new_cnd2);
%     resultTanova = ragu_computeTanova(fakeDataTanova, settings);
%     plotFactor1(resultTanova, settings, projectedData, 0);
    
%     %permute the OFF condition
%     new_cnd2 = cnd1(randperm(size(cnd1, 1)), :, :, :);
%     fakeDataTanova = cat(2, cnd1, new_cnd2);    
%     resultTanova = ragu_computeTanova(fakeDataTanova, settings);
%     plotFactor1(resultTanova, settings, projectedData, 0);

    
        %permute the OFF condition
    new_cnd2_r = new_cnd2(randperm(size(new_cnd2, 1)), :, :, :);
    fakeDataTanova = cat(2, cnd1, new_cnd2_r);    
    resultTanova = ragu_computeTanova(fakeDataTanova, settings);
    plotFactor1(resultTanova, settings, projectedData, 0);