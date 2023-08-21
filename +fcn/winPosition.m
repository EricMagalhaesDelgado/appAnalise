function winPosition(app)

    mainMonitor = get(0, 'MonitorPositions');
    [~, idx]    = max(mainMonitor(:,3));
    mainMonitor = mainMonitor(idx,:);
    
    app.UIFigure.Position(1:2) = [mainMonitor(1)+round((mainMonitor(3)-app.UIFigure.Position(3))/2), ...
                                  mainMonitor(2)+round((mainMonitor(4)-app.UIFigure.Position(4)-30)/2)];
end