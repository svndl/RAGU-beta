function [fcn, argsIdx] = ragu_GetCallbackMatrix(doF1, doF2, doGroup)
    % callback matrix
    % if F1                 ragu_CalcFactor1(data, Normalize, Design, contF1)
    % if F2                 ragu_CalcFactor2(data, Normalize, Design)
    % if F1 & F2            ragu_CalcFactors(data, Normalize, Design, iDesign , contF1)
    % if doGroup            ragu_CalcGroup(data, Normalize, Group, contGroup)
    % if doGroup & F1       ragu_CalcGroupF1(data, Normalize, Design, Group , ContGroup, contF1)
    % if doGroup & F2       ragu_CalcGroupF2(data, Normalize, Design, Group , ContGroup)
    % if doGroup & F1 & F2  ragu_CalcGroupFactors(data, Normalize, Design, iDesign, Group, ContGroup, contF1)

    callback_Matrix = cell(2,2,2);    
    callback_Matrix{1, 1, 1} = 'error';
    callback_Matrix{2, 1, 1} = 'ragu_CalcFactor1';
    callback_Matrix{1, 2, 1} = 'ragu_CalcFactor2';
    callback_Matrix{2, 2, 1} = 'ragu_CalcFactors';
    callback_Matrix{1, 1, 2} = 'ragu_CalcGroup';
    callback_Matrix{2, 1, 2} = 'ragu_CalcGroupF1';
    callback_Matrix{1, 2, 2} = 'ragu_CalcGroupF2';
    callback_Matrix{2, 2, 2} = 'ragu_CalcGroupFactors';
    
    str = callback_Matrix{doF1 + 1, doF2 + 1, doGroup + 1};
    fcn = str2func(str);
    nMaxArgs = 5;
    argsIdx = zeros(nMaxArgs, 1);
    % arg list:
    %Design, iDesign, Group, ContGroup, contF1
    
    switch str
        case 'ragu_CalcFactor1'
            argsIdx([1 5], 1) = 1;
        case 'ragu_CalcFactor2'
            argsIdx(1, 1) = 1;
        case 'ragu_CalcFactors'
            argsIdx([1 2 5], 1) = 1;
        case 'ragu_CalcGroup'
            argsIdx([3 4], 1) = 1;
        case 'ragu_CalcGroupF1'
            argsIdx([1, 3:5], 1) = 1;
        case 'ragu_CalcGroupF2'
            argsIdx([1 3 4], 1) = 1;
        case 'ragu_CalcGroupFactors'
            argsIdx = ones(nMaxArgs, 1);
    end
    argsIdx = logical(argsIdx');
end