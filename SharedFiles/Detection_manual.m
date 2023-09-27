function Peaks = Detection_manual(Data)
%% DETECTION_MANUAL PeakManual
% Trata-se de função auxiliar à *Fcn_ReportGenerator*, possibilitando organização 
% das emissões detectados no modo Playback do appAnálise.
% 
% Versão: *05/04/2022*
    arguments
        Data struct
    end
    Peaks = table('Size', [height(Data.Emissions), 5],                               ...
                  'VariableTypes', {'uint16', 'double', 'single', 'double', 'cell'}, ...
                  'VariableNames', {'Index', 'Frequency', 'Truncated', 'BW', 'Detection'});
    for ii = 1:height(Data.Emissions)
        if Data.Emissions.Type(ii)
            Truncated = Misc_TruncatedFrequency(Data, Data.Emissions.Frequency(ii));
        else
            Truncated = Data.Emissions.Frequency(ii);
        end
        Peaks(ii,:) = {Data.Emissions.Index(ii),      ...
                       Data.Emissions.Frequency(ii), ...
                       Truncated,                     ...
                       Data.Emissions.BW(ii) / 1000,  ...
                       Data.Emissions.Detection{ii}};        
    end
    
end