function compareStats
    %% Function compares RAGU RC OZ stats with t-squared stats
    %%
    experiment = 'FullField';
    groups = {'Students'};
    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));   

    savedAnalysisDir = fullfile(curr_path, 'EEG_DATA', experiment);
    savedAnalysisFile = fullfile(savedAnalysisDir, [groups{:} '.mat']);  
    
    %% Load RAGU OZ stats
    load(savedAnalysisFile);
    Tanova_Sensor_stats = resultTanova.PTanova;
    
    oz = 76;
    conditionDiff = squeeze(projectedData.eeg(:, 1, oz, :) - projectedData.eeg(:, 2, oz, :));
    groupDiff = squeeze(projectedData.group_mu(1, :, :) - projectedData.group_mu(2,:, :));
    
    nIters = 5000;
    
    [p_cnd, t_cnd, critt_cnd, alpha_cnd, s] = ttest_permute(conditionDiff', nIters);
    %[p_grp, t_grp, critt_grp, alpha_grp, s] = ttest_permute(groupDiff, nIters);
%       
%     % compare stats:
%     figure(1);
    plot(t_cnd, '--r'); hold on;
%     plot(squeeze(Tanova_Sensor_stats(1, 2, :, 1)), '--r'); hold on;
% 
%     figure(2)
%     plot(t_grp, 'b'); hold on;
%     plot(squeeze(Tanova_Sensor_stats(2, 1, :, 1)), '--b'); hold on;
    
    
    savedAnalysisFile_rc = fullfile(savedAnalysisDir, [groups{:} '_rc.mat']);   
    %% Load RAGU RC stats
    load(savedAnalysisFile_rc);
    Tanova_RC_stats = resultTanova.PTanova;
    rc = 1;
    conditionDiff = squeeze(projectedData.eeg(:, 1, rc, :) - projectedData.eeg(:, 2, rc, :));
    groupDiff = squeeze(projectedData.group_mu(1, rc, :) - projectedData.group_mu(2, rc, :));

    nIters = 5000;
    
    [p_cnd, t_cnd, critt_cnd, alpha_cnd, s] = ttest_permute(conditionDiff', nIters);
    %[p_grp, t_grp, critt_grp, alpha_grp, s] = ttest_permute(groupDiff, nIters);
      
    % compare stats:
    %figure(3);
    plot(t_cnd, '--r'); hold on;
    plot(squeeze(Tanova_Sensor_stats(1, 2, :, 1)), '--r'); hold on;

    figure(2)
    plot(t_grp, 'b'); hold on;
    plot(squeeze(Tanova_Sensor_stats(2, 1, :, 1)), '--b'); hold on;
    
    
end