function rsig = ragu_computeSignificance(results, settings)

    [n1, n2, n3, ~] = size(results.PTanova);
    rsig = zeros(n1, n2, n3);
    for i = 1:n1
        for j = 1:n2
            cd = results.CritDuration(i, j);
            sig = squeeze(results.PTanova(i, j, :, 1) > settings.Threshold);
            rsig(i, j, :) = zeros(size(sig));
            isOn = false;
            for tm = 1:numel(sig) 
                if sig(tm) == false
                    if isOn == false
                        tStart = tm;
                    end
                    isOn = true;
                else
                    if isOn == true && (tm - tStart - 1) >= cd
                        rsig(i, j, tStart:(tm - 1)) = 1;
                    end
                    isOn = false;
                end
            end
            if isOn == true && (tm - tStart) >= cd
                rsig(i, j, tStart:tm) = 1;
            end
        end
    end
end
