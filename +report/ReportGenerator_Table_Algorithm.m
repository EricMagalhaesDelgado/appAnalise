function Table = ReportGenerator_Table_Algorithm(SpecInfo, idx)

    Table = table('Size', [3, 2], 'VariableTypes', {'cell', 'cell'}, 'VariableNames', {'Algorithm', 'Parameters'});
        
    % Ocupation
    Ocupation = {sprintf('Método: %s', SpecInfo(idx).UserData.reportOCC.Method); ...
                 sprintf('Parâmetros: %s', jsonencode(rmfield(SpecInfo(idx).UserData.reportOCC, 'Method')))};

    % Detection
    Algorithms = unique(SpecInfo(idx).UserData.reportPeaksTable.Detection);
    if isempty(Algorithms)
        if SpecInfo(idx).UserData.reportDetection.ManualMode
            Algorithms = 'Detecção manual';

        else
            Algorithms = {sprintf('Algoritmo: %s', SpecInfo(idx).UserData.reportDetection.Algorithm);   ...
                          sprintf('Parâmetros: %s', SpecInfo(idx).UserData.reportDetection.Parameters); ...
                          sprintf('Faixa sob análise: %.3f - %.3f MHz', SpecInfo(idx).UserData.reportDetection.Band(1), SpecInfo(idx).UserData.reportDetection.Band(2))};
        end

    elseif numel(Algorithms) == 1
        if contains(Algorithms, '"Algorithm":"Detecção manual"')
            Algorithms = 'Detecção manual';
            
        else
            sAlgorithms = jsondecode(char(Algorithms));

            if contains(Algorithms, '"Algorithm":"FindPeaks"')                
                Algorithms = {sprintf('Algoritmo: %s',  sAlgorithms.Algorithm); ...
                              sprintf('Parâmetros: %s', jsonencode(sAlgorithms.Parameters))};

            else
                Algorithms = {sprintf('Algoritmo: %s',  sAlgorithms.Algorithm);              ...
                              sprintf('Parâmetros: %s', jsonencode(sAlgorithms.Parameters)); ...
                              sprintf('Faixa sob análise: %.3f - %.3f MHz', SpecInfo(idx).UserData.reportDetection.Band(1), SpecInfo(idx).UserData.reportDetection.Band(2))};
            end
        end

    else
        oldAlgorithms = sort(Algorithms);                
        Algorithms    = {};

        for ii = 1:numel(oldAlgorithms)
            if oldAlgorithms{ii} == "Detecção manual"
                Algorithms(end+1:end+3, 1) = {'Detecção manual';                                                                                                 ...
                                              sprintf('Emissões: %s', strjoin("P" + string(find(strcmp(SpecInfo(idx).UserData.reportPeaks.Detection, oldAlgorithms{ii}))), ', ')); ...
                                              '&nbsp;'};

            elseif contains(oldAlgorithms{ii}, 'Findpeaks')
                Algorithms(end+1:end+4, 1) = {sprintf('Algoritmo: %s',  char(extractBefore(oldAlgorithms{ii}, ' - ')));                                           ...
                                              sprintf('Parâmetros: %s', char(extractAfter(oldAlgorithms{ii},  ' - ')));                                           ...
                                              sprintf('Emissões: %s', strjoin("P" + string(find(strcmpi(SpecInfo(idx).UserData.Peaks.Detection, oldAlgorithms{ii}))), ', ')); ...
                                              '&nbsp;'};

            else
                Algorithms(end+1:end+5, 1) = {sprintf('Algoritmo: %s',  char(extractBefore(oldAlgorithms{ii}, ' - ')));                                                    ...
                                              sprintf('Parâmetros: %s', char(extractAfter(oldAlgorithms{ii},  ' - ')));                                                    ...
                                              sprintf('Faixa sob análise: %.3f - %.3f MHz', SpecInfo(idx).UserData.reportDetection.Band(1), SpecInfo(idx).UserData.reportDetection.Band(2)); ...
                                              sprintf('Emissões: %s', strjoin("P" + string(find(strcmpi(SpecInfo(idx).UserData.reportPeaks.Detection, oldAlgorithms{ii}))), ', '));          ...
                                              '&nbsp;'};
            end
        end
        Algorithms(end) = [];

    end
    
    % Classification
    Classification = {sprintf('Algoritmo: %s', SpecInfo(idx).UserData.reportClassification.Algorithm); ...
                      sprintf('Parâmetros: %s', SpecInfo(idx).UserData.reportClassification.Parameters)};

    Table(1,:) = {'Ocupação',                  Ocupation};
    Table(2,:) = {'Detecção de emissões',      Algorithms};
    Table(3,:) = {'Classificação de emissões', Classification};

end