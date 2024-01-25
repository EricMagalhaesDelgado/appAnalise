function maxHold(app, idx, newArray, LevelUnit)
    
    if isinf(app.General.Integration.Trace)
        app.line_MaxHold = plot(app.axes1, app.Band.xArray, app.specData(idx).Data{3}(:,3), Color=app.General.Plot.MaxHold.EdgeColor, Tag='MaxHold');
    else
        app.line_MaxHold = plot(app.axes1, app.Band.xArray, newArray, Color=app.General.Plot.MaxHold.EdgeColor, Tag='MaxHold');
    end

    plotFcn.DataTipModel(app.line_MaxHold, LevelUnit)
    plotFcn.axesStackingOrder.execute('winAppAnalise', app.axes1)
end