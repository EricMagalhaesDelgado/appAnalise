function FullFileName = DriveTest(SpecInfo, idx, reportInfo)

    % REPORT GENERATOR: DRIVE-TEST PLOTS
    % Version: February 3th 2023

    arguments
        SpecInfo
        idx       double
        reportInfo struct
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
                 'Name', sprintf('ID %.0f: %.3f - %.3f MHz (%s)', SpecInfo(idx).RelatedFiles.ID(1),        ...
                                                                  SpecInfo(idx).MetaData.FreqStart / 1e+6, ...
                                                                  SpecInfo(idx).MetaData.FreqStop  / 1e+6, ...
                                                                  SpecInfo(idx).Receiver),                 ...
                 'Icon', fullfile(RootFolder, 'Icons', 'LR_icon.png'), 'Tag', 'ReportGenerator');

    % Layout...
    t = tiledlayout(f, 1, 1, "Padding", "tight", "TileSpacing", "tight");
    
    axes1 = plotFcn.axesDraw.AxesCreation([], 'Geographic', t);
    drawnow nocallbacks

    geolimits(axes1, 'auto')
    plotFcn.axesDraw.geographicAxes_type1(axes1, reportInfo.General.Parameters.DriveTest, 'ReportGenerator')

    % Desabilitando interatividade do plot...
    disableDefaultInteractivity(axes1)

    % Export figure as PNG or JPEG file
    FullFileName = '';
    if strcmp(reportInfo.General.Mode, 'Report')
        defaultFilename = class.Constants.DefaultFileName(userPath, sprintf('Image_ID%d', SpecInfo(idx).RelatedFiles.ID(1)), -1);
        FullFileName    = sprintf('%s.%s', defaultFilename, reportInfo.General.Image.Format);
        if ~strcmp(reportInfo.General.Version, 'Definitiva')
            FullFileName = replace(FullFileName, 'Image', '~Image');
        end
        
        exportgraphics(f, FullFileName, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
    end

    % Habilitando interatividade do plot...
    enableDefaultInteractivity(axes1)
end