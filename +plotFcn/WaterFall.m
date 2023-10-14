function WaterFall(app, idx, Type, LevelUnit)

    switch Type
        case 'Creation'
            hComponents = findobj(app.play_WaterFallGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigrid', '-or', 'Type', 'uipanel'});
            
            if app.play_Waterfall.Value
                set(hComponents, Enable=1)
        
                if isempty(app.img_WaterFall)
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
                    [X, Y] = meshgrid(app.Band.xArray, t);
            
                    app.axes3.CLimMode = 'auto';
                    app.img_WaterFall = mesh(app.axes3, X, Y, app.specData(idx).Data{2}(:,1:Decimate:end)', 'MeshStyle', app.play_Waterfall_Interpolation.Value, 'SelectionHighlight', 'off', 'Tag', 'WaterFall');
                    plotFcn.DataTipModel(app.img_WaterFall, LevelUnit)
                    view(app.axes3, 0, 90);
                    
                    if strcmp(app.play_Waterfall_Timestamp.Value, 'on')
                        app.line_WaterFallTime = line(app.axes3, [app.Band.xArray(1), app.Band.xArray(end)], [app.specData(idx).Data{1}(app.timeIndex), app.specData(idx).Data{1}(app.timeIndex)], [app.axes1.YLim(2) app.axes1.YLim(2)], ...
                                                                'Color', 'red', 'LineWidth', 1, 'PickableParts', 'none', 'Tag', 'WaterFall_time');
                    end
                    
                    tTickLabel    = linspace(t(1), t(end), 3);
                    [~, tIndex]   = min(abs(app.specData(idx).Data{1} - tTickLabel(2)));
                    tTickLabel(2) = app.specData(idx).Data{1}(tIndex);
            
                    set(app.axes3, 'YLim' , [t(1), t(end)], 'YTick', tTickLabel, 'YTickLabel', [1, round(tIndex), nSweeps])
            
                    % Colors limits
                    app.axes3.CLim(2)  = round(app.axes3.CLim(2));
                    app.axes3.CLim(1)  = round(app.axes3.CLim(2) - diff(app.axes3.CLim)/2);

                    app.restoreView(3) = {app.axes3.YLim};
                    app.restoreView(4) = {app.axes3.CLim};
            
                    app.play_Waterfall_cLim1.Value = app.axes3.CLim(1);
                    app.play_Waterfall_cLim2.Value = app.axes3.CLim(2);
                end   
                
            else
                set(hComponents, Enable=0)
            end

        %-----------------------------------------------------------------%
        case 'Delete'
            cla(app.axes3)
            
            app.img_WaterFall      = [];
            app.line_WaterFallTime = [];
    end
end