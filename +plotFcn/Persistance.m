function Persistance(app)

    if app.play_Persistance.Value
        set(app.play_PersistanceGrid.Children, Enable=1)

        % Identifica índice do fluxo espectral plotado.
        idx = [];
        if ~isempty(app.play_PlotPanel.UserData)
            idx = app.play_PlotPanel.UserData.NodeData;
        end

        % Pendente
        
    else
        set(findobj(app.play_PersistanceGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigridlayout'}), Enable=0)
    end
    drawnow
end





        function Plot_StartUp2_Persistance(app)

            % SELECTED DATA
            ind = app.traceInfo.SelectedNode;
            
            FreqStart  = app.specData(ind).MetaData.FreqStart / 1e+6;
            FreqStop   = app.specData(ind).MetaData.FreqStop  / 1e+6;
            DataPoints = app.specData(ind).MetaData.DataPoints;


            % IMAGE
            % (a) RESOLUTION (801x201 pixels)
            yResolution   = 201;
            xResolution   = 801;
            if DataPoints < xResolution; xResolution = DataPoints;
            end

            % (b) INTERPOLATION, LEVEL AMPLITUDE AND ALPHADATA
            Interpolation = app.play_Persistance_Interpolation.Value;
            yAmplitude    = 100;

            % (c) WINDOW SIZE (PLAYBACK)
            ySamples = str2double(app.play_Persistance_Samples.Value);
            if isnan(ySamples); ySamples = app.specData(ind).Samples;
            end


            % PROCESSING...
            yMin = min(app.specData(ind).Data{2}, [], 'all');
            yMax = yMin+yAmplitude;
            
            xEdges = linspace(FreqStart, FreqStop, xResolution+1);
            yEdges = linspace(yMin, yMax, yResolution+1);            
            
            specHist = zeros(yResolution, xResolution);
            hImg = image(app.axes1, specHist, 'alphadata', im2double(specHist),'XData', [FreqStart, FreqStop], 'YData', [yMin, yMax], 'Tag', 'Persistance');
            set(hImg, CDataMapping = "scaled", Interpolation = Interpolation, AlphaData = im2double(specHist))
            
            app.obj_Persistance = struct('handle',   hImg,     ...
                                         'ySamples', ySamples, ...
                                         'xEdges',   xEdges,   ...
                                         'yEdges',   yEdges);
            
            Plot_Persistance_Update(app, ind)

            app.play_Persistance_cLim1.Value = app.axes1.CLim(1);
            app.play_Persistance_cLim2.Value = app.axes1.CLim(2);

            uistack(hImg, 'bottom')

        end


        function Plot_Persistance_Update(app, ind)

            if app.play_Persistance_Samples.Value == "full"
                specHist = histcounts2(app.specData(ind).Data{2}, repmat(app.x', 1, app.specData(ind).Samples), ...
                                       app.obj_Persistance.yEdges, ...
                                       app.obj_Persistance.xEdges);

            else
                idx2 = app.timeIndex;
                idx1 = idx2 - (app.obj_Persistance.ySamples-1);
                if idx1 < 1; idx1 = 1;
                end            
                
                specHist = histcounts2(app.specData(ind).Data{2}(:, idx1:idx2), repmat(app.x', 1, idx2-idx1+1), ...
                                       app.obj_Persistance.yEdges, ...
                                       app.obj_Persistance.xEdges);
            end

            set(app.obj_Persistance.handle, 'CData', (100 * specHist ./ sum(specHist)), ...
                                            'AlphaData', double(logical(specHist))*app.play_Persistance_Transparency.Value)
            
            drawnow

        end