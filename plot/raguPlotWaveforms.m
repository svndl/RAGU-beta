function raguPlotWaveforms(plotHandle, dataStruct, tc, labels, dataType, channel)
    load('colorbrewer');    
    
    nGroups = size(dataStruct.means, 2);
    nCnd = size(dataStruct.means, 3);
    
    % specify palette depending on grouptype
    switch dataType
        case 'gc'
            nPlots = nGroups*nCnd;
            groupData = squeeze(dataStruct.means(:, :, :, channel, :));
            muData = squeeze(nanmean(groupData, 1));
            muData = muData - repmat(muData(:, :, 1), [1 1 size(muData, 3)]);
            semData = squeeze(nanstd(groupData, [], 1)/(sqrt(size(groupData, 1))));
            PaletteN = 9;
            blues = colorbrewer.seq.Blues{PaletteN}/255;
            reds = colorbrewer.seq.Reds{PaletteN}/255;
            oranges = colorbrewer.seq.Oranges{PaletteN}/255;
            greens = colorbrewer.seq.Greens{PaletteN}/255;
            warmColors = interleave(1 ,reds(end:-2:3, :), oranges(end:-2:3, :));
            coldColors = interleave(1, blues(end:-2:3, :), greens(end:-2:3, :));
            c_rg = interleave(1, coldColors(2:nGroups + 1, :), ...
                warmColors(2:nGroups + 1, :));           
        case 'g'
            nPlots = nGroups;
            c_rg = colorbrewer.qual.Dark2{8}/255;
            groupData = squeeze(dataStruct.gmeans(:, :, channel, :));
            muData = squeeze(nanmean(groupData, 3));
            muData = muData - repmat(muData(:, 1), [1 size(muData, 2)]);
            semData = squeeze(nanstd(groupData, [], 3)/(sqrt(size(groupData, 3))));
            muData = reshape(muData, [1 size(muData)]);
            semData = reshape(semData, [1 size(semData)]);
        case 'c'
            PaletteN = 9;
            nPlots = nCnd;            
            blues = colorbrewer.seq.Blues{PaletteN}/255;
            reds = colorbrewer.seq.Reds{PaletteN}/255;
            c_rg = interleave(1, blues(end:-1:1, :), ...
                reds(end:-1:1, :));                       
            groupData = squeeze(dataStruct.cmeans(:, :, channel, :));
            muData = squeeze(nanmean(groupData, 3));
            muData = muData - repmat(muData(:, 1), [1 size(muData, 2)]);
            semData = squeeze(nanstd(groupData, [], 3)/(sqrt(size(groupData, 3))));
            muData = reshape(muData, [1 size(muData)]);
            semData = reshape(semData, [1 size(semData)]);            
        otherwise
    end
    legend_patch = cell(nPlots, 1);
    for p = 1:nPlots
        [r, c] = ind2sub([size(muData, 1) size(muData, 2)], p);
        legend_patch{p} = customErrPlot(plotHandle, tc, squeeze(muData(r, c, :)),...
            squeeze(semData(r, c , :)), c_rg(p, :), 25, 'All', '-');
           
    end
    legend(plotHandle, [legend_patch{:}], labels(:));   
end