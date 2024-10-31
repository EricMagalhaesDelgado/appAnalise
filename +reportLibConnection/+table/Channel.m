function GeneralTable = Channel(specData, idxThread)

    arguments
        specData 
        idxThread = 1
    end

    % O relatório para o PM-SAT será composto de duas tabelas. 
    % • TABELA GERAL que será apresentada abaixo do plot de toda a faixa, 
    %   contendo informações gerais de cada um dos transponders.
    % • TABELA DE EMISSÕES que será apresentada abaixo do plot de transponder
    %   ocupado, contendo informações das emissões relacionadas.
    
    % Métricas de ocupação:
    % • FCO ("Frequency Channel Occupancy"): no tempo, com integração infinita
    %   (24 horas, no caso das monitorações ordinárias do PM-SAT);
    % • FBO ("Frequency Band Occupancy"): no espaço, aferido para cada varredura.
    
    % Descrição dos passos para aferição de FCO e FBO:
    % • Faixa de guarda de 10% (5% para cima e 5% para baixo) para definição 
    %   de rol de dados que subsidiarão cálculo do THRESHOLD.
    % • Ordena os dados para cada varredura e calcula a média das 20% amostras 
    %   com menores níveis.
    % • A esse valor, soma-se 5dB de offset. Assim, define-se o THRESHOLD
    %   para cada varredura.
    % • Calcula a ocupação por bin para cada varredura (occMatrix). Limitado 
    %   apenas aos limites do canal (não usa a Faixa de Guarda).
    % • Calcula a ocupação espacial do canal por varredura (chFBO). Limitado 
    %   apenas aos limites do canal (não usa a Faixa de Guarda).
    % • Calcula a ocupação do canal no período de observação (chFCO). Um único 
    %   valor. Limitado apenas aos limites do canal (não usa a Faixa de Guarda).

    specData = specData(idxThread);

    chTable  = specData.UserData.reportChannelTable;
    chTable.ChannelGuardBW = ceil(chTable.ChannelBW/20);
    
    % Insere na planilha informação de ocupação total informada pela operadora...
    try
        TPDRInfo = cellfun(@(x) jsondecode(x), chTable.Reference, "UniformOutput", false);
        chTable.TPDR_OCUPACAO_TOTAL = cellfun(@(x) x.TPDR_OCUPACAO_TOTAL, TPDRInfo, "UniformOutput", true);
    catch
        chTable.TPDR_OCUPACAO_TOTAL = -ones(height(chTable), 1);
    end

    GeneralTable   = TableTemplate('GeneralTable', height(chTable));
    
    for ii = 1:height(chTable)
        % Limites do canal sob análise.
        chStart    = chTable.FreqStart(ii);
        chStop     = chTable.FreqStop(ii);
        
        % Limites do canal sob análise (incluindo banda de guarda).
        chStart_GB = chStart - chTable.ChannelGuardBW(ii);
        chStop_GB  = chStop  + chTable.ChannelGuardBW(ii);
    
        % Matriz de níveis do canal (incluindo banda de guarda p/ fins 
        % de cômputo do piso de ruído usando o método das 20% menores 
        % amostras). Ao final, o THR é aproximado para o interior superior
        % mais próximo (evitando casas decimais no THR).
        idx1_GB    = freq2idx(specData.MetaData.FreqStart, specData.MetaData.FreqStop, height(specData.Data{2}), chStart_GB * 1e+6);
        idx2_GB    = freq2idx(specData.MetaData.FreqStart, specData.MetaData.FreqStop, height(specData.Data{2}), chStop_GB  * 1e+6);
        nPoints_GB = idx2_GB-idx1_GB+1;
        chMatrix_GB= specData.Data{2}(idx1_GB:idx2_GB, :);
    
        sortedData = sort(chMatrix_GB);
        meanNoise  = mean(sortedData(1:ceil(.2*nPoints_GB), :));
        occTHR     = ceil(meanNoise) + 5;
    
        % Cálculo da ocupação por bin para cada varredura.
        idx1       = freq2idx(specData.MetaData.FreqStart, specData.MetaData.FreqStop, height(specData.Data{2}), chStart  * 1e+6);
        idx2       = freq2idx(specData.MetaData.FreqStart, specData.MetaData.FreqStop, height(specData.Data{2}), chStop   * 1e+6);
        nPoints    = idx2-idx1+1;
        chMatrix   = specData.Data{2}(idx1:idx2, :);
    
        occMatrix  = chMatrix > occTHR;
        chTable.occMatrix(ii) = {occMatrix};
    
        % Afere a ocupação por dois métodos: FBO e FCO
        % FBO: "Frequency Band Occupancy" (%)
        % FCO: "Frequency Channel Occupancy" (%)
        chFBO      = 100 * sum(occMatrix)/nPoints;
        chFCO      = 100 * sum(any(occMatrix)) / width(occMatrix);    
    
        % Identificação de emissões relacionadas a cada transponder.
        Emissions      = specData.UserData.Emissions;
        idxEmissions   = find((Emissions.Frequency >= chStart) & (Emissions.Frequency < chStop));
        EmissionsCount = numel(idxEmissions);
        EmissionTable  = TableTemplate('EmissionTable', numel(idxEmissions));

        for jj = 1:EmissionsCount
            idxEmission = idxEmissions(jj);
    
            EmissionFrequency    = specData.UserData.Emissions.Frequency(idxEmission);
            idxEmissionFrequency = freq2idx(chStart*1e+6, chStop*1e+6, height(chMatrix), EmissionFrequency*1e+6);
    
            EmissionDescription  = specData.UserData.Emissions.UserData(idxEmission).Description;
            if isnumeric(EmissionDescription) || isempty(EmissionDescription)
                EmissionDescription = '-';
            end

            EmissionTable(jj, :) = {jj,                                                               ...
                                    EmissionFrequency,                                                ...
                                    specData.UserData.Emissions.BW(idxEmission),                      ...
                                    100 * sum(occMatrix(idxEmissionFrequency, :)) / width(occMatrix), ...
                                    EmissionDescription};
        end

        chName = extractBefore(chTable.Name{ii}, ' @');
        if isempty(chName)
            chName = chTable.Name{ii};
        end
    
        GeneralTable(ii, :) = {chName,                          ...
                               chTable.FirstChannel(ii),        ...
                               chTable.ChannelBW(ii) * 1000,    ...
                               chTable.Reference{ii},           ...
                               chTable.TPDR_OCUPACAO_TOTAL(ii), ...
                               min(chFBO),                      ...
                               mean(chFBO),                     ...
                               max(chFBO),                      ...
                               chFCO,                           ...
                               EmissionsCount,                  ...
                               {idxEmissions},                  ...
                               {EmissionTable}};
    end

    specData.UserData.reportChannelAnalysis = GeneralTable;
end


%-------------------------------------------------------------------------%
function Template = TableTemplate(Type, Height)
    switch Type
        case 'GeneralTable'
            Template = table('Size',          [Height, 12],                                                                                                 ...
                             'VariableNames', {'Transponder', 'Frequência central (MHz)', 'Largura (kHz)', 'Referência', 'FBO estimada (%)',                ...
                                               'FBO mínima (%)', 'FBO média (%)', 'FBO máxima (%)', 'FCO (%)', 'Qtd. emissões', 'idxEmission', 'Emissões'}, ...
                             'VariableTypes', {'cell', 'double', 'double', 'cell', 'double', 'double', 'double', 'double', 'double', 'uint32', 'cell', 'cell'});
        case 'EmissionTable'
            Template = table('Size',          [Height, 5],                                                                 ...
                             'VariableNames', {'ID', 'Frequência central (MHz)', 'Largura (kHz)', 'FCO (%)', 'Descrição'}, ...
                             'VariableTypes', {'uint16', 'double', 'double', 'double', 'cell'});
    end
end


%-------------------------------------------------------------------------%
function FrequencyIndex = freq2idx(FreqStart, FreqStop, DataPoints, FrequencyInHertz)
    aCoef = (FreqStop - FreqStart) ./ (DataPoints - 1);
    bCoef = FreqStart - aCoef;

    FrequencyIndex = round((FrequencyInHertz - bCoef)/aCoef);
    FrequencyIndex(FrequencyIndex < 1) = 1;
    FrequencyIndex(FrequencyIndex > DataPoints) = DataPoints;
end