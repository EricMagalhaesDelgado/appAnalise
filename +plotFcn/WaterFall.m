function WaterFall(app)

    if app.play_Waterfall.Value
        set(app.play_WaterFallGrid.Children, Enable=1)

        % Identifica índice do fluxo espectral plotado.
        idx = [];
        if ~isempty(app.play_PlotPanel.UserData)
            idx = app.play_PlotPanel.UserData.NodeData;
        end

        app.img_WaterFall = image(app.axes3, app.xArray, 1:numel(app.specData(idx).Data{1}), app.specData(idx).Data{2}', CDataMapping='scaled', Tag='Waterfall');
        plotFcn.DataTipModel(app.img_WaterFall, LevelUnit)
        
    else
        set(findobj(app.play_WaterFallGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigridlayout'}), Enable=0)
    end
    drawnow
end

       
function Plot_StartUp2_WaterFall(app)
    ind1 = app.traceInfo.SelectedNode;
    
    if isempty(findobj('Tag', 'wfSurface'))
        if strcmp(app.play_Waterfall_Decimation.Value, 'auto')
            auxSize = app.specData(ind1).MetaData.DataPoints .* app.specData(ind1).Samples;
            if auxSize > 1474560; Decimate = ceil(auxSize/1474560);
            else;                 Decimate = 1;
            end
        else
            Decimate = str2double(app.play_Waterfall_Decimation.Value);
        end

        while true
            t = app.specData(ind1).Data{1}(1:Decimate:end);
            if numel(t) > 1; break
            else;            Decimate = round(Decimate/2);
            end
        end

        if ~strcmp(app.play_Waterfall_Decimation.Value, 'auto')
            app.play_Waterfall_Decimation.Value = num2str(Decimate);
        end

        if t(1) == t(end)
            t(end) = t(1)+seconds(1);
        end
        app.RestoreView{3} = [t(1), t(end)];
        
        [X, Y] = meshgrid(app.x, t);

        app.axes3.CLimMode = 'auto';
        mesh(app.axes3, X, Y, app.specData(ind1).Data{2}(:,1:Decimate:end)', 'MeshStyle', app.play_Waterfall_Interpolation.Value, 'SelectionHighlight', 'off', 'Tag', 'wfSurface')
        view(app.axes3, 0, 90);
        
        if strcmp(app.play_Waterfall_Timestamp.Value, 'on')
            app.line_wfTime = line(app.axes3, [app.x(1), app.x(end)], [app.specData(ind1).Data{1}(app.timeIndex), app.specData(ind1).Data{1}(app.timeIndex)], [app.axes1.YLim(2) app.axes1.YLim(2)], ...
                                              'Color', 'red', 'LineWidth', 1, 'PickableParts', 'none', 'Tag', 'wfTimeStamp');
        end
        
        tTickLabel    = linspace(t(1), t(end), 3);
        [~, tIndex]   = min(abs(app.specData(ind1).Data{1} - tTickLabel(2)));
        tTickLabel(2) =  app.specData(ind1).Data{1}(tIndex);

        set(app.axes3, 'YLim' , [t(1), t(end)], 'YTick', tTickLabel, 'YTickLabel', [1, round(tIndex), app.specData(ind1).Samples])

        hText = findobj('Tag', 'DecimateLabel');
        if isempty(hText)
            text(app.axes3, 1.01, .98, 0, sprintf('FD: %.0f', Decimate), 'Units', 'normalized', 'FontName', 'Helvetica', 'FontSize', 7, 'Tag', 'DecimateLabel')
        else
            hText.String = sprintf('FD: %.0f', Decimate);
        end

        % Colors limits
        app.axes3.CLim(2)  = round(app.axes3.CLim(2));
        app.axes3.CLim(1)  = round(app.axes3.CLim(2) - diff(app.axes3.CLim)/2);

        app.RestoreView{4} = app.axes3.CLim;

        app.play_Waterfall_cLim1.Value = app.axes3.CLim(1);
        app.play_Waterfall_cLim2.Value = app.axes3.CLim(2);

        Li = app.axes3.CLim(1);
        Ls = app.axes3.CLim(2);
        
        set(app.cBar1, Limits=[Li, Ls], Ticks=[Li, Ls], TickLabels={num2str(Li), num2str(Ls)})
    end    
end