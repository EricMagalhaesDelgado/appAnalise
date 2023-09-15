function Average(app, idx, newArray, LevelUnit)
    
    switch app.play_TraceIntegration.Value
        case 'Inf'
            app.line_Average = plot(app.axes1, app.xArray, app.specData(idx).Data{3}(:,2), Color=app.General.Colors(2,:), Tag='Average');
        otherwise
            app.line_Average = plot(app.axes1, app.xArray, newArray, Color=app.General.Colors(2,:), Tag='Average');
    end

    plotFcn.DataTipModel(app.line_Average, LevelUnit)
end