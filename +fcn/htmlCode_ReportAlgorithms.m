function htmlContent = htmlCode_ReportAlgorithms(specData)

    threadTag = sprintf('%.3f - %.3f MHz', specData.MetaData.FreqStart/1e+6, specData.MetaData.FreqStop/1e+6);

    if specData.UserData.bandLimitsStatus && height(specData.UserData.bandLimitsTable)
        detectionBands = strjoin(arrayfun(@(x,y) sprintf('%.3f - %.3f MHz', x, y), specData.UserData.bandLimitsTable.FreqStart, ...
                                                                                   specData.UserData.bandLimitsTable.FreqStop, 'UniformOutput', false), ', ');
    else
        detectionBands = sprintf('%.3f - %.3f MHz', specData.MetaData.FreqStart/1e+6, ...
                                                    specData.MetaData.FreqStop /1e+6);
    end

    dataStruct    = struct('group', 'OCUPAÇÃO', 'value', specData.UserData.reportOCC);
    dataStruct(2) = struct('group', 'DETECÇÃO ASSISTIDA', 'value', struct('Origin', 'PLAYBACK', 'BandLimits', detectionBands));
    if ~specData.UserData.reportDetection.ManualMode
        dataStruct(end+1) = struct('group', 'DETECÇÃO NÃO ASSISTIDA', 'value', struct('Origin',     'RELATÓRIO', ...
                                                                                      'BandLimits',  detectionBands,     ...
                                                                                      'Algorithm',   specData.UserData.reportDetection.Algorithm, ...
                                                                                      'Parameters',  jsonencode(specData.UserData.reportDetection.Parameters)));
    end
    dataStruct(end+1)  = struct('group', 'CLASSIFICAÇÃO', 'value', struct('Algorithm',   specData.UserData.reportClassification.Algorithm, ...
                                                                          'Parameters',  specData.UserData.reportClassification.Parameters));
    
    htmlContent   = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; line-height: 12px; margin: 5px; padding-top: 5px; padding-bottom: 10px;"><b>%s</b></p>', threadTag), ...
                    textFormatGUI.struct2PrettyPrintList(dataStruct)];
end