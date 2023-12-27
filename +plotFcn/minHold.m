function minHold(app, idx, newArray, LevelUnit)
    
    if isinf(app.General.Integration.Trace)
        app.line_MinHold = plot(app.axes1, app.Band.xArray, app.specData(idx).Data{3}(:,1), Color=app.General.Plot.MinHold.EdgeColor, Tag='MinHold');
    else
        app.line_MinHold = plot(app.axes1, app.Band.xArray, newArray, Color=app.General.Plot.MinHold.EdgeColor, Tag='MinHold');
    end

    plotFcn.DataTipModel(app.line_MinHold, LevelUnit)
    plotFcn.axesStackingOrder.execute('winAppAnalise', app.axes1)
end