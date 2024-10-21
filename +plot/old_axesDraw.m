classdef (Abstract) old_axesDraw

    methods (Static = true)
        %-----------------------------------------------------------------%
        % EIXO CARTESIANO: CONTROLE
        %-----------------------------------------------------------------%
        function cartesianAxes__type1(hAxes, specData, idxThread, tempBandObj, Parameters)          % Spectrum
            MinHold  = Parameters.MinHold;
            Average  = Parameters.Average;
            MaxHold  = Parameters.MaxHold;
            ROI      = Parameters.EmissionROI;
            Axes     = Parameters.Axes;

            % PRÉ-PLOT
            [xLim, yLim, xIndexLim, xArray] = plot.old_axesDraw.Limits(tempBandObj, idxThread);
            plot.old_prePlotConfiguration(hAxes, xLim, yLim, 'linear')
        
            % PLOT
            plot.old_axesDraw.OrdinaryPlot(hAxes, specData(idxThread), xIndexLim, xArray, yLim, 'MinHold', MinHold)
            plot.old_axesDraw.OrdinaryPlot(hAxes, specData(idxThread), xIndexLim, xArray, yLim, 'Average', Average)
            plot.old_axesDraw.OrdinaryPlot(hAxes, specData(idxThread), xIndexLim, xArray, yLim, 'MaxHold', MaxHold)            
            plot.old_axesDraw.BandLimitsPlot(hAxes, specData(idxThread))
            plot.old_axesDraw.EmissionPlot(hAxes, specData(idxThread), yLim, ROI)            
            plot.old_axesDraw.ThresholdPlot(hAxes, specData(idxThread), xArray)

            plot.axes.StackingOrder.execute(hAxes, 'appAnalise:REPORT')

            % PÓS-PLOT
            plot.old_axesDraw.PostPlotConfig(hAxes, specData(idxThread), Axes, 'Frequência (MHz)', ['Nível (' specData(idxThread).MetaData.LevelUnit ')'])
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type2(hAxes, specData, idxThread, tempBandObj, Parameters)          % Persistance
            Average     = Parameters.Average;
            EmissionROI = Parameters.EmissionROI;
            Persistance = Parameters.Persistance;
            Axes        = Parameters.Axes;
            
            % PRÉ-PLOT
            [xLim, yLim, xIndexLim, xArray] = plot.old_axesDraw.Limits(tempBandObj, idxThread);
            plot.old_prePlotConfiguration(hAxes, xLim, yLim, 'linear', Persistance.Colormap)
            
            % PLOT
            plot.Persistance('Creation', [], hAxes, tempBandObj, idxThread);
            plot.old_axesDraw.OrdinaryPlot(hAxes, specData(idxThread), xIndexLim, xArray, yLim, 'Average', Average)
            plot.old_axesDraw.BandLimitsPlot(hAxes, specData(idxThread))
            plot.old_axesDraw.EmissionPlot(hAxes, specData(idxThread), yLim, EmissionROI);            
            plot.old_axesDraw.ThresholdPlot(hAxes, specData(idxThread), xArray)

            plot.axes.StackingOrder.execute(hAxes, 'appAnalise:REPORT')

            % PÓS-PLOT
            plot.old_axesDraw.PostPlotConfig(hAxes, specData(idxThread), Axes, 'Frequência (MHz)', ['Nível (' specData(idxThread).MetaData.LevelUnit ')'])
        end


        %-----------------------------------------------------------------%
        function cartesianAxes__type3(hAxes, specData, idxThread, tempBandObj, Parameters)          % OccupancyPerBin
            occMinHold = Parameters.occMinHold;
            occAverage = Parameters.occAverage;
            occMaxHold = Parameters.occMaxHold;
            Axes       = Parameters.Axes;

            % PRÉ-PLOT
            [xLim, yLim, xIndexLim, xArray] = plot.old_axesDraw.Limits(tempBandObj, idxThread);
            plot.old_prePlotConfiguration(hAxes, xLim, yLim, 'log')
        
            % PLOT
            plot.old_axesDraw.OccupancyPerBinPlot(hAxes, specData(idxThread), xIndexLim, xArray, 'occMinHold', occMinHold)
            plot.old_axesDraw.OccupancyPerBinPlot(hAxes, specData(idxThread), xIndexLim, xArray, 'occAverage', occAverage)
            plot.old_axesDraw.OccupancyPerBinPlot(hAxes, specData(idxThread), xIndexLim, xArray, 'occMaxHold', occMaxHold)

            % PÓS-PLOT
            plot.old_axesDraw.PostPlotConfig(hAxes, specData(idxThread), Axes, 'Frequência (MHz)', 'Ocupação (%)')
        end


        %-----------------------------------------------------------------%
        % EIXO CARTESIANO: PLOT
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
            plot.datatip.Template(p, 'Frequency+Level', SpecInfo.MetaData.LevelUnit)
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
            occData(occData==0) = .1;

            switch Occupancy.Fcn
                case 'line'
                    p = plot(hAxes, xArray, occData(xIndexLim(1):xIndexLim(2)), 'Tag', plotMode, 'LineStyle', Occupancy.LineStyle, 'LineWidth', Occupancy.LineWidth, 'Color', Occupancy.EdgeColor);
                case 'area'
                    p = area(hAxes, xArray, occData(xIndexLim(1):xIndexLim(2)), 'Tag', plotMode, 'LineStyle', Occupancy.LineStyle, 'LineWidth', Occupancy.LineWidth, 'EdgeColor', Occupancy.EdgeColor, 'FaceColor', Occupancy.FaceColor, 'BaseValue', .1);
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


        %-----------------------------------------------------------------%
        % FUNÇÕES AUXILIARES
        %-----------------------------------------------------------------%
        function [imgFileName, hContainer] = plot2report(hContainer, specData, idxThread, tempBandObj, reportInfo, plotInfo)
            % Limpa container.
            if ~isempty(hContainer.Children)
                delete(hContainer.Children)
            end

            % Criação dos eixos e disposição no layout indicado no JSON do
            % modelo do relatório.
            if strcmp(reportInfo.General.Parameters.Plot.Type, 'Emission')
                idxDriveTest = find(strcmp({plotInfo.Name}, 'DriveTest'));
                idxEmission  = reportInfo.General.Parameters.Plot.emissionIndex;
                
                if ~isempty(idxDriveTest) && isempty(specData(idxThread).UserData.Emissions.UserData(idxEmission).DriveTest)
                    plotInfo(idxDriveTest) = [];
                end
            end

            if isempty(plotInfo)
                error('Empty plot list!')
            end

            tiledPos  = 1;
            tiledSpan = [plotInfo.Layout];

            t = tiledlayout(hContainer, sum(tiledSpan), 1, "Padding", "tight", "TileSpacing", "tight");
           
            [axesType, axesXLabel] = plot.axes.axesTypeMapping({plotInfo.Name});

            for ii = 1:numel(plotInfo)
                switch plotInfo(ii).Name
                    case 'DriveTest'
                        Parameters = reportInfo.General.Parameters.DriveTest;
                    
                    otherwise
                        Parameters = reportInfo.General.Parameters;
                end

                xTickFlag = true;

                switch axesType{ii}
                    case 'Geographic'
                        hAxes = plot.axes.Creation(t, 'Geographic');

                    case 'Cartesian'
                        hAxes = plot.axes.Creation(t, 'Cartesian', {'XColor', [.15,.15,.15], 'YColor', [.15,.15,.15]});
                        if (numel(plotInfo) > 1) && (ii < numel(plotInfo)) && any(strcmp(axesType(2:end), 'Cartesian'))
                            xTickFlag = false;
                        end
                end

                hAxes.Layout.Tile     = tiledPos;
                hAxes.Layout.TileSpan = [tiledSpan(ii) 1];

                cla(hAxes)
                switch plotInfo(ii).Name
                    case 'Spectrum'
                        plot.old_axesDraw.cartesianAxes__type1(hAxes, specData, idxThread, Parameters)
                    
                    case 'Persistance'
                        plot.old_axesDraw.cartesianAxes__type2(hAxes, specData, idxThread, tempBandObj, Parameters)
                    
                    case 'OccupancyPerBin'
                        plot.old_axesDraw.cartesianAxes__type3(hAxes, specData, idxThread, Parameters)
                    
                    case 'Waterfall'
                        plot.Waterfall('Creation', hAxes, tempBandObj, idxThread);

                    case 'DriveTest'
                        plot.old_axesDraw.geographicAxes_type1(hAxes, Parameters, 'ReportGenerator')

                    case 'DriveTestRoute'
                        plot.old_axesDraw.geographicAxes_type2(hAxes, Parameters)
                end

                if xTickFlag
                    xlabel(hAxes, axesXLabel{ii})
                else
                    hAxes.XTickLabel = {};
                    xlabel(hAxes, '')
                end
                tiledPos = tiledPos+tiledSpan(ii);
            end

            % Espera renderizar e salva a imagem...
            defaultFilename = class.Constants.DefaultFileName(reportInfo.General.UserPath, sprintf('Image_ID%d', specData(idxThread).RelatedFiles.ID(1)), -1);
            imgFileName     = sprintf('%s.%s', defaultFilename, reportInfo.General.Image.Format);
            if ~strcmp(reportInfo.General.Version, 'Definitiva')
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
        function PostPlotConfig(hAxes, SpecInfo, Axes, xUnit, yUnit)
            % xyLabels
            if Axes.xLabel;     xlabel(hAxes, xUnit)
            else;               xlabel(hAxes, '')
            end

            if Axes.yLabel;     ylabel(hAxes, yUnit)
            else;               ylabel(hAxes, '')
            end

            % xyTicks
            [xTick, xTickLabel, yTick, yTickLabel] = plot.old_axesDraw.Tick(hAxes, SpecInfo);
            set(hAxes, 'XTick', xTick, 'YTick', yTick);

            if Axes.xTickLabel; hAxes.XTickLabel = xTickLabel;
            else;               hAxes.XTickLabel = {};
            end

            if Axes.yTickLabel; hAxes.YTickLabel = yTickLabel;
            else;               hAxes.YTickLabel = {};
            end
        end


        %-----------------------------------------------------------------%
        function [xLim, yLim, xIndexLim, xArray] = Limits(tempBandObj, idxThread)
            axesLimits  = Limits(tempBandObj, idxThread);
            
            xLim        = axesLimits.xLim;
            yLim        = axesLimits.yLevelLim;
            xIndexLim   = axesLimits.xIndexLimits;
            xArray      = tempBandObj.xArray;
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