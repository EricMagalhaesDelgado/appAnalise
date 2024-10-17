classdef userData

    properties
        %-----------------------------------------------------------------%
        customPlayback       = struct('Type', 'auto', 'Parameters', [])

        occCache             = struct('Info', {}, 'THR', {}, 'Data', {})
        occMethod            = struct('RelatedIndex', [], 'SelectedIndex', [], 'CacheIndex', [])

        channelLibIndex      = []
        channelManual        = struct('Name', {}, 'Band', {}, 'FirstChannel', {}, 'LastChannel', {}, 'StepWidth', {}, 'ChannelBW', {}, 'FreqList', {}, 'Reference', {}, 'FindPeaksName', {})

        bandLimitsStatus     = false
        bandLimitsTable      = table('Size', [0, 2],                        ...
                                     'VariableTypes', {'double', 'double'}, ...
                                     'VariableNames', {'FreqStart', 'FreqStop'})

        % O "coringa" para armazenar informações individualizadas por emissão
        % é o "UserData". Já criados os campos "Description", "ChannelAssigned"
        % e "DriveTest", mas outros deverão ser criados no futuro...
        Emissions            = table(uint32([]), [], [], true(0,1), {}, struct('Description', {}, 'ChannelAssigned', {}, 'DriveTest', {}), ...
                                     'VariableNames', {'Index', 'Frequency', 'BW', 'isTruncated', 'Detection', 'UserData'})

        measCalibration      = table('Size', [0, 4],                                    ...
                                     'VariableTypes', {'cell', 'cell', 'cell', 'cell'}, ...
                                     'VariableNames', {'Name', 'Type', 'oldUnitLevel', 'newUnitLevel'})

        reportFlag           = false        
        reportOCC            = []
        reportDetection      = [] % struct('ManualMode', 0, 'Algorithm', {}, 'Parameters', {})
        reportClassification = [] % struct('Algorithm', {}, 'Parameters', {})
        reportPeaksTable     = []
        reportExternalFiles  = table('Size', [0, 3],                             ...
                                     'VariableTypes', {'uint8', 'cell', 'cell'}, ...
                                     'VariableNames', {'ID', 'Tag', 'Filename'});
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function userDataTemplate = emissionUserDataTemplate()
            userDataTemplate = struct('Description',     '',                                       ...
                                      'ChannelAssigned', struct('Frequency', {}, 'ChannelBW', {}), ...
                                      'DriveTest',       []);
        end

        %-----------------------------------------------------------------%
        function reportProperties_DefaultValues(specData, idxThreads, callingApp)        
            for ii = idxThreads
                specData(ii).UserData.reportFlag = true;
        
                % As propriedades "reportOCC", "reportDetection" e "reportClassification"
                % são criadas aqui...
                
                % Ocupação
                if isempty(specData(ii).UserData.reportOCC)
                    if isempty(specData(ii).UserData.occMethod.CacheIndex)
                        if isempty(specData(ii).UserData.occMethod.RelatedIndex)        
                            specData(ii).UserData.reportOCC = class.Constants.reportOCC;
                        else
                            idx2 = specData(ii).UserData.occMethod.SelectedIndex;
                            specData(ii).UserData.reportOCC = struct('Method',                  'Linear fixo (COLETA)',                           ...
                                                                     'IntegrationTimeCaptured', mean(specData(idx2).RelatedFiles.RevisitTime)/60, ...
                                                                     'THRCaptured',             specData(idx2).MetaData.Threshold);
                        end
                        occIndex = play_OCCIndex(callingApp, ii, 'REPORT');
        
                    else
                        occIndex = specData(ii).UserData.occMethod.CacheIndex;
                    end
                    specData(ii).UserData.reportOCC = specData(ii).UserData.occCache(occIndex).Info;
                end

                % Detecção de emissões
                if isempty(specData(ii).UserData.reportDetection)
                    findPeaks = FindPeaksOfPrimaryBand(callingApp.channelObj, specData(ii));
                    if isempty(findPeaks)
                        specData(ii).UserData.reportDetection = class.Constants.reportDetection;
                    else
                        specData(ii).UserData.reportDetection = struct('ManualMode', 0,                                               ...
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
                if isempty(specData(ii).UserData.reportClassification)
                    specData(ii).UserData.reportClassification = class.Constants.reportClassification;
                end
            end
        end
    end
end