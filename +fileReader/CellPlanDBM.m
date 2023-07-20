function specData = CellPlanDBM(filename, ReadType, metaData, RootFolder)

    arguments
        filename char
        ReadType char   = 'SingleFile'
        metaData struct = []
        RootFolder char = ''
    end

    global SpecInfo

    pathToMFILE = fileparts(mfilename('fullpath'));
    
    % DBM FILE
    fileID1 = fopen(filename);
    if fileID1 == -1
        error('File not found.');
    end
    fclose(fileID1);

    % BIN TEMPFILE
    [~, tempFile] = fileparts(filename);
    tempFile = fullfile(RootFolder, 'Temp', sprintf('~%s.bin', tempFile));    

    if isdeployed; RootFolder = fullfile(ctfroot, 'appAnalise');
    end
    cd(fullfile(pathToMFILE, 'CellPlanDBM'))
    system(sprintf('CellPlan_dBmReader.exe "%s" "%s"', filename, tempFile));
    cd(RootFolder)    
    drawnow

    fileID2 = fopen(tempFile);
    if fileID2 == -1
        error('Tempfile not found.');
    end

    rawData = fread(fileID2, [1, inf], 'uint8=>uint8');
    fclose(fileID2);    
    
    FileFormat = char(rawData(2:rawData(1)+1));
    rawData(1:rawData(1)+1) = [];    
    
    switch ReadType
        case {'MetaData', 'SingleFile'}
            SpecInfo = struct('Node',         '', 'ThreadID',   '', 'MetaData',   [], 'ObservationTime', '', 'Samples',     [], ...
                              'Data',         {}, 'statsData',  [], 'FileFormat', '', 'TaskName',        '', 'Description', '', ...
                              'RelatedFiles', {}, 'RelatedGPS', {}, 'gps',        [], 'Blocks',          []);

            Fcn_MetaDataReader(filename, rawData, FileFormat);

            if strcmp(ReadType, 'SingleFile')
                Fcn_SpecDataReader(rawData)
            end
            
        case 'SpecData'
            SpecInfo = metaData(1).Data;
            Fcn_SpecDataReader(rawData);
    end
    
    specData = SpecInfo;
    clear global SpecInfo
    
    try
        delete(tempFile)
    catch
    end

end


function Fcn_MetaDataReader(filename, rawData, FileFormat)

    global SpecInfo
    global GPS

    GPS = struct('Status', 0, 'Latitude', -1, 'Longitude', -1, 'Count', 0, 'Location', '', 'Matrix', []);
    
    SpecInfo(1).ThreadID = 1;
    SpecInfo.MetaData    = struct('DataType',   [], 'ThreadID',    1, 'FreqStart',  [], 'FreqStop',   [], ...
                                  'LevelUnit',  [], 'DataPoints', [], 'Resolution', [], 'SampleTime', [], ...
                                  'Threshold',  [], 'TraceMode',  [], 'Detector',   [], 'metaString', []);

    switch FileFormat
        case 'CellSpec dll v. 1000'
            % INFORMAÇÕES EXTRAÍDAS DOS METADADOS DO ARQUIVO
            SpecInfo.Samples      = double(typecast(rawData(1:4), 'int32'));
            SpecInfo.FileFormat   = FileFormat;
            SpecInfo.TaskName     = 'Undefined';
            SpecInfo.Description  = 'Undefined';
                        
            Center = typecast(rawData(17:24), 'double');
            Span   = typecast(rawData(33:40), 'double')*1e+6;

            SpecInfo.MetaData.DataType   = 1000;
            SpecInfo.MetaData.FreqStart  = Center - Span/2;
            SpecInfo.MetaData.FreqStop   = Center + Span/2;
            SpecInfo.MetaData.LevelUnit  = 1;
            SpecInfo.MetaData.DataPoints = double(typecast(rawData( 5: 8), 'int32'));
            SpecInfo.MetaData.Resolution = typecast(rawData(41:48), 'double')*1e+3;
            SpecInfo.MetaData.SampleTime = [];
            SpecInfo.MetaData.Threshold  = [];
            SpecInfo.MetaData.Detector   = 1;


            % INFORMAÇÕES EXTRAÍDAS DO NOME DO ARQUIVO
            % 'CWSM21100020_E1_A1_Spec Frq=98.000 Span=20.000 RBW=10.000 [2022-09-25,22-51-30-090-8012].dbm'
            % 'CWSM21100020_E2_A2_Peak Frq=98.000 Span=20.000 RBW=20.000 [2022-09-25,22-51-29-089-2962].dBm'
            % 'CWSM21100020_E2_A3_Mean Frq=98.000 Span=20.000 RBW=20.000 [2022-09-25,22-51-34-097-8392].dBm'
            [~, file, ext] = fileparts(filename);
            filenameToken  = regexpi(file, '(?<Node>CWSM2\d{6,7})_E(?<Scan>\d*)_A(?<Operation>\d*)_(?<TraceMode>\w*).*', 'names');

            if isempty(filenameToken)
                SpecInfo.Node = 'CWSM2110000';

                SpecInfo.MetaData.ThreadID  = 1;
                SpecInfo.MetaData.TraceMode = 1; traceMode = 'ClearWrite';

            else
                SpecInfo.Node = filenameToken.Node;
                
                SpecInfo.ThreadID = str2double([filenameToken.Scan, filenameToken.Operation]);
                SpecInfo.MetaData.ThreadID = SpecInfo.ThreadID;

                switch filenameToken.TraceMode
                    case 'Spec'; SpecInfo.MetaData.TraceMode = 1; traceMode = 'ClearWrite';
                    case 'Peak'; SpecInfo.MetaData.TraceMode = 2; traceMode = 'MaxHold';
                    case 'Mean'; SpecInfo.MetaData.TraceMode = 3; traceMode = 'Average';
                end
            end
            SpecInfo.MetaData.metaString = {'dBm', sprintf('%.3f kHz', SpecInfo.MetaData.Resolution/1000), traceMode, 'Sample', 'Undefined'};


            % INFORMAÇÕES EXTRAÍDAS DOS BLOCOS DE ESPECTRO DO ARQUIVO
            SpecInfo.Blocks = table('Size', [SpecInfo.Samples, 2],         ...
                                    'VariableTypes', {'double', 'double'}, ...
                                    'VariableNames', {'StartByte', 'StopByte'});            

            BlockSize = 24+4*SpecInfo.MetaData.DataPoints;
            for ii = 1:SpecInfo.Samples
                ind1 = BlockSize*(ii-1)+81;
                ind2 = ind1+BlockSize-1;
                
                Read_GPSInfo(rawData(ind1:ind2));
                SpecInfo.Blocks(ii,:) = {ind1, ind2};
            end

            % GPS
            if ~isempty(GPS.Matrix)
                GPS.Status    = 1;
                GPS.Count     = height(GPS.Matrix);
                GPS.Latitude  = mean(GPS.Matrix(:,1));
                GPS.Longitude = mean(GPS.Matrix(:,2));          
                
                GPS.Location  = geo_FindCity(GPS);
            end
            SpecInfo.gps        = rmfield(GPS, {'Count', 'Matrix'});
            SpecInfo.RelatedGPS = {GPS};

            [ObservationTime, RevisitTime, StartTime, StopTime] = Read_ObservationTime(rawData);
            SpecInfo.ObservationTime = ObservationTime;
            SpecInfo.RelatedFiles    = table({[file ext]}, StartTime, StopTime, SpecInfo.Samples, RevisitTime, ...
                                             'VariableNames', {'Name', 'BeginTime', 'EndTime', 'Samples', 'RevisitTime'});

        otherwise
            % DEPENDE DE EVOLUÇÕES PELA CELLPLAN DA SUA LIB
    end

end


function Fcn_SpecDataReader(rawData)

    global SpecInfo

    SpecInfo.Data  = {repmat(datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss'), 1, SpecInfo.Samples), ...
                      zeros(SpecInfo.MetaData.DataPoints, SpecInfo.Samples, 'single')};
    
    for ii = 1:SpecInfo.Samples
        Read_SpecData(ii, rawData)
    end

end


function TimeStamp = Read_TimeStamp(rawArray)

    Date_Year     = double(rawArray(1)) + 2000;
    Date_Month    = double(rawArray(2));
    Date_Day      = double(rawArray(3));
    Time_Hours    = double(rawArray(4));
    Time_Minutes  = double(rawArray(5));
    Time_Seconds  = double(rawArray(6));
    Time_milliSec = double(typecast(rawArray(7:8), 'uint16'));
   
    TimeStamp    = datetime([Date_Year, Date_Month, Date_Day, Time_Hours, Time_Minutes, (Time_Seconds+Time_milliSec/1000)]);

end


function Read_GPSInfo(rawArray)

    global GPS

    lat  = typecast(rawArray( 9:16), 'double');
    long = typecast(rawArray(17:24), 'double');

    if (lat ~= -200) & (long ~= -200)
        GPS.Matrix(end+1,:) = [lat, long];
    end
    
end


function Read_SpecData(ii, rawData)

    global SpecInfo

    rawArray = rawData(SpecInfo.Blocks.StartByte(ii):SpecInfo.Blocks.StopByte(ii));

    SpecInfo.Data{1}(ii)   = Read_TimeStamp(rawArray);
    SpecInfo.Data{2}(:,ii) = (typecast(rawArray(25:end), 'single'))';
    

end


function [ObservationTime, RevisitTime, StartTime, StopTime] = Read_ObservationTime(rawData)

    global SpecInfo

    StartTime = Read_TimeStamp(rawData(SpecInfo.Blocks.StartByte(1)  :SpecInfo.Blocks.StopByte(1)));
    StopTime  = Read_TimeStamp(rawData(SpecInfo.Blocks.StartByte(end):SpecInfo.Blocks.StopByte(end)));

    StartTime.Format = 'dd/MM/yyyy HH:mm:ss';
    StopTime.Format  = 'dd/MM/yyyy HH:mm:ss';

    ObservationTime = sprintf('%s - %s', datestr(StartTime, 'dd/mm/yyyy HH:MM:SS'), datestr(StopTime, 'dd/mm/yyyy HH:MM:SS'));
    RevisitTime     = seconds(StopTime-StartTime)/(SpecInfo.Samples-1);
    
end