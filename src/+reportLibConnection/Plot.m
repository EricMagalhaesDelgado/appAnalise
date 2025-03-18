classdef (Abstract) Plot

    methods (Static = true)
        %-----------------------------------------------------------------%
        function imgFileName = Controller(hContainer, specData, idxThread, tempBandObj, reportInfo, plotInfoPerAxes)
            % Limpa container.
            if ~isempty(hContainer.Children)
                delete(hContainer.Children)
            end

            % Cria eixos de acordo com estabelecido no JSON.
            tiledPos     = 1;
            tiledSpan    = [plotInfoPerAxes.Layout];

            axesParent   = tiledlayout(hContainer, sum(tiledSpan), 1, "Padding", "tight", "TileSpacing", "tight");           
            [axesType,   ...
             axesXLabel, ...
             axesYLabel, ...
             axesYScale] = plot.axes.axesTypeMapping({plotInfoPerAxes.Name}, tempBandObj);

            for ii = 1:numel(plotInfoPerAxes)
                xLabelFlag  = true;
                
                switch axesType{ii}
                    case 'Geographic'
                        hAxes = plot.axes.Creation(axesParent, 'Geographic');

                    case 'Cartesian'
                        hAxes = plot.axes.Creation(axesParent, 'Cartesian', {'XColor', [.15,.15,.15], 'YColor', [.15,.15,.15], 'XLim', tempBandObj.xLim, 'YLim', tempBandObj.yLevelLim});
                        if (numel(plotInfoPerAxes) > 1) && (ii < numel(plotInfoPerAxes)) && any(strcmp(axesType(ii+1:end), 'Cartesian'))
                            xLabelFlag = false;
                        end
                end
                hAxes.Layout.Tile     = tiledPos;
                hAxes.Layout.TileSpan = [tiledSpan(ii) 1];
            
                % PLOT
                plotNames = strsplit(plotInfoPerAxes(ii).Name, '+');
                for plotTag = plotNames
                    switch plotTag{1}
                        case {'MinHold', 'Average', 'MaxHold'}
                            plot.draw2D.OrdinaryLine(hAxes, tempBandObj, idxThread, plotTag{1});
    
                        case 'Persistance'
                            plot.Persistance('Creation', [], hAxes, tempBandObj, idxThread);
    
                        case 'Waterfall'
                            plot.Waterfall('Creation', hAxes, tempBandObj, idxThread);
                            plot.axes.Colorbar(hAxes, 'eastoutside', {'Color', 'black'})
    
                        case 'BandLimits'
                            plot.draw2D.horizontalSetOfLines(hAxes, tempBandObj, idxThread, 'BandLimits')
                        
                        case 'Channel'
                            chTable  = specData(idxThread).UserData.reportChannelTable;
                            if isempty(chTable)
                                chTable = ChannelTable2Plot(tempBandObj.callingApp.channelObj, specData(idxThread));
                                specData(idxThread).UserData.reportChannelTable = chTable;
                            end

                            if ~isempty(chTable)
                                plot.draw2D.horizontalSetOfLines(hAxes, tempBandObj, idxThread, 'Channel', chTable)
                            end

                        case 'Emission'
                            plot.draw2D.horizontalSetOfLines(hAxes, tempBandObj, idxThread, 'Emission')

                        % <PENDENTE MIGRAR PARA NOVAS FUNÇÕES>
                        case 'OccupancyThreshold'
                            reportLibConnection.Plot.ThresholdPlot(hAxes, tempBandObj, idxThread, reportInfo)

                        case 'OccupancyPerBin'
                            reportLibConnection.Plot.OccupancyPerBin(hAxes, tempBandObj, idxThread, reportInfo)
                            hAxes.YLim = [0,100];

                        case 'EmissionROI'
                            reportLibConnection.Plot.EmissionPlot(hAxes, specData(idxThread), yLim, Parameters)
    
                        case {'occMinHold', 'occAverage', 'occMaxHold'}
                            hAxes.YLim = [0,100];

                        case 'OccupancyPerChannel'
                            hAxes.YLim = [0,100];

                        case 'DriveTest'
                            reportLibConnection.Plot.DriveTestPlot(hAxes, tempBandObj, idxThread, reportInfo)

                        case 'DriveTestChannelPower'
                            idxEmission = reportInfo.General.Parameters.Plot.idxEmission;

                            if ~isempty(specData.UserData.Emissions.auxAppData(idxEmission).DriveTest)
                                specRawTable = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.specRawTable;
                                Color        = '#91ff00';
                                EdgeAlpha    = 1;
                                FaceAlpha    = .4;
                    
                                plot.DriveTest.ChannelPower(hAxes, tempBandObj, specRawTable, Color, EdgeAlpha, FaceAlpha)
                                plot.axes.StackingOrder.execute(hAxes, 'appAnalise:DRIVETEST')
                            end                            
    
                        case 'DriveTestRoute'
                            plot.DriveTest.Route(hAxes, tempBandObj, idxThread)
                    end
                end
                
                % POST-PLOT
                plot.axes.StackingOrder.execute(hAxes, tempBandObj.Context)
                switch axesType{ii}
                    case 'Geographic'
                        % ...

                    case 'Cartesian'
                        % xAxes
                        hAxes.XLim = tempBandObj.xLim;

                        if xLabelFlag
                            xlabel(hAxes, axesXLabel{ii})
                        else
                            hAxes.XTickLabel = {};
                            xlabel(hAxes, '')
                        end

                        % yAxes
                        if ~isempty(axesYScale{ii})
                            hAxes.YScale = axesYScale{ii};
                        end

                        if ~isempty(axesYLabel{ii})
                            ylabel(hAxes, axesYLabel{ii})
                        end
                end
                tiledPos = tiledPos+tiledSpan(ii);
            end

            % Espera renderizar e salva a imagem...
            defaultFilename = appUtil.DefaultFileName(reportInfo.General.UserPath, sprintf('Image_ID%d', specData(idxThread).RelatedFiles.ID(1)), -1);
            imgFileName     = sprintf('%s.%s', defaultFilename, reportInfo.General.Image.Format);
            if ~ismember(reportInfo.Model.Version, {'final', 'Definitiva'})
                imgFileName = replace(imgFileName, 'Image', '~Image');
            end
            
            exportgraphics(hContainer, imgFileName, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
            drawnow nocallbacks
            
            while true
                pause(1)
                if isfile(imgFileName)
                    break
                end
            end
        end

        %-----------------------------------------------------------------%
        function OccupancyPerBin(hAxes, bandObj, idx, reportInfo)
            defaultProperties = bandObj.callingApp.General_I;

            specData  = bandObj.callingApp.specData(idx);
            xArray    = bandObj.xArray;
            
            switch bandObj.Context
                case 'appAnalise:REPORT:CHANNEL'
                    idxChannel = reportInfo.General.Parameters.Plot.idxChannel;
                    
                    occTHR    = [specData.UserData.reportChannelAnalysis.("Threshold mínimo")(idxChannel), ...
                                 specData.UserData.reportChannelAnalysis.("Threshold máximo")(idxChannel)];
                    occOffset =  specData.UserData.reportChannelAnalysis.Offset(idxChannel);
                    xIndexLim = [specData.UserData.reportChannelAnalysis.("FCO per bin (%)"){idxChannel}.idx1, ...
                                 specData.UserData.reportChannelAnalysis.("FCO per bin (%)"){idxChannel}.idx2];
                    occData   =  specData.UserData.reportChannelAnalysis.("FCO per bin (%)"){idxChannel}.binFCO';

                    Occupancy  = defaultProperties.Plot.OccupancyPerBin;
                    plot(hAxes, xArray(xIndexLim(1):xIndexLim(2)), occData, 'Color',     Occupancy.Color,     ...
                                                                            'LineStyle', Occupancy.LineStyle, ...
                                                                            'LineWidth', Occupancy.LineWidth, ...
                                                                            'Tag', 'OccupancyPerBin');
                    ysecondarylabel(hAxes, sprintf('Threshold: [%.1f, %.1f] (Offset em relação ao piso de ruído: %d dB)', occTHR(1), occTHR(2), occOffset))

                otherwise
                    occMinHold = defaultProperties.Plot.occMinHold;
                    occAverage = defaultProperties.Plot.occAverage;
                    occMaxHold = defaultProperties.Plot.occMaxHold;

                    xIndexLim = bandObj.xIndexLimits;
                
                    reportLibConnection.Plot.OccupancyPerBinPlot(hAxes, specData(idx), xIndexLim, xArray, 'occMinHold', occMinHold)
                    reportLibConnection.Plot.OccupancyPerBinPlot(hAxes, specData(idx), xIndexLim, xArray, 'occAverage', occAverage)
                    reportLibConnection.Plot.OccupancyPerBinPlot(hAxes, specData(idx), xIndexLim, xArray, 'occMaxHold', occMaxHold)
            end
        end

        %-----------------------------------------------------------------%
        function OccupancyPerBinPlot(hAxes, SpecInfo, xIndexLim, xArray, plotMode, Occupancy)
            occIndex = SpecInfo.UserData.occMethod.CacheIndex;
            if isempty(occIndex)
                return
            end

            switch plotMode
                case 'occMinHold'; idx = 1;
                case 'occAverage'; idx = 2;
                case 'occMaxHold'; idx = 3;
            end

            occData = SpecInfo.UserData.occCache(occIndex).Data{3}(:,idx);

            switch Occupancy.Fcn
                case 'line'
                    p = plot(hAxes, xArray(xIndexLim(1):xIndexLim(2)), occData(xIndexLim(1):xIndexLim(2)), 'Tag', plotMode, 'LineStyle', Occupancy.LineStyle, 'LineWidth', Occupancy.LineWidth, 'Color', Occupancy.EdgeColor);
                case 'area'
                    p = area(hAxes, xArray(xIndexLim(1):xIndexLim(2)), occData(xIndexLim(1):xIndexLim(2)), 'Tag', plotMode, 'LineStyle', Occupancy.LineStyle, 'LineWidth', Occupancy.LineWidth, 'EdgeColor', Occupancy.EdgeColor, 'FaceColor', Occupancy.FaceColor, 'BaseValue', .1);
            end
            plot.datatip.Template(p, 'Frequency+Occupancy', '%%')
        end


        %-----------------------------------------------------------------%
        function EmissionPlot(hAxes, SpecInfo, yLim, ROI)
            pks = SpecInfo.UserData.Emissions;
            if ~isempty(pks)
                for ii = 1:height(pks)
                    if ischar(ROI.Color)
                        ROI.Color = hex2rgb(ROI.Color);
                    end
                    drawrectangle(hAxes, 'Position', [pks.Frequency(ii)-pks.BW_kHz(ii)/2000, yLim(1)+1, pks.BW_kHz(ii)/1000, diff(yLim)-2],                   ...
                                         'Color', ROI.Color, 'EdgeAlpha', ROI.EdgeAlpha, 'FaceAlpha', ROI.FaceAlpha, 'MarkerSize', 5, 'LineWidth', 1, ...
                                         'Deletable', 0, 'InteractionsAllowed', 'none', 'Tag', 'mkrROI');
                end

                NN = height(pks);
                pksLabel = string((1:NN)'); % Opcionalmente: "P_" + string((1:NN)')
                text(hAxes, pks.Frequency, repmat(yLim(1)+ROI.LabelOffset, NN, 1), pksLabel, ...
                           'Color', ROI.LabelColor, 'BackgroundColor', ROI.Color,            ...
                           'FontSize', ROI.LabelFontSize, 'FontWeight', 'bold',              ...
                           'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'PickableParts', 'none', 'Tag', 'mkrLabels');
            end
        end


        %-----------------------------------------------------------------%
        function ThresholdPlot(hAxes, bandObj, idx, reportInfo)
            defaultProperties = bandObj.callingApp.General_I;
            plotConfig = structUtil.struct2cellWithFields(defaultProperties.Plot.OccupancyThreshold);

            specData = bandObj.callingApp.specData(idx);
            xArray   = bandObj.xArray;

            switch bandObj.Context
                case 'appAnalise:REPORT:CHANNEL'
                    idxChannel = reportInfo.General.Parameters.Plot.idxChannel;
                    
                    occMethod = 'Linear adaptativo';
                    occTHR    = [specData.UserData.reportChannelAnalysis.("Threshold mínimo")(idxChannel), ...
                                 specData.UserData.reportChannelAnalysis.("Threshold máximo")(idxChannel)];

                otherwise
                    occIndex  = specData.UserData.occMethod.CacheIndex;
                    if isempty(occIndex)
                        return
                    end
        
                    occMethod = specData.UserData.occCache(occIndex).Info.Method;
                    occTHR    = specData.UserData.occCache(occIndex).THR;
            end

            switch occMethod
                case {'Linear fixo (COLETA)', 'Linear fixo'}
                    p    = plot(hAxes, [xArray(1), xArray(end)], [occTHR, occTHR]);
                case 'Linear adaptativo'
                    [minTHR, maxTHR] = bounds(occTHR);
                    p(1) = plot(hAxes, [xArray(1), xArray(end)], [minTHR, minTHR]);
                    p(2) = plot(hAxes, [xArray(1), xArray(end)], [maxTHR, maxTHR]);
                case 'Envoltória do ruído'
                    p    = plot(hAxes, xArray, occTHR);
            end
            arrayfun(@(x) set(x, 'MarkerIndices', [1, numel(x.XData)], 'Tag', 'OccupancyThreshold', plotConfig{:}), p)
        end

        %-----------------------------------------------------------------%
        function DriveTestPlot(hAxes, tempBandObj, idxThread, reportInfo)
            if tempBandObj.Context ~= "appAnalise:REPORT:EMISSION"
                return
            end

            specData = tempBandObj.callingApp.specData(idxThread);
            idxEmission = reportInfo.General.Parameters.Plot.idxEmission;

            if ~isempty(specData.UserData.Emissions.auxAppData(idxEmission).DriveTest)
                % Density | Distortion
                Source      = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.Source;
                filterTable = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.filterTable;
                pointsTable = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.pointsTable;
                plotMode    = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.plotType;
                plotSize    = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.plotSize;
                Basemap     = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.Basemap;
                Colormap    = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.Colormap;
    
                switch Source
                    case {'Raw', 'Filtered'}
                        srcTable = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.specFilteredTable;
                    case 'Data-Binning'
                        srcTable = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.specBinTable;
                end
    
                if ~strcmp(hAxes.Basemap, Basemap)
                    hAxes.Basemap = Basemap;
                end
                colormap(hAxes, Colormap)
    
                plot.DriveTest.DistortionAndDensityPlot(hAxes, tempBandObj, srcTable, plotMode, plotSize)
                plot.axes.StackingOrder.execute(hAxes, 'appAnalise:DRIVETEST')

                % Points
                if ~isempty(pointsTable)
                    MarkerStyle = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.points_Marker;
                    MarkerColor = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.points_Color;
                    MarkerSize  = specData.UserData.Emissions.auxAppData(idxEmission).DriveTest.points_Size;
                    plot.DriveTest.Points(hAxes, pointsTable, MarkerStyle, MarkerColor, MarkerSize)
                end

                % Filters
                if ~isempty(filterTable)
                    for ii = 1:height(filterTable)
                        FilterSubtype = filterTable.subtype{ii};
    
                        switch FilterSubtype
                            case 'PolygonKML'
                                Latitude  = filterTable.roi(ii).specification.Latitude;
                                Longitude = filterTable.roi(ii).specification.Longitude;
                                shapeObj  = geopolyshape(Latitude, Longitude);
    
                                geoplot(hAxes, shapeObj, FaceColor=[0 0.4470 0.7410], ...
                                                         EdgeColor=[0 0.4470 0.7410], ...
                                                         FaceAlpha=0.05,              ...
                                                         EdgeAlpha=1,                 ...
                                                         LineWidth=1,               ...
                                                         PickableParts='none',        ...
                                                         Tag='FilterROI');
                            otherwise
                                switch FilterSubtype
                                    case 'Circle';     roiFcn = 'images.roi.Circle';
                                    case 'Rectangle';  roiFcn = 'images.roi.Rectangle';
                                    case 'Polygon';    roiFcn = 'images.roi.Polygon';
                                end
            
                                eval(sprintf('hROI = %s(hAxes, LineWidth=1, FaceAlpha=0.05, Deletable=0, FaceSelectable=0, InteractionsAllowed="none", Tag="FilterROI");', roiFcn))

                                fieldsList = fields(filterTable.roi(ii).specification);
                                for jj = 1:numel(fieldsList)
                                    hROI.(fieldsList{jj}) = filterTable.roi(ii).specification.(fieldsList{jj});
                                end
                        end
                    end
                end
            end
        end
    end
end