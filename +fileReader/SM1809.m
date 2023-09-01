function specData = SM1809(filename, ReadType, metaData)
%% SM1809 Leitor de arquivo no formato SM1809.
% Trata-se de leitor de arquivo no formato SM1809.
% 
% Versão: *03/03/2021*
    arguments
        filename char
        ReadType char   = 'SingleFile'
        metaData struct = []
    end
    
    global SpecInfo
    
    fileID = fopen(filename);
    if fileID == -1
        error('Arquivo não encontrado!');
    end
    
    extractedLine = fgetl(fileID);
    if (extractedLine == -1) | (~strcmp(extractBefore(extractedLine, ' '), 'FileType'))
        fclose(fileID);
        error('Parece não se tratar de um arquivo no formato SM1809.');
    end
    
    switch ReadType
        case {'MetaData', 'SingleFile'}
            SpecInfo = struct('Node',         '', 'ThreadID',   '', 'MetaData',   [], 'ObservationTime', '', 'Samples',   [],    ...
                              'Data',         {}, 'statsData',  [], 'FileFormat', '', 'TaskName',        '', 'Description', '',  ...
                              'RelatedFiles', {}, 'RelatedGPS', {}, 'gps',        [], 'Blocks',          []);
            
            Fcn_MetaDataReader(fileID, filename);
            
            if strcmp(ReadType, 'SingleFile')
                Fcn_SpecDataReader(fileID)
            end
            
        case 'SpecData'
            SpecInfo = metaData(1).Data;
            Fcn_SpecDataReader(fileID);
    end
    fclose(fileID);
    
    specData = SpecInfo;
    clear global SpecInfo
end
%% 
% Leitura de *metadados*.
function Fcn_MetaDataReader(fileID, filename)
    global SpecInfo
    SpecInfo(1).MetaData = struct('DataType', 1809, 'ThreadID',   [], 'FreqStart',  [], 'FreqStop',   [], ...
                                  'LevelUnit',  [], 'DataPoints', [], 'Resolution', [], 'SampleTime', [], ...
                                  'Threshold',  [], 'TraceMode',  [], 'Detector',   [], 'Antenna',    []);
    
    SpecInfo.FileFormat = 'SM1809 v.2';
    SpecInfo.gps        = struct('Status', 0, 'Latitude', -1, 'Longitude', -1, 'Count', 0, 'Location', '');
    
    gpsFlag = 0;
    
    while true
        extractedLine = fgetl(fileID);
        
        if isempty(extractedLine)
            break
        end
        
        Field = extractBefore(extractedLine, ' ');
        Value = extractAfter(extractedLine,  ' ');
        
        switch Field
            case 'LocationName';    Location                  = Value;
            case 'Latitude';        latDegree                 = gpsConversionFormats(Value, ''); gpsFlag = gpsFlag+1;
            case 'Longitude';       [~, longDegree]           = gpsConversionFormats('', Value); gpsFlag = gpsFlag+1;
            case 'FreqStart';       FreqStart                 = strsplit(Value, ';');
            case 'FreqStop';        FreqStop                  = strsplit(Value, ';');
            case 'AntennaType';     antennaName               = Value;
            case 'FilterBandwidth'; FilterBandwidth           = strsplit(Value, ';');
            case 'LevelUnits';      LevelUnits                = strsplit(Value, ';');
            case 'Date';            SpecInfo.Blocks(1)        = {Value};
            case 'DataPoints';      DataPoints                = strsplit(Value, ';');
            case 'ScanTime';        RevisitTime               = strsplit(Value, ';');
            case 'Detector';        Detector                  = strsplit(Value, ';');
            case 'TraceMode';       TraceMode                 = strsplit(Value, ';');
            case 'Samples';         SpecInfo.Samples          = str2double(Value);
            case 'Node';            SpecInfo.Node             = Value;
            case 'ThreadID';        ThreadID                  = strsplit(Value, ';');
            case 'TaskName';        SpecInfo.TaskName         = Value;    
            case 'Description';     Description               = strsplit(Value, ';');
            case 'ObservationTime'; SpecInfo.ObservationTime  = Value;
        end
    end
    
    if gpsFlag == 2
        SpecInfo.gps = struct('Status', 1, 'Latitude', latDegree, 'Longitude', longDegree, 'Count', 1, 'Location', Location, 'Matrix', [latDegree, longDegree]);
    end
    [~, file, ext] = fileparts(filename);
    
    SpecInfo.Blocks(2) = {ftell(fileID)};
    
    SpecInfo = repmat(SpecInfo, numel(FreqStart), 1);
    
    for ii=1:numel(FreqStart)
        SpecInfo(ii).MetaData.FreqStart  = str2double(FreqStart{ii}) * 1e+3;
        SpecInfo(ii).MetaData.FreqStop   = str2double(FreqStop{ii})  * 1e+3;
        SpecInfo(ii).MetaData.DataPoints = str2double(DataPoints{ii});
        SpecInfo(ii).MetaData.SampleTime = [];
        SpecInfo(ii).MetaData.TraceMode  = TraceMode{ii};
        SpecInfo(ii).ThreadID            = str2double(ThreadID{ii});
        SpecInfo(ii).MetaData.ThreadID   = SpecInfo(ii).ThreadID;
        SpecInfo(ii).Description         = Description{ii};
        SpecInfo(ii).MetaData.metaString = repmat({''}, 1, 5);        
        
        switch LevelUnits{ii}
            case 'dBm'
                SpecInfo(ii).MetaData.LevelUnit     = 1;
                SpecInfo(ii).MetaData.metaString{1} = 'dBm';
            case 'dBuV'
                SpecInfo(ii).MetaData.LevelUnit     = 2;
                SpecInfo(ii).MetaData.metaString{1} = 'dBµV';
            case 'dBuV/m'
                SpecInfo(ii).MetaData.LevelUnit     = 3;
                SpecInfo(ii).MetaData.metaString{1} = 'dBµV/m';
        end
        
        if ~isempty(FilterBandwidth{ii})
            SpecInfo(ii).MetaData.Resolution    = str2double(FilterBandwidth{ii}) * 1e+3;
            SpecInfo(ii).MetaData.metaString{2} = sprintf('%.3f kHz', SpecInfo(ii).MetaData.Resolution/1e+3);
        end
        
        if ~isempty(TraceMode{ii})
            value = [];
            if contains(SpecInfo(ii).Node, 'RFeye', 'IgnoreCase', true)
                switch SpecInfo(ii).MetaData.TraceMode
                    case 'Single Measurement'; value = 0;
                    case 'Mean';               value = 1;
                    case 'Peak';               value = 2;
                    case 'Minimum';            value = 3;
                end
            else
                switch TraceMode{ii}
                    case 'ClearWrite'; value = 1;
                    case 'Average';    value = 2;
                    case 'MaxHold';    value = 3;
                    case 'MinHold';    value = 4;
                end
            end
            SpecInfo(ii).MetaData.TraceMode     = value;
            SpecInfo(ii).MetaData.metaString{3} = TraceMode{ii};
        end
        
        try
            switch Detector{ii}
                case 'Sample';        value = 1;
                case 'Average/RMS';   value = 2;
                case 'Positive Peak'; value = 3;
                case 'Negative Peak'; value = 4;
            end
            SpecInfo(ii).MetaData.Detector      = value;
            SpecInfo(ii).MetaData.metaString{4} = Detector{ii};
        catch
            SpecInfo(ii).MetaData.Detector      = [];
            SpecInfo(ii).MetaData.metaString{4} = '';
        end
        
        SpecInfo(ii).MetaData.metaString{5} = antennaName;
        
        SpecInfo(ii).RelatedGPS   = {SpecInfo(ii).gps};
        SpecInfo(ii).gps          = rmfield(SpecInfo(ii).gps, {'Count', 'Matrix'});
        StartTime = datetime(extractBefore(SpecInfo(1).ObservationTime, ' - '), 'InputFormat', 'dd/MM/yyyy HH:mm:ss', 'Format', 'dd/MM/yyyy HH:mm:ss');
        StopTime  = datetime(extractAfter( SpecInfo(1).ObservationTime, ' - '), 'InputFormat', 'dd/MM/yyyy HH:mm:ss', 'Format', 'dd/MM/yyyy HH:mm:ss');
        SpecInfo(ii).RelatedFiles = table({[file ext]}, StartTime, StopTime, SpecInfo(1).Samples, str2double(RevisitTime{ii}), ...
                                          'VariableNames', {'Name', 'BeginTime', 'EndTime', 'Samples', 'RevisitTime'});
    end     
end
%% 
% *Leitura dos dados de espectro.*
function Fcn_SpecDataReader(fileID)
    global SpecInfo
    
    % Pré-alocação.
    startDate = SpecInfo(1).Blocks{1};
    TimeStamp = datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss');
    
    for ii = 1:length(SpecInfo)
        SpecInfo(ii).Data  = {repmat(datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss'), 1, SpecInfo(ii).Samples), ...
                              zeros(SpecInfo(ii).MetaData.DataPoints,                             SpecInfo(ii).Samples, 'single')};
    end
    
    fseek(fileID, SpecInfo(1).Blocks{2}, 'bof');
    
    kk = zeros(1, length(SpecInfo));
    while true
        extractedLine = fgetl(fileID);
        
        if extractedLine == -1
            break
        else
            auxStream = strsplit(extractedLine, ';');
            
            for ii = 1:numel(SpecInfo)
                auxData = strsplit(auxStream{ii}, ',');
                
                if ii == 1
                    auxTimeStamp = datetime([startDate auxData{1}], 'InputFormat', 'yyyy-MM-ddHH:mm:ss', 'Format', 'dd/MM/yyyy HH:mm:ss');
                    
                    if auxTimeStamp > TimeStamp
                        TimeStamp = auxTimeStamp;
                    else
                        TimeStamp = auxTimeStamp + days(1);
                        startDate = datestr(TimeStamp, 'yyyy-mm-dd');
                    end
                end
                
                if length(auxData) == (SpecInfo(ii).MetaData.DataPoints + 1)
                    kk(ii) = kk(ii)+1;
                    
                    SpecInfo(ii).Data{1}(kk(ii)) = TimeStamp;
                    
                    for jj = 1:SpecInfo(ii).MetaData.DataPoints
                        SpecInfo(ii).Data{2}(jj,kk(ii)) = str2double(auxData{jj+1});
                    end
                else
                    warning('Número de elementos de "auxData" difere de "specData.DataPoints".')
                end
            end
        end
    end
end
%% Funções auxiliares
% *GPS Conversion Formats*.
function [Latitude, Longitude] = gpsConversionFormats(LatitudeString, LongitudeString)
    arguments
        LatitudeString  char
        LongitudeString char
    end
    
    Latitude = [];
    if ~isempty(LatitudeString)
        auxStr = strsplit(LatitudeString(1:end-1), '.');
        
        Latitude = str2double(auxStr{1}) + str2double(auxStr{2})/60 + str2double(auxStr{3})/3600;                
        if LatitudeString(end) == 'S'
            Latitude = -Latitude;
        end
    end
    
    Longitude = [];
    if ~isempty(LongitudeString)
        auxStr = strsplit(LongitudeString(1:end-1), '.');
        
        Longitude = str2double(auxStr{1}) + str2double(auxStr{2})/60 + str2double(auxStr{3})/3600;                
        if LongitudeString(end) == 'W'
            Longitude = -Longitude;
        end
    end
    
end