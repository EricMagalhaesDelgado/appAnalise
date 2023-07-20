function toolbar_interaction(app)
    if app.tb_interaction.Tag == "zoom"
        app.axes1.Interactions = [regionZoomInteraction, zoomInteraction, dataTipInteraction];
        app.axes2.Interactions = [regionZoomInteraction, zoomInteraction, dataTipInteraction];
        app.axes3.Interactions = [regionZoomInteraction, zoomInteraction, dataTipInteraction];

        set(app.tb_interaction, 'CData', Fcn_ToolbarIcon(app, 'interaction_pan'), 'Tag', 'pan')
    else
        app.axes1.Interactions = [panInteraction, zoomInteraction, dataTipInteraction];
        app.axes2.Interactions = [panInteraction, zoomInteraction, dataTipInteraction];
        app.axes3.Interactions = [panInteraction, zoomInteraction, dataTipInteraction];

        set(app.tb_interaction, 'CData', Fcn_ToolbarIcon(app, 'interaction_zoom'), 'Tag', 'zoom')
    end
end