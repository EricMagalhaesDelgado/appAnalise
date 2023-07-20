function toolbar_playback(app)
    if ~app.plotFlag
        app.plotFlag = 1;
        set(app.tb_playback, 'CData', Fcn_ToolbarIcon(app, 'playback_stop'), 'Tag', 'stop')
        
        set(findall(groot, 'Parent', app.menu_Grid2, 'Type', 'uistatebutton'), 'Enable', 0)
        app.mainInfo_Delete1.Enable = 0;
        
        Plot(app)

    else
        app.plotFlag = 0;
        set(app.tb_playback, 'CData', Fcn_ToolbarIcon(app, 'playback_play'), 'Tag', 'play')
        
        set(findall(groot, 'Parent', app.menu_Grid2, 'Type', 'uistatebutton'), 'Enable', 1)
        app.mainInfo_Delete1.Enable = 1;
        
        Fcn_plotToolbar(app, 1)
    end
end