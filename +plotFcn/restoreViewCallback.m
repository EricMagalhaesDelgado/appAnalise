function restoreViewCallback(app)
    h = [findobj(app.axes1.Toolbar, 'Tooltip', 'Restore View'), ...
         findobj(app.axes2.Toolbar, 'Tooltip', 'Restore View'), ...
         findobj(app.axes3.Toolbar, 'Tooltip', 'Restore View')];

    for ii = 1:numel(h)
        h(ii).ButtonPushedFcn = {@ButtonPushedFcn, app};
    end
end


%-------------------------------------------------------------------------%
function ButtonPushedFcn(src, evt, app)
    xLimits = app.restoreView{1};
    yLimits = app.restoreView{2};

    set(app.axes1, XLim=xLimits, YLim=yLimits)
    
    if ~isempty(app.axes2.Children)
        app.axes2.YLim = [0,100];
    end

    if ~isempty(app.axes3.Children)
        app.axes3.YLim = app.restoreView{3};
    end
end