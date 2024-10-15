function specData = ArgusCSV(fileName, ReadType, metaData)

    % Author.: Eric Magalhães Delgado
    % Date...: November 09, 2023
    % Version: 2.00

    arguments
        fileName char
        ReadType char   = 'SingleFile'
        metaData struct = []
    end
    
    switch ReadType
        case {'MetaData', 'SingleFile'}
            specData = Fcn_MetaDataReader(fileName);
            
            if strcmp(ReadType, 'SingleFile')
                specData = Fcn_SpecDataReader(specData);
            end
            
        case 'SpecData'
            specData = copy(metaData(1).Data, {});
            specData = Fcn_SpecDataReader(specData);
    end
end


%-------------------------------------------------------------------------%
function specData = Fcn_MetaDataReader(fileName)

    [~, file, ext] = fileparts(fileName);

    % Criação das variáveis principais (specData e gpsData)
    specData = class.specData.empty;
    gpsData  = struct('Status', 0, 'Matrix', []);

    % O Argus gera arquivos com estruturas diferentes - um deles, um arquivo
    % sem compressão, é do tipo 'Measurement Result' e possui apenas quatro
    % colunas intituladas "Time", "Frequency (Hz)", "Level (dBm)" e "File Info".
    %
    % Já o arquivo comprimido, do tipo 'Compressed Measurement Result', possui 
    % oito colunas intituladas "Time", "Frequency (Hz)", "Level (dBm)", 
    % "Level_1 (dBm)", "Level_2 (dBm)", "Level_3 (dBm)", "Value Count" e 
    % "File Info".
    [fileFormat, LevelUnit] = text2metadata(fileName);

    rawTable    = csv2table(fileName, fileFormat);

    % Metadados extraídos da coluna "Frequency (Hz)".
    xArray      = unique(rawTable.Frequency);

    DataPoints  = numel(xArray);
    FreqStart   = xArray(1);
    FreqStop    = xArray(end);

    % Índices das linhas da tabela temporária...
    initialSweepIndex = strfind(rawTable.Frequency', xArray');
    if isempty(initialSweepIndex)
        return
    end
    nSweeps     = numel(initialSweepIndex);

    % Metadados extraídos da coluna "Time".
    [BeginTime, InputFormat] = str2datetime(rawTable.Time{initialSweepIndex(1)});
    EndTime     = str2datetime(rawTable.Time{initialSweepIndex(end)});
    RevisitTime = seconds(EndTime-BeginTime)/(nSweeps-1);

    BeginTime.Format = 'dd/MM/yyyy HH:mm:ss';
    EndTime.Format   = 'dd/MM/yyyy HH:mm:ss';

    specData(1).MetaData.FreqStart = FreqStart;
    specData.MetaData.FreqStop     = FreqStop;
    specData.MetaData.DataPoints   = DataPoints;
    specData.MetaData.Detector     = 'Sample';
    specData.MetaData.LevelUnit    = LevelUnit;
    specData.RelatedFiles(1,:)     = {[file ext], '-', 1, DefaultDescription(1, FreqStart, FreqStop), BeginTime, EndTime, nSweeps, RevisitTime, [], char(matlab.lang.internal.uuid())};

    switch fileFormat
        case 'Measurement Result'
            specData.MetaData.DataType  = 167;
            specData.MetaData.TraceMode = 'ClearWrite';
        case 'Compressed Measurement Result'
            specData.MetaData.DataType  = 168;
            specData.MetaData.TraceMode = 'Average';
    end

    if ismember('Integration', rawTable.Properties.VariableNames)
        specData.MetaData.TraceIntegration = median(rawTable.Integration);
    end    

    % Metadados extraídos da coluna "FileInfo"
    fileHeader = rawTable.FileInfo(cellfun(@(x) ~isempty(x), rawTable.FileInfo));

    ii = 1;
    while ii <= numel(fileHeader)
        fieldName  = strtrim(extractBefore(fileHeader{ii}, ':'));
        fieldValue = strtrim(extractAfter( fileHeader{ii}, ':'));

        %-----------------------------------------------------------------%
        if ~isempty(fieldValue)
            switch fieldName
                case 'Meas. Unit'
                    specData.Receiver = fieldValue;
    
                case 'Longitude'
                    if ~exist('longDegree', 'var')
                        longDMS    = regexp(fieldValue, '\d+(\.\d+)?', 'match');
                        longDegree = (str2double(longDMS{1}) + str2double(longDMS{2})/60 + str2double(longDMS{3})/3600);
                        if contains(fieldValue, 'W')
                            longDegree = -longDegree;
                        end               
                    end
    
                case 'Latitude'
                    if ~exist('latDegree', 'var')
                        latDMS    = regexp(fieldValue, '\d+(\.\d*)?', 'match');
                        latDegree = (str2double(latDMS{1}) + str2double(latDMS{2})/60 + str2double(latDMS{3})/3600);
                        if contains(fieldValue, 'S')
                            latDegree = -latDegree;
                        end  
                    end
    
                case 'IF Bandwidth'
                    res = regexp(fieldValue, '\d+(\.\d*)?', 'match');
                    specData.MetaData.Resolution = str2double(res{1}) * 1000;
            end

        %-----------------------------------------------------------------%
        else
            if ismember(fieldName, {'Measurement Definition', 'Range Definition', 'Device 1'})
                switch fieldName
                    case {'Measurement Definition', 'Range Definition'}
                        subFieldNameList = {'Name', 'Date', 'Time'};

                    case 'Device 1'
                        subFieldNameList = {'Name', 'Azimuth', 'Elevation', 'Height'};
                end

                while true
                    ii = ii+1;
    
                    subFieldName  = strtrim(extractBefore(fileHeader{ii}, ':'));
                    subFieldValue = strtrim(extractAfter( fileHeader{ii}, ':'));
    
                    if ismember(subFieldName, subFieldNameList) && ~isempty(subFieldValue)
                        switch fieldName
                            case 'Measurement Definition'
                                if strcmp(subFieldName, 'Name')
                                    specData.RelatedFiles.Task{1} = subFieldValue;
                                end
    
                            case 'Range Definition'
                                if strcmp(subFieldName, 'Name')
                                    if ~isnan(str2double(subFieldValue))
                                        specData.RelatedFiles.ID(1)          = str2double(subFieldValue);
                                        specData.RelatedFiles.Description{1} = DefaultDescription(specData.RelatedFiles.ID(1), specData.MetaData.FreqStart, specData.MetaData.FreqStop);
                                    else
                                        specData.RelatedFiles.Description{1} = subFieldValue;
                                    end
                                end

                            case 'Device 1'
                                specData.MetaData.Antenna.(subFieldName) = subFieldValue;
                        end
                    else
                        ii = ii-1;
                        break
                    end
                end
            end
        end
        ii = ii+1;
    end

    % Informações relacionadas às coordenadas geográficas do local onde
    % ocorreu a monitoração.    
    if exist('latDegree', 'var') && exist('longDegree', 'var')
        gpsData  = struct('Status', 1, 'Matrix', [latDegree longDegree]);
    end
    gpsData = fcn.gpsSummary({gpsData});

    specData.GPS = rmfield(gpsData, 'Matrix');
    specData.RelatedFiles.GPS = {gpsData};

    % Identifica índices da tabela cujos valores não estão relacionadas ao
    % vetor xArray, apagando-os. E depois salva a informação que será útil
    % na leitura dos dados de espectro (de certa forma já lida, mas não
    % mapeada na propriedade "Data").
    if nSweeps*DataPoints ~= height(rawTable)
        tableIndex = zeros(height(rawTable), 1, 'logical');

        for kk = initialSweepIndex
            tableIndex(kk:kk+DataPoints-1) = true;
        end
        rawTable(~tableIndex,:) = [];
    end

    specData.FileMap = struct('rawTable',    rawTable, ...
                              'InputFormat', InputFormat);
end


%-------------------------------------------------------------------------%
function specData = Fcn_SpecDataReader(specData)
    if specData.Enable
        rawTable    = specData.FileMap.rawTable;
        InputFormat = specData.FileMap.InputFormat;
    
        DataPoints  = specData.MetaData.DataPoints;
        idxSweeps   = 1:DataPoints:height(rawTable);
        nSweeps     = specData.RelatedFiles.nSweeps(1);    
    
        % E, por fim, preenche o vetor de timestamp e a matriz de níveis...
        PreAllocationData(specData)
    
        specData.Data{1}(:)   = datetime(DateTimePreProcess(rawTable.Time(idxSweeps)), 'InputFormat', InputFormat)';
        specData.Data{2}(:,:) = reshape(rawTable{:,3}, [DataPoints, nSweeps]);
    end

    specData.FileMap      = [];
end


%-------------------------------------------------------------------------%
function [fileFormat, LevelUnit] = text2metadata(fileName)
    % Colunas comuns a ambos os tipos de arquivo: "Time", "Frequency (Hz)" 
    % e "File Info". Alguns metadados (apresentados na última coluna da tabela)
    % possuem "Time" como subcampo, o que pode inviabilizar a leitura correta
    % da informação. Por isso, restringe-se apenas à busca pelas colunas 
    % "Frequency (Hz)" e "File Info".

    % Lembrando que apenas o arquivo do tipo 'Compressed Measurement Result' 
    % possui coluna intitulada "Value Count". E que a unidade de médida consta
    % apenas nos títulos das colunas - "Level (dBm)", "Level_1 (dBm)", "Level_2 (dBm)" 
    % e "Level_3 (dBm)", por exemplo.
    fileID = fopen(fileName, 'rt');

    while true
        lineContent = fgetl(fileID);

        % O método fgetl retorna -1 (numérico) quando chega ao final do 
        % arquivo...
        if isequal(lineContent, -1)
            break
        end

        if contains(lineContent, 'Frequency (Hz)') && contains(lineContent, 'File Info')
            if contains(lineContent, 'Value Count'); fileFormat = 'Compressed Measurement Result';
            else;                                    fileFormat = 'Measurement Result';
            end
            
            if contains(lineContent, 'dBm');         LevelUnit = 'dBm';
            else;                                    LevelUnit = 'dBµV/m';
            end

            break
        end
    end
    fclose(fileID);

    if ~exist('fileFormat', 'var') || ~exist('LevelUnit', 'var')
        error('fileReader:ArgusCSV', 'Unsupported file format')
    end    
end


%-------------------------------------------------------------------------%
function rawTable = csv2table(fileName, fileFormat)
    % Para que não seja necessária a leitura do cabeçalho do arquivo, busca-se 
    % a leitura do arquivo como tabela. Para tanto, considera-se, inicialmente, 
    % que o arquivo seria do tipo "Compressed Measurement Result".
    switch fileFormat
        case 'Compressed Measurement Result'
            opts = delimitedTextImportOptions(NumVariables       = 8,          ...
                                              DataLines          = [2, Inf],   ...
                                              ExtraColumnsRule   = "ignore",   ...
                                              VariableNamingRule = "preserve", ...
                                              MissingRule        = "omitrow",  ...
                                              VariableNames      = ["Time", "Frequency", "Level", "stdLevel", "minLevel", "maxLevel", "Integration", "FileInfo"], ...
                                              VariableTypes      = ["char", "double", "single", "single", "single", "single", "single", "char"]);
        
            opts = setvaropts(opts, [1,8], "WhitespaceRule", "preserve");
            opts = setvaropts(opts, [1,8], "EmptyFieldRule", "auto");
            opts = setvaropts(opts, 2:7,   "TrimNonNumeric", true);
            opts = setvaropts(opts, 2:7,   "DecimalSeparator", ",");

        case 'Measurement Result'
            opts = delimitedTextImportOptions(NumVariables       = 4,          ...
                                              DataLines          = [2, Inf],   ...
                                              ExtraColumnsRule   = "ignore",   ...
                                              VariableNamingRule = "preserve", ...
                                              MissingRule        = "omitrow",  ...
                                              VariableNames      = ["Time", "Frequency", "Level", "FileInfo"], ...
                                              VariableTypes      = ["char", "double", "single", "char"]);
        
            opts = setvaropts(opts, [1,4], "WhitespaceRule", "preserve");
            opts = setvaropts(opts, [1,4], "EmptyFieldRule", "auto");
            opts = setvaropts(opts, 2:3,   "TrimNonNumeric", true);
            opts = setvaropts(opts, 2:3,   "DecimalSeparator", ",");
    end

    rawTable = readtable(fileName, opts);

    if ismember('Integration', rawTable.Properties.VariableNames)
        rawTable(rawTable.Integration == 0, :) = [];
    end
end


%-------------------------------------------------------------------------%
function [TimeStamp, InputFormat] = str2datetime(sTimeStamp)
    % Ao que parece, o Argus usa o formato definido no sistema operacional
    % (Windows) de hora/data no arquivo CSV. Como são múltiplos formatos,
    % foi prevista a decodificação dos principais (os mais comuns nas línguas 
    % portuguesa e inglesa).
     
    datetimeFormats      = table('Size', [0,2],                     ...
                                 'VariableTypes', {'cell', 'cell'}, ...
                                 'VariableNames', {'Format', 'Expression'});

    datetimeFormats(1,:) = {'yyyy.MM.dd  HH:mm:ss.SSS', '^\d{4}[.]\d{1,2}[.]\d{1,2}\s+\d{1,2}:\d{2}:\d{2}[.]\d{3}$'};
    datetimeFormats(2,:) = {'dd.MM.yyyy  HH:mm:ss.SSS', '^\d{1,2}[.]\d{1,2}[.]\d{4}\s+\d{1,2}:\d{2}:\d{2}[.]\d{3}$'};

    sTimeStamp = DateTimePreProcess(sTimeStamp);
    for ii = 1:height(datetimeFormats)
        tempTime = regexp(sTimeStamp, datetimeFormats.Expression{ii}, 'match');

        if ~isempty(tempTime)
            InputFormat = datetimeFormats.Format{ii};
            TimeStamp   = datetime(sTimeStamp, 'InputFormat', InputFormat);
            break
        end
    end

    if ~exist('TimeStamp', 'var')
        error('fileReader:ArgusCSV', 'Unsupported date/time format')
    end
end


%-------------------------------------------------------------------------%
function sTimeStamp = DateTimePreProcess(sTimeStamp)
    sTimeStamp = replace(sTimeStamp, {',', '/', '-'}, '.');
end


%-------------------------------------------------------------------------%
function Description = DefaultDescription(ID, FreqStart, FreqStop)
    Description = sprintf('ID %.0f: %.3f - %.3f MHz', ID, FreqStart/1e+6, FreqStop/1e+6);
end