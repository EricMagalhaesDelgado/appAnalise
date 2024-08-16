classdef (Abstract) draw3D

    methods (Static = true)
        %---------------------------------------------------------------------%
        function hPersistanceObj = Persistance(hAxes, bandObj, idx, hPersistanceObj, operationType)
            xArray        = bandObj.xArray';
            specData      = bandObj.callingApp.specData(idx);
            nSweeps       = numel(specData.Data{1});
            defaultProp   = bandObj.callingApp.General;
            customProp    = specData.UserData.customPlayback.Parameters;
            Context       = bandObj.Context;

            [plotConfig,   ...
             Samples,      ...
             Colormap,     ...
             Transparency, ...
             LevelLimits] = plot.Config('Persistance', defaultProp, customProp);
            
            switch operationType
                case 'Creation'
                    DataPoints  = numel(bandObj.xArray);
                    FreqStart   = bandObj.FreqStart;
                    FreqStop    = bandObj.FreqStop;
    
                    xResolution = min(801, DataPoints);
                    yResolution = 201;
        
                    ySamples      = str2double(Samples);
                    if isnan(ySamples)
                        ySamples  = nSweeps;
                    end
            
                    yAmplitude    = class.Constants.yMaxLimRange;
                    [yMin, yMax]  = bounds(specData.Data{2}, 'all');
                    yMax          = max(yMin+yAmplitude, yMax);
                    yMin          = yMax-yAmplitude;
                    
                    xEdges        = linspace(FreqStart, FreqStop, xResolution+1);
                    yEdges        = linspace(yMin, yMax, yResolution+1);
                    specHist      = zeros(yResolution, xResolution);
    
                    hPersistance  = image(hAxes, specHist, 'AlphaData', specHist,'XData', [FreqStart, FreqStop], 'YData', [yMin, yMax], plotConfig{:});
                    
                    hPersistanceObj = struct('handle',   hPersistance, ...
                                             'ySamples', ySamples,     ...
                                             'xEdges',   xEdges,       ...
                                             'yEdges',   yEdges);
    
                    hPersistanceObj = plot.draw3D.Persistance(hAxes, bandObj, idx, hPersistanceObj, 'Update');
    
                case 'Update'
                    switch Samples
                        case 'full'
                            specHist = histcounts2(specData.Data{2}, repmat(xArray, 1, nSweeps), hPersistanceObj.yEdges, hPersistanceObj.xEdges);    
                            set(hPersistanceObj.handle, 'CData', (100 * specHist ./ sum(specHist)), 'AlphaData', double(logical(specHist))*Transparency)
    
                        otherwise
                            idx2 = app.timeIndex;
                            idx1 = idx2 - (hPersistanceObj.ySamples-1);
                            if idx1 < 1
                                idx1 = 1;
                            end            
                            
                            specHist = histcounts2(specData.Data{2}(:, idx1:idx2), repmat(xArray, 1, idx2-idx1+1), hPersistanceObj.yEdges, hPersistanceObj.xEdges);    
                            set(hPersistanceObj.handle, 'CData', (100 * specHist ./ sum(specHist)), 'AlphaData', double(logical(specHist))*Transparency)
                    end

                case 'Delete'
                    if ~isempty(hPersistanceObj)
                        delete(hPersistanceObj.handle)
                        hPersistanceObj = [];
                    end
            end

            plot.axes.StackingOrder.execute(hAxes, Context)
        end
    end
end