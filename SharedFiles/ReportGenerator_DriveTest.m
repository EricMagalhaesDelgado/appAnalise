function filename = ReportGenerator_DriveTest(idx, reportInfo, Layout)

    % REPORT GENERATOR: DRIVE-TEST PLOTS
    % Version: February 3th 2023

    arguments
        idx        double
        reportInfo struct
        Layout     double = 1
    end
    
    global specData
    global ID_img

    RootFolder = reportInfo.General.RootFolder;
    UserPath   = reportInfo.General.UserPath;


    % Figure
    mainMonitor = get(0, 'MonitorPositions');
    
    [~, indMonitor] = max(mainMonitor(:,3));
    mainMonitor     = mainMonitor(indMonitor,:);
    fig = figure('Visible', reportInfo.General.Image.Visibility,                                       ...
                 'Position', [(mainMonitor(1) + round((mainMonitor(3)-650)/2) + 32*ID_img),            ...
                              (mainMonitor(2) + round((mainMonitor(4)-160)/2) - 32*ID_img), 480, 480], ...
                 'Name', sprintf('ThreadID %.0f: %.3f - %.3f MHz (%s)', specData(idx).ThreadID,        ...
                                                                        specData(idx).MetaData.FreqStart/1e+6, ...
                                                                        specData(idx).MetaData.FreqStop/1e+6,  ...
                                                                        specData(idx).Node),                   ...
                 'NumberTitle', 'off', 'Tag', 'ReportGenerator', 'CloseRequestFcn', "set(gcf, 'Visible', 'off')");
    delete(findall(fig, '-not', 'Type', 'Figure'));
        
    jFrame = get(fig, 'javaframe');
    jIcon  = javax.swing.ImageIcon(fullfile(RootFolder, 'Icons', 'LR_icon.png'));
    jFrame.setFigureIcon(jIcon);


    % Axes
    switch Layout
        case 1
            Fcn_Route(fig, specData, idx)

        otherwise
            % Pendente
    end


    % Export figure as PNG or JPEG file
    filename = '';
    if reportInfo.General.Mode == "Report"
        if reportInfo.General.Version == "Definitiva"
            filename = sprintf('Image_%s_ThreadID%.0f.%s', datestr(datetime('now'), 'yyyy.mm.dd_THH.MM.SS'), specData(idx).ThreadID, reportInfo.General.Image.Format);
        else
            filename = sprintf('~Image_%s_ThreadID%.0f.%s', datestr(datetime('now'), 'yyyy.mm.dd_THH.MM.SS'), specData(idx).ThreadID, reportInfo.General.Image.Format);
        end
        filename = fullfile(UserPath, filename);
        
        exportgraphics(fig, filename, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
        drawnow nocallbacks
    end

end


function Fcn_Route(fig, specData, idx)

    Lat  = [];
    Long = [];
    for ii = 1:numel(specData(idx).RelatedGPS)
        Lat  = [Lat;  specData(idx).RelatedGPS{ii}.Matrix(:,1)];
        Long = [Long; specData(idx).RelatedGPS{ii}.Matrix(:,2)];
    end

    axes1 = geoaxes(fig, 'FontSize', 6, 'Units', 'pixels', 'Basemap', 'darkwater', 'FontName', 'Calibri', 'FontSize', 10);

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