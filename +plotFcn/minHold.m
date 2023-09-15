function minHold(app, idx, newArray, LevelUnit)
    
    switch app.play_TraceIntegration.Value
        case 'Inf'
            app.line_MinHold = plot(app.axes1, app.xArray, app.specData(idx).Data{3}(:,1), Color=app.General.Colors(1,:), Tag='MinHold');
        otherwise
            app.line_MinHold = plot(app.axes1, app.xArray, newArray, Color=app.General.Colors(1,:), Tag='MinHold');
    end

    plotFcn.DataTipModel(app.line_MinHold, LevelUnit)
end