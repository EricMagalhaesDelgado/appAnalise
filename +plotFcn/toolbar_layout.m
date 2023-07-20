function toolbar_layout(app)
    if app.tb_layout.Tag == "1:1"
        set(app.tb_layout, 'CData', Fcn_ToolbarIcon(app, 'layout2'), 'Tag', "1:3")
    else
        set(app.tb_layout, 'CData', Fcn_ToolbarIcon(app, 'layout1'), 'Tag', "1:1")
    end

    Plot_Layout2(app)
end