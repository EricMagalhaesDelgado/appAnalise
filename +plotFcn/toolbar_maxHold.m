function toolbar_maxHold(app)
    if app.tb_maxHold.State
        app.traceInfo.Mode(3) = 4;
        
        if app.traceInfo.SelectedNode
            ind1 = app.traceInfo.SelectedNode;
            
            newLine = plot(app.axes1, app.x, app.specData(ind1).statsData(:, 4), 'Tag', 'MaxHold', 'Color', app.General.Colors(3,:));
            Misc_DataTipSettings(newLine, app.specData(ind1).MetaData.metaString{1})
        end

    else
        app.traceInfo.Mode(3) = 0;
        delete(findobj('Tag', 'MaxHold'))
    end
    drawnow nocallbacks
end