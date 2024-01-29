function [htmlReport, peaksTable] = ReportGenerator(app, idx, reportInfo)

    global ID_img
    global ID_tab

    global ID_imgExt
    global ID_tabExt

    ID_img = 0;
    ID_tab = 0;

    ID_imgExt = 0;
    ID_tabExt = 0;

    htmlReport    = '';
    
    appVersion    = reportInfo.appVersion;
    RootFolder    = reportInfo.General.RootFolder;
    Template      = jsondecode(reportInfo.Model.Template);
    
    SpecInfo      = report.TimeStampFilter(app, idx, reportInfo.TimeStamp);
    exceptionList = app.exceptionList;
    peaksTable    = Fcn_Peaks(app, SpecInfo, reportInfo, exceptionList);    
    
    % HTML header (style)    
    if strcmp(reportInfo.General.Version, 'Preliminar')
        htmlReport = sprintf('%s\n\n', fileread(fullfile(RootFolder, 'Template', 'html_DocumentStyle.txt')));
    end
    tableStyleFlag = 1;

    % HTML body
    for ii = 1:numel(Template)
        if ~ismember(Template(ii).Type, {'Item', 'ItemN1'}) || isempty(Template(ii).Data.Children)
            continue
        else
            htmlReport = sprintf('%s%s', htmlReport, report.ReportGenerator_HTML(Template(ii)));

            if tableStyleFlag
                htmlReport = sprintf('%s%s\n\n', htmlReport, fileread(fullfile(RootFolder, 'Template', 'html_DocumentTableStyle.txt')));
                tableStyleFlag = 0;
            end
        end

        NN = 1;
        if Template(ii).Recurrence
            NN = numel(SpecInfo);
        end

        for jj = 1:NN
            % Insere uma quebra de linha, caso exista recorrência no item
            % (iterando SpecInfo).
            if jj > 1
                htmlReport = sprintf('%s%s', htmlReport, report.ReportGenerator_HTML(struct('Type', 'Paragraph', 'Data', struct('Editable', 'false', 'String', '&nbsp;'))));
            end

            for kk = 1:numel(Template(ii).Data.Children)
                % Children é uma estrutura com os campos "Type" e "Data". Se o 
                % campo "Type" for igual a "Image" ou "Table" e ocorrer um erro 
                % na leitura de uma imagem ou tabela externa, por exemplo, o erro 
                % retornado terá o formato "Configuration file error message: %s". 
                % Esse "%s" é uma mensagem JSON (e por isso deve ser deserializada) 
                % de um componente HTML textual ("Subitem" ou "Paragraph", por 
                % exemplo).
                Children = Template(ii).Data.Children(kk);

                try
                    switch Children.Type
                        case {'Subitem', 'ItemN2', 'ItemN3', 'Paragraph', 'List', 'Footnote'}
                            for ll = 1:numel(Children.Data)
                                if ~isempty(Children.Data(ll).Settings)
                                    Children.Data(ll).String = Fcn_FillWords(SpecInfo, jj, reportInfo, Children);
                                end
                            end

                            htmlReport = sprintf('%s%s', htmlReport, report.ReportGenerator_HTML(Children));

                        case 'Image'
                            opt2 = Children.Data.Intro;
                            opt3 = Children.Data.Error;
                            opt4 = Children.Data.LineBreak;

                            plotType   = Children.Data.Type;
                            plotName   = strsplit(Children.Data.Source, '+');
                            plotLayout = str2double(strsplit(Children.Data.Layout, ':'));

                            plotInfo   = arrayfun(@(x, y) struct('Name', x, 'Layout', y), plotName, plotLayout);                                        

                            switch plotType
                                case 'Emission'
                                    MM = height(SpecInfo(jj).UserData.Emissions);
                                    for ll = 1:MM
                                        reportInfo.General.Parameters.Plot      = struct('Type', 'Emission', 'emissionIndex', ll);
                                        reportInfo.General.Parameters.DriveTest = SpecInfo(jj).UserData.Emissions.UserData{ll};

                                        % Verifica se o plot requerido é apenas DriveTest... em sendo,
                                        % evita a criação do subtítulo da emissão, caso não tenha
                                        % informação de DriveTest.
                                        if (numel(plotInfo) == 1) && strcmp(plotInfo.Name, 'DriveTest')
                                            if isempty(SpecInfo(jj).UserData.Emissions.UserData{ll})
                                                continue
                                            end
                                        end

                                        % Cabeçalho da emissão...
                                        emissionTitle = struct('Type', 'ItemN3',                                                ...
                                                               'Data', struct('Editable', false,                                ...
                                                                              'String',   '%s',                                 ...
                                                                              'Settings', struct('Source',     'emissionTitle', ...
                                                                                                 'Precision',  '%s',            ...
                                                                                                 'Multiplier', 1)));
                                        emissionTitle.Data.String = Fcn_FillWords(SpecInfo, jj, reportInfo, emissionTitle);                        
                                        htmlReport = sprintf('%s%s', htmlReport, report.ReportGenerator_HTML(emissionTitle));

                                        opt1 = Fcn_Image(SpecInfo, jj, reportInfo, Template(ii).Recurrence, Children, plotInfo);
                                        htmlReport = HTMLReport(htmlReport, Children, opt1, opt2, opt3, opt4);
                                    end

                                otherwise % 'Band' e imagens externas...
                                    reportInfo.General.Parameters.Plot = struct('Type', 'Band', 'emissionIndex', -1);
                                    
                                    opt1 = Fcn_Image(SpecInfo, jj, reportInfo, Template(ii).Recurrence, Children, plotInfo);
                                    htmlReport = HTMLReport(htmlReport, Children, opt1, opt2, opt3, opt4);
                            end

                        case 'Table'
                            opt1 = Fcn_Table(SpecInfo, jj, reportInfo, peaksTable, exceptionList, Template(ii).Recurrence, Children);
                            opt2 = Children.Data.Intro;
                            opt3 = Children.Data.Error;
                            opt4 = Children.Data.LineBreak;
                            
                            htmlReport = HTMLReport(htmlReport, Children, opt1, opt2, opt3, opt4);

                        otherwise
                            error('Unexpected type "%s"', Children.Type)
                    end

                catch ME
                    msgError = extractAfter(ME.message, 'Configuration file error message: ');

                    if ~isempty(msgError)
                        msgError   = jsondecode(msgError);
                        htmlReport = sprintf('%s%s', htmlReport, report.ReportGenerator_HTML(struct('Type', msgError.Type, 'Data', struct('Editable', 'false', 'String', msgError.String))));
                    end
                end
            end
        end
    end

    % HTML footnotes    
    LineBreak = report.ReportGenerator_HTML(struct('Type', 'Paragraph', 'Data', struct('Editable', 'false', 'String', '&nbsp;')));
    Separator = report.ReportGenerator_HTML(struct('Type', 'Footnote',  'Data', struct('Editable', 'false', 'String', repmat('_', 1, 45))));

    Footnote1 = sprintf('<b>appAnalise</b> v. %s, <b>fiscaliza</b> v. %s, <b>RFDataHub</b> %s', appVersion.(class.Constants.appName).Version, appVersion.fiscaliza, appVersion.RFDataHub.ReleaseDate);
    Footnote2 = sprintf('<b>Relatório</b>: %s',      jsonencode(reportInfo.Model.Type));
    Footnote3 = sprintf('<b>Imagem</b>: %s',         jsonencode(rmfield(reportInfo.General.Image, 'Visibility')));
    Footnote4 = sprintf('<b>Matlab</b> v. %s, %s',   appVersion.Matlab.Version, appVersion.Matlab.Products);
    Footnote5 = '';
    try
        Footnote5 = sprintf('<b>Python</b> v. %s',   appVersion.Python.Version);
    catch
    end
    
    Footnote1_html = report.ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote1)));
    Footnote2_html = report.ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote2)));
    Footnote3_html = report.ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote3)));
    Footnote4_html = report.ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote4)));
    Footnote5_html = report.ReportGenerator_HTML(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'String', Footnote5)));

    htmlReport = sprintf('%s%s%s%s%s%s%s%s%s', htmlReport, LineBreak, Separator, Footnote1_html, Footnote2_html, Footnote3_html, Footnote4_html, Footnote5_html, LineBreak);

    % HTML trailer
    if reportInfo.General.Version == "Preliminar"
        htmlReport = sprintf('%s</body>\n</html>', htmlReport);
    end

end


%-------------------------------------------------------------------------%
function htmlReport = HTMLReport(htmlReport, Children, opt1, opt2, opt3, opt4)
    htmlReport = sprintf('%s%s', htmlReport, report.ReportGenerator_HTML(Children, {opt1, opt2, opt3, opt4}));
end


%-------------------------------------------------------------------------%
function String = Fcn_FillWords(SpecInfo, idx, reportInfo, Children)

    for ii = 1:numel(Children.Data.Settings)
        Precision  = string(Children.Data.Settings(ii).Precision);
        Source     = Children.Data.Settings(ii).Source;
        Multiplier = Children.Data.Settings(ii).Multiplier;

        FillWords(ii) = sprintf(Precision, Fcn_Source(SpecInfo, idx, reportInfo, struct('Source', Source, 'Multiplier', Multiplier)));
    end

    String = sprintf(Children.Data.String, FillWords);
end


%-------------------------------------------------------------------------%
function value = Fcn_Source(SpecInfo, idx, reportInfo, Children)

    Source     = Children.Source;
    Multiplier = Children.Multiplier;

    switch Source
        case 'idx';              value = idx;
        case 'ID';               value = Multiplier;
        case 'Issue';            value = reportInfo.Issue;
        case 'Image';            value = jsonencode(rmfield(reportInfo.General.Image, 'Visibility'));
        case 'Template';         value = jsonencode(reportInfo.Model.Type);
        case 'Node';             value = SpecInfo(idx).Receiver;
        case 'ThreadID';         value = SpecInfo(idx).RelatedFiles.ID(1);
        case 'MetaData';         value = jsonencode(SpecInfo(idx).MetaData);
        case 'FreqStart';        value = SpecInfo(idx).MetaData.FreqStart * Multiplier;
        case 'FreqStop';         value = SpecInfo(idx).MetaData.FreqStop  * Multiplier;
        case 'StepWidth';        value = ((SpecInfo(idx).MetaData.FreqStop - SpecInfo(idx).MetaData.FreqStart) / (SpecInfo(idx).MetaData.DataPoints - 1)) * Multiplier;
        case 'Samples';          value = numel(SpecInfo(idx).Data{1});
        case 'DataPoints';       value = SpecInfo(idx).MetaData.DataPoints;
        case 'BeginTime';        value = char(SpecInfo(idx).Data{1}(1));
        case 'EndTime';          value = char(SpecInfo(idx).Data{1}(end));
        case 'minLevel';         value = sprintf('%.1f %s', min(SpecInfo(idx).Data{3}(:,1)), SpecInfo(idx).MetaData.LevelUnit);
        case 'maxLevel';         value = sprintf('%.1f %s', max(SpecInfo(idx).Data{3}(:,3)), SpecInfo(idx).MetaData.LevelUnit);
        case 'TaskName';         value = SpecInfo(idx).RelatedFiles.Task{1};
        case 'Description';      value = SpecInfo(idx).RelatedFiles.Description{1};
        case 'RelatedFiles';     value = strjoin(SpecInfo(idx).RelatedFiles.File, ', ');
        case 'GPS';              value = jsonencode(SpecInfo(idx).GPS);
        case 'Latitude';         value = SpecInfo(idx).GPS.Latitude;
        case 'Longitude';        value = SpecInfo(idx).GPS.Longitude;
        case 'Location';         value = SpecInfo(idx).GPS.Location;
        case 'RelatedLocations'; value = strjoin(unique(arrayfun(@(x) x.GPS.Location, SpecInfo, 'UniformOutput', false)), ', ');
        case 'Parameters'
            Operation = '-';
            if ~isempty(SpecInfo(idx).MetaData.TraceMode) 
                TraceIntegration = '';
                if SpecInfo(idx).MetaData.TraceIntegration ~= -1
                    TraceIntegration = sprintf(' (Integração: %d amostras)', SpecInfo(idx).MetaData.TraceIntegration);
                end

                if ~isempty(SpecInfo(idx).MetaData.Detector)
                    Operation = sprintf('%s/%s%s', SpecInfo(idx).MetaData.TraceMode, SpecInfo(idx).MetaData.Detector, TraceIntegration);
                else
                    Operation = sprintf('%s%s', SpecInfo(idx).MetaData.TraceMode, TraceIntegration);
                end

            elseif ~isempty(SpecInfo(idx).MetaData.Detector)
                Operation = SpecInfo(idx).MetaData.Detector;
            end

            Resolution = '';
            if SpecInfo(idx).MetaData.Resolution ~= -1
                Resolution = sprintf('; Resolução: %.3f kHz', SpecInfo(idx).MetaData.Resolution/1000);
            end

            VBW = '';
            if SpecInfo(idx).MetaData.VBW ~= -1
                VBW = sprintf('; Resolução de vídeo (VBW): %.3f kHz', SpecInfo(idx).MetaData.VBW/1000);
            end

            value = sprintf('GPS: %.6f, %.6f (%s); Operação: %s; Unidade: %s%s%s', ...
                            SpecInfo(idx).GPS.Latitude,       ...
                            SpecInfo(idx).GPS.Longitude,      ...
                            SpecInfo(idx).GPS.Location,       ...
                            Operation,                        ...
                            SpecInfo(idx).MetaData.LevelUnit, ...
                            Resolution, VBW);

        case 'emissionTitle'
            emissionIndex = reportInfo.General.Parameters.Plot.emissionIndex;
            value = sprintf('<b>Emissão %d: %.3f MHz ⌂ %.1f kHz</b>', emissionIndex, SpecInfo(idx).UserData.Emissions{emissionIndex,2}, SpecInfo(idx).UserData.Emissions{emissionIndex,3});
    end
end


%-------------------------------------------------------------------------%
function peaksTable = Fcn_Peaks(app, SpecInfo, reportInfo, exceptionList)

    peaksTable = [];

    for ii = 1:numel(SpecInfo)
        Peaks = report.ReportGenerator_Peaks(app, SpecInfo, ii, reportInfo);

        if ~isempty(Peaks)
            if isempty(peaksTable); peaksTable = Peaks;
            else;                   peaksTable = [peaksTable; Peaks];
            end
        end

        Peaks = Fcn_exceptionList(Peaks, exceptionList);
        SpecInfo(ii).UserData.reportPeaksTable = Peaks;
    end
end


%-------------------------------------------------------------------------%
function Peaks = Fcn_exceptionList(Peaks, exceptionList)

    if ~isempty(Peaks)
        % Itera em relação à lista de exceções...
        for ii = 1:height(exceptionList)
            Tag       = exceptionList.Tag{ii};
            Frequency = exceptionList.Frequency(ii);

            % Identifica registros das duas tabelas - peaksTable e exceptionList 
            % - que possuem a mesma "Tag" e a mesma "Frequency".    
            idx = find(strcmp(Peaks.Tag, Tag) & (abs(Peaks.Frequency-Frequency) <= class.Constants.floatDiffTolerance));

            if numel(idx) == 1
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

        % Itera em relação à lista de emissões, buscando aquelas que foram
        % incluídas por arquivo.
        fileDetectionIndex = find(contains(Peaks.Detection, '"Algorithm":"ExternalFile"'))';
        for ii = fileDetectionIndex
            fileDetectionInfo = jsondecode(Peaks.Detection{ii});
            Peaks.Description{ii} = sprintf('%s <p class="Tabela_Texto_8" contenteditable="false" style="color: #808080;">(%s)', Peaks.Description{ii}, fileDetectionInfo.Description); 
        end
    end
end


%-------------------------------------------------------------------------%
function Image = Fcn_Image(SpecInfo, idx, reportInfo, Recurrence, Children, plotInfo)

    global ID_imgExt

    Image = '';
    switch Children.Data.Origin
        case 'Internal'
            Image = plotFcn.axesDraw.plot2report(SpecInfo(idx), reportInfo, plotInfo);

        case 'External'
            if Recurrence
                Image     = SpecInfo(idx).UserData.reportAttachments.image;
            else
                ID_imgExt = ID_imgExt+1;    
                try
                    Image = reportInfo.Attachments.image{ID_imgExt};
                catch
                    ID_imgExt = ID_imgExt-1;
                end
            end
    end

    if ~isfile(Image)
        error('Configuration file error message: %s', Children.Data.Error)
    end
end


%-------------------------------------------------------------------------%
function Table = Fcn_Table(SpecInfo, idx, reportInfo, peaksTable, exceptionList, Recurrence, Children)

    global ID_tabExt
    
    Origin = Children.Data.Origin;
    if Origin == "Internal"
        Source = Children.Data.Source;

    else
        if Recurrence
            Source    = SpecInfo(idx).UserData.reportAttachments.table.Source;
            SheetID   = SpecInfo(idx).UserData.reportAttachments.table.SheetID;
        else
            ID_tabExt = ID_tabExt+1;

            try
                Source    = reportInfo.Attachments.table{ID_tabExt}.Source;
                SheetID   = reportInfo.Attachments.table{ID_tabExt}.SheetID;
            catch
                Source    = [];
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
                    Table = report.ReportGenerator_Table_Algorithm(SpecInfo, idx);
        
                    for ii = 1:numel(Table.Properties.VariableNames)
                        Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).String;
                    end
        
                case 'Peaks'
                    if ~isempty(SpecInfo(idx).UserData.reportPeaksTable)                        
                        Table       = SpecInfo(idx).UserData.reportPeaksTable;
                        Table.ID(:) = string(1:height(Table)');
                        Table       = movevars(Table, 'ID', 'Before', 1);
                        
                        % FILTRO
                        if ~isempty(Children.Data.Filter)
                            ind_Field = find(strcmp(Children.Data.Filter.Column, Table.Properties.VariableNames), 1);
                            ind_Value = strcmp(Table{:,ind_Field}, Children.Data.Filter.Value);
        
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
                                Table.Properties.VariableNames{ii} = sprintf('%s (%s)', Table.Properties.VariableNames{ii}, SpecInfo(idx).MetaData.LevelUnit);
                            end
                        end
                    end
        
                case 'Summary'        
                    if ~isempty(peaksTable)
                        infoTable = report.ReportGenerator_Table_Summary(peaksTable, exceptionList);
        
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
                    MM = numel(SpecInfo);
                    
                    % Povoa a tabela.ReportGenerator_HTML
                    Table = table('Size', [MM, NN],               ...
                                  'VariableTypes', VariableTypes, ...
                                  'VariableNames', VariableNames);
        
                    ll = 0;
                    for jj = 1:MM
                        if ismember(SpecInfo(jj).MetaData.DataType, class.Constants.specDataTypes)
                            ll = ll+1;
        
                            for kk = 1:NN
                                Source = Children.Data.Columns{kk};
                                if Source == "ID"; Multiplier = ll;
                                else;              Multiplier = 1;
                                end                        
        
                                Table(ll,kk) = {Fcn_Source(SpecInfo, jj, reportInfo, struct('Source', Source, 'Multiplier', Multiplier))};
                            end
                        end
                    end
        
                    for ii = 1:numel(Table.Properties.VariableNames)
                        Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).String;
                    end
            end

        case 'External'
            Columns = Children.Data.Columns;

            [~, ~, fileExt] = fileparts(Source);
            switch lower(fileExt)
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