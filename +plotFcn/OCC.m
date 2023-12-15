function OCC(app, idx, Type, LevelUnit, occIndex)

    switch Type
        case 'Creation'
            if app.play_Occupancy.Value
                DeleteLines(app)

                xArray  = app.Band.xArray;

                occInfo = app.specData(idx).UserData.occCache(occIndex).Info;
                occTHR  = app.specData(idx).UserData.occCache(occIndex).THR;
                occData = app.specData(idx).UserData.occCache(occIndex).Data;

                % app.axes1
                switch occInfo.Method
                    case 'Linear fixo (COLETA)'
                        hPlotAxes1    = plot(app.axes1, [xArray(1), xArray(end)], [occTHR, occTHR], Color='red', LineStyle='-', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='red', MarkerEdgeColor='black', Tag='occTHR');

                    case 'Linear fixo'
                        hPlotAxes1    = images.roi.Line(app.axes1,'Position',[xArray(1) occTHR; xArray(end) occTHR], 'Color', 'red', 'MarkerSize', 4, 'Deletable', 0, 'LineWidth', 1, 'InteractionsAllowed', 'translate', 'Tag', 'occTHR');
                        
                        addlistener(hPlotAxes1, 'MovingROI', @(src,evt)occLineROI(src,evt,app));
                        addlistener(hPlotAxes1, 'ROIMoved',  @(src,evt)occLineROI(src,evt,app));
    
                    case 'Linear adaptativo'                        
                        [minTHR, maxTHR] = bounds(occTHR);

                        hPlotAxes1(1) = plot(app.axes1, [xArray(1), xArray(end)], [minTHR, minTHR], Color='red', LineStyle='-.', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='red', MarkerEdgeColor='black', Tag='occTHR');
                        hPlotAxes1(2) = plot(app.axes1, [xArray(1), xArray(end)], [maxTHR, maxTHR], Color='red', LineStyle='-.', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='red', MarkerEdgeColor='black', Tag='occTHR');

                    case 'Envoltória do ruído'
                        hPlotAxes1    = plot(app.axes1, xArray, occTHR, Color='red', LineStyle='-', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=[1, numel(xArray)], MarkerFaceColor='r', MarkerEdgeColor='black', Tag='occTHR');
                end

                % app.axes2
                % O modo PLAYBACK das primeiras versões do appAnalise apresenta, 
                % no app.axes2, as curvas de média e máximo da ocupação por bin, 
                % aferida de forma "online". Nessa nova versão do appAnalise, por
                % outro lado, será apresentada apenas a curva de média.
                set(app.axes2, XLim=app.axes1.XLim, YLim=[0, 100])
                hPlotAxes2 = plot(app.axes2, app.Band.xArray, occData{3}(:,2), Color=app.General.Colors(4,:), Tag='occData_Mean');

                % DataTip
                DataTip(hPlotAxes1, LevelUnit)
                DataTip(hPlotAxes2, '%%')
            end

        case 'Delete'
            DeleteLines(app)
    end
end


%-------------------------------------------------------------------------%
function DeleteLines(app)
    delete(findobj(app.axes1, 'Tag', 'occTHR'))
    cla(app.axes2)
end


%-------------------------------------------------------------------------%
function DataTip(hPlot, LevelUnit)
    for ii = 1:numel(hPlot)
        plotFcn.DataTipModel(hPlot(ii), LevelUnit)
    end
end


%-------------------------------------------------------------------------%
function occLineROI(src, event, app)
    switch(event.EventName)
        case 'MovingROI'
            plotFcn.axesInteraction.DisableDefaultInteractions([app.axes1, app.axes2, app.axes3])
            app.play_OCC_THR.Value = event.CurrentPosition(1,2);
            
        case 'ROIMoved'
            plotFcn.axesInteraction.EnableDefaultInteractions([app.axes1, app.axes2, app.axes3])
            play_OCCNewPlot(app)
    end
end