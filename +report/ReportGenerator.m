function [htmlReport, peaksTable] = ReportGenerator(Data, reportInfo, exceptionList)

    global specData
    
    global ID_img
    global ID_tab

    global ID_imgExt
    global ID_tabExt

    ID_img = 0;
    ID_tab = 0;

    ID_imgExt = 0;
    ID_tabExt = 0;

    appVersion = reportInfo.appVersion;
    specData   = Misc_TimeStampFilter(Data, reportInfo.TimeStamp, 1);
    RootFolder = reportInfo.General.RootFolder;

    Template   = jsondecode(reportInfo.Model.Template);
    
    htmlReport = '';
    peaksTable = Fcn_Peaks(reportInfo, exceptionList);
    
    % HTML header (style)    
    if reportInfo.General.Version == "Preliminar"
        htmlReport = sprintf('%s\n\n', fileread(fullfile(RootFolder, 'Template', 'html_DocumentStyle.txt')));
    end
    tableStyleFlag = 1;

    % HTML body
    for ii = 1:numel(Template)
        if (Template(ii).Type ~= "Item") || isempty(Template(ii).Data.Children)
            continue
        else
            htmlReport = sprintf('%s%s', htmlReport, ReportGenerator_HTML(Template(ii)));

            if tableStyleFlag
                htmlReport = sprintf('%s%s\n\n', htmlReport, fileread(fullfile(RootFolder, 'Template', 'html_DocumentTableStyle.txt')));
                tableStyleFlag = 0;
            end
        end

        NN = 1;
        if Template(ii).Recurrence
            NN = Fcn_Threads;
        end
        
        jj = 0;
        kk = 0;
        while kk < NN
            jj = jj+1;

            if Template(ii).Recurrence && ~ismember(specData(jj).MetaData.DataType, class.Constants.specDataTypes)
                continue
            else
                kk = kk+1;
            end

            if jj > 1
                htmlReport = sprintf('%s%s', htmlReport, ReportGenerator_HTML(struct('Type', 'Paragraph', 'Data', struct('Editable', 'false', 'String', '&nbsp;'))));
            end

            for ll = 1:numel(Template(ii).Data.Children)
                Children = Template(ii).Data.Children(ll);
    
                msgError = '';
                try
                    switch Children.Type
                        case {'Subitem', 'Paragraph', 'List', 'Footnote'}
                            opt1 = [];
                            opt2 = '';
                            opt3 = '';
                            opt4 = [];
                
                            for mm = 1:numel(Children.Data)
                                if ~isempty(Children.Data(mm).Settings)
                                    Children.Data(mm).String = Fcn_FillWords(Children, reportInfo, jj);
                                end
                            end

                        otherwise
                            if     Children.Type == "Image"; opt1 = Fcn_Image(Template(ii).Recurrence, Children, reportInfo, jj);
                            elseif Children.Type == "Table"; opt1 = Fcn_Table(Template(ii).Recurrence, Children, reportInfo, peaksTable, exceptionList, jj);
                            end

                            opt2 = Children.Data.Intro;
                            opt3 = Children.Data.Error;
                            opt4 = Children.Data.LineBreak;
                    end

                catch ME
                    msgError = ME.message; 
                end

                if isempty(msgError)
                    htmlReport = sprintf('%s%s', htmlReport, ReportGenerator_HTML(Children, {opt1, opt2, opt3, opt4}));
                else
                    msgError = extractAfter(ME.message, 'Configuration file error message: ');

                    if ~isempty(msgError)
                        msgError   = jsondecode(msgError);
                        htmlReport = sprintf('%s%s', htmlReport, ReportGenerator_HTML(struct('Type', msgError.Type, 'Data', struct('Editable', 'false', 'String', msgError.String))));
                    end
                end
            end
        end
    end

    % HTML footnotes    
    LineBreak = ReportGenerator_HTML(struct('Type', 'Paragraph', 'Data', struct('Editable', 'false', 'String', '&nbsp;')));
    Separator = ReportGenerator_HTML(struct('Type', 'Footnote',  'Data', struct('Editable', 'false', 'String', repmat('_', 1, 45))));

    Footnote1 = sprintf('<b>appAnalise</b> v. %s, <b>fiscaliza</b> v. %s, <b>anateldb</b> %s', appVersion.appAnalise.Version, appVersion.fiscaliza, appVersion.anateldb.ReleaseDate);
    Footnote2 = sprintf('<b>Bases de dados</b>: %s', jsonencode(rmfield(appVersion.anateldb, 'ReleaseDate')));
    Footnote3 = sprintf('<b>Relatório</b>: %s',      jsonencode(reportInfo.Model.Type));
    Footnote4 = sprintf('<b>Imagem</b>: %s',         jsonencode(rmfield(reportInfo.General.Image, 'Visibility')));
    Footnote5 = sprintf('<b>Matlab</b> v. %s, %s',   appVersion.Matlab.Version, appVersion.Matlab.Products);
    Footnote6 = '';
    try
        Footnote6 = sprintf('<b>Python</b> v. %s',   appVersion.Python.Version);
    catch
    end
    
    Footnote1_html = ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote1)));
    Footnote2_html = ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote2)));
    Footnote3_html = ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote3)));
    Footnote4_html = ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote4)));
    Footnote5_html = ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote5)));
    Footnote6_html = ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote6)));

    htmlReport = sprintf('%s%s%s%s%s%s%s%s%s%s', htmlReport, LineBreak, Separator, Footnote1_html, Footnote2_html, Footnote3_html, Footnote4_html, Footnote5_html, Footnote6_html, LineBreak);

    % HTML trailer
    if reportInfo.General.Version == "Preliminar"
        htmlReport = sprintf('%s</body>\n</html>', htmlReport);
    end

end


%-------------------------------------------------------------------------%
function MM = Fcn_Threads

    global specData

    MM = 0;
    for ii = 1:numel(specData)
        if ismember(specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            MM = MM+1;
        end
    end

end


%-------------------------------------------------------------------------%
function String = Fcn_FillWords(Children, reportInfo, idx)

    for ii = 1:numel(Children.Data.Settings)
        Precision  = string(Children.Data.Settings(ii).Precision);
        Source     = Children.Data.Settings(ii).Source;
        Multiplier = Children.Data.Settings(ii).Multiplier;

        FillWords(ii) = sprintf(Precision, Fcn_Source(struct('Source', Source, 'Multiplier', Multiplier), reportInfo, idx));
    end

    String = sprintf(Children.Data.String, FillWords);

end


%-------------------------------------------------------------------------%
function value = Fcn_Source(Children, reportInfo, idx)

    global specData

    Source     = Children.Source;
    Multiplier = Children.Multiplier;

    switch Source
        case 'idx';          value = idx;
        case 'ID';           value = Multiplier;
        case 'Issue';        value = reportInfo.Issue;
        case 'Image';        value = jsonencode(rmfield(reportInfo.General.Image, 'Visibility'));
        case 'Template';     value = jsonencode(reportInfo.Model.Type);
        case 'Node';         value = specData(idx).Receiver;
        case 'ThreadID';     value = specData(idx).RelatedFiles.ID(1);
        case 'MetaData';     value = jsonencode(specData(idx).MetaData);
        case 'FreqStart';    value = specData(idx).MetaData.FreqStart * Multiplier;
        case 'FreqStop';     value = specData(idx).MetaData.FreqStop  * Multiplier;
        case 'StepWidth';    value = ((specData(idx).MetaData.FreqStop - specData(idx).MetaData.FreqStart) / (specData(idx).MetaData.DataPoints - 1)) * Multiplier;
        case 'Samples';      value = numel(specData(idx).Data{1});
        case 'DataPoints';   value = specData(idx).MetaData.DataPoints;
        case 'BeginTime';    value = datestr(specData(idx).Data{1}(1),   'dd/mm/yyyy HH:MM:SS');
        case 'EndTime';      value = datestr(specData(idx).Data{1}(end), 'dd/mm/yyyy HH:MM:SS');
        case 'minLevel';     value = sprintf('%.1f %s', min(specData(idx).statsData(:,1)), specData(idx).MetaData.LevelUnit);
        case 'maxLevel';     value = sprintf('%.1f %s', max(specData(idx).statsData(:,4)), specData(idx).MetaData.LevelUnit);
        case 'TaskName';     value = specData(idx).RelatedFiles.Task{1};
        case 'Description';  value = specData(idx).RelatedFiles.Description{1};
        case 'RelatedFiles'; value = strjoin(specData(idx).RelatedFiles.File, ', ');
        case 'gps';          value = jsonencode(specData(idx).GPS);
        case 'Latitude';     value = specData(idx).GPS.Latitude;
        case 'Longitude';    value = specData(idx).GPS.Longitude;
        case 'Location';     value = specData(idx).GPS.Location;
        
        case 'RelatedLocations'
            value = {};
            for ii = 1:numel(specData)
                if ismember(specData(ii).MetaData.DataType, class.Constants.specDataTypes)
                    value{end+1} = specData(ii).GPS.Location;
                end
            end

            value = char(strjoin(unique(value), ', '));

        case 'Parameters'
            if ~isempty(specData(idx).MetaData.TraceMode) && ~isempty(specData(idx).MetaData.Detector)
                Operation = sprintf('%s/%s', specData(idx).MetaData.TraceMode, specData(idx).MetaData.Detector);
            elseif ~isempty(specData(idx).MetaData.TraceMode)
                Operation = specData(idx).MetaData.TraceMode;
            elseif ~isempty(specData(idx).MetaData.Detector)
                Operation = specData(idx).MetaData.Detector;
            else
                Operation = '-';
            end

            if ~isempty(specData(idx).MetaData.Resolution)
                Resolution = specData(idx).MetaData.Resolution;
            else
                Resolution = '-';
            end

            value = sprintf('GPS: %.6f, %.6f (%s); Operação: %s; Unidade: %s; %s', specData(idx).GPS.Latitude,           ...
                                                                                   specData(idx).GPS.Longitude,          ...
                                                                                   specData(idx).GPS.Location,           ...
                                                                                   Operation,                            ...
                                                                                   specData(idx).MetaData.LevelUnit, ...
                                                                                   Resolution);
    end

end


%-------------------------------------------------------------------------%
function peaksTable = Fcn_Peaks(reportInfo, exceptionList)

    global specData

    peaksTable = [];
    RootFolder = reportInfo.General.RootFolder;

    for ii = 1:numel(specData)
        if ismember(specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            if isempty(specData(ii).reportOCC.Index)
                ReportGenerator_OCC(ii)
            end

            Peaks = ReportGenerator_Peaks(specData(ii), RootFolder);

            if ~isempty(Peaks)
                if isempty(peaksTable); peaksTable = Peaks;
                else;                   peaksTable(end+1:end+height(Peaks),:) = Peaks;
                end
            end

            Peaks = Fcn_exceptionList(Peaks, exceptionList);

            specData(ii).Peaks = Peaks;
        end
    end

end


%-------------------------------------------------------------------------%
function Peaks = Fcn_exceptionList(Peaks, exceptionList)

    if ~isempty(Peaks)
        for ii = 1:height(exceptionList)
            Tag       = exceptionList.Tag{ii};
            Frequency = exceptionList.Frequency(ii);
    
            idx = intersect(find(strcmp(Peaks.Tag, Tag)), ...
                            find(abs(Peaks.Frequency - Frequency) <= 1e-5));
    
            if ~isempty(idx) && (numel(idx) == 1)
                if Peaks.Description{idx} == "-"
                    Description = sprintf('<font style="color: #ff0000;">%s</font>', exceptionList.Description{ii});
                    Distance    = sprintf('<font style="color: #ff0000;">%s</font>', exceptionList.Distance{ii});
                else
                    Description = sprintf('<del>%s</del></p> <p class="Tabela_Texto_8" contenteditable="false" style="color: #ff0000;">%s', Peaks.Description{idx}, exceptionList.Description{ii});
                    Distance    = sprintf('<del>%s</del></p> <p class="Tabela_Texto_8" contenteditable="false" style="color: #ff0000;">%s', Peaks.Distance{idx},    exceptionList.Distance{ii});
                end
    
                Peaks(idx, 13:20)      = exceptionList(ii, 3:10);
                Peaks.Description{idx} = Description;
                Peaks.Distance{idx}    = Distance;
            end
        end
    end

end


%-------------------------------------------------------------------------%
function Image = Fcn_Image(Recurrence, Children, reportInfo, idx)

    global specData
    global ID_imgExt

    Origin = Children.Data.Origin;    
    if Origin == "Internal"
        Source = Children.Data.Source;
        Layout = Children.Data.Layout;

    else
        if Recurrence
            Source    = specData(idx).reportAttachments.image;
        else
            ID_imgExt = ID_imgExt+1;

            try
                Source = reportInfo.Attachments.image{ID_imgExt};
            catch
                ID_imgExt = ID_imgExt-1;
            end
        end
    end

    if isempty(Source) || ((Origin == "External") & ~isfile(Source))
        error('Configuration file error message: %s', Children.Data.Error)
    end

    Image = '';
    switch Origin
        case 'Internal'
            switch Source
                case 'specImage'
                    Image = ReportGenerator_Plot(idx, reportInfo, Layout);

                case 'Drive-Test'
                    Image = ReportGenerator_DriveTest(idx, reportInfo, Layout);

                case 'Histogram'
                    % Pendente                    
            end

        case 'External'
            Image = Source;
    end

end


%-------------------------------------------------------------------------%
function Table = Fcn_Table(Recurrence, Children, reportInfo, peaksTable, exceptionList, idx)

    global specData
    global ID_tabExt
    
    Origin = Children.Data.Origin;
    if Origin == "Internal"
        Source = Children.Data.Source;

    else
        if Recurrence
            Source    = specData(idx).reportAttachments.table.Source;
            SheetID   = specData(idx).reportAttachments.table.SheetID;
        else
            ID_tabExt = ID_tabExt+1;

            try
                Source  = reportInfo.Attachments.table{ID_tabExt}.Source;
                SheetID = reportInfo.Attachments.table{ID_tabExt}.SheetID;
            catch 
                ID_tabExt = ID_tabExt-1;
            end
        end
    end

    if isempty(Source) || ((Origin == "External") & ~isfile(Source))
        error('Configuration file error message: %s', Children.Data.Error)
    end

    Table = [];
    switch Origin
        case 'Internal'
            switch Source
                case 'Algorithms'
                    Table = ReportGenerator_Table_Algorithm(specData, idx);
        
                    for ii = 1:numel(Table.Properties.VariableNames)
                        Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).String;
                    end
        
                case 'Peaks'
                    if ~isempty(specData(idx).Peaks)
                        specData(idx).Peaks.ID(:) = "P" + string(1:height(specData(idx).Peaks)');
                        specData(idx).Peaks       = movevars(specData(idx).Peaks, 'ID', 'Before', 1);
                        
                        Table = specData(idx).Peaks;
                        
                        % FILTRO
                        if ~isempty(Children.Data.Filter)
                            ind_Field = find(strcmp(Children.Data.Filter.Column, specData(idx).Peaks.Properties.VariableNames), 1);
                            ind_Value = strcmp(specData(idx).Peaks{:,ind_Field}, Children.Data.Filter.Value);
        
                            Table(~ind_Value,:) = [];
                        end
        
                        % COLUNAS VAZIAS EDITÁVEIS
                        ind_Empty = cellfun(@(x) strcmp(x, 'EmptyColumn'), Children.Data.Columns);
        
                        % COLUNAS DE PEAKSTABLE
                        ind_Peaks = cellfun(@(x) find(strcmp(x, Table.Properties.VariableNames)), Children.Data.Columns(~ind_Empty));
                        Table = Table(:,ind_Peaks);
        
                        % CRIAÇÃO DE TABELA COM AS COLUNAS VAZIAS EDITÁVEIS 
                        % (caso aplicável)
                        if ~isempty(ind_Empty)
                            EmptyTable = table('Size', [height(Table), sum(ind_Empty)], ...
                                               'VariableTypes', repmat({'cell'}, 1, sum(ind_Empty)));
            
                            for ii = 1:width(EmptyTable)
                                EmptyTable{:,ii} = repmat({'-'}, height(Table), 1);
                            end
            
                            Table = [Table, EmptyTable];
                        end
        
                        % AJUSTE DA POSIÇÃO DAS COLUNAS VAZIAS EDITÁVEIS
                        jj = 0;
                        for ii = find(ind_Empty)'
                            jj = jj+1;
                            Table = movevars(Table, sprintf('Var%.0f', jj), 'Before', ii);                    
                        end
        
                        % AJUSTE DOS NOMES DAS COLUNAS
                        for ii = 1:numel(Table.Properties.VariableNames)
                            Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).String;
        
                            if ismember(Children.Data.Columns{ii}, ["minLevel", "meanLevel", "maxLevel"])
                                Table.Properties.VariableNames{ii} = sprintf('%s (%s)', Table.Properties.VariableNames{ii}, specData(idx).MetaData.metaString{1});
                            end
                        end
                    end
        
                case 'Summary'        
                    if ~isempty(peaksTable)
                        infoTable = ReportGenerator_Table_Summary(peaksTable, exceptionList);
        
                        % COLUNAS DE INFOTABLE
                        ind_Peaks = cellfun(@(x) find(strcmp(x, infoTable.Properties.VariableNames)), Children.Data.Columns);
                        Table = infoTable(:,ind_Peaks);
        
                        % AJUSTE DOS NOMES DAS COLUNAS
                        for ii = 1:numel(Table.Properties.VariableNames)
                            Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).String;
                        end
                    end
        
                case 'specData'
                    NN = numel(Children.Data.Settings);
        
                    VariableTypes = {};
                    VariableNames = {};
        
                    % Identifica tipos e nomes das colunas.
                    for ii = 1:NN
                        Precision = regexp(Children.Data.Settings(ii).Precision, "\w*%(s|.[013]f)\w*", "match");
        
                        if Precision == "%s"
                            VariableTypes(end+1) = {'cell'};
        
                        elseif ismember(Precision, ["%.0f", "%.1f", "%.3f"])
                            VariableTypes(end+1) = {'double'};
        
                        end
                        VariableNames{end+1} = Children.Data.Settings(ii).String;
                    end
        
                    % Identifica quantidade de fluxos de espectro.
                    MM = Fcn_Threads;
                    
                    % Povoa a tabela.ReportGenerator_HTML
                    Table = table('Size', [MM, NN],               ...
                                  'VariableTypes', VariableTypes, ...
                                  'VariableNames', VariableNames);
        
                    ll = 0;
                    for jj = 1:numel(specData)
                        if ismember(specData(jj).MetaData.DataType, class.Constants.specDataTypes)
                            ll = ll+1;
        
                            for kk = 1:NN
                                Source = Children.Data.Columns{kk};
                                if Source == "ID"; Multiplier = ll;
                                else;              Multiplier = 1;
                                end                        
        
                                Table(ll,kk) = {Fcn_Source(struct('Source', Source, 'Multiplier', Multiplier), reportInfo, jj)};
                            end
                        end
                    end
        
                    for ii = 1:numel(Table.Properties.VariableNames)
                        Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).String;
                    end
            end

        case 'External'
            Columns = Children.Data.Columns;

            [~, ~, ext] = fileparts(Source);
            switch ext
                case '.json'
                    Table = struct2table(jsondecode(fileread(Source)));

                case {'.xls', '.xlsx'}
                    Table = readtable(Source, "VariableNamingRule", "preserve", "Sheet", SheetID);

                otherwise
                    Table = readtable(Source, "VariableNamingRule", "preserve");
            end

            Table = Table(:,Columns);

            for ii = 1:numel(Table.Properties.VariableNames)
                Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).String;
            end
    end

end