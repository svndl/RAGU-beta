function compare_TANOVA(experiment, groupLabels)

    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    %% load sample structure
    
    
    %% specify design
    savedAnalysisDir = fullfile(curr_path, 'EEG_DATA', experiment);
    %savedAnalysisFile_rc = fullfile(savedAnalysisDir, [experiment '_RC.mat']);
    
    savedAnalysisFile_oz = fullfile(savedAnalysisDir, [groupLabels '_OZ.mat']);
    [file, path] = uigetfile(savedAnalysisDir);
    savedAnalysisFile_oz = fullfile(path, file);
    load(savedAnalysisFile_oz, 'settings', 'projectedData');
        
    oz = 76;
    
    %% ttest on GFP!
    cnd1 = squeeze(projectedData.eeg(:, 1, :, :));
    cnd2 = squeeze(projectedData.eeg(:, 2, :, :));
    
    
    % ragu way of computing GFP
    ragu_C1 = squeeze(mean(cnd1))';
    ragu_C2 = squeeze(mean(cnd2))';
    
    ragu_C1_gfp = gfpData(ragu_C1);
    ragu_C2_gfp = gfpData(ragu_C2);
    
    
    GFP_cnd1 = gfpData_mat(cnd1);
    GFP_cnd2 = gfpData_mat(cnd2);
    
    c1_gfp_mean = mean(GFP_cnd1);
    c2_gfp_mean = mean(GFP_cnd2);
    
    c1_gfp_sem =  std(GFP_cnd1, 0, 1)/(sqrt(size(GFP_cnd1, 1)));
    c2_gfp_sem =  std(GFP_cnd2, 0, 1)/(sqrt(size(GFP_cnd2, 1)));

%     c1_gfp_mean = squeeze(projectedData.gfp.condition_mu(1, :, :));
%     c2_gfp_mean = squeeze(projectedData.gfp.condition_mu(2, :, :));
%     c1_gfp_sem = squeeze(projectedData.gfp.condition_s(1, :, :));
%     c2_gfp_sem = squeeze(projectedData.gfp.condition_s(2, :, :));
    
    conditionDiff = squeeze(GFP_cnd1 - GFP_cnd2);    
    nIters = 5000;
    
    [sig_tt, p_tt, critt_cnd, alpha_cnd, s] = ttest_permute(conditionDiff', nIters);
    
%     settings.DoGFP = 0;
%     settings.DoGroup = 1;
    dataForTanova_oz = projectedData.eeg;
%     resultTanova_res = ragu_computeTanova(dataForTanova_oz, settings);
    
    %p_efs_oz_res = resultTanova_res.PTanova;
    
    
    NewDesign = settings.NewDesign';
    SelIndFeature = settings.BetweenGroups;
 
    [p_efs_oz, pTan] = quickRAGU(dataForTanova_oz, NewDesign, SelIndFeature);
    
    bcol_gfp = [255, 116, 0]/255;   
    bcol_oz = [118 226 94]/255;   

    tc = size(pTan, 3)*(1000/420)*(linspace(0, 1, size(pTan, 3)))';
    p_cnd_Tanova = squeeze(pTan(1, 2, :, 1));
   
    figure;
    subplot(3, 1, 1);
    title('p-Value')

    plot(tc, p_cnd_Tanova, '*k', 'LineWidth', 5); 
    plot(tc, p_tt, 'color', [0.5 0.5 0.5], 'LineWidth', 5);
    
    h1 = bar(tc , double(p_cnd_Tanova < 0.05),'LineStyle', 'none', 'ShowBaseLine', 'off');
    set(h1, 'BarWidth', 1, 'EdgeColor',bcol_gfp, 'FaceColor', bcol_gfp, 'FaceAlpha', 0.3); hold on;
    h2 = bar(tc , double(p_tt < 0.05), 'LineStyle', 'none', 'ShowBaseLine', 'off');
    set(h2, 'BarWidth', 1, 'EdgeColor',bcol_oz,'FaceColor', bcol_oz, 'FaceAlpha', 0.3);hold on;
    
    p1 = plot(tc, p_cnd_Tanova, '*k', 'LineWidth', 5); 
    p2 = plot(tc, p_tt, 'color', [0.5 0.5 0.5], 'LineWidth', 5);
    
    set(gca,'FontSize',25)
    legend([p1, p2], {'Ragu', 't-Test'});
    
    %%
    subplot(3, 1, 2);
    
    sem_ragu = 0.001*ones(size(squeeze(projectedData.gfp.condition_s(1, :, :))));
    
    on_gfp = customErrPlot(gca, tc, ragu_C1_gfp - ragu_C1_gfp(1, :), sem_ragu,...
        'b', 25, 'GFP', '-');
    off_gfp = customErrPlot(gca, tc, ragu_C2_gfp - ragu_C2_gfp(1, :), sem_ragu,...
        'r', 25, 'GFP', '-');

    limits_oz = ylim(gca);

    h1 = bar(tc , limits_oz(1)*double(p_cnd_Tanova < 0.05), 'LineStyle', 'none', 'ShowBaseLine', 'off');
    set(h1, 'BarWidth', 1, 'EdgeColor',bcol_gfp, 'FaceColor', bcol_gfp, 'FaceAlpha', 0.3);
    h2 = bar(tc , limits_oz(2)*double(p_cnd_Tanova < 0.05), 'LineStyle', 'none', 'ShowBaseLine', 'off');
    set(h2, 'BarWidth', 1, 'EdgeColor',bcol_gfp, 'FaceColor', bcol_gfp, 'FaceAlpha', 0.3);
    
    legend([on_gfp, off_gfp], {'ON', 'OFF'});

    %% 
    subplot(3, 1, 3);
    
    on_oz = customErrPlot(gca, tc, c1_gfp_mean - c1_gfp_mean(:, 1), c1_gfp_sem,...
        'b', 25, 'OZ', '-');
    off_oz = customErrPlot(gca, tc, c2_gfp_mean - c2_gfp_mean(:, 1), c2_gfp_sem,...
        'r', 25, 'OZ', '-');
    
    limits_oz = ylim(gca);
    h1 = bar(tc , limits_oz(1)*double(p_tt < 0.05), 'LineStyle', 'none');
    set(h1, 'BarWidth', 1, 'EdgeColor',bcol_oz,'FaceColor', bcol_oz, 'FaceAlpha', 0.3, 'ShowBaseLine', 'off');
    h2 = bar(tc , limits_oz(2)*double(p_tt < 0.05), 'LineStyle', 'none');
    set(h2, 'BarWidth', 1, 'EdgeColor',bcol_oz,'FaceColor', bcol_oz, 'FaceAlpha', 0.3, 'ShowBaseLine', 'off');
    legend([on_oz, off_oz], {'ON', 'OFF'});
    
    
    
%     plot(tc, squeeze(p_efs_oz_res(2, 2, :, 1)), '-g', 'LineWidth', 3); hold on;
%     plot(tc, squeeze(p_efs_oz(2, 2, :, 1)), '--g', 'LineWidth', 3); hold on;
%     plot(tc, squeeze(pTan(2, 2, :, 1)), '--g', 'LineWidth', 3); hold on;
   
    
end

function [p_efs, PTanova] = quickRAGU(InData, NewDesign, SelIndFeature)

    Iterations = 5000;
    t2 = size(InData, 4);
    TanovaEffectSize = nan*ones(2, 4, t2, Iterations);
    efs = TanovaEffectSize;
    Design = NewDesign';
    DoFactor1 = 1;
    DoFactor2 = 0;
    DoGroup = 0;
    Normalize = 0;
    [callback_fcn, argsIdx] = ragu_GetCallbackMatrix(DoFactor1, DoFactor2, DoGroup);
    args = [{Design}, {[1 2]}, {SelIndFeature}, {0}, {0}];
    
    efs(:, :, :, 1) = callback_fcn(InData, Normalize, args{argsIdx});
    TanovaEffectSize(:, :, :, 1) = DoAllEffectSizes(InData, Design, SelIndFeature, DoGroup, 1, Normalize);
    
    for iter = 2:Iterations
        % shuffle conditions for each subject
        shuffled_cnd = zeros(size(InData)); 
        for j = 1:size(InData, 1)
            shuffled_cnd(j, :, :, :) = InData(j, PermDesign(Design, 0), :, :);
        end
        %newDesignIdx = PermDesign(settings.NewDesign, settings.NoXing);
        % update args
        args{3} = SelIndFeature(randperm(numel(SelIndFeature)));
        efs(:, :, :, iter) = callback_fcn(shuffled_cnd, Normalize, args{argsIdx});
        TanovaEffectSize(:, :, :, iter) = DoAllEffectSizes(shuffled_cnd, Design, args{3}, DoGroup, DoFactor1, Normalize);        
    end
    
    
    Rank = (1:Iterations)/Iterations;
    PTanova = ones(size(TanovaEffectSize, 1), 2, t2, 5000);
    p_efs = ones(size(TanovaEffectSize, 1), 2, t2, 5000);
    
    for i = 1:2
        for j = 1:2
            for t = 1:t2
                efs_sq = squeeze(efs(i, j, t, :));
                tes_sq = squeeze(TanovaEffectSize(i, j, t, :));
                if ~isnan(max(tes_sq))
                    [~, order1] = sort(tes_sq, 'descend');
                    PTanova(i, j, t, order1) = Rank;
                end
                if ~isnan(max(efs_sq))
                    [~, order2] = sort(efs_sq, 'descend');
                    p_efs(i, j, t, order2) = Rank;
                end
            end
        end
    end

end
function efs = DoAllEffectSizes(data, Design, Group, DoGroup, DoF1, Normalize)

    if Normalize
        data = NormDimL2(data,3);
    end

    if (numel(size(data)) == 3)
        DoAverage = true;
    else
        DoAverage = false;
    end

    if DoAverage
        t2 = 1;
        efs = nan(2,4);
    else
        t2 = size(data,4);
        efs = nan(2,4,size(data,4));
    end
    %% debug
    mmBL_t = zeros(size(data));
    mmBLG_t = zeros(size(data));
    mmBLF1_t = zeros(size(data));
    mmBLGF1_t = zeros(size(data));
    
    %% timesamples
    for t = 1:t2
        if DoAverage
            in = data;
        else
            in = data(:,:,:,t);
        end
    
    %    'Take out the mean'
        [es,mmBL] = OLES(in,ones(1,size(data,2)),0);
        noBL_M = in - mmBL;
        efs(1,1,t) = es;
    
%    'Main group effect'
        if DoGroup
            [es, mmBLG] = OLESG(noBL_M,ones(1,size(data,2)),Group,Normalize);
            noBL_MG = noBL_M - mmBLG;
            efs(2,1,t) = es;
        end
%    'Factor 1'
        if DoF1
            [es,mmBLF1] = OLES(noBL_M,Design(:,1),Normalize);
            efs(1,2, t) = es;
        end
%    'Factor 1 and Group'
        if (DoF1 && DoGroup)
            [es,mmBLGF1] =  OLESG(noBL_MG-mmBLF1,Design(:,1),Group,Normalize);
            efs(2,2,t) = es;
        end
%         mmBL_t(:, :, :, t) = mmBL;
%         mmBLG_t(:, :, :, t) = mmBLG;
%         mmBLF1_t(:, :, :, t) = mmBLF1;
%         mmBLGF1_t(:, :, :, t) = mmBLGF1;
    end
%     disp('Saving vars... \n');
%     save('oldRAGU_iter1.mat', 'mmBL_t', 'mmBLG_t', 'mmBLF1_t', 'mmBLGF1_t');    
end
function [es,mmap] = OLESG(in,Design,Group,nFlag)

    %nSub = size(in,1);
    Level = unique(Group);
    nLevel = numel(Level);
    dLevel = unique(Design);
    ndLevel = numel(dLevel);

    LMap = zeros(nLevel,ndLevel,size(in,3));
    for l = 1:nLevel
        for  l2 = 1:ndLevel
            in_s = in(Group == Level(l),Design == dLevel(l2),:);
            nCObs = size(in_s,1) * size(in_s,2);
            maps = reshape(in_s,nCObs,size(in_s,3));
            LMap(l,l2,:) = mean(maps); 
        end
    end

    if nFlag == 1
        LMap2 = NormDimL2(LMap,3);
        es = sqrt(sum(LMap2.*LMap2,3));
        es = sum(es(:));
    else
        es = sqrt(sum(LMap.*LMap,3));
        es = sum(es(:));
    end

    if nargout > 1
        mmap = zeros(size(in));
        for l = 1:nLevel
            idx = find(Group == Level(l));
            for l2 = 1:ndLevel
                idx2 = find(Design == dLevel(l2));
                mmap(idx,idx2,:) = repmat(LMap(l,l2,:),[numel(idx),numel(idx2),1]);
            end
        end
    end
end


function [es,mmap] = OLES(in,Design,nFlag)
    nSub = size(in,1);
    Level = unique(Design);
    nLevel = numel(Level);

    LMap = zeros(1,nLevel,size(in,3));

    for l = 1:nLevel
        in_s = in(:,Design == Level(l),:);
        nCObs = size(in_s,1) * size(in_s,2);
        maps = reshape(in_s,nCObs,size(in_s,3));
        LMap(1,l,:) = mean(maps); 
    end

    if nFlag == 1
        LMap2 = NormDimL2(LMap,3);
        es = sum((sqrt(sum(LMap2.*LMap2,3))));
    else
        es = sum((sqrt(sum(LMap.*LMap,3))));
    end

    if nargout > 1
        mmap = zeros(size(in));
        for l = 1:nLevel
            idx = find(Design == Level(l));
            mmap(:,idx,:) = repmat(LMap(1,l,:),[nSub,numel(idx),1]);        
        end
    end
end
