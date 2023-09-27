function OCC(app, idx, newArray, LevelUnit)

    if app.play_Occupancy.Value
        set(app.play_occGrid.Children, Enable=1)

        % Identifica índice do fluxo espectral plotado.
        idx = [];
        if ~isempty(app.play_PlotPanel.UserData)
            idx = app.play_PlotPanel.UserData.NodeData;
        end

        Plot_StartUp1_OCC(app)
        % Plot_StartUp2_OCC(app, idx)
        
    else
        set(findobj(app.play_occGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigridlayout'}), Enable=0)
    end
    drawnow
end


%-------------------------------------------------------------------------%
function Plot_StartUp1_OCC(app)

    set(app.axes2, XLim=app.axes1.XLim, YLim=[0, 100]);
    ylabel(app.axes2, 'Ocupação (%)');

end


%-------------------------------------------------------------------------%
function Plot_StartUp2_OCC(app, idx)

    if isempty(app.line_OCC)        
        if strcmp(app.specData(idx).MetaData.metaString{1}, 'dBm') && (app.Playback_occValue.Value > 0)
            app.Playback_occValueLabel.Text{2} = '(dBm):';
            app.Playback_occValue.Value        = -80;

        elseif strcmp(app.specData(idx).MetaData.metaString{1}, 'dBµV') && (app.Playback_occValue.Value < 0)
            app.Playback_occValueLabel.Text{2} = '(dBµV):';
            app.Playback_occValue.Value        = 27;
            
        elseif strcmp(app.specData(idx).MetaData.metaString{1}, 'dBµV/m') && (app.Playback_occValue.Value < 0)
            app.Playback_occValueLabel.Text{2} = '(dBµV/m):';
            app.Playback_occValue.Value        = 40;
        end
        
        if app.Playback_occValue.Value > app.axes1.YLim(2)
            app.Playback_occValue.Value = double(app.axes1.YLim(2));
        end
        
        switch app.Playback_occType.Value
            case 'Linear'
                app.occTHR   = app.Playback_occValue.Value;
                app.line_OCC = images.roi.Line(app.axes1,'Position',[app.x(1) app.Playback_occValue.Value; app.x(end) app.Playback_occValue.Value], 'Color', 'red', 'MarkerSize', 4, 'Deletable', 0, 'LineWidth', 1, 'InteractionsAllowed', 'translate', 'Tag', 'occROI');
                
                addlistener(app.line_OCC, 'MovingROI', @app.occLineROI);
                addlistener(app.line_OCC, 'ROIMoved',  @app.occLineROI);
                
            case 'Piso de ruído (Offset)'
                occInfo = struct('Offset',   app.Playback_occOffset.Value,                              ...
                                 'Fcn',      app.Playback_occFcn.Value,                                 ...
                                 'Samples', [app.Playback_tSamples.Value, app.Playback_uSamples.Value], ...
                                 'Factor',   app.Playback_occConfLevel.Value);

                app.occTHR   = Misc_occThreshold('Piso de ruído (Offset)', app.specData(idx), occInfo);
                app.line_OCC = plot(app.axes1, app.x, app.occTHR, 'Color', 'red', 'LineStyle', '-', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerIndices', [1, app.specData(idx).MetaData.DataPoints], 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'black', 'Tag', 'occROI');
        end
        app.line_OCCLabel = text(app.axes1, app.x(end), double(app.occTHR(end)), '  THR', 'FontName', 'Helvetica', 'FontSize', 7, 'Color', 'red', 'Tag', 'occROI');
        
        plot(app.axes2, app.x, zeros(1, numel(app.line_ClearWrite.YData), 'single'), 'Tag', 'maxOCC',  'Color', app.General.Colors(3,:));   % MaxHold
        plot(app.axes2, app.x, zeros(1, numel(app.line_ClearWrite.YData), 'single'), 'Tag', 'meanOCC', 'Color', app.General.Colors(2,:));   % Média
    
    else
        if isa(app.line_OCC, 'images.roi.Line')
            app.line_OCC.Position(:,2)    = [app.play_occValue.Value; app.play_occValue.Value];
            app.line_OCCLabel.Position(2) = app.play_occValue.Value;

        else
            occInfo = struct('Offset',   app.Playback_occOffset.Value,                              ...
                             'Fcn',      app.Playback_occFcn.Value,                                 ...
                             'Samples', [app.Playback_tSamples.Value, app.Playback_uSamples.Value], ...
                             'Factor',   app.Playback_occConfLevel.Value);

            app.occTHR                    = Misc_occThreshold('Piso de ruído (Offset)', app.specData(idx), occInfo);                    
            app.line_OCC.YData            = app.occTHR;
            app.line_OCCLabel.Position(2) = double(app.occTHR(end));
        end
        
        set(app.axes2.Children, 'YData', zeros(1, numel(app.line_ClearWrite.YData), 'single'));
    end
    
end   


        function occLineROI(app, src, event)            
            switch(event.EventName)
                case{'MovingROI'}
                    disableDefaultInteractivity(app.axes1)                    
                    app.play_occValue.Value = event.CurrentPosition(1,2);
                    app.line_OCCLabel.Position(2)      = event.CurrentPosition(1,2);
                    
                case{'ROIMoved'}
                    enableDefaultInteractivity(app.axes1)                    
                    set(app.axes2.Children, 'YData', zeros(1, numel(app.line_ClrWrite.YData), 'single'));
            end            
        end