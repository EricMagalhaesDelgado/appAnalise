function [xTick, xTickLabel, yTick, yTickLabel] = XYTick(hAxes, bandObj, idx)

    if ~strcmp(bandObj.Context, 'appAnalise:REPORT')
        error('plot.axes.XTick restrito ao contexto "appAnalise:REPORT"'.)
    end

    specData  = bandObj.callingApp.specData(idx);
    xTickFlag = true;
    yTickFlag = true;

    for ii = 5:-1:1
        if xTickFlag
            xTick = linspace(hAxes.XLim(1), hAxes.XLim(2), ii);

            if issorted(xTick, "strictascend")
                xTickFlag  = false;
                xTickLabel = string(round(xTick, 3));
            end
        end

        if yTickFlag
            yTick = linspace(hAxes.YLim(1), hAxes.YLim(2), ii);

            if issorted(yTick, "strictascend")
                yTickFlag = false;

                switch class(yTick)
                    case 'datetime'
                        yTickLabel = [];
                        for jj = 1:numel(yTick)
                            [~, yTickIndex]   = min(abs(specData.Data{1} - yTick(jj)));
                            yTickLabel(end+1) = yTickIndex;
                        end
                    otherwise
                        yTickLabel = round(yTick);
                end
                yTickLabel = string(yTickLabel);
            end
        end

        if ~xTickFlag && ~yTickFlag
            break
        end
    end

end