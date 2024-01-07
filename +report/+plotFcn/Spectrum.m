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
    
    % Figura
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