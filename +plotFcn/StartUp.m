function StartUp(app, idx)

    cla(app.axes1)
    cla(app.axes2)
    cla(app.axes3)

    % Controle do tempo.
    app.timeIndex = 1;
    app.play_PlaybackSlider.Value = 0;

    % Controle dos handles.
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

    % Habilita/desabilita funcionalidades que dependem do número de
    % varreduradas.
    nSweeps = sum(app.specData(idx).RelatedFiles.nSweeps);
    if nSweeps > 2
        if ismember(app.specData(idx).MetaData.DataType, class.Constants.specDataTypes)
            set(app.play_Occupancy, Enable=1)
        else
            % Não tem sentido fazer uma análise de ocupação de um fluxo espectral 
            % de ocupação!
            set(app.play_Occupancy, Enable=0, Value=0)
        end

        app.play_Persistance.Enable = 1;
        app.play_Waterfall.Enable   = 1;

    else
        set(app.play_Persistance, Enable=0, Value=0)
        set(app.play_Occupancy,   Enable=0, Value=0)
        set(app.play_Waterfall,   Enable=0, Value=0)

        plotFcn.Persistance(app)
        plotFcn.OCC(app)
        plotFcn.WaterFall(app)
    end

    % Outros aspectos:
    app.play_PlotPanel.UserData = app.play_Tree.SelectedNodes;
    app.play_tool_SelectedNode.Text = sprintf('%s\nID %d: %.3f - %.3f MHz', app.specData(idx).Receiver,                  ...
                                                                            app.specData(idx).RelatedFiles.ID(1),        ...
                                                                            app.specData(idx).MetaData.FreqStart / 1e+6, ...
                                                                            app.specData(idx).MetaData.FreqStop  / 1e+6);
    app.play_tool_Timestamp.Text    = sprintf('1 de %d\n%s', nSweeps, app.specData(idx).Data{1}(1));
end