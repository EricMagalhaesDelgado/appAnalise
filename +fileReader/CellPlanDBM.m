function specData = CellPlanDBM(fileName, ReadType, metaData, RootFolder)

    % Author.: Eric Magalhães Delgado
    % Date...: November 12, 2023
    % Version: 1.01

    arguments
        fileName   char
        ReadType   char   = 'SingleFile'
        metaData   struct = []
        RootFolder char   = ''
    end
    
    fileID1 = fopen(fileName);
    if fileID1 == -1
        error('File not found.');
    end
    fclose(fileID1);

    % Necessário ajustar "RootFolder", caso se trate de uma aplicação
    % standalone.
    if isdeployed
        RootFolder = fullfile(ctfroot, class.Constants.appName);
    end
    
    % Como a estrutura do arquivo binário gerado pelo CellSpectrum não é
    % conhecida, mas a CellPlan disponibilizou uma API para extração de
    % alguns dos seus metadados, além da matriz de níveis, inicialmente, 
    % gera-se um arquivo temporário (no formato .bin), o qual possui uma
    % estrutura conhecida.
    [~, tempFile] = fileparts(fileName);
    tempFile = fullfile(RootFolder, 'Temp', sprintf('~%s.bin', tempFile));    

    pathToMFILE = fileparts(mfilename('fullpath'));
    cd(fullfile(pathToMFILE, 'CellPlanDBM'))
    system(sprintf('CellPlan_dBmReader.exe "%s" "%s"', fileName, tempFile));
    cd(RootFolder)
    pause(.100)

    fileID2 = fopen(tempFile);
    if fileID2 == -1
        error('Tempfile not found.');
    end

    rawData = fread(fileID2, [1, inf], 'uint8=>uint8');
    fclose(fileID2);    
    
  % fileFormat = char(rawData(2:rawData(1)+1));                             % 'CellSpec dll v. 1000'
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
    specData = class.specData.empty;
    gpsData  = struct('Status', 0, 'Matrix', []);

    nSweeps    = double(typecast(rawData(1:4), 'int32'));
    FreqCenter = typecast(rawData(17:24), 'double');
    Span       = typecast(rawData(33:40), 'double')*1e+6;

    specData(1).MetaData.DataType = 1000;
    specData.MetaData.FreqStart   = FreqCenter - Span/2;
    specData.MetaData.FreqStop    = FreqCenter + Span/2;
    specData.MetaData.LevelUnit   = 'dBm';
    specData.MetaData.DataPoints  = double(typecast(rawData( 5: 8), 'int32'));
    specData.MetaData.Resolution  = typecast(rawData(41:48), 'double')*1e+3;
    specData.MetaData.Detector    = 'Sample';

    % INFORMAÇÕES EXTRAÍDAS DO NOME DO ARQUIVO
    % 'CWSM21100020_E1_A1_Spec Frq=98.000 Span=20.000 RBW=10.000 [2022-09-25,22-51-30-090-8012].dbm'
    % 'CWSM21100020_E2_A2_Peak Frq=98.000 Span=20.000 RBW=20.000 [2022-09-25,22-51-29-089-2962].dBm'
    % 'CWSM21100020_E2_A3_Mean Frq=98.000 Span=20.000 RBW=20.000 [2022-09-25,22-51-34-097-8392].dBm'
    [~, file, ext] = fileparts(fileName);
    fileNameToken  = regexpi(file, '(?<Receiver>CWSM2\d{6,7})_E(?<Scan>\d*)_A(?<Operation>\d*)_(?<TraceMode>\w*).*', 'names');

    if isempty(fileNameToken)
        specData.Receiver           = 'CWSM2110000';
        specData.MetaData.TraceMode = 'ClearWrite';

        ID = 1;

    else
        specData.Receiver           = fileNameToken.Receiver;
        switch fileNameToken.TraceMode
            case 'Spec'; specData.MetaData.TraceMode = 'ClearWrite';
            case 'Peak'; specData.MetaData.TraceMode = 'MaxHold';
            case 'Mean'; specData.MetaData.TraceMode = 'Average';
        end

        ID = str2double([fileNameToken.Scan, fileNameToken.Operation]);
    end

    % INFORMAÇÕES EXTRAÍDAS DOS BLOCOS DE ESPECTRO DO ARQUIVO
    specData.FileMap = table('Size', [nSweeps, 2],                  ...
                             'VariableTypes', {'double', 'double'}, ...
                             'VariableNames', {'StartByte', 'StopByte'});            

    BlockSize = 24+4*specData.MetaData.DataPoints;
    for ii = 1:nSweeps
        ind1 = BlockSize*(ii-1)+81;
        ind2 = ind1+BlockSize-1;
        
        gpsData = Read_GPSInfo(gpsData, rawData(ind1:ind2));
        specData.FileMap(ii,:) = {ind1, ind2};
    end

    % GPS
    if ~isempty(gpsData.Matrix)
        gpsData.Status  = 1;
    end
    gpsData = fcn.gpsSummary({gpsData});
    specData.GPS = rmfield(gpsData, 'Matrix');

    [BeginTime, EndTime, RevisitTime] = Read_ObservationTime(specData, rawData, nSweeps);
    specData.RelatedFiles(1,:) = {[file ext], 'Undefined', ID, 'Undefined', BeginTime, EndTime, nSweeps, RevisitTime, {gpsData}, char(matlab.lang.internal.uuid())};
end


%-------------------------------------------------------------------------%
function specData = Fcn_SpecDataReader(specData, rawData)

    if specData.Enable
        specData = PreAllocationData(specData);
        nSweeps  = specData.RelatedFiles.nSweeps;
        
        for ii = 1:nSweeps
            rawArray = rawData(specData.FileMap.StartByte(ii):specData.FileMap.StopByte(ii));
        
            specData.Data{1}(ii)   = Read_TimeStamp(rawArray);
            specData.Data{2}(:,ii) = (typecast(rawArray(25:end), 'single'))';
        end
    end

    specData.FileMap = [];
end


%-------------------------------------------------------------------------%
function TimeStamp = Read_TimeStamp(rawArray)

    Date_Year     = double(rawArray(1)) + 2000;
    Date_Month    = double(rawArray(2));
    Date_Day      = double(rawArray(3));
    Time_Hours    = double(rawArray(4));
    Time_Minutes  = double(rawArray(5));
    Time_Seconds  = double(rawArray(6));
    Time_milliSec = double(typecast(rawArray(7:8), 'uint16'));
   
    TimeStamp     = datetime([Date_Year, Date_Month, Date_Day, Time_Hours, Time_Minutes, (Time_Seconds+Time_milliSec/1000)]);
end


%-------------------------------------------------------------------------%
function gpsData = Read_GPSInfo(gpsData, rawArray)

    lat  = typecast(rawArray( 9:16), 'double');
    long = typecast(rawArray(17:24), 'double');

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