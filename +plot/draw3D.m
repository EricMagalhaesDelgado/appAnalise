classdef (Abstract) draw3D

    methods (Static = true)
        %-----------------------------------------------------------------%
        function [hWaterfall, Decimation] = Waterfall(operationType, varargin)
            switch operationType
                case 'Creation'
                    hAxes   = varargin{1};
                    bandObj = varargin{2};
                    idx     = varargin{3};

                    Context     = bandObj.Context;
                    defaultProp = bandObj.callingApp.General;
                    customProp  = bandObj.callingApp.specData(idx).UserData.customPlayback.Parameters;
        
                    [plotConfig,   ...
                     Fcn,          ...
                     Decimation,   ...
                     colormapName, ...
                     cLimits]   = plot.Config('Waterfall', defaultProp, customProp, Context);
        
                    xArray      = bandObj.xArray';
                    xLim        = [xArray(1), xArray(end)];
                    specData    = bandObj.callingApp.specData(idx);
                    nSweeps     = numel(specData.Data{1});
        
                    set(hAxes, 'CLimMode', 'auto')
                    switch Fcn
                        case 'mesh'
                            [nDecimation, tArray] = plot.draw3D.checkDecimation(specData, bandObj, Decimation, 1);
                
                            if tArray(1) == tArray(end)
                                tArray(end) = tArray(1)+seconds(1);
                            end
                            yLim = [tArray(1), tArray(end)];
                            plot.axes.Ruler(hAxes, xLim, yLim)
                
                            [X, Y] = meshgrid(xArray, tArray);
                            hWaterfall = mesh(hAxes, X, Y, specData.Data{2}(:,1:nDecimation:end)', plotConfig{:});                            

                        case 'image'
                            nDecimation = plot.draw3D.checkDecimation(specData, bandObj, Decimation, 16);

                            idxTimeArray = 1:nDecimation:nSweeps;
                            if idxTimeArray(end) ~= nSweeps
                                idxTimeArray(end+1) = nSweeps;
                            end

                            yLim = [1, nSweeps];
                            plot.axes.Ruler(hAxes, xLim, yLim)

                            hWaterfall = image(hAxes, xArray, idxTimeArray, specData.Data{2}(:, idxTimeArray)', plotConfig{:});
                    end

                    Decimation = num2str(nDecimation);

                    if isempty(cLimits)
                        cLimits = bandObj.callingApp.restoreView(3).cLim;
                        hAxes.UserData.CLimMode = 'auto';
                    else                        
                        hAxes.UserData.CLimMode = 'manual';
                    end
                    
                    postPlotConfig = {'YLim', yLim, 'CLim', cLimits};
                    if ismember(bandObj.Context, {'appAnalise:REPORT', 'appAnalise:REPORT:BAND', 'appAnalise:REPORT:EMISSION'})
                        postPlotConfig = [postPlotConfig, {'XLim', xLim}];
                        ylabel(hAxes, 'Varredura')
                    end
                    set(hAxes, postPlotConfig{:})
        
                    plot.axes.Colormap(hAxes, colormapName)
                    plot.datatip.Template(hWaterfall, 'Frequency+Timestamp+Level', bandObj.LevelUnit)
                    plot.axes.StackingOrder.execute(hAxes, bandObj.Context)

                case 'Delete'
                    hWaterfall = varargin{1};
                    Decimation = 'auto';
                    
                    if ~isempty(hWaterfall) && isvalid(hWaterfall)
                        cla(hWaterfall.Parent)
                        hWaterfall = [];
                    end
            end
        end

        %-----------------------------------------------------------------%
        function [nDecimation, tArray] = checkDecimation(specData, bandObj, DecimationType, DecimationFactor)
            switch DecimationType
                case 'auto'
                    nWaterFallPoints    = bandObj.DataPoints * bandObj.nSweeps;
                    nMaxWaterFallPoints = DecimationFactor * class.Constants.nMaxWaterFallPoints;

                    if nWaterFallPoints > nMaxWaterFallPoints
                        nDecimation = ceil(nWaterFallPoints/nMaxWaterFallPoints);
                    else
                        nDecimation = 1;
                    end

                otherwise
                    nDecimation = str2double(DecimationType);
            end

            while true
                tArray = specData.Data{1}(1:nDecimation:end);
                if numel(tArray) > 1; break
                else;                 nDecimation = round(nDecimation/2);
                end
            end
        end

        %-----------------------------------------------------------------%
        function windowSize = checkWindowSize(bandObj, windowSize)
            if windowSize == "full"
                nPersistancePoints    = bandObj.DataPoints * bandObj.nSweeps;
                nMaxPersistancePoints = class.Constants.nMaxPersistancePoints;

                if nPersistancePoints > nMaxPersistancePoints
                    windowSize = num2str(min(bandObj.nSweeps, 512));
                end
            end
        end

        %-----------------------------------------------------------------%
        function [hPersistanceObj, windowSize] = Persistance(operationType, hPersistanceObj, varargin)
            switch operationType
                case {'Creation', 'Update'}
                    hAxes       = varargin{1};
                    bandObj     = varargin{2};
                    idx         = varargin{3}; 

                    specData    = bandObj.callingApp.specData(idx);

                    defaultProp = bandObj.callingApp.General;
                    customProp  = bandObj.callingApp.specData(idx).UserData.customPlayback.Parameters;
        
                    [plotConfig,   ...
                     windowSize,   ...
                     colormapName, ...
                     Transparency, ...
                     cLimits]   = plot.Config('Persistance', defaultProp, customProp);
                    windowSize  = plot.draw3D.checkWindowSize(bandObj, windowSize);

                    switch operationType
                        case 'Creation'    
                            xResolution = min(801, bandObj.DataPoints);
                            yResolution = 201;
                    
                            yAmplitude    = class.Constants.yMaxLimRange;
                            [yMin, yMax]  = bounds(specData.Data{2}, 'all');
                            yMax          = max(yMin+yAmplitude, yMax);
                            yMin          = yMax-yAmplitude;
                            
                            xEdges        = linspace(bandObj.FreqStart, bandObj.FreqStop, xResolution+1);
                            yEdges        = linspace(yMin, yMax, yResolution+1);
                            specHist      = zeros(yResolution, xResolution);
            
                            hPersistance  = image(hAxes, specHist, 'AlphaData', specHist,'XData', [bandObj.FreqStart, bandObj.FreqStop], 'YData', [yMin, yMax], plotConfig{:});
                            
                            % Cria uma imagem vazia, o que possibilita criar o
                            % objeto hPersistanceObj. E logo em seguida chama essa
                            % mesma função, mas no modo "Update".
                            hPersistanceObj = struct('handle',   hPersistance, ...
                                                     'xEdges',   xEdges,       ...
                                                     'yEdges',   yEdges);
            
                            set(hAxes, 'CLimMode', 'auto')
                            hPersistanceObj = plot.draw3D.Persistance('Update', hPersistanceObj, hAxes, bandObj, idx);
                            
                            if isempty(cLimits)
                                hAxes.UserData.CLimMode = 'auto';
                            else
                                hAxes.CLim  = cLimits;
                                hAxes.UserData.CLimMode = 'manual';
                            end
        
                            plot.axes.Colormap(hAxes, colormapName)
                            plot.axes.StackingOrder.execute(hAxes, bandObj.Context)
            
                        case 'Update'
                            if isempty(hPersistanceObj)
                                hPersistanceObj = plot.draw3D.Persistance('Creation', hPersistanceObj, hAxes, bandObj, idx);
                                return
                            end

                            nSweeps = numel(specData.Data{1});
                            switch windowSize
                                case 'full'
                                    idxTimeArray = 1:nSweeps;

                                otherwise
                                    winSize = str2double(windowSize);

                                    switch bandObj.Context
                                        case {'appAnalise:PLAYBACK', 'appAnalise:DRIVETEST'}
                                            idxTime = bandObj.callingApp.idxTime;
                                            idxTimeArray = max(1,idxTime-winSize+1):idxTime;

                                        case {'appAnalise:REPORT', 'appAnalise:REPORT:BAND', 'appAnalise:REPORT:EMISSION'}
                                            idxTimeArray = round(linspace(1, nSweeps, winSize));
                                    end                          
                            end

                            nTimeArray = numel(idxTimeArray);
        
                            specHist = histcounts2(specData.Data{2}(:, idxTimeArray), repmat(bandObj.xArray', 1, nTimeArray), hPersistanceObj.yEdges, hPersistanceObj.xEdges);
                            set(hPersistanceObj.handle, 'CData', (100 * specHist ./ sum(specHist)), 'AlphaData', double(logical(specHist))*Transparency)
                    end

                case 'Delete'
                    windowSize = '';

                    if ~isempty(hPersistanceObj)
                        delete(hPersistanceObj.handle)
                        hPersistanceObj = [];
                    end
            end       
        end
    end
end