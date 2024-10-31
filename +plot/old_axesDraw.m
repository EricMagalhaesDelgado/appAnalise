classdef (Abstract) old_axesDraw

    methods (Static = true)
        %-----------------------------------------------------------------%
        function imgFileName = plot2report(hContainer, specData, idxThread, tempBandObj, reportInfo, plotInfoPerAxes)
            % Limpa container.
            if ~isempty(hContainer.Children)
                delete(hContainer.Children)
            end

            % Cria eixos de acordo com estabelecido no JSON.
            tiledPos     = 1;
            tiledSpan    = [plotInfoPerAxes.Layout];

            axesParent   = tiledlayout(hContainer, sum(tiledSpan), 1, "Padding", "tight", "TileSpacing", "tight");           
            [axesType, ...
             axesXLabel] = plot.axes.axesTypeMapping({plotInfoPerAxes.Name});

            for ii = 1:numel(plotInfoPerAxes)
                xLabelFlag  = true;
                
                switch axesType{ii}
                    case 'Geographic'
                        hAxes = plot.axes.Creation(axesParent, 'Geographic');

                    case 'Cartesian'
                        switch tempBandObj.Context
                            case 'appAnalise:REPORT:CHANNEL'
                                idxSource = reportInfo.General.Parameters.Plot.idxChannel;
                            case 'appAnalise:REPORT:EMISSION'
                                idxSource = reportInfo.General.Parameters.Plot.idxEmission;
                            otherwise
                                idxSource = {};
                        end

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
                        case {'MinHold', 'ClearWrite', 'Average', 'MaxHold'}
                            plot.draw2D.OrdinaryLine(hAxes, tempBandObj, idxThread, plotTag{1});
    
                        case 'Persistance'
                            plot.Persistance('Creation', [], hAxes, tempBandObj, idxThread);
    
                        case 'Waterfall'
                            plot.Waterfall('Creation', hAxes, tempBandObj, idxThread);
    
                        case 'WaterfallTime'
    
                        %-----------------------------------------------------%
                        case 'Channel'
                            chTable = ChannelTable2Plot(tempBandObj.callingApp.channelObj, specData(idxThread));
                            specData(idxThread).UserData.reportChannelTable = chTable;
                            if ~isempty(chTable)
                                plot.draw2D.horizontalSetOfLines(hAxes, tempBandObj, idxThread, 'Channel', chTable)
                            end

                        case 'OccupancyPerChannel'
                            hAxes.YLim = [0,100];
    
                        %-----------------------------------------------------%
                        case 'BandLimits'
                            plot.old_axesDraw.BandLimitsPlot(hAxes, specData(idxThread))
    
                        case 'EmissionROI'
                            plot.old_axesDraw.EmissionPlot(hAxes, specData(idxThread), yLim, Parameters)
    
                        case {'occMinHold', 'occAverage', 'occMaxHold'}
                            hAxes.YLim = [0,100];
    
                        case 'occThreshold' % NAO ESTÁ NO GENERALSETTINGS.JSON
                            plot.old_axesDraw.ThresholdPlot(hAxes, specData(idxThread), xArray)
    
                        case 'OccupancyPerBin'
                            plot.old_axesDraw.cartesianAxes__type3(hAxes, specData, idxThread, tempBandObj, reportInfo, tempBandObj.xIndexLimits, tempBandObj.xArray)
                            hAxes.YLim = [0,100];
    
                        %-----------------------------------------------------%
                        case 'DriveTest'
                            plot.old_axesDraw.geographicAxes_type1(hAxes, Parameters, 'ReportGenerator')
    
                        case 'DriveTestRoute'
                            plot.old_axesDraw.geographicAxes_type2(hAxes, Parameters)
                    end
                end
                plot.axes.StackingOrder.execute(hAxes, tempBandObj.Context)

                if xLabelFlag
                    xlabel(hAxes, axesXLabel{ii})
                else
                    hAxes.XTickLabel = {};
                    xlabel(hAxes, '')
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
        function cartesianAxes__type3(hAxes, specData, idxThread, tempBandObj, reportInfo, xIndexLim, xArray)          % OccupancyPerBin
            defaultProperties = tempBandObj.callingApp.General_I;

            occMinHold = defaultProperties.Plot.occMinHold;
            occAverage = defaultProperties.Plot.occAverage;
            occMaxHold = defaultProperties.Plot.occMaxHold;
        
            % PLOT
            plot.old_axesDraw.OccupancyPerBinPlot(hAxes, specData(idxThread), xIndexLim, xArray, 'occMinHold', occMinHold)
            plot.old_axesDraw.OccupancyPerBinPlot(hAxes, specData(idxThread), xIndexLim, xArray, 'occAverage', occAverage)
            plot.old_axesDraw.OccupancyPerBinPlot(hAxes, specData(idxThread), xIndexLim, xArray, 'occMaxHold', occMaxHold)
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
                    drawrectangle(hAxes, 'Position', [pks.Frequency(ii)-pks.BW(ii)/2000, yLim(1)+1, pks.BW(ii)/1000, diff(yLim)-2],                   ...
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
        function ThresholdPlot(hAxes, SpecInfo, xArray)
            occIndex = SpecInfo.UserData.occMethod.CacheIndex;
            if isempty(occIndex)
                return
            end

            occMethod = SpecInfo.UserData.occCache(occIndex).Info.Method;
            occTHR    = SpecInfo.UserData.occCache(occIndex).THR;

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
            arrayfun(@(x) set(x, Color='red', LineStyle='-.', LineWidth=.5, Marker='o',                                           ...
                                 MarkerSize=4, MarkerIndices=[1, numel(x.XData)], MarkerFaceColor='red', MarkerEdgeColor='black', ...
                                 PickableParts='none', Tag='occTHR'), p)
        end


        %-----------------------------------------------------------------%
        function BandLimitsPlot(hAxes, SpecInfo)
            if SpecInfo.UserData.bandLimitsStatus
                yLevel = hAxes.YLim(2)-1;
            
                for ii = 1:height(SpecInfo.UserData.bandLimitsTable)
                    FreqStart = SpecInfo.UserData.bandLimitsTable.FreqStart(ii);
                    FreqStop  = SpecInfo.UserData.bandLimitsTable.FreqStop(ii);
                    
                    % Cria uma linha por subfaixa a analise, posicionando-o na parte 
                    % inferior do plot.
                    line(hAxes, [FreqStart, FreqStop], [yLevel, yLevel], ...
                                Color=[.5 .5 .5], LineWidth=5,           ...
                                PickableParts='none',  Tag='BandLimits')
                end
            end
        end


        %-----------------------------------------------------------------%
        % EIXO GEOGRÁFICO: CONTROLE
        %-----------------------------------------------------------------%
        function geographicAxes_type1(hAxes, Parameters, srcFcn)
            if isempty(Parameters)
                error('Unexpected parameters value.')
            end

            % PRÉ-PLOT
            cla(hAxes)

            % AJUSTE DO BASEMAP
            if isfield(Parameters, 'Basemap') && ~strcmp(hAxes.Basemap, Parameters.Basemap)
                hAxes.Basemap = Parameters.Basemap;
            end

            % PLOT
            if strcmp(srcFcn, 'ReportGenerator')
                plot.old_axesDraw.DriveTestFilterPlot(hAxes, Parameters, 'GeographicPlot');
            end            
            plot.old_axesDraw.DriveTestRoutePlot(hAxes, Parameters)
            plot.old_axesDraw.DriveTestPointsPlot(hAxes, Parameters);

            hDistortionVisibility = 0;
            hDensityVisibility    = 0;
            switch Parameters.plotType
                case 'distortion'
                    hDistortionVisibility = 1;
                case 'density'
                    hDensityVisibility    = 1;
            end

            switch Parameters.Source
                case {'Raw', 'Filtered'}
                    srcTable = Parameters.specFilteredTable;
                case 'Data-Binning'
                    srcTable = Parameters.specBinTable;
            end

            plot.old_axesDraw.DriveTestDistortionlPlot(hAxes, srcTable, Parameters, hDistortionVisibility);
            plot.old_axesDraw.DriveTestDensityPlot(hAxes, srcTable, Parameters, hDensityVisibility);
            geolimits(hAxes, 'auto')

            % PÓS-PLOT
            plot.axes.StackingOrder.execute(hAxes, 'appAnalise:DRIVETEST')
        end


        %-----------------------------------------------------------------%
        function geographicAxes_type2(hAxes, Parameters)
            if isempty(Parameters)
                error('Unexpected parameters value.')
            end

            % PLOT
            specData   = Parameters.specData;
            gpsPerFile = vertcat(specData.RelatedFiles.GPS{:});
            gpsMatrix  = vertcat(gpsPerFile.Matrix);

            if hAxes.Basemap == "none"
                hAxes.Basemap = 'streets-light';
            end

            geoplot(hAxes, gpsMatrix(:,1), gpsMatrix(:,2));
            geolimits(hAxes, 'auto')
        end
        
        
        %-----------------------------------------------------------------%
        % EIXO GEOGRÁFICO: PLOT
        %-----------------------------------------------------------------%
        function DriveTestFilterPlot(hAxes, Parameters, plotType)
            delete(findobj(hAxes.Children, 'Tag', 'FilterROI'))

            filterTable = Parameters.filterTable;

            for ii = 1:height(filterTable)
                subtype = filterTable.subtype{ii};

                switch subtype
                    case 'Threshold'
                        if ~strcmp(plotType, 'CartesianPlot')
                            continue
                        end
                        hROI = images.roi.Line(hAxes, 'Color', 'red', 'MarkerSize', 4, 'LineWidth', 1, 'Deletable', 0, 'InteractionsAllowed', 'translate', 'Tag', 'FilterROI');

                    case {'Circle', 'Rectangle', 'Polygon'}
                        if ~strcmp(plotType, 'GeographicPlot')
                            continue
                        end

                        switch subtype
                            case 'Circle';    roiFcn = 'Circle';    roiNameArgument = '';
                            case 'Rectangle'; roiFcn = 'Rectangle'; roiNameArgument = 'Rotatable=true, ';
                            case 'Polygon';   roiFcn = 'Polygon';   roiNameArgument = '';
                        end
                        eval(sprintf('hROI = images.roi.%s(hAxes, LineWidth=1, Deletable=0, FaceSelectable=0, %sTag="FilterROI");', roiFcn, roiNameArgument))
                end

                fieldsList = fields(filterTable.roi(ii).specification);
                for jj = 1:numel(fieldsList)
                    hROI.(fieldsList{jj}) = filterTable.roi(ii).specification.(fieldsList{jj});
                end
            end
        end

        %-----------------------------------------------------------------%
        function DriveTestRoutePlot(hAxes, Parameters)
            delete(findobj(hAxes.Children, 'Tag', 'OutRoute', '-or', 'Tag', 'InRoute'))

            specTable   = Parameters.specRawTable;
            filtTable   = Parameters.specFilteredTable;

            OutTable    = specTable(~specTable.Filtered,:);
            InTable     = filtTable;

            switch Parameters.route_LineStyle
                case 'none'; markerSize = 1;
                otherwise;   markerSize = 8*Parameters.route_MarkerSize;
            end

            geoplot(hAxes, OutTable.Latitude, OutTable.Longitude, 'Marker', '.', 'Color', Parameters.route_OutColor, 'MarkerFaceColor', Parameters.route_OutColor, 'MarkerEdgeColor', Parameters.route_OutColor, 'MarkerSize', markerSize, 'LineStyle', 'none',                     'Tag', 'OutRoute');
            geoplot(hAxes,  InTable.Latitude,  InTable.Longitude, 'Marker', '.', 'Color', Parameters.route_InColor,  'MarkerFaceColor', Parameters.route_InColor,  'MarkerEdgeColor', Parameters.route_InColor,  'MarkerSize', markerSize, 'LineStyle', Parameters.route_LineStyle, 'Tag', 'InRoute');
        end

        %-----------------------------------------------------------------%
        function DriveTestDistortionlPlot(hAxes, srcTable, Parameters, hDistortionVisibility)
            geoscatter(hAxes, srcTable.Latitude, srcTable.Longitude, [], srcTable.ChannelPower, ...
                'filled', 'SizeData', 20*Parameters.plotSize, 'Tag', 'Distortion', 'Visible', hDistortionVisibility);
        end


        %-----------------------------------------------------------------%
        function DriveTestDensityPlot(hAxes, srcTable, Parameters, hDensityVisibility)
            weights = srcTable.ChannelPower;
            if min(weights) < 0
                weights = weights+abs(min(weights));
            end

            geodensityplot(hAxes, srcTable.Latitude, srcTable.Longitude, weights, ...
                'FaceColor','interp', 'Radius', 100*Parameters.plotSize,          ...
                'PickableParts', 'none', 'Tag', 'Density', 'Visible', hDensityVisibility);
        end


        %-----------------------------------------------------------------%
        function DriveTestPointsPlot(hAxes, Parameters)
            delete(findobj(hAxes.Children, 'Tag', 'Points'))
            
            pointsTable = Parameters.pointsTable;
            MarkerStyle = Parameters.points_Marker;
            MarkerColor = Parameters.points_Color;
            MarkerSize  = Parameters.points_Size;

            plot.DriveTest.Points(hAxes, pointsTable, MarkerStyle, MarkerColor, MarkerSize)
        end
    end
end