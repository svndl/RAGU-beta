function plotGroupF1(results, settings, dataIn, ch, varargin)
    %% plots Group F1
    % left top panel p-value
    % left bottom panel mean conditions at channel xx?
    % right panel(s) A topo condition A, B
    
    figure;
    
    idx1 = 2;
    idx2 = 2;
    nGroups = size(dataIn.all_mu, 1);
    nCnd = size(dataIn.all_mu, 2);
    nPlotRows = nCnd + 2;
    nPlots = nPlotRows*nGroups;
    
    %egih = cell(nGroups, 1);
    
    if nargin < 5
        idx_0 = 0.5*size(dataIn.all_mu, 4);
    else
        idx_0 = varargin{5};
    end
    
    %% default template for plotting
    data.dataXY = dataIn.topoGroupF1;
    l1 = repmat(settings.groupLabels, [nCnd 1]);
    l2 = repmat(settings.conditionLabels', [1 nGroups]);
    data.titles = cellfun(@(x, y) strcat(x, ': ', y), l1, l2, 'uni', false);
    plotTopoGroupF(data, idx_0);

    data.callback = @plotTopoGroupF;
    set(gcf, 'UserData', data);    
    
    data_pVal = squeeze(results.PTanova(idx1, idx2, :, 1));
    endFrame = size(results.PTanova, 3);
    freq = 1000/420;

    %plot_F1_cnds = subplot(2, 2, 2);
    
    time = linspace(0, endFrame*freq, endFrame);
    bcol = [0.7 0.7 0.7];
    axismin = time(1);
    axismax = time(end);
    
    f1g_data_start = nGroups*nCnd + 1;
    f1g_data_end = nGroups*(nCnd + 1);
    plot_F1G_data = subplot(nPlotRows, nGroups, f1g_data_start:f1g_data_end);
    
    
    title(plot_F1G_data, 'Groups', 'Interpreter', 'none', 'FontSize', 28);
    dataLabels = allcomb(settings.groupLabels, settings.conditionLabels);    
    allLabels = cellfun(@(x, y) strcat(x, ' ', y), dataLabels(:, 1), dataLabels(:, 2), 'uni', false);
    
    raguPlotRCWaveforms(plot_F1G_data, dataIn, time, allLabels, 'gc', ch);   
    % Signifiance shading
    set(gca,'FontSize',25);
    
    f1g_p_start = f1g_data_end + 1;
    f1g_p_end = nPlots;
    plotPValue = subplot(nPlotRows, nGroups, f1g_p_start:f1g_p_end);   
%     h = bar(plotPValue, time, data_pVal > settings.Threshold); 
%     set(h, 'BarWidth', 1, 'EdgeColor', bcol, 'FaceColor', bcol);
%     hold on
%     h = bar(plotPValue, time, norminv(squeeze(results.rsig(idx1, idx2, :))));
%     set(h,'BarWidth',1,'EdgeColor',[0 1 0],'FaceColor',[0 1 0]);

    % p-Value plot
    zscore = @(p) -sqrt(2) * erfcinv(p*2);
    plot(plotPValue, [time(1) time(end)], norminv([0.05 0.05]), '-k', 'LineWidth', 4); hold on;
    
    tanh = plot(plotPValue, time, zscore(data_pVal), 'color', bcol, 'LineWidth', 6);
    title('Groups x Factor p-value', 'Interpreter', 'none', 'FontSize', 28);
    %axis([axismin axismax 0 1]);
    set(gca,'FontSize',25);
    set(tanh, 'Tag', 'TanovaP'); 
    p_label = [0.0001 0.001 0.01 0.05 0.1 0.25 0.5 0.75 0.9 0.95 0.99 0.999 0.9999 0.99999];
    set(gca,'YTick',norminv(p_label))
    set(gca,'YTickLabel',p_label)    
    
    
    set(plotPValue,'ButtonDownFcn', {@RefreshTanovaCallback});        
    
    kids = get(plotPValue, 'Children');
    for c = 1:numel(kids)
        set(kids(c), 'ButtonDownFcn', {@RefreshTanovaCallbackKid});
    end
     
    tc = (axismin + axismax) / 2;
    lh = plot(plotPValue, [tc tc], norminv([0.0001 0.99999]), '-r', 'LineWidth', 4);
    
    set(lh,'Tag','Cursor');
    xlabel('Time, ms');
    ylabel('p-Value');
end