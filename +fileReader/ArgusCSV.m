function specData = ArgusCSV(filename, ReadType, metaData)
%% ARGUSCSV Leitor de arquivo do Argus.
% Trata-se de leitor dos principais tipos de dados gerados originalmente pela 
% aplicação Argus
% 
% Versão: *10/06/2021*
    arguments
        filename char
        ReadType char   = 'SingleFile'
        metaData struct = []
    end
    
    global SpecInfo
    
    fileID = fopen(filename, 'rt');
    if fileID == -1
        error('Arquivo não encontrado!');
    end
    
    switch ReadType
        case {'MetaData', 'SingleFile'}
            SpecInfo = struct('Node',         '', 'ThreadID',   '', 'MetaData',   [], 'ObservationTime', '', 'Samples',   [],    ...
                              'Data',         {}, 'statsData',  [], 'FileFormat', '', 'TaskName',        '', 'Description', '',  ...
                              'RelatedFiles', {}, 'RelatedGPS', {}, 'gps',        [], 'Blocks',          []);
            
            Fcn_MetaDataReader(fileID, filename);
            
            if strcmp(ReadType, 'SingleFile')
                Fcn_SpecDataReader(filename)
            end
            
        case 'SpecData'
            SpecInfo = metaData(1).Data;
            
            Fcn_SpecDataReader(filename);
    end
    fclose(fileID);
    
    specData = SpecInfo;
    clear global SpecInfo
    
end    
%% 
% Leitura de *metadados*.
function Fcn_MetaDataReader(fileID, filename)
    global SpecInfo
    
    SpecInfo(1).ThreadID = 1;
    SpecInfo.MetaData = struct('DataType',   [], 'ThreadID',    1, 'FreqStart',  [], 'FreqStop',   [], ...
                               'LevelUnit',  [], 'DataPoints', [], 'Resolution', [], 'SampleTime', [], ...
                               'Threshold',  [], 'TraceMode',  [], 'Detector',   [], 'metaString', []);
    
    latDegree   = [];
    longDegree  = [];
    freqStep    = [];
    Resolution  = '';
    TraceMode   = '';
    Detector    = '';
    
    extractedLine = fgetl(fileID);
    if contains(extractedLine, 'dBm')
        SpecInfo.MetaData.LevelUnit = 1;
        Unit  = 'dBm';
    else
        SpecInfo.MetaData.LevelUnit = 3;
        Unit  = 'dBµV/m';
    end
    
    while true
        extractedLine = fgetl(fileID);
        
        if isempty(extractedLine)
            break
        end
        
        value = strsplit(extractedLine, '",');
        if isempty(value{end})
            break
        end
        str1 = char(extractBetween(value{end}, '"', ':'));
        str1 = replace(str1, ' ', '');
        
        str2 = extractAfter(value{end}, ': ');
        str2 = replace(str2, '"', '');
        
        switch str1
            case 'Meas.Unit'
                SpecInfo.Node = str2;
            case 'Longitude'
                if isempty(longDegree)
                    longDMS    = regexp(str2, '\d+(\.\d+)?', 'match');
                    longDegree = (str2double(longDMS{1}) + str2double(longDMS{2})/60 + str2double(longDMS{3})/3600);
                    if contains(str2, 'W')
                        longDegree = -longDegree;
                    end               
                end
            case 'Latitude'
                if isempty(latDegree)
                    latDMS    = regexp(str2, '\d+(\.\d*)?','match');
                    latDegree = (str2double(latDMS{1}) + str2double(latDMS{2})/60 + str2double(latDMS{3})/3600);
                    if contains(str2, 'S')
                        latDegree = -latDegree;
                    end  
                end
            case 'MeasurementResultType'
                SpecInfo.FileFormat = ['R&S Argus ' str2];
                if strcmp(SpecInfo.FileFormat, 'R&S Argus Measurement Result')
                    SpecInfo.MetaData.DataType = 167;
                    SpecInfo.MetaData.TraceMode = 0; 
                    TraceMode = 'ClearWrite';
                elseif strcmp(SpecInfo.FileFormat, 'R&S Argus Compressed Measurement Result')
                    SpecInfo.MetaData.DataType = 168;
                    SpecInfo.MetaData.TraceMode = 1;
                    TraceMode = 'Average';
                else
                    fclose(fileID);
                    error('Leitura de formato de arquivo ainda não implementada. Favor acionar Eric (GR08).');
                end
            case 'CompressTimeInterval'
%                 timeInt = str2;
%                 nTime = regexp(timeInt, '\d+(\.\d*)?', 'match');
%                 SpecInfo.MetaData.SampleTime = time2seconds(nTime{1});
            case 'MeasurementDefinition'
                extractedLine = fgetl(fileID);
                value = strsplit(extractedLine, '","');
                str2 = char(extractBetween(value{end}, ': ', '"'));
                SpecInfo.TaskName = str2;
            case 'RangeDefinition'
                extractedLine = fgetl(fileID);
                value = strsplit(extractedLine, '","');
                str2 = char(extractBetween(value{end}, ': ', '"'));
                
                if ~isnan(str2double(str2))
                    SpecInfo.ThreadID    = str2double(str2);
                    SpecInfo.Description = sprintf('ThreadID %.0f: %.3f - %.3f MHz', ...
                                                   SpecInfo.ThreadID, ...
                                                   SpecInfo.MetaData.FreqStart ./ 1e+6, ...
                                                   SpecInfo.MetaData.FreqStop  ./ 1e+6);
                else
                    SpecInfo.Description = str2;
                end                
            case 'MinimumFrequency'
                SpecInfo.MetaData.FreqStart = convert2hz(str2);
            case 'MaximumFrequency'
                SpecInfo.MetaData.FreqStop  = convert2hz(str2);             
            case 'StepWidth'
                freqStep = convert2hz(str2);
            case 'IFBandwidth'
                res = regexp(str2, '\d+(\.\d*)?', 'match');
                SpecInfo.MetaData.Resolution = str2double(res{1}) * 1000;
                Resolution = sprintf('%.3f kHz', SpecInfo.MetaData.Resolution/1000);
            case 'Detector'
                if strcmp(str2, 'Fast')
                    Detector = 'Sample';
                    SpecInfo.MetaData.Detector = 1;
                end
        end  
    end
    
    if isempty(SpecInfo.MetaData.FreqStart) | isempty(SpecInfo.MetaData.FreqStop) | isempty(freqStep)
        error('Algum metadado obrigatório não foi identificado.')
    end
    
    SpecInfo.MetaData.DataPoints = (SpecInfo.MetaData.FreqStop - SpecInfo.MetaData.FreqStart)/freqStep + 1;
    
    if SpecInfo.MetaData.FreqStart < 1e+9
        antennaName = 'Rohde & Schwarz ADD107';
    else
        antennaName = 'Rohde & Schwarz ADD207';
    end
    SpecInfo.MetaData.metaString = {Unit, Resolution, TraceMode, Detector, antennaName};
    
    if latDegree & longDegree
        GPS = struct('Latitude',  latDegree,  ...
                     'Longitude', longDegree);
        
        SpecInfo.gps = struct('Status', 1, 'Latitude', latDegree, 'Longitude', longDegree, 'Count', 1, 'Location', geo_FindCity(GPS), 'Matrix', [latDegree, longDegree]);
    else
        SpecInfo.gps = struct('Status', 0, 'Latitude', -1, 'Longitude', -1, 'Count', 0, 'Location', '', 'Matrix', []);
    end
    SpecInfo.RelatedGPS = {SpecInfo.gps};
    SpecInfo.gps        = rmfield(SpecInfo.gps, {'Count', 'Matrix'});
        
end
%% 
% Leitura de informações de *níveis apenas dos dados de blocos espectrais*.
function Fcn_SpecDataReader(filename)
    global SpecInfo
    global freqs
    inData = csvTable(filename);
    inData = table2cell(inData(:,1:3));
    
    % Eliminação de linhas que estejam faltando a informação de frequência ou nível.
    indexTrash = find(cellfun(@(x) ismissing(x), inData(:,2:3)));
    indexTrash(indexTrash > height(inData)) = indexTrash(indexTrash > height(inData)) - height(inData);
    indexTrash = unique(indexTrash);
    
    inData(indexTrash,:) = [];
    
    [freqs, ~, ifreqs] = unique(cell2mat(inData(:,2)), "stable");
    cfreqs             = accumarray(ifreqs, 1);
    
    if SpecInfo.MetaData.DataPoints ~= numel(freqs)
        SpecInfo.MetaData.DataPoints = numel(freqs);
    end
    
    % Eliminação de blocos de dados incompletos, caso existentes.
    indexF0 = find(ifreqs == 1);
    if min(cfreqs) ~= max(cfreqs)
        while true
            [~, ~, ifreqs] = unique(cell2mat(inData(:,2)), "stable");
            indexF0 = find(ifreqs == 1);
            indexF1 = find(ifreqs == SpecInfo.MetaData.DataPoints);
            
            auxIndexF0 = indexF0;
            auxIndexF1 = indexF1;
            
            value1 = numel(indexF1) - numel(indexF0);
            if     value1 > 0; auxIndexF1 = indexF1(1:end-value1);
            elseif value1 < 0; auxIndexF0 = indexF0(1:end+value1);
            end
            
            indexDiff = find(auxIndexF1-auxIndexF0 ~= (SpecInfo.MetaData.DataPoints-1), 1);
            if isempty(indexDiff)
                value1 = numel(indexF1) - numel(indexF0);
                if value1 == 0
                    break
                elseif value1 < 0
                    inData(indexF0(end):end,:) = [];
                    indexF0(end)               = [];
                elseif value1 > 0
                    inData(indexF1(end):end,:) = [];
                    indexF1(end)               = [];
                end
                
            else
                valueDiff = auxIndexF1(indexDiff)-auxIndexF0(indexDiff);
                if valueDiff > 0
                    if valueDiff < SpecInfo.MetaData.DataPoints-1
                        inData(indexF0(indexDiff):indexF1(indexDiff),:) = [];
                        
                        indexF0(indexDiff) = [];
                        indexF1(indexDiff) = [];
                        
                    else
                        downLim = indexF0(indexDiff);
                        upLim   = indexF0(indexDiff)+valueDiff;
                                            
                        if upLim >= height(inData) || indexDiff+1 > numel(indexF0)
                            inData(downLim:end,:) = [];
                        else
                            inData(downLim:indexF0(indexDiff+1)-1,:) = [];
                        end
                        indexF0(indexDiff) = [];
                    end
                    
                else
                    downLim = indexF1(indexDiff-1);
                    upLim   = indexF1(indexDiff);
                    
                    if (indexDiff-1) < 1; inData(1:upLim,:)         = [];
                    else;                 inData(downLim+1:upLim,:) = [];
                    end
                    indexF1(indexDiff) = [];
                end
            end
        end
    end
    SpecInfo.Samples = numel(indexF0);
    
    dataTime = inData(indexF0, 1);
    if contains(inData{1,1}, '-')
        dataFormat = 'yyyy-MM-dd  HH:mm:ss,SSS';
    elseif contains(inData{1,1}, '/')
        dataFormat = 'dd/MM/yyyy  HH:mm:ss,SSS';
    else
        error(['Formato de data/hora não compatível com àqueles já identificados que são gerados pelo ' ...
               'Argus - "yyyy-MM-dd  HH:mm:ss,SSS" e "dd/MM/yyyy  HH:mm:ss,SSS". Favor acionar Eric (GR08).']);
    end
    
    SpecInfo.Data{1} = datetime(dataTime', 'InputFormat', dataFormat, 'Format', 'dd/MM/yyyy HH:mm:ss');
    SpecInfo.Data{2} = single(reshape(cell2mat(inData(:,3)), [length(freqs), SpecInfo.Samples]));  
    StartTime = SpecInfo.Data{1}(1);
    StopTime  = SpecInfo.Data{1}(end);
    ObservationTime = sprintf('%s - %s', datestr(StartTime, 'dd/mm/yyyy HH:MM:SS'), datestr(StopTime, 'dd/mm/yyyy HH:MM:SS'));
    RevisitTime     = seconds(StopTime-StartTime)/(SpecInfo.Samples-1);
        
    SpecInfo.ObservationTime = ObservationTime;
    
    [~, file, ext] = fileparts(filename);
    SpecInfo.RelatedFiles = table({[file ext]}, StartTime, StopTime, SpecInfo.Samples, RevisitTime, ...
                                  'VariableNames', {'Name', 'BeginTime', 'EndTime', 'Samples', 'RevisitTime'});
    
%     if isempty(SpecInfo.MetaData.SampleTime)
%         SpecInfo.MetaData.SampleTime = mean(seconds(SpecInfo.Data{1}(2:end) - SpecInfo.Data{1}(1:end-1)));
%     end
    
end
%% 
% Funções auxiliares:
% 
% 1. Receives as input a string containing frequency and unit (e.g., "90.1 MHz") 
% and return the frequency in Hertz (i.e., 90,100,000) as a number.
function freq = convert2hz(f1)
    f1 = replace(f1, ',', '.');
    factor = 1;
    if contains(f1, 'THz');     factor = 1e+12;
    elseif contains(f1, 'GHz'); factor = 1e+9;
    elseif contains(f1, 'MHz'); factor = 1e+6;
    elseif contains(f1, 'kHz'); factor = 1e+3;
    end
    freq = str2double(regexp(f1,'\d+(\.\d*)?','match')) * factor;
    freq = freq(1);
    
end
%% 
% 2. Receives as input a string containing time and unit (e.g., "2 min") and 
% return the time in seconds (i.e., 120) as a number.
function time = time2seconds(t1)
   factor = 1;
   if contains(t1,'min');    factor = 60;
   elseif contains(t1,'ms'); factor = 0.001;
   elseif contains(t1,'h');  factor = 3600;
   end
   time = str2double(regexp(t1,'\d+(\.\d*)?','match'))*factor;
   
end
%% 
% 3. Read CSV file as a table
function csvTable = csvTable(filename)
    global SpecInfo
    
    if strcmp(SpecInfo.FileFormat, 'R&S Argus Compressed Measurement Result')
        opts = delimitedTextImportOptions("NumVariables", 8);
        
        % Specify range and delimiter
        opts.DataLines = [2, Inf];
        opts.Delimiter = ",";
        
        % Specify column names and types
        opts.VariableNames         = ["Time", "FrequencyHz", "LeveldBm", "Level_1dBm", "Level_2dBm", "Level_3dBm", "ValueCount", "FileInfo"];
        opts.VariableTypes         = ["char", "double", "double", "double", "double", "double", "double", "string"];
        opts.SelectedVariableNames = ["Time", "FrequencyHz", "LeveldBm","ValueCount"];
        
        % Specify file level properties
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule    = "read";
        
        % Specify variable properties
        opts = setvaropts(opts, ["Time", "FileInfo"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Time", "FileInfo"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, ["LeveldBm", "Level_1dBm", "Level_2dBm", "Level_3dBm"], "TrimNonNumeric", true);
        opts = setvaropts(opts, ["LeveldBm", "Level_1dBm", "Level_2dBm", "Level_3dBm"], "DecimalSeparator", ",");
        
        csvTable = readtable(filename, opts);
        csvTable(find(csvTable.ValueCount == 0),:) = []; 
    else
        opts = delimitedTextImportOptions("NumVariables", 4);
        
        % Specify range and delimiter
        opts.DataLines = [2, Inf];
        opts.Delimiter = ",";
        
        % Specify column names and types
        opts.VariableNames = ["Time", "FrequencyHz", "LeveldBm", "FileInfo"];
        opts.VariableTypes = ["char", "double", "double", "string"];
        
        % Specify file level properties
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule    = "read";
        
        % Specify variable properties
        opts = setvaropts(opts, ["Time", "FileInfo"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Time", "FileInfo"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "LeveldBm", "TrimNonNumeric", true);
        opts = setvaropts(opts, "LeveldBm", "DecimalSeparator", ",");
        
        csvTable = readtable(filename, opts);
    end
end