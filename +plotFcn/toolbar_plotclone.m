function toolbar_plotclone(app)
    d = uiprogressdlg(app.UIFigure, 'Indeterminate', 'on', 'Interpreter', 'html');
    d.Message = '<font style="font-size:12;">Em andamento...</font>';

    Misc_PlotClone(app.fig, app.RootFolder)

    delete(d)
end