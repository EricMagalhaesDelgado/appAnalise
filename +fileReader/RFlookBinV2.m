function specData = RFlookBinV2(fileName, ReadType, metaData)

    % Author.: Eric Magalhães Delgado
    % Date...: March 28, 2024
    % Version: 1.02

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
    if ~contains(fileFormat, 'RFlookBin v.2')
        error('It is not a RFlookBin file! :(')
    end

    switch ReadType
        case {'MetaData', 'SingleFile'}
            specData = Fcn_MetaDataReader(rawData, fileName);

            if strcmp(ReadType, 'SingleFile')
                specData = Fcn_SpecDataReader(specData, rawData, fileFormat);
            end
            
        case 'SpecData'
            specData = copy(metaData(1).Data, {});
            specData = Fcn_SpecDataReader(specData, rawData, fileFormat);
    end
end


%-------------------------------------------------------------------------%
function specData = Fcn_MetaDataReader(rawData, fileName)

    % Criação das variáveis principais (specData e gpsData)
    specData = class.specData.empty;
    gpsData  = struct('Status', 0, 'Matrix', []);
    
    % Busca pelas expressões que delimitam os blocos de espectro:
    startIndex = strfind(char(rawData), 'StArT') + 5;
    stopIndex  = strfind(char(rawData), 'StOp')  - 1;

    concIndex  = [];
    try
        concIndex  = zeros(1, numel(startIndex)+numel(stopIndex));
        concIndex(1:2:end) = startIndex;
        concIndex(2:2:end) = stopIndex;
    catch
    end

    if (numel(startIndex) ~= numel(stopIndex)) || (~isempty(concIndex) && ~issorted(concIndex))
        [startIndex, stopIndex] = fixIndexArrays(startIndex, stopIndex);
    end

    if isempty(startIndex) || isempty(stopIndex)
        return
    end

    % Leitura dos principais metadados escritos em arquivo:
    BitsPerSample  = rawData(16);                                           % 8 | 16 | 32 (bits)
    attMode_ID     = rawData(17);                                           % 0 (manual) | 1 (auto)
    gpsMode_ID     = rawData(18);                                           % 0 (manual) | 1 (Built-in) | 2 (External)
    nMetaStruct    = typecast(rawData(19:22), 'uint32');
    MetaStruct     = jsondecode(native2unicode(rawData(23:22+nMetaStruct)));

    specData(1).Receiver          = MetaStruct.Receiver;
    
    specData.MetaData.DataType   = 2;
    specData.MetaData.FreqStart  = MetaStruct.FreqStart;
    specData.MetaData.FreqStop   = MetaStruct.FreqStop;
    specData.MetaData.LevelUnit  = class.specData.str2str(MetaStruct.Unit);
    specData.MetaData.DataPoints = MetaStruct.DataPoints;
    
    specData.MetaData.Resolution = str2double(extractBefore(MetaStruct.Resolution, ' kHz'))*1000;
    if isfield(MetaStruct, 'VBW')
        specData.MetaData.VBW = str2double(extractBefore(MetaStruct.VBW, ' kHz'))*1000;
    end

    specData.MetaData.TraceMode  = MetaStruct.TraceMode;

    if ~strcmp(MetaStruct.TraceMode, 'ClearWrite')
        specData.MetaData.TraceIntegration = MetaStruct.TraceIntegration;
    end
    
    specData.MetaData.Detector   = MetaStruct.Detector;
    specData.MetaData.Antenna    = MetaStruct.AntennaInfo;
    specData.MetaData.Others     = class.specData.SecundaryMetaData('RFlookBin v.2', MetaStruct);

    % Número de bytes do cabeçalho dos blocos de espectro:
    % (a) blockOffset1: gps e atenuação
    % (b) blockOffset2: RefLevel
    if     gpsMode_ID && attMode_ID; blockOffset1 = 10;
    elseif gpsMode_ID;               blockOffset1 =  9;
    elseif attMode_ID;               blockOffset1 =  1;
    else;                            blockOffset1 =  0;
    end

    if BitsPerSample == 8;           blockOffset2 =  2;
    else;                            blockOffset2 =  0;
    end

    specData.FileMap = struct('BitsPerSample', BitsPerSample, ...
                              'blockOffset1',  blockOffset1,  ...
                              'blockOffset2',  blockOffset2,  ...
                              'idxTable',      table(startIndex', stopIndex', 'VariableNames', {'startByte', 'stopByte'}), ...
                              'attData',       struct('Mode', attMode_ID, 'Array', []));

    % O gpsMode_ID por ser 0 (manual), 1 (Built-in) ou 2 (External).
    % (a) Se gpsMode_ID = 0     >> gpsData.Status = -1
    % (b) Se gpsMode_ID = 1 | 2 >> gpsData.Status = 0 (invalid) | 1 (valid)
    nSweeps = numel(startIndex);

    if gpsMode_ID
        gpsArray = zeros(nSweeps, 3);
        for ii = 1:nSweeps
            blockArray = rawData(startIndex(ii):stopIndex(ii));

            if  ii == 1
                BeginTime = observationTime(blockArray);
            end

            if ii == nSweeps
                EndTime   = observationTime(blockArray);
            end

            gpsArray(ii,:) = [single(blockArray(9)),                 ...    % STATUS
                              typecast(blockArray(10:13), 'single'), ...    % LATITUDE
                              typecast(blockArray(14:17), 'single')];       % LONGITUDE
        end
        gpsData = fcn.gpsInterpolation(gpsArray);

    else
        BeginTime = observationTime(rawData(startIndex(1):stopIndex(1)));
        EndTime   = observationTime(rawData(startIndex(end):stopIndex(end)));

        if isfield(MetaStruct, 'Latitude') && isfield(MetaStruct, 'Longitude')
            gpsData.Status = -1;
            gpsData.Matrix(end+1,:) = [MetaStruct.Latitude, MetaStruct.Longitude];
        end
    end
    gpsData = fcn.gpsSummary({gpsData});

    [~, file, ext]  = fileparts(fileName);
    RevisitTime     = seconds(EndTime-BeginTime)/(nSweeps-1);

    specData.GPS = rmfield(gpsData, 'Matrix');
    specData.RelatedFiles(end+1,:) = {[file ext], MetaStruct.Task, MetaStruct.ID, MetaStruct.Description, BeginTime, EndTime, nSweeps, RevisitTime, {gpsData}, char(matlab.lang.internal.uuid())};    
end


%-------------------------------------------------------------------------%
function specData = Fcn_SpecDataReader(specData, rawData, fileFormat)

    if isempty(specData)
        return
    end

    if specData.Enable
        specData      = specData.PreAllocationData(1, fileFormat);
        nSweeps       = specData.RelatedFiles.nSweeps;
        DataPoints    = specData.MetaData.DataPoints;
        OFFSET        = [];
        
        if specData.FileMap.attData.Mode
            specData.FileMap.attData.Array = zeros(nSweeps, 1, 'uint8');
        end
    
        % Apenas para simplificar a notação...
        BitsPerSample = specData.FileMap.BitsPerSample;    
        startIndex    = specData.FileMap.idxTable.startByte;
        stopIndex     = specData.FileMap.idxTable.stopByte;    
        blockOffset1  = specData.FileMap.blockOffset1;
        blockOffset2  = specData.FileMap.blockOffset2;

        errorIndex    = [];
    
        for ii = 1:nSweeps
            try
                blockArray = rawData(startIndex(ii):stopIndex(ii));
                TimeStamp  = observationTime(blockArray);
        
                if BitsPerSample == 8
                    RefLevel = double(typecast(blockArray(blockOffset1+9:blockOffset1+10), 'int16'));
                    OFFSET   = RefLevel - 127.5;
                end
        
                compressedArray = blockArray(blockOffset1+blockOffset2+9:end);
                processedArray  = matlabCommunity.CompressLib.decompress(compressedArray);
                newArray        = newArrayParsing(processedArray, BitsPerSample, OFFSET, DataPoints, fileFormat);

                specData.Data{1}(ii)   = TimeStamp;
                specData.Data{2}(:,ii) = newArray(:,1);

                if fileFormat == "RFlookBin v.2/2"
                    specData.Data{4}(:,ii) = newArray(:,2);
                    specData.Data{5}(:,ii) = newArray(:,3);
                end

            catch
                errorIndex = [errorIndex, ii];
            end
        end

        if ~isempty(errorIndex)
            switch specData.MetaData.LevelUnit
                case 'dBm';    noiseLevel = -107;
                case 'dBµV';   noiseLevel =    0;
                case 'dBµV/m'; noiseLevel =   13;
            end

            xTimeIndex = setdiff(1:numel(specData.Data{1}), errorIndex);
            yTimeStamp = specData.Data{1}(xTimeIndex);

            specData.Data{1}(errorIndex)   = interp1(xTimeIndex, yTimeStamp, errorIndex, 'linear', 'extrap');
            specData.Data{2}(:,errorIndex) = noiseLevel;
        end
    
        BeginTime   = specData.Data{1}(1);
        EndTime     = specData.Data{1}(end);
        RevisitTime = seconds(EndTime-BeginTime)/(nSweeps-1);
    
        specData.RelatedFiles(1,5:8) = {BeginTime, EndTime, nSweeps, RevisitTime};
    end

    specData.FileMap = [];
end


%-------------------------------------------------------------------------%
function newArray = newArrayParsing(processedArray, BitsPerSample, OFFSET, DataPoints, fileFormat)

    newArray(:,1) = newArrayDecompress(processedArray(1:DataPoints), BitsPerSample, OFFSET);

    if fileFormat == "RFlookBin v.2/2"
            switch BitsPerSample
                case  8; kk = 2;
                case 16; kk = 1;
                case 32; kk = 1/2;
            end

            idx11 = DataPoints+1;
            idx12 = (kk+1)*DataPoints;
            idx21 = idx12+1;
            idx22 = numel(processedArray);
            
            newArray(:,2) = newArrayDecompress(typecast(processedArray(idx11:idx12), 'int16'), 16, -1);
            newArray(:,3) = newArrayDecompress(typecast(processedArray(idx21:idx22), 'int16'), 16, -1);
    end
end


%-------------------------------------------------------------------------%
function newArray = newArrayDecompress(processedArray, BitsPerSample, OFFSET)

    switch BitsPerSample
        case  8; newArray = single(processedArray)./2 + OFFSET;
        case 16; newArray = single(processedArray)./100;
        case 32; newArray = processedArray;
    end
end


%-------------------------------------------------------------------------%
function [startIndex, stopIndex] = fixIndexArrays(startIndex, stopIndex)

    if isempty(startIndex) || isempty(stopIndex)
        return
    end

    ii = 1;
    while true
        NN = numel(startIndex);
        MM = numel(stopIndex);

        if ii > NN
            break
        end

        if startIndex(ii) > stopIndex(ii)
            stopIndex(ii) = [];
            continue
        elseif (NN > ii) && (startIndex(ii+1) < stopIndex(ii))
            startIndex(ii) = [];
            continue
        end

        ii = ii+1;
    end

    if NN < MM
        startIndex(MM+1:end) = [];
    elseif NN > MM
        stopIndex(NN+1:end)  = [];
    end
end


%-------------------------------------------------------------------------%
function specificTime = observationTime(blockArray)

    specificTime  = datetime(double(blockArray(1))+2000, ...                % Year
                             double(blockArray(2)),      ...                % Month
                             double(blockArray(3)),      ...                % Date
                             double(blockArray(4)),      ...                % Hour
                             double(blockArray(5)),      ...                % Minute
                             double(blockArray(6)),      ...                % Second
                             double(typecast(blockArray(7:8), 'uint16')));  % Milisecond
end