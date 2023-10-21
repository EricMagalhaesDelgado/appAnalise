function customPlayback(app, idx)

    app.play_MinHold.Value                     = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_MinHold;
    app.play_Average.Value                     = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_Average;
    app.play_MaxHold.Value                     = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_MaxHold;
    app.play_Persistance.Value                 = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_Persistance;
    app.play_Occupancy.Value                   = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_Occupancy;
    app.play_Waterfall.Value                   = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_Waterfall;

    if app.play_Occupancy.Value && app.play_Waterfall.Value
        app.play_LayoutRatio.Items = {'2:1:1', '1:2:1', '1:1:2'};
    elseif app.play_Occupancy.Value
        app.play_LayoutRatio.Items = {'3:1:0', '1:1:0', '1:3:0'};
    elseif app.play_Waterfall.Value
        app.play_LayoutRatio.Items = {'3:0:1', '1:0:1', '1:0:3'};
    else
        set(app.play_LayoutRatio, Items={'1:0:0'})
    end
    app.play_LayoutRatio.Value                 = app.specData(idx).UserData.customPlayback.Parameters.Controls.play_LayoutRatio;

    app.play_Persistance_Interpolation.Value   = app.specData(idx).UserData.customPlayback.Parameters.Persistance.play_Persistance_Interpolation;
    app.play_Persistance_Samples.Value         = app.specData(idx).UserData.customPlayback.Parameters.Persistance.play_Persistance_Samples;
    app.play_Persistance_Transparency.Value    = app.specData(idx).UserData.customPlayback.Parameters.Persistance.play_Persistance_Transparency;

    app.play_Waterfall_Decimation.Value        = app.specData(idx).UserData.customPlayback.Parameters.Waterfall.play_Waterfall_Decimation;
end