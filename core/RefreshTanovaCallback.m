function RefreshTanovaCallback(obj, varargin)
    pos = get(obj, 'CurrentPoint');

    fh = gcf;
    p0 = get(obj, 'Parent');
    % callback tag
    plotData = get(p0, 'UserData');
    tanh = findobj(obj, 'Tag','TanovaP');
    x = get(tanh, 'XData');
    if isempty(x)
        x = 1;
    end
    delta = abs(x - pos(1, 1)); 
    [~, idx] = min(delta);
    
    if isfield(plotData.dataXY, 'AutoMin')
        [~, idx] = min(get(tanh, 'YData'));
    end
    if isempty(x)
        x = 1;
    end
    ch = findobj(fh, 'Tag', 'Cursor');
    for i = 1:numel(ch)
        set(ch(i), 'XData', [x(idx) x(idx)]);
    end
    plotData.callback(plotData, idx);
end
