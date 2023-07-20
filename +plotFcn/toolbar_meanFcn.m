function toolbar_meanFcn(app)
    if app.tb_meanFcn.Tag == "meanFcn"
        set(app.tb_meanFcn, 'CData', Fcn_ToolbarIcon(app, 'medianFcn'), 'Tag', "medianFcn")
    else
        set(app.tb_meanFcn, 'CData', Fcn_ToolbarIcon(app, 'meanFcn'),   'Tag', "meanFcn")
    end

    plotFcn.toolbar_meanHold(app)
end