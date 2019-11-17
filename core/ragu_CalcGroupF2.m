function efs = ragu_CalcGroupF2(data, Normalize, Design, Group, ContGroup)
    [~, nCnds, ~, nSamples] = size(data);
    
    if Normalize
        data = NormDimL2(data, 3);
    end
    
    if (numel(size(data)) == 3)
        data = reshape(data, [size(data) 1]);
    end
    efs = squeeze(nan(2, 4, nSamples));
    
    %% callback/index table:
        
    callback_group = @OLESG; 
    if (ContGroup)
        callback_group = @OLESCG;
    end
   
    for t = 1:nSamples 
        currSample = squeeze(data(:, :, :, t));
        [efs(1, 1, t), mmBL] = OLES(currSample, ones(1, nCnds), 0);
        noBL_M = currSample - mmBL;
        [efs(1, 3, t), mmBLF2] = OLES(noBL_M, Design(:, 2), Normalize);
        [efs(2, 3, t), ~] = callback_group(noBL_MG - mmBLF2, Design(:, 2), Group, Normalize);
    end
end
