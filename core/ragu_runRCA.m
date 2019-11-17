function dataOut = ragu_runRCA(data, path, label)

    rcData = cat(1, data(:));
    settings.resultsDir = path;
    settings.dataset = label;            
    [~, W, A]  = rcaRunOnly(rcData, settings);
        
    dataOut.W = W;
    dataOut.A = A;
end