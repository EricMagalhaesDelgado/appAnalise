function OCC_old(app, idx, Type, occIndex)

    switch Type
        case 'Creation'
            if app.tool_Occupancy.Value
                DeleteLines(app)

                xArray  = app.bandObj.xArray;

                occInfo = app.specData(idx).UserData.occCache(occIndex).Info;
                occTHR  = app.specData(idx).UserData.occCache(occIndex).THR;
                occData = app.specData(idx).UserData.occCache(occIndex).Data;

                % app.UIAxes1
                switch occInfo.Method
                    case 'Linear fixo (COLETA)'
                        hPlotAxes1    = plot(app.UIAxes1, [xArray(1), xArray(end)], [occTHR, occTHR], Color='red', LineStyle='-', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='red', MarkerEdgeColor='black', Tag='occTHR');

                    case 'Linear fixo'
                        hPlotAxes1    = images.roi.Line(app.UIAxes1,'Position',[xArray(1) occTHR; xArray(end) occTHR], 'Color', 'red', 'MarkerSize', 4, 'Deletable', 0, 'LineWidth', 1, 'InteractionsAllowed', 'translate', 'Tag', 'occTHR');
                        
                        addlistener(hPlotAxes1, 'MovingROI', @(src,evt)occLineROI(src,evt,app));
                        addlistener(hPlotAxes1, 'ROIMoved',  @(src,evt)occLineROI(src,evt,app));
    
                    case 'Linear adaptativo'                        
                        [minTHR, maxTHR] = bounds(occTHR);

                        hPlotAxes1(1) = plot(app.UIAxes1, [xArray(1), xArray(end)], [minTHR, minTHR], Color='red', LineStyle='-.', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='red', MarkerEdgeColor='black', Tag='occTHR');
                        hPlotAxes1(2) = plot(app.UIAxes1, [xArray(1), xArray(end)], [maxTHR, maxTHR], Color='red', LineStyle='-.', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='red', MarkerEdgeColor='black', Tag='occTHR');

                    case 'Envoltória do ruído'
                        hPlotAxes1    = plot(app.UIAxes1, xArray, occTHR, Color='red', LineStyle='-', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=[1, numel(xArray)], MarkerFaceColor='r', MarkerEdgeColor='black', Tag='occTHR');
                end

                % app.UIAxes2
                % O modo PLAYBACK das primeiras versões do appAnalise apresenta, 
                % no app.UIAxes2, as curvas de média e máximo da ocupação por bin, 
                % aferida de forma "online". Nessa nova versão do appAnalise, por
                % outro lado, será apresentada apenas a curva de média.
                set(app.UIAxes2, XLim=app.UIAxes1.XLim, YLim=[0, 100])
                hPlotAxes2 = plot(app.UIAxes2, app.bandObj.xArray, occData{3}(:,2), Color=app.General.Plot.ClearWrite.EdgeColor, Tag='occData_Mean');

                % DataTip
                DataTip(hPlotAxes1, app.bandObj.LevelUnit)
                DataTip(hPlotAxes2, '%%')
            end

        case 'Delete'
            DeleteLines(app)
    end
end


%-------------------------------------------------------------------------%
function DeleteLines(app)
    delete(findobj(app.UIAxes1, 'Tag', 'occTHR'))
    cla(app.UIAxes2)
end


%-------------------------------------------------------------------------%
function DataTip(hPlot, LevelUnit)
    for ii = 1:numel(hPlot)
        plot.datatip.Template(hPlot(ii), 'Frequency+Level', LevelUnit)
    end
end


%-------------------------------------------------------------------------%
function occLineROI(src, event, app)
    switch(event.EventName)
        case 'MovingROI'
            plot.axes.Interactivity.DefaultDisable([app.UIAxes1, app.UIAxes2, app.UIAxes3])
            app.play_OCC_THR.Value = event.CurrentPosition(1,2);
            
        case 'ROIMoved'
            plot.axes.Interactivity.DefaultEnable([app.UIAxes1, app.UIAxes2, app.UIAxes3])
            play_OCCNewPlot(app)
    end
end