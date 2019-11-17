function efs = ragu_CalcFactor2(data, Normalize, Design)
    
    [~, nCnds, ~, nSamples] = size(data);
    
    if Normalize
        data = NormDimL2(data, 3);
    end
    
    if (numel(size(data)) == 3)
        data = reshape(data, [size(data) 1]);
    end
    efs = squeeze(nan(2, 4, nSamples));
    
    %% callback/index table:
    callback_fcn = @OLES;
        
    for t = 1:nSamples 
        currSample = squeeze(data(:, :, :, t));
    
        % Take out the mean
        [efs(1, 1, t), mmBL] = OLES(currSample, ones(1, nCnds), 0);
        noBL_M = currSample - mmBL;
        [efs(1, 3, t), ~] = callback_fcn(noBL_M, Design(:, 1), Normalize);
    end
end