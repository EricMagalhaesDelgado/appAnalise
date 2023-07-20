function toolbar_meanHold(app)
    if app.tb_meanHold.State
        if app.tb_meanFcn.Tag == "meanFcn"
            app.traceInfo.Mode(2) = 3;
        else
            app.traceInfo.Mode(2) = 2;
        end
        
        if app.traceInfo.SelectedNode
            ind1 = app.traceInfo.SelectedNode;
            
            newLine = findobj('Type', 'Line', {'Tag', 'medianFcn', '-or', 'Tag', 'meanFcn'});
            if isempty(newLine)
                newLine = plot(app.axes1, app.x, app.specData(ind1).statsData(:, app.traceInfo.Mode(2)), 'Tag', app.tb_meanFcn.Tag, 'Color', app.General.Colors(2,:));
                Misc_DataTipSettings(newLine, app.specData(ind1).MetaData.metaString{1})
            else
                set(newLine, 'YData', app.specData(ind1).statsData(:, app.traceInfo.Mode(2)), 'Tag', app.tb_meanFcn.Tag)
            end
        end

    else
        app.traceInfo.Mode(2) = 0;
        delete(findobj('Type', 'Line', {'Tag', 'medianFcn', '-or', 'Tag', 'meanFcn'}))
    end
    drawnow nocallbacks
end