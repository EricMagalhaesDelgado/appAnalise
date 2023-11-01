function filename = ReportGenerator_Plot(SpecInfo, idx, reportInfo, Layout)

    % Função auxiliar à "ReportGenerator" e "PreviewGenerator", possibilitando 
    % geração do plot para cada uma das faixas, o qual é salvo como imagem no 
    % formato "PNG" (para posterior inclusão no relatório no formato HTML),
    % caso aplicável.
    % 
    % Versão: 30/10/2023

    % !! TODO !!
    % MIGRAR O PLOT PRA PRÓPRIA TELA DE CONTROLE DO APPANALISE, MANTENDO 
    % EVENTUAIS PERSONALIZAÇÕES DE DATATIPS E TAL.
    % !! TODO !!

    arguments
        SpecInfo
        idx
        reportInfo
        Layout = 1
    end

    global ID_img

    RootFolder = reportInfo.General.RootFolder;
    UserPath   = reportInfo.General.UserPath;

    xArray = round(linspace(SpecInfo(idx).MetaData.FreqStart / 1e+6, ...
                            SpecInfo(idx).MetaData.FreqStop  / 1e+6, ...
                            SpecInfo(idx).MetaData.DataPoints), 3);

    % Criação da figura antiga do Matlab - a "figure".
    mainMonitor = get(0, 'MonitorPositions');

    [~, indMonitor] = max(mainMonitor(:,3));
    mainMonitor     = mainMonitor(indMonitor,:);

    fig = figure('Visible', reportInfo.General.Image.Visibility,                                           ...
                 'Position', [(mainMonitor(1) + round((mainMonitor(3)-650)/2) + 32*ID_img),                ...
                              (mainMonitor(2) + round((mainMonitor(4)-800)/2) - 32*ID_img), 650, 800],     ...
                 'Name', sprintf('ID %.0f: %.3f - %.3f MHz (%s)', SpecInfo(idx).RelatedFiles.ID(1),        ...
                                                                  SpecInfo(idx).MetaData.FreqStart / 1e+6, ...
                                                                  SpecInfo(idx).MetaData.FreqStop  / 1e+6, ...
                                                                  SpecInfo(idx).Receiver),                 ...
                 'NumberTitle', 'off', 'Tag', 'ReportGenerator', 'CloseRequestFcn', "set(gcf, 'Visible', 'off')");

    delete(findall(fig, '-not', 'Type', 'Figure'));
    jFrame = get(fig, 'javaframe');
    jIcon  = javax.swing.ImageIcon(fullfile(RootFolder, 'Icons', 'LR_icon.png'));
    jFrame.setFigureIcon(jIcon);


    % Layout...
    switch Layout
        case 1
            axes1 = axes(fig, 'Unit', 'normalized', 'InnerPosition', [0.13 0.62 0.78 0.36], 'Color', [0,0,0],       'ToolBar', []);
            axes2 = axes(fig, 'Unit', 'normalized', 'InnerPosition', [0.13 0.42 0.78 0.18], 'Color', [0,0,0],       'ToolBar', []);
            axes3 = axes(fig, 'Unit', 'normalized', 'InnerPosition', [0.13 0.05 0.78 0.35], 'Color', [.94,.94,.94], 'ToolBar', []);
            Fcn_axes1(axes1, SpecInfo, idx, xArray)
            Fcn_axes2(axes2, SpecInfo, idx, xArray)
            Fcn_axes3(axes3, SpecInfo, idx, xArray)
            linkaxes([axes1, axes2, axes3], 'x')
    
            enableDefaultInteractivity(axes1)
            enableDefaultInteractivity(axes2)
            enableDefaultInteractivity(axes3)
            
            axesChildren = [axes1.Children; axes2.Children; axes3.Children];
            
        case 2
            axes1 = axes(fig, 'Unit', 'normalized', 'InnerPosition', [0.13 0.62 0.78 0.36], 'Color', [0,0,0],       'ToolBar', []);
            axes3 = axes(fig, 'Unit', 'normalized', 'InnerPosition', [0.13 0.05 0.78 0.55], 'Color', [.94,.94,.94], 'ToolBar', []);
            Fcn_axes1(axes1, SpecInfo, idx, xArray)
            Fcn_axes3(axes3, SpecInfo, idx, xArray)
            linkaxes([axes1, axes3], 'x')
    
            enableDefaultInteractivity(axes1)
            enableDefaultInteractivity(axes3)
            
            axesChildren = [axes1.Children; axes3.Children];            
    end


    % Ajustes finais dos gráficos e linhas.
    for ii = 1:numel(axesChildren)
        if ismember(axesChildren(ii).Type, {'line', 'area', 'surface'}) 
            if ~strcmp(axesChildren(ii).Tag, 'OCC')
                plotFcn.DataTipModel(axesChildren(ii), SpecInfo(idx).MetaData.LevelUnit)
            else
                plotFcn.DataTipModel(axesChildren(ii), '%%')
            end
        end
    end


    % Export figure as PNG or JPEG file
    filename = '';
    if reportInfo.General.Mode == "Report"
        if reportInfo.General.Version == "Definitiva"
            filename = sprintf( 'Image_%s_ID%.0f.%s', datestr(datetime('now'), 'yyyy.mm.dd_THH.MM.SS'), SpecInfo(idx).RelatedFiles.ID(1), reportInfo.General.Image.Format);
        else
            filename = sprintf('~Image_%s_ID%.0f.%s', datestr(datetime('now'), 'yyyy.mm.dd_THH.MM.SS'), SpecInfo(idx).RelatedFiles.ID(1), reportInfo.General.Image.Format);
        end
        filename = fullfile(UserPath, filename);
        
        exportgraphics(fig, filename, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
        drawnow nocallbacks
    end
end


%-------------------------------------------------------------------------%
function Fcn_axes1(axes1, SpecInfo, idx, xArray)

    color1   = [1 .07 .65];   % MaxHold
    color2   = "#005dd1";   % MinHold
    color3   = [1 1 .07];     % Median or mean
    roiColor = [.40,.73,.88]; %[.00 .45 .74]; % Band roi region

    downYLim = min(SpecInfo(idx).Data{3}(:,1));
    upYLim   = max(SpecInfo(idx).Data{3}(:,end));

    occIndex = SpecInfo(idx).UserData.occMethod.CacheIndex;
    occTHR   = SpecInfo(idx).UserData.occCache(occIndex).THR;
    if upYLim < max(occTHR)
        upYLim = max(occTHR);
    end


    % Parameters related to xLim and yLim (Spectrum and Waterfall plots)
    if (xArray(end)-xArray(1) >= 5)
        auxXLabel1 =   fix(linspace(xArray(1), xArray(end), 5));
        auxXLabel2 = round(linspace(xArray(1), xArray(end), 5), 3);
    else
        auxXLabel1 = [xArray(1), xArray(end)];
        auxXLabel2 = [xArray(1), xArray(end)];
    end

    hold(axes1, 'on')
    set(axes1, 'FontName', 'Calibri', 'FontSize', 8,                                                                ...
               'XGrid', 'on', 'XMinorGrid', 'on', 'YGrid', 'on', 'YMinorGrid', 'on', 'Box', 'on',                   ...
               'GridColor', [.94,.94,.94], 'MinorGridColor', [.94,.94,.94], 'GridAlpha', .25, 'MinorGridAlpha', .2, ...
               'XLim' , [xArray(1), xArray(end)],    'XTick', auxXLabel1,                    'XTickLabel', {},                ...
               'YLim', [downYLim, upYLim], 'YTick', linspace(downYLim, upYLim, 5), 'YTickLabel', fix(linspace(downYLim, upYLim, 5)));
    ylabel(axes1, ['Nível (' SpecInfo(idx).MetaData.LevelUnit ')'], 'FontSize', 8, 'FontWeight', 'bold')
    

    % Emissions ROI and label
    Peaks = SpecInfo(idx).UserData.Emissions;
    if ~isempty(Peaks)
        for ii = 1:height(Peaks)
            drawrectangle(axes1, 'Position', [Peaks.Frequency(ii)-Peaks.BW(ii)/2000, ...
                                              axes1.YLim(1)+1,                       ...
                                              Peaks.BW(ii)/1000,                     ...
                                              diff(axes1.YLim)-2],                   ...
                                 'Color', roiColor, ...
                                 'MarkerSize', 5, ...
                                 'Deletable', 0, ...
                                 'LineWidth', 1, ...
                                 'InteractionsAllowed', 'none');
        end
    end
        

    % MinHold, MaxHold and Median/Mean
    area(axes1, xArray, SpecInfo(idx).Data{3}(:,1),   'EdgeColor', color2, 'FaceColor', color2, 'BaseValue', axes1.YLim(1));
    plot(axes1, xArray, SpecInfo(idx).Data{3}(:,end), 'Color', color1, 'LineWidth', .5);
    plot(axes1, xArray, SpecInfo(idx).Data{3}(:,2),   'Color', color3, 'LineWidth', 1,             ...
                                                      'Marker', '.', 'MarkerIndices', Peaks.Index, ...
                                                      'MarkerFaceColor', roiColor, 'MarkerEdgeColor', roiColor, 'MarkerSize', 14);


    % Threshold line
    switch SpecInfo(idx).UserData.reportOCC.Method
        case {'Linear fixo (COLETA)', 'Linear fixo'}
            plot(axes1, [xArray(1), xArray(end)], [occTHR, occTHR], '-', 'Color', 'red', 'LineWidth', .5)

        case 'Linear adaptativo'
            [minTHR, maxTHR] = bounds(occTHR);

            plot(axes1, [xArray(1), xArray(end)], [minTHR, minTHR], Color='red', LineStyle='-.', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='red', MarkerEdgeColor='black', Tag='occTHR');
            plot(axes1, [xArray(1), xArray(end)], [maxTHR, maxTHR], Color='red', LineStyle='-.', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='red', MarkerEdgeColor='black', Tag='occTHR');

        case 'Envoltória do ruído'
            plot(axes1, xArray, occTHR, Color='red', LineStyle='-', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=[1, numel(xArray)], MarkerFaceColor='r', MarkerEdgeColor='black', Tag='occTHR');
    end
    text(axes1, xArray(end), double(occTHR(end)), 'thrOCC', 'FontName', 'Calibri', 'FontSize', 7, 'FontWeight', 'bold', 'Color', 'red');
    

    if ~isempty(Peaks)
        text(axes1, Peaks.Frequency, double(SpecInfo(idx).Data{3}(Peaks.Index,2)), string((1:height(Peaks))'), ...
            'FontName', 'Calibri', 'FontSize', 7, 'Color', roiColor, 'FontWeight', 'bold', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
    end

    hold(axes1, 'off')
    drawnow nocallbacks
end


%-------------------------------------------------------------------------%
function Fcn_axes2(axes2, SpecInfo, idx, xArray)

    if (xArray(end)-xArray(1) >= 5)
        auxXLabel1 =   fix(linspace(xArray(1), xArray(end), 5));
        auxXLabel2 = round(linspace(xArray(1), xArray(end), 5), 3);
    else
        auxXLabel1 = [xArray(1), xArray(end)];
        auxXLabel2 = [xArray(1), xArray(end)];
    end 

    color1   = [1 .07 .65];   % MaxHold
    color3   = [1 1 .07];     % Median or mean

    occIndex = SpecInfo(idx).UserData.occMethod.CacheIndex;
    zeroIndex1 = SpecInfo(idx).UserData.occCache(occIndex).Data{3}(:,2) == 0;
    zeroIndex2 = SpecInfo(idx).UserData.occCache(occIndex).Data{3}(:,3) == 0;

    SpecInfo(idx).UserData.occCache(occIndex).Data{3}(zeroIndex1, 2) = 0.1;
    SpecInfo(idx).UserData.occCache(occIndex).Data{3}(zeroIndex2, 3) = 0.1;
    
    
    hold(axes2, 'on')
    plot(axes2, xArray, SpecInfo(idx).UserData.occCache(occIndex).Data{3}(:,3), 'Color', color1, 'LineWidth', .5, 'Tag', 'OCC');
    plot(axes2, xArray, SpecInfo(idx).UserData.occCache(occIndex).Data{3}(:,2), 'Color', color3, 'LineWidth', 1, 'Tag', 'OCC');
    
    set(axes2, 'YScale', 'log', 'FontName', 'Calibri', 'FontSize', 8,                                               ...
               'XGrid', 'on', 'XMinorGrid', 'on', 'YGrid', 'on', 'YMinorGrid', 'on', 'Box', 'on',                   ...
               'GridColor', [.94,.94,.94], 'MinorGridColor', [.94,.94,.94], 'GridAlpha', .25, 'MinorGridAlpha', .2, ...
               'XLim',  [xArray(1), xArray(end)], 'XTick', auxXLabel1, 'XTickLabel', {}, 'YLim',  [.1 100], 'YTick', [.1 1 10 100], 'YTickLabel', {'0', '1', '10', '100'})
    ylabel(axes2, 'Ocupação (%)', 'FontSize', 8, 'FontWeight', 'bold')

    hold(axes2, 'off')
    drawnow nocallbacks
end


%-------------------------------------------------------------------------%
function Fcn_axes3(axes3, SpecInfo, idx, xArray)

    if (xArray(end)-xArray(1) >= 5)
        auxXLabel1 =   fix(linspace(xArray(1), xArray(end), 5));
        auxXLabel2 = round(linspace(xArray(1), xArray(end), 5), 3);
    else
        auxXLabel1 = [xArray(1), xArray(end)];
        auxXLabel2 = [xArray(1), xArray(end)];
    end 


    % DECIMAÇÃO: 
    Points = SpecInfo(idx).MetaData.DataPoints .* numel(SpecInfo(idx).Data{1});
    if Points > 1474560; Decimate = ceil(Points/1474560);
    else;                Decimate = 1;
    end

    t = SpecInfo(idx).Data{1}(1:Decimate:end);
    if t(1) == t(end); t(end) = t(1)+seconds(1);
    end

    [X, Y] = meshgrid(xArray, t);
    colormap(axes3, 'winter');
    axes3.Colormap(1,:) = [0,0,0];
    hold(axes3, 'on')
    axes3.CLimMode = 'auto';
    mesh(axes3, X, Y, SpecInfo(idx).Data{2}(:,1:Decimate:end)')
    view(axes3, 0,90);

    axes3.CLim(2)  = round(axes3.CLim(2));
    axes3.CLim(1)  = round(axes3.CLim(2) - diff(axes3.CLim)/2);

    Li = axes3.CLim(1);
    Ls = axes3.CLim(2);

    colorbar(axes3, 'Location', 'manual', 'Units', 'normalized', 'Position', [0.9215, 0.05, 0.025, 0.08], ...
                    'AxisLocation', 'out', 'FontSize', 8, 'Limits', [Li, Ls], 'Ticks', [Li, Ls], 'TickLabels', {num2str(Li), num2str(Ls)});
    
    set(axes3, 'FontName', 'Calibri', 'FontSize', 8,                                  ...
               'XLim' , [xArray(1) xArray(end)], 'XTick', auxXLabel1, 'XTickLabel', auxXLabel2, ...
               'YLim' , [t(1) t(end)], 'YTick', linspace(t(1), t(end), 3),            ...
               'YTickLabel', datestr(linspace(t(1), SpecInfo(idx).Data{1}(end), 3), 'dd/mm/yyyy HH:MM'))
    xlabel(axes3, 'Frequência (MHz)', 'FontSize', 8, 'FontWeight','bold')

    hold(axes3, 'off')
    drawnow nocallbacks
end