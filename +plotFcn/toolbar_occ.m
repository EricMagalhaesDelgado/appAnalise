function toolbar_occ(app)
    traceInfoCallback2_plotLayout(app)
    Playback_Layout_occPlot(app)
    Plot_Layout2(app)
    
    if app.tb_occ.State        
        if app.traceInfo.SelectedNode
            ind1 = app.traceInfo.SelectedNode;
            
            Plot_StartUp1_OCC(app)
            Plot_StartUp2_OCC(app, ind1)
            Plot_StartUp3(app)
        end

    else
        set(findall(groot, 'Parent', app.GridLayout23, '-not', 'Type', 'uipanel'), 'Enable', 0)
        set(app.Playback_occGrid2.Children, 'Enable', 0)
        
        delete(findobj({'Tag', 'occROI', '-or', 'Tag', 'maxOCC', '-or', 'Tag', 'meanOCC'}))
    end
    drawnow nocallbacks
end