function OCC(app, idx)

    if app.play_Occupancy.Value        
        switch app.play_OCC_Method.Value
            case 'Linear fixo'
                THR = app.play_OCC_THR.Value;
                app.line_OCC = images.roi.Line(app.axes1,'Position',[app.x(1) THR; app.x(end) THR], 'Color', 'red', 'MarkerSize', 4, 'Deletable', 0, 'LineWidth', 1, 'InteractionsAllowed', 'translate', 'Tag', 'occROI');
                
                addlistener(app.line_OCC, 'MovingROI', {@(src,event)occLineROI, app, idx});
                addlistener(app.line_OCC, 'ROIMoved',  {@(src,event)occLineROI, app, idx});
    
            case 'Linear adaptativo'
                occInfo = struct('Offset',   app.play_OCC_Offset.Value,                                                    ...
                                 'Fcn',      app.play_OCC_noiseFcn.Value,                                                  ...
                                 'Samples', [app.play_OCC_noiseTrashSamples.Value, app.play_OCC_noiseUsefulSamples.Value], ...
                                 'Factor',   app.play_OCC_Factor.Value);
    
                app.occTHR   = Misc_occThreshold('Piso de ruído (Offset)', app.specData(idx), occInfo);
                app.line_OCC = plot(app.axes1, app.x, app.occTHR, 'Color', 'red', 'LineStyle', '-', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerIndices', [1, app.specData(idx).MetaData.DataPoints], 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'black', 'Tag', 'occROI');
                
            case 'Piso de ruído (Offset)'
                occInfo = struct('Offset',   app.play_OCC_Offset.Value,                                                    ...
                                 'Fcn',      app.play_OCC_noiseFcn.Value,                                                  ...
                                 'Samples', [app.play_OCC_noiseTrashSamples.Value, app.play_OCC_noiseUsefulSamples.Value], ...
                                 'Factor',   app.play_OCC_Factor.Value);
    
                app.occTHR   = Misc_occThreshold('Piso de ruído (Offset)', app.specData(idx), occInfo);
                app.line_OCC = plot(app.axes1, app.x, app.occTHR, 'Color', 'red', 'LineStyle', '-', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerIndices', [1, app.specData(idx).MetaData.DataPoints], 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'black', 'Tag', 'occROI');
        end
        app.line_OCCLabel = text(app.axes1, app.x(end), double(app.occTHR(end)), '  THR', 'FontName', 'Helvetica', 'FontSize', 7, 'Color', 'red', 'Tag', 'occROI');
        
        set(app.axes2, XLim=app.axes1.XLim, YLim=[0, 100])
        plot(app.axes2, app.x, zeros(1, numel(app.line_ClearWrite.YData), 'single'), 'Tag', 'maxOCC',  'Color', app.General.Colors(3,:));   % MaxHold
        plot(app.axes2, app.x, zeros(1, numel(app.line_ClearWrite.YData), 'single'), 'Tag', 'meanOCC', 'Color', app.General.Colors(2,:));   % Média

        fcn.OCC(app, idx)
    end
end


%-------------------------------------------------------------------------%
function occLineROI(src, event, app, idx)
    switch(event.EventName)
        case{'MovingROI'}
            disableDefaultInteractivity(app.axes1)
            
            app.play_OCC_THR.Value        = event.CurrentPosition(1,2);
            app.line_OCCLabel.Position(2) = event.CurrentPosition(1,2);
            
        case{'ROIMoved'}
            enableDefaultInteractivity(app.axes1)
            plotFcn.OCC(app, idx)
    end
end


%-------------------------------------------------------------------------%
function THR = Threshold(app, idx, Type, occInfo)

    DataPoints = app.specData(idx).MetaData.DataPoints;

    Offset     = occInfo.Offset;
    statsFcn   = occInfo.Fcn;
    tSamples   = occInfo.Samples(1);                     
    uSamples   = occInfo.Samples(2);

    statsData  = eval(sprintf('sort(%s(app.specData(idx).Data{2}, 2));', statsFcn));
    
    ind1 = max(1,                 ceil((tSamples/100) * DataPoints));
    ind2 = min(DataPoints, ind1 + ceil((uSamples/100) * DataPoints));

    switch Type
        case 'Linear adaptativo'
            THR = statsData(ind1:ind2);
            
            if ~mod(numel(THR), 2); THR(end) = [];
            end
            
            switch statsFcn
                case 'Mediana'; THR = ceil(median(THR) + Offset);
                case 'Média';   THR = ceil(mean(THR)   + Offset);
            end
            
            
        case 'Piso de ruído (Offset)'
            ConfLevel = occInfo.Factor;
            
            auxMatrix = sort(Data.Data{2});
            auxMatrix = auxMatrix(ind1:ind2, :);
            
            noiseMean = mean(auxMatrix,    'all');
            noiseStd  =  std(auxMatrix, 1, 'all');
            
            switch ConfLevel
                case '68'; Factor = 1;
                case '95'; Factor = 2;
                case '99'; Factor = 3;
            end
            THR(THR < noiseMean - Factor*noiseStd) = noiseMean - Factor*noiseStd;
            THR(THR > noiseMean + Factor*noiseStd) = noiseMean + Factor*noiseStd;
            
            THR = THR + Offset;
    end
end