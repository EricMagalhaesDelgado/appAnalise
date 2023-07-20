function toolbar_refreshView(app)
    if ~isempty(app.RestoreView)
        set(app.axes1, 'XLim', app.RestoreView{1}, 'YLim', app.RestoreView{2})
        set(app.axes2, 'YLim', [0,100])
    
        if app.tb_waterfall.State
            set(app.axes3, 'YLim', app.RestoreView{3})
            view(app.axes3, 0, 90);
        end
    end
end