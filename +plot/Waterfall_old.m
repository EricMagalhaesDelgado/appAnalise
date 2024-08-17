function Waterfall_old(app, idx, Type, LevelUnit)

    hComponents = findobj(app.play_WaterFallGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigrid', '-or', 'Type', 'uipanel'});

    switch Type
        case 'Creation'
            if app.tool_Waterfall.Value
                set(hComponents, Enable=1)
        
                if isempty(app.hWaterfall)
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
                    app.hWaterfall = mesh(app.UIAxes3, X, Y, app.specData(idx).Data{2}(:,1:Decimate:end)', 'MeshStyle', app.play_Waterfall_Interpolation.Value, 'SelectionHighlight', 'off', 'Tag', 'Waterfall');
                    plot.datatip.Template(app.hWaterfall, 'Frequency+Timestamp+Level', LevelUnit)
                    % view(app.UIAxes3, 0, 90);
                    
                    if strcmp(app.play_Waterfall_Timestamp.Value, 'on')
                        app.hWaterfallTime = line(app.UIAxes3, [app.bandObj.xArray(1), app.bandObj.xArray(end)], [app.specData(idx).Data{1}(app.idxTime), app.specData(idx).Data{1}(app.idxTime)], [app.UIAxes1.YLim(2) app.UIAxes1.YLim(2)], ...
                                                                'Color', 'red', 'LineWidth', 1, 'PickableParts', 'none', 'Tag', 'WaterfallTime');
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
            
            app.hWaterfall      = [];
            app.hWaterfallTime = [];
            
            set(hComponents, Enable=0)
    end
end