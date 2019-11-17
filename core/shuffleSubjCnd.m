function dataOut = shuffleSubjCnd(dataIn, settings)

    dataOut = zeros(size(dataIn));
    
    for s = 1:size(dataIn, 1)
       dataOut(s, :, :, :) = dataIn(s, PermDesign(settings.NewDesign, settings.NoXing), :, :);
    end
    
end
