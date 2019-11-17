function dataOut = ragu_calcData(experiment, groupLabels, analysisType)


    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    if (nargin<3)
        analysisType = 'OZ';
    end
    %% load sample structure
    
    
    %% specify design
    savedAnalysisDir = fullfile(curr_path, 'EEG_DATA', experiment);
    if (~exist(savedAnalysisDir, 'dir'))
        mkdir(savedAnalysisDir);
    end
    ngroups = size(groupLabels, 2);
    avgData = cell(1, ngroups);
    group_rawData = cell(ngroups, 1);
    dataInfo = getExperimentInfo(experiment);
    nCnds = size(dataInfo.conditionLabels, 2);
    subtype = 'axx';
    for ng = 1:ngroups
        dataStruct_curr = ragu_getData(experiment, groupLabels{ng}, 0, subtype);
        nSubjs = size(dataStruct_curr.rawData, 1);
        avgDataG = cellfun(@(x) nanmean(x, 3), dataStruct_curr.rawData, 'uni', false);
        combinedData = cat(3, avgDataG{:});
        nSamples = size(combinedData, 1);
        nChannels = size(combinedData, 2);
        reshapedData = reshape(combinedData, nSamples, nChannels, nSubjs, nCnds);
        avgData{ng}  = permute(reshapedData, [3 4 2 1]);
        group_rawData{ng} = dataStruct_curr.rawData;
    end
    % groups are conditions
    % go from 1 cell of nSubj x nCond x nCh x nSamples to
    % nCond/2 cells of nSubj x 2 x nCh x nSamples
    if (ngroups == 1)
        numSubGroups = numel(dataInfo.subgroupsLabels);
        reshapedCellData =  cell(numSubGroups, 1);
        for sg = 1:numSubGroups
            reshapedCellData{sg} = group_rawData{ng}(:, dataStruct_curr.(['group' num2str(sg)]));
        end
        groupData = conditionsToGroups(avgData, 2);
        if (numel(dataInfo.subgroupsLabels) > 1)
            settings.groupLabels = [dataInfo.subgroupsLabels];
        else
            settings.groupLabels = [groupLabels dataInfo.subgroupsLabels];
        end
        settings.conditionLabels = dataInfo.subcndLabels;
    else
        reshapedCellData = group_rawData;
        groupData = avgData;
        settings.groupLabels = groupLabels;
        settings.conditionLabels = dataInfo.conditionLabels;
    end
    
    sensorData.eegGrouped = groupData';
    sensorData.rawData = reshapedCellData;

    %% update settings
    
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
    
    savedAnalysisFile = fullfile(savedAnalysisDir, [subtype settings.groupLabels{:} '_' subtype '_' analysisType '.mat']);
 
    
    switch analysisType
        case 'OZ'
            weights = ones(128, 128);
            sensorIdx = 0;
        case 'RC'
            rcSettings.groupLabels = settings.groupLabels;
            rcSettings.conditionLabels = settings.conditionLabels;
            rcSettings.path = savedAnalysisDir;     
            weights = ragu_runRC_OZ_DataAnalysis(reshapedCellData, rcSettings);
            sensorIdx = 1;            
    end
  
    projectedData = ragu_projectRawData(sensorData, weights);
    ng = size(groupData, 2);
    nc = size(projectedData.eeg, 2);
    
    %% write average subj data files    
%     strCndLabel = 'C';
%     strSubjLabel = 'SA';
%     for s = 1:size(projectedData.eeg, 1)
%         for c = 1:size(projectedData.eeg, 2)
%             data = squeeze(projectedData.eeg(s, c, :, :))';
%             f = [strSubjLabel num2str(floor(s/10)) num2str(rem(s, 10)) '_' strCndLabel num2str(c) '.asc'];
%             save(fullfile(savedAnalysisDir, f), 'data', '-ascii');            
%         end
%     end
    
    switch analysisType
        case 'OZ'        
            plotData.topoGroupF1 = projectedData.all_mu;
            plotData.topoGroup = projectedData.group_mu;
            plotData.topoF1 = projectedData.condition_mu;
        case 'RC'
            topo_gc_cell = cellfun(@(x) squeeze(x(:, sensorIdx)), weights.A_gc, 'uni', false);
            topo_g_cell = cellfun(@(x) squeeze(x(:, sensorIdx)), weights.A_g, 'uni', false);
            topo_c_cell = cellfun(@(x) squeeze(x(:, sensorIdx)), weights.A_c, 'uni', false);
            
            topo_gc = reshape(cell2mat(topo_gc_cell), [nChannels nc ng]);
            topo_g = reshape(cell2mat(topo_g_cell), [nChannels ng]);
            topo_c = reshape(cell2mat(topo_c_cell), [nChannels nc]);
            
            plotData.topoGroupF1 = repmat(permute(topo_gc, [3 2 1]), [1 1 1 nSamples]);
            plotData.topoGroup = repmat(permute(topo_g, [2 1]), [1 1 nSamples]);
            plotData.topoF1 = repmat(permute(topo_c, [2 1]), [1 1 nSamples]);
    end
           

    f = fieldnames(plotData);
    for i = 1:length(f)
        projectedData.(f{i}) = plotData.(f{i});
    end
    
    dataForTanova = projectedData.eeg;
    reload = 1;
    if (~exist(savedAnalysisFile, 'file') || reload )   
    %% do Tanova and GFP
        disp('Cooking ...');
        tic
        resultTanova = ragu_computeTanova(dataForTanova, settings);
        toc
    
%         settings.DoGFP = 1;
%         resultGFP = ragu_computeTanova(dataForTanova, settings);
%     
%         %% merge results
%         f = fieldnames(resultGFP);
%         for i = 1:length(f)
%             resultTanova.(f{i}) = resultGFP.(f{i});
%         end  
        resultTanova.rsig = ragu_computeSignificance(resultTanova, settings);
        save(savedAnalysisFile, 'resultTanova', 'settings', 'projectedData', '-v7.3');
    else
        load(savedAnalysisFile);
    end
    %close all;
    if (ng > 1 )
        plotGroupF1(resultTanova, settings, projectedData, sensorIdx);
    end
    if (ng*nc > nc)
        plotGroup(resultTanova, settings,  projectedData, sensorIdx);
    end
    plotFactor1(resultTanova, settings, projectedData, sensorIdx);
end