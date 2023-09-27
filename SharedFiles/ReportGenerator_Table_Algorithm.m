function Table = ReportGenerator_Table_Algorithm(specData, idx)

    Table = table('Size', [3, 2], 'VariableTypes', {'cell', 'cell'}, 'VariableNames', {'Algorithm', 'Parameters'});
        
    % Ocupation
    Ocupation = {sprintf('Método: %s', specData(idx).reportOCC.Method); ...
                 sprintf('Parâmetros: %s', specData(idx).reportOCC.Parameters)};

    % Detection
    Algorithms = unique(specData(idx).Peaks.Detection);
    if isempty(Algorithms)
        if specData(idx).reportDetection.ManualMode
            Algorithms = 'Detecção manual';

        else
            Algorithms = {sprintf('Algoritmo: %s', specData(idx).reportDetection.Algorithm);   ...
                          sprintf('Parâmetros: %s', specData(idx).reportDetection.Parameters); ...
                          sprintf('Faixa sob análise: %.3f - %.3f MHz', specData(idx).reportDetection.Band(1), specData(idx).reportDetection.Band(2))};
        end

    elseif numel(Algorithms) == 1
        if Algorithms{1} == "Detecção manual"
            Algorithms = char(Algorithms);

        elseif contains(Algorithms, 'Findpeaks')
            Algorithms = {sprintf('Algoritmo: %s',  char(extractBefore(Algorithms, ' - '))); ...
                          sprintf('Parâmetros: %s', char(extractAfter(Algorithms,  ' - ')))};

        else
            Algorithms = {sprintf('Algoritmo: %s',  char(extractBefore(Algorithms, ' - '))); ...
                          sprintf('Parâmetros: %s', char(extractAfter(Algorithms,  ' - '))); ...
                          sprintf('Faixa sob análise: %.3f - %.3f MHz', specData(idx).reportDetection.Band(1), specData(idx).reportDetection.Band(2))};
        end

    else
        oldAlgorithms = sort(replace(Algorithms, 'appAnálise', 'AppAnálise'));                
        Algorithms    = {};

        for ii = 1:numel(oldAlgorithms)
            if oldAlgorithms{ii} == "Detecção manual"
                Algorithms(end+1:end+3, 1) = {'Detecção manual';                                                                                                 ...
                                              sprintf('Emissões: %s', strjoin("P" + string(find(strcmp(specData(idx).Peaks.Detection, oldAlgorithms{ii}))), ', ')); ...
                                              '&nbsp;'};

            elseif contains(oldAlgorithms{ii}, 'Findpeaks')
                Algorithms(end+1:end+4, 1) = {sprintf('Algoritmo: %s',  char(extractBefore(oldAlgorithms{ii}, ' - ')));                                           ...
                                              sprintf('Parâmetros: %s', char(extractAfter(oldAlgorithms{ii},  ' - ')));                                           ...
                                              sprintf('Emissões: %s', strjoin("P" + string(find(strcmpi(specData(idx).Peaks.Detection, oldAlgorithms{ii}))), ', ')); ...
                                              '&nbsp;'};

            else
                Algorithms(end+1:end+5, 1) = {sprintf('Algoritmo: %s',  char(extractBefore(oldAlgorithms{ii}, ' - ')));                                                    ...
                                              sprintf('Parâmetros: %s', char(extractAfter(oldAlgorithms{ii},  ' - ')));                                                    ...
                                              sprintf('Faixa sob análise: %.3f - %.3f MHz', specData(idx).reportDetection.Band(1), specData(idx).reportDetection.Band(2)); ...
                                              sprintf('Emissões: %s', strjoin("P" + string(find(strcmpi(specData(idx).Peaks.Detection, oldAlgorithms{ii}))), ', '));          ...
                                              '&nbsp;'};
            end
        end

        Algorithms(end) = [];
        Algorithms      = replace(Algorithms, 'AppAnálise', 'appAnálise');

    end
    
    % Classification
    Classification = {sprintf('Algoritmo: %s', specData(idx).reportClassification.Algorithm); ...
                      sprintf('Parâmetros: %s', specData(idx).reportClassification.Parameters)};

    Table(1,:) = {'Ocupação',                  Ocupation};
    Table(2,:) = {'Detecção de emissões',      Algorithms};
    Table(3,:) = {'Classificação de emissões', Classification};

end