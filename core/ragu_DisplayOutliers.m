function ragu_DisplayOutliers(data, settings)
    
    groups = unique(settings.BetweenGroups);
    ng = numel(groups);
    
    dims = size(data);
    ns = numel(settings.BetweenGroups)/ng;
    
    labels = cellstr(num2str([1:ns]'));
    
    centering = eye(dims(1)) - 1/ dims(1);
    dtv = centering * reshape(data, [dims(1),prod(dims(2:end))]);
    cov = dtv * dtv';

    [v, ~] = eigs(cov,2);
    figure;
    lbl = {'*g','+y','oB','.r','xc','sm','dk','vw'};
    legend_patch = cell(ng, 1);
    
    for g = 1:ng
        idx = settings.BetweenGroups == groups(g);
        legend_patch{g} = plot(gca, v(idx, 1), v(idx, 2), lbl{g}, 'MarkerSize', 20); hold on;
        text(v(idx, 1), v(idx, 2), labels, 'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'right');      
    end
    
    dd = v(:, 1:2);
    mx = max(abs(dd(:))) * 1.05;
    axis([-mx mx -mx mx]);
    
    plot(gca, [0 0], [-mx mx], '-k', 'LineWidth', 2);
    plot(gca, [-mx mx], [0 0], '-k', 'LineWidth', 2);
    
    set(gca,'FontSize',25);
    set(gca,'Color',[0.5 0.5 0.5]);  
    legend(gca, [legend_patch{:}], settings.groupLabels(:));    
end