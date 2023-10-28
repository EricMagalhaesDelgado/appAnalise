function ReportGenerator_Main(app, Mode)

    d = uiprogressdlg(app.UIFigure, 'Indeterminate', 'on', 'Interpreter', 'html'); 
    d.Message = '<font style="font-size:12;">Em andamento a análise dos fluxos de dados selecionados, o que inclui diversas manipulações, como, por exemplo, a busca de emissões, a comparação com a base de dados da Agência e a geração de plots.</font>';
        
    try
        if isempty(app.General.ver.fiscaliza)
            app.General.ver = startup_Versions("Full", app.RootFolder);
        end

        reportInfo = ReportGenerator_Aux1(app, Mode);
    
        % FLUXOS DE DADOS A PROCESSAR
        if Mode == "Report"
            ExternalFiles_Flag = extractBefore(reportInfo.Model.Template, '"Origin": "External"');
            if ~isempty(ExternalFiles_Flag)
                msg = '<font style="font-size:12;">Confirma que foram relacionados os arquivos externos ao appAnálise estabelecidos no modelo?</font>';
                selection = uiconfirm(app.UIFigure, msg, 'appAnálise', 'Options', {'OK', 'Cancelar'}, 'DefaultOption', 1, 'CancelOption', 2, 'Icon', 'question', 'Interpreter', 'html');
                
                if selection == "Cancelar"
                    return
                end
            end

            CheckedRows = find([app.specData.reportFlag]);

        else
            CheckedRows = [];
            for mm = 1:numel(app.Report_Tree.CheckedNodes)
                if isnumeric(app.Report_Tree.CheckedNodes(mm).NodeData)
                    CheckedRows = [CheckedRows, app.Report_Tree.CheckedNodes(mm).NodeData];
                end
            end
            CheckedRows = unique(CheckedRows);                    
        end
        
        idx = Misc_FindOCCData(app.specData(CheckedRows));
        ProjectRows = sort([CheckedRows, idx]);
        
        % OCC Map (Step 1 of 2)
        OCCLength = numel(idx);
        if OCCLength
            OCCMap = zeros(OCCLength, 2);
            
            jj = 0;
            for ii = 1:numel(ProjectRows)
                if ~isempty(app.specData(ProjectRows(ii)).UserData.reportOCC.Index)
                    jj=jj+1;
                    OCCMap(jj,:) = [ProjectRows(ii), app.specData(ProjectRows(ii)).UserData.reportOCC.Index];
                    app.specData(ProjectRows(ii)).UserData.reportOCC.Index = find(ProjectRows == OCCMap(jj,2));
                end
            end
        end
        
        if Mode == "Report"
            [htmlReport, Peaks] = ReportGenerator(app.specData(ProjectRows), reportInfo, app.exceptionList);
            ReportGenerator_PeaksUpdate(app, CheckedRows, Peaks)

            if app.Report_Version.Value == "Definitiva"
                filename = fullfile(app.menu_userPath.Value, sprintf('Report_%s_%.0f.html', datestr(datetime('now'), 'yyyy.mm.dd_THH.MM.SS'), app.Report_Issue.Value));
                fileID   = fopen(filename, 'w', 'native', 'ISO-8859-1');

            else
                filename = fullfile(app.menu_userPath.Value, sprintf('~Report_%s_%.0f.html', datestr(datetime('now'), 'yyyy.mm.dd_THH.MM.SS'), app.Report_Issue.Value));
                fileID   = fopen(filename, 'w');
            end
            
            fprintf(fileID, '%s', htmlReport);
            fclose(fileID);

            if app.Report_Version.Value == "Definitiva"
                app.General.Report = filename;
                
                [ReportProject, tableStr] = ReportGenerator_Aux2(app, ProjectRows, reportInfo);
                save(replace(filename, '.html', '.mat'), 'ReportProject', '-mat', '-v7.3')
                writematrix(tableStr, replace(filename, '.html', '.json'), "FileType", "text", "QuoteStrings", "none")
            end
            web(filename, '-new')

        else
            Peaks = PreviewGenerator(app.specData(ProjectRows), reportInfo);
            ReportGenerator_PeaksUpdate(app, CheckedRows, Peaks)
        end

        % OCC Map (Step 2 of 2)
        if OCCLength
            for jj = 1:height(OCCMap)
                app.specData(OCCMap(jj,1)).UserData.reportOCC.Index = OCCMap(jj,2);
            end
        end
        
    catch ME
        fprintf('%s\n', jsonencode(ME))
        MessageBox(app, 'error', getReport(ME))
    end
    delete(d)
end


%-----------------------------------------------------------------%
function reportInfo = ReportGenerator_Aux1(app, Mode)
    
    Date1 = app.Report_DatePicker1.Value + hours(app.Report_Spinner1.Value) + minutes(app.Report_Spinner2.Value);
    Date2 = app.Report_DatePicker2.Value + hours(app.Report_Spinner3.Value) + minutes(app.Report_Spinner4.Value);
    
    if Date1 > Date2
        error('Os valores inseridos para aplicação do filtro de TimeStamp devem ser ajustados!')
    end
    
    idx = find(strcmp(app.Report_Type.Items, app.Report_Type.Value), 1);
    
    reportInfo = struct('appVersion', app.General.ver,                                ...
                        'Issue',      app.Report_Issue.Value,                         ...
                        'General',    struct('Mode',       Mode,                      ...
                                             'Version',    app.Report_Version.Value,  ...
                                             'Image',      app.General.Image,         ...
                                             'RootFolder', app.RootFolder,            ...
                                             'UserPath',   app.menu_userPath.Value),  ...
                        'Model',      struct('Name',       app.Report_Type.Value,     ...
                                             'Type',       app.General.Models(idx,:), ...
                                             'Template',   fileread(fullfile(app.RootFolder, 'Template', app.General.Models.Template{idx}))), ...
                        'Attachments', app.projData,  ...
                        'TimeStamp',  [Date1, Date2], ...
                        'Filename',   '');            
end


%-----------------------------------------------------------------%
function [ReportProject, tableStr] = ReportGenerator_Aux2(app, ProjectRows, reportInfo)

    % Variável que possibilitará o preenchimento dos campos
    % estruturados na inspeção (no Fiscaliza).
    ReportProject = struct('Issue',           app.Report_Issue.Value,       ...
                           'Latitude',        [], 'Longitude',          [], ...
                           'City',            [], 'Bands',              [], ...
                           'F0',              [], 'F1',                 [], ...
                           'emissionsValue1',  0, 'emissionsValue2',     0, 'emissionsValue3',     0, ...
                           'Services',        [], 'tableJournal',       []);

    % Preenchimento dos dados...            
    idx = find(strcmp(app.General.Models.Name, app.Report_Type.Value), 1);
    ReportProject.Services = app.General.Models.RelatedServices{idx};
    
    % Definir FreqStart, FreqStop, Latitude, Longitude e City que
    % irão compor inspeção no Fiscaliza.
    ReportProject.Bands = {};
    for ii = 1:numel(ProjectRows)
        if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            ReportProject.Bands(end+1) = {sprintf('%.3f - %.3f MHz', app.specData(ii).MetaData.FreqStart ./ 1e+6, app.specData(ii).MetaData.FreqStop ./ 1e+6)};
            
            if isempty(ReportProject.Latitude)
                ReportProject.Latitude  = app.specData(ProjectRows(ii)).gps.Latitude;
                ReportProject.Longitude = app.specData(ProjectRows(ii)).gps.Longitude;
                ReportProject.City      = {app.specData(ProjectRows(ii)).gps.Location};
                
                ReportProject.F0 = app.specData(ProjectRows(ii)).MetaData.FreqStart;
                ReportProject.F1 = app.specData(ProjectRows(ii)).MetaData.FreqStop;
            
            else
                if ~ismember(app.specData(ProjectRows(ii)).gps.Location, ReportProject.City)
                    ReportProject.City{end+1,1} = app.specData(ProjectRows(ii)).gps.Location;
                end                        
                
                ReportProject.F0 = min(ReportProject.F0, app.specData(ProjectRows(ii)).MetaData.FreqStart);
                ReportProject.F1 = max(ReportProject.F1, app.specData(ProjectRows(ii)).MetaData.FreqStop);
            end
        end
    end
    
    % Juntar numa mesma variável a informação gerada pelo algoritmo
    % embarcado no appAnálise (app.peaksTable) com a informação
    % gerada pelo fiscal (app.exceptionList).
    [infoTable, countTable] = ReportGenerator_Table_Summary(app.peaksTable, app.exceptionList);

    ReportProject.emissionsValue1 = sum(infoTable{:,2:4}, 'all');                               % Qtd. emissões
    ReportProject.emissionsValue2 = sum(infoTable{:,2});                                        % Qtd. emissões licenciadas
    ReportProject.emissionsValue3 = sum(infoTable{:,5:8}, 'all');                               % Qtd. emissões identificadas

    ReportProject.tableJournal = infoTable(:,cell2mat(reportInfo.Model.Type.JournalTable));

    % Arquivo JSON
    tableStr = ReportGenerator_Aux3(app, ProjectRows, countTable);
end


%-----------------------------------------------------------------%
function tableStr = ReportGenerator_Aux3(app, ProjectRows, countTable)
    
    % Tabelas que irão compor o JSON que será carregado como anexo
    % à inspeção (no Fiscaliza).
    TaskTable   = table('Size', [0, 12],                                                                                                                 ...
                        'VariableTypes', {'uint16', 'cell', 'single', 'single', 'double', 'double', 'cell', 'cell', 'uint32', 'double', 'cell', 'cell'}, ...
                        'VariableNames', {'PK1', 'Node', 'Latitude', 'Longitude', 'FreqStart', 'FreqStop', 'BeginTime', 'EndTime', 'Samples', 'timeOCC', 'Description', 'RelatedFiles'});

    occMethodTable      = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK2', 'occMethod'});
    DetectionTable      = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK3', 'Detection'});
    ClassificationTable = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK4', 'Classification'});
    
    PeakTable = countTable(:,5:21);
    PeakTable.Frequency = round(PeakTable.Frequency, 3);
    PeakTable.BW        = round(1000 * PeakTable.BW, 3);

    occMethod = unique(countTable.occMethod);
    occMethodTable(1:numel(occMethod),:) = [num2cell((1:numel(occMethod))'), occMethod];
    
    Detection = unique(countTable.Detection);
    DetectionTable(1:numel(Detection),:) = [num2cell((1:numel(Detection))'), Detection];
    
    Classification = unique(countTable.Classification);
    ClassificationTable(1:numel(Classification),:) = [num2cell((1:numel(Classification))'), Classification];

    jj = 0;
    for ii = ProjectRows
        if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            jj = jj+1;

            occInfo = jsondecode(app.specData(ii).UserData.reportOCC.Parameters);
            
            TaskTable(end+1,:) = {jj,                                  ...
                                  app.specData(ii).Node,               ...
                                  app.specData(ii).gps.Latitude,       ...
                                  app.specData(ii).gps.Longitude,      ...
                                  app.specData(ii).MetaData.FreqStart ./ 1e+6, ...
                                  app.specData(ii).MetaData.FreqStop  ./ 1e+6, ...
                                  datestr(app.specData(ii).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), ...
                                  datestr(app.specData(ii).Data{1}(end), 'dd/mm/yyyy HH:MM:SS'), ...
                                  app.specData(ii).Samples,             ...
                                  occInfo.IntegrationTime,              ...
                                  app.specData(ii).Description,         ...
                                  strjoin(app.specData(ii).RelatedFiles.Name, ', ')};
            
            Tag = sprintf('%s\nThreadID %d: %.3f - %.3f MHz', app.specData(ii).Node,     ...
                                                              app.specData(ii).ThreadID, ...
                                                              app.specData(ii).MetaData.FreqStart ./ 1e+6, ...
                                                              app.specData(ii).MetaData.FreqStop  ./ 1e+6);
            
            idx1 = find(strcmp(app.peaksTable.Tag, Tag));
            if ~isempty(idx1)
                PeakTable.FK1(idx1) = uint16(jj);
            end
        end
    end

    % occMethod, detection and classification tables
    for ii = 1:numel(occMethod)
        idx_OCC = find(strcmp(app.peaksTable.occMethod, occMethod(ii)));

        if ~isempty(idx_OCC); PeakTable.FK2(idx_OCC) = uint16(ii);
        end                
    end

    for ii = 1:numel(Detection)
        idx_Det = find(strcmp(app.peaksTable.Detection, Detection(ii)));

        if ~isempty(idx_Det); PeakTable.FK3(idx_Det) = uint16(ii);
        end
    end

    for ii = 1:numel(Classification)
        idx_Cla = find(strcmp(app.peaksTable.Classification, Classification(ii)));

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