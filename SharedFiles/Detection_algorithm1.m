function [newIndex, newFreq, newBW, auxPeaks] = Detection_algorithm1(app, idx1, Attributes)

    % DETECTION ALGORITHM1: FindPeaks+OCC (appAnálise v. 1.00)
    %
    % Possibilita identificação de emissões pelos seguintes critérios:
    % - Critério 1: na curva de tendência central (média ou mediana), identificam-se os 
    %               picos espaçados entre si ao menos de _minDistance_ (em kHz), cuja 
    %               largura e proeminência de cada um deles seja ao menos igual a _minWidth_ 
    %               (em kHz) e _minLevel_ (em dB), respectivamente.
    %
    % - Critério 2: na curva de máximo, identificam-se os picos espaçados entre si ao 
    %               menos de _minDistance_ (em kHz), cuja largura e proeminência de cada um 
    %               deles seja ao menos igual a _minWidth_ (em kHz) e _minLevel_ (em dB), 
    %               respectivamente, e cuja ocupação seja superior a _minOCC_ (em %).
    %
    % Versão: 19/10/2023

    % Critério 1: Média
    % (Critério primário)
    THR1 = -inf;
    if app.specData(idx1).MetaData.Threshold == -1
        THR1 = app.specData(idx1).MetaData.Threshold + Attributes.Prominence1;
    end
    
    Attributes_C1 = struct('Fcn',        'Média',                ...
                           'NPeaks',     100,                    ...
                           'THR',        THR1,                   ...
                           'Prominence', Attributes.Prominence1, ...
                           'Distance',   Attributes.Distance,    ...
                           'BW',         Attributes.BW);
        
    [meanIndex, meanFrequency, meanBW] = Detection_findpeaks(app, idx1, Attributes_C1);

    % Critério 2: MaxHold
    % (Critério secundário)
    THR2 = -inf;
    if app.specData(idx1).MetaData.Threshold == -1
        THR2 = app.specData(idx1).MetaData.Threshold + Attributes.Prominence2;
    end
    Attributes_C2 = struct('Fcn',        'MaxHold',              ...
                           'NPeaks',     100,                    ...
                           'THR',        THR2,                   ...
                           'Prominence', Attributes.Prominence2, ...
                           'Distance',   Attributes.Distance,    ...
                           'BW',         Attributes.BW,          ...
                           'meanOCC',    Attributes.meanOCC,     ...
                           'maxOCC',     Attributes.maxOCC);

    [maxIndex, maxFrequency, maxBW] = Detection_findpeaks(app, idx1, Attributes_C2);
    
    if ~isempty(maxIndex) && ~isempty(Data.reportOCC.Index)
        occIndex_Mean = find(specData(Data.reportOCC.Index).statsData(:,2) >= Attributes.meanOCC);
        occIndex_Max  = find(specData(Data.reportOCC.Index).statsData(:,3) >= Attributes.maxOCC);
        
        [maxIndex, idx2] = intersect(maxIndex, intersect(occIndex_Mean, occIndex_Max), 'stable');
        
        maxFrequency = maxFrequency(idx2);
        maxBW        = maxBW(idx2);
    end

    % Validação
    % Elimina emissões identificadas no Critério 2 cujas frequências centrais estão 
    % contidas em alguma das emissões identificadas no Critério 1.
    for ii = numel(maxFrequency):-1:1
        for jj = 1:numel(meanFrequency)
            if (maxIndex(ii) == meanIndex(jj)) || ((maxFrequency(ii) >= meanFrequency(jj)-meanBW(jj)/2) && (maxFrequency(ii) <= meanFrequency(jj)+meanBW(jj)/2))
                maxIndex(ii)     = [];
                maxFrequency(ii) = [];
                maxBW(ii)        = [];

                break
            end
        end
    end

    % Variável de saída
    newIndex = [meanIndex;     maxIndex];
    newFreq  = [meanFrequency; maxFrequency];
    newBW    = [meanBW;        maxBW];
end