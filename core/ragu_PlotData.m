function ragu_PlotData(results, settings)
% function will plot:
% left panel: top: p-Value for the given option; bottom: waveforms
% right panel: top is topo and bottom is the distance 
% 
    time = linspace(0, 154*2.73, 154);
    p_threshold = 0.05;
    bcol = [0.7 0.7 0.7];
    axismin = time(1);
    axismax = time(end);
    
    f = figure;
    s11 = subplot(2, 2, 1);
    s12 = subplot(2, 2, 2);
    s21 = subplot(2, 2, 3);
    s22 = subplot(2, 2, 4);
    
    % Signifiance shading
    h = bar(time, data_pVal > p_threshold); % 
    set(h,'BarWidth', 1, 'EdgeColor', bcol, 'FaceColor', bcol);
    hold on
    
    % p-Value plot
    tanh = plot(time, data_pVal, '-k', 'LineWidth', 2);    
    title('Group*Condition', 'Interpreter', 'none', 'FontSize',2 8);
    axis([axismin axismax 0 1]);
    
    % cursor
    tc = (axismin + axismax) / 2;
    lh = plot([tc tc], [0 1],'-r');
    set(lh,'Tag','Cursor');
    xlabel('Time, ms');
    ylabel('p-Value');
    
    %topomap
end