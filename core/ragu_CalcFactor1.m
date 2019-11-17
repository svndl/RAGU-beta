function efs = ragu_CalcFactor1(data, Normalize, Design, contF1)
    
    [~, nCnds, ~, nSamples] = size(data);
    
    if Normalize
        data = NormDimL2(data, 3);
    end
    
    if (numel(size(data)) == 3)
        data = reshape(data, [size(data) 1]);
    end
    efs = nan(2, 4, nSamples);
    
    %% callback/index table:
    callback_fcn = @OLES_mat;
    
    if (contF1)
        callback_fcn = @OLESC;
    end
    
    [efs(1, 1, :), mmBL] = OLES_mat(data, ones(1, nCnds), 0);
    noBL_M = data - mmBL;
    [efs(1, 2, :), ~] = callback_fcn(noBL_M, Design(:, 1), Normalize);

%     for t = 1:nSamples 
%         currSample = squeeze(data(:, :, :, t));
%     
%         % Take out the mean
%         [efs(1, 1, t), mmBL] = OLES(currSample, ones(1, nCnds), 0);
%         noBL_M = currSample - mmBL;
%         [efs(1, 2, t), ~] = callback_fcn(noBL_M, Design(:, 1), Normalize);
%     end
end