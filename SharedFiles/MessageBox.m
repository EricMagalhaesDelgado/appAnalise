function MessageBox(app, type, msg)

    appName = class.Constants.appName;
    msg = sprintf('<font style="font-size:12;">%s</font>', msg);
    
    switch type
        case 'error'
            uialert(app.UIFigure, msg, appName, 'Interpreter', 'html');
        
        case 'warning'
            uialert(app.UIFigure, msg, appName, 'Interpreter', 'html', 'Icon', 'warning');
        
        case 'info'
            uialert(app.UIFigure, msg, appName, 'Interpreter', 'html', 'Icon', 'LT_info.png')

        case 'startup'
            app.UIFigure.Visible = 1;
            uialert(app.UIFigure, msg, appName, 'Interpreter', 'html', 'CloseFcn', @(~,~)closeRequest(app));
    end
end