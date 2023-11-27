function SM1809(filename, SpecInfo)

    % Escrita de arquivo no formato SM1809 - um formato texto estabelecido pela 
    % UIT como o "formato padrão de intercâmbio entre os administradores do espectro 
    % de radiofrequências", definido na Recomendação ITU-R SM.1809, publicada em 
    % 2007. O conteúdo do arquivo é extraído da variável "specData", uma estrutura 
    % definida para manuseio de dados de espectro no âmbito do appAnalise.
    % 
    % Em relação à recomendação da UIT:
    % - Foram inclusos todos campos obrigatórios no _header_, quais sejam: FileType, 
    %   LocationName, Latitude, Longitude, FreqStart, FreqStop, AntennaType, FilterBandwidth, 
    %   LevelUnits, Date, DataPoints, ScanTime e Detector.
    % - Foi inserido apenas um campo opcional, o MultiScan.
    % - Foram inseridos outros campos opcionais - ObservationTime, TraceMode, Samples, 
    %   Node, ThreadID (ou ID), ScriptName e Description - que não são previstos na Recomendação 
    %   e, portanto, somente serão decodificados no próprio appAnalise. O campo TraceMode, 
    %   ressalte-se, é importantíssimo pois o registro de uma monitoração com o traço 
    %   ClearWrite é muito diferente de uma monitoração com o traço MaxHold, por exemplo. 
    %
    % Além disso, os outros campos são importantes para manter a coerência de dados 
    % da variável "specData", em especial por conta de metadados existentes no CRFS 
    % BIN.
    %
    % Quando se tratar de um arquivo que registra uma monitoração multifaixa, alguns 
    % dos parâmetros do _header_ apresentam valores específicos para cada faixa. São 
    % eles:
    % - FreqStart
    % - FreqStop
    % - FilterBandwidth
    % - LevelUnits
    % - DataPoints
    % - ScanTime
    % - Detector
    % - TraceMode
    % - ThreadID | ID
    % - Description

    % Author.: Eric Magalhães Delgado
    % Date...: November 26, 2023
    % Version: 1.01
    
    if SpecInfo(1).GPS.Status
        [Latitude, Longitude] = gpsConversionFormats(SpecInfo(1).GPS);
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
    
    NN = numel(SpecInfo);
    if NN == 1; Multiscan = 'N';
    else;       Multiscan = 'Y';
    end
    
    nMinSweeps      = min(arrayfun(@(x) numel(x.Data{1}), SpecInfo));
    ObservationTime = sprintf('%s - %s', datestr(SpecInfo(1).Data{1}(1),          'dd/mm/yyyy HH:MM:SS'), ...
                                         datestr(SpecInfo(1).Data{1}(nMinSweeps), 'dd/mm/yyyy HH:MM:SS'));
    
    for ii = 1:NN
        FreqStart   = [FreqStart   sprintf('%.3f', SpecInfo(ii).MetaData.FreqStart  ./ 1e+3)];
        FreqStop    = [FreqStop    sprintf('%.3f', SpecInfo(ii).MetaData.FreqStop   ./ 1e+3)];
        Resolution  = [Resolution  sprintf('%.3f', SpecInfo(ii).MetaData.Resolution ./ 1e+3)];
        DataPoints  = [DataPoints  sprintf('%.0f', SpecInfo(ii).MetaData.DataPoints)];
        ThreadID    = [ThreadID    sprintf('%.0f', SpecInfo(ii).RelatedFiles.ID(1))];
        Description = [Description sprintf('%s',   SpecInfo(ii).RelatedFiles.Description{1})];
        SampleTime  = [SampleTime  sprintf('%.6f', mean(SpecInfo(ii).RelatedFiles.RevisitTime))];
        LevelUnit   = [LevelUnit   replace(SpecInfo(ii).MetaData.LevelUnit, 'µ', 'u')];
        Detector    = [Detector    SpecInfo(ii).MetaData.Detector];
        TraceMode   = [TraceMode   SpecInfo(ii).MetaData.TraceMode];        
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
                             Multiscan, SpecInfo(1).Receiver, ThreadID, FreqStart, FreqStop, LevelUnit, DataPoints,             ...
                             Resolution, SampleTime, TraceMode, Detector, jsonencode(SpecInfo(1).MetaData.Antenna), nMinSweeps, ...
                             SpecInfo(1).RelatedFiles.Task{1}, Description, Latitude, Longitude, SpecInfo(1).GPS.Location,      ...
                             datestr(SpecInfo(1).Data{1}(1), 'yyyy-mm-dd'), ObservationTime));
        
    if NN == 1
        nSweeps = numel(SpecInfo(1).Data{1});
        for jj = 1:nSweeps
            writecell([{datestr(SpecInfo(1).Data{1}(jj), 'HH:MM:SS')}, {SpecInfo(1).Data{2}(:,jj)'}], ...
                        filename, 'FileType', 'text', 'Delimiter', ',', 'WriteMode', 'append')
        end
        
    else
        for jj = 1:nMinSweeps
            strData = sprintf('%.1f,', SpecInfo(1).Data{2}(:,jj)');
            fprintf(fileID, sprintf('%s,%s', datestr(SpecInfo(1).Data{1}(jj), 'HH:MM:SS'), strData(1:end-1)));
            
            for kk = 2:numel(SpecInfo)
                strData = sprintf('%.1f,', SpecInfo(kk).Data{2}(:,jj)');
                fprintf(fileID,'; ,%s', strData(1:end-1));
            end
            fprintf(fileID, newline);
        end
    end

    fclose(fileID);
end


%-------------------------------------------------------------------------%
function [Latitude, Longitude] = gpsConversionFormats(gps)
    
    % LATITUDE
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