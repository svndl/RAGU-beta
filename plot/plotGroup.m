function plotGroup(results, settings, dataIn, ch, varargin)

    %% plots factor 1
    % left top panel p-value
    % left bottom panel mean conditions at channel xx?
    % right panel(s) A topo condition A, B    
    figure;

    idx1 = 2;
    idx2 = 1;
    groupMeans = dataIn.group_mu;
    nGroups = size(groupMeans, 1);

    % add extra single dim to handle topoplot
    if (nGroups == 1)
        groupMeans = reshape(groupMeans, [1 size(groupMeans, 1) size(groupMeans, 2)]);
    end
    nPlotRows = 3;
    nPlots = nPlotRows*nGroups;
    %egih = cell(nGroups, 1);
    
    if nargin < 5
        idx_0 = 0.5*size(groupMeans, 3);
    else
        idx_0 = varargin{5};
    end
    %% default template for plotting
    data.dataXY = dataIn.topoGroup;
    data.titles = settings.groupLabels;
    plotTopoGroup(data, idx_0);

    data.callback = @plotTopoGroup;
    set(gcf, 'UserData', data);    
    endFrame = size(results.PTanova, 3);
    freq = 1000/420;
        
    time = linspace(0, endFrame*freq, endFrame);
    bcol = [0.7 0.7 0.7];
    axismin = time(1);
    axismax = time(end);
    
    data_pVal = squeeze(results.PTanova(idx1, idx2, :, 1));
    %data_GFP = squeeze(mean(results.meansGFP, 2));    
    %data_GFP = data_GFP - repmat(data_GFP(:,1), [1 endFrame]);
    
    % GFP plot
    group_gfp_start = nGroups + 1;
    group_gfp_end = group_gfp_start + nGroups - 1;
    
    plot_g_GFP = subplot(nPlotRows, nGroups, group_gfp_start:group_gfp_end);   
    raguPlotRCWaveforms(plot_g_GFP, dataIn, time, settings.groupLabels, 'g', ch);   
    set(gca,'FontSize',25);
    
    % Signifiance shading
    group_p_start = group_gfp_end + 1;
    group_p_end = nPlots;
    plot_g_pval = subplot(nPlotRows, nGroups, group_p_start:group_p_end);
    
    % p-Value plot
    zscore = @(p) -sqrt(2) * erfcinv(p*2);
    hold on
    
    plot(plot_g_pval, [time(1) time(end)], norminv([0.05 0.05]), '-k', 'LineWidth', 4); hold on;  
    tanh = plot(plot_g_pval, time, zscore(data_pVal), 'Color', bcol, 'LineWidth', 6); hold on;
    title('Groups p-value', 'Interpreter', 'none', 'FontSize', 28);
    set(tanh, 'Tag', 'TanovaP');    
    p_label = [0.0001 0.001 0.01 0.05 0.1 0.25 0.5 0.75 0.9 0.95 0.99 0.999 0.9999 0.99999];
    set(gca,'YTick',norminv(p_label))
    set(gca,'YTickLabel',p_label)    
    
    set(plot_g_pval,'ButtonDownFcn', {@RefreshTanovaCallback, 1});        
    kids = get(plot_g_pval, 'Children');
    for c = 1:numel(kids)
        set(kids(c), 'ButtonDownFcn', {@RefreshTanovaCallbackKid});
    end
    set(gca,'FontSize',25)
    
    tc = (axismin + axismax) / 2;
    lh = plot(plot_g_pval, [tc tc], norminv([0.0001 0.999]), '-r', 'LineWidth', 6); hold on;
    %plot(plot_g_GFP, [tc tc], [0 1],'-r');

    set(lh,'Tag','Cursor');
    xlabel('Time, ms');
    ylabel('p-Value');   
end