function out = gfpData_mat(matEEG)
    % computes GFP data for array of subjects
    % input: 3D data matrix nSubj x nChanels x nSamples
    % output: 2D data matrix nSubj x nSamples
    ns = size(matEEG, 1);
    out = zeros(ns, size(matEEG, 3));
    for s = 1:ns
        out(s, :) = gfpData(squeeze(matEEG(s, :, :))');
    end
end
