function dataOut = baseline3DData(dataIn)
    averagingWindowMs = 50;
    [nSubj, nCh, nSamples] = size(dataIn);
    
    tc = linspace(0, nSamples*1000/420, nSamples);
    % nsubj x nch x ntimesamples 
    [~, b] = find(tc > averagingWindowMs);
    
    m1 = nanmean(dataIn(:, :, 1:b), 3);   

    dataOut =  dataIn - repmat(m1, [1 1 nSamples]);
end
