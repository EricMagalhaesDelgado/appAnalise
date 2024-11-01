function [htmlReport, peaksTable] = ReportGenerator(app, idxThreads, reportInfo, progressDialog)
    
    global hContainer

    if nargin == 3
        progressDialog = [];
    end

    internalFcn_counterCreation()
    
    exceptionList = app.projectData.exceptionList;
    peaksTable    = report.Peaks(app, idxThreads, reportInfo.DetectionMode, exceptionList);

    tempBandObj   = class.Band('appAnalise:REPORT:BAND', app);
    
    % HTML header (style)
    htmlReport = '';
    if ismember(reportInfo.Model.Version, {'preview', 'Preliminar'})
        docTitle   = reportInfo.Model.Name;
        docType    = reportInfo.Model.DocumentType;
        docStyle   = sprintf(fileread(fullfile(reportLib.Path, 'html', 'docStyle.txt')), docTitle, docType);

        htmlReport = sprintf('%s\n\n', docStyle);
    end
    tableStyleFlag = 1;

    % HTML body
    jsonScript = jsondecode(reportInfo.Model.Script);
    for ii = 1:numel(jsonScript)
        parentNode = jsonScript(ii);

        if isfield(parentNode.Data, 'Variable') && ~isempty(parentNode.Data.Variable)
            parentNode.Data.Text = internalFcn_FillWords(reportInfo, [], parentNode, 1);
        end
        htmlReport = [htmlReport, reportLib.sourceCode.htmlCreation(parentNode)];

        if tableStyleFlag
            htmlReport = sprintf('%s%s\n\n', htmlReport, fileread(fullfile(reportLib.Path, 'html', 'docTableStyle.txt')));
            tableStyleFlag = 0;
        end

        NN = 1;
        if parentNode.Recurrence
            NN = numel(idxThreads);
        end

        for jj = 1:NN
            if parentNode.Recurrence && ~isempty(progressDialog)
                progressDialog.Message = sprintf('<p style="font-size: 12px; text-align: justify;">%d de %d</p>', jj, NN);
            end

            update(tempBandObj, idxThreads(jj));
            reportInfo.General.Parameters.Plot = struct('idxThread',   jj, ...
                                                        'idxChannel',  -1, ...
                                                        'idxEmission', -1);

            % Insere uma quebra de linha, caso exista recorrência no
            % item.
            if jj > 1
                htmlReport = [htmlReport, reportLib.sourceCode.LineBreak];
            end

            htmlReport = [htmlReport, HTMLRenderization(parentNode, app.specData, idxThreads(jj), reportInfo, tempBandObj)];

            % Atualiza barra de progresso... e cancela operação, caso
            % requisitado pelo usuário.
            if parentNode.Recurrence && ~isempty(progressDialog)
                progressDialog.Value = jj/NN;
                if progressDialog.CancelRequested
                    return
                end
            end
        end
    end

    % HTML footnotes
    FootnoteList = fields(reportInfo.Version);
    FootnoteText = '';
        
    for ii = 1:numel(FootnoteList)
        FootnoteVersion = reportInfo.Version.(FootnoteList{ii});

        if ~isempty(FootnoteVersion)
            FootnoteFields = fields(FootnoteVersion);
            
            FootnoteFieldsText = {};
            for jj = 1:numel(FootnoteFields)
                switch FootnoteFields{jj}
                    case 'name'
                        FootnoteFieldsText{end+1} = sprintf('<b>__%s</b>', upper(FootnoteVersion.(FootnoteFields{jj})));
                    otherwise
                        if isstruct(FootnoteVersion.(FootnoteFields{jj}))
                            FootnoteVersion.(FootnoteFields{jj}) = jsonencode(FootnoteVersion.(FootnoteFields{jj}));
                        end

                        FootnoteFieldsText{end+1} = sprintf('<b>%s</b>: %s', FootnoteFields{jj}, FootnoteVersion.(FootnoteFields{jj}));
                end
            end
            FootnoteFieldsText = strjoin(FootnoteFieldsText, ', ');
            FootnoteText       = [FootnoteText, reportLib.sourceCode.htmlCreation(struct('Type', 'Footnote', 'Data', struct('Editable', 'false', 'Text', FootnoteFieldsText, 'Variable', [])))];
        end
    end
    htmlReport = [htmlReport, reportLib.sourceCode.LineBreak, reportLib.sourceCode.Separator, FootnoteText, reportLib.sourceCode.LineBreak];

    % HTML trailer
    if ismember(reportInfo.Model.Version, {'preview', 'Preliminar'})
        htmlReport = sprintf('%s</body>\n</html>', htmlReport);
    end

    if ~isempty(hContainer) && isvalid(hContainer)
        delete(hContainer.Children)
    end

    arrayfun(@(x) eval('x.UserData.reportChannelAnalysis = [];'), app.specData)
end

%-------------------------------------------------------------------------%
function htmlContent = HTMLRenderization(parentNode, specData, idxThread, reportInfo, tempBandObj)
    
    arguments
        parentNode
        specData
        idxThread
        reportInfo
        tempBandObj
    end

    if ~isfield(parentNode, 'Recurrence')
        parentNode.Recurrence = 0;
    end
    
    htmlContent = '';

    for ii = 1:numel(parentNode.Data.Children)
        childNode = parentNode.Data.Children(ii);
        childType = childNode.Type;
    
        try
            switch childType
                case 'Container'
                    htmlTempContent = '';

                    switch childNode.Data.Source
                        case 'Channel'
                            channelBandObj = class.Band('appAnalise:REPORT:CHANNEL', tempBandObj.callingApp);

                            for channelIndex = 1:height(specData(idxThread).UserData.reportChannelTable)
                                if ~specData(idxThread).UserData.reportChannelAnalysis.("Qtd. emissões")(channelIndex)
                                    continue
                                end

                                update(channelBandObj, idxThread, channelIndex);
                                reportInfo.General.Parameters.Plot.idxChannel = channelIndex;

                                htmlTempContent = [htmlTempContent, reportLib.sourceCode.Separator, HTMLRenderization(childNode, specData, idxThread, reportInfo, channelBandObj)];
                            end

                        case 'Emission'
                            emissionBandObj = class.Band('appAnalise:REPORT:EMISSION', tempBandObj.callingApp);

                            for emissionIndex = 1:height(specData(idxThread).UserData.Emissions)
                                update(emissionBandObj, idxThread, emissionIndex);
                                reportInfo.General.Parameters.Plot.idxEmission = emissionIndex;

                                htmlTempContent = [htmlTempContent, reportLib.sourceCode.Separator, HTMLRenderization(childNode, specData, idxThread, reportInfo, emissionBandObj)];
                            end

                        otherwise
                            error('UnexpectedValue')
                    end
    
                case {'ItemN2', 'ItemN3', 'Paragraph', 'List', 'Footnote'}
                    for jj = 1:numel(childNode.Data)
                        if isfield(childNode.Data(jj), 'Variable') && ~isempty(childNode.Data(jj).Variable)
                            childNode.Data(jj).Text = internalFcn_FillWords(specData, idxThread, reportInfo, childNode);
                        end
                    end
    
                    htmlTempContent = reportLib.sourceCode.htmlCreation(childNode);
    
                case 'Image'
                    hFigure    = tempBandObj.callingApp.UIFigure;

                    plotName   = strsplit(childNode.Data.Plot, ':');
                    plotLayout = str2double(strsplit(childNode.Data.Layout, ':'));    
                    plotInfo   = arrayfun(@(x, y) struct('Name', x, 'Layout', y), plotName, plotLayout);
                    
                    Image = Fcn_Image(specData, idxThread, tempBandObj, reportInfo, parentNode.Recurrence, childNode, plotInfo, hFigure);
                    htmlTempContent = reportLib.sourceCode.htmlCreation(childNode, Image);
    
                case 'Table'
                    Table = Fcn_Table(specData, idxThread, reportInfo, tempBandObj.callingApp.projectData.peaksTable, tempBandObj.callingApp.projectData.exceptionList, parentNode.Recurrence, childNode);
                    htmlTempContent = reportLib.sourceCode.htmlCreation(childNode, Table);
    
                otherwise
                    error('Unexpected type "%s"', childType)
            end

            htmlContent = [htmlContent, htmlTempContent];
    
        catch ME
            struct2table(ME.stack)
            msgError = extractAfter(ME.message, 'Configuration file error message: ');
    
            if ~isempty(msgError)
                htmlContent = reportLib.sourceCode.AuxiliarHTMLBlock(htmlContent, 'Error', msgError);
            end
        end
    end
end

%-------------------------------------------------------------------------%
function internalFcn_counterCreation()
    global ID_img
    global ID_imgExt
    global ID_tab    
    global ID_tabExt

    ID_img    = 0;
    ID_imgExt = 0;
    ID_tab    = 0;    
    ID_tabExt = 0;
end

%-------------------------------------------------------------------------%
function Text = internalFcn_FillWords(specData, idxThread, reportInfo, Children)
    for ii = 1:numel(Children.Data.Variable)
        Precision = string(Children.Data.Variable(ii).Precision);
        fieldName = Children.Data.Variable(ii).Source;
        
        try
            FillWords(ii) = sprintf(Precision, Fcn_Source(specData, idxThread, reportInfo, fieldName));
        catch ME
            fieldName
            ME.message
            pause(1)
        end
    end
    
    Text = sprintf(Children.Data.Text, FillWords);
end

%-------------------------------------------------------------------------%
function value = Fcn_Source(specData, idxThread, reportInfo, fieldName)
    arguments
        specData 
        idxThread 
        reportInfo 
        fieldName char {mustBeMember(fieldName, {'Issue',            ...
                                                 'Receiver',         ...
                                                 'Band',             ...
                                                 'FreqStart',        ...
                                                 'FreqStop',         ...
                                                 'StepWidth',        ...
                                                 'ObservationTime',  ...
                                                 'BeginTime',        ...
                                                 'EndTime',          ...
                                                 'RelatedFiles',     ...
                                                 'Location',         ...
                                                 'RelatedLocations', ...
                                                 'Parameters',       ...
                                                 'threadTag',        ...
                                                 'channelTag',       ...
                                                 'emissionTag'})}
    end

    switch fieldName
        case 'Issue'
            value = reportInfo.Issue;        
        case 'Receiver'
            value = specData(idxThread).Receiver;
        case 'Band'
            value = sprintf('%.3f - %.3f MHz', specData(idxThread).MetaData.FreqStart * 1e-6, specData(idxThread).MetaData.FreqStop * 1e-6);
        case 'FreqStart'
            value = specData(idxThread).MetaData.FreqStart * 1e-6;
        case 'FreqStop'
            value = specData(idxThread).MetaData.FreqStop  * 1e-6;
        case 'StepWidth'
            value = ((specData(idxThread).MetaData.FreqStop - specData(idxThread).MetaData.FreqStart) / (specData(idxThread).MetaData.DataPoints - 1)) * 1e-3;
        case 'ObservationTime'
            BeginTime   = specData(idxThread).Data{1}(1);
            EndTime     = specData(idxThread).Data{1}(end);
            nSweeps     = numel(specData(idxThread).Data{1});
            RevisitTime = mean(specData(idxThread).RelatedFiles.RevisitTime);
            value = sprintf('%s - %s<br>%d varreduras<br>%.1f segundos (tempo de revisita estimado)', BeginTime, ...
                                                                                                      EndTime,   ...
                                                                                                      nSweeps,   ...
                                                                                                      RevisitTime);
        case 'BeginTime'
            value = char(specData(idxThread).Data{1}(1));
        case 'EndTime'
            value = char(specData(idxThread).Data{1}(end));        
        case 'RelatedFiles'
            value = strjoin(specData(idxThread).RelatedFiles.File, ', ');        
        case 'Location'
            value = specData(idxThread).GPS.Location;        
        case 'RelatedLocations'
            value = strjoin(unique(arrayfun(@(x) x.GPS.Location, specData, 'UniformOutput', false)), ', ');
        case 'Parameters'
            value = {};

            % Description
            value{end+1} = sprintf('• Descrição: "%s"', specData(idxThread).RelatedFiles.Description{1});
            
            % TraceMode+TraceIntegration+Detector
            if ~isempty(specData(idxThread).MetaData.TraceMode) 
                TraceIntegration = '';
                if specData(idxThread).MetaData.TraceIntegration ~= -1
                    TraceIntegration = sprintf(' (Integração: %d amostras)', specData(idxThread).MetaData.TraceIntegration);
                end

                if ~isempty(specData(idxThread).MetaData.Detector)
                    Operation = sprintf('• Operação: %s/%s%s', specData(idxThread).MetaData.TraceMode, specData(idxThread).MetaData.Detector, TraceIntegration);
                else
                    Operation = sprintf('• Operação: %s%s', specData(idxThread).MetaData.TraceMode, TraceIntegration);
                end

            elseif ~isempty(specData(idxThread).MetaData.Detector)
                Operation = sprintf('• Operação: %s', specData(idxThread).MetaData.Detector);
            end
            value{end+1} = Operation;

            % DataPoints
            value{end+1} = sprintf('• %d pontos por varredura', specData(idxThread).MetaData.DataPoints);

            % Resolution+VBW+StepWidth
            RBW       = specData(idxThread).MetaData.Resolution/1000;
            VBW       = specData(idxThread).MetaData.VBW/1000;
            StepWidth = ((specData(idxThread).MetaData.FreqStop - specData(idxThread).MetaData.FreqStart) / (specData(idxThread).MetaData.DataPoints - 1)) * 1e-3;

            if (specData(idxThread).MetaData.Resolution ~= -1) && (specData(idxThread).MetaData.VBW ~= -1)
                Resolution = sprintf('• Resolução: %.3f kHz (RBW), %.3f kHz (VBW), %.3f kHz (Passo da varredura)', RBW, VBW, StepWidth);
            elseif specData(idxThread).MetaData.Resolution ~= -1
                Resolution = sprintf('• Resolução: %.3f kHz (RBW), %.3f kHz (Passo da varredura)', RBW, StepWidth);
            elseif specData(idxThread).MetaData.VBW ~= -1
                Resolution = sprintf('• Resolução: %.3f kHz (VBW), %.3f kHz (Passo da varredura)', VBW, StepWidth);
            else
                Resolution = sprintf('• Resolução: %.3f kHz (Passo da varredura)', StepWidth);
            end
            value{end+1} = Resolution;

            % Antenna
            value{end+1} = sprintf('• Antena: %s', jsonencode(specData(idxThread).MetaData.Antenna));

            % GPS
            value{end+1} = sprintf('• GPS: %.6f, %.6f (%s)', specData(idxThread).GPS.Latitude,  ...
                                                             specData(idxThread).GPS.Longitude, ...
                                                             specData(idxThread).GPS.Location);

            % Others
            if ~isempty(specData(idxThread).MetaData.Others)
                value{end+1} = sprintf('• Outros metadados: %s', specData(idxThread).MetaData.Others);
            end

            value = strjoin(value, '<br>');
        case 'threadTag'
            threadIndex = reportInfo.General.Parameters.Plot.idxThread;
            value = sprintf('FAIXA DE FREQUÊNCIA #%d: <b>%.3f - %.3f MHz</b>', threadIndex,                                ...
                                                                            specData(idxThread).MetaData.FreqStart * 1e-6, ...
                                                                            specData(idxThread).MetaData.FreqStop  * 1e-6);
        case 'channelTag'
            threadIndex = reportInfo.General.Parameters.Plot.idxThread;
            chIndex = reportInfo.General.Parameters.Plot.idxChannel;
            
            chTable = specData(idxThread).UserData.reportChannelTable;
            chName  = extractBefore(chTable.Name{chIndex}, ' @');
            if isempty(chName)
                chName = chTable.Name{chIndex};
            end
            value = sprintf('CANAL #%d.%d: <b>%s @ %.3f MHz ⌂ %.1f kHz</b>', threadIndex, chIndex,  chName,   ...
                                                                            chTable.FirstChannel(chIndex),    ...
                                                                            chTable.ChannelBW(chIndex) * 1000);
        case 'emissionTag'
            emissionIndex = reportInfo.General.Parameters.Plot.idxEmission;
            value = sprintf('EMISSÃO #d: <b>%.3f MHz ⌂ %.1f kHz</b>',       emissionIndex,                                           ...
                                                                            specData(idxThread).UserData.Emissions{emissionIndex,2}, ...
                                                                            specData(idxThread).UserData.Emissions{emissionIndex,3});
    end
end

%-------------------------------------------------------------------------%
% IMAGEM
%-------------------------------------------------------------------------%
function hContainer = PlotContainer(hFigure)
    xWidth     = class.Constants.windowSize(1);
    yHeight    = class.Constants.windowSize(2);    
    hContainer = uipanel(hFigure, AutoResizeChildren='off',          ...
                                  Position=[100 100 xWidth yHeight], ...
                                  BorderType='none',                 ...
                                  BackgroundColor=[0 0 0],           ...
                                  Visible=0);
end

%-------------------------------------------------------------------------%
function Image = Fcn_Image(specData, idxThread, tempBandObj, reportInfo, Recurrence, Children, plotInfo, hFigure)
    global ID_imgExt
    global hContainer

    Image = '';
    switch Children.Data.Origin
        case 'Internal'
            if isempty(hContainer) || ~isvalid(hContainer)
                hContainer = PlotContainer(hFigure);
            end

            Image = plot.old_axesDraw.plot2report(hContainer, specData, idxThread, tempBandObj, reportInfo, plotInfo);

        case 'External'
            if Recurrence
                Image     = specData(idxThread).UserData.reportAttachments.image;
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
% TABELA
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

    if isempty(Source) || ((Origin == "External") && ~isfile(Source))
        error('Configuration file error message: %s', Children.Data.Error)
    end

    Table = [];
    switch Origin
        case 'Internal'
            switch Source
                case {'Algorithms', 'Channel'}
                    Table = eval(sprintf('reportLibConnection.table.%s(SpecInfo, idx);', Source));
                    Table = Fcn_Table_PreProcess(Table, reportInfo, Children);

                case 'EmissionPerChannel'
                    chIndex = reportInfo.General.Parameters.Plot.idxChannel;
                    chTable = SpecInfo(idx).UserData.reportChannelAnalysis;
                    if isempty(chTable)
                        chTable = reportLibConnection.table.Channel(SpecInfo, idx);
                    end
                    Table = chTable.("Emissões"){chIndex};
                    Table = Fcn_Table_PreProcess(Table, reportInfo, Children);
        
                case 'Peaks'
                    if ~isempty(SpecInfo(idx).UserData.reportPeaksTable)                        
                        Table       = SpecInfo(idx).UserData.reportPeaksTable;
                        Table.ID(:) = 1:height(Table)';
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
                            Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).ColumnName;
        
                            if ismember(Children.Data.Columns{ii}, ["minLevel", "meanLevel", "maxLevel"])
                                Table.Properties.VariableNames{ii} = sprintf('%s (%s)', Table.Properties.VariableNames{ii}, SpecInfo(idx).MetaData.LevelUnit);
                            end
                        end
                    end
        
                case 'Summary'        
                    if ~isempty(peaksTable)
                        infoTable = reportLibConnection.table.Summary(peaksTable, exceptionList);
        
                        % COLUNAS DE INFOTABLE
                        ind_Peaks = cellfun(@(x) find(strcmp(x, infoTable.Properties.VariableNames)), Children.Data.Columns);
                        Table = infoTable(:,ind_Peaks);
        
                        % AJUSTE DOS NOMES DAS COLUNAS
                        for ii = 1:numel(Table.Properties.VariableNames)
                            Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).ColumnName;
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
                        VariableNames{end+1} = Children.Data.Settings(ii).ColumnName;
                    end
        
                    % Identifica quantidade de fluxos de espectro.
                    MM = numel(SpecInfo);
                    
                    % Povoa a tabela.
                    Table = table('Size', [MM, NN],               ...
                                  'VariableTypes', VariableTypes, ...
                                  'VariableNames', VariableNames);
        
                    ll = 0;
                    for jj = 1:MM
                        if ismember(SpecInfo(jj).MetaData.DataType, class.Constants.specDataTypes)
                            ll = ll+1;
        
                            for kk = 1:NN
                                Source = Children.Data.Columns{kk};
                                switch Source
                                    case 'ID'
                                        Table{ll,kk} = ll;
                                    otherwise
                                        Table(ll,kk) = {Fcn_Source(SpecInfo, jj, reportInfo, Source)};
                                end
                            end
                        end
                    end
        
                    for ii = 1:numel(Table.Properties.VariableNames)
                        Table.Properties.VariableNames{ii} = Children.Data.Settings(ii).ColumnName;
                    end
            end

        case 'External'
            [~, ~, fileExt] = fileparts(Source);
            switch lower(fileExt)
                case '.json'
                    Table = struct2table(jsondecode(fileread(Source)));
                case {'.xls', '.xlsx'}
                    Table = readtable(Source, "VariableNamingRule", "preserve", "Sheet", SheetID);
                otherwise
                    Table = readtable(Source, "VariableNamingRule", "preserve");
            end

            Table = Fcn_Table_PreProcess(Table, reportInfo, Children);
    end
end

%-------------------------------------------------------------------------%
function Table = Fcn_Table_PreProcess(Table, reportInfo, Children)
    if strcmp(Children.Data.Columns{1}, 'ID') && ~ismember('ID', Table.Properties.VariableNames)
        Source = Children.Data.Source;
        IDReference = (1:height(Table))';

        switch Source
            case 'Channel'
                idxThread   = reportInfo.General.Parameters.Plot.idxThread;
                Table.ID(:) = string(idxThread) + "." + string(IDReference);

            case 'EmissionPerChannel'
                idxThread   = reportInfo.General.Parameters.Plot.idxThread;
                idxChannel  = reportInfo.General.Parameters.Plot.idxChannel;
                Table.ID(:) = string(idxThread) + "." + string(idxChannel) + "." + string(IDReference);

            otherwise
                Table.ID(:) = IDReference;
        end    
        
        Table = movevars(Table, 'ID', 'Before', 1);
    end

    Table = Table(:, Children.Data.Columns);
    Table.Properties.VariableNames = {Children.Data.Settings.ColumnName};
end