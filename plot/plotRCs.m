function plotRCs(experiment, groupLabel)
    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    savedAnalysisDir = fullfile(curr_path, 'EEG_DATA', experiment);
    dataInfo = getExperimentInfo(experiment);

    if (numel(dataInfo.subgroupsLabels) > 1)
        groupLabels = [dataInfo.subgroupsLabels];
    else
        groupLabels = [groupLabel dataInfo.subgroupsLabels];
    end
    conditionLabels = dataInfo.subcndLabels;
    analysisType = 'RC';
    savedAnalysisFile = fullfile(savedAnalysisDir, [groupLabels{:} '_' analysisType '.mat']);
    load(savedAnalysisFile);
    c1_rc1_rc2 = squeeze(projectedData.condition_mu(1, [1 2], :));
    c2_rc1_rc2 = squeeze(projectedData.condition_mu(2, [1 2], :));
    
    g1_rc1_rc2 = squeeze(projectedData.group_mu(1, [1 2], :));
    g2_rc1_rc2 = squeeze(projectedData.group_mu(2, [1 2], :));
    g3_rc1_rc2 = squeeze(projectedData.group_mu(3, [1 2], :));
    g4_rc1_rc2 = squeeze(projectedData.group_mu(4, [1 2], :));
    g5_rc1_rc2 = squeeze(projectedData.group_mu(5, [1 2], :));
    
    figure;
    plot(c1_rc1_rc2(1, :), c1_rc1_rc2(2, :), 'b'); hold on;
    plot(c2_rc1_rc2(1, :), c2_rc1_rc2(2, :), 'r'); hold on;
    xlabel('RC1'); ylabel('RC2');
    set(gca, 'FontSize', 25);
    
    figure;
    plot(g1_rc1_rc2(1, :), g1_rc1_rc2(2, :), 'b'); hold on;
    plot(g2_rc1_rc2(1, :), g2_rc1_rc2(2, :), 'r'); hold on;
    plot(g3_rc1_rc2(1, :), g3_rc1_rc2(2, :), 'g'); hold on;
    plot(g4_rc1_rc2(1, :), g4_rc1_rc2(2, :), 'y'); hold on;
    plot(g5_rc1_rc2(1, :), g5_rc1_rc2(2, :), 'm'); hold on;
    
    xlabel('RC1 \mu V'); ylabel('RC2 \mu V');
    set(gca, 'FontSize', 25);
    
end
