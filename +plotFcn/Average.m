function Average(app, idx, newArray, LevelUnit)
    
    if isinf(app.General.Integration.Trace)
        app.line_Average = plot(app.axes1, app.Band.xArray, app.specData(idx).Data{3}(:,2), Color=app.General.Colors(2,:), Tag='Average');
    else
        app.line_Average = plot(app.axes1, app.Band.xArray, newArray, Color=app.General.Colors(2,:), Tag='Average');
    end

    plotFcn.DataTipModel(app.line_Average, LevelUnit)
end