function specData = RFlookBinV1(fileName, ReadType, metaData)

    % Author.: Eric Magalhães Delgado
    % Date...: October 23, 2023
    % Version: 1.01

    arguments
        fileName char
        ReadType char   = 'SingleFile'
        metaData struct = []
    end
    
    fileID = fopen(fileName, 'r');
    if fileID == -1
        error('File not found.');
    end

    rawData = fread(fileID, [1, inf], 'uint8=>uint8');
    fclose(fileID);

    fileFormat = char(rawData(1:15));
    if ~strcmp(fileFormat, 'RFlookBin v.1/1')
        error('It is not a RFlookBinV1 file! :(')
    end

    switch ReadType
        case {'MetaData', 'SingleFile'}
            specData = Fcn_MetaDataReader(rawData, fileName);

            if strcmp(ReadType, 'SingleFile')
                specData = Fcn_SpecDataReader(specData);
            end
            
        case 'SpecData'
            specData = copy(metaData(1).Data, {});
            specData = Fcn_SpecDataReader(specData);
    end
end


%-------------------------------------------------------------------------%
function specData = Fcn_MetaDataReader(rawData, fileName)

    % Criação das variáveis principais (specData e gpsData).
    specData = class.specData.empty;
    gpsData  = struct('Status', 0, 'Matrix', []);

    [FileHeaderBlock, gpsTimestampBlock, SpectralBlock, TextTrailerBlock] = Fcn_FileMemoryMap(rawData, fileName);
    [TaskName, ID, Description, Receiver, AntennaInfo, IntegrationFactor] = Fcn_TextBlockRead(TextTrailerBlock);
    
    nSweeps = double(FileHeaderBlock.Data.WritedSamples);
    if ~nSweeps
        return
    end   


    % Metadados principais.
    specData(1).Receiver               = Receiver;
    specData.MetaData.DataType         = 1;
    specData.MetaData.FreqStart        = double(FileHeaderBlock.Data.F0);
    specData.MetaData.FreqStop         = double(FileHeaderBlock.Data.F1);
    specData.MetaData.LevelUnit        = class.specData.id2str('LevelUnit', FileHeaderBlock.Data.LevelUnit);
    specData.MetaData.DataPoints       = double(FileHeaderBlock.Data.DataPoints);
    specData.MetaData.Resolution       = double(FileHeaderBlock.Data.Resolution);
    specData.MetaData.TraceMode        = class.specData.id2str('TraceMode', FileHeaderBlock.Data.TraceMode);

    if ~strcmp(specData.MetaData.TraceMode, 'ClearWrite')
        specData.MetaData.TraceIntegration = IntegrationFactor;
    end
    
    specData.MetaData.Detector         = class.specData.id2str('Detector', FileHeaderBlock.Data.Detector);
    specData.MetaData.Antenna          = AntennaInfo;


    % GPS.
    switch FileHeaderBlock.Data.gpsType
        case 0                                                                                      % MANUAL
            gpsData.Status = -1;
            gpsData.Matrix = [double(FileHeaderBlock.Data.Latitude), double(FileHeaderBlock.Data.Longitude)];
        
        otherwise                                                                                   % AUTO (1: BUILT-IN; 2: EXTERNAL)
            gpsArray = zeros(nSweeps, 3);
            for ii = 1:nSweeps
                gpsArray(ii,:) = [double(gpsTimestampBlock.Data(ii).gpsStatus), double(gpsTimestampBlock.Data(ii).Latitude), double(gpsTimestampBlock.Data(ii).Longitude)];
            end

            gpsStatus = max(gpsArray(:,1));
            if gpsStatus
                gpsData = fcn.gpsInterpolation(gpsArray);
            else
                if FileHeaderBlock.Data.gpsStatus
                    gpsData.Status = FileHeaderBlock.Data.gpsStatus;
                    gpsData.Matrix = [double(FileHeaderBlock.Data.Latitude), double(FileHeaderBlock.Data.Longitude)];
                end
            end
    end
    gpsData = fcn.gpsSummary({gpsData});


    % Metadados secundários (incluso na tabela "RelatedFiles"), além de
    % informação acerca do mapeamento do arquivo (para fins de leitura dos
    % dados de espectro).
    [~, file, ext] = fileparts(fileName);
    BeginTime      = datetime(gpsTimestampBlock.Data(1).localTimeStamp,   'Format', 'dd/MM/yyyy HH:mm:ss') + years(2000);
    EndTime        = datetime(gpsTimestampBlock.Data(end).localTimeStamp, 'Format', 'dd/MM/yyyy HH:mm:ss') + years(2000);
    RevisitTime    = seconds(EndTime-BeginTime)/(nSweeps-1);    
    
    specData.GPS = rmfield(gpsData, 'Matrix');
    specData.RelatedFiles(end+1,:) = {[file ext], TaskName, ID, Description, BeginTime, EndTime, nSweeps, RevisitTime, {gpsData}, char(matlab.lang.internal.uuid())};

    specData.FileMap.BitsPerPoint      = FileHeaderBlock.Data.BitsPerPoint;
    specData.FileMap.gpsTimestampBlock = gpsTimestampBlock;
    specData.FileMap.SpectralBlock     = SpectralBlock;
end


%-------------------------------------------------------------------------%
function specData = Fcn_SpecDataReader(specData)

    if isempty(specData)
        return
    end

    if specData.Enable
        specData          = specData.PreAllocationData();
    
        nSweeps           = specData.RelatedFiles.nSweeps;
        BitsPerPoint      = specData.FileMap.BitsPerPoint;
        gpsTimestampBlock = specData.FileMap.gpsTimestampBlock;
        SpectralBlock     = specData.FileMap.SpectralBlock;
    
        for ii = 1:nSweeps
            specData.Data{1}(ii) = datetime(gpsTimestampBlock.Data(ii).localTimeStamp, 'Format', 'dd/MM/yyyy HH:mm:ss') + years(2000);
    
            switch BitsPerPoint
                case 8
                    OFFSET = single(gpsTimestampBlock.Data(ii).Offset) - 127.5;
                    specData.Data{2}(:,ii) = single(SpectralBlock.Data.Array(:,ii))./2 + OFFSET;
                case 16
                    specData.Data{2}(:,ii) = single(SpectralBlock.Data.Array(:,ii)) ./ 100;
                case 32
                    specData.Data{2}(:,ii) = SpectralBlock.Data.Array(:,ii);
            end
        end
    end

    specData.FileMap = [];
end


%-------------------------------------------------------------------------%
function [FileHeaderBlock, gpsTimestampBlock, SpectralBlock, TextTrailerBlock] = Fcn_FileMemoryMap(rawData, fileName)

    FileHeaderBlock = memmapfile(fileName, 'Format', {'uint8',  [1 15], 'FileName';         ... % 15 (File Format)
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
    
    switch FileHeaderBlock.Data.BitsPerPoint
        case  8; dataFormat = 'uint8';
        case 16; dataFormat = 'int16';
        case 32; dataFormat = 'single';
    end
    
    DataPoints      = double(FileHeaderBlock.Data.DataPoints);
    WritedSamples   = double(FileHeaderBlock.Data.WritedSamples);
    TextBlockLength = double(numel(rawData)-FileHeaderBlock.Data.Offset3);
    
    if WritedSamples > 0
        gpsTimestampBlock  = memmapfile(fileName, 'Offset', FileHeaderBlock.Data.Offset1,           ...
                                                  'Format', {'int8',   [1  6], 'localTimeStamp';    ...
                                                             'int16',  [1  1], 'localTimeStamp_ms'; ...
                                                             'int16',  [1  1], 'Offset';            ...
                                                             'uint8',  [1  1], 'attFactor';         ...
                                                             'uint8',  [1  1], 'gpsStatus';         ...
                                                             'single', [1  1], 'Latitude';          ...
                                                             'single', [1  1], 'Longitude'},        ...
                                                  'Repeat', WritedSamples);
        
        SpectralBlock      = memmapfile(fileName, 'Offset', FileHeaderBlock.Data.Offset2,                       ...
                                                  'Format', {dataFormat, [DataPoints, WritedSamples], 'Array'}, ...
                                                  'Repeat', 1);
        
        TextTrailerBlock   = memmapfile(fileName, 'Offset', FileHeaderBlock.Data.Offset3,                 ...
                                                  'Format', {'uint8', [1 TextBlockLength], 'Dictionary'}, ...
                                                  'Repeat', 1);
    else
        gpsTimestampBlock = [];
        SpectralBlock     = [];
        TextTrailerBlock  = [];
    end
end


%-------------------------------------------------------------------------%
function [TaskName, ID, Description, Receiver, AntennaInfo, IntegrationFactor] = Fcn_TextBlockRead(metaStr)

    % - appColeta v. 1.00
    %   "TaskName", "ThreadID", "Description", "Node", "Antenna", "AntennaHeight", 
    %   "AntennaAzimuth" (*), "AntennaElevation" (*) e "RevisitTime" (**).
    %
    % - appColeta v. 1.11
    %   Incluso o campo "IntegrationFactor".
    %
    % - appColeta v. 1.49
    %   Eliminados os campos "AntennaHeight", "AntennaAzimuth" e "AntennaElevation".
    %   As informações sobre a antena estão estruturadas num único campo chamado
    %   "Antenna" (***).
    %
    % - Notas:
    %   *   Campos incluídos apenas se a antena for diretiva.
    %   **  Campo "RevisitTime" contém informação ainda não explorada na atual versão 
    %       do appAnalise.
    %   *** A nova estrutura "Antenna" é formada pelos campos "Name", "TrackingMode", 
    %       "Height", "Azimuth", "Elevation" e "Polarization", a depender do tipo de 
    %       antena. "Height" é uma string no formato "2m" (diferente do antigo campo 
    %       "AntennaHeight" que era numérico).

    metaStruct  = jsondecode(native2unicode(metaStr.Data.Dictionary));

    TaskName    = metaStruct.TaskName;
    ID          = metaStruct.ThreadID;
    Description = metaStruct.Description;
    Receiver    = metaStruct.Node;

    if isstruct(metaStruct.Antenna)
        AntennaInfo = metaStruct.Antenna;
    else
        AntennaInfo = struct('Name', metaStruct.Antenna, 'TrackingMode', 'Manual');
    end

    if isfield(metaStruct, 'AntennaHeight')
        AntennaInfo.Height    = sprintf('%dm', metaStruct.AntennaHeight);
    end

    if isfield(metaStruct, 'AntennaAzimuth')
        AntennaInfo.Azimuth   = metaStruct.AntennaAzimuth;
    end

    if isfield(metaStruct, 'AntennaElevation')
        AntennaInfo.Elevation = metaStruct.AntennaElevation;
    end
    
    if isfield(metaStruct, 'IntegrationFactor')
        IntegrationFactor     = metaStruct.IntegrationFactor;
    else
        IntegrationFactor     = -1;
    end
end