function Peaks = Detection_validation(Data, Peaks, auxPeaks)
%% DETECTION_VALIDATION PeakValidation
% Elimina emissões já apontadas no modo Playback do appAnálise ou que extrapolam 
% a faixa sob análise.
% 
% Versão: *05/04/2022*
    arguments
        Data     struct
        Peaks    table
        auxPeaks table
    end
    Limits = Data.reportDetection.Band;
    if isequal(Limits, [Data.MetaData.FreqStart, Data.MetaData.FreqStop] / 1e+6)
        global peaksReference
        idx = Misc_Band(Data);
        if ~isempty(idx)
            Limits = [peaksReference(idx).Band(1), peaksReference(idx).Band(2)] / 1e+6;
        end
    end
    NN = height(auxPeaks);
    for ii = NN:-1:1
        if (auxPeaks.Frequency(ii) < Limits(1)) || (auxPeaks.Frequency(ii) > Limits(2))
            auxPeaks(ii,:) = [];
        else
            for jj = 1:height(Peaks)
                if (auxPeaks.Index(ii) == Peaks.Index(jj)) || ((auxPeaks.Frequency(ii) >= Peaks.Frequency(jj)-Peaks.BW(jj)/2) && (auxPeaks.Frequency(ii) <= Peaks.Frequency(jj)+Peaks.BW(jj)/2))
                    auxPeaks(ii,:) = [];
                    break
                end
            end
        end
    end
    Peaks = [Peaks; auxPeaks];
        
end