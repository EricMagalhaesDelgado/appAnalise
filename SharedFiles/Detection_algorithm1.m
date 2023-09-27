function auxPeaks = Detection_algorithm1(Data)
%% DETECTION_ALGORITHM1 PeakDetection_1
% Trata-se de função auxiliar à *Fcn_ReportGenerator*, possibilitando identificação 
% de emissões por dois critérios, os quais são descritos a seguir.
%% 
% * *Critério 1*: na curva de mediana, identificam-se os picos espaçados entre 
% si ao menos de _minDistance_ (em kHz), cuja largura e proeminência de cada um 
% deles seja ao menos igual a _minWidth_ (em kHz) e _minLevel_ (em dB), respectivamente.
% * *Critério 2*: na curva de máximo, identificam-se os picos espaçados entre 
% si ao menos de _minDistance_ (em kHz), cuja largura e proeminência de cada um 
% deles seja ao menos igual a _minWidth_ (em kHz) e _minLevel_ (em dB), respectivamente, 
% e cuja ocupação seja superior a _minOCC_ (em %).
%% 
% Versão: *04/04/2022*
    arguments
        Data  struct
    end
    global specData
    DetectionInfo = jsondecode(Data.reportDetection.Parameters);
% Critério 1: Média/Mediana
% (Critério primário)
    THR_C1 = -inf;
    if ~isempty(Data.MetaData.Threshold)
        THR_C1 = Data.MetaData.Threshold + DetectionInfo.C1_Proeminence;
    end
    
    Attributes = struct('Fcn',         DetectionInfo.C1_Fcn,         ...
                        'NPeaks',      100,                          ...
                        'THR',         THR_C1,                       ...
                        'Proeminence', DetectionInfo.C1_Proeminence, ...
                        'Distance',    DetectionInfo.Cn_minDist,     ...
                        'BW',          DetectionInfo.Cn_BW);
        
    [peakIndex, peakFrequency, peakBW] = Detection_findpeaks(Data, Attributes);
    peakMethod = sprintf('%s - %s', 'appAnálise v. 1.00', jsonencode(Attributes));
% Critério 2: MaxHold
% (Critério secundário)
    THR_C2 = -inf;
    if ~isempty(Data.MetaData.Threshold)
        THR_C2 = Data.MetaData.Threshold + DetectionInfo.C2_Proeminence;
    end
    Attributes = struct('Fcn',         'MaxHold',                    ...
                        'NPeaks',      100,                          ...
                        'THR',         THR_C2,                       ...
                        'Proeminence', DetectionInfo.C2_Proeminence, ...
                        'Distance',    DetectionInfo.Cn_minDist,     ...
                        'BW',          DetectionInfo.Cn_BW,          ...
                        'meanOCC',     DetectionInfo.C2_meanOCC,     ...
                        'maxOCC',      DetectionInfo.C2_maxOCC);
    [maxIndex, maxFrequency, maxBW] = Detection_findpeaks(Data, Attributes);
    maxMethod = sprintf('%s - %s', 'appAnálise v. 1.00', jsonencode(Attributes));
    
    if ~isempty(maxIndex) && ~isempty(Data.reportOCC.Index)
        occIndex_Mean = find(specData(Data.reportOCC.Index).statsData(:,2) >= Attributes.meanOCC);
        occIndex_Max  = find(specData(Data.reportOCC.Index).statsData(:,3) >= Attributes.maxOCC);
        
        [maxIndex, idx1] = intersect(maxIndex, intersect(occIndex_Mean, occIndex_Max), 'stable');
        
        maxFrequency = maxFrequency(idx1);
        maxBW        = maxBW(idx1);
    end
% Validação
% Elimina emissões identificadas no Critério 2 cujas frequências centrais estão 
% contidas em alguma das emissões identificadas no Critério 1.
    for ii = numel(maxFrequency):-1:1
        for jj = 1:numel(peakFrequency)
            if (maxIndex(ii) == peakIndex(jj)) || ((maxFrequency(ii) >= peakFrequency(jj)-peakBW(jj)/2) && (maxFrequency(ii) <= peakFrequency(jj)+peakBW(jj)/2))
                maxIndex(ii)     = [];
                maxFrequency(ii) = [];
                maxBW(ii)        = [];
                break
            end
        end
    end
    peakTruncated = Misc_TruncatedFrequency(Data, peakFrequency);
    maxTruncated  = Misc_TruncatedFrequency(Data, maxFrequency);
% Variável de saída
    NN = numel(peakIndex) + numel(maxIndex);
    if NN
        auxPeaks = table(uint16([peakIndex; maxIndex]), [peakFrequency; maxFrequency],                         ...
                         single([peakTruncated; maxTruncated]), [peakBW; maxBW],                               ...
                         [repmat({peakMethod}, numel(peakIndex), 1); repmat({maxMethod}, numel(maxIndex), 1)], ...
                         'VariableNames', {'Index', 'Frequency', 'Truncated', 'BW', 'Detection'});
    else
        auxPeaks = [];
    end
end