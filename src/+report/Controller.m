function Controller(app, operationType)

    try
        [idxThreads, reportInfo] = ReportGenerator_Aux1(app, operationType);
        
        switch operationType
            case 'Report'
                d = uiprogressdlg(app.UIFigure, 'Indeterminate', 'off', 'Interpreter', 'html', 'Cancelable', 'on', 'CancelText', 'Cancelar', 'Value', 0, 'Message', 'Em andamento...');

                % Verifica se o template e relatório selecionado demanda
                % arquivos externos (imagens e tabelas).
                if contains(reportInfo.Model.Script, '"Origin": "External"')
                    msg = '<p style="font-size:12px; text-align: justify;">Confirma que foram relacionados os arquivos externos ao appAnalise estabelecidos no modelo?</p>';
                    selection = uiconfirm(app.UIFigure, msg, '', 'Options', {'OK', 'Cancelar'}, 'DefaultOption', 1, 'CancelOption', 2, 'Icon', 'question', 'Interpreter', 'html');
                    
                    if selection == "Cancelar"
                        return
                    end
                end

                % Verifica...
                [htmlReport, Peaks] = report.ReportGenerator(app, idxThreads, reportInfo, d);
                report.ReportGenerator_PeaksUpdate(app, idxThreads, Peaks)

                switch app.report_Version.Value
                    case 'Definitiva'
                        [baseFullFileName, baseFileName] = appUtil.DefaultFileName(app.General.fileFolder.tempPath, 'Report', app.report_Issue.Value);
                        HTMLDocFullPath = [baseFullFileName '.html'];
                        fileID = fopen(HTMLDocFullPath, 'w', 'native', 'ISO-8859-1');
 
                    case 'Preliminar'
                        [baseFullFileName, baseFileName] = appUtil.DefaultFileName(app.General.fileFolder.tempPath, '~Report', app.report_Issue.Value);
                        HTMLDocFullPath = [baseFullFileName '.html'];
                        fileID = fopen(HTMLDocFullPath, 'w');
                end
                
                fprintf(fileID, '%s', htmlReport);
                fclose(fileID);
    
                switch app.report_Version.Value
                    case 'Definitiva'
                        JSONFile = [baseFullFileName '.json'];
                        MATFile  = [baseFullFileName '.mat'];
                        ZIPFile  = fullfile(app.General.fileFolder.userPath, [baseFileName '.zip']);
                        
                        [ReportProject, tableStr] = ReportGenerator_Aux2(app, idxThreads, reportInfo);
                        save(MATFile, 'ReportProject', '-mat', '-v7.3')
                        writematrix(tableStr, JSONFile, "FileType", "text", "QuoteStrings", "none")
    
                        app.projectData.generatedFiles.lastHTMLDocFullPath = HTMLDocFullPath;
                        app.projectData.generatedFiles.lastTableFullPath   = JSONFile;
                        app.projectData.generatedFiles.lastMATFullPath     = MATFile;

                        nameFormatMap = {'*.zip', 'appAnalise (*.zip)'};
                        ZIPFullPath  = appUtil.modalWindow(app.UIFigure, 'uiputfile', '', nameFormatMap, ZIPFile);
                        if isempty(ZIPFullPath)
                            return
                        end
                        
                        zip(ZIPFullPath, {HTMLDocFullPath, JSONFile, MATFile})
                        app.projectData.generatedFiles.lastZIPFullPath     = ZIPFullPath;

                    case 'Preliminar'
                        web(HTMLDocFullPath, '-new')
                end
            

            case {'Preview', 'playback.AddEditOrDeleteEmission', 'report.AddOrDeleteThread', 'signalAnalysis.EditOrDeleteEmission'}
                app.progressDialog.Visible = 'visible';

                Peaks = report.PreviewGenerator(app, idxThreads, reportInfo.DetectionMode);
                report.ReportGenerator_PeaksUpdate(app, idxThreads, Peaks)

                app.progressDialog.Visible = 'hidden';


            case 'signalAnalysis.externalJSON'
                countTable = reportLibConnection.table.Summary(app.projectData.peaksTable, app.projectData.exceptionList, 'EditedEmissionsTable');
                tableStr = ReportGenerator_Aux3(app, idxThreads, countTable);

                nameFormatMap   = {'*.json', 'appAnalise (*.json)'};
                defaultFilename = class.Constants.DefaultFileName(app.CallingApp.General.fileFolder.userPath, 'preReport', app.CallingApp.report_Issue.Value);
                JSONFullPath    = appUtil.modalWindow(app.UIFigure, 'uiputfile', '', nameFormatMap, defaultFilename);
                if isempty(JSONFullPath)
                    return
                end
                
                writematrix(tableStr, JSONFullPath, "FileType", "text", "QuoteStrings", "none")
        end
        
    catch ME
        appUtil.modalWindow(app.UIFigure, 'error', getReport(ME));
    end

    if exist('d', 'var')
        delete(d)
    end
end


%-------------------------------------------------------------------------%
function [idxThreads, reportInfo] = ReportGenerator_Aux1(app, Mode)
    switch Mode
        case {'Report', 'Preview', 'playback.AddEditOrDeleteEmission', 'report.AddOrDeleteThread', 'signalAnalysis.EditOrDeleteEmission'}
            if isempty(app.General.AppVersion.fiscaliza) && strcmp(Mode, 'Report')
                app.General.AppVersion = util.getAppVersion(app.rootFolder, app.entryPointFolder, app.General.fileFolder.tempPath, 'full+Python');
            end
        
            reportTemplateIndex = find(strcmp(app.report_ModelName.Items, app.report_ModelName.Value), 1) - 1;
            [idxThreads, reportInfo]   = report.GeneralInfo(app, Mode, reportTemplateIndex);

        case 'signalAnalysis.externalJSON'
            reportTemplateIndex = find(strcmp(app.CallingApp.report_ModelName.Items, app.CallingApp.report_ModelName.Value), 1) - 1;
            [idxThreads, reportInfo]   = report.GeneralInfo(app.CallingApp, Mode, reportTemplateIndex);
    end
end


%-------------------------------------------------------------------------%
function [ReportProject, tableStr] = ReportGenerator_Aux2(app, idxThreads, reportInfo)

    % Variável que possibilitará o preenchimento dos campos
    % estruturados da inspeção (no Fiscaliza).
    ReportProject = struct('Issue',           app.report_Issue.Value,       ...
                           'Latitude',        [], 'Longitude',          [], ...
                           'City',            [], 'Bands',              [], ...
                           'F0',              [], 'F1',                 [], ...
                           'emissionsValue1',  0, 'emissionsValue2',     0, 'emissionsValue3',     0, ...
                           'Services',        [], 'tableJournal',       []);

    % Preenchimento dos dados...            
    ReportProject.Services = app.General.Models.RelatedServices{reportInfo.Model.idx};
    
    % Definir FreqStart, FreqStop, Latitude, Longitude e City que
    % irão compor inspeção no Fiscaliza.
    ReportProject.Bands = {};
    for ii = idxThreads
        if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            ReportProject.Bands(end+1) = {sprintf('%.3f - %.3f MHz', app.specData(ii).MetaData.FreqStart / 1e+6, ...
                                                                     app.specData(ii).MetaData.FreqStop  / 1e+6)};
            
            if isempty(ReportProject.Latitude)
                ReportProject.Latitude  = app.specData(ii).GPS.Latitude;
                ReportProject.Longitude = app.specData(ii).GPS.Longitude;
                ReportProject.City      = {sprintf('%s/%s', app.specData(ii).GPS.Location(end-1:end), app.specData(ii).GPS.Location(1:end-3))};
                
                ReportProject.F0 = app.specData(ii).MetaData.FreqStart;
                ReportProject.F1 = app.specData(ii).MetaData.FreqStop;
            
            else
                if ~ismember(app.specData(ii).GPS.Location, ReportProject.City)
                    ReportProject.City{end+1,1} = sprintf('%s/%s', app.specData(ii).GPS.Location(end-1:end), app.specData(ii).GPS.Location(1:end-3));
                end                        
                
                ReportProject.F0 = min(ReportProject.F0, app.specData(ii).MetaData.FreqStart);
                ReportProject.F1 = max(ReportProject.F1, app.specData(ii).MetaData.FreqStop);
            end
        end
    end
    
    % Juntar numa mesma variável a informação gerada pelo algoritmo
    % embarcado no appAnálise (app.peaksTable) com a informação
    % gerada pelo fiscal (app.exceptionList).
    [countTable, infoTable] = reportLibConnection.table.Summary(app.projectData.peaksTable, app.projectData.exceptionList, 'EditedEmissionsTable+TotalSummaryTable');

    ReportProject.emissionsValue1 = sum(infoTable{:,2:4}, 'all');                               % Qtd. emissões
    ReportProject.emissionsValue2 = sum(infoTable{:,2});                                        % Qtd. emissões licenciadas
    ReportProject.emissionsValue3 = sum(infoTable{:,5:8}, 'all');                               % Qtd. emissões identificadas

    % Arquivo JSON
    tableStr = ReportGenerator_Aux3(app, idxThreads, countTable);
end


%-------------------------------------------------------------------------%
function tableStr = ReportGenerator_Aux3(app, idxThreads, countTable)
    
    % Tabelas que irão compor o JSON que será carregado como anexo
    % à inspeção (no Fiscaliza).
    TaskTable   = table('Size', [0, 12],                                                                                                                 ...
                        'VariableTypes', {'uint16', 'cell', 'single', 'single', 'double', 'double', 'cell', 'cell', 'uint32', 'double', 'cell', 'cell'}, ...
                        'VariableNames', {'PK1', 'Node', 'Latitude', 'Longitude', 'FreqStart', 'FreqStop', 'BeginTime', 'EndTime', 'Samples', 'timeOCC', 'Description', 'RelatedFiles'});

    occMethodTable      = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK2', 'occMethod'});
    DetectionTable      = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK3', 'Detection'});
    ClassificationTable = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK4', 'Classification'});
    
    PeakTable           = countTable(:,5:21);
    PeakTable.Frequency = round(PeakTable.Frequency, 3);
    PeakTable.BW        = round(PeakTable.BW, 3);

    occMethod = unique(countTable.occMethod);
    occMethodTable(1:numel(occMethod),:) = [num2cell((1:numel(occMethod))'), occMethod];
    
    Detection = unique(countTable.Detection);
    DetectionTable(1:numel(Detection),:) = [num2cell((1:numel(Detection))'), Detection];
    
    Classification = unique(countTable.Classification);
    ClassificationTable(1:numel(Classification),:) = [num2cell((1:numel(Classification))'), Classification];

    jj = 0;
    for ii = idxThreads
        if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            jj = jj+1;

            occInfo = app.specData(ii).UserData.reportOCC;
            if isfield(occInfo, 'IntegrationTime')
                IntegrationTime = occInfo.IntegrationTime;
            else
                IntegrationTime = occInfo.IntegrationTimeCaptured;
            end
            
            TaskTable(end+1,:) = {jj,                                  ...
                                  app.specData(ii).Receiver,           ...
                                  app.specData(ii).GPS.Latitude,       ...
                                  app.specData(ii).GPS.Longitude,      ...
                                  app.specData(ii).MetaData.FreqStart / 1e+6, ...
                                  app.specData(ii).MetaData.FreqStop  / 1e+6, ...
                                  datestr(app.specData(ii).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), ...
                                  datestr(app.specData(ii).Data{1}(end), 'dd/mm/yyyy HH:MM:SS'), ...
                                  numel(app.specData(ii).Data{1}),      ...
                                  IntegrationTime,                      ...
                                  app.specData(ii).RelatedFiles.Description{1}, ...
                                  strjoin(app.specData(ii).RelatedFiles.File, ', ')};
            
            Tag = sprintf('%s\n%.3f - %.3f MHz', app.specData(ii).Receiver,                  ...
                                                 app.specData(ii).MetaData.FreqStart / 1e+6, ...
                                                 app.specData(ii).MetaData.FreqStop  / 1e+6);
            
            idx1 = find(strcmp(app.projectData.peaksTable.Tag, Tag));
            if ~isempty(idx1)
                PeakTable.FK1(idx1) = uint16(jj);
            end
        end
    end

    % occMethod, detection and classification tables
    for ii = 1:numel(occMethod)
        idx_OCC = find(strcmp(countTable.occMethod, occMethod(ii)));

        if ~isempty(idx_OCC); PeakTable.FK2(idx_OCC) = uint16(ii);
        end                
    end

    for ii = 1:numel(Detection)
        idx_Det = find(strcmp(countTable.Detection, Detection(ii)));

        if ~isempty(idx_Det); PeakTable.FK3(idx_Det) = uint16(ii);
        end
    end

    for ii = 1:numel(Classification)
        idx_Cla = find(strcmp(countTable.Classification, Classification(ii)));

        if ~isempty(idx_Cla); PeakTable.FK4(idx_Cla) = uint16(ii);
        end
    end

    if ~isempty(PeakTable)
        PeakTable = movevars(PeakTable, {'FK1', 'FK2', 'FK3', 'FK4'}, 'Before', 1);
        tableStr  = jsonencode(struct('ReferenceData1', TaskTable, 'ReferenceData2', occMethodTable, 'ReferenceData3', DetectionTable, 'ReferenceData4', ClassificationTable, 'MeasurementData', PeakTable(:,1:end-1)), 'PrettyPrint', true);
    else
        tableStr  = jsonencode(struct('ReferenceData1', TaskTable), 'PrettyPrint', true);
    end            
end