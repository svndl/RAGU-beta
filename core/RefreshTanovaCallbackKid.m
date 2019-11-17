function RefreshTanovaCallbackKid(obj, event)
    ph = get(obj, 'Parent');
    if (ph ~= 0)
        RefreshTanovaCallback(ph);
    end 
end

