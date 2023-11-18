classdef userData

    properties
        %-----------------------------------------------------------------%
        customPlayback       = struct('Type', 'auto', 'Parameters', [])

        occCache             = struct('Info', {}, 'THR', {}, 'Data', {})
        occMethod            = struct('RelatedIndex', [], 'SelectedIndex', [], 'CacheIndex', [])

        channelLibIndex      = []
        channelManual        = table('Size', [0, 9],                                                                                      ...
                                     'VariableTypes', {'cell', 'cell', 'double', 'double', 'double', 'double', 'cell', 'cell', 'cell'}, ...
                                     'VariableNames', {'Name', 'Band', 'FirstChannel', 'LastChannel', 'StepWidth', 'ChannelBW', 'FreqList', 'Reference', 'FindPeaksName'})

        bandLimitsStatus     = false
        bandLimitsTable      = table('Size', [0, 2],                        ...
                                     'VariableTypes', {'double', 'double'}, ...
                                     'VariableNames', {'FreqStart', 'FreqStop'})

        Emissions            = table('Size', [0, 5],                                                     ...
                                     'VariableTypes', {'uint16', 'double', 'double', 'logical', 'cell'}, ...
                                     'VariableNames', {'Index', 'Frequency', 'BW', 'isTruncated', 'Detection'})

        measCalibration      = table('Size', [0, 3],                            ...
                                     'VariableTypes', {'cell', 'cell', 'cell'}, ...
                                     'VariableNames', {'oldUnitLevel', 'newUnitLevel', 'Name'})

        reportFlag           = false
        
        reportOCC            = []
        reportDetection      = [] % struct('ManualMode', 0, 'Algorithm', {}, 'Parameters', {})
        reportClassification = [] % struct('Algorithm', {}, 'Parameters', {})

        reportPeaksTable     = []
        reportAttachments    = struct('image', '', 'table', struct('Source', '', 'SheetID', 1))
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function reportProperties_DefaultValues(app, idx1)
            
            % Criação dos campos "reportDetection" e "reportClassification", caso 
            % aplicável.
        
            for ii = idx1
                app.specData(ii).UserData.reportFlag = true;
        
                % As propriedades "reportOCC", "reportDetection" e "reportClassification"
                % são criadas aqui...
                
                % Ocupação
                if isempty(app.specData(ii).UserData.reportOCC)
                    if isempty(app.specData(ii).UserData.occMethod.CacheIndex)
                        if isempty(app.specData(ii).UserData.occMethod.RelatedIndex)        
                            app.specData(ii).UserData.reportOCC = class.Constants.reportOCC;
                        else
                            idx2 = app.specData(ii).UserData.occMethod.SelectedIndex;
                            app.specData(ii).UserData.reportOCC = struct('Method',                  'Linear fixo (COLETA)', ...
                                                                         'IntegrationTimeCaptured', mean(app.specData(idx2).RelatedFiles.RevisitTime)/60, ...
                                                                         'THRCaptured',             app.specData(idx2).MetaData.Threshold);
                        end
                        occIndex = play_OCCIndex(app, ii, 'REPORT');
        
                    else
                        occIndex = app.specData(ii).UserData.occMethod.CacheIndex;
                    end
                    app.specData(ii).UserData.reportOCC = app.specData(ii).UserData.occCache(occIndex).Info;
                end

                % Detecção de emissões
                if isempty(app.specData(ii).UserData.reportDetection)
                    findPeaks = FindPeaksOfPrimaryBand(app.channelObj, app.specData(ii));
                    if isempty(findPeaks)
                        app.specData(ii).UserData.reportDetection = class.Constants.reportDetection;
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
                end

                % Classificação das emissões
                if isempty(app.specData(ii).UserData.reportClassification)
                    app.specData(ii).UserData.reportClassification = class.Constants.reportClassification;
                end
            end
        end
    end
end