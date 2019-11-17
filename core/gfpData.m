function out = gfpData(tEEG)
    % Computes GFP for a single dataset
    % input: 2D data matrix nSamples x nChanels
    % output: 1D data matrix nSamples x 1

    [tNt, tNChan] = size( tEEG );
    tYj = zeros(tNt,1);
    for i = 1:tNChan
        tYj = tYj + sum( ( tEEG(:,repmat(i,1,tNChan-i)) - tEEG(:,(i+1):tNChan) ).^2, 2);
    end
    out = sqrt( tYj / tNChan);
end

