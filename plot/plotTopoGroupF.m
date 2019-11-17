function plotTopoGroupF(data, index)

    nPlotRows = 4;
    nGroups = size(data.dataXY, 1);
    nConds = size(data.dataXY, 2);
    maxV = max(data.dataXY(:));
    minV = min(data.dataXY(:));
    
    for c = 1:nConds
        for g = 1:nGroups
            frames = squeeze(data.dataXY(g, c, :, index));
            i = sub2ind([nGroups, nPlotRows], g, c);
            subplot(nPlotRows, nGroups, i);
            plotOnEgi(frames, [minV, maxV]);
            title(data.titles{c, g}, 'FontSize', 25);
        end
    end
end