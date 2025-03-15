classdef (Abstract) HtmlTextGenerator

    properties (Constant)
        %-----------------------------------------------------------------%
    end

    
    methods (Static = true)
        %-----------------------------------------------------------------%
        function htmlContent = AppInfo(appGeneral, rootFolder, executionMode)
            global RFDataHub
            global RFDataHub_info
        
            appName    = class.Constants.appName;
            appVersion = appGeneral.AppVersion;
            appURL     = util.publicLink(appName, rootFolder, 'appAnalise');
        
            switch executionMode
                case {'MATLABEnvironment', 'desktopStandaloneApp'}
                    appMode = 'desktopApp';        
                case 'webApp'
                    computerName = ccTools.fcn.OperationSystem('computerName');
                    if strcmpi(computerName, appGeneral.computerName.webServer)
                        appMode = 'webServer';
                    else
                        appMode = 'deployServer';                    
                    end
            end
        
            dataStruct    = struct('group', 'COMPUTADOR', 'value', struct('Machine', appVersion.machine, 'Mode', sprintf('%s - %s', executionMode, appMode)));
            dataStruct(2) = struct('group', appName,      'value', appVersion.(appName));
            dataStruct(3) = struct('group', 'RFDataHub',  'value', struct('releasedDate', RFDataHub_info.ReleaseDate, 'numberOfRows', height(RFDataHub), 'numberOfUniqueStations', numel(unique(RFDataHub.("Station")))));
            dataStruct(4) = struct('group', 'MATLAB',     'value', appVersion.matlab);
        
            htmlContent   = sprintf(['<p style="font-size: 12px; text-align:justify;">O repositório das '   ...
                                    'ferramentas desenvolvidas no Escritório de inovação da SFI pode ser ' ...
                                    'acessado <a href="%s">aqui</a>.\n\n</p>%s'], appURL.Sharepoint, textFormatGUI.struct2PrettyPrintList(dataStruct));
        end


        %-----------------------------------------------------------------%
        function htmlContent = Thread(dataSource, varargin)
            if isa(dataSource, 'model.MetaData')
                idxFile    = varargin{1};
                idxThread  = varargin{2};

                specData   = dataSource(idxFile).Data(idxThread);
                dataStruct = struct('group', 'GERAL',                                           ...
                                    'value', struct('File',    dataSource(idxFile).File,        ...
                                                    'Type',    dataSource(idxFile).Type,        ...
                                                    'nData',   numel(dataSource(idxFile).Data), ...
                                                    'Memory',  sprintf('%.3f MB', dataSource(idxFile).Memory)));
                if isempty(idxThread)
                    receiverList = strjoin(unique({dataSource(idxFile).Data.Receiver})', '<br>');
                else
                    receiverList = dataSource(idxFile).Data(idxThread(1)).Receiver;
                end
                dataStruct(end+1) = struct('group', 'RECEPTOR',  'value', receiverList);
        
            else % 'model.SpecData'
                idxThread  = varargin{1};

                specData   = dataSource(idxThread);
                dataStruct = struct('group', 'RECEPTOR', 'value', specData(1).Receiver);
            end    
            
            if isscalar(specData)
                threadTag = sprintf('%.3f - %.3f MHz', specData.MetaData.FreqStart/1e+6, specData.MetaData.FreqStop/1e+6);
        
                % Tempo de observação:
                if isa(dataSource, 'model.SpecData')
                    dataStruct(end+1) = struct('group', 'TEMPO DE OBSERVAÇÃO', 'value', sprintf('%s - %s', datestr(specData.Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), datestr(specData.Data{1}(end), 'dd/mm/yyyy HH:MM:SS')));
                end
        
                % Metadados:
                dataStruct(end+1) = struct('group', 'METADADOS', 'value', rmfield(specData.MetaData, {'DataType'}));
                dataStruct(end).value.FreqStart = sprintf('%d Hz', dataStruct(end).value.FreqStart);
                dataStruct(end).value.FreqStop  = sprintf('%d Hz', dataStruct(end).value.FreqStop);

                if specData.MetaData.Resolution ~= -1
                    dataStruct(end).value.Resolution = sprintf('%.1f kHz', dataStruct(end).value.Resolution/1000);
                end
        
                if specData.MetaData.VBW ~= -1
                    dataStruct(end).value.VBW = sprintf('%.3f kHz', dataStruct(end).value.VBW/1000);
                end
        
                % GPS e arquivos:
                dataStruct(end+1) = struct('group', 'GPS', 'value', specData.GPS);
                dataStruct(end+1) = struct('group', 'FONTE DA INFORMAÇÃO',                                   ...
                                           'value', struct('File',    strjoin(specData.RelatedFiles.File, ', '), ...
                                                           'nSweeps', sum(specData.RelatedFiles.nSweeps)));
        
                for ii = 1:height(specData.RelatedFiles)
                    BeginTime = datestr(specData.RelatedFiles.BeginTime(ii), 'dd/mm/yyyy HH:MM:SS');
                    EndTime   = datestr(specData.RelatedFiles.EndTime(ii),   'dd/mm/yyyy HH:MM:SS');
        
                    dataStruct(end+1) = struct('group', upper(specData.RelatedFiles.File{ii}),                            ...
                                               'value', struct('ID',              specData.RelatedFiles.ID(ii),           ...
                                                               'Task',            specData.RelatedFiles.Task{ii},         ...
                                                               'Description',     specData.RelatedFiles.Description{ii},  ...
                                                               'ObservationTime', sprintf('%s - %s', BeginTime, EndTime), ...
                                                               'nSweeps',         specData.RelatedFiles.nSweeps(ii),      ...
                                                               'RevisitTime',     sprintf('%.3f segundos', specData.RelatedFiles.RevisitTime(ii))));
                end
        
                if isprop(specData, 'UserData') && ~isempty(specData.UserData) && ~isempty(specData.UserData.LOG)
                    dataStruct(end+1) = struct('group', 'LOG', 'value', strjoin(specData.UserData.LOG));
                end
            
            else
                threadTag = strjoin(arrayfun(@(x) sprintf('%.3f - %.3f MHz', x.MetaData.FreqStart/1e+6, x.MetaData.FreqStop/1e+6), specData, "UniformOutput", false), '<br>');
            end
        
            htmlContent = {sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; line-height: 16px; margin: 5px; padding-top: 5px; padding-bottom: 10px;"><b>%s</b></p>', threadTag), ...
                           textFormatGUI.struct2PrettyPrintList(dataStruct, 'delete')};
            htmlContent = strjoin(htmlContent);
        end


        %-----------------------------------------------------------------%
        function [htmlContent, emissionTag, userDescription, stationInfo] = Emission(specData, idxThread, idxEmission)
            emissionTable = specData(idxThread).UserData.Emissions(idxEmission, :);
            emissionTag   = sprintf('%.3f MHz ⌂ %.1f kHz', emissionTable.Frequency, emissionTable.BW_kHz);
        
            % Identificando registros que foram editados pelo usuário:
            columns2Compare = {'Regulatory', 'Service', 'Station', 'EmissionType', 'Irregular', 'RiskLevel', 'Latitude', 'Longitude', 'AntennaHeight', 'Description', 'Distance'};
            stationInfo = [];
            for ii = 1:numel(columns2Compare)
                columnName = columns2Compare{ii};
                if isequal(emissionTable.Classification.autoSuggested.(columnName), emissionTable.Classification.userModified.(columnName))
                    columnsDiff.(columnName) = string(emissionTable.Classification.autoSuggested.(columnName));
                else
                    columnsDiff.(columnName) = sprintf('<del>%s</del> → <font style="color: red;">%s</font>', string(emissionTable.Classification.autoSuggested.(columnName)), string(emissionTable.Classification.userModified.(columnName)));                    
                end
                stationInfo.(columnName) = emissionTable.Classification.userModified.(columnName);
            end

            % Destacando em VERMELHO registros que possuem situação diferente de 
            % "Licenciada" e, também, registros cujo número da estação é igual a -1.
            % Este último caso, contudo, é feito apenas se a tabela exceptionList 
            % estiver vazia.
            if stationInfo.Regulatory ~= "Licenciada"
                columnsDiff.Regulatory = sprintf('<font style="color: red;">%s</font>', columnsDiff.Regulatory);
            end
        
            if stationInfo.Station == -1
                columnsDiff.Station = sprintf('<font style="color: red;">%s</font>', columnsDiff.Station);
            end

            if stationInfo.AntennaHeight <= 0
                columnsDiff.AntennaHeight = '<font style="color: red;">-1</font>';
            end
        
            % stationInfo
            stationInfo.Details       = emissionTable.Classification.userModified.Details;
        
            % HTML
            dataStruct(1) = struct('group', 'RECEPTOR',            'value', specData(idxThread).Receiver);
            dataStruct(2) = struct('group', 'TEMPO DE OBSERVAÇÃO', 'value', sprintf('%s - %s', datestr(specData(idxThread).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), datestr(specData(idxThread).Data{1}(end), 'dd/mm/yyyy HH:MM:SS')));    
            dataStruct(3) = struct('group', 'CANAL',               'value', struct('autoSuggested', sprintf('%.3f MHz ⌂ %.1f kHz', emissionTable.ChannelAssigned.autoSuggested.Frequency, emissionTable.ChannelAssigned.autoSuggested.ChannelBW)));
            
            if ~isequal(emissionTable.ChannelAssigned.autoSuggested, emissionTable.ChannelAssigned.userModified)
                dataStruct(3).value.userModified = sprintf('%.3f MHz ⌂ %.1f kHz', emissionTable.ChannelAssigned.userModified.Frequency,  emissionTable.ChannelAssigned.userModified.ChannelBW);
            end

            dataStruct(4) = struct('group', 'CLASSIFICAÇÃO',       'value', columnsDiff);
            dataStruct(5) = struct('group', 'ALGORITMOS',          'value', struct('Occupancy',       emissionTable.Algorithms.Occupancy, ...
                                                                                   'Detection',       emissionTable.Algorithms.Detection, ...
                                                                                   'Classification',  emissionTable.Algorithms.Classification));
        
            userDescription = specData(idxThread).UserData.Emissions.Description(idxEmission);
            if userDescription ~= ""
                dataStruct(4).value.userDescription = sprintf('<font style="color: blue;">%s</font>', userDescription);
            end
        
            htmlContent    = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; line-height: 12px; margin: 5px; padding-top: 5px; padding-bottom: 10px;"><b>%s</b></p>', emissionTag) ...
                              textFormatGUI.struct2PrettyPrintList(dataStruct(1:4)), ...
                              '<p style="font-family: Helvetica, Arial, sans-serif; color: gray; font-size: 10px; text-align: justify; line-height: 12px; margin: 5px; padding-bottom: 10px;">&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;&thinsp;____________________<br>&thinsp;̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ ̅ <br>A seguir são apresentadas informações acerca do método de aferição da ocupação e dos algoritmos de detecção e classificação da emissão.</p>' ...
                              textFormatGUI.struct2PrettyPrintList(dataStruct(5), 'delete')];
        end


        %-----------------------------------------------------------------%
        function htmlContent = ReportAlgorithms(specData)
            threadTag = sprintf('%.3f - %.3f MHz', specData.MetaData.FreqStart/1e+6, specData.MetaData.FreqStop/1e+6);
        
            if specData.UserData.bandLimitsStatus && height(specData.UserData.bandLimitsTable)
                detectionBands = strjoin(arrayfun(@(x,y) sprintf('%.3f - %.3f MHz', x, y), specData.UserData.bandLimitsTable.FreqStart, ...
                                                                                           specData.UserData.bandLimitsTable.FreqStop, 'UniformOutput', false), ', ');
            else
                detectionBands = sprintf('%.3f - %.3f MHz', specData.MetaData.FreqStart/1e+6, ...
                                                            specData.MetaData.FreqStop /1e+6);
            end
        
            dataStruct    = struct('group', 'OCUPAÇÃO', 'value', specData.UserData.reportAlgorithms.Occupancy);
            dataStruct(2) = struct('group', 'DETECÇÃO ASSISTIDA', 'value', struct('Origin', 'PLAYBACK', 'BandLimits', detectionBands));
            if ~specData.UserData.reportAlgorithms.Detection.ManualMode
                dataStruct(end+1) = struct('group', 'DETECÇÃO NÃO ASSISTIDA', 'value', struct('Origin',     'RELATÓRIO', ...
                                                                                              'BandLimits',  detectionBands,     ...
                                                                                              'Algorithm',   specData.UserData.reportAlgorithms.Detection.Algorithm, ...
                                                                                              'Parameters',  jsonencode(specData.UserData.reportAlgorithms.Detection.Parameters)));
            end
            dataStruct(end+1) = struct('group', 'CLASSIFICAÇÃO', 'value', struct('Algorithm',  specData.UserData.reportAlgorithms.Classification.Algorithm, ...
                                                                                 'Parameters', specData.UserData.reportAlgorithms.Classification.Parameters));
            
            htmlContent = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; line-height: 12px; margin: 5px; padding-top: 5px; padding-bottom: 10px;"><b>%s</b></p>', threadTag), ...
                           textFormatGUI.struct2PrettyPrintList(dataStruct)];
        end


        %-----------------------------------------------------------------%
        function htmlContent = Station(rfDataHub, idxRFDataHub, rfDataHubLOG, appGeneral)
            % stationTag
            stationInfo    = table2struct(rfDataHub(idxRFDataHub,:));
            if stationInfo.BW <= 0
                stationTag = sprintf('%.3f MHz',            stationInfo.Frequency);
            else
                stationTag = sprintf('%.3f MHz ⌂ %.1f kHz', stationInfo.Frequency, stationInfo.BW);
            end
        
            % stationService
            global id2nameTable
            if isempty(id2nameTable)
                serviceOptions = appGeneral.fiscaliza.defaultValues.servicos_da_inspecao.options;
                serviceIDs     = int16(str2double(extractBefore(serviceOptions, '-')));
                id2nameTable   = table(serviceIDs, serviceOptions, 'VariableNames', {'ID', 'Serviço'});
            end
            stationService = fiscalizaGUI.serviceMapping(stationInfo.Service);
        
            [~, idxService] = ismember(stationInfo.Service, id2nameTable.ID);
            if idxService
                stationService = id2nameTable.("Serviço"){idxService};
            else
                stationService = num2str(stationService);
            end
        
            if strcmp(stationService, '-1')
                stationService = '<font style="color: red;">-1</font>';
            end
            
            % stationNumber
            mergeCount = str2double(string(stationInfo.MergeCount));
            if stationInfo.Station == -1
                stationNumber = sprintf('<font style="color: red;">%d</font>', stationInfo.Station);
            else
                stationNumber = num2str(stationInfo.Station);
                if mergeCount > 1
                    stationNumber = sprintf('%s*', stationNumber);
                end
            end
        
            % stationLocation, stationHeight
            stationLocation = sprintf('(%.6fº, %.6fº)', stationInfo.Latitude, stationInfo.Longitude);
            stationHeight   = str2double(char(stationInfo.AntennaHeight));
            if stationHeight <= 0
                stationHeight = '<font style="color: red;">-1</font>';
            else
                stationHeight = sprintf('%.1fm', stationHeight);
            end    
        
            % stationLOG
            stationLOG = class.RFDataHub.queryLog(rfDataHubLOG, stationInfo.Log);
            if isempty(stationLOG)
                stationLOG = 'Registro não editado';
            end
        
            % dataStruct2HTMLContent
            dataStruct(1) = struct('group', 'Service',                  'value', stationService);
            dataStruct(2) = struct('group', 'Station',                  'value', stationNumber);
            dataStruct(3) = struct('group', 'Localização',              'value', stationLocation);
            dataStruct(4) = struct('group', 'Altura',                   'value', stationHeight);

            columns2Del   = {'AntennaPattern', 'BW', 'Description', 'Distance', 'Fistel', 'Frequency',     ...
                             'ID', 'Latitude', 'LocationID', 'Location', 'Log', 'Longitude', 'MergeCount', ...
                             'Name', 'Station', 'StationClass', 'Status', 'Service', 'Source', 'State', 'URL'};
            dataStruct(5) = struct('group', 'OUTROS ASPECTOS TÉCNICOS', 'value', rmfield(stationInfo, columns2Del));        
            if mergeCount > 1
                dataStruct(end+1) = struct('group', 'NÚMERO ESTAÇÕES AGRUPADAS', 'value', string(mergeCount));
            end
        
            try
                if isstruct(stationLOG) || ischar(stationLOG)
                    dataStruct(end+1) = struct('group', 'LOG', 'value', stationLOG);
                elseif iscell(stationLOG)
                    for ii = 1:numel(stationLOG)
                        dataStruct(end+1) = struct('group', sprintf('LOG #%d', ii), 'value', stationLOG{ii});
                    end
                end
            catch
            end
        
            htmlContent   = [sprintf('<div><p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; margin: 5px; color: white; background-color: red; display: inline-block; vertical-align: middle; padding: 5px; border-radius: 5px;">%s</p><span style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; display: inline-block; vertical-align: sub;">ID %s</span></div>', stationInfo.Source, stationInfo.ID) ...
                             sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; margin: 5px;"><b>%s</b></p>', stationTag)                             ...
                             sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 11px; text-align: justify; margin: 5px; padding-bottom: 10px;">%s</p>', stationInfo.Description) ...
                             textFormatGUI.struct2PrettyPrintList(dataStruct, 'delete')];
        end
    end
end