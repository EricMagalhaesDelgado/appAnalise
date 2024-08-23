function specData = CellPlanDBM(fileName, ReadType, metaData)

    % Author.: Eric Magalhães Delgado
    % Date...: July 08, 2024
    % Version: 1.10

    arguments
        fileName   char
        ReadType   char   = 'SingleFile'
        metaData   struct = []
    end

    fileID1 = fopen(fileName);
    if fileID1 == -1
        error('File not found.');
    end
    fclose(fileID1);
    
    % Como a estrutura do arquivo binário gerado pelo CellSpectrum não é
    % conhecida, mas a CellPlan disponibilizou uma API para extração de
    % alguns dos seus metadados, além da matriz de níveis, inicialmente, 
    % gera-se um arquivo temporário (no formato .bin), o qual possui uma
    % estrutura conhecida.
    rootFolder = pwd;
    tempFile   = [tempname '.bin'];

    cd(fullfile(fileparts(mfilename('fullpath')), 'CellPlanDBM'))
    
    system(sprintf('CellPlan_dBmReader.exe "%s" "%s"', fileName, tempFile));
    pause(.100)
    
    cd(rootFolder)
    
    % Abrindo o arquivo temporário...
    fileID2 = fopen(tempFile);
    if fileID2 == -1
        error('Tempfile not found.');
    end

    rawData = fread(fileID2, [1, inf], 'uint8=>uint8');
    fclose(fileID2);    
    
  % fileFormat = char(rawData(2:rawData(1)+1));                             % 'CellSpec dll v. 1001'
    rawData(1:rawData(1)+1) = [];    

    switch ReadType
        case {'MetaData', 'SingleFile'}
            specData = Fcn_MetaDataReader(rawData, fileName);

            if strcmp(ReadType, 'SingleFile')
                specData = Fcn_SpecDataReader(specData, rawData);
            end
            
        case 'SpecData'
            specData = copy(metaData(1).Data, {});
            specData = Fcn_SpecDataReader(specData, rawData);
    end
    
    try
        delete(tempFile)
    catch
    end
end


%-------------------------------------------------------------------------%
function specData = Fcn_MetaDataReader(rawData, fileName)

    % Criação das variáveis principais (specData e gpsData)
    specData   = class.specData.empty;
    gpsData    = struct('Status', 0, 'Matrix', []);

    % Busca pelas expressões que delimitam os blocos de espectro:
    [startIndex, stopIndex] = findIndexArrays(rawData);
    if isempty(startIndex) || isempty(stopIndex)
        return
    end

    % INFORMAÇÕES EXTRAÍDAS DO NOME DO ARQUIVO
    % 'CWSM21100020_E1_A1_Spec Frq=98.000 Span=20.000 RBW=10.000 [2022-09-25,22-51-30-090-8012].dbm'
    % 'CWSM21100020_E2_A2_Peak Frq=98.000 Span=20.000 RBW=20.000 [2022-09-25,22-51-29-089-2962].dBm'
    % 'CWSM21100020_E2_A3_Mean Frq=98.000 Span=20.000 RBW=20.000 [2022-09-25,22-51-34-097-8392].dBm'
    [~, file, ext] = fileparts(fileName);
    fileNameToken  = regexpi(file, '(?<Receiver>CWSM2\d{6,7})_E(?<Scan>\d*)_A(?<Operation>\d*)_(?<TraceMode>\w*).*', 'names');

    if isempty(fileNameToken)
        Receiver  = 'CWSM2110000';
        TraceMode = 'ClearWrite';
        ThreadID  = 1;
    else
        Receiver  = fileNameToken.Receiver;
        switch fileNameToken.TraceMode
            case 'Spec'; TraceMode = 'ClearWrite';
            case 'Peak'; TraceMode = 'MaxHold';
            case 'Mean'; TraceMode = 'Average';
        end
        ThreadID  = str2double([fileNameToken.Scan, fileNameToken.Operation]);
    end

    % Bloco espectral...
    metaDataInfo = struct(class.MetaDataList);
    metaDataInfo.DataType  = 1000;
    metaDataInfo.LevelUnit = 'dBm';
    metaDataInfo.TraceMode = TraceMode;
    metaDataInfo.Detector  = 'Sample';

    nBlocks = numel(startIndex);
    for ii = 1:nBlocks
        % Índices:
        metaIndex1 = startIndex(ii);
        metaIndex2 = startIndex(ii)+79;
        specIndex1 = startIndex(ii)+80;
        specIndex2 = stopIndex(ii);

        % Blocos:
        metaBlockArray = rawData(metaIndex1:metaIndex2);
        specBlockArray = rawData(specIndex1:specIndex2);

        % Metadados do bloco:
        FreqCenter = typecast(metaBlockArray(17:24), 'double');
        FreqSpan   = typecast(metaBlockArray(33:40), 'double')*1e+6;

        metaDataInfo.FreqStart  = FreqCenter - FreqSpan/2;
        metaDataInfo.FreqStop   = FreqCenter + FreqSpan/2;
        metaDataInfo.DataPoints = double(typecast(metaBlockArray(5:8), 'int32'));
        metaDataInfo.Resolution = typecast(metaBlockArray(41:48), 'double')*1e+3;

        [specData, idx] = checkNewBlock(specData, metaDataInfo, specIndex1, specIndex2);

        % GPS e mapeamento da leitura dos dados de espectro:
        if idx == 1
            gpsData = Read_GPSInfo(gpsData, specBlockArray);
        end
        
    end

    % GPS
    if ~isempty(gpsData.Matrix)
        gpsData.Status  = 1;
    end
    gpsData = fcn.gpsSummary({gpsData});

    for jj = 1:numel(specData)
        specData(jj).Receiver = Receiver;
        specData(jj).GPS      = rmfield(gpsData, 'Matrix');

        nSweeps = height(specData(jj).FileMap);
        [BeginTime, EndTime, RevisitTime] = Read_ObservationTime(specData(jj), rawData, nSweeps);
        specData(jj).RelatedFiles(1,:) = {[file ext], 'Undefined', ThreadID, 'Undefined', BeginTime, EndTime, nSweeps, RevisitTime, {gpsData}, char(matlab.lang.internal.uuid())};
    end
end


%-------------------------------------------------------------------------%
function [specData, idx] = checkNewBlock(specData, metaDataInfo, specIndex1, specIndex2)

    if isempty(specData)
        idx = 1;
    else
        idx = find(arrayfun(@(x) isequal(metaDataInfo, x), [specData.MetaData]), 1);
        if isempty(idx)
            idx = numel(specData)+1;
        end
    end

    if idx > numel(specData)
        specData(idx).MetaData = metaDataInfo;
        specData(idx).FileMap  = table('Size',          [0, 2],               ...
                                       'VariableTypes', {'double', 'double'}, ...
                                       'VariableNames', {'StartByte', 'StopByte'});
    end

    specData(idx).FileMap(end+1,:) = {specIndex1, specIndex2};
end


%-------------------------------------------------------------------------%
function specData = Fcn_SpecDataReader(specData, rawData)
    
    for ii = 1:numel(specData)
        if specData(ii).Enable
            PreAllocationData(specData(ii))
            nSweeps  = specData(ii).RelatedFiles.nSweeps;
            
            for jj = 1:nSweeps
                specIndex1     = specData(ii).FileMap.StartByte(jj);
                specIndex2     = specData(ii).FileMap.StopByte(jj);
                specBlockArray = rawData(specIndex1:specIndex2);
            
                specData(ii).Data{1}(jj)   = Read_TimeStamp(specBlockArray);
                specData(ii).Data{2}(:,jj) = (typecast(specBlockArray(25:end), 'single'))';
            end
        end
    
        specData(ii).FileMap = [];
    end
end


%-------------------------------------------------------------------------%
function TimeStamp = Read_TimeStamp(specBlockArray)

    Date_Year     = double(specBlockArray(1)) + 2000;
    Date_Month    = double(specBlockArray(2));
    Date_Day      = double(specBlockArray(3));
    Time_Hours    = double(specBlockArray(4));
    Time_Minutes  = double(specBlockArray(5));
    Time_Seconds  = double(specBlockArray(6));
    Time_milliSec = double(typecast(specBlockArray(7:8), 'uint16'));
   
    TimeStamp     = datetime([Date_Year, Date_Month, Date_Day, Time_Hours, Time_Minutes, (Time_Seconds+Time_milliSec/1000)]);
end


%-------------------------------------------------------------------------%
function gpsData = Read_GPSInfo(gpsData, specBlockArray)

    lat  = typecast(specBlockArray( 9:16), 'double');
    long = typecast(specBlockArray(17:24), 'double');

    if (lat ~= -200) && (long ~= -200)
        gpsData.Matrix(end+1,:) = [lat, long];
    end    
end


%-------------------------------------------------------------------------%
function [BeginTime, EndTime, RevisitTime] = Read_ObservationTime(specData, rawData, nSweeps)

    BeginTime = Read_TimeStamp(rawData(specData.FileMap.StartByte(1)  :specData.FileMap.StopByte(1)));
    EndTime   = Read_TimeStamp(rawData(specData.FileMap.StartByte(end):specData.FileMap.StopByte(end)));

    BeginTime.Format = 'dd/MM/yyyy HH:mm:ss';
    EndTime.Format   = 'dd/MM/yyyy HH:mm:ss';

    RevisitTime      = seconds(EndTime-BeginTime)/(nSweeps-1);    
end


%-------------------------------------------------------------------------%
function [startIndex, stopIndex] = findIndexArrays(rawData)
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