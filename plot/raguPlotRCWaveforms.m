function raguPlotRCWaveforms(plotHandle, data, tc, labels, dataType, rc)
    load('colorbrewer');    
    
    nGroups = size(data.all_mu, 1);
    nCnd = size(data.all_mu, 2);
    
    labels_1 = 'OZ';
    if (rc == 0)
        plotData = data.gfp;
        plotIdx = 1;
        labels_1 = 'GFP';
    else
        plotData = data;
        plotIdx = rc;
        labels_1 = 'RC';
    end
    
    % specify palette depending on grouptype
    switch dataType
        case 'gc'
            nPlots = nGroups*nCnd;
            labels_2 = 'Groups x Factor ';
            muData = squeeze(plotData.all_mu(:, :, plotIdx, :));
            semData = squeeze(plotData.all_s(:, :, plotIdx, :));
            PaletteN = 9;
            blues = colorbrewer.seq.Blues{PaletteN}/255;
            reds = colorbrewer.seq.Reds{PaletteN}/255;
            oranges = colorbrewer.seq.Oranges{PaletteN}/255;
            greens = colorbrewer.seq.Greens{PaletteN}/255;
            warmColors = interleave(1 ,reds(end:-1:2, :), oranges(end:-1:2, :));
            coldColors = interleave(1, blues(end:-1:2, :), greens(end:-1:2, :));
            c_rg = interleave(1, coldColors(2:nGroups + 1, :), ...
                warmColors(2:nGroups + 1, :));           
        case 'g'
            nPlots = nGroups; 
            labels_2 = 'Groups ';
            c_rg = [colorbrewer.qual.Dark2{8}; colorbrewer.qual.Accent{4}]/255;
            muData = (plotData.group_mu(:, plotIdx, :));
            semData = (plotData.group_s(:, plotIdx, :));
        case 'c'
            labels_2 = 'Factors ';
            PaletteN = 9;
            nPlots = nCnd;            
            blues = colorbrewer.seq.Blues{PaletteN}/255;
            reds = colorbrewer.seq.Reds{PaletteN}/255;
            c_rg = interleave(1, blues(end:-1:1, :), ...
                reds(end:-1:1, :));
            muData = (plotData.condition_mu(:, plotIdx, :));
            semData = (plotData.condition_s(:, plotIdx, :));
                
        otherwise
    end
    legend_patch = cell(nPlots, 1);
    Label = [labels_2 labels_1 ' Waveforms'];
    for p = 1:nPlots
        [r, c] = ind2sub([size(muData, 1) size(muData, 2)], p);
        mu = squeeze(muData(r, c, :));
        sem = squeeze(semData(r, c , :));
        legend_patch{p} = customErrPlot(plotHandle, tc', mu, sem, c_rg(p, :), 25, Label, '--');
    end
    legend(plotHandle, [legend_patch{:}], labels(:));   
end