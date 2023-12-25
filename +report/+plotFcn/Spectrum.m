function FullFileName = Spectrum(SpecInfo, idx1, reportInfo, Layout)

    % Função auxiliar à "ReportGenerator", possibilitando geração do plot 
    % para cada uma das faixas, o qual é salvo como imagem no formato "PNG" 
    % (para posterior inclusão no relatório no formato HTML).
    % 
    % Versão: 30/10/2023

    % !! TODO !!
    % MIGRAR O PLOT PRA PRÓPRIA TELA DE CONTROLE DO APPANALISE, MANTENDO 
    % EVENTUAIS PERSONALIZAÇÕES DE DATATIPS E TAL.
    % !! TODO !!

    arguments
        SpecInfo
        idx1
        reportInfo
        Layout = 1
    end

    RootFolder = reportInfo.General.RootFolder;
    userPath   = reportInfo.General.UserPath;
    idx2       = reportInfo.General.Parameters.Plot.emissionIndex;

    xArray = round(linspace(SpecInfo(idx1).MetaData.FreqStart / 1e+6, ...
                            SpecInfo(idx1).MetaData.FreqStop  / 1e+6, ...
                            SpecInfo(idx1).MetaData.DataPoints), 3);

    
    % Criação da figura antiga do Matlab - a "figure".
    mainMonitor = get(0, 'MonitorPositions');

    [~, indMonitor] = max(mainMonitor(:,3));
    mainMonitor     = mainMonitor(indMonitor,:);

    f = uifigure('Visible', reportInfo.General.Image.Visibility,                                            ...
                 'WindowState','maximized',                                                                 ...
                 'Position', [mainMonitor(1) + round((mainMonitor(3)-1244)/2),                              ...
                              mainMonitor(2) + round((mainMonitor(4)+48-660-30)/2), 1244, 660],             ...
                 'Name', sprintf('ID %.0f: %.3f - %.3f MHz (%s)', SpecInfo(idx1).RelatedFiles.ID(1),        ...
                                                                  SpecInfo(idx1).MetaData.FreqStart / 1e+6, ...
                                                                  SpecInfo(idx1).MetaData.FreqStop  / 1e+6, ...
                                                                  SpecInfo(idx1).Receiver),                 ...
                 'Icon', fullfile(RootFolder, 'Icons', 'LR_icon.png'), 'Tag', 'ReportGenerator');

    % Layout...
    switch Layout
        case 1
            t = tiledlayout(f, 3, 1, "Padding", "tight", "TileSpacing", "tight");
            
            axes1 = plotFcn.axesDraw.AxesCreation([], 'Cartesian', t);
            axes1.Layout.Tile = 1;

            axes2 = plotFcn.axesDraw.AxesCreation([], 'Cartesian', t);
            axes2.Layout.Tile = 2;

            axes3 = plotFcn.axesDraw.AxesCreation([], 'Cartesian', t);
            axes3.Layout.Tile = 3;
            
            reportInfo.General.Parameters.ROI.yPosition = 4;
            reportInfo.General.Parameters.ROI.TextFontSize = 10;
            plotFcn.axesDraw.execute('Spectrum', axes1, SpecInfo(idx1), reportInfo.General.Parameters)
            axes1.XTickLabel = {};
            xlabel(axes1, '')

            Fcn_axes2(axes2, SpecInfo, idx1, xArray)

            % Fcn_axes3(axes3, SpecInfo, idx1, xArray)
            plotFcn.axesDraw.execute('Waterfall', axes3, SpecInfo(idx1), reportInfo.General.Parameters)

            linkaxes([axes1, axes2, axes3], 'x')
            axesChildren = [axes1.Children; axes2.Children; axes3.Children];
            
        case 2
            t = tiledlayout(f, 3, 1, "Padding", "tight", "TileSpacing", "tight");

            axes1 = plotFcn.axesDraw.AxesCreation([], 'Cartesian', t);
            axes1.Layout.Tile = 1;

            axes3 = plotFcn.axesDraw.AxesCreation([], 'Cartesian', t);
            axes3.Layout.Tile = 1;
            axes3.Layout.TileSpan = [2,1];

            reportInfo.General.Parameters.ROI.yPosition = 4;
            plotFcn.axesDraw.execute('Spectrum', axes1, SpecInfo(idx1), reportInfo.General.Parameters)
            axes1.XTickLabel = {};
            xlabel(axes1, '')
            
            plotFcn.axesDraw.execute('Waterfall', axes3, SpecInfo(idx1), reportInfo.General.Parameters)
            
            linkaxes([axes1, axes3], 'x')
            axesChildren = [axes1.Children; axes3.Children];            
    end
    hAxes = findobj(f, 'Type', 'axes');
    arrayfun(@(x) disableDefaultInteractivity(x), hAxes)


    % Export figure as PNG or JPEG file
    FullFileName = '';
    if ismember(reportInfo.General.Mode, {'Report', 'auxApp.winTemplate'})
        defaultFilename = class.Constants.DefaultFileName(userPath, sprintf('Image_ID%d', SpecInfo(idx1).RelatedFiles.ID(1)), -1);
        FullFileName    = sprintf('%s.%s', defaultFilename, reportInfo.General.Image.Format);
        if ~strcmp(reportInfo.General.Version, 'Definitiva')
            FullFileName = replace(FullFileName, 'Image', '~Image');
        end
        
        exportgraphics(f, FullFileName, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
        drawnow nocallbacks
    end
    

    arrayfun(@(x) enableDefaultInteractivity(x), hAxes)
end


%-------------------------------------------------------------------------%
function Fcn_axes2(axes2, SpecInfo, idx, xArray)

    if (xArray(end)-xArray(1) >= 5)
        auxXLabel1 =   fix(linspace(xArray(1), xArray(end), 5));
    else
        auxXLabel1 = [xArray(1), xArray(end)];
    end 

    color1   = [1 .07 .65];   % MaxHold
    color3   = [1 1 .07];     % Median or mean

    occIndex = SpecInfo(idx).UserData.occMethod.CacheIndex;
    zeroIndex1 = SpecInfo(idx).UserData.occCache(occIndex).Data{3}(:,2) == 0;
    zeroIndex2 = SpecInfo(idx).UserData.occCache(occIndex).Data{3}(:,3) == 0;

    SpecInfo(idx).UserData.occCache(occIndex).Data{3}(zeroIndex1, 2) = 0.1;
    SpecInfo(idx).UserData.occCache(occIndex).Data{3}(zeroIndex2, 3) = 0.1;
    
    
    plot(axes2, xArray, SpecInfo(idx).UserData.occCache(occIndex).Data{3}(:,3), 'Color', color1, 'LineWidth', .5, 'Tag', 'OCC');
    plot(axes2, xArray, SpecInfo(idx).UserData.occCache(occIndex).Data{3}(:,2), 'Color', color3, 'LineWidth', 1, 'Tag', 'OCC');
    
    set(axes2, 'YScale', 'log', 'XLim',  [xArray(1), xArray(end)], 'XTick', auxXLabel1, 'XTickLabel', {}, 'YLim',  [.1 100], 'YTick', [.1 1 10 100], 'YTickLabel', {'0', '1', '10', '100'})
    ylabel(axes2, 'Ocupação (%)')
    drawnow nocallbacks
end