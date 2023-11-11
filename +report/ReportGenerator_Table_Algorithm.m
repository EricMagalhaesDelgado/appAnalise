function Table = ReportGenerator_Table_Algorithm(SpecInfo, idx)

    Table = table('Size', [3, 2],                    ...
                  'VariableTypes', {'cell', 'cell'}, ...
                  'VariableNames', {'Algorithm', 'Parameters'});
        
    % Ocupação
    Ocupation = {sprintf('Método: %s',     SpecInfo(idx).UserData.reportOCC.Method); ...
                 sprintf('Parâmetros: %s', jsonencode(rmfield(SpecInfo(idx).UserData.reportOCC, 'Method')))};


    % Detecção
    bandLimitsStatus = SpecInfo(idx).UserData.bandLimitsStatus;
    bandLimitsTable  = SpecInfo(idx).UserData.bandLimitsTable;
    if ~bandLimitsStatus || isempty(bandLimitsTable)
        bandLimits = sprintf('Faixa sob análise: %.3f - %.3f MHz', SpecInfo(idx).MetaData.FreqStart / 1e+6, ...
                                                                   SpecInfo(idx).MetaData.FreqStop  / 1e+6);    else
        bandLimits = {};
        for ii = 1:height(bandLimitsTable)
            bandLimits{end+1} = sprintf('%.3f - %.3f MHz', bandLimitsTable.FreqStart(ii), ...
                                                           bandLimitsTable.FreqStop(ii));
        end
        bandLimits = sprintf('Faixa sob análise: %s', strjoin(bandLimits, ', '));
    end
    
    [DetectionType, ~, DetectionTypeIndex] = unique(SpecInfo(idx).UserData.reportPeaksTable.Detection, 'stable');

    Detection = {};
    if SpecInfo(idx).UserData.reportDetection.ManualMode
        Detection = {'Detecção limitada às emissoes identificadas no modo PLAYBACK do appAnalise'; ...
                     '&nbsp;'};
    end

    for ii =1:numel(DetectionType)
        sDetectionType  = jsondecode(DetectionType{ii});
        sDetectionIndex = find(DetectionTypeIndex == ii);
        PeaksLabel      = strjoin("P" + string(sDetectionIndex), ', ');

        if isfield(sDetectionType, 'Parameters')
            Detection(end+1:end+4,1) = {sprintf('Algoritmo: %s',  sDetectionType.Algorithm);              ...
                                        sprintf('Parâmetros: %s', jsonencode(sDetectionType.Parameters)); ...
                                        bandLimits; sprintf('Emissões: %s', PeaksLabel)};
        else
            Detection(end+1:end+3,1) = {sprintf('Algoritmo: %s',  sDetectionType.Algorithm);              ...
                                        bandLimits; sprintf('Emissões: %s', PeaksLabel)};
        end

        if (numel(DetectionType) > 1) && (ii < numel(DetectionType))
            Detection(end+1) = {'&nbsp;'};
        end
    end
    
    % Classificação
    Classification = {sprintf('Algoritmo: %s',  SpecInfo(idx).UserData.reportClassification.Algorithm); ...
                      sprintf('Parâmetros: %s', jsonencode(SpecInfo(idx).UserData.reportClassification.Parameters))};

    Table(1,:) = {'Ocupação',                  Ocupation};
    Table(2,:) = {'Detecção de emissões',      Detection};
    Table(3,:) = {'Classificação de emissões', Classification};
end