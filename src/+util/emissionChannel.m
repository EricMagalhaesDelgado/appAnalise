function chAssigned = emissionChannel(specData, idxThread, idxEmission, channelObj)

    % Trata-se de função auxiliar ao módulo de DRIVE-TEST, que busca identificar 
    % o canal relacionado à emissão.

    % A análise aqui é simplista, até porque a informação pode ser editada 
    % diretamente na GUI. 
    
    % Inicialmente, trunca-se a frequência central da emissão, caso aplicável. 
    % E, em posse dessa informação, busca-se no RFDataHub todos os registros 
    % com essa frequência, retornando a largura mais comum.

    if isempty(idxEmission)
        chFrequency = (specData(idxThread).MetaData.FreqStart + specData(idxThread).MetaData.FreqStop) / 2e6; % MHz
        chBW        = (specData(idxThread).MetaData.FreqStop - specData(idxThread).MetaData.FreqStart) / 1e3; % kHz
    else
        chFrequency = getChannelFrequency(specData, idxThread, idxEmission, channelObj);
        chBW        = getChannelBW(specData, idxThread, idxEmission, chFrequency);
    end

    chAssigned  = struct('Frequency', round(double(chFrequency), 6), ...
                         'ChannelBW', round(double(chBW), 6));
end

%-------------------------------------------------------------------------%
function chFrequency = getChannelFrequency(specData, idxThread, idxEmission, channelObj)
    if specData(idxThread).UserData.Emissions.isTruncated(idxEmission)
        chFrequency = TruncatedFrequency(channelObj, specData(idxThread), idxEmission);
    else
        chFrequency = specData(idxThread).UserData.Emissions.Frequency(idxEmission);
    end
end

%-------------------------------------------------------------------------%
function chBW = getChannelBW(specData, idxThread, idxEmission, chFrequency)
    global RFDataHub

    idx  = abs(RFDataHub.Frequency - chFrequency) <= class.Constants.floatDiffTolerance;
    chBW = mode(RFDataHub.BW(idx));
    
    if isempty(chBW) || ~isnumeric(chBW) || isnan(chBW) || (chBW <= 0)
        chBW = specData(idxThread).UserData.Emissions.BW_kHz(idxEmission);
    end
end