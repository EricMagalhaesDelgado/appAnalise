function maxHold(app, idx, newArray, LevelUnit)
    
    if isinf(app.General.Integration.Trace)
        app.line_MaxHold = plot(app.axes1, app.Band.xArray, app.specData(idx).Data{3}(:,3), Color=app.General.Colors(3,:), Tag='MaxHold');
    else
        app.line_MaxHold = plot(app.axes1, app.Band.xArray, newArray, Color=app.General.Colors(3,:), Tag='MaxHold');
    end

    plotFcn.DataTipModel(app.line_MaxHold, LevelUnit)
end