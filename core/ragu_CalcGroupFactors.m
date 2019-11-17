function efs = ragu_CalcGroupFactors(data, Normalize, Design, iDesign, Group, ContGroup, ContF1)
    [~, nCnds, ~, nSamples] = size(data);
    
    if Normalize
        data = NormDimL2(data, 3);
    end
    
    if (numel(size(data)) == 3)
        data = reshape(data, [size(data) 1]);
    end
    efs = squeeze(nan(2, 4, nSamples));
    
    %% callback/index table:
    
    % ContF1 = 0; ContGroup = 0;
    callback_matrix_group_f1 = {@OLESG, @OLESCG; @OLESGDC, @OLESCCG};
    callback_group_f1 = callback_matrix_group_f1(ContGroup + 1, ContF1 + 1);
    
    callback_f1 = @OLES; 
    if (ContF1)
        callback_f1 = @OLESC;
    end
    
    callback_group = @OLESG;
    if (ContGroup)
        callback_group = @OLESGC;
    end
    
    for t = 1:nSamples 
        currSample = squeeze(data(:, :, :, t));
        [efs(1, 1, t), mmBL] = OLES(currSample, ones(1, nCnds), 0);
        noBL_M = currSample - mmBL;
        % F1, group F1
        [efs(1, 2, t), mmBLF1] = callback_f1(noBL_M, Design(:, 1), Normalize);
        [efs(2, 2, t), mmBLGF1] = callback_group_f1(noBL_MG - mmBLF1, Design(:, 1), Group, Normalize);        
        % F2; group F2
        [efs(1, 3, t), mmBLF2] = OLES(noBL_M, Design(:, 2), Normalize);
        [efs(2,3,t), mmBLGF2] = callback_group(noBL_MG - mmBLF2, Design(:, 2), Group, Normalize);
        % Group
        [efs(2, 1, t), mmBLG] = callback_group(noBL_M, ones(1, nCnds), Group, Normalize);
        noBL_MG = noBL_M - mmBLG;
        efs(2, 4, t) =  callback_group(noBL_MG - mmBLF1 - mmBLF2 - mmBLGF1 - mmBLGF2 - mmBLGF1F2, ...
                    iDesign, Group, Normalize);
    end
end