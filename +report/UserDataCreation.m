function UserDataCreation(app, idx1)
    
    % Criação dos campos "reportDetection" e "reportClassification", caso 
    % aplicável.

    for ii = idx1
        app.specData(ii).UserData.reportFlag = true;

        % As propriedades "reportOCC", "reportDetection" e "reportClassification"
        % são criadas apenas aqui. Por isso, avalia-se se "reportOCC" está vazia 
        % e, em caso positivo, cria-se toda a informação.
        
        if isempty(app.specData(ii).UserData.reportOCC)       || ...
           isempty(app.specData(ii).UserData.reportDetection) || ...
           isempty(app.specData(ii).UserData.reportClassification)
            
            % Ocupação
            if isempty(app.specData(ii).UserData.occMethod.CacheIndex)
                if isempty(app.specData(ii).UserData.occMethod.RelatedIndex)        
                    app.specData(ii).UserData.reportOCC = struct('Method',            'Linear adaptativo', ...
                                                                 'IntegrationTime',    15,                 ...
                                                                 'Offset',             12,                 ...
                                                                 'noiseFcn',           'mean',             ...
                                                                 'noiseTrashSamples',  0.10,               ...
                                                                 'noiseUsefulSamples', 0.20);
                else
                    idx2 = app.specData(ii).UserData.occMethod.SelectedIndex;
    
                    app.play_OCC_THRCaptured.Value = num2str(app.specData(idx2).MetaData.Threshold);
                    app.play_OCC_IntegrationTimeCaptured.Value = mean(app.specData(idx2).RelatedFiles.RevisitTime)/60;

                    occIndex = play_OCCIndex(app, ii);
                    app.specData(ii).UserData.reportOCC = app.specData(ii).UserData.occCache(occIndex).Info;
                end

            else
                occIndex = app.specData(ii).UserData.occMethod.CacheIndex;
                app.specData(ii).UserData.reportOCC = app.specData(ii).UserData.occCache(occIndex).Info;
            end

            % Detecção de emissões
            findPeaks = FindPeaksOfPrimaryBand(app.channelObj, app.specData(ii));
            if isempty(findPeaks)
                app.specData(ii).UserData.reportDetection = struct('ManualMode', 0,                        ...
                                                                   'Algorithm', 'FindPeaks+OCC',           ...
                                                                   'Parameters', struct('Distance',    25, ... % kHz
                                                                                        'BW',          10, ... % kHz
                                                                                        'Prominence1', 10, ...
                                                                                        'Prominence2', 30, ...
                                                                                        'meanOCC',     10, ...
                                                                                        'maxOCC',      67));
            else
                app.specData(ii).UserData.reportDetection = struct('ManualMode', 0,                                               ...
                                                                   'Algorithm', 'FindPeaks+OCC',                                  ...
                                                                   'Parameters', struct('Distance',    1000 * findPeaks.Distance, ... % MHz >> kHz
                                                                                        'BW',          1000 * findPeaks.BW,       ... % MHz >> kHz
                                                                                        'Prominence1', findPeaks.Prominence1,     ...
                                                                                        'Prominence2', findPeaks.Prominence2,     ...
                                                                                        'meanOCC',     findPeaks.meanOCC,         ...
                                                                                        'maxOCC',      findPeaks.maxOCC));
            end

            % Classificação das emissões
            app.specData(ii).UserData.reportClassification = struct('Algorithm', 'appAnalise v. 1.20',         ...
                                                                    'Parameters', struct('Contour', 30,        ...
                                                                                         'ClassMultiplier', 2, ...
                                                                                         'bwFactors', [100, 300]));
        end
    end
end