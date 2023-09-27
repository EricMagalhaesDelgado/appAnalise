function ROI(app, newPosition)

    app.mkr_ROI = images.roi.Rectangle(app.axes1, Position=newPosition, ...
                                                   Color=[0.40,0.73,0.88], ...
                                                   MarkerSize=5,           ...
                                                   Deletable=0,            ...
                                                   LineWidth=1,            ...
                                                   Tag='mkrROI');

    addlistener(app.mkr_ROI, 'MovingROI', @app.mkrLineROI);
    addlistener(app.mkr_ROI, 'ROIMoved',  @app.mkrLineROI);

end



        function mkrLineROI(app, src, event)
            ind1 = app.traceInfo.SelectedNode;
            switch(event.EventName)
                case{'MovingROI'}
                    disableDefaultInteractivity(app.axes1)

                    FreqCenter = app.mkr_ROI.Position(1) + app.mkr_ROI.Position(3)/2;
                    if (FreqCenter*1e+6 < app.specData(ind1).MetaData.FreqStart) || ...
                       (FreqCenter*1e+6 > app.specData(ind1).MetaData.FreqStop)
                    
                       return
                    end

                    app.play_FindPeaks_PeakCF.Value = round(FreqCenter, 3);
                    app.play_FindPeaks_PeakBW.Value = round(app.mkr_ROI.Position(3) * 1000, 3);

                    ind2 = app.play_FindPeaks_Tree.SelectedNodes(1).NodeData;
                    app.line_ClrWrite.MarkerIndices(ind2) = round((app.play_FindPeaks_PeakCF.Value*1e+6 - app.bCoef)/app.aCoef);
                    
                    % Se tiver apenas um marcador, então a string fica como
                    % cell. Caso tenha mais de um marcador, então a string
                    % fica como char.
                    markerTag = findobj('Type', 'Text', 'String', sprintf('  %d', ind2));
                    if isempty(markerTag)
                        markerTag = findobj('Type', 'Text', 'String', {sprintf('  %d', ind2)});
                    end
                    markerTag.Position(1:2) = [app.play_FindPeaks_PeakCF.Value, app.line_ClrWrite.YData(app.line_ClrWrite.MarkerIndices(ind2))];
                    
                    set(app.play_FindPeaks_Tree.Children(ind2), 'Text', sprintf("%d: %.3f MHz ⌂ %.3f kHz", ind2, app.play_FindPeaks_PeakCF.Value, app.play_FindPeaks_PeakBW.Value), ...
                                                                'NodeData', ind2)
                    
                case{'ROIMoved'}
                    enableDefaultInteractivity(app.axes1)
                    
                    ind2 = app.play_FindPeaks_Tree.SelectedNodes(1).NodeData;
                    
                    newIndex = round((app.play_FindPeaks_PeakCF.Value*1e+6 - app.bCoef)/app.aCoef);
                    
                    app.specData(ind1).Emissions(ind2,[1:3, 5]) = {newIndex, app.play_FindPeaks_PeakCF.Value, app.play_FindPeaks_PeakBW.Value, 'Detecção manual'};
                    app.specData(ind1).Emissions = sortrows(app.specData(ind1).Emissions, 'Index');
                    
                    selectedEmission = find(app.specData(ind1).Emissions.Index == newIndex, 1);
                    Plot_StartUp2_Spectrum(app, 'PeakValueChanged', ind1, selectedEmission)
            end            
        end