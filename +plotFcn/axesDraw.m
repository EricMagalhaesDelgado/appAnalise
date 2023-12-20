classdef (Abstract) axesDraw

    properties (Constant)
        %-----------------------------------------------------------------%
        figureSize = [650, 800]
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        % CONTROLE
        %-----------------------------------------------------------------%
        function execute(plotName, hAxes, SpecInfo, Parameters)
            cla(hAxes)
            switch plotName
                case 'Spectrum';               plotFcn.axesDraw.cartesianAxes__type1(hAxes, SpecInfo, Parameters)
                case 'Persistance';            plotFcn.axesDraw.cartesianAxes__type2(hAxes, SpecInfo, Parameters)
                case 'OccupancyPerBin';        plotFcn.axesDraw.cartesianAxes__type3(hAxes, SpecInfo, Parameters)
                case 'OccupancyPerHour';       plotFcn.axesDraw.cartesianAxes__type4(hAxes, SpecInfo, Parameters)
                case 'OccupancyPerDay';        plotFcn.axesDraw.cartesianAxes__type5(hAxes, SpecInfo, Parameters)
                case 'SamplesPerLevel';        plotFcn.axesDraw.cartesianAxes__type6(hAxes, SpecInfo, Parameters)
                case 'ChannelPower';           plotFcn.axesDraw.cartesianAxes__type7(hAxes, SpecInfo, Parameters)
                case 'Waterfall';              plotFcn.axesDraw.cartesianAxes__type8(hAxes, SpecInfo, Parameters)
                case 'Drive-test: Route';      plotFcn.axesDraw.geographicAxes_type1(hAxes, SpecInfo, Parameters)
                case 'Drive-test: Distortion'; plotFcn.axesDraw.geographicAxes_type2(hAxes, SpecInfo, Parameters)
                case 'Drive-test: Heatmap';    plotFcn.axesDraw.geographicAxes_type3(hAxes, SpecInfo, Parameters)
                case 'RFDataHub: Stations';    plotFcn.axesDraw.geographicAxes_type4(hAxes, SpecInfo, Parameters)
                case 'RFDataHub: Link';        plotFcn.axesDraw.geographicAxes_type5(hAxes, SpecInfo, Parameters)
            end
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type1(hAxes, SpecInfo, Parameters)
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
        function cartesianAxes__type2(hAxes, SpecInfo, Parameters)
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
        function cartesianAxes__type3(hAxes, SpecInfo, Parameters)
            occMinHold = Parameters.occMinHold;
            occAverage = Parameters.occAverage;
            occMaxHold = Parameters.occMaxHold;
            Axes       = Parameters.Axes;

            % PRÉ-PLOT
            [xLim, yLim, ~, ~, xArray] = plotFcn.axesDraw.Limits(SpecInfo, Parameters, 'occupancy level');            
            plotFcn.axesDraw.PrePlotConfig(hAxes, xLim, yLim, 'log', '')
        
            % PLOT
            plotFcn.axesDraw.OccupancyPerBinPlot(hAxes, SpecInfo, xArray, 'occMinHold', occMinHold)
            plotFcn.axesDraw.OccupancyPerBinPlot(hAxes, SpecInfo, xArray, 'occAverage', occAverage)
            plotFcn.axesDraw.OccupancyPerBinPlot(hAxes, SpecInfo, xArray, 'occMaxHold', occMaxHold)

            % PÓS-PLOT
            plotFcn.axesDraw.PostPlotConfig(hAxes, SpecInfo, Axes, 'Frequência (MHz)', 'Ocupação (%)')
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type4(hAxes, SpecInfo, Parameters)
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type5(hAxes, SpecInfo, Parameters)
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type6(hAxes, SpecInfo, Parameters)
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type7(hAxes, SpecInfo, Parameters)
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type8(hAxes, SpecInfo, Parameters)
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
        function geographicAxes_type1(hAxes, SpecInfo, Parameters)
        end


        %-----------------------------------------------------------------%
        function geographicAxes_type2(hAxes, SpecInfo, Parameters) % ROUTE
            Lat  = [];
            Long = [];
            for ii = 1:height(SpecInfo(idx).RelatedFiles)
                Lat  = [Lat;  SpecInfo(idx).RelatedFiles.GPS{ii}.Matrix(:,1)];
                Long = [Long; SpecInfo(idx).RelatedFiles.GPS{ii}.Matrix(:,2)];
            end
        
            hAxes = geoaxes(fig, 'FontSize', 6, 'Units', 'pixels', 'Basemap', 'darkwater', 'FontName', 'Calibri', 'FontSize', 10, 'ToolBar', []);
            disableDefaultInteractivity(hAxes)
        
            while true
                try
                    hAxes.LatitudeLabel.String  = '';
                    hAxes.LongitudeLabel.String = '';
        
                    colormap(hAxes, Parameters.Colormap)                    
                    break
                catch
                end
            end
        
            try
                geobasemap(hAxes, Parameters.GeoBaseMap)
            catch
            end
        
            geoplot(hAxes, Lat, Long, 'Color', Parameters.Color, 'LineWidth', 5);
        end


        %-----------------------------------------------------------------%
        function geographicAxes_type3(hAxes, SpecInfo, Parameters)
        end


        %-----------------------------------------------------------------%
        function geographicAxes_type4(hAxes, SpecInfo, Parameters)
        end


        %-----------------------------------------------------------------%
        function geographicAxes_type5(hAxes, SpecInfo, Parameters)
        end


        %-----------------------------------------------------------------%
        % PLOTS
        %-----------------------------------------------------------------%
        function OrdinaryPlot(hAxes, SpecInfo, xIndexLim, xArray, yLim, plotMode, TraceMode)
            switch plotMode
                case 'MinHold'; idx = 1;
                case 'Average'; idx = 2;
                case 'MaxHold'; idx = 3;
            end

            switch TraceMode.Fcn
                case 'line'
                    p = plot(hAxes, xArray, SpecInfo.Data{3}(xIndexLim(1):xIndexLim(2),idx), 'Tag', plotMode, 'LineStyle', TraceMode.LineStyle, 'LineWidth', TraceMode.LineWidth, 'Color', TraceMode.EdgeColor);
                case 'area'
                    p = area(hAxes, xArray, SpecInfo.Data{3}(xIndexLim(1):xIndexLim(2),idx), 'Tag', plotMode, 'LineStyle', TraceMode.LineStyle, 'LineWidth', TraceMode.LineWidth, 'EdgeColor', TraceMode.EdgeColor, 'FaceColor', TraceMode.FaceColor, 'BaseValue', yLim(1));
            end
            plotFcn.axesDataTipTemplate.execute('Frequency+Level', p, [], SpecInfo.MetaData.LevelUnit)
        end


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
        function OccupancyPerBinPlot(hAxes, SpecInfo, xArray, plotMode, Occupancy)
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
            occData(occData==0) = .1;

            switch Occupancy.Fcn
                case 'line'
                    p = plot(hAxes, xArray, occData, 'Tag', plotMode, 'LineStyle', Occupancy.LineStyle, 'LineWidth', Occupancy.LineWidth, 'Color', Occupancy.EdgeColor);
                case 'area'
                    p = area(hAxes, xArray, occData, 'Tag', plotMode, 'LineStyle', Occupancy.LineStyle, 'LineWidth', Occupancy.LineWidth, 'EdgeColor', Occupancy.EdgeColor, 'FaceColor', Occupancy.FaceColor, 'BaseValue', .1);
            end
            plotFcn.axesDataTipTemplate.execute('Frequency+Occupancy', p, [], '%%')
        end


        %-----------------------------------------------------------------%
        function EmissionPlot(hAxes, SpecInfo, yLim, ROI)
            pks = SpecInfo.UserData.Emissions;
            if ~isempty(pks)
                for ii = 1:height(pks)
                    if ischar(ROI.Color)
                        ROI.Color = ccTools.fcn.hex2rgb(ROI.Color);
                    end
                    drawrectangle(hAxes, 'Position', [pks.Frequency(ii)-pks.BW(ii)/2000, yLim(1)+1, pks.BW(ii)/1000, diff(yLim)-2],        ...
                                         'Color', ROI.Color, 'FaceAlpha', ROI.FaceAlpha', 'MarkerSize', 5, 'LineWidth', 1, 'Deletable', 0, ...
                                         'InteractionsAllowed', 'none', 'Tag', 'mkrROI');
                end

                NN = height(pks);
                pksLabel = string((1:NN)'); % Opcionalmente: "P_" + string((1:NN)')
                text(hAxes, pks.Frequency, repmat(yLim(1)+ROI.yPosition, NN, 1), pksLabel, ...
                            'Color', ROI.TextColor, 'BackgroundColor', ROI.Color,          ...
                            'FontSize', ROI.TextFontSize, 'FontWeight', 'bold',            ...
                            'HorizontalAlignment', 'center', 'PickableParts', 'none', 'Tag', 'mkrLabels');
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
        % FUNÇÕES AUXILIARES
        %-----------------------------------------------------------------%
        function imgFileName = plot2report(SpecInfo, reportInfo, imgID)
            % Criação da figura.
            figWidth        = plotFcn.axesDraw.figureSize(1);
            figHeight       = plotFcn.axesDraw.figureSize(2);

            mainMonitor     = get(0, 'MonitorPositions');
            [~, indMonitor] = max(mainMonitor(:,3));
            mainMonitor     = mainMonitor(indMonitor,:);
        
            f = uifigure('Visible', reportInfo.General.Image.Visibility,                                                       ...
                         'Position', [(mainMonitor(1) + round((mainMonitor(3)-figWidth)/2) + 32*imgID),                        ...
                                      (mainMonitor(2) + round((mainMonitor(4)-figHeight)/2) - 32*imgID), figWidth, figHeight], ...
                         'Name', 'appAnalise: Relatório', 'Icon', fullfile(reportInfo.General.RootFolder, 'Icons', 'LR_icon.png'), 'Tag', 'ReportGenerator');

            % Criação dos eixos e disposição no layout indicado no JSON do
            % modelo do relatório.
            

            % Desenho dos plots...


            % Espera renderizar e salva a imagem...
            defaultFilename = class.Constants.DefaultFileName(userPath, sprintf('Image_ID%d', SpecInfo.RelatedFiles.ID(1)), -1);
            imgFileName     = sprintf('%s.%s', defaultFilename, reportInfo.General.Image.Format);
            if ~strcmp(reportInfo.General.Version, 'Definitiva')
                imgFileName = replace(imgFileName, 'Image', '~Image');
            end
            
            exportgraphics(f, imgFileName, 'ContentType', 'image', 'Resolution', reportInfo.General.Image.Resolution)
            drawnow nocallbacks

            if ~reportInfo.General.Image.Visibility
                delete(f)
            end
        end


        %-----------------------------------------------------------------%
        function hAxes = AxesCreation(app, axesType, axesParent)
            switch axesType
                case 'Cartesian'
                    hAxes = uiaxes(axesParent,  Color=[0,0,0], ColorScale='log', FontName='Helvetica', FontSize=9, FontSmoothing='on',   ...
                                                XGrid='on', XMinorGrid='on', YGrid='on', YMinorGrid='on',                                ...
                                                GridAlpha=.25, GridColor=[.94,.94,.94], MinorGridAlpha=.2, MinorGridColor=[.94,.94,.94], ...
                                                Interactions=[], Toolbar=[]);

                    % Interactions
                    plotFcn.axesInteraction.CartesianToolbar(hAxes, {'datacursor', 'pan', 'restoreview'});
                    plotFcn.axesInteraction.CartesianDefaultInteractions(hAxes, [dataTipInteraction, regionZoomInteraction])
                    plotFcn.axesInteraction.InteractionsCallbacks({'Data Tips', 'Pan'}, hAxes, [])
                    plotFcn.axesInteraction.InteractionsCallbacks({'Restore View'}, hAxes, app)

                case 'Geographic'
                    hAxes = geoaxes(axesParent, FontSize=6, Units='pixels', Basemap='darkwater', ...
                                                Box='off', Interactions=[], ToolBar=[]);

                    hAxes.LatitudeLabel.String  = '';
                    hAxes.LongitudeLabel.String = '';

                    geolimits(hAxes, [-35 10], [-95, -15])
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
        function [xLim, yLim, zLim, xIndexLim, xArray] = Limits(SpecInfo, Parameters, yUnit)
            FreqStart     = SpecInfo.MetaData.FreqStart / 1e+6;
            FreqStop      = SpecInfo.MetaData.FreqStop  / 1e+6;
            DataPoints    = SpecInfo.MetaData.DataPoints;

            xArray        = round(linspace(FreqStart, FreqStop, DataPoints), 3);            

            switch Parameters.Plot.Type
                case 'Band'
                    FreqStartView = FreqStart;
                    FreqStopView  = FreqStop;
                    xIndexLim     = [1, DataPoints];

                case 'Emission'
                    emissionIndex = Parameters.Plot.emissionIndex;
                    if emissionIndex == -1
                        error('Unexpected value.')
                    end
    
                    emissionBW    = SpecInfo.UserData.Emissions.BW(emissionIndex)/1000;
                    xGuardBand    = Parameters.Axes.xGuardBandFactor * emissionBW;
    
                    FreqStartView = SpecInfo.UserData.Emissions.Frequency(emissionIndex) - (emissionBW + xGuardBand)/2;
                    FreqStopView  = SpecInfo.UserData.Emissions.Frequency(emissionIndex) + (emissionBW + xGuardBand)/2;
                    xIndexLim     = [plotFcn.axesDraw.freq2idx(SpecInfo, FreqStartView*1e+6, 'fix'), plotFcn.axesDraw.freq2idx(SpecInfo, FreqStopView*1e+6, 'ceil')];

                    xArray        = xArray(xIndexLim(1):xIndexLim(2));
            end

            xLim = [FreqStartView, FreqStopView];

            switch yUnit
                case {'ordinary level', 'persistance level'}
                    yLim = plotFcn.axesDraw.yzLimits(SpecInfo, yUnit, xIndexLim);
                    zLim = [-1, 1];
                case 'occupancy level'
                    yLim = [0, 100];
                    zLim = [-1, 1];
                case 'time'
                    yLim = [SpecInfo.Data{1}(1), SpecInfo.Data{1}(end)];
                    zLim = plotFcn.axesDraw.yzLimits(SpecInfo, yUnit, xIndexLim);
                case 'timeIndex'
                    yLim = [1, numel(SpecInfo.Data{1})];
                    zLim = [-1, 1];
            end
        end


        %-----------------------------------------------------------------%
        function yzLim = yzLimits(SpecInfo, yUnit, xIndexLim)
            yzLim  = [min(SpecInfo.Data{3}(xIndexLim(1):xIndexLim(2),1)), max(SpecInfo.Data{3}(xIndexLim(1):xIndexLim(2),end))];

            if ismember(yUnit, {'persistance level', 'time'})
                yzAmplitude = class.Constants.yMaxLimRange;

                yzLim(2)    = max(yzLim(1)+yzAmplitude, yzLim(2));
                yzLim(1)    = yzLim(2)-yzAmplitude;
            end
        end


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