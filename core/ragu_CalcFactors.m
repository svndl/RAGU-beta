function efs = ragu_CalcFactors(data, Normalize, Design, iDesign, contF1)
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
    
    if (contF1)
        callback_fcn = @OLESC;
    end
    
    for t = 1:nSamples 
        currSample = squeeze(data(:, :, :, t));

        % Take out the mean
        [efs(1, 1, t), mmBL] = OLES(currSample, ones(1, nCnds), 0);
        noBL_M = currSample - mmBL;
        [efs(1, 2, t), mmBLF1] = callback_fcn(noBL_M, Design(:, 1), Normalize);
        [efs(1, 3, t), mmBLF2] = callback_fcn(noBL_M, Design(:, 2), Normalize);
        [efs(1, 4, t), ~] = OLES(noBL_M - mmBLF1 - mmBLF2, iDesign, Normalize);
    end
end