function dataOut = ragu_calcDataonRC(experiment, groupLabels)

    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    %% load sample structure
    
    
    %% specify design
    savedAnalysisDir = fullfile(curr_path, 'EEG_DATA', experiment);
    if (~exist(savedAnalysisDir, 'dir'))
        mkdir(savedAnalysisDir);
    end
    ngroups = size(groupLabels, 2);
    avgData = cell(ngroups, 1);
    group_rawData = cell(ngroups, 1);
    dataInfo = getExperimentInfo(experiment);
    nCnds = size(dataInfo.conditionLabels, 2);
    
    for ng = 1:ngroups
        dataStruct = ragu_getData(experiment, groupLabels{ng}, 1);
        nSubjs = size(dataStruct.rawData, 1);
        avgData_group = cellfun(@(x) nanmean(x, 3), dataStruct.rawData, 'uni', false);
        combinedData = cat(3, avgData_group{:});
        nSamples = size(combinedData, 1);
        nChannels = size(combinedData, 2);   
        reshapedData = reshape(combinedData, nSamples, nChannels, nSubjs, nCnds);
        avgData{ng}  = permute(reshapedData, [3 4 2 1]);
        group_rawData{ng} = dataStruct.rawData;
    end
    % groups are conditions
    % go from 1 cell of nSubj x nCond x nCh x nSamples to
    % nCond/2 cells of nSubj x 2 x nCh x nSamples
    if (ngroups == 1)
        group_data = conditionsToGroups(avgData, 2);
        settings.groupLabels = dataInfo.subgroupsLabels;
        settings.conditionLabels = dataInfo.subcndLabels;
        % reshape group_rawData
    else
        group_data = cat(2, avgData(:));
        settings.groupLabels = groupLabels;
        settings.conditionLabels = dataInfo.conditionLabels;
    end
    groupData = group_data;
    settings.groupLabels = settings.groupLabels;
    settings_design = ragu_UpdateDesign(groupData);
    f = fieldnames(settings_design);
    for i = 1:length(f)
        settings.(f{i}) = settings_design.(f{i});
    end
    %% create data for RAGU to double-checks
    for sg = 1:size(groupData, 2)
        strSubjLabel = ['S', num2str(sg)];
        writeRAGUFiles(groupData{sg}, strSubjLabel, savedAnalysisDir);
    end
    % TANOVA settings
    settings.MeanInterval = 0;    
    settings.ContGroup = 0;
    settings.ContF1 = 0;
    settings.NoXing = 0;
    settings.DoGFP = 0;
    settings.Threshold = 0.05;
    settings.PreNormalize = 0;
    settings.Normalize = 0;    

    dataTanova.eeg = cat(1, groupData{:});
    f = fieldnames(dataStruct);
    for i = 1:length(f)
        dataTanova.(f{i}) = dataStruct.(f{i});
    end
    
    savedAnalysisFile = fullfile(savedAnalysisDir, [settings.groupLabels{:} '_rc.mat']);  
    
    %% RC settings
    rcSettings.groupLabels = settings.groupLabels;
    rcSettings.conditionLabels = settings.conditionLabels;
    rcSettings.path = savedAnalysisDir;
    
    rcWeights = ragu_runRC_OZ_DataAnalysis(dataStruct, rcSettings);
    projectedData = ragu_projectRawData(dataTanova, rcWeights);
    % save RC files
    strSubjLabel = ['S', num2str('1')];
    rcDataDir = fullfile(savedAnalysisDir, 'RC');
    writeRAGUFiles(projectedData.eeg, strSubjLabel, rcDataDir);
    
    ragu_DisplayOutliers(dataTanova.eeg, settings);
    
    dataMeans = ragu_computeMeans(dataTanova, settings);
    
    %%
    f = fieldnames(dataMeans);
    for i = 1:length(f)
        dataTanova.(f{i}) = dataMeans.(f{i});
        projectedData.(f{i}) = dataMeans.(f{i});
    end
    
    if (~exist(savedAnalysisFile, 'file') )   
    %% do Tanova and GFP
        tic
        resultTanova = ragu_computeTanova(projectedData.eeg, settings);
        toc
    
        settings.DoGFP = 1;
        resultGFP = ragu_computeTanova(projectedData.eeg, settings);
    
        %% merge results
        f = fieldnames(resultGFP);
        for i = 1:length(f)
            resultTanova.(f{i}) = resultGFP.(f{i});
        end  
        resultTanova.rsig = ragu_computeSignificance(resultTanova, settings);
        save(savedAnalysisFile, 'resultTanova', 'settings', 'projectedData');
    else
        load(savedAnalysisFile);
    end
    %close all;
    rc = 1;
    plotGroupF1(resultTanova, settings, projectedData, rc);              
    plotGroup(resultTanova, settings,  projectedData, rc);
    plotFactor1(resultTanova, settings, projectedData, rc);
end