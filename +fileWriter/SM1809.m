function SM1809(filename, specData)
%% FILEWRITER_SM1809 *Escrita do arquivo SM1809.*
% Escrita de arquivo no formato SM1809 - um formato texto estabelecido pela 
% UIT como _"formato padrão de intercâmbio entre os administradores do espectro 
% de radiofrequências"_, definido na Recomendação ITU-R SM.1809, publicada em 
% 2007. O conteúdo do arquivo é extraído da variável "specData", uma estrutura 
% definida para manuseio de dados de espectro no âmbito do *appAnálise*.
% 
% Em relação à recomendação da UIT:
%% 
% * Foram inclusos todos campos obrigatórios no _header_, quais sejam: FileType, 
% LocationName, Latitude, Longitude, FreqStart, FreqStop, AntennaType, FilterBandwidth, 
% LevelUnits, Date, DataPoints, ScanTime e Detector.
% * Foi inserido apenas um campo opcional, o MultiScan.
% * Foram inseridos outros campos opcionais - ObservationTime, TraceMode, Samples, 
% Node, ThreadID, ScriptName e Description - que não são previstos na Recomendação 
% e, portanto, somente serão decodificados no próprio appAnálise. O campo TraceMode, 
% ressalte-se, é importantíssimo pois o registro de uma monitoração com o traço 
% ClearWrite é muito diferente de uma monitoração com o traço MaxHold, por exemplo. 
% Além disso, os outros campos são importantes para manter a coerência de dados 
% da variável "specData", em especial por conta de metadados existentes no CRFS 
% BIN.
%% 
% Quando se tratar de um arquivo que registra uma monitoração multifaixa, alguns 
% dos parâmetros do _header_ apresentam valores específicos para cada faixa. São 
% eles:
%% 
% * FreqStart
% * FreqStop
% * FilterBandwidth
% * LevelUnits
% * DataPoints
% * ScanTime
% * Detector
% * TraceMode
% * ThreadID
% * Description
    arguments
        filename char
        specData struct
    end
    
    if specData(1).gps.Status
        [Latitude, Longitude] = gpsConversionFormats(specData(1).gps);
    else
        error('Necessária a informação de GPS.')
    end
    
    fileID = fopen(filename, 'wt');
    
    FreqStart   = {};
    FreqStop    = {};
    Resolution  = {};
    DataPoints  = {};
    ThreadID    = {};
    Description = {};
    SampleTime  = {};
    LevelUnit   = {};
    Detector    = {};
    TraceMode   = {};
    
    N = length(specData);
    if N == 1; Multiscan = 'N';
    else;      Multiscan = 'Y';
    end
    
    Samples         = min([specData.Samples]);
    ObservationTime = sprintf('%s - %s', datestr(specData(1).Data{1}(1),       'dd/mm/yyyy HH:MM:SS'), ...
                                         datestr(specData(1).Data{1}(Samples), 'dd/mm/yyyy HH:MM:SS'));
    
    for ii = 1:N
        FreqStart   = [FreqStart   sprintf('%.3f', specData(ii).MetaData.FreqStart  ./ 1e+3)];
        FreqStop    = [FreqStop    sprintf('%.3f', specData(ii).MetaData.FreqStop   ./ 1e+3)];
        Resolution  = [Resolution  sprintf('%.3f', specData(ii).MetaData.Resolution ./ 1e+3)];
        DataPoints  = [DataPoints  sprintf('%.0f', specData(ii).MetaData.DataPoints)];
        ThreadID    = [ThreadID    sprintf('%.0f', specData(ii).ThreadID)];
        Description = [Description sprintf('%s',   specData(ii).Description)];
        SampleTime  = [SampleTime  sprintf('%.6f', sum(specData(ii).RelatedFiles.Samples.*specData(ii).RelatedFiles.RevisitTime)/sum(specData(ii).RelatedFiles.Samples))];
        
        switch specData(ii).MetaData.LevelUnit
            case 1; auxUnit = 'dBm';
            case 2; auxUnit = 'dBuV';
            case 3; auxUnit = 'dBuV/m';
        end
        LevelUnit = [LevelUnit auxUnit];
        
        if ~isempty(specData(ii).MetaData.Detector)
            switch specData(ii).MetaData.Detector
                case 1; auxDetector = 'Sample';
                case 2; auxDetector = 'Average/RMS';
                case 3; auxDetector = 'Positive Peak';
                case 4; auxDetector = 'Negative Peak';
            end
            Detector = [Detector auxDetector];
        end
        
        if contains(specData(ii).Node, 'RFeye', 'IgnoreCase', true)
            switch specData(ii).MetaData.TraceMode
                case 0; auxTraceMode = 'Single Measurement';
                case 1; auxTraceMode = 'Mean';
                case 2; auxTraceMode = 'Peak';
                case 3; auxTraceMode = 'Minimum';
            end
        else
            switch specData(ii).MetaData.TraceMode
                case 1; auxTraceMode = 'ClearWrite';
                case 2; auxTraceMode = 'Average';
                case 3; auxTraceMode = 'MaxHold';
                case 4; auxTraceMode = 'MinHold';
            end
        end
        TraceMode = [TraceMode auxTraceMode];
    end
    FreqStart   = strjoin(FreqStart,   ';');
    FreqStop    = strjoin(FreqStop,    ';');
    Resolution  = strjoin(Resolution,  ';');
    DataPoints  = strjoin(DataPoints,  ';');
    ThreadID    = strjoin(ThreadID,    ';');
    Description = strjoin(Description, ';');
    SampleTime  = strjoin(SampleTime,  ';');
    LevelUnit   = strjoin(LevelUnit,   ';');
    Detector    = strjoin(Detector,    ';');
    TraceMode   = strjoin(TraceMode,   ';');
    
    fprintf(fileID, sprintf(['FileType SM1809\n'     ...
                             'Multiscan %s\n'        ...
                             'Node %s\n'             ...
                             'ThreadID %s\n'         ...
                             'FreqStart %s\n'        ...
                             'FreqStop %s\n'         ...
                             'LevelUnits %s\n'       ...
                             'DataPoints %s\n'       ...
                             'FilterBandwidth %s\n'  ...
                             'ScanTime %s\n'         ...
                             'TraceMode %s\n'        ...
                             'Detector %s\n'         ...
                             'AntennaType %s\n'      ...
                             'Samples %.0f\n'        ...
                             'TaskName %s\n'         ...
                             'Description %s\n'      ...
                             'Latitude %s\n'         ...
                             'Longitude %s\n'        ...
                             'LocationName %s\n'     ...
                             'Date %s\n'             ...
                             'ObservationTime %s\n\n'], ...
                             Multiscan, specData(1).Node, ThreadID, FreqStart, FreqStop, LevelUnit, DataPoints,        ...
                             Resolution, SampleTime, TraceMode, Detector, specData(1).MetaData.metaString{5}, Samples, ...
                             specData(1).TaskName, Description, Latitude, Longitude, specData(1).gps.Location,         ...
                             datestr(specData(1).Data{1}(1), 'yyyy-mm-dd'), ObservationTime));
        
    if N == 1
        for jj = 1:specData(1).Samples
            writecell([{datestr(specData(1).Data{1}(jj), 'HH:MM:SS')}, {specData(1).Data{2}(:,jj)'}], ...
                        filename, 'FileType', 'text', 'Delimiter', ',', 'WriteMode', 'append')
        end
        
    else
        for jj = 1:Samples
            strData = sprintf('%.1f,', specData(1).Data{2}(:,jj)');
            fprintf(fileID, sprintf('%s,%s', datestr(specData(1).Data{1}(jj), 'HH:MM:SS'), strData(1:end-1)));
            for kk = 2:length(specData)
                strData = sprintf('%.1f,', specData(kk).Data{2}(:,jj)');
                fprintf(fileID,'; ,%s', strData(1:end-1));
            end
            fprintf(fileID, newline);
        end
    end
    fclose(fileID);
end
%% 
% Conversão de grau decimal (que é o formato armazenado na variável specData) 
% para o formato padrão do SM1809.
function [Latitude, Longitude] = gpsConversionFormats(gps)
    arguments
        gps struct
    end
    
    if gps.Latitude < 0; auxStr = 'S';
    else               ; auxStr = 'N';
    end
    
    SEGUNDOS = abs(gps.Latitude - fix(gps.Latitude)) * 3600;
    MINUTOS  = fix(SEGUNDOS/60);
    SEGUNDOS = SEGUNDOS - MINUTOS * 60;
    
    HORAS = num2str(abs(fix(gps.Latitude)));
    if numel(HORAS) == 1; HORAS = ['0' HORAS];
    end
    MINUTOS = num2str(MINUTOS);
    if numel(MINUTOS) == 1; MINUTOS = ['0' MINUTOS];
    end
    
    SEGUNDOS = num2str(fix(SEGUNDOS));
    if numel(SEGUNDOS) == 1; SEGUNDOS = ['0' SEGUNDOS];
    end
    
    Latitude = sprintf('%s.%s.%s%s', HORAS, MINUTOS, SEGUNDOS, auxStr);
    
    
    % Longitude
    if gps.Longitude < 0; auxStr = 'W';
    else                ; auxStr = 'E';
    end
    
    SEGUNDOS = abs(gps.Longitude - fix(gps.Longitude)) * 3600;
    MINUTOS  = fix(SEGUNDOS/60);
    SEGUNDOS = SEGUNDOS - MINUTOS * 60;
    
    HORAS = num2str(abs(fix(gps.Longitude)));
    if numel(HORAS) < 3; HORAS = [repmat('0',1,(3-numel(HORAS))) HORAS];
    end
    MINUTOS = num2str(MINUTOS);
    if numel(MINUTOS) == 1; MINUTOS = ['0' MINUTOS];
    end
    
    SEGUNDOS = num2str(fix(SEGUNDOS));
    if numel(SEGUNDOS) == 1; SEGUNDOS = ['0' SEGUNDOS];
    end
    
    Longitude = sprintf('%s.%s.%s%s', HORAS, MINUTOS, SEGUNDOS, auxStr);
end