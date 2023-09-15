function Persistance(app)

    if app.play_Persistance.Value
        set(app.play_PersistanceGrid.Children, Enable=1)

        % Identifica índice do fluxo espectral plotado.
        idx = [];
        if ~isempty(app.play_PlotPanel.UserData)
            idx = app.play_PlotPanel.UserData.NodeData;
        end

        % Pendente
        
    else
        set(findobj(app.play_PersistanceGrid, '-not', 'Type', 'uilabel'), Enable=0)
    end
    drawnow
end