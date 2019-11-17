function plot_BetweenGroups(analyzedData)
    % nGroups x nConditions p-value plot 
    
    f = figure('Units','normalized','Position',[0.05 0.05 0.9 0.8]);
    
    time = analyzedData.DeltaX*(0:analyzedData.EndFrame - 1);
    axislabel = analyzedData.txtX;
    
    % process the data
    DataToUse = find(~isnan(analyzedData.Design(:, 1)));
    gfp = sqrt(mean(analyzedData.V(:, DataToUse, :, :).^2, 3));
    
    % between groups and conditions
    tanova = analyzedData.PTanova(end, end, :, 1);
    
%     h = bar(time,double(squeeze(pTanova(i,j,:,1) > Threshold(i,j)))); % significance
%     set(h,'BarWidth',1,'EdgeColor',bcol,'FaceColor',bcol);
%     hold on
%     h = bar(time,squeeze(rsig(i,j,:)));
%     set(h,'BarWidth',1,'EdgeColor',[0 1 0],'FaceColor',[0 1 0]);
%     tanh = plot(time,squeeze(pTanova(i,j,:,1)),'-k', 'LineWidth', 2);
%     set(tanh,'Tag','TanovaP');
%     title(t{2*j+i-2},'Interpreter','none','FontSize',28);
%     axis([axismin axismax 0 1]);
%     tc = (axismin + axismax) / 2;
%     lh = plot([tc tc], [0 1],'-r');
%     set(lh,'Tag','Cursor');
%     set(hp(i,j),'Tag','subplot','Userdata',t{2*j+i-2});
%     xlabel(d.txtX);
%     ylabel('p-Value');
    
    
    
    % cmeans: Covariance maps for each group
    % gmeans: Within effects across groups
    % means: Means within group and condition

    if out.ContBetween == false
        b = unique(out.IndFeature(~isnan(out.IndFeature)));
        d.GLabels = out.GroupLabels(b);
        nGroups = sum(~isnan(b));
        
        d.means    = zeros(nGroups,numel(DataToUse),size(out.V,3),size(out.V,4));
        d.meansGFP = zeros(nGroups,numel(DataToUse),1,size(out.V,4));
        
        if d.ContF1
            d.cmeans    = zeros(nGroups,2,size(out.V,3),size(out.V,4));
            d.cmeansGFP = zeros(nGroups,1,1            ,size(out.V,4));
            d.means    = zeros(nGroups,2,size(out.V,3),size(out.V,4));
            d.meansGFP = zeros(nGroups,numel(DataToUse),1,size(out.V,4));
        end
        
        % These are the within effects for each group
        for g = 1:nGroups
            if d.ContF1
                error('This needs to be fixed');
                [cm,cmgfp] = MakeCovMapForDisplay(out.V(out.IndFeature == b(g),DataToUse,:,:),out.Design(DataToUse,1),[]);
                
                d.cmeans(g,:,:,:)   = cm;
                d.cmeansGFP(g,:,:,:) = cmgfp;
            end
            d.means(g,:,:,:)    = mean(out.V(out.IndFeature == b(g),DataToUse,:,:),1);
            d.meansGFP(g,:,:,:) = mean(  gfp(out.IndFeature == b(g),:        ,:,:),1);
        end
        else
        % These are the within effects for each group
        if d.ContF1
            d.cmeans    = zeros(2,2,size(out.V,3),size(out.V,4));
            d.cmeansGFP = zeros(2,2,1,            size(out.V,4));
            
            [cm,cmgfp] = MakeCovMapForDisplay(out.V(~isnan(out.IndFeature),DataToUse,:,:),out.Design(DataToUse,1),out.IndFeature(~isnan(out.IndFeature)));
            
            d.cmeans    = cm;
            d.cmeansGFP = cmgfp;
        end
        %    d.means    = zeros(1,numel(DataToUse),size(out.V,3),size(out.V,4));
        %    d.meansGFP = zeros(1,numel(DataToUse),1            ,size(out.V,4));
        d.means    = zeros(2,numel(DataToUse),size(out.V,3),size(out.V,4));
        d.meansGFP = zeros(2,numel(DataToUse),1            ,size(out.V,4));

        for c = 1:numel(DataToUse)
            [cm,cmgfp] = MakeCovMapForDisplay(out.V(~isnan(out.IndFeature),DataToUse(c),:,:),[],out.IndFeature(~isnan(out.IndFeature)));
            d.means(:,c,:,:) = cm;
            d.meansGFP(:,c,:,:) = cmgfp;
        end
    end
end