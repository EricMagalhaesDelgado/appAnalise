classdef (Abstract) axesDraw

    properties (Constant)
        %-----------------------------------------------------------------%
        figureSize = [1244, 660] % antigo: [650, 800]
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function execute(plotName, hAxes, SpecInfo, Parameters, srcFcn)
            cla(hAxes)
            switch plotName
                case 'Spectrum';         plotFcn.axesDraw.cartesianAxes__type1(hAxes, SpecInfo, Parameters)
                case 'Persistance';      plotFcn.axesDraw.cartesianAxes__type2(hAxes, SpecInfo, Parameters)
                case 'OccupancyPerBin';  plotFcn.axesDraw.cartesianAxes__type3(hAxes, SpecInfo, Parameters)
                case 'Waterfall';        plotFcn.axesDraw.cartesianAxes__type4(hAxes, SpecInfo, Parameters)
              % case 'OccupancyPerHour'; plotFcn.axesDraw.cartesianAxes__type5(hAxes, SpecInfo, Parameters)
              % case 'OccupancyPerDay';  plotFcn.axesDraw.cartesianAxes__type6(hAxes, SpecInfo, Parameters)
              % case 'SamplesPerLevel';  plotFcn.axesDraw.cartesianAxes__type7(hAxes, SpecInfo, Parameters)
              % case 'ChannelPower';     plotFcn.axesDraw.cartesianAxes__type8(hAxes, SpecInfo, Parameters)
                case 'DriveTest';        plotFcn.axesDraw.geographicAxes_type1(hAxes, Parameters, srcFcn)
                case 'DriveTestRoute';   plotFcn.axesDraw.geographicAxes_type2(hAxes, Parameters)
              % case 'Stations';         plotFcn.axesDraw.geographicAxes_type3(hAxes, SpecInfo, Parameters)
              % case 'Link';             plotFcn.axesDraw.geographicAxes_type4(hAxes, SpecInfo, Parameters)
            end
        end


        %-----------------------------------------------------------------%
        % EIXO CARTESIANO: CONTROLE
        %-----------------------------------------------------------------%
        function cartesianAxes__type1(hAxes, SpecInfo, Parameters)          % Spectrum
            MinHold  = Parameters.MinHold;
            Average  = Parameters.Average;
            MaxHold  = Parameters.MaxHold;
            ROI      = Parameters.ROI;
            Axes     = Parameters.Axes;

            % PRÉ-PLOT
            [xLim, yLim, ~, xIndexLim, xArray] = plotFcn.axesDraw.Limits(SpecInfo, Parameters, 'ordinary level');
            plotFcn.axesDraw.PrePlotConfig(hAxes, xLim, yLim, 'linear', '')
        
            % PLOT
            plotFcn.axesDraw.OrdinaryPlot(hAxes, SpecInfo, xIndexLim, xArray, yLim, 'MinHold', MinHold)
            plotFcn.axesDraw.OrdinaryPlot(hAxes, SpecInfo, xIndexLim, xArray, yLim, 'Average', Average)
            plotFcn.axesDraw.OrdinaryPlot(hAxes, SpecInfo, xIndexLim, xArray, yLim, 'MaxHold', MaxHold)            
            plotFcn.axesDraw.BandLimitsPlot(hAxes, SpecInfo)
            plotFcn.axesDraw.EmissionPlot(hAxes, SpecInfo, yLim, ROI)            
            plotFcn.axesDraw.ThresholdPlot(hAxes, SpecInfo, xArray)

            plotFcn.axesStackingOrder.execute('winAppAnalise', hAxes)

            % PÓS-PLOT
            plotFcn.axesDraw.PostPlotConfig(hAxes, SpecInfo, Axes, 'Frequência (MHz)', ['Nível (' SpecInfo.MetaData.LevelUnit ')'])
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type2(hAxes, SpecInfo, Parameters)          % Persistance
            Average     = Parameters.Average;
            ROI         = Parameters.ROI;
            Persistance = Parameters.Persistance;
            Axes        = Parameters.Axes;
            
            % PRÉ-PLOT
            [xLim, yLim, ~, xIndexLim, xArray] = plotFcn.axesDraw.Limits(SpecInfo, Parameters, 'persistance level');
            plotFcn.axesDraw.PrePlotConfig(hAxes, xLim, yLim, 'linear', Persistance.Colormap)
            
            % PLOT        
            plotFcn.axesDraw.PersistancePlot(hAxes, SpecInfo, xIndexLim, xArray, yLim, Persistance)
            plotFcn.axesDraw.OrdinaryPlot(hAxes, SpecInfo, xIndexLim, xArray, yLim, 'Average', Average)
            plotFcn.axesDraw.BandLimitsPlot(hAxes, SpecInfo)
            plotFcn.axesDraw.EmissionPlot(hAxes, SpecInfo, yLim, ROI);            
            plotFcn.axesDraw.ThresholdPlot(hAxes, SpecInfo, xArray)

            plotFcn.axesStackingOrder.execute('winAppAnalise', hAxes)

            % PÓS-PLOT
            plotFcn.axesDraw.PostPlotConfig(hAxes, SpecInfo, Axes, 'Frequência (MHz)', ['Nível (' SpecInfo.MetaData.LevelUnit ')'])
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type3(hAxes, SpecInfo, Parameters)          % OccupancyPerBin
            occMinHold = Parameters.occMinHold;
            occAverage = Parameters.occAverage;
            occMaxHold = Parameters.occMaxHold;
            Axes       = Parameters.Axes;

            % PRÉ-PLOT
            [xLim, yLim, ~, xIndexLim, xArray] = plotFcn.axesDraw.Limits(SpecInfo, Parameters, 'occupancy level');
            plotFcn.axesDraw.PrePlotConfig(hAxes, xLim, yLim, 'log', '')
        
            % PLOT
            plotFcn.axesDraw.OccupancyPerBinPlot(hAxes, SpecInfo, xIndexLim, xArray, 'occMinHold', occMinHold)
            plotFcn.axesDraw.OccupancyPerBinPlot(hAxes, SpecInfo, xIndexLim, xArray, 'occAverage', occAverage)
            plotFcn.axesDraw.OccupancyPerBinPlot(hAxes, SpecInfo, xIndexLim, xArray, 'occMaxHold', occMaxHold)

            % PÓS-PLOT
            plotFcn.axesDraw.PostPlotConfig(hAxes, SpecInfo, Axes, 'Frequência (MHz)', 'Ocupação (%)')
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type4(hAxes, SpecInfo, Parameters)          % Waterfall
            Waterfall = Parameters.Waterfall;
            Axes      = Parameters.Axes;

            % PRÉ-PLOT
            switch Waterfall.Fcn
                case 'mesh';  yUnit = 'time';
                case 'image'; yUnit = 'timeIndex';
            end
            [xLim, yLim, ~, xIndexLim, xArray] = plotFcn.axesDraw.Limits(SpecInfo, Parameters, yUnit);
            plotFcn.axesDraw.PrePlotConfig(hAxes, xLim, yLim, 'linear', Waterfall.Colormap)

            % PLOT
            plotFcn.axesDraw.WaterfallPlot(hAxes, SpecInfo, xIndexLim, xArray, Waterfall)

            % PÓS-PLOT
            plotFcn.axesDraw.PostPlotConfig(hAxes, SpecInfo, Axes, 'Frequência (MHz)', 'Amostras')
        end


        %-----------------------------------------------------------------%
        % EIXO CARTESIANO: PLOT
        %-----------------------------------------------------------------%
        function PersistancePlot(hAxes, SpecInfo, xIndexLim, xArray, yLim, Persistance)
            DataPoints  = numel(xArray);
            nSweeps     = numel(SpecInfo.Data{1});

            xResolution = min(801, DataPoints);
            yResolution = 201;

            xEdges      = linspace(xArray(1), xArray(end), xResolution+1);
            yEdges      = linspace(yLim(1), yLim(2), yResolution+1);

            specHist    = histcounts2(SpecInfo.Data{2}(xIndexLim(1):xIndexLim(2),:), repmat(xArray', 1, nSweeps), yEdges, xEdges);    

            image(hAxes, specHist, 'XData', [xArray(1), xArray(end)], 'YData', yLim, 'CData', (100 * specHist ./ sum(specHist)), ...
                                   'AlphaData', specHist, 'CDataMapping', 'scaled', 'Interpolation', Persistance.Interpolation,   ...
                                   'PickableParts', 'none', 'Tag', 'Persistance');
        end


        %-----------------------------------------------------------------%
        function WaterfallPlot(hAxes, SpecInfo, xIndexLim, xArray, Waterfall)
            DataPoints  = numel(xArray);
            nSweeps     = numel(SpecInfo.Data{1});

            switch Waterfall.Fcn
                case 'mesh'
                    nWaterFallPoints    = DataPoints*nSweeps;
                    nMaxWaterFallPoints = class.Constants.nMaxWaterFallPoints;
                    if nWaterFallPoints > nMaxWaterFallPoints; Decimate = ceil(nWaterFallPoints/nMaxWaterFallPoints);
                    else;                                      Decimate = 1;
                    end
        
                    while true
                        tArray = SpecInfo.Data{1}(1:Decimate:end);
                        if numel(tArray) > 1; break
                        else;                 Decimate = round(Decimate/2);
                        end
                    end
        
                    if tArray(1) == tArray(end)
                        tArray(end) = tArray(1)+seconds(1);
                    end
        
                    [X, Y] = meshgrid(xArray, tArray);
                    p = mesh(hAxes, X, Y, SpecInfo.Data{2}(xIndexLim(1):xIndexLim(2),1:Decimate:end)', 'MeshStyle', Waterfall.MeshStyle, 'SelectionHighlight', 'off', 'Tag', 'WaterFall');                    

                case 'image'
                    p = image(hAxes, xArray, 1:nSweeps, SpecInfo.Data{2}(xIndexLim(1):xIndexLim(2),:)', 'CDataMapping', 'scaled', 'Tag', 'Waterfall');                    
            end
            plotFcn.axesDataTipTemplate.execute('Frequency+Timestamp+Level', p, [], SpecInfo.MetaData.LevelUnit)

            hAxes.CLim(2) = round(hAxes.CLim(2));
            hAxes.CLim(1) = round(hAxes.CLim(2) - diff(hAxes.CLim)/2);

            if strcmp(Waterfall.View, 'horizontal')
                hAxes.View(1) = 90;
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
            colormap(hAxes, Parameters.Colormap)
            hAxes.Colormap(1,:) = [0,0,0];

            % AJUSTE DO BASEMAP
            if isfield(Parameters, 'Basemap')
                hAxes.Basemap = Parameters.Basemap;
            end

            % PLOT
            if strcmp(srcFcn, 'ReportGenerator')
                plotFcn.axesDraw.DriveTestFilterPlot(hAxes, Parameters, 'GeographicPlot');
            end            
            plotFcn.axesDraw.DriveTestRoutePlot(hAxes, Parameters)
            plotFcn.axesDraw.DriveTestDistortionlPlot(hAxes, Parameters);
            plotFcn.axesDraw.DriveTestDensityPlot(hAxes, Parameters);
            plotFcn.axesDraw.DriveTestPointsPlot(hAxes, Parameters);

            % PÓS-PLOT
            plotFcn.axesStackingOrder.execute('winDriveTest', hAxes)
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

            geoplot(hAxes, gpsMatrix(:,1), gpsMatrix(:,2));
        end
        
        
        %-----------------------------------------------------------------%
        % EIXO GEOGRÁFICO: PLOT
        %-----------------------------------------------------------------%
        function DriveTestFilterPlot(hAxes, Parameters, plotType)
            delete(findobj(hAxes, 'Tag', 'ROI'))

            filterTable = Parameters.filterTable;

            for ii = 1:height(filterTable)
                subtype = filterTable.subtype{ii};

                switch subtype
                    case 'Threshold'
                        if ~strcmp(plotType, 'CartesianPlot')
                            continue
                        end

                        hROI = images.roi.Line(hAxes, 'Color', 'red', 'MarkerSize', 4, 'LineWidth', 1, 'Deletable', 0, 'InteractionsAllowed', 'translate', 'Tag', 'ROI');

                    case {'Circle', 'Rectangle', 'Polygon'}
                        if ~strcmp(plotType, 'GeographicPlot')
                            continue
                        end

                        switch subtype
                            case 'Circle';    roiFcn = 'Circle';    roiNameArgument = '';
                            case 'Rectangle'; roiFcn = 'Rectangle'; roiNameArgument = 'Rotatable=true, ';
                            case 'Polygon';   roiFcn = 'Polygon';   roiNameArgument = '';
                        end
                        eval(sprintf('hROI = images.roi.%s(hAxes, LineWidth=1, Deletable=0, FaceSelectable=0, %sTag="ROI");', roiFcn, roiNameArgument))
                end

                fieldsList = fields(filterTable.roi(ii).specification);
                for jj = 1:numel(fieldsList)
                    hROI.(fieldsList{jj}) = filterTable.roi(ii).specification.(fieldsList{jj});
                end
            end
        end


        %-----------------------------------------------------------------%
        function DriveTestRoutePlot(hAxes, Parameters)
            delete(findobj(hAxes, 'Tag', 'OutRoute', '-or', 'Tag', 'InRoute'))

            specTable   = Parameters.specTable;
            filtTable   = Parameters.filtTable;

            OutTable    = specTable(~specTable.filtered,:);
            InTable     = filtTable;

            switch Parameters.route_LineStyle
                case 'none'; markerSize = 1;
                otherwise;   markerSize = 8*Parameters.route_MarkerSize;
            end

            hOutRoute   = geoplot(hAxes, OutTable.Lat, OutTable.Long, 'Marker', '.', 'Color', Parameters.route_OutColor, 'MarkerFaceColor', Parameters.route_OutColor, 'MarkerEdgeColor', Parameters.route_OutColor, 'MarkerSize', markerSize, 'LineStyle', 'none',                     'Tag', 'OutRoute');
            hInRoute    = geoplot(hAxes,  InTable.Lat,  InTable.Long, 'Marker', '.', 'Color', Parameters.route_InColor,  'MarkerFaceColor', Parameters.route_InColor,  'MarkerEdgeColor', Parameters.route_InColor,  'MarkerSize', markerSize, 'LineStyle', Parameters.route_LineStyle, 'Tag', 'InRoute');

            plotFcn.axesDataTipTemplate.execute('Coordinates', hOutRoute, [], [])
            plotFcn.axesDataTipTemplate.execute('Coordinates', hInRoute,  [], [])
        end


        %-----------------------------------------------------------------%
        function DriveTestDistortionlPlot(hAxes, Parameters)
            delete(findobj(hAxes, 'Tag', 'Distortion'))

            switch Parameters.Source
                case 'RawData'; tempTable = Parameters.filtTable;
                case 'BinData'; tempTable = Parameters.binTable;
            end

            hDistortion = geoscatter(hAxes, tempTable{:,1}, tempTable{:,2}, [], tempTable{:,3},  ...
                                            'filled', 'SizeData', 20*Parameters.distortion_Size, ...
                                            'Visible', Parameters.distortion_Visibility, 'Tag', 'Distortion');
            
            plotFcn.axesDataTipTemplate.execute('SweepID+ChannelPower+Coordinates', hDistortion, [], [])
        end


        %-----------------------------------------------------------------%
        function DriveTestDensityPlot(hAxes, Parameters)
            delete(findobj(hAxes, 'Tag', 'Density'))

            switch Parameters.Source
                case 'RawData'; tempTable = Parameters.filtTable;
                case 'BinData'; tempTable = Parameters.binTable;
            end

            weights = tempTable{:,3};
            if min(weights) < 0
                weights = weights+abs(min(weights));
            end

            geodensityplot(hAxes, tempTable{:,1}, tempTable{:,2}, weights,                     ...
                                  'FaceColor','interp', 'Radius', 100*Parameters.density_Size, ...
                                  'PickableParts', 'none', 'Visible', Parameters.density_Visibility, 'Tag', 'Density');
        end


        %-----------------------------------------------------------------%
        function DriveTestPointsPlot(hAxes, Parameters)
            delete(findobj(hAxes, 'Tag', 'Points'))

            global RFDataHub
            pointsTable = Parameters.pointsTable;

            for ii = 1:height(pointsTable)
                if ~pointsTable.visible(ii)
                    continue
                end

                rowIndex    = pointsTable.value(ii).idx;
                Coordinates = pointsTable.value(ii).Coordinates;

                switch pointsTable.type{ii}
                    case 'RFDataHub'
                        hStation = geoplot(hAxes, Coordinates(:,1), Coordinates(:,2),                                                        ...
                                                  'LineStyle', 'none', 'Color', Parameters.points_Color, 'Marker', Parameters.points_Marker, ...
                                                  'MarkerSize', Parameters.points_Size, 'MarkerFaceColor', Parameters.points_Color,          ...
                                                  'MarkerEdgeColor', Parameters.points_Color, 'Tag', 'Points');
                        plotFcn.axesDataTipTemplate.execute('Coordinates+Frequency', hStation, RFDataHub(rowIndex,1:2), [])

                    case 'FindPeaks'
                        geoplot(hAxes, Coordinates(:,1), Coordinates(:,2),                                                                          ...
                                       'LineStyle', 'none', 'Color', Parameters.points_Color, 'Marker', Parameters.points_Marker,                   ...
                                       'MarkerSize', Parameters.points_Size, 'MarkerFaceColor', 'none', 'MarkerEdgeColor', Parameters.points_Color, ...
                                       'PickableParts', 'none', 'Tag', 'Points');
                end
            end
        end


        %-----------------------------------------------------------------%
        % FUNÇÕES AUXILIARES
        %-----------------------------------------------------------------%
        function imgFileName = plot2report(SpecInfo, reportInfo, plotInfo)
            % Criação da figura.
            f = plotFcn.axesDraw.FigureCreation(reportInfo);

            % Criação dos eixos e disposição no layout indicado no JSON do
            % modelo do relatório.
            if strcmp(reportInfo.General.Parameters.Plot.Type, 'Emission')
                idxDriveTest = find(strcmp({plotInfo.Name}, 'DriveTest'));
                idxEmission  = reportInfo.General.Parameters.Plot.emissionIndex;
                
                if ~isempty(idxDriveTest) && isempty(SpecInfo.UserData.Emissions.UserData{idxEmission})
                    plotInfo(idxDriveTest) = [];
                end
            end

            if isempty(plotInfo)
                error('Empty plot list!')
            end

            tiledPos  = 1;
            tiledSpan = [plotInfo.Layout];

            t = tiledlayout(f, sum(tiledSpan), 1, "Padding", "tight", "TileSpacing", "tight");
           
            axesType = plotFcn.axesDraw.AxesType({plotInfo.Name});

            for ii = 1:numel(plotInfo)
                switch plotInfo(ii).Name
                    case 'DriveTest'; Parameters = reportInfo.General.Parameters.DriveTest;
                    otherwise;        Parameters = reportInfo.General.Parameters;
                end

                hAxes     = plotFcn.axesDraw.AxesCreation([], axesType{ii}, t);
                xTickFlag = true;

                switch axesType{ii}
                    case 'Geographic'
                        geolimits(hAxes, 'auto')

                    case 'Cartesian'
                        if (numel(plotInfo) > 1) && (ii < numel(plotInfo)) && any(strcmp(axesType(2:end), 'Cartesian'))
                            xTickFlag = false;
                        end
                end

                disableDefaultInteractivity(hAxes)

                hAxes.Layout.Tile     = tiledPos;
                hAxes.Layout.TileSpan = [tiledSpan(ii) 1];

                plotFcn.axesDraw.execute(plotInfo(ii).Name, hAxes, SpecInfo, Parameters, 'ReportGenerator')

                if ~xTickFlag
                    hAxes.XTickLabel = {};
                    xlabel(hAxes, '')
                end
                tiledPos = tiledPos+tiledSpan(ii);
            end

            % Espera renderizar e salva a imagem...
            defaultFilename = class.Constants.DefaultFileName(reportInfo.General.UserPath, sprintf('Image_ID%d', SpecInfo.RelatedFiles.ID(1)), -1);
            imgFileName     = sprintf('%s.%s', defaultFilename, reportInfo.General.Image.Format);
            if ~strcmp(reportInfo.General.Version, 'Definitiva')
                imgFileName = replace(imgFileName, 'Image', '~Image');
            end
            
            exportgraphics(f, imgFileName, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
            drawnow nocallbacks
            while true
                if isfile(imgFileName)
                    delete(f)
                    break
                end
            end
        end


        %-----------------------------------------------------------------%
        function f = FigureCreation(reportInfo)
            mainMonitor     = get(0, 'MonitorPositions');
            [~, indMonitor] = max(mainMonitor(:,3));
            mainMonitor     = mainMonitor(indMonitor,:);
        
            xPixels = class.Constants.windowSize(1);
            yPixels = class.Constants.windowSize(2);
        
            f = uifigure('Visible', false,                                                                         ...
                         'Position', [mainMonitor(1) + round((mainMonitor(3)-xPixels)/2),                          ...
                                      mainMonitor(2) + round((mainMonitor(4)+48-yPixels-30)/2), xPixels, yPixels], ...
                         'Icon', 'icon_48.png', 'Tag', 'ReportGenerator');
        end


        %-----------------------------------------------------------------%
        function hAxes = AxesCreation(app, axesType, axesParent)
            switch axesType
                case 'Cartesian'
                    hAxes = uiaxes(axesParent,  Color=[0,0,0], ColorScale='log', FontName='Helvetica', FontSize=9,                       ...
                                                XGrid='on', XMinorGrid='on', YGrid='on', YMinorGrid='on',                                ...
                                                GridAlpha=.25, GridColor=[.94,.94,.94], MinorGridAlpha=.2, MinorGridColor=[.94,.94,.94], ...
                                                Interactions=[], Toolbar=[]);

                    % Interactions
                    plotFcn.axesInteraction.CartesianToolbar(hAxes, {'datacursor', 'pan', 'restoreview'});
                    plotFcn.axesInteraction.CartesianDefaultInteractions(hAxes, [dataTipInteraction, regionZoomInteraction])
                    plotFcn.axesInteraction.InteractionsCallbacks({'Data tips', 'Pan'}, hAxes, [])
                    plotFcn.axesInteraction.InteractionsCallbacks({'Restore view'}, hAxes, app)

                case 'Geographic'
                    hAxes = geoaxes(axesParent, FontSize=6, Units='pixels', Basemap='darkwater', Box='off');

                    hAxes.LatitudeLabel.String  = '';
                    hAxes.LongitudeLabel.String = '';

                    try
                        geobasemap(hAxes, 'streets-light')
                    catch
                    end

                    % Interactions
                    plotFcn.axesInteraction.GeographicToolbar(hAxes, 'default', 'export')
            end

            hold(hAxes, 'on')
        end


        %-----------------------------------------------------------------%
        function axesType = AxesType(plotName)
            axesType = {};
            for ii = 1:numel(plotName)
                switch plotName{ii}
                    case {'Spectrum', 'Persistance', 'OccupancyPerBin', 'Waterfall', 'OccupancyPerHour', 'OccupancyPerDay', 'SamplesPerLevel', 'ChannelPower', 'Link'}
                        axesType{ii} = 'Cartesian';
                    case {'DriveTest', 'Stations', 'DriveTestRoute'}
                        axesType{ii} = 'Geographic';
                    otherwise
                        error('Unexpected plotName')
                end
            end
        end

        %-----------------------------------------------------------------%
        function PrePlotConfig(hAxes, xLim, yLim, yScale, colorMap)
            switch class(yLim)
                case 'datetime'
                    if ~isa(hAxes.YAxis, 'matlab.graphics.axis.decorator.DatetimeRuler')
                        matlab.graphics.internal.configureAxes(hAxes, xLim, yLim)
                    end

                otherwise
                    if ~isa(hAxes.YAxis, 'matlab.graphics.axis.decorator.NumericRuler')
                        matlab.graphics.internal.configureAxes(hAxes, xLim, yLim)
                    end
            end

            if ~diff(xLim)
                xLim = [xLim(1)-.1, xLim(1)+.1];
            end

            set(hAxes, 'XLim', xLim, 'YLim', yLim, 'YScale', yScale, 'ZLimMode', 'auto', 'CLimMode', 'auto', 'View', [0,90])
            try
                hAxes.XAxis.Exponent = 0;
                hAxes.YAxis.Exponent = 0;
                hAxes.ZAxis.Exponent = 0;
            catch
            end

            if ~isempty(colorMap)
                colormap(hAxes, colorMap)
                hAxes.Colormap(1,:) = [0,0,0];
            end
        end


        %-----------------------------------------------------------------%
        function PostPlotConfig(hAxes, SpecInfo, Axes, xUnit, yUnit)
            % xyLabels
            if Axes.xLabel;     xlabel(hAxes, xUnit)
            else;               xlabel(hAxes, '')
            end

            if Axes.yLabel;     ylabel(hAxes, yUnit)
            else;               ylabel(hAxes, '')
            end

            % xyTicks
            [xTick, xTickLabel, yTick, yTickLabel] = plotFcn.axesDraw.Tick(hAxes, SpecInfo);
            set(hAxes, 'XTick', xTick, 'YTick', yTick);

            if Axes.xTickLabel; hAxes.XTickLabel = xTickLabel;
            else;               hAxes.XTickLabel = {};
            end

            if Axes.yTickLabel; hAxes.YTickLabel = yTickLabel;
            else;               hAxes.YTickLabel = {};
            end
        end


        %-----------------------------------------------------------------%



        %-----------------------------------------------------------------%



        %-----------------------------------------------------------------%
        function idx = freq2idx(SpecInfo, FrequencyInHertz, RoundType)
            FreqStartInHertz = SpecInfo.MetaData.FreqStart;
            FreqStopInHertz  = SpecInfo.MetaData.FreqStop;
            DataPoints       = SpecInfo.MetaData.DataPoints;

            % FrequencyInHertz = aCoef * idx + bCoef;
            aCoef = (FreqStopInHertz - FreqStartInHertz) / (DataPoints - 1);
            bCoef = FreqStartInHertz - aCoef;

            switch RoundType
                case 'fix';  idx = fix((FrequencyInHertz  - bCoef) / aCoef);
                case 'ceil'; idx = ceil((FrequencyInHertz - bCoef) / aCoef);
            end

            if idx < 1
                idx = 1;
            elseif idx > DataPoints
                idx = DataPoints;
            end
        end


        %-----------------------------------------------------------------%
        function [xTick, xTickLabel, yTick, yTickLabel] = Tick(hAxes, SpecInfo)
            xTickFlag = true;
            yTickFlag = true;

            for ii = 5:-1:1
                if xTickFlag
                    xTick = linspace(hAxes.XLim(1), hAxes.XLim(2), ii);

                    if issorted(xTick, "strictascend")
                        xTickFlag  = false;
                        xTickLabel = string(round(xTick, 3));
                    end
                end

                if yTickFlag
                    yTick = linspace(hAxes.YLim(1), hAxes.YLim(2), ii);

                    if issorted(yTick, "strictascend")
                        yTickFlag = false;

                        switch class(yTick)
                            case 'datetime'
                                yTickLabel = [];
                                for jj = 1:numel(yTick)
                                    [~, yTickIndex]   = min(abs(SpecInfo.Data{1} - yTick(jj)));
                                    yTickLabel(end+1) = yTickIndex;
                                end
                            otherwise
                                yTickLabel = round(yTick);
                        end
                        yTickLabel = string(yTickLabel);
                    end
                end

                if ~xTickFlag && ~yTickFlag
                    break
                end
            end
        end
    end
end