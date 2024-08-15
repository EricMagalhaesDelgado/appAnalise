classdef (Abstract) draw2D

    methods (Static = true)
        %-----------------------------------------------------------------%
        function hLine = OrdinaryPlot(hAxes, xArray, yArray, defaultProperties, customProperties, plotTag)
            arguments
                hAxes
                xArray
                yArray
                defaultProperties % "GeneralSettings.json"
                customProperties
                plotTag
            end

            [plotType, plotConfig] = plot.Config(plotTag, defaultProperties, customProperties);
            
            switch plotType
                case 'line'
                    hLine = plot(hAxes, xArray, yArray, plotConfig{:});
                case 'area'
                    hLine = area(hAxes, xArray, yArray, 'BaseValue', hAxes.YLim(1), plotConfig{:});
            end
        end


        %-----------------------------------------------------------------%
        function OrdinatyPlotUpdate(hLine, yArray, plotTag, varargin)
            arguments
                hLine
                yArray
                plotTag
            end

            arguments (Repeating)
                varargin
            end

            switch plotTag
                case 'ClearWrite'
                    hLine.YData = yArray;
                case 'MinHold'
                    hLine.YData = min(hLine.YData, yArray);
                case 'Average'
                    integrationFactor = varargin{1};
                    hLine.YData = ((integrationFactor-1)*hLine.YData + yArray) / integrationFactor;
                case 'MaxHold'
                    hLine.YData = max(hLine.YData, yArray);
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
            occData(occData==0) = .1;

            switch Occupancy.Fcn
                case 'line'
                    p = plot(hAxes, xArray, occData(xIndexLim(1):xIndexLim(2)), 'Tag', plotMode, 'LineStyle', Occupancy.LineStyle, 'LineWidth', Occupancy.LineWidth, 'Color', Occupancy.EdgeColor);
                case 'area'
                    p = area(hAxes, xArray, occData(xIndexLim(1):xIndexLim(2)), 'Tag', plotMode, 'LineStyle', Occupancy.LineStyle, 'LineWidth', Occupancy.LineWidth, 'EdgeColor', Occupancy.EdgeColor, 'FaceColor', Occupancy.FaceColor, 'BaseValue', .1);
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
                    drawrectangle(hAxes, 'Position', [pks.Frequency(ii)-pks.BW(ii)/2000, yLim(1)+1, pks.BW(ii)/1000, diff(yLim)-2],                   ...
                                         'Color', ROI.Color, 'EdgeAlpha', ROI.EdgeAlpha, 'FaceAlpha', ROI.FaceAlpha, 'MarkerSize', 5, 'LineWidth', 1, ...
                                         'Deletable', 0, 'InteractionsAllowed', 'none', 'Tag', 'mkrROI');
                end

                NN = height(pks);
                pksLabel = string((1:NN)'); % Opcionalmente: "P_" + string((1:NN)')
                text(hAxes, pks.Frequency, repmat(yLim(1)+ROI.yPosition, NN, 1), pksLabel, ...
                           'Color', ROI.TextColor, 'BackgroundColor', ROI.Color,           ...
                           'FontSize', ROI.TextFontSize, 'FontWeight', 'bold',             ...
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
        function ClearWrite(app, idx, plotType, selectedEmission)
            switch plotType
                case 'InitialPlot'
                    newArray  = app.specData(idx).Data{2}(:,app.timeIndex)';
        
                    app.line_ClrWrite = plot(app.UIAxes1, app.bandObj.xArray, newArray, Color=app.General.Plot.ClearWrite.EdgeColor, ...
                                                                                   Marker='.',                             ...
                                                                                   MarkerIndices=[],                       ...
                                                                                   MarkerFaceColor=[0.40,0.73,0.88],       ...
                                                                                   MarkerEdgeColor=[0.40,0.73,0.88],       ...
                                                                                   MarkerSize=14,                          ...
                                                                                   Visible=app.play_LineVisibility.Value,  ...
                                                                                   Tag='ClearWrite');
                    plot.datatip.Model(app.line_ClrWrite, app.bandObj.LevelUnit)
        
                    case 'TreeSelectionChanged'
                        idx2 = app.play_FindPeaks_Tree.SelectedNodes.NodeData;
                        app.mkr_ROI.Position(:, [1, 3]) = [app.specData(idx).UserData.Emissions.Frequency(idx2) - app.specData(idx).UserData.Emissions.BW(idx2)/(2*1000), ...
                                                           app.specData(idx).UserData.Emissions.BW(idx2)/1000];
                        return
                    
                    case 'PeakValueChanged'
                        delete(findobj('Tag', 'mkrTemp', '-or', 'Tag', 'mkrLine', '-or', 'Tag', 'mkrLabels'))
        
                    case 'DeleteButtonPushed'
                        delete(findobj('Tag', 'mkrTemp', '-or', 'Tag', 'mkrLine', '-or', 'Tag', 'mkrLabels', '-or', 'Tag', 'mkrROI'))
                        
                        app.mkr_ROI   = [];
                        app.mkr_Label = [];
            end
        
            % Processing...
            play_EmissionList(app, idx, selectedEmission)
        
            if isempty(app.specData(idx).UserData.Emissions)
                app.line_ClrWrite.MarkerIndices = [];
        
            else
                app.line_ClrWrite.MarkerIndices = app.specData(idx).UserData.Emissions.Index;
        
                yLevel1   = app.restoreView(1).yLim(1) + 1;
                yLevel2   = diff(app.restoreView(1).yLim) - 2;
        
                mkrLabels = {};
                for ii = 1:height(app.specData(idx).UserData.Emissions)
                    mkrLabels = [mkrLabels {['  ' num2str(ii)]}];
        
                    FreqStart = app.specData(idx).UserData.Emissions.Frequency(ii) - app.specData(idx).UserData.Emissions.BW(ii)/(2*1000);
                    FreqStop  = app.specData(idx).UserData.Emissions.Frequency(ii) + app.specData(idx).UserData.Emissions.BW(ii)/(2*1000);
                    BW        = app.specData(idx).UserData.Emissions.BW(ii)/1000;            
                    
                    % Cria uma linha por emissão, posicionando-o na parte inferior
                    % do plot.
                    line(app.UIAxes1, [FreqStart, FreqStop], [yLevel1, yLevel1], ...
                                    Color=[0.40,0.73,0.88], LineWidth=1, ...
                                    Marker='.',             MarkerSize=14, ...
                                    PickableParts='none',   Tag='mkrLine')
        
                    % Cria um ROI para a emissão selecionada, posicionando-o em
                    % todo o plot.
                    if ii == selectedEmission
                        newPosition = [FreqStart, yLevel1, ...
                                       BW,        yLevel2];
                        
                        if isempty(app.mkr_ROI)
                            app.mkr_ROI = images.roi.Rectangle(app.UIAxes1, Position=newPosition,   ...
                                                                          Color=[0.40,0.73,0.88], ...
                                                                          MarkerSize=5,           ...
                                                                          Deletable=0,            ...
                                                                          FaceSelectable=0,       ...
                                                                          LineWidth=1,            ...
                                                                          Tag='mkrROI');
                
                            addlistener(app.mkr_ROI, 'MovingROI', @(src, evt)mkrLineROI(src, evt, app, idx));
                            addlistener(app.mkr_ROI, 'ROIMoved',  @(src, evt)mkrLineROI(src, evt, app, idx));
        
                        else
                            app.mkr_ROI.Position = newPosition;
                        end
                    end
                end
        
                app.mkr_Label = text(app.UIAxes1, app.specData(idx).UserData.Emissions.Frequency, double(app.specData(idx).Data{2}(app.specData(idx).UserData.Emissions.Index, app.timeIndex)), mkrLabels, ...
                                                     Color=[0.40,0.73,0.88], FontSize=11, FontWeight='bold', FontName='Helvetica', FontSmoothing='on', Tag='mkrLabels', Visible=app.play_LineVisibility.Value);
            end
        end
        
        
        %-------------------------------------------------------------------------%
        function mkrLineROI(src, evt, app, idx1)
        
            switch(evt.EventName)
                case 'MovingROI'
                    plotFcn.axesInteraction.DisableDefaultInteractions([app.UIAxes1, app.UIAxes2, app.UIAxes3])
        
                    FreqCenter = app.mkr_ROI.Position(1) + app.mkr_ROI.Position(3)/2;
                    if (FreqCenter*1e+6 < app.specData(idx1).MetaData.FreqStart) || ...
                       (FreqCenter*1e+6 > app.specData(idx1).MetaData.FreqStop)
                    
                       return
                    end
        
                    app.play_FindPeaks_PeakCF.Value = round(FreqCenter, 3);
                    app.play_FindPeaks_PeakBW.Value = round(app.mkr_ROI.Position(3) * 1000, 3);
        
                    idx2 = app.play_FindPeaks_Tree.SelectedNodes(1).NodeData;
                    app.line_ClrWrite.MarkerIndices(idx2) = round((app.play_FindPeaks_PeakCF.Value*1e+6 - app.bandObj.bCoef)/app.bandObj.aCoef);
                    
                    % Se tiver apenas um marcador, então a string fica como
                    % cell. Caso tenha mais de um marcador, então a string
                    % fica como char.
                    markerTag = findobj('Type', 'Text', 'String', sprintf('  %d', idx2));
                    if isempty(markerTag)
                        markerTag = findobj('Type', 'Text', 'String', {sprintf('  %d', idx2)});
                    end
                    markerTag.Position(1:2) = [app.play_FindPeaks_PeakCF.Value, app.line_ClrWrite.YData(app.line_ClrWrite.MarkerIndices(idx2))];
                    
                    set(app.play_FindPeaks_Tree.Children(idx2), 'Text', sprintf("%d: %.3f MHz ⌂ %.3f kHz", idx2, app.play_FindPeaks_PeakCF.Value, app.play_FindPeaks_PeakBW.Value), ...
                                                                'NodeData', idx2)
                    
                case 'ROIMoved'
                    plotFcn.axesInteraction.EnableDefaultInteractions([app.UIAxes1, app.UIAxes2, app.UIAxes3])
        
                    idx2 = app.play_FindPeaks_Tree.SelectedNodes(1).NodeData;            
                    newIndex = round((app.play_FindPeaks_PeakCF.Value*1e+6 - app.bandObj.bCoef)/app.bandObj.aCoef);
        
                    emissionInfo = jsondecode(app.specData(idx1).UserData.Emissions.Detection{idx2});
                    emissionInfo.Algorithm = 'Manual';
                    
                    app.specData(idx1).UserData.Emissions(idx2,[1:3, 5]) = {newIndex, app.play_FindPeaks_PeakCF.Value, app.play_FindPeaks_PeakBW.Value, jsonencode(emissionInfo)};
                    play_BandLimits_updateEmissions(app, idx1, newIndex)
                    play_UpdatePeaksTable(app, idx1)
            end
        end
    end
end

