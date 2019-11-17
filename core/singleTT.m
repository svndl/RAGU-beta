function [threshold, p] = singleTT(data)
    n_iters = size(data, 4);
    th = 0.05;
    m = squeeze(mean(data, 3));
    ms = sort(m, 3, 'ascend');
 
    idx = floor(n_iters * th);
    threshold = 0;
    p = 1;
    
    if (isempty(idx)||(idx < 1))
        return
    end
    
    threshold = squeeze(ms(:, :, idx));
    p = sum(m <= repmat(m(:,:,1),[1,1,n_iters]),3) / n_iters;
end 