function restoreViewCallback(app)
    h = findobj(app.axes1.Toolbar, 'Tooltip', 'Restore View');
    if ~isempty(h)
        h.ButtonPushedFcn = {@ButtonPushedFcn, app};
    end
end


%-------------------------------------------------------------------------%
function ButtonPushedFcn(src, evt, app)
    xLimits = app.restoreView{1};
    yLimits = app.restoreView{2};

    set(app.axes1, XLim=xLimits, YLim=yLimits)
end