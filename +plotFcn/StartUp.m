function StartUp(app, idx)

    cla(app.axes1)
    cla(app.axes2)
    cla(app.axes3)

    % Controle do tempo.
    app.timeIndex = 1;
    app.play_PlaybackSlider.Value = 0;

    % Controle dos handles.
    app.restoreView        = {[0,1], [0,1], [0,1]};

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
            app.play_Occupancy.Enable = 1;
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

        plotFcn.Persistance(app, idx, 'Delete')
        plotFcn.OCC(app, idx, 'Delete', '', [])
        plotFcn.WaterFall(app, idx, 'Delete', '')
    end

    % Outros aspectos:
    app.play_PlotPanel.UserData = app.play_Tree.SelectedNodes;
    app.play_SelectedNode.Text  = sprintf('%s\nID %d: %.3f - %.3f MHz', app.specData(idx).Receiver,                  ...
                                                                        app.specData(idx).RelatedFiles.ID(1),        ...
                                                                        app.specData(idx).MetaData.FreqStart / 1e+6, ...
                                                                        app.specData(idx).MetaData.FreqStop  / 1e+6);
    app.play_Timestamp.Text     = sprintf('1 de %d\n%s', nSweeps, app.specData(idx).Data{1}(1));

    % Customização do playback:
    switch app.specData(idx).UserData.customPlayback.Type
        case 'auto'
            app.play_Customization.Value             = 0;
            app.play_Waterfall_Decimation.Value      = 'auto';

        case 'manual'
            app.play_Customization.Value             = 1;

            app.play_MinHold.Value                   = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_MinHold;
            app.play_Average.Value                   = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_Average;
            app.play_MaxHold.Value                   = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_MaxHold;
            app.play_Persistance.Value               = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_Persistance;
            app.play_Occupancy.Value                 = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_Occupancy;
            app.play_Waterfall.Value                 = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_Waterfall;

            if app.play_Occupancy.Value && app.play_Waterfall.Value
                app.play_LayoutRatio.Items = {'2:1:1', '1:2:1', '1:1:2'};
            elseif app.play_Occupancy.Value
                app.play_LayoutRatio.Items = {'3:1:0', '1:1:0', '1:3:0'};
            elseif app.play_Waterfall.Value
                app.play_LayoutRatio.Items = {'3:0:1', '1:0:1', '1:0:3'};
            else
                set(app.play_LayoutRatio, Items={'1:0:0'})
            end
            app.play_LayoutRatio.Value               = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_LayoutRatio;

            app.play_Persistance_Interpolation.Value = app.specData(idx).UserData.customPlayback.Parameters.Persistance.play_Persistance_Interpolation;
            app.play_Persistance_Samples.Value       = app.specData(idx).UserData.customPlayback.Parameters.Persistance.play_Persistance_Samples;
            app.play_Persistance_Transparency.Value  = app.specData(idx).UserData.customPlayback.Parameters.Persistance.play_Persistance_Transparency;

            app.play_OCC_Method.Value                = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_Method;
            layoutFcn.OCC(app, app.specData(idx).MetaData.LevelUnit)
            
            app.play_OCC_IntegrationTime.Value       = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_IntegrationTime;
            app.play_OCC_Orientation.Value           = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_Orientation;
            app.play_OCC_THR.Value                   = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_THR;
            app.play_OCC_Offset.Value                = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_Offset;
            app.play_OCC_ceilFactor.Value            = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_ceilFactor;
            app.play_OCC_noiseFcn.Value              = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_noiseFcn;
            app.play_OCC_noiseTrashSamples.Value     = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_noiseTrashSamples;
            app.play_OCC_noiseUsefulSamples.Value    = app.specData(idx).UserData.customPlayback.Parameters.Occupancy.play_OCC_noiseUsefulSamples;

            app.play_Waterfall_Decimation.Value      = app.specData(idx).UserData.customPlayback.Parameters.Waterfall.play_Waterfall_Decimation;
    end
end