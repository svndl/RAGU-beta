function efs = ragu_CalcGroupF1(data, Normalize, Design, Group, ContGroup, ContF1)
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
    callback_matrix = {@OLESG_mat, @OLESCG; @OLESGDC, @OLESCCG};
    callback_group = callback_matrix{1, ContGroup + 1};
    callback_groupf1 = callback_matrix{ContGroup + 1, ContF1 + 1};
    
    callback_f1 = @OLES_mat; 
    if (ContF1)
        callback_f1 = @OLESC;
    end
    [es1, meanAll] = OLES_mat(data, ones(1, nCnds), 0);
    efs(1, 1, :) = es1;
    noBL_M = data - meanAll;
    [esG, meanGroup] = callback_group(noBL_M, ones(1, nCnds), Group, Normalize);
    efs(2, 1, :) = esG;
    noBL_MG = noBL_M - meanGroup;
    
    [esF1, meanFactor1] = callback_f1(noBL_M, Design(:, 1), Normalize);
    efs(1, 2, :) = esF1;
    [esGF1, meanGroupFactor1] =  callback_groupf1(noBL_MG - meanFactor1, Design(:, 1), Group, Normalize);
    efs(2, 2, :) = esGF1;
%     load('oldRAGU_iter1.mat');
%     delta_oles = meanAll - mmBL_t;
%     sum(delta_oles(:))
% 
%     delta_olesg = meanGroup - mmBLG_t;
%     sum(delta_olesg(:))
% 
%     delta_olesf1 = meanFactor1 - mmBLF1_t;
%     sum(delta_olesf1(:))
% 
%     delta_olesgf1 = meanGroupFactor1 - mmBLGF1_t;
%     sum(delta_olesgf1(:))            
end
