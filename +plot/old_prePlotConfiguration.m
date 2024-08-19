function old_prePlotConfiguration(hAxes, xLim, yLim, yScale, colormapName)

    arguments
        hAxes
        xLim
        yLim
        yScale {mustBeMember(yScale, {'linear', 'log'})} = 'linear'
        colormapName = ''
    end

    plot.axes.Ruler(hAxes, xLim, yLim)

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

    if ~isempty(colormapName)
        plot.axes.Colormap(hAxes, colormapName)
    end
    
end