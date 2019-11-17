function avgData = ragu_getData(experiment, groupLabel, reload, subtype)
    %% data loader for Ragu
    %% returns average by subject+condition
    [rootFolder, ~, ~] = fileparts(mfilename('fullpath'));
    datatype = 'Time';
    if (isempty(experiment))
        experiment = 'FullField';
    end
    if (isempty(groupLabel))
        groupLabel = 'Students';
    end
    savedDataFolder = fullfile(rootFolder, 'EEG_DATA', experiment);    
    saved_data_file = fullfile(savedDataFolder, ['avgData_' experiment '_' subtype '_' groupLabel '.mat']);
    [groupLbl, subgroupLbl] = strtok(groupLabel, '_');
    if (reload || ~exist(saved_data_file, 'file'))
        switch groupLbl  
            case 'Patients'
                [rawData_Pat_os, rawData_Pat_od] = getRawData(groupLbl, datatype, experiment);
                pgroups = numel(rawData_Pat_os);  
                switch subgroupLbl(2:end)
                    case 'Mild'
                        p = 1;
                    case 'Moderate'
                        p = 2;
                    case 'Severe'
                        p= 3;
                end
                if (p > pgroups)
                    p = pgroups;
                end
                rawData = cat(1, rawData_Pat_os{p}, rawData_Pat_od{p});
%                 p0 = cellfun(@(x) nanmean(x, 3), rawData, 'uni', false);
%                 hasNans = cell2mat(cellfun(@(x) ~isnan(sum(sum(x))), p0, 'uni', false));
%                 avgSubjData = cat(2, p0(hasNans(:, 1), 1), p0(hasNans(:, 1), 2));
%                 avgData_pat = permute(cat(4, cat(3, avgSubjData{:, 1}), cat(3, avgSubjData{:, 2})), [3 4 2 1]);
                
%                 for p = 1:pgroups
%                     rawData{p} = cat(1, rawData_Pat_os{p}, rawData_Pat_od{p});
%                     p0 = cellfun(@(x) nanmean(x, 3), rawData{p}, 'uni', false);
%                     hasNans = cell2mat(cellfun(@(x) ~isnan(sum(sum(x))), p0, 'uni', false));
%                     avgSubjData = cat(2, p0(hasNans(:, 1), 1), p0(hasNans(:, 1), 2));
%                     avgData_pat{p} = permute(cat(4, cat(3, avgSubjData{:, 1}), cat(3, avgSubjData{:, 2})), [3 4 2 1]);
%                     nPatients = nPatients + size(avgData_pat{p}, 1);
%                 end
                info = getExperimentInfo('FullField');
                idx = ragu_prepForReshape(info);
            otherwise
                [expLbl, subLbl] = strtok(experiment, '_');
                rawData = getRawData(groupLbl, datatype, expLbl, subtype);
                                    
                if (iscell(rawData))
                    %avg per subject
                    switch expLbl
                        case 'FullField'
                            %% leave  2 conditions 
                            info = getExperimentInfo('FullField');
                            idx = ragu_prepForReshape(info);                        
                        case 'UpperVsLower'
                            info = getExperimentInfo('UpperVsLower');
                            idx = ragu_prepForReshape(info);
                        case 'HexagonsSquares'
                            info = getExperimentInfo('HexagonsSquares');
                            idx = ragu_prepForReshape(info);
                        case '2F'
                            info = getExperimentInfo('2F');
                            idx = ragu_prepForReshape(info); 
                        case '2FContrast'
                            info = getExperimentInfo('2FContrast');
                            idx = ragu_prepForReshape(info);                             
                        otherwise
                    end
                end
        end
        avgData.rawData = rawData;
        f = fieldnames(idx);
        for i = 1:length(f)
            avgData.(f{i}) = idx.(f{i});
        end 
        save(saved_data_file, 'avgData', '-v7.3');                    
    else
        load(saved_data_file);
    end
end
