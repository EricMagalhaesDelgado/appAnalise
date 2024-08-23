function specData = SM1809(fileName, ReadType, metaData)

    % Author.: Eric Magalhães Delgado
    % Date...: November 12, 2023
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
    
    switch ReadType
        case {'MetaData', 'SingleFile'}
            specData = Fcn_MetaDataReader(fileID, fileName);
            
            if strcmp(ReadType, 'SingleFile')
                specData = Fcn_SpecDataReader(specData, fileID);
            end
            
        case 'SpecData'
            specData = copy(metaData(1).Data, {});
            specData = Fcn_SpecDataReader(specData, fileID);
    end

    fclose(fileID);
end


%-------------------------------------------------------------------------%
function specData = Fcn_MetaDataReader(fileID, fileName)

    % Criação das variáveis principais (specData e gpsData)
    specData = class.specData.empty;
    gpsData  = struct('Status', 0, 'Matrix', []);

    [~, file, ext] = fileparts(fileName);
    
    while true
        extractedLine = fgetl(fileID);        
        if isempty(extractedLine)
            break
        end
        
        Field = extractBefore(extractedLine, ' ');
        Value = extractAfter(extractedLine,  ' ');
        
        switch Field
            case 'Latitude';             latDegree        = gpsConversionFormats(Value);
            case 'Longitude';            longDegree       = gpsConversionFormats(Value);
            case 'FreqStart';            FreqStart        = strsplit(Value, ';');
            case 'FreqStop';             FreqStop         = strsplit(Value, ';');
            case 'AntennaType';          AntennaType      = Value;
            case 'FilterBandwidth';      FilterBandwidth  = strsplit(Value, ';');
            case 'LevelUnits';           LevelUnits       = strsplit(Value, ';');
            case 'Date';                 ReferenceDate    = Value;
            case 'DataPoints';           DataPoints       = strsplit(Value, ';');
            case 'ScanTime';             RevisitTime      = strsplit(Value, ';');
            case 'Detector';             Detector         = strsplit(Value, ';');
            case 'TraceMode';            TraceMode        = strsplit(Value, ';');
            case {'Samples', 'nSweeps'}; nSweeps          = str2double(Value);
            case {'Node', 'Receiver'};   Receiver         = Value;
            case {'ThreadID', 'ID'};     ID               = strsplit(Value, ';');
            case 'TaskName';             TaskName         = Value;    
            case 'Description';          Description      = strsplit(Value, ';');
            case 'ObservationTime';      ObservationTime  = Value;
        end
    end
    ByteOffset = ftell(fileID);
    
    if exist('latDegree', 'var')  && ~isempty(latDegree) && ...
       exist('longDegree', 'var') && ~isempty(longDegree)
        gpsData.Status = 1;
        gpsData.Matrix = [latDegree, longDegree];
    end
    gpsData = fcn.gpsSummary({gpsData});
    
    for ii=1:numel(FreqStart)
        specData(ii).Receiver             = Receiver;

        specData(ii).MetaData.DataType    = 1809;
        specData(ii).MetaData.FreqStart   = str2double(FreqStart{ii}) * 1e+3;
        specData(ii).MetaData.FreqStop    = str2double(FreqStop{ii})  * 1e+3;
        specData(ii).MetaData.DataPoints  = str2double(DataPoints{ii});
        specData(ii).MetaData.TraceMode   = TraceMode{ii};

        try
            specData(ii).MetaData.Antenna = jsondecode(AntennaType);
        catch
            specData(ii).MetaData.Antenna = struct('Name', AntennaType);
        end
        
        switch LevelUnits{ii}
            case 'dBm'
                specData(ii).MetaData.LevelUnit = 'dBm';
            case 'dBuV'
                specData(ii).MetaData.LevelUnit = 'dBµV';
            case 'dBuV/m'
                specData(ii).MetaData.LevelUnit = 'dBµV/m';
        end
        
        if ~isempty(FilterBandwidth{ii})
            specData(ii).MetaData.Resolution = str2double(FilterBandwidth{ii}) * 1e+3;
        end
        
        if ~isempty(TraceMode{ii})
            specData(ii).MetaData.TraceMode  = TraceMode{ii};
        end
        
        try
            specData(ii).MetaData.Detector   = Detector{ii};
        catch
        end

        specData(ii).GPS     = rmfield(gpsData, 'Matrix');
        specData(ii).FileMap = struct('ReferenceDate', ReferenceDate, 'ByteOffset', ByteOffset);

        BeginTime = datetime(extractBefore(ObservationTime, ' - '), 'InputFormat', 'dd/MM/yyyy HH:mm:ss', 'Format', 'dd/MM/yyyy HH:mm:ss');
        EndTime   = datetime(extractAfter( ObservationTime, ' - '), 'InputFormat', 'dd/MM/yyyy HH:mm:ss', 'Format', 'dd/MM/yyyy HH:mm:ss');

        specData(ii).RelatedFiles(1,:) = {[file ext], TaskName, str2double(ID{ii}), Description{ii}, BeginTime, EndTime, nSweeps, str2double(RevisitTime{ii}), {gpsData}, char(matlab.lang.internal.uuid())};
    end
end


%-------------------------------------------------------------------------%
function specData = Fcn_SpecDataReader(specData, fileID)

    fseek(fileID, specData(1).FileMap.ByteOffset, 'bof');
    
    arrayfun(@(x) PreAllocationData(x), specData)
    
    startDate = specData(1).FileMap.ReferenceDate;
    TimeStamp = datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss');
    
    kk = zeros(1, numel(specData));
    while true
        extractedLine = fgetl(fileID);        
        if extractedLine == -1
            break

        else
            auxStream = strsplit(extractedLine, ';');
            
            for ii = 1:numel(specData)
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
                
                if numel(auxData) == (specData(ii).MetaData.DataPoints + 1)
                    kk(ii) = kk(ii)+1;
                    
                    specData(ii).Data{1}(kk(ii))   = TimeStamp;
                    specData(ii).Data{2}(:,kk(ii)) = cellfun(@(x) str2double(x), auxData(2:end))';
                end
            end
        end
    end

    for ii = 1:numel(specData)
        if kk(ii) < specData(ii).RelatedFiles.nSweeps(1)
            specData(ii).Data{1}(kk(ii)+1:end)   = [];
            specData(ii).Data{2}(:,kk(ii)+1:end) = [];
        end
    end
end


%-------------------------------------------------------------------------%
function outValue = gpsConversionFormats(inValue)
    
    outValue = [];

    if ~isempty(inValue)
        tempValue = strsplit(inValue(1:end-1), '.');
        outValue  = str2double(tempValue{1}) + str2double(tempValue{2})/60 + str2double(tempValue{3})/3600;

        if ismember(inValue(end), {'S', 'W'})
             outValue = -outValue;
        end
    end
end