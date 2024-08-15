classdef (Abstract) draw3D

    methods (Static = true)
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


        %---------------------------------------------------------------------%
        function hPersistanceObj = Persistance(hPersistanceObj, hAxes, specData, bandObj, defaultProperties, customProperties, plotTag, operationType)
            arguments
                hPersistanceObj
                hAxes
                specData
                bandObj
                defaultProperties
                customProperties
                plotTag
                operationType
            end

            [plotConfig, Samples, Colormap, Transparency, LevelLimits] = plot.Config(plotTag, defaultProperties, customProperties);
            
            nSweeps = numel(specData.Data{1});
            xArray  = bandObj.xArray';

            switch operationType
                case 'Creation'
                    DataPoints  = numel(bandObj.xArray);
                    FreqStart   = bandObj.FreqStart;
                    FreqStop    = bandObj.FreqStop;
    
                    xResolution = min(801, DataPoints);
                    yResolution = 201;
        
                    ySamples      = str2double(Samples);
                    if isnan(ySamples)
                        ySamples  = nSweeps;
                    end
            
                    yAmplitude    = class.Constants.yMaxLimRange;
                    [yMin, yMax]  = bounds(specData.Data{2}, 'all');
                    yMax          = max(yMin+yAmplitude, yMax);
                    yMin          = yMax-yAmplitude;
                    
                    xEdges        = linspace(FreqStart, FreqStop, xResolution+1);
                    yEdges        = linspace(yMin, yMax, yResolution+1);
                    specHist      = zeros(yResolution, xResolution);
    
                    hPersistance  = image(hAxes, specHist, 'AlphaData', specHist,'XData', [FreqStart, FreqStop], 'YData', [yMin, yMax], plotConfig{:});
                    
                    hPersistanceObj = struct('handle',   hPersistance, ...
                                             'ySamples', ySamples,     ...
                                             'xEdges',   xEdges,       ...
                                             'yEdges',   yEdges);
    
                    plot.draw3D.Persistance(hPersistanceObj, hAxes, specData, bandObj, defaultProperties, customProperties, plotTag, 'Update')
    
                case 'Update'
                    switch Samples
                        case 'full'
                            specHist = histcounts2(specData.Data{2}, repmat(xArray, 1, nSweeps), hPersistanceObj.yEdges, hPersistanceObj.xEdges);    
                            set(hPersistanceObj.handle, 'CData', (100 * specHist ./ sum(specHist)), 'AlphaData', double(logical(specHist))*Transparency)
    
                        otherwise
                            idx2 = app.timeIndex;
                            idx1 = idx2 - (hPersistanceObj.ySamples-1);
                            if idx1 < 1
                                idx1 = 1;
                            end            
                            
                            specHist = histcounts2(specData.Data{2}(:, idx1:idx2), repmat(xArray, 1, idx2-idx1+1), hPersistanceObj.yEdges, hPersistanceObj.xEdges);    
                            set(hPersistanceObj.handle, 'CData', (100 * specHist ./ sum(specHist)), 'AlphaData', double(logical(specHist))*Transparency)
                    end
            end
        end


        %-----------------------------------------------------------------%
        function Waterfall(app, idx, Type, LevelUnit)
            hComponents = findobj(app.play_WaterFallGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigrid', '-or', 'Type', 'uipanel'});
        
            switch Type
                case 'Creation'
                    if app.tool_Waterfall.Value
                        set(hComponents, Enable=1)
                
                        if isempty(app.hWaterFall)
                            DataPoints = app.specData(idx).MetaData.DataPoints;
                            nSweeps    = numel(app.specData(idx).Data{1});
                
                            % Definição do fator inicial de decimação de amostras para desenho
                            % do WaterFall.
                            switch app.play_Waterfall_Decimation.Value
                                case 'auto'
                                    nWaterFallPoints     = DataPoints*nSweeps;
                                    nMaxWaterFallPoints = class.Constants.nMaxWaterFallPoints;
                    
                                    if nWaterFallPoints > nMaxWaterFallPoints
                                        Decimate = ceil(nWaterFallPoints/nMaxWaterFallPoints);
                                    else
                                        Decimate = 1;
                                    end
                
                                otherwise
                                    Decimate = str2double(app.play_Waterfall_Decimation.Value);
                            end
                
                            % Ajuste do fator de decimação, de forma que após aplicação desse
                            % fator reste ao menos duas varreduras.    
                            while true
                                t = app.specData(idx).Data{1}(1:Decimate:end);
                                if numel(t) > 1; break
                                else;            Decimate = round(Decimate/2);
                                end
                            end
        
                            switch app.play_Waterfall_Decimation.Value
                                case 'auto'
                                    set(app.play_Waterfall_DecimationValue, Visible=1, Text=num2str(Decimate))
        
                                otherwise
                                    set(app.play_Waterfall_DecimationValue, Visible=0)
                                    app.play_Waterfall_Decimation.Value = num2str(Decimate);
                            end
                    
                            if t(1) == t(end)
                                t(end) = t(1)+seconds(1);
                            end
                
                            % Grid            
                            [X, Y] = meshgrid(app.bandObj.xArray, t);
                    
                            app.UIAxes3.CLimMode = 'auto';
                            app.hWaterFall = mesh(app.UIAxes3, X, Y, app.specData(idx).Data{2}(:,1:Decimate:end)', 'MeshStyle', app.play_Waterfall_Interpolation.Value, 'SelectionHighlight', 'off', 'Tag', 'WaterFall');
                            plot.datatip.Model(app.hWaterFall, LevelUnit)
                            view(app.UIAxes3, 0, 90);
                            
                            if strcmp(app.play_Waterfall_Timestamp.Value, 'on')
                                app.hWaterFallTime = line(app.UIAxes3, [app.bandObj.xArray(1), app.bandObj.xArray(end)], [app.specData(idx).Data{1}(app.timeIndex), app.specData(idx).Data{1}(app.timeIndex)], [app.UIAxes11.YLim(2) app.UIAxes11.YLim(2)], ...
                                                                        'Color', 'red', 'LineWidth', 1, 'PickableParts', 'none', 'Tag', 'WaterFall_time');
                            end
                            
                            tTickLabel    = linspace(t(1), t(end), 3);
                            [~, tIndex]   = min(abs(app.specData(idx).Data{1} - tTickLabel(2)));
                            tTickLabel(2) = app.specData(idx).Data{1}(tIndex);
                    
                            set(app.UIAxes3, 'YLim' , [t(1), t(end)], 'YTick', tTickLabel, 'YTickLabel', [1, round(tIndex), nSweeps])
                    
                            % Colors limits
                            app.UIAxes3.CLim(2)  = round(app.UIAxes3.CLim(2));
                            app.UIAxes3.CLim(1)  = round(app.UIAxes3.CLim(2) - diff(app.UIAxes3.CLim)/2);
        
                            app.restoreView(3).yLim = app.UIAxes3.YLim;
                            app.restoreView(3).cLim = app.UIAxes3.CLim;            
                            app.play_Waterfall_cLim1.Value = app.UIAxes3.CLim(1);
                            app.play_Waterfall_cLim2.Value = app.UIAxes3.CLim(2);
                        end   
                        
                    else
                        set(hComponents, Enable=0)
                    end
        
                %-----------------------------------------------------------------%
                case 'Delete'
                    cla(app.UIAxes3)
                    
                    app.hWaterFall      = [];
                    app.hWaterFallTime = [];
                    
                    set(hComponents, Enable=0)
            end
        end
    end
end