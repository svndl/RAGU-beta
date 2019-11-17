function ragu_displayMDS  
maps = reshape(Mean2Show,size(Mean2Show,1)*size(Mean2Show,2),size(Mean2Show,3));
    maps = maps - repmat(mean(maps),size(maps,1),1);
% PCA based
    cov = maps' * maps;

    opt.disp = 0;
    [v,de] = eigs(cov,2,'LM',opt);
%    d.pro = maps*v;
    TwoDimsToMap = size(maps,1) > 2;
    
% Matlab MDS    
    ops = statset('Display','off','TolFun',0.01);
%    squareform(pdist(maps,'euclidean'))

    if TwoDimsToMap == true
        d.pro = mdscale(pdist(maps,'euclidean'),2,'Options',ops,'Criterion','strain');
    else
        d.pro = mdscale(pdist(maps,'euclidean'),1,'Options',ops,'Criterion','strain');
        d.pro(:,2) = 0;
    end
    
    v = NormDimL2(maps'*d.pro,1);

    d.pro = reshape(d.pro,size(Mean2Show,1),size(Mean2Show,2),2);
    d.timePT = x(idx);
    d.in1 = in1;

    set(get(obj,'Parent'),'UserData',d);

    sh = ShowMDS(d,false);

    spos = get(sh,'Position');

    col = lines();
    psymb = '.ox+*sdv^<>ph';
    subplot('Position',[0.88 0.15 0.1 0.35]);
    axis off
    cla
