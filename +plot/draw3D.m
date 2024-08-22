classdef (Abstract) draw3D

    methods (Static = true)
        %-----------------------------------------------------------------%
        function [hWaterfall, Decimation] = Waterfall(operationType, varargin)
            switch operationType
                case 'Creation'
                    hAxes   = varargin{1};
                    bandObj = varargin{2};
                    idx     = varargin{3};

                    defaultProp = bandObj.callingApp.General;
                    customProp  = bandObj.callingApp.specData(idx).UserData.customPlayback.Parameters;
        
                    [plotConfig,   ...
                     Fcn,          ...
                     Decimation,   ...
                     colormapName, ...
                     cLimits]   = plot.Config('Waterfall', defaultProp, customProp);
        
                    xArray      = bandObj.xArray';
                    xLim        = [xArray(1), xArray(end)];
                    specData    = bandObj.callingApp.specData(idx);
                    nSweeps     = numel(specData.Data{1});
        
                    set(hAxes, 'CLimMode', 'auto')
                    switch Fcn
                        case 'mesh'
                            switch Decimation
                                case 'auto'
                                    nWaterFallPoints    = bandObj.DataPoints * nSweeps;
                                    nMaxWaterFallPoints = class.Constants.nMaxWaterFallPoints;
                                    if nWaterFallPoints > nMaxWaterFallPoints; nDecimation = ceil(nWaterFallPoints/nMaxWaterFallPoints);
                                    else;                                      nDecimation = 1;
                                    end        
                                otherwise
                                    nDecimation = str2double(Decimation);
                            end
                
                            while true
                                tArray = specData.Data{1}(1:nDecimation:end);
                                if numel(tArray) > 1; break
                                else;                 nDecimation = round(nDecimation/2);
                                end
                            end
                
                            if tArray(1) == tArray(end)
                                tArray(end) = tArray(1)+seconds(1);
                            end
                            yLim = [tArray(1), tArray(end)];
                            plot.axes.Ruler(hAxes, xLim, yLim)
                
                            [X, Y] = meshgrid(xArray, tArray);
                            hWaterfall = mesh(hAxes, X, Y, specData.Data{2}(:,1:nDecimation:end)', plotConfig{:});
                            Decimation = num2str(nDecimation);

                        case 'image'
                            yLim = [1, nSweeps];
                            plot.axes.Ruler(hAxes, xLim, yLim)

                            hWaterfall = image(hAxes, xArray, 1:nSweeps, specData.Data{2}', plotConfig{:});
                            Decimation = 'auto';
                    end
                    
                    if isempty(cLimits)
                        cLimits = bandObj.callingApp.restoreView(3).cLim;
                        hAxes.UserData.CLimMode = 'auto';
                    else                        
                        hAxes.UserData.CLimMode = 'manual';
                    end
                    
                    postPlotConfig = {'YLim', yLim, 'CLim', cLimits};
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


        %---------------------------------------------------------------------%
        function hPersistanceObj = Persistance(operationType, hPersistanceObj, varargin)
            switch operationType
                case {'Creation', 'Update'}
                    hAxes       = varargin{1};
                    bandObj     = varargin{2};
                    idx         = varargin{3}; 

                    specData    = bandObj.callingApp.specData(idx);
                    idxTime     = bandObj.callingApp.idxTime;

                    defaultProp = bandObj.callingApp.General;
                    customProp  = bandObj.callingApp.specData(idx).UserData.customPlayback.Parameters;
        
                    [plotConfig,   ...
                     windowSize,   ...
                     colormapName, ...
                     Transparency, ...
                     cLimits]   = plot.Config('Persistance', defaultProp, customProp);

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
                                    idx1 = 1;
                                    idx2 = nSweeps;    
                                otherwise
                                    idx2 = idxTime;
                                    idx1 = idx2-nSweeps+1;
                                    if idx1 < 1
                                        idx1 = 1;
                                    end                            
                            end
        
                            specHist = histcounts2(specData.Data{2}(:, idx1:idx2), repmat(bandObj.xArray', 1, idx2-idx1+1), hPersistanceObj.yEdges, hPersistanceObj.xEdges);
                            set(hPersistanceObj.handle, 'CData', (100 * specHist ./ sum(specHist)), 'AlphaData', double(logical(specHist))*Transparency)
                    end

                case 'Delete'
                    if ~isempty(hPersistanceObj)
                        delete(hPersistanceObj.handle)
                        hPersistanceObj = [];
                    end
            end       
        end
    end
end