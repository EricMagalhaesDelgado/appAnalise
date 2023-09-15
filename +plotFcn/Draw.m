function Draw(app, idx)

    newArray = app.specData(idx).Data{2}(:,app.timeIndex)';

    if isempty(app.line_ClrWrite)
        FreqStart = app.specData(idx).MetaData.FreqStart / 1e+6;
        FreqStop  = app.specData(idx).MetaData.FreqStop  / 1e+6;
        LevelUnit = app.specData(idx).MetaData.LevelUnit;

        % Propriedades do app que poderão ser referenciadas, caso criadas
        % curvas estatísticas (MinHold | Average | MaxHold), ou caso a
        % janela de integração não seja "full".
        app.xArray = linspace(FreqStart, FreqStop, app.specData(idx).MetaData.DataPoints);
        app.General.Integration.Trace = plotFcn.TraceIntegration(app, idx);

        % Outras características dos eixos.
        yLimits = YLimits(app, idx);
        set(app.axes1, XLim=[FreqStart, FreqStop], YLim=yLimits, YScale='linear')
        ylabel(app.axes1, sprintf('Nível (%s)', LevelUnit))

        % Curva "guia" (ClearWrite), além das curvas estatísticas (MinHold | 
        % Average | MaxHold)
        app.line_ClrWrite = plot(app.axes1, app.xArray, newArray, Color=app.General.Colors(4,:), Tag='ClrWrite');
        plotFcn.DataTipModel(app.line_ClrWrite, LevelUnit)
        
        if app.play_MinHold.Value
            plotFcn.minHold(app, idx, newArray, LevelUnit)
        end

        if app.play_Average.Value
            plotFcn.Average(app, idx, newArray, LevelUnit)
        end

        if app.play_MaxHold.Value
            plotFcn.maxHold(app, idx, newArray, LevelUnit)
        end

        % Persistence and Waterfall
        app.surface_WFall = image(app.axes3, app.xArray, 1:app.specData(ii).Band(jj).Waterfall.Depth, app.specData(ii).Band(jj).Waterfall.Matrix(idx2,:), CDataMapping='scaled', Tag='Waterfall');
        plotFcn.DataTipModel(app.surface_WFall, LevelUnit)

    else
        app.line_ClrWrite.YData = newArray;

        if ~strcmp(app.play_TraceIntegration.Value, 'Inf')
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

        % Persistência
        % WaterFall
    end
    drawnow
end


%-------------------------------------------------------------------------%
function yLimits = YLimits(app, idx)
    if ismember(app.specData(idx).MetaData.DataType, class.Constants.specDataTypes)
        auxValue = min(app.specData(idx).Data{3}(:,1));
        downYLim = auxValue - mod(auxValue, 10);
    
        auxValue = max(app.specData(idx).Data{3}(:,3));
        upYLim   = auxValue - mod(auxValue, 10) + 10;
    else
        downYLim = 0;
        upYLim   = 100;
    end
    yLimits = [downYLim, upYLim];

    if diff(yLimits) > class.Constants.yMaxLimRange
        yLimits(1) = yLimits(1) + diff(yLimits) - class.Constants.yMaxLimRange;
    end
end