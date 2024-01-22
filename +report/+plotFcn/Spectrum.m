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

    userPath   = reportInfo.General.UserPath;
    
    % Criação da figura e dos eixos
    f = FigureCreation(reportInfo);

    % Layout...
    t = tiledlayout(f, 3, 1, "Padding", "tight", "TileSpacing", "tight");
    
    axes1 = plotFcn.axesDraw.AxesCreation([], 'Cartesian', t);
    axes1.Layout.Tile = 1;

    axes2 = plotFcn.axesDraw.AxesCreation([], 'Cartesian', t);
    axes2.Layout.Tile = 2;

    axes3 = plotFcn.axesDraw.AxesCreation([], 'Cartesian', t);
    axes3.Layout.Tile = 3;
    
    reportInfo.General.Parameters.ROI.yPosition = 4;
    reportInfo.General.Parameters.ROI.TextFontSize = 10;

    plotFcn.axesDraw.execute('Spectrum',        axes1, SpecInfo(idx1), reportInfo.General.Parameters, 'ReportGenerator')
    plotFcn.axesDraw.execute('OccupancyPerBin', axes2, SpecInfo(idx1), reportInfo.General.Parameters, 'ReportGenerator')
    plotFcn.axesDraw.execute('Waterfall',       axes3, SpecInfo(idx1), reportInfo.General.Parameters, 'ReportGenerator')

    axes1.XTickLabel = {};
    axes2.XTickLabel = {};
    xlabel(axes1, '')
    xlabel(axes2, '')

    % Desabilitando interatividade do plot...
    hAxes = findobj(f, 'Type', 'axes');
    arrayfun(@(x) disableDefaultInteractivity(x), hAxes)

    % Exportando a figura como imagem PNG ou JPEG
    FullFileName = '';
    if ismember(reportInfo.General.Mode, {'Report', 'auxApp.winTemplate'})
        defaultFilename = class.Constants.DefaultFileName(userPath, sprintf('Image_ID%d', SpecInfo(idx1).RelatedFiles.ID(1)), -1);
        FullFileName    = sprintf('%s.%s', defaultFilename, reportInfo.General.Image.Format);
        if ~strcmp(reportInfo.General.Version, 'Definitiva')
            FullFileName = replace(FullFileName, 'Image', '~Image');
        end
        
        exportgraphics(f, FullFileName, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
    end
    
    % Habilitando interatividade do plot...
    arrayfun(@(x) enableDefaultInteractivity(x), hAxes)
end


%-------------------------------------------------------------------------%
function f = FigureCreation(reportInfo)
    mainMonitor     = get(0, 'MonitorPositions');
    [~, indMonitor] = max(mainMonitor(:,3));
    mainMonitor     = mainMonitor(indMonitor,:);

    xPixels = class.Constants.windowSize(1);
    yPixels = class.Constants.windowSize(2);

    f = uifigure('Visible', reportInfo.General.Image.Visibility,                                           ...
                 'Position', [mainMonitor(1) + round((mainMonitor(3)-xPixels)/2),                          ...
                              mainMonitor(2) + round((mainMonitor(4)+48-yPixels-30)/2), xPixels, yPixels], ...
                 'Icon', fullfile(reportInfo.General.RootFolder, 'Icons', 'LR_icon.png'), 'Tag', 'ReportGenerator');
end