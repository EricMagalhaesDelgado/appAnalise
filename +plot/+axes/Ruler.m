function Ruler(hAxes, xLim, yLim)
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
end