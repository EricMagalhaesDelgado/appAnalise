function DeleteAll(app)

    cla(app.UIAxes1)
    cla(app.UIAxes2)
    cla(app.UIAxes3)

    app.restoreView = struct('ID', {}, 'xLim', {}, 'yLim', {}, 'cLim', {});
    app.timeIndex = 1;
    app.tool_TimestampSlider.Value = 0;

    app.hClearWrite       = [];
    app.hMinHold          = [];
    app.hAverage          = [];
    app.hMaxHold          = [];
    app.hPersistanceObj   = [];

    app.hSelectedEmission = [];
    app.hEmissionMarkers  = [];
    
    app.hTHR              = [];
    app.hTHRLabel         = [];
        
    app.hWaterfall        = [];
    app.hWaterfallTime    = [];
end