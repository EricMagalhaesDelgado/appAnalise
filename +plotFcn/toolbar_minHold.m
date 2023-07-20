function toolbar_minHold(app)
    if app.tb_minHold.State
        app.traceInfo.Mode(1) = 1;
        
        if app.traceInfo.SelectedNode
            ind1 = app.traceInfo.SelectedNode;
            
            newLine = plot(app.axes1, app.x, app.specData(ind1).statsData(:, 1), 'Tag', 'MinHold', 'Color', app.General.Colors(1,:));
            Misc_DataTipSettings(newLine, app.specData(ind1).MetaData.metaString{1})
        end

    else
        app.traceInfo.Mode(1) = 0;
        delete(findobj('Tag', 'MinHold'))
    end
    drawnow nocallbacks
end