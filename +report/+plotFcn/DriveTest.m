function FullFileName = DriveTest(SpecInfo, idx, reportInfo, Layout)

    % REPORT GENERATOR: DRIVE-TEST PLOTS
    % Version: February 3th 2023

    arguments
        SpecInfo
        idx        double
        reportInfo struct
        Layout     double = 1
    end
    
    global ID_img

    RootFolder = reportInfo.General.RootFolder;
    userPath   = reportInfo.General.UserPath;

    % Figure
    mainMonitor = get(0, 'MonitorPositions');
    
    [~, indMonitor] = max(mainMonitor(:,3));
    mainMonitor     = mainMonitor(indMonitor,:);
    fig = figure('Visible', reportInfo.General.Image.Visibility,                                           ...
                 'Position', [(mainMonitor(1) + round((mainMonitor(3)-650)/2) + 32*ID_img),                ...
                              (mainMonitor(2) + round((mainMonitor(4)-160)/2) - 32*ID_img), 480, 480],     ...
                 'Name', sprintf('ID %.0f: %.3f - %.3f MHz (%s)', SpecInfo(idx).RelatedFiles.ID(1),        ...
                                                                  SpecInfo(idx).MetaData.FreqStart / 1e+6, ...
                                                                  SpecInfo(idx).MetaData.FreqStop  / 1e+6, ...
                                                                  SpecInfo(idx).Receiver),                 ...
                 'NumberTitle', 'off', 'Tag', 'ReportGenerator', 'CloseRequestFcn', "set(gcf, 'Visible', 'off')");
    delete(findall(fig, '-not', 'Type', 'Figure'));
        
    jFrame = get(fig, 'javaframe');
    jIcon  = javax.swing.ImageIcon(fullfile(RootFolder, 'Icons', 'LR_icon.png'));
    jFrame.setFigureIcon(jIcon);

    % Axes
    switch Layout
        case 1
            Fcn_Route(fig, SpecInfo, idx)
        otherwise
            % Pendente
    end

    % Export figure as PNG or JPEG file
    FullFileName = '';
    if strcmp(reportInfo.General.Mode, 'Report')
        defaultFilename = class.Constants.DefaultFileName(userPath, sprintf('Image_ID%d', SpecInfo(idx).RelatedFiles.ID(1)), -1);
        FullFileName    = sprintf('%s.%s', defaultFilename, reportInfo.General.Image.Format);
        if ~strcmp(reportInfo.General.Version, 'Definitiva')
            FullFileName = replace(FullFileName, 'Image', '~Image');
        end
        
        exportgraphics(fig, FullFileName, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
        drawnow nocallbacks
    end
end


%-------------------------------------------------------------------------%
function Fcn_Route(fig, SpecInfo, idx)

    Lat  = [];
    Long = [];
    for ii = 1:height(SpecInfo(idx).RelatedFiles)
        Lat  = [Lat;  SpecInfo(idx).RelatedFiles.GPS{ii}.Matrix(:,1)];
        Long = [Long; SpecInfo(idx).RelatedFiles.GPS{ii}.Matrix(:,2)];
    end

    axes1 = geoaxes(fig, 'FontSize', 6, 'Units', 'pixels', 'Basemap', 'darkwater', 'FontName', 'Calibri', 'FontSize', 10, 'ToolBar', []);
    disableDefaultInteractivity(axes1)

    while true
        try
            axes1.LatitudeLabel.String  = '';
            axes1.LongitudeLabel.String = '';

            colormap(axes1, 'jet')
            hold(axes1, 'on')
            
            break
        catch
        end
    end

    try
        geobasemap(axes1, 'streets-light')
    catch
    end

    geoplot(axes1, Lat, Long, 'Color', [0.87,0.54,0.54], 'LineWidth', 5);
end