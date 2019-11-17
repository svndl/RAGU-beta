function plotTopoGroup(data, index)
    nPlotRows = 3;
    nGroups = size(data.dataXY, 1);
    maxV = max(data.dataXY(:));
    minV = min(data.dataXY(:));
    for g = 1:nGroups
        frames = squeeze(data.dataXY(g, :, index));
        subplot(nPlotRows, nGroups, g);
        plotOnEgi(frames, [minV, maxV]);
        title(data.titles{g}, 'FontSize', 25);
    end
end