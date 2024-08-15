function DeleteAll(app)

    cla(app.axes1)
    cla(app.axes2)
    cla(app.axes3)

    % Controle do tempo.
    app.timeIndex = 1;
    app.tool_TimestampSlider.Value = 0;

    % Controle dos handles.
    app.restoreView        = struct('ID', {}, 'xLim', {}, 'yLim', {}, 'cLim', {});

    app.line_ClrWrite      = [];
    app.line_MinHold       = [];
    app.line_Average       = [];
    app.line_MaxHold       = [];
    app.obj_Persistance    = [];

    app.mkr_ROI            = [];
    app.mkr_Label          = [];
    
    app.line_OCC           = [];
    app.line_OCCLabel      = [];
        
    app.img_WaterFall      = [];
    app.line_WaterFallTime = [];
end