function toolbar_persistance(app)
    h = findall(app.play_Persistance_Grid, '-not', 'Type', 'uigrid');

    if app.tb_persistance.State    
        set(h, 'Enable', 1)
        set(findall(app.play_Persistance_cLim_Grid2.Children, '-not', 'Type', 'uilabel'), 'FontColor', [0,0,0])
        app.traceInfo.Persistance = 1;
        
        if app.traceInfo.SelectedNode
            Plot_StartUp2_Persistance(app)
        end

    else
        set(h, 'Enable', 0)
        set(findall(app.play_Persistance_cLim_Grid2.Children, '-not', 'Type', 'uilabel'), 'FontColor', [.98,.98,.98])
        app.traceInfo.Persistance = 0;

        delete(app.obj_Persistance.handle)
        app.obj_Persistance = [];

        app.play_ClearWriteVisibility.Value = 'on';
        set(app.line_ClearWrite, 'Visible', app.play_ClearWriteVisibility.Value)
    end
    drawnow nocallbacks
end