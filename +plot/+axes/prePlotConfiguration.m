function prePlotConfiguration(hAxes, xLim, yLim, yScale, colorMap)

    arguments
        hAxes
        xLim
        yLim
        yScale {mustBeMember(yScale, {'linear', 'log'})} = 'linear'
        colorMap = ''
    end

    switch class(yLim)
        case 'datetime'
            if ~isa(hAxes.YAxis, 'matlab.graphics.axis.decorator.DatetimeRuler')
                matlab.graphics.internal.configureAxes(hAxes, xLim, yLim)
            end
    
        otherwise
            if ~isa(hAxes.YAxis, 'matlab.graphics.axis.decorator.NumericRuler')
                matlab.graphics.internal.configureAxes(hAxes, xLim, yLim)
            end
    end

    if ~diff(xLim)
        xLim = [xLim(1)-.1, xLim(1)+.1];
    end

    set(hAxes, 'XLim', xLim, 'YLim', yLim, 'YScale', yScale, 'ZLimMode', 'auto', 'CLimMode', 'auto', 'View', [0,90])
    try
        hAxes.XAxis.Exponent = 0;
        hAxes.YAxis.Exponent = 0;
        hAxes.ZAxis.Exponent = 0;
    catch
    end

    if ~isempty(colorMap)
        if isempty(hAxes.UserData) || ~isfield(hAxes, 'Colormap') || ~strcmp(hAxes.Colormap, colorMap)
            colormap(hAxes, colorMap)
            hAxes.Colormap(1,:) = [0,0,0];
            hAxes.UserData.Colormap = colorMap;
        end
    end
    
end