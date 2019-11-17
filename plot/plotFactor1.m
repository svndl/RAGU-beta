function plotFactor1(results, settings, dataIn, ch, varargin)
    
    %% plots factor 1
    % left top panel p-value
    % left bottom panel mean conditions at channel xx?
    % right panel(s) A topo condition A, B
        
    figure;

    idx1 = 1;
    idx2 = 2;
    
    cndMeans = dataIn.condition_mu;
    nCnd = size(cndMeans, 1);
    
    nPlotRows = 3;
    nPlots = nPlotRows*nCnd;
    
    %egih = cell(nGroups, 1);
    
    if nargin < 5
        idx_0 = 0.5*size(cndMeans, 3);
    else
        idx_0 = varargin{5};
    end
    %% default template for plotting
    data.dataXY = dataIn.topoF1;
    data.titles = settings.conditionLabels;
    plotTopoGroup(data, idx_0);

    data.callback = @plotTopoGroup;
    set(gcf, 'UserData', data);    
    
    data_pVal = squeeze(results.PTanova(idx1, idx2, :, 1));
    endFrame = size(results.PTanova, 3);
    freq = 1000/420;
 
    endFrame = size(results.PTanova, 3);
    freq = 1000/420;
    time = linspace(0, endFrame*freq, endFrame);
    plot_F1_GFP = subplot(nPlotRows, nCnd, (nPlotRows - 2)*nCnd + 1:(nPlotRows - 1)*nCnd);
    raguPlotRCWaveforms(plot_F1_GFP, dataIn, time, settings.conditionLabels, 'c', ch);   
    
    bcol = [0.7 0.7 0.7];
    axismin = time(1);
    axismax = time(end);
    
    % Signifiance shading
    plot_F1_pval = subplot(nPlotRows, nCnd, (nPlotRows - 1)*nCnd + 1:nPlots);
    

    % p-Value plot
    zscore = @(p) -sqrt(2) * erfcinv(p*2);

    p_label = [0.0001 0.001 0.01 0.05 0.1 0.25 0.5 0.75 0.9 0.95 0.99 0.999 0.9999 0.99999];
    set(gca,'YTick',norminv(p_label))
    set(gca,'YTickLabel',p_label)    
    
    plot(plot_F1_pval, [time(1) time(end)], norminv([0.05 0.05]), '-k', 'LineWidth', 4); hold on; 
    tanh = plot(plot_F1_pval, time, zscore(data_pVal), 'Color', bcol, 'LineWidth', 6);
    title('Factor p-value', 'Interpreter', 'none', 'FontSize', 28);
    %axis([axismin axismax 0 1]);
    set(tanh, 'Tag', 'TanovaP');
    p_label = [0.0001 0.001 0.01 0.05 0.1 0.25 0.5 0.75 0.9 0.95 0.99 0.999 0.9999 0.99999];
    set(gca,'YTick',norminv(p_label))
    set(gca,'YTickLabel',p_label)    
   
    set(plot_F1_pval,'ButtonDownFcn', {@RefreshTanovaCallback, 1});        
    kids = get(plot_F1_pval, 'Children');
    for c = 1:numel(kids)
        set(kids(c), 'ButtonDownFcn', {@RefreshTanovaCallbackKid});
    end
    set(gca,'FontSize',25)

    
    tc = (axismin + axismax) / 2;
    lh = plot(plot_F1_pval, [tc tc], norminv([0.0001 0.999]), '-r', 'LineWidth', 6);
    set(lh,'Tag','Cursor');
    xlabel('Time, ms');
    ylabel('p-Value');
end