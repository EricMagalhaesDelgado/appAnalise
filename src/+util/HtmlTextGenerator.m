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
        function htmlContent = ReportAlgorithms(specData)
            threadTag = sprintf('%.3f - %.3f MHz', specData.MetaData.FreqStart/1e+6, specData.MetaData.FreqStop/1e+6);
        
            if specData.UserData.bandLimitsStatus && height(specData.UserData.bandLimitsTable)
                detectionBands = strjoin(arrayfun(@(x,y) sprintf('%.3f - %.3f MHz', x, y), specData.UserData.bandLimitsTable.FreqStart, ...
                                                                                           specData.UserData.bandLimitsTable.FreqStop, 'UniformOutput', false), ', ');
            else
                detectionBands = sprintf('%.3f - %.3f MHz', specData.MetaData.FreqStart/1e+6, ...
                                                            specData.MetaData.FreqStop /1e+6);
            end
        
            dataStruct    = struct('group', 'OCUPAÇÃO', 'value', specData.UserData.reportOCC);
            dataStruct(2) = struct('group', 'DETECÇÃO ASSISTIDA', 'value', struct('Origin', 'PLAYBACK', 'BandLimits', detectionBands));
            if ~specData.UserData.reportDetection.ManualMode
                dataStruct(end+1) = struct('group', 'DETECÇÃO NÃO ASSISTIDA', 'value', struct('Origin',     'RELATÓRIO', ...
                                                                                              'BandLimits',  detectionBands,     ...
                                                                                              'Algorithm',   specData.UserData.reportDetection.Algorithm, ...
                                                                                              'Parameters',  jsonencode(specData.UserData.reportDetection.Parameters)));
            end
            dataStruct(end+1) = struct('group', 'CLASSIFICAÇÃO', 'value', struct('Algorithm',   specData.UserData.reportClassification.Algorithm, ...
                                                                                  'Parameters',  specData.UserData.reportClassification.Parameters));
            
            htmlContent = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 16px; text-align: justify; line-height: 12px; margin: 5px; padding-top: 5px; padding-bottom: 10px;"><b>%s</b></p>', threadTag), ...
                           textFormatGUI.struct2PrettyPrintList(dataStruct)];
        end
    end
end