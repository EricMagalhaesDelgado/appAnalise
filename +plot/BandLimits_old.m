function BandLimits_old(app, idx)

    delete(findobj(app.UIAxes1, 'Tag', 'BandLimits'))

    if app.specData(idx).UserData.bandLimitsStatus
        yLevel = app.restoreView(1).yLim(2) - 1;
    
        for ii = 1:height(app.specData(idx).UserData.bandLimitsTable)
            FreqStart = app.specData(idx).UserData.bandLimitsTable.FreqStart(ii);
            FreqStop  = app.specData(idx).UserData.bandLimitsTable.FreqStop(ii);
            
            % Cria uma linha por subfaixa a analise, posicionando-o na parte 
            % inferior do plot.
            line(app.UIAxes1, [FreqStart, FreqStop], [yLevel, yLevel], ...
                            Color=[.5 .5 .5], LineWidth=5,           ...
                            PickableParts='none',  Tag='BandLimits')
        end
        plot.axes.StackingOrder.execute(app.UIAxes1, app.bandObj.Context)
    end
end