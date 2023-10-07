function OCC(app, idx, Type, LevelUnit, occIndex)

    switch Type
        case 'Creation'
            if app.play_Occupancy.Value
                xArray  = app.Band.xArray;

                occInfo = app.specData(idx).UserData.OCC(occIndex).Info;
                occTHR  = app.specData(idx).UserData.OCC(occIndex).THR;
                occData = app.specData(idx).UserData.OCC(occIndex).Data;

                % Plot a ser realizado no app.axes1, apresentando o threshold.

                switch occInfo.Method
                    case 'Linear fixo'
                        hPlotAxes1(1) = plot(app.axes1, [xArray(1), xArray(end)], [occTHR, occTHR], Color='red', LineStyle='-', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='r', MarkerEdgeColor='black', Tag='occTHR', Visible='off');
    
                    case 'Linear adaptativo'                        
                        [minTHR, maxTHR] = bounds(occTHR);

                        hPlotAxes1(1) = plot(app.axes1, [xArray(1), xArray(end)], [minTHR, minTHR], Color='red', LineStyle='-.', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='r', MarkerEdgeColor='black', Tag='occTHR', Visible='off');
                        hPlotAxes1(2) = plot(app.axes1, [xArray(1), xArray(end)], [maxTHR, maxTHR], Color='red', LineStyle='-.', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=1:2, MarkerFaceColor='r', MarkerEdgeColor='black', Tag='occTHR', Visible='off');

                    case 'Envoltória do ruído'
                        hPlotAxes1(1) = plot(app.axes1, xArray, occTHR, Color='red', LineStyle='-', LineWidth=1, Marker='o', MarkerSize=4, MarkerIndices=[1, numel(xArray)], MarkerFaceColor='r', MarkerEdgeColor='black', Tag='occTHR', Visible='off');
                end

                % Plot a ser realizado no app.axes2, apresentando os valores 
                % de média e máxima da ocupação ao longo da monitoração.
                
                set(app.axes2, XLim=app.axes1.XLim, YLim=[0, 100])

                hPlotAxes2(1) = plot(app.axes2, app.Band.xArray, occData{3}(:,3), Color=app.General.Colors(3,:), Tag='occData_MaxHold');
                hPlotAxes2(2) = plot(app.axes2, app.Band.xArray, occData{3}(:,2), Color=app.General.Colors(4,:), Tag='occData_Average');
                

                % DataTip
                DataTip(hPlotAxes1, LevelUnit)
                DataTip(hPlotAxes2, '%%')
            end

        case 'Delete'
            delete(findobj(app.axes1, 'Tag', 'occTHR'))
            cla(app.axes2)
    end
end


%-------------------------------------------------------------------------%
function DataTip(hPlot, LevelUnit)

    for ii = 1:numel(hPlot)
        plotFcn.DataTipModel(hPlot(ii), LevelUnit)
    end
end