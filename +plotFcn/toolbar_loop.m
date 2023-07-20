function toolbar_loop(app)
    if app.tb_loop.Tag == "loop"
        set(app.tb_loop, 'CData', Fcn_ToolbarIcon(app, 'playback_straight'), 'Tag', 'straight');
    else
        set(app.tb_loop, 'CData', Fcn_ToolbarIcon(app, 'playback_loop'), 'Tag', 'loop');
    end
end