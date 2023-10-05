function Persistance(app, idx, Type)

    hComponents = findobj(app.play_PersistanceGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigridlayout'});

    if app.play_Persistance.Value
        set(hComponents, Enable=1)

        if ~strcmp(app.play_Persistance_Samples.Value, 'full')
            app.play_Persistance_cLim_Mode.Enable = 0;
            set(app.play_Persistance_cLim_Grid2.Children, Enable=0)
        end

        switch Type
            case 'Creation'
                DataPoints    = app.Band.DataPoints;
                FreqStart     = app.Band.FreqStart;
                FreqStop      = app.Band.FreqStop;

                % IMAGE
                % (a) RESOLUTION (801x201 pixels)
                yResolution   = 201;
                xResolution   = min(801, DataPoints);
    
                % (b) INTERPOLATION, LEVEL AMPLITUDE AND ALPHADATA
                Interpolation = app.play_Persistance_Interpolation.Value;   % "nearest" | "bilinear"
                yAmplitude    = class.Constants.yMaxLimRange;
    
                % (c) WINDOW SIZE (PLAYBACK)
                ySamples      = str2double(app.play_Persistance_Samples.Value);
                if isnan(ySamples)
                    ySamples  = numel(app.specData(idx).Data{1});
                end
        
                % PROCESSING...
                [yMin, yMax]  = bounds(app.specData(idx).Data{2}, 'all');
                yMax          = max(yMin+yAmplitude, yMax);
                yMin          = yMax-yAmplitude;
                
                xEdges        = linspace(FreqStart, FreqStop, xResolution+1);
                yEdges        = linspace(yMin, yMax, yResolution+1);
                specHist      = zeros(yResolution, xResolution);

                hImg          = image(app.axes1, specHist, 'alphadata', im2double(specHist),'XData', [FreqStart, FreqStop], 'YData', [yMin, yMax], 'Tag', 'Persistance');
                set(hImg, CDataMapping = "scaled", Interpolation=Interpolation, AlphaData=im2double(specHist), PickableParts='none')
                
                app.obj_Persistance = struct('handle',   hImg,     ...
                                             'ySamples', ySamples, ...
                                             'xEdges',   xEdges,   ...
                                             'yEdges',   yEdges);

                plotFcn.Persistance(app, idx, 'Update')
    
                app.play_Persistance_cLim1.Value = app.axes1.CLim(1);
                app.play_Persistance_cLim2.Value = app.axes1.CLim(2);
    
                uistack(hImg, 'bottom')

            case 'Update'
                switch app.play_Persistance_Samples.Value
                    case 'full'
                        specHist = histcounts2(app.specData(idx).Data{2}, repmat(app.Band.xArray', 1, numel(app.specData(idx).Data{1})), ...
                                               app.obj_Persistance.yEdges, app.obj_Persistance.xEdges);

                        set(app.obj_Persistance.handle, 'CData', (100 * specHist ./ sum(specHist)), ...
                                                        'AlphaData', double(logical(specHist))*app.play_Persistance_Transparency.Value)

                    otherwise
                        idx2 = app.timeIndex;
                        idx1 = idx2 - (app.obj_Persistance.ySamples-1);
                        if idx1 < 1
                            idx1 = 1;
                        end            
                        
                        specHist = histcounts2(app.specData(idx).Data{2}(:, idx1:idx2), repmat(app.Band.xArray', 1, idx2-idx1+1), ...
                                               app.obj_Persistance.yEdges, app.obj_Persistance.xEdges);

                        set(app.obj_Persistance.handle, 'CData', (100 * specHist ./ sum(specHist)), ...
                                                'AlphaData', double(logical(specHist))*app.play_Persistance_Transparency.Value)

                        app.play_Persistance_cLim1.Value = app.axes1.CLim(1);
                        app.play_Persistance_cLim2.Value = app.axes1.CLim(2);
                end
        end
        
    else
        set(hComponents, Enable=0)

        if strcmp(Type, 'Delete')
            delete(app.obj_Persistance.handle)
            app.obj_Persistance = [];
        end
    end
end