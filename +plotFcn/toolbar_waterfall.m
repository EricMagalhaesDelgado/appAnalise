function toolbar_waterfall(app)
    traceInfoCallback2_plotLayout(app)
    Plot_Layout2(app)

    h = findall(app.GridLayout15, '-not', 'Type', 'uigrid');
    
    if app.tb_waterfall.State
        set(h, 'Enable', 1)
        set(findall(app.play_Waterfall_cLim_Grid2.Children, '-not', 'Type', 'uilabel'), 'FontColor', [0,0,0])
        
        if app.traceInfo.SelectedNode
            Plot_StartUp1(app)
            Plot_StartUp2_WaterFall(app)
            Plot_StartUp3(app)
        end

    else
        set(h, 'Enable', 0)
        set(findall(app.play_Waterfall_cLim_Grid2.Children, '-not', 'Type', 'uilabel'), 'FontColor', [.98,.98,.98])
        app.play_Waterfall_Decimation.Value = 'auto';
        
        delete(findobj({'Tag', 'wfSurface', '-or', 'Tag', 'wfTimeStamp', '-or', 'Tag', 'DecimateLabel'}))
        app.line_wfTime = [];
    end
    drawnow nocallbacks
end