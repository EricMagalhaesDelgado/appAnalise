function Table = Algorithms(specData, idxThread)

    Table = table('Size', [3, 2],                    ...
                  'VariableTypes', {'cell', 'cell'}, ...
                  'VariableNames', {'Algorithm', 'Parameters'});
        
    % Ocupação
    if isempty(specData(idxThread).UserData.Emissions)
        Occupancy = {sprintf('Método: %s',       specData(idxThread).UserData.reportAlgorithms.Occupancy.Method); ...
                     sprintf('• Parâmetros: %s', jsonencode(structUtil.delEmptyFields(specData(idxThread).UserData.reportAlgorithms.Occupancy, {'Method'})))};

    else        
        occList  = arrayfun(@(x) x.Occupancy, specData(idxThread).UserData.Emissions.Algorithms, 'UniformOutput', false);
        [occType, ~, occTypeIndex] = unique(occList, 'stable');

        Occupancy = {};        
        for ii = 1:numel(occType)
            sOCCType   = jsondecode(occType{ii});
            sOCCIndex  = find(occTypeIndex == ii);
            peaksLabel = strjoin(string(sOCCIndex), ', ');
    
            Occupancy(end+1:end+3,1) = {sprintf('Método: %s',       sOCCType.Method);                                                                     ...
                                        sprintf('• Parâmetros: %s', jsonencode(structUtil.delEmptyFields(sOCCType, {'Method'}), "ConvertInfAndNaN", false)); ...
                                        sprintf('• Emissões: %s',   peaksLabel)};
    
            if (numel(occType) > 1) && (ii < numel(occType))
                Occupancy(end+1) = {'&nbsp;'};
            end
        end
    end

    % Detecção
    bandLimitsStatus = specData(idxThread).UserData.bandLimitsStatus;
    bandLimitsTable  = specData(idxThread).UserData.bandLimitsTable;
    if ~bandLimitsStatus || isempty(bandLimitsTable)
        bandLimits = sprintf('Faixa sob análise: %.3f - %.3f MHz', specData(idxThread).MetaData.FreqStart / 1e+6, ...
                                                                   specData(idxThread).MetaData.FreqStop  / 1e+6);    
    else
        bandLimits = {};
        for ii = 1:height(bandLimitsTable)
            bandLimits{end+1} = sprintf('%.3f - %.3f MHz', bandLimitsTable.FreqStart(ii), ...
                                                           bandLimitsTable.FreqStop(ii));
        end
        bandLimits = sprintf('Faixa sob análise: %s', strjoin(bandLimits, ', '));
    end

    % Essa operação aqui surgiu por conta da inclusão de emissões através
    % de arquivos (seja ele gerado pelo ROMES ou outra ferramenta).
    detectionList  = arrayfun(@(x) x.Detection, specData(idxThread).UserData.Emissions.Algorithms, 'UniformOutput', false);
    [DetectionType, ~, DetectionTypeIndex] = unique(detectionList, 'stable');

    if specData(idxThread).UserData.reportAlgorithms.Detection.ManualMode
        Detection = {'Detecção limitada às emissoes identificadas no modo PLAYBACK do appAnalise'; bandLimits};
    else
        Detection = {'Detecção não limitada às emissões identificadas no modo PLAYBACK do appAnalise'; bandLimits; ...
                     sprintf('Algoritmo: %s',  specData(idxThread).UserData.reportAlgorithms.Detection.Algorithm);       ...
                     sprintf('• Parâmetros: %s', jsonencode(specData(idxThread).UserData.reportAlgorithms.Detection.Parameters, "ConvertInfAndNaN", false))};
    end

    if ~isempty(DetectionType)
        Detection = [Detection; '&nbsp;'];
    end

    for ii =1:numel(DetectionType)
        sOCCType   = jsondecode(DetectionType{ii});
        sOCCIndex  = find(DetectionTypeIndex == ii);
        peaksLabel = strjoin(string(sOCCIndex), ', ');

        if isfield(sOCCType, 'Parameters')
            Detection(end+1:end+3,1) = {sprintf('Algoritmo: %s',    sOCCType.Algorithm);                                         ...
                                        sprintf('• Parâmetros: %s', jsonencode(sOCCType.Parameters, "ConvertInfAndNaN", false)); ...
                                        sprintf('• Emissões: %s',   peaksLabel)};
        else
            Detection(end+1:end+2,1) = {sprintf('Algoritmo: %s',    sOCCType.Algorithm); ...
                                        sprintf('• Emissões: %s',   peaksLabel)};
        end

        if (numel(DetectionType) > 1) && (ii < numel(DetectionType))
            Detection(end+1) = {'&nbsp;'};
        end
    end
    
    % Classificação
    Classification = {sprintf('Algoritmo: %s',  specData(idxThread).UserData.reportAlgorithms.Classification.Algorithm); ...
                      sprintf('• Parâmetros: %s', jsonencode(specData(idxThread).UserData.reportAlgorithms.Classification.Parameters, "ConvertInfAndNaN", false))};


    Table(1,:) = {'Ocupação',                  Occupancy};
    Table(2,:) = {'Detecção de emissões',      Detection};
    Table(3,:) = {'Classificação de emissões', Classification};
end