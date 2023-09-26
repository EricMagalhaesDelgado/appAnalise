function specData = CRFSBin(fileName, ReadType, metaData)

    % Author.: Eric Magalhães Delgado
    % Date...: September 11, 2023
    % Version: 2.01

    arguments
        fileName char
        ReadType char   = 'SingleFile'
        metaData struct = []
    end
    
    fileID = fopen(fileName, 'r');
    if fileID == -1
        error('File not found.');
    end

    fileFormatID = fread(fileID, 1, 'int32', 32);
    if ~ismember(fileFormatID, [21, 22, 23])
        error('Appears not to be a CRFS Bin file.')
    end
    
    rawData = fread(fileID, [1, inf], 'uint8=>uint8');
    fclose(fileID);
    
    switch ReadType
        case {'MetaData', 'SingleFile'}
            specData = Fcn_MetaDataReader(rawData, fileName);

            if strcmp(ReadType, 'SingleFile')
                specData = Fcn_SpecDataReader(specData, rawData, fileName);
            end
            
        case 'SpecData'
            specData = copy(metaData(1).Data, {});
            specData = Fcn_SpecDataReader(specData, rawData, fileName);
    end
end


%-------------------------------------------------------------------------%
function specData = Fcn_MetaDataReader(rawData, fileName)

    % Criação das variáveis principais (specData e gpsData)
    specData = class.specData.empty;
    gpsData  = struct('Status', 0, 'Matrix', []);

    % Busca pela expressão que delimita cada bloco:
    rawIndex     = strfind(char(rawData), 'UUUU');
    if isempty(rawIndex)
        return
    end
    
    DATATYPES    = [1:8, 21:22, 24, 40:42, 51, 60:69];
    SPECTYPES    = [4, 7:8, 60:65, 67:69];
    
    BlocksTable  = table('Size', [0, 6],                                                             ...
                         'VariableTypes', {'uint8', 'double', 'double', 'uint16', 'int8', 'uint32'}, ...
                         'VariableNames', {'ID', 'StartByte', 'StopByte', 'OffsetByte', 'OffsetLevel', 'DataPoints'});
    messageTable = table('Size', [0, 2],                      ...
                         'VariableTypes', {'double', 'cell'}, ...
                         'VariableNames', {'ThreadID', 'Message'});
    Hostname     = '';
    Taskname     = '';

    warning('off', 'MATLAB:table:RowsAddedExistingVars')
    
    ii = 1;
    while ii <= numel(rawIndex)
        if ii == 1; ind1 = 1;
        else;       ind1 = rawIndex(ii-1)+4;
        end
        
        ind2     = rawIndex(ii)+3;
        rawArray = rawData(ind1:ind2);

        try
            jj = 0;
            while numel(rawArray) < 20
                jj = jj+1;
                
                ind2     = rawIndex(ii+jj)+3;
                rawArray = rawData(ind1:ind2);
            end

            ThreadID   = typecast(rawArray(1:4),  'uint32');
            BytesBlock = typecast(rawArray(5:8),  'uint32');
            DataType   = typecast(rawArray(9:12), 'uint32');
            
            if ~ismember(DataType, DATATYPES)
                error('DATATYPE')
            end

            tStart = tic;
            while numel(rawArray) < BytesBlock+20
                jj = jj+1;
                ind2     = rawIndex(ii+jj)+3;
                rawArray = rawData(ind1:ind2);
                if toc(tStart) > .1
                    error('BLOCKTIMEOUT')
                end
            end
    
            if numel(rawArray) ~= BytesBlock+20
                error('BLOCKSIZE')
            end
    
            EstimatedCheckSum  = typecast(rawArray(end-7:end-4), 'uint32');
            CalculatedCheckSum = uint32(sum(rawArray(1:end-8)));
    
            if EstimatedCheckSum ~= CalculatedCheckSum
                error('CHECKSUM')
            end

            switch DataType
                % Spectral/OCC data
                case 67; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType67(specData, rawArray, ThreadID, DataType);
                case 68; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType68(specData, rawArray, ThreadID, DataType);
                case 69; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType69(specData, rawArray, ThreadID, DataType);
                
                case 63; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType63(specData, rawArray, ThreadID, DataType);
                case 64; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType64(specData, rawArray, ThreadID, DataType);
                case 65; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType65(specData, rawArray, ThreadID, DataType);
                
                case 60; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType60(specData, rawArray, ThreadID, DataType);
                case 61; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType61(specData, rawArray, ThreadID, DataType);
                case 62; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType62(specData, rawArray, ThreadID, DataType);

                case  4; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType04(specData, rawArray, ThreadID, DataType);
                case  7; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType07(specData, rawArray, ThreadID, DataType);
                case  8; [specData, ID, OffsetByte, OffsetLevel, DataPoints] = Read_DataType08(specData, rawArray, ThreadID, DataType);

                % GPS data    
                case {2, 40}
                    if DataType == 2; gpsData = Read_DataType02(gpsData, rawArray);
                    else;             gpsData = Read_DataType40(gpsData, rawArray);
                    end

                % Thread info
                case {3, 22, 24}
                    if    DataType == 24; Description = Read_DataType24(rawArray);
                    else;                 Description = Read_DataType22(rawArray);
                    end
                    messageTable(end+1, :) = {ThreadID, Description};
                        
                % Free text
                case {5, 41, 42}
                    % Informações desses blocos não compõem app.specData.
                    
                % Unit info
                case  1; [Hostname, Taskname] = Read_DataType01(rawArray);
                case 21; [Hostname, Taskname] = Read_DataType21(rawArray);

                % Others...
                otherwise
                    warning(['Leitor do bloco do tipo ' num2str(DataType) ' pendente de implementação.']);
                    ii = ii+jj+1; 
                    continue
            end

            ii = ii+jj+1;
            if ismember(DataType, SPECTYPES)
                BlocksTable(end+1,:) = {ID, ind1, ind2, OffsetByte, OffsetLevel, DataPoints};
            end
    
        catch ME
            ME.message
            switch ME.message
                case {'CHECKSUM', 'GERROR'}
                    ii = ii+jj+1;
                otherwise % 'DATATYPE', 'BLOCKTIMEOUT' and 'BLOCKSIZE'
                    ii = ii+1;
            end
        end
    end

    gpsData  = fcn.gpsSummary({gpsData});
    specData = Fcn_DataOrganization(specData, gpsData, fileName, rawData, BlocksTable, Hostname, Taskname, messageTable);
end


%-------------------------------------------------------------------------%
function specData = Fcn_SpecDataReader(specData, rawData, fileName)

    for ii = 1:numel(specData)
        specData(ii) = PreAllocationData(specData(ii));
        Samples = specData(ii).RelatedFiles.nSweeps;
        
        for jj = 1:Samples
            specData(ii) = Read_SpecData(specData(ii), jj, rawData);
        end

        if ismember(specData(ii).MetaData.DataType, [4, 7])
            fileInfo = dir(fileName);
            specData(ii).Data{1}(1:end) = linspace(datetime(fileInfo.date)-seconds(Samples-1), datetime(fileInfo.date), Samples);
        end

        specData(ii).FileMap = [];
    end
end


%-------------------------------------------------------------------------%
% AUXILIAR FUNCTIONS
%-------------------------------------------------------------------------%
function specData = Fcn_DataOrganization(specData, gpsData, fileName, rawData, BlocksTable, Hostname, Taskname, messageTable)

    messageTable(~ismember(messageTable{:,1}, specData.IDList), :) = [];
    [~, file, ext] = fileparts(fileName);

    for ii = 1:numel(specData)
        specData(ii).Receiver = Hostname;

        levelUnit = '';
        switch specData(ii).MetaData.LevelUnit
            case 0; levelUnit = 'dBm';
            case 1; levelUnit = 'dBµV/m';
        end
        specData(ii).MetaData.LevelUnit = levelUnit;

        traceMode = '';
        if ismember(specData(ii).MetaData.DataType, [8, 62, 65, 69])
            traceMode = 'OCC';
        else
            switch specData(ii).MetaData.TraceMode
                case 0; traceMode = 'SingleMeasurement';
                case 1; traceMode = 'Mean';
                case 2; traceMode = 'Peak';
                case 3; traceMode = 'Minimum';
            end
        end
        specData(ii).MetaData.TraceMode = traceMode;

        if specData(ii).MetaData.Antenna; antennaInfo = struct('SwitchMode', 'manual', 'Port', specData(ii).MetaData.Antenna);
        else;                             antennaInfo = struct('SwitchMode', 'auto');
        end
        specData(ii).MetaData.Antenna = antennaInfo;
         
        specData(ii).GPS = rmfield(gpsData, 'Matrix');
        specData(ii).FileMap = BlocksTable(BlocksTable.ID == ii, 2:6);

        [BeginTime, EndTime, RevisitTime] = Read_ObservationTime(specData(ii), rawData, fileName);
        specData(ii).RelatedFiles(1,[1:2 5:10]) = {[file ext], Taskname, BeginTime, EndTime, height(specData(ii).FileMap), RevisitTime, {gpsData}, char(matlab.lang.internal.uuid())};
        
        
        if ~isempty(messageTable)
            specData(ii).RelatedFiles.Description{1} = Read_Description(specData, ii, messageTable);
        end            
    end

    % Ordena os fluxos pelo ID:
    IDList = specData.IDList;
    if ~issorted(IDList)
        [~, idx] = sort(IDList);
        specData = specData(idx);
    end
end


%-------------------------------------------------------------------------%
function [specData, idx] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA)
    
    Bin = struct('DataType',         DataType,   ...
                 'FreqStart',        FreqStart,  ...
                 'FreqStop',         FreqStop,   ...
                 'LevelUnit',        UnitID,     ...
                 'DataPoints',       NDATA,      ...
                 'Resolution',       Resolution, ...
                 'VBW',              -1,         ...
                 'Threshold',        Threshold,  ...
                 'TraceMode',        TraceID,    ...
                 'TraceIntegration', -1,         ...
                 'Detector',         '',         ...
                 'Antenna',          AntennaID);
    
    idx = numel(specData)+1;
    for ii = 1:numel(specData)
        if (specData(ii).RelatedFiles.ID == ThreadID) && strcmp(specData(ii).RelatedFiles.Description, Description) && isequal(specData(ii).MetaData, Bin)
            idx = ii;
            break
        end
    end

    if idx > numel(specData)        
        specData(idx).MetaData             = Bin;
        specData(idx).MetaData.DataType    = double(specData(idx).MetaData.DataType);
        specData(idx).MetaData.DataPoints  = double(specData(idx).MetaData.DataPoints);
        specData(idx).MetaData.TraceMode   = double(specData(idx).MetaData.TraceMode);

        specData(idx).RelatedFiles(1,3:4)  = {double(ThreadID), Description};
    end
end


%-------------------------------------------------------------------------%
function TimeStamp = Read_TimeStamp(rawArray, DataType)

    Date_Day     = double(rawArray(13));
    Date_Month   = double(rawArray(14));
    Date_Year    = double(rawArray(15)) + 2000;
    Time_Hours   = double(rawArray(17));
    Time_Minutes = double(rawArray(18));
    Time_Seconds = double(rawArray(19));

    if ismember(DataType, [60:65, 67:69])
        Time_nanoSec = double(typecast(rawArray(21:24), 'uint32'));
    else
        Time_nanoSec = 0;
    end
   
    TimeStamp    = datetime([Date_Year, Date_Month, Date_Day, Time_Hours, Time_Minutes, (Time_Seconds+Time_nanoSec/1e+9)]);
end


%-------------------------------------------------------------------------%
function [BeginTime, EndTime, RevisitTime] = Read_ObservationTime(specData, rawData, filename)

    if ismember(specData.MetaData.DataType, [4, 7])
        fileInfo = dir(filename);
        EndTime  = datetime(fileInfo.date, 'Locale', 'system');
        BeginTime = EndTime - seconds(specData.RelatedFiles.nSweeps-1);
        
    else
        BytesOffset = 0;
        if specData.MetaData.DataType == 8
            BytesOffset = 12;
        end

        ind1 = specData.FileMap.StartByte(1) + BytesOffset;
        ind2 = specData.FileMap.StopByte(1);
        BeginTime = Read_TimeStamp(rawData(ind1:ind2), specData.MetaData.DataType);

        ind1 = specData.FileMap.StartByte(end) + BytesOffset;
        ind2 = specData.FileMap.StopByte(end);
        EndTime  = Read_TimeStamp(rawData(ind1:ind2), specData.MetaData.DataType);
    end
    BeginTime.Format = 'dd/MM/yyyy HH:mm:ss';
    EndTime.Format   = 'dd/MM/yyyy HH:mm:ss';

    Samples          = height(specData.FileMap);
    RevisitTime      = seconds(EndTime-BeginTime)/(Samples-1);    
end


%-------------------------------------------------------------------------%
function Description = Read_Description(specData, ii, messageTable)

    Description = '';
    if isequal(messageTable.ThreadID', specData.IDList)
        Description = messageTable.Message{ii};
    else
        idx = find(messageTable.ThreadID == specData(ii).RelatedFiles.ID);
        if ~isempty(idx)
            if numel(idx) == 1
                Description = messageTable.Message{idx};
            else
                Description = jsonencode(messageTable(idx,:));
            end
        end
    end
end


%-------------------------------------------------------------------------%
% UNIT INFO: [1, 21]
%-------------------------------------------------------------------------%
% DataType 1
function [Hostname, Taskname] = Read_DataType01(rawArray)
    
    Hostname      = deblank(char(rawArray(13:28)));
    Hostname(1:2) = upper(Hostname(1:2));
    Hostname      = erase(Hostname, '_');
    
    Taskname      = 'Unknown info';    
end

% DataType 21
function [Hostname, Taskname] = Read_DataType21(rawArray)
    
    Hostname      = deblank(char(rawArray(13:28)));
    Hostname(1:2) = upper(Hostname(1:2));
    Hostname      = erase(Hostname, '_');
    TEXT1LEN      = typecast(rawArray(29:32), 'uint32');
    TEXT2LEN      = typecast(rawArray(33+TEXT1LEN:36+TEXT1LEN), 'uint32');
    Taskname      = deblank(char(rawArray(37+TEXT1LEN:36+TEXT1LEN+TEXT2LEN)));
    Taskname      = erase(Taskname, '_');    
end


%-------------------------------------------------------------------------%
% GPS DATA: [2, 40]
%-------------------------------------------------------------------------%
% DataType 2
function gpsData = Read_DataType02(gpsData, rawArray)
    
    Status    = double(typecast(rawArray(23:24), 'uint16'));
    Latitude  = double(typecast(rawArray(27:30), 'int32'));
    Longitude = double(typecast(rawArray(31:34), 'int32'));

    if Status
        gpsData.Status          = 1;
        gpsData.Matrix(end+1,:) = [Latitude, Longitude] ./ 1e+6;
    end    
end

% DataType 40
function gpsData = Read_DataType40(gpsData, rawArray)
    
    Status    = double(rawArray(33));
    Latitude  = double(typecast(rawArray(37:40), 'int32'));
    Longitude = double(typecast(rawArray(41:44), 'int32'));

    if Status
        gpsData.Status          = 1;
        gpsData.Matrix(end+1,:) = [Latitude, Longitude] ./ 1e+6;
    end    
end


%-------------------------------------------------------------------------%
% THREAD INFO: [3, 22, 24]
%-------------------------------------------------------------------------%
% DataTypes 3/22
function Description = Read_DataType22(rawArray)
    
    TEXTLEN     = typecast(rawArray(13:16), 'uint32');
    Description = deblank(char(rawArray(17:16+TEXTLEN)));
    
end

% DataType 24
function Description = Read_DataType24(rawArray)
    
    TEXTLEN     = typecast(rawArray(17:20), 'uint32');
    Description = deblank(char(rawArray(21:20+TEXTLEN)));
    
end


%-------------------------------------------------------------------------%
% SPECTRAL DATA: [4, 7, 8, 60, 61, 62, 63, 64, 65, 67, 68, 69]
%-------------------------------------------------------------------------%
% DataType 4
function [specData, ID, OffsetByte, OffsetLevel, NDATA] = Read_DataType04(specData, rawArray, ThreadID, DataType)
    
    FreqStart      = double(typecast(rawArray(13:14), 'uint16')) * 1e+6;               % (01:02) (2 bytes)
    FreqStop       = double(typecast(rawArray(15:16), 'uint16')) * 1e+6;               % (03:04) (2 bytes)
    OffsetLevel    = typecast(rawArray(17), 'int8');                                   % (05:05) (1 byte )
    AntennaID      = rawArray(18);                                                     % (06:06) (1 byte )
    TraceID        = rawArray(19);                                                     % (07:07) (1 byte )
    NDATA          = typecast(rawArray(21:24), 'uint32');                              % (09:12) (4 bytes)

    Description    = '';
    Resolution     = -1;
    Threshold      = -1;
    UnitID         = 0;

    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 24;
end


% DataType 7 (Compressed)
function [specData, ID, OffsetByte, OffsetLevel, NCDATA] = Read_DataType07(specData, rawArray, ThreadID, DataType)

    FreqStart      = double(typecast(rawArray(13:16), 'uint32')) * 1e+6;               % (01:04) (4 bytes)
    FreqStop       = double(typecast(rawArray(17:20), 'uint32')) * 1e+6;               % (05:08) (4 bytes)
    OffsetLevel    = typecast(rawArray(21:24),  'int32');                              % (09:12) (4 bytes)
    Threshold      = double(typecast(rawArray(25:28), 'int32'));                       % (13:16) (4 bytes)
    AntennaID      = typecast(rawArray(29:32), 'uint32');                              % (17:20) (4 bytes)
    TraceID        = typecast(rawArray(33:36), 'uint32');                              % (21:24) (4 bytes)
    NDATA          = typecast(rawArray(41:44), 'uint32');                              % (29:32) (4 bytes)    
    NCDATA         = typecast(rawArray(49:52), 'uint32');                              % (37:40) (4 bytes)    

    Description    = '';
    Resolution     = -1;
    UnitID         = 0;

    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 52;
end


% DataType 8 (OCC)
function [specData, ID, OffsetByte, OffsetLevel, NDATA] = Read_DataType08(specData, rawArray, ThreadID, DataType)

    FreqStart      = double(typecast(rawArray(13:16), 'uint32')) * 1e+6;               % (01:04) (4 bytes)
    FreqStop       = double(typecast(rawArray(17:20), 'uint32')) * 1e+6;               % (05:08) (4 bytes)
    Threshold      = double(typecast(rawArray(21:24),  'int32'));                      % (09:12) (4 bytes)
    AntennaID      = typecast(rawArray(37:40), 'uint32');                              % (25:28) (4 bytes)
    NDATA          = typecast(rawArray(49:52), 'uint32');                              % (37:40) (4 bytes)

    Description    = '';
    Resolution     = -1;
    TraceID        = [];
    UnitID         = 0;

    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 52;
    OffsetLevel    = 0;
end


% DataType 60
function [specData, ID, OffsetByte, OffsetLevel, NDATA] = Read_DataType60(specData, rawArray, ThreadID, DataType)
    % v.3 commom fields
    auxF0          = double(typecast(rawArray(25:28), 'uint32'));                      % (13:16) (4 bytes)
    auxF1          = double(typecast(rawArray(29:32), 'uint32'));                      % (17:20) (4 bytes)
    expF0          = double(typecast(rawArray(33:33), 'int8'));                        % (21:21) (1 byte )
    FreqStart      = auxF0 * 10^expF0;
    FreqStop       = auxF1 * 10^expF0;

    AntennaID      = rawArray(34);                                                     % (22:22) (1 byte )
    GERROR         = typecast(rawArray(35), 'int8');                                   % (23:23) (1 byte )
    if GERROR ~= -1
        error('GERROR');
    end

    % others fields...
    TraceID        = rawArray(39);                                                     % (27:27) (1 byte )
    OffsetLevel    = typecast(rawArray(41), 'int8');                                   % (29:29) (1 byte )
    NTUN           = typecast(rawArray(43:44), 'uint16');                              % (31:32) (2 bytes)
    NAGC           = typecast(rawArray(45:46), 'uint16');                              % (33:34) (2 bytes)
    NDATA          = typecast(rawArray(49:52), 'uint32');                              % (37:40) (4 bytes)

    Description    = '';
    Resolution     = [];
    Threshold      = [];
    UnitID         = 0;

    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 52 + 4*NTUN + NAGC;
end


% DataType 61 (Compressed)
function [specData, ID, OffsetByte, OffsetLevel, NCDATA] = Read_DataType61(specData, rawArray, ThreadID, DataType)
    % v.3 commom fields
    auxF0          = double(typecast(rawArray(25:28), 'uint32'));                      % (13:16) (4 bytes)
    auxF1          = double(typecast(rawArray(29:32), 'uint32'));                      % (17:20) (4 bytes)
    expF0          = double(typecast(rawArray(33:33), 'int8'));                        % (21:21) (1 byte )
    FreqStart      = auxF0 * 10^expF0;
    FreqStop       = auxF1 * 10^expF0;

    AntennaID      = rawArray(34);                                                     % (22:22) (1 byte )
    GERROR         = typecast(rawArray(35), 'int8');                                   % (23:23) (1 byte )
    if GERROR ~= -1
        error('GERROR');
    end

    % others fields...
    TraceID        = rawArray(39);                                                     % (27:27) (1 byte )
    OffsetLevel    = typecast(rawArray(41), 'int8');                                   % (29:29) (1 byte )
    NTUN           = typecast(rawArray(43:44), 'uint16');                              % (31:32) (2 bytes)
    NAGC           = typecast(rawArray(45:46), 'uint16');                              % (33:34) (2 bytes)
    NCDATA         = typecast(rawArray(49:52), 'uint32');                              % (37:40) (4 bytes)
    Threshold      = double(typecast(rawArray(53:56), 'int32'));                       % (41:44) (4 bytes)
    NDATA          = typecast(rawArray(57:60), 'uint32');                              % (45:48) (4 bytes)

    Description    = '';
    Resolution     = [];
    UnitID         = 0;

    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 60 + 4*NTUN + NAGC;
end


% DataType 62 (OCC)
function [specData, ID, OffsetByte, OffsetLevel, NDATA] = Read_DataType62(specData, rawArray, ThreadID, DataType)
    % v.3 commom fields
    auxF0          = double(typecast(rawArray(25:28), 'uint32'));                      % (13:16) (4 bytes)
    auxF1          = double(typecast(rawArray(29:32), 'uint32'));                      % (17:20) (4 bytes)
    expF0          = double(typecast(rawArray(33:33), 'int8'));                        % (21:21) (1 byte )
    FreqStart      = auxF0 * 10^expF0;
    FreqStop       = auxF1 * 10^expF0;

    AntennaID      = rawArray(34);                                                     % (22:22) (1 byte )
    GERROR         = typecast(rawArray(35), 'int8');                                   % (23:23) (1 byte )
    if GERROR ~= -1
        error('GERROR');
    end

    % others fields...
    Threshold      = double(typecast(rawArray(39:40), 'int16'));                       % (27:28) (2 bytes)
    NDATA          = typecast(rawArray(53:56), 'uint32');                              % (41:44) (4 bytes)

    Description    = '';
    Resolution     = -1;
    TraceID        = [];
    UnitID         = 0;

    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 56;
    OffsetLevel    = 0;
end


% DataType 63
function [specData, ID, OffsetByte, OffsetLevel, NDATA] = Read_DataType63(specData, rawArray, ThreadID, DataType)
    % v.4 commom fields
    IntegerPart    = double(typecast(rawArray(25:26), 'uint16'));                      % (13:14) (2 bytes)
    DecimalPart    = double(typecast(rawArray(27:30), 'int32'));                       % (15:18) (4 bytes)
    FreqStart      = (IntegerPart + DecimalPart / 1e+9) * 1e+6;

    IntegerPart    = double(typecast(rawArray(31:32), 'uint16'));                      % (19:20) (2 bytes)
    DecimalPart    = double(typecast(rawArray(33:36), 'int32'));                       % (21:24) (4 bytes)
    FreqStop       = (IntegerPart + DecimalPart / 1e+9) * 1e+6;

    % others fields...
    AntennaID      = rawArray(49);                                                     % (37:37) (1 byte )
    TraceID        = rawArray(50);                                                     % (38:38) (1 byte )
    UnitID         = rawArray(51);                                                     % (39:39) (1 byte )
    OffsetLevel   = typecast(rawArray(52), 'int8');                                    % (40:40) (1 byte )
    GERROR         = typecast(rawArray(53), 'int8');                                   % (41:41) (1 byte )
    if GERROR ~= -1
        error('GERROR');
    end

    NTUN           = typecast(rawArray(56:57), 'uint16');                              % (44:45) (2 bytes)
    NAGC           = typecast(rawArray(58:59), 'uint16');                              % (46:47) (2 bytes)
    NDATA          = typecast(rawArray(61:64), 'uint32');                              % (49:52) (4 bytes)

    Description    = '';
    Resolution     = -1;
    Threshold      = -1;
    
    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 64 + 4*NTUN + NAGC;
end


% DataType 64 (Compressed)
function [specData, ID, OffsetByte, OffsetLevel, NCDATA] = Read_DataType64(specData, rawArray, ThreadID, DataType)
    % v.4 commom fields
    IntegerPart    = double(typecast(rawArray(25:26), 'uint16'));                      % (13:14) (2 bytes)
    DecimalPart    = double(typecast(rawArray(27:30), 'int32'));                       % (15:18) (4 bytes)
    FreqStart      = (IntegerPart + DecimalPart / 1e+9) * 1e+6;

    IntegerPart    = double(typecast(rawArray(31:32), 'uint16'));                      % (19:20) (2 bytes)
    DecimalPart    = double(typecast(rawArray(33:36), 'int32'));                       % (21:24) (4 bytes)
    FreqStop       = (IntegerPart + DecimalPart / 1e+9) * 1e+6;

    % others fields...
    AntennaID      = rawArray(49);                                                     % (37:37) (1 byte )
    TraceID        = rawArray(50);                                                     % (38:38) (1 byte )
    UnitID         = rawArray(51);                                                     % (39:39) (1 byte )
    OffsetLevel    = typecast(rawArray(52), 'int8');                                   % (40:40) (1 byte )
    GERROR         = typecast(rawArray(53), 'int8');                                   % (41:41) (1 byte )
    if GERROR ~= -1
        error('GERROR');
    end

    NTUN           = typecast(rawArray(56:57), 'uint16');                              % (44:45) (2 bytes)
    NAGC           = typecast(rawArray(58:59), 'uint16');                              % (46:47) (2 bytes)
    NCDATA         = typecast(rawArray(61:64), 'uint32');                              % (49:52) (4 bytes)
    Threshold      = double(typecast(rawArray(65:68), 'int32'));                       % (53:56) (4 bytes)
    NDATA          = typecast(rawArray(69:72), 'uint32');                              % (57:60) (4 bytes)

    Description    = '';
    Resolution     = -1;
    
    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 72 + 4*NTUN + NAGC;
end


% DataType 65 (OCC)
function [specData, ID, OffsetByte, OffsetLevel, NDATA] = Read_DataType65(specData, rawArray, ThreadID, DataType)
    % v.4 commom fields
    IntegerPart    = double(typecast(rawArray(25:26), 'uint16'));                      % (13:14) (2 bytes)
    DecimalPart    = double(typecast(rawArray(27:30), 'int32'));                       % (15:18) (4 bytes)
    FreqStart      = (IntegerPart + DecimalPart / 1e+9) * 1e+6;

    IntegerPart    = double(typecast(rawArray(31:32), 'uint16'));                      % (19:20) (2 bytes)
    DecimalPart    = double(typecast(rawArray(33:36), 'int32'));                       % (21:24) (4 bytes)
    FreqStop       = (IntegerPart + DecimalPart / 1e+9) * 1e+6;

    % others fields...
    AntennaID      = rawArray(45);                                                     % (33:33) (1 byte )
    UnitID         = typecast(rawArray(47:48), 'uint16');                              % (35:36) (2 bytes)
    GERROR         = typecast(rawArray(49), 'int8');                                   % (37:37) (1 byte )
    if GERROR ~= -1
        error('GERROR');
    end
    
    Threshold      = double(typecast(rawArray(53:54), 'int16'));                       % (41:42) (2 bytes)
    NDATA          = typecast(rawArray(57:60), 'uint32');                              % (45:48) (4 bytes)

    Description    = '';
    Resolution     = -1;
    TraceID        = -1;
    
    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 60;
    OffsetLevel    = 0;
end


% DataType 67
function [specData, ID, OffsetByte, OffsetLevel, NDATA] = Read_DataType67(specData, rawArray, ThreadID, DataType)

    % v.5 commom fields
    DESCLEN        = double(typecast(rawArray(33:36), 'uint32'));                      % (21:24)           (      4 bytes)
    Description    = deblank(char(rawArray(37:36+DESCLEN)));                           % (25:24+DESCLEN)   (DESCLEN bytes)
    
    IntegerPart    = double(typecast(rawArray(37+DESCLEN:38+DESCLEN), 'uint16'));      % (25:26) + DESCLEN (      2 bytes)
    DecimalPart    = double(typecast(rawArray(39+DESCLEN:42+DESCLEN), 'int32'));       % (27:30) + DESCLEN (      4 bytes)
    FreqStart      = (IntegerPart + DecimalPart / 1e+9) * 1e+6;
    
    IntegerPart    = double(typecast(rawArray(43+DESCLEN:44+DESCLEN), 'uint16'));      % (31:32) + DESCLEN (      2 bytes)
    DecimalPart    = double(typecast(rawArray(45+DESCLEN:48+DESCLEN), 'int32'));       % (33:36) + DESCLEN (      4 bytes)
    FreqStop       = (IntegerPart + DecimalPart / 1e+9) * 1e+6;
    Resolution     = double(typecast(rawArray(49+DESCLEN:52+DESCLEN), 'int32'));       % (37:40) + DESCLEN (      4 bytes)

    % others fields...
    AntennaID      = rawArray(65+DESCLEN);                                             % (53:53) + DESCLEN (      1 byte )
    TraceID        = rawArray(66+DESCLEN);                                             % (54:54) + DESCLEN (      1 byte )
    UnitID         = rawArray(67+DESCLEN);                                             % (55:55) + DESCLEN (      1 byte )
    OffsetLevel    = typecast(rawArray(68+DESCLEN), 'int8');                           % (56:56) + DESCLEN (      1 byte )

    GERROR         = typecast(rawArray(69+DESCLEN), 'int8');                           % (57:57) + DESCLEN (      1 byte )
    if GERROR ~= -1
        error('GERROR');
    end
    NTUN           = typecast(rawArray(72+DESCLEN:73+DESCLEN), 'uint16');              % (60:61) + DESCLEN (      2 bytes)
    NAGC           = typecast(rawArray(74+DESCLEN:75+DESCLEN), 'uint16');              % (62:63) + DESCLEN (      2 bytes)
    NDATA          = typecast(rawArray(77+DESCLEN:80+DESCLEN), 'uint32');              % (65:68) + DESCLEN (      4 bytes)
    Threshold      = -1;

    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 80 + DESCLEN + 4*NTUN + NAGC;
end


% DataType 68 (Compressed)
function [specData, ID, OffsetByte, OffsetLevel, NCDATA] = Read_DataType68(specData, rawArray, ThreadID, DataType)
    % v.5 commom fields
    DESCLEN        = double(typecast(rawArray(33:36), 'uint32'));                      % (21:24)           (      4 bytes)
    Description    = deblank(char(rawArray(37:36+DESCLEN)));                           % (25:24+DESCLEN)   (DESCLEN bytes)
    
    IntegerPart    = double(typecast(rawArray(37+DESCLEN:38+DESCLEN), 'uint16'));      % (25:26) + DESCLEN (      2 bytes)
    DecimalPart    = double(typecast(rawArray(39+DESCLEN:42+DESCLEN), 'int32'));       % (27:30) + DESCLEN (      4 bytes)
    FreqStart      = (IntegerPart + DecimalPart / 1e+9) * 1e+6;
    
    IntegerPart    = double(typecast(rawArray(43+DESCLEN:44+DESCLEN), 'uint16'));      % (31:32) + DESCLEN (      2 bytes)
    DecimalPart    = double(typecast(rawArray(45+DESCLEN:48+DESCLEN), 'int32'));       % (33:36) + DESCLEN (      4 bytes)
    FreqStop       = (IntegerPart + DecimalPart / 1e+9) * 1e+6;
    Resolution     = double(typecast(rawArray(49+DESCLEN:52+DESCLEN), 'int32'));       % (37:40) + DESCLEN (      4 bytes)
    
    % others fields...
    AntennaID      = rawArray(65+DESCLEN);                                             % (53:53) + DESCLEN (      1 byte )
    TraceID        = rawArray(66+DESCLEN);                                             % (54:54) + DESCLEN (      1 byte )
    UnitID         = rawArray(67+DESCLEN);                                             % (55:55) + DESCLEN (      1 byte )
    OffsetLevel    = typecast(rawArray(68+DESCLEN), 'int8');                           % (56:56) + DESCLEN (      1 byte )
    GERROR         = typecast(rawArray(69+DESCLEN), 'int8');                           % (57:57) + DESCLEN (      1 byte )
    if GERROR ~= -1
        error('GERROR');
    end
    
    NTUN           = typecast(rawArray(72+DESCLEN:73+DESCLEN), 'uint16');              % (60:61) + DESCLEN (      2 bytes)
    NAGC           = typecast(rawArray(74+DESCLEN:75+DESCLEN), 'uint16');              % (62:63) + DESCLEN (      2 bytes)
    NCDATA         = typecast(rawArray(77+DESCLEN:80+DESCLEN), 'uint32');              % (65:68) + DESCLEN (      4 bytes)
    Threshold      = double(typecast(rawArray(81+DESCLEN:84+DESCLEN), 'int32'));       % (69:72) + DESCLEN (      4 bytes)
    NDATA          = typecast(rawArray(85+DESCLEN:88+DESCLEN), 'uint32');              % (73:76) + DESCLEN (      4 bytes)
    
    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 88 + DESCLEN + 4*NTUN + NAGC;
end


% DataType 69 (OCC)
function [specData, ID, OffsetByte, OffsetLevel, NDATA] = Read_DataType69(specData, rawArray, ThreadID, DataType)
    % v.5 commom fields
    DESCLEN        = double(typecast(rawArray(33:36), 'uint32'));                      % (21:24)           (      4 bytes)
    Description    = deblank(char(rawArray(37:36+DESCLEN)));                           % (25:24+DESCLEN)   (DESCLEN bytes)
    
    IntegerPart    = double(typecast(rawArray(37+DESCLEN:38+DESCLEN), 'uint16'));      % (25:26) + DESCLEN (      2 bytes)
    DecimalPart    = double(typecast(rawArray(39+DESCLEN:42+DESCLEN), 'int32'));       % (27:30) + DESCLEN (      4 bytes)
    FreqStart      = (IntegerPart + DecimalPart / 1e+9) * 1e+6;
    
    IntegerPart    = double(typecast(rawArray(43+DESCLEN:44+DESCLEN), 'uint16'));      % (31:32) + DESCLEN (      2 bytes)
    DecimalPart    = double(typecast(rawArray(45+DESCLEN:48+DESCLEN), 'int32'));       % (33:36) + DESCLEN (      4 bytes)
    FreqStop       = (IntegerPart + DecimalPart / 1e+9) * 1e+6;
    Resolution     = double(typecast(rawArray(49+DESCLEN:52+DESCLEN), 'int32'));       % (37:40) + DESCLEN (      4 bytes)
    
    % others fields...
    AntennaID      = rawArray(62+DESCLEN);                                             % (50:50) + DESCLEN (      1 byte )
    UnitID         = typecast(rawArray(63+DESCLEN:64+DESCLEN), 'uint16');              % (51:52) + DESCLEN (      2 bytes)
    
    GERROR         = typecast(rawArray(65+DESCLEN), 'int8');                           % (53:53) + DESCLEN (      1 byte )
    if GERROR ~= -1
        error('GERROR');
    end
    
    Threshold      = double(typecast(rawArray(69+DESCLEN:70+DESCLEN), 'int16'));       % (57:58) + DESCLEN (      2 bytes)
    NDATA          = typecast(rawArray(73+DESCLEN:76+DESCLEN), 'uint32');              % (61:64) + DESCLEN (      4 bytes)
    TraceID        = [];
    
    [specData, ID] = Fcn_BinInfo(specData, ThreadID, DataType, Description, FreqStart, FreqStop, Resolution, Threshold, AntennaID, TraceID, UnitID, NDATA);
    OffsetByte     = 76 + DESCLEN;
    OffsetLevel    = 0;
end


%-------------------------------------------------------------------------%
function specData = Read_SpecData(specData, idx, rawData)

    ind1 = specData.FileMap.StartByte(idx);
    ind2 = specData.FileMap.StopByte(idx);
    ind3 = ind1 + double(specData.FileMap.OffsetByte(idx));
    ind4 = ind3 + double(specData.FileMap.DataPoints(idx)) - 1;
    OFFSET = double(specData.FileMap.OffsetLevel(idx)) - 127.5;

    switch specData.MetaData.DataType
        case {67, 63, 60}
            specData.Data{2}(:,idx) = (single(rawData(ind3:ind4))/2 + OFFSET)';
            specData.Data{1}(idx)   = Read_TimeStamp(rawData(ind1:ind2), specData.MetaData.DataType);

        case 4
            specData.Data{2}(:,idx) = (-single(rawData(ind3:ind4))/2 + OFFSET + 127.5)';            
            
        case {68, 64, 61, 7}
            CompressedData = single(rawData(ind3:ind4));
            TraceData      = 2*((specData.MetaData.Threshold-1)-OFFSET) * ones(specData.MetaData.DataPoints, 1, 'single');
            
            kk = 0;
            ll = 0;
            while kk < length(CompressedData)
                kk=kk+1;
                TraceValue = CompressedData(kk);
                
                if TraceValue == 255
                    kk=kk+1;
                    ll=ll+CompressedData(kk);
                else
                    ll=ll+1;
                    TraceData(ll,1) = TraceValue;
                end
            end
            specData.Data{2}(:,idx) = TraceData/2 + OFFSET;
            
            if specData.MetaData.DataType ~= 7
                specData.Data{1}(idx) = Read_TimeStamp(rawData(ind1:ind2), specData.MetaData.DataType);
            end

        case {69, 65, 62, 8}
            specData.Data{2}(:,idx) = (single(rawData(ind3:ind4))/2)';
            
            if specData.MetaData.DataType ~= 8
                specData.Data{1}(idx) = Read_TimeStamp(rawData(ind1:ind2),    specData.MetaData.DataType);
            else
                specData.Data{1}(idx) = Read_TimeStamp(rawData(ind1+12:ind2), specData.MetaData.DataType);
            end            
    end
end