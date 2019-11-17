function efs = ragu_DoAllEffectSizes(data, Design, iDesign, Group, DoGroup, DoF1, DoF2, Normalize, ContGroup, ContF1)
    
    [~, nCnds, ~, nSamples] = size(data);
    
    if Normalize
        data = NormDimL2(data, 3);
    end
    
    if (numel(size(data)) == 3)
        data = reshape(data, [size(data) 1]);
    end


    efs = squeeze(nan(2, 4, nSamples));
        
    
    for t = 1:nSamples 
        currSample = squeeze(data(:, :, :, t));
    
        % Take out the mean
        [es, mmBL] = OLES(currSample, ones(1, nCnds), 0);
        noBL_M = currSample - mmBL;
        efs(1, 1, t) = es;
    
        %'Main group effect'
        if DoGroup
            if ContGroup
                callback_fcn = @OLESCG;
            else
                callback_fcn = @OLESG;
            end
            [es, mmBLG] = callback_fcn(noBL_M, ones(1, nCnds), Group, Normalize);
            noBL_MG = noBL_M - mmBLG;
            efs(2, 1, t) = es;
        end
        
        %Factor 1
        if DoF1
            if ContF1 == 0
                [es, mmBLF1] = OLES(noBL_M, Design(:, 1), Normalize);
            else
                [es, mmBLF1] = OLESC(noBL_M, Design(:, 1), Normalize);
            end
            efs(1, 2, t) = es;
        end
        %'Factor 1 and Group'
        if (DoF1 && DoGroup)
            if ContGroup
                if ContF1 == 0
                    [es, mmBLGF1] = OLESCG(noBL_MG - mmBLF1, Design(:, 1), Group, Normalize);
                else
                    [es, mmBLGF1] = OLESCCG(noBL_MG - mmBLF1, Design(:, 1), Group, Normalize);
                end
            else
                if ContF1 == 0
                    [es, mmBLGF1] =  OLESG(noBL_MG - mmBLF1, Design(:, 1), Group, Normalize);
                else
                    [es, mmBLGF1] =  OLESGDC(noBL_MG - mmBLF1, Design(:, 1), Group, Normalize);
                end
            end
            efs(2, 2, t) = es;
        end
         % Factor 2
        if DoF2
            [es,mmBLF2] = OLES(noBL_M, Design(:, 2), Normalize);
            efs(1, 3, t) = es;
        end
        % Factor 2 and Group
        if (DoF2 && DoGroup)
            if ContGroup
                [es, mmBLGF2] = OLESCG(noBL_MG - mmBLF2, Design(:, 2), Group, Normalize);
            else
                [es, mmBLGF2] = OLESG(noBL_MG - mmBLF2, Design(:, 2), Group, Normalize);
            end
%        noBL_MGF2 = noBL_MG-mmBLF2-mmBLGF2;
            efs(2,3,t) = es;
        end
    % Factor 1 * Factor 2
        if (DoF1 && DoF2)
            [es, mmBLGF1F2] = OLES(noBL_M - mmBLF1 - mmBLF2, iDesign, Normalize);
            efs(1,4,t) = es;
        end
    % Factor 1 * Factor 2 * Group
        if (DoF1 && DoF2 && DoGroup)
            if ContGroup
                efs(2,4,t) = OLESCG(noBL_MG - mmBLF1 - mmBLF2 - mmBLGF1 - mmBLGF2 - mmBLGF1F2, ...
                    iDesign, Group, Normalize);
            else
                efs(2,4,t) =  OLESG(noBL_MG - mmBLF1 - mmBLF2 - mmBLGF1 - mmBLGF2 - mmBLGF1F2, ...
                    iDesign, Group, Normalize);
            end
        end
    end

end