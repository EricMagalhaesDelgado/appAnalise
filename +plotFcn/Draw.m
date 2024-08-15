function Draw(app, idx)

    newArray = app.specData(idx).Data{2}(:,app.timeIndex)';

    if isempty(app.line_ClrWrite)
        DataPoints = app.specData(idx).MetaData.DataPoints;
        FreqStart  = app.specData(idx).MetaData.FreqStart / 1e+6;
        FreqStop   = app.specData(idx).MetaData.FreqStop  / 1e+6;

        if ismember(app.specData(idx).MetaData.DataType, class.Constants.occDataTypes)
            LevelUnit = '%';
        else
            LevelUnit = app.specData(idx).MetaData.LevelUnit;
        end

        % Propriedades do app que poderão ser referenciadas, caso criadas
        % curvas estatísticas (MinHold | Average | MaxHold).
        update(app.Band, DataPoints, FreqStart, FreqStop)

        % Limites do app.axes1, os quais ficam armazenadas em app.restoreView 
        % para recuperação posterior. O comportamento padrão do "restoreView"
        % (existente no toolbar do eixo) não se mostrou adequado porque ao
        % ser acionado, não há troca das propriedades "XLim" e "YLim", logo
        % os controles "uispinner" não são atualizados.
        xytLimits = plotFcn.axesLimits(app.specData(idx));

        % Inicialização de restoreView. O valor "cLim" é atualizado após
        % plotar as curvas dos tipos "Persistance" e "Waterfall".
        app.restoreView(1) = struct('ID', 'app.axes1', 'xLim', xytLimits.xLim, 'yLim', xytLimits.yLim, 'cLim', app.axes1.CLim);
        app.restoreView(2) = struct('ID', 'app.axes2', 'xLim', xytLimits.xLim, 'yLim', [0, 100],       'cLim', app.axes2.CLim);
        app.restoreView(3) = struct('ID', 'app.axes3', 'xLim', xytLimits.xLim, 'yLim', xytLimits.tLim, 'cLim', app.axes3.CLim);

        set(app.axes1, 'XLim', xytLimits.xLim, 'YLim', xytLimits.yLim, 'YScale', 'linear')
        ylabel(app.axes1, sprintf('Nível (%s)', LevelUnit))

        % Curvas a plotar em app.axes1 (na sua ordem correta!).
        % Persistance >> ClearWrite >> MinHold >> Average >> MaxHold        
        if app.tool_Persistance.Value
            plotFcn.Persistance(app, idx, 'Creation')
        end

        plotFcn.clrWrite(app, idx, 'InitialPlot', 1)
        plotFcn.BandLimits(app, idx)
        
        if app.tool_MinHold.Value
            plotFcn.minHold(app, idx, newArray, LevelUnit)
        end

        if app.tool_MaxHold.Value
            plotFcn.maxHold(app, idx, newArray, LevelUnit)
        end

        if app.tool_Average.Value
            plotFcn.Average(app, idx, newArray, LevelUnit)
        end

        % Curva a plotar em app.axes1 e app.axes2.
        if app.tool_Occupancy.Value
            occIndex = play_OCCIndex(app, idx, 'PLAYBACK');
            plotFcn.OCC(app, idx, 'Creation', LevelUnit, occIndex)
        end

        % Curva a plotar em app.axes3.        
        if app.tool_Waterfall.Value
            plotFcn.WaterFall(app, idx, 'Creation', LevelUnit)
        end

        % Customização do playback:
        if app.specData(idx).UserData.customPlayback.Type == "manual"
            % DataTip
            dtConfig = app.specData(idx).UserData.customPlayback.Parameters.Datatip;
            dtParent = [app.axes1, app.axes2, app.axes3];
            plot.datatip.Create('customPlayback', dtConfig, dtParent)

            % Colormap
            % O MATLAB não tem uma função que retorna o nome do colormap
            % ("summer" ou "hot", por exemplo). Por conta disso, essa
            % informação foi armazenada no UserData dos eixos.
            if ~strcmp(app.axes1.UserData.Colormap, app.play_Persistance_Colormap.Value)
                plot_Colormap_axes1(app)
            end

            if ~strcmp(app.axes3.UserData.Colormap, app.play_Waterfall_Colormap.Value)
                plot_Colormap_axes3(app)
            end            
        end

        plotFcn.axesStackingOrder.execute('winAppAnalise', app.axes1)

    else
        app.line_ClrWrite.YData = newArray;

        for ii = 1:numel(app.mkr_Label)
            app.mkr_Label(ii).Position(2) = app.line_ClrWrite.YData(app.line_ClrWrite.MarkerIndices(ii));
        end

        if app.tool_Persistance.Value && ~strcmp(app.play_Persistance_Samples.Value, 'full')
            plotFcn.Persistance(app, idx, 'Update')
        end

        if ~isinf(app.General.Integration.Trace)
            if ~isempty(app.line_MinHold)
                app.line_MinHold.YData = min(app.line_MinHold.YData, newArray);
            end
    
            if ~isempty(app.line_Average)
                app.line_Average.YData = ((app.General.Integration.Trace-1)*app.line_Average.YData + newArray) / app.General.Integration.Trace;
            end
    
            if ~isempty(app.line_MaxHold)
                app.line_MaxHold.YData = max(app.line_MaxHold.YData, newArray);
            end
        end

        if app.tool_Waterfall.Value && ~isempty(app.line_WaterFallTime) && strcmp(app.play_Waterfall_Timestamp.Value, 'on')
            app.line_WaterFallTime.YData = [app.specData(idx).Data{1}(app.timeIndex), app.specData(idx).Data{1}(app.timeIndex)];
        end
    end
    drawnow
end