function [SpecInfo, metaData, specData] = RFLookBin(filename, ReadType)
% FILEREADER_RFLOOKBIN Leitor de arquivo no formato RFlookBin.
    
    arguments
        filename char
        ReadType char = 'SingleFile'
    end
    
    fileID = fopen(filename);
    if fileID == -1
        error('Arquivo não encontrado!');
    end
    
    SpecInfo = struct('Node',         '', 'ThreadID',   '', 'MetaData',   [], 'ObservationTime', '', 'Samples',   [],    ...
                      'Data',         {}, 'statsData',  [], 'FileFormat', '', 'TaskName',        '', 'Description', '',  ...
                      'RelatedFiles', {}, 'RelatedGPS', {}, 'gps',        [], 'Blocks',          []);
    
    [metaData, specData] = Fcn_RFLookReader(filename);
    
    if ~metaData.Data.WritedSamples
        SpecInfo(1).Samples = [];
        return
    end
    [TaskName, ThreadID, Description, Node, antennaName] = Fcn_TextBlockRead(specData{3}.Data.Dictionary);
    
    SpecInfo(1).Node  = Node;
    SpecInfo.ThreadID = ThreadID;
    
    SpecInfo.MetaData.DataType   = str2double(extractAfter(char(metaData.Data.FileName), '/'));
    SpecInfo.MetaData.ThreadID   = SpecInfo.ThreadID;
    SpecInfo.MetaData.FreqStart  = double(metaData.Data.F0);
    SpecInfo.MetaData.FreqStop   = double(metaData.Data.F1);
    SpecInfo.MetaData.LevelUnit  = double(metaData.Data.LevelUnit);
    SpecInfo.MetaData.DataPoints = double(metaData.Data.DataPoints);
    SpecInfo.MetaData.Resolution = double(metaData.Data.Resolution);
    SpecInfo.MetaData.SampleTime = [];    
    SpecInfo.MetaData.Threshold  = [];
    SpecInfo.MetaData.TraceMode  = double(metaData.Data.TraceMode);
    SpecInfo.MetaData.Detector   = double(metaData.Data.Detector);
    
    Unit        = Fcn_UnitMap(SpecInfo.MetaData.LevelUnit);
    Resolution  = sprintf('%.3f kHz', SpecInfo.MetaData.Resolution/1000);
    TraceMode   = Fcn_TraceModeMap(SpecInfo.MetaData.TraceMode);
    Detector    = Fcn_DetectorMap(SpecInfo.MetaData.Detector);    
    SpecInfo.MetaData.metaString = {Unit, Resolution, TraceMode, Detector, antennaName};
    
    SpecInfo.Samples     = double(metaData.Data.WritedSamples);
    SpecInfo.FileFormat  = 'RFlookBin';
    SpecInfo.TaskName    = TaskName;
    SpecInfo.Description = Description;
    StartTime = datetime(specData{1}.Data(1).localTimeStamp,   'Format', 'dd/MM/yyyy HH:mm:ss') + years(2000);
    StopTime  = datetime(specData{1}.Data(end).localTimeStamp, 'Format', 'dd/MM/yyyy HH:mm:ss') + years(2000);
    ObservationTime = sprintf('%s - %s', datestr(StartTime, 'dd/mm/yyyy HH:MM:SS'), datestr(StopTime, 'dd/mm/yyyy HH:MM:SS'));
    RevisitTime     = seconds(StopTime-StartTime)/(SpecInfo.Samples-1);
    
    SpecInfo.ObservationTime = ObservationTime;
    
    [~, file, ext] = fileparts(filename);
    
    switch ReadType
        case 'MetaData'
            SpecInfo.gps = struct('Status', double(metaData.Data.gpsStatus), ...
                                  'Latitude', -1, 'Longitude', -1, 'Count', 0, 'Location', '', 'Matrix', []);
            
            switch metaData.Data.gpsType
                case 0                                                                                      % MANUAL
                    SpecInfo.gps.Count     = 1;                    
                    SpecInfo.gps.Latitude  = double(metaData.Data.Latitude);
                    SpecInfo.gps.Longitude = double(metaData.Data.Longitude);
                    if (SpecInfo.gps.Latitude ~= -1) | (SpecInfo.gps.Longitude ~= -1)
                        SpecInfo.gps.Matrix    = [SpecInfo.gps.Latitude, SpecInfo.gps.Longitude];
                    end
                
                otherwise                                                                                   % AUTO (1: BUILT-IN; 2: EXTERNAL)
                    gpsArray = zeros(SpecInfo.Samples, 3);
                    for ii = 1:SpecInfo.Samples
                        gpsArray(ii,:) = [double(specData{1}.Data(ii).gpsStatus), double(specData{1}.Data(ii).Latitude), double(specData{1}.Data(ii).Longitude)];
                    end
                    gpsStatus = max(gpsArray(:,1));
                    if gpsStatus
                        SpecInfo.gps.Status = gpsStatus;
                        idx_invalid = find(gpsArray(:,1) == 0);
                        if ~isempty(idx_invalid)
                            idx_valid = find(gpsArray(:,1) == 1);
                            latArray  = interp1(idx_valid, gpsArray(idx_valid,2), idx_invalid, 'linear', 'extrap');
                            longArray = interp1(idx_valid, gpsArray(idx_valid,3), idx_invalid, 'linear', 'extrap');
                            gpsArray(idx_invalid,2:3) = [latArray, longArray];
                        end                        
                        
                        SpecInfo.gps.Count     = SpecInfo.Samples;
                        SpecInfo.gps.Latitude  = mean(gpsArray(:,2));
                        SpecInfo.gps.Longitude = mean(gpsArray(:,3));
                        SpecInfo.gps.Matrix    = gpsArray(:,2:3);                        
                    else
                        if metaData.Data.gpsStatus
                            SpecInfo.gps.Count     = 1;                    
                            SpecInfo.gps.Latitude  = double(metaData.Data.Latitude);
                            SpecInfo.gps.Longitude = double(metaData.Data.Longitude);
        
                            if (SpecInfo.gps.Latitude ~= -1) | (SpecInfo.gps.Longitude ~= -1)
                                SpecInfo.gps.Matrix = [SpecInfo.gps.Latitude, SpecInfo.gps.Longitude];
                            end
                        end
                    end
            end
            
            if SpecInfo.gps.Count
                SpecInfo.gps.Location = geo_FindCity(SpecInfo.gps);
            end
            
            SpecInfo.RelatedFiles = table({[file ext]}, StartTime, StopTime, SpecInfo.Samples, RevisitTime, ...
                                          'VariableNames', {'Name', 'BeginTime', 'EndTime', 'Samples', 'RevisitTime'});
            SpecInfo.RelatedGPS   = {SpecInfo.gps};
            SpecInfo.gps          = rmfield(SpecInfo.gps, {'Count', 'Matrix'});
        
        case 'SingleFile'
            SpecInfo.Data{1} = repmat(datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss'), 1, SpecInfo.Samples);
            SpecInfo.Data{2} = zeros(SpecInfo.MetaData.DataPoints, SpecInfo.Samples, 'single');
            
            for ii = 1:SpecInfo.Samples
                SpecInfo.Data{1}(ii) = datetime(specData{1}.Data(ii).localTimeStamp, 'Format', 'dd/MM/yyyy HH:mm:ss') + years(2000);
                
                if metaData.Data.BitsPerPoint ==  8
                    OFFSET = single(specData{1}.Data(ii).Offset) - 127.5;
                    SpecInfo.Data{2}(:,ii) = single(specData{2}.Data.Array(:,ii))./2 + OFFSET;
                elseif metaData.Data.BitsPerPoint == 16
                    SpecInfo.Data{2}(:,ii) = single(specData{2}.Data.Array(:,ii)) ./ 100;
                elseif metaData.Data.BitsPerPoint == 32
                    SpecInfo.Data{2}(:,ii) = specData{2}.Data.Array(:,ii);
                end
            end
    end    
end


%-------------------------------------------------------------------------%
function [TaskName, ThreadID, Description, Node, Antenna] = Fcn_TextBlockRead(metaStr)    
    metaStruct  = jsondecode(native2unicode(metaStr));
    TaskName    = metaStruct.TaskName;
    ThreadID    = metaStruct.ThreadID;
    Description = metaStruct.Description;
    Node        = metaStruct.Node;
    Antenna     = metaStruct.Antenna;    
end


%-------------------------------------------------------------------------%
function str = Fcn_UnitMap(ID)
    str = '';
    switch ID
        case 1; str = 'dBm';
        case 2; str = 'dBµV';
    end
end


%-------------------------------------------------------------------------%
function str = Fcn_TraceModeMap(ID)        
    str = '';
    switch ID
        case 1; str = 'ClearWrite';
        case 2; str = 'Average';
        case 3; str = 'MaxHold';
        case 4; str = 'MinHold';
    end    
end


%-------------------------------------------------------------------------%
function str = Fcn_DetectorMap(ID)        
    str = '';
    switch ID
        case 1; str = 'Sample';
        case 2; str = 'Average/RMS';
        case 3; str = 'Positive Peak';
        case 4; str = 'Negative Peak';
    end
end


%-------------------------------------------------------------------------%
% Mapeamento do arquivo na memória
%-------------------------------------------------------------------------%
function [metaData, specData] = Fcn_RFLookReader(filename)
    arguments
        filename char
    end
    metaData = memmapfile(filename, 'Format',  {'uint8',  [1 15], 'FileName';         ... % 15 (File Format)
                                                'uint8',  [1  1], 'BitsPerPoint';     ... % 16
                                                'uint32', [1  1], 'EstimatedSamples'; ... % 20
                                                'uint32', [1  1], 'WritedSamples';    ... % 24
                                                'single', [1  1], 'F0';               ... % 28 (Spectral MetaData)
                                                'single', [1  1], 'F1';               ... % 32
                                                'single', [1  1], 'Resolution';       ... % 36
                                                'uint16', [1  1], 'DataPoints';       ... % 38
                                                'int8',   [1  1], 'TraceMode';        ... % 39
                                                'int8',   [1  1], 'Detector';         ... % 40
                                                'int8',   [1  1], 'LevelUnit';        ... % 41
                                                'int8',   [1  1], 'Preamp';           ... % 42
                                                'int8',   [1  1], 'attMode';          ... % 43
                                                'int8',   [1  1], 'attFactor';        ... % 44
                                                'single', [1  1], 'SampleTime';       ... % 48
                                                'uint8',  [1  2], 'Alignment';        ... % 50
                                                'uint8',  [1  1], 'gpsType';          ... % 51 (GPS Data)
                                                'int8',   [1  1], 'gpsStatus';        ... % 52
                                                'single', [1  1], 'Latitude';         ... % 56
                                                'single', [1  1], 'Longitude';        ... % 60
                                                'int8',   [1  6], 'utcTimeStamp';     ... % 66
                                                'int16',  [1  1], 'utcTimeStamp_ms';  ... % 68
                                                'uint32', [1  1], 'Offset1';          ... % 72 (Offset Data)
                                                'uint32', [1  1], 'Offset2';          ... % 76
                                                'uint32', [1  1], 'Offset3'},         ... % 80
                                    'Repeat', 1);
    
    if     metaData.Data.BitsPerPoint ==  8; dataFormat = 'uint8';
    elseif metaData.Data.BitsPerPoint == 16; dataFormat = 'int16';
    elseif metaData.Data.BitsPerPoint == 32; dataFormat = 'single';
    end
    
    DataPoints    = double(metaData.Data.DataPoints);
    WritedSamples = double(metaData.Data.WritedSamples);
    
    fileID = fopen(filename);
    fseek(fileID, 0, 'eof');
    TextBlockLength = double(ftell(fileID)-metaData.Data.Offset3);
    fclose(fileID);
    
    specData = [];
    if WritedSamples > 0
        specData{1} = memmapfile(filename, 'Offset', metaData.Data.Offset1,                  ...
                                           'Format', {'int8',   [1  6], 'localTimeStamp';    ...
                                                      'int16',  [1  1], 'localTimeStamp_ms'; ...
                                                      'int16',  [1  1], 'Offset';            ...
                                                      'uint8',  [1  1], 'attFactor';         ...
                                                      'uint8',  [1  1], 'gpsStatus';         ...
                                                      'single', [1  1], 'Latitude';          ...
                                                      'single', [1  1], 'Longitude'},        ...
                                           'Repeat', WritedSamples);
        
        specData{2} = memmapfile(filename, 'Offset', metaData.Data.Offset2,                              ...
                                           'Format', {dataFormat, [DataPoints, WritedSamples], 'Array'}, ...
                                           'Repeat', 1);
        
        specData{3} = memmapfile(filename, 'Offset', metaData.Data.Offset3,                        ...
                                           'Format', {'uint8', [1 TextBlockLength], 'Dictionary'}, ...
                                           'Repeat', 1);
    end
end