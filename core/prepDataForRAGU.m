function prepDataForRAGU(experiment, group)
% Ragu stores all scalp field data to be analyzed internally in a single 
% four-dimensional matrix number of subjects number of conditions sensors time points
% fileformat SXX_CYY.asc

    [rootFolder, ~, ~] = fileparts(mfilename('fullpath'));
    datatype = 'Time';
    srcEEGDir = fullfile(rootFolder, 'EEG_DATA', experiment, group);
    
    % average subject/condition data    
    switch group
        case 'Students'
            rawData = getRawData(group, datatype, experiment);
            LabelDigs = {'10'};
        case 'Controls'
            LabelDigs = {'20'};
            rawData = getRawData(group, datatype, experiment);
        case 'Patients'
            [data_os, data_od] = getRawData(group, datatype, experiment);
            rawData = cellfun(@(x, y) cat(1, x, y), data_os, data_od, 'uni', false);
            nSubGroups = size(rawData, 1);
            LabelDigs = arrayfun(@ (x) strcat('3', num2str(x)), 1:nSubGroups, 'uni', false); 
        otherwise
    end
    
    strSubjLabel = cellfun(@ (x) strcat('S', x), LabelDigs, 'uni', false);
    hasSubGroups = iscell(rawData{1,1});
    if (hasSubGroups) 
        % filename matrix
        for s = 1:size(rawData, 1)
            p0 = cellfun(@(x) nanmean(x, 3), rawData{s}, 'uni', false);
            hasNans = cell2mat(cellfun(@(x) ~isnan(sum(sum(x))), p0, 'uni', false));
            avgSubjData{s} = cat(2, p0(hasNans(:, 1), 1), p0(hasNans(:, 1), 2));
            %writeRAGUFiles(p0, strSubjLabel{s}, srcEEGDir); 
        end
    else
        avgSubjData = {cellfun(@(x) nanmean(x, 3), rawData, 'uni', false)};
    end
    writeRAGUFiles(avgSubjData, strSubjLabel, srcEEGDir);
end
