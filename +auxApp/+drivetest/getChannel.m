function chAssigned = getChannel(specData, idxThread, idxEmission, channelObj)

    % Trata-se de função auxiliar ao módulo de DRIVE-TEST, que busca identificar 
    % o canal relacionado à emissão.

    % A análise aqui é simplista, até porque a informação pode ser editada 
    % diretamente na GUI. 
    
    % Inicialmente, trunca-se a frequência central da emissão, caso aplicável. 
    % E, em posse dessa informação, busca-se no RFDataHub todos os registros 
    % com essa frequência, retornando a largura mais comum.

    chFrequency = getChannelFrequency(specData, idxThread, idxEmission, channelObj);
    chBW        = getChannelBW(specData, idxThread, idxEmission, chFrequency);

    chAssigned  = struct('Frequency', double(chFrequency), ...
                         'ChannelBW', double(chBW));
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
        chBW = specData(idxThread).UserData.Emissions.BW(idxEmission);
    end
end