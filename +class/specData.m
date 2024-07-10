classdef specData < handle

    properties
        %-----------------------------------------------------------------%
        Receiver
        MetaData     = struct(class.MetaDataList)
        Data                                                                % Data{1}: timestamp; Data{2}: matrix; and Data{3}: stats
        GPS
        RelatedFiles = table('Size', [0,10],                                                                                                  ...
                             'VariableTypes', {'cell', 'cell', 'double', 'cell', 'datetime', 'datetime', 'double', 'double', 'cell', 'cell'}, ...
                             'VariableNames', {'File', 'Task', 'ID', 'Description', 'BeginTime', 'EndTime', 'nSweeps', 'RevisitTime', 'GPS', 'uuid'})
        UserData     = class.userData.empty
        FileMap                                                             % Auxilia o processo de leitura dos dados de espectro
        Enable       = true
    end


    methods
        %-----------------------------------------------------------------%
        function obj = PreAllocationData(obj, idx, fileType)

            if nargin < 3
                idx      = 1;
                fileType = '';
            end

            obj(idx).Data = {repmat(datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss'), 1, sum(obj(idx).RelatedFiles.nSweeps)), ...
                             zeros(obj(idx).MetaData.DataPoints, sum(obj(idx).RelatedFiles.nSweeps), 'single'),                       ...
                             zeros(obj(idx).MetaData.DataPoints, 3, 'single')};

            if fileType == "RFlookBin v.2/2"
                obj(idx).Data{4} = zeros(obj(idx).MetaData.DataPoints, sum(obj(idx).RelatedFiles.nSweeps), 'single');
                obj(idx).Data{5} = zeros(obj(idx).MetaData.DataPoints, sum(obj(idx).RelatedFiles.nSweeps), 'single');
            end
        end


        %-----------------------------------------------------------------%
        function copyObj = copy(obj, fields2remove)            
            copyObj  = class.specData();
            propList = setdiff(properties(copyObj), fields2remove);

            for ii = 1:numel(obj)
                for jj = 1:numel(propList)
                    copyObj(ii).(propList{jj}) = obj(ii).(propList{jj});                
                end
            end
        end


        %-----------------------------------------------------------------%
        function IDs = IDList(obj)
            IDs = arrayfun(@(x) x.RelatedFiles.ID(1), obj);
        end


        %-----------------------------------------------------------------%
        function obj = merge(obj, idx, uiFigure)

            if numel(idx) < 2
                error('Devem ser selecionados ao menos dois fluxos espectrais...')
            end

            mergeTable = table('Size',          [0, 10],                                                                                          ...
                               'VariableTypes', {'double', 'cell', 'double', 'double', 'double', 'cell', 'double', 'double', 'double', 'double'}, ...
                               'VariableNames', {'idx', 'Receiver', 'DataType', 'FreqStart', 'FreqStop', 'LevelUnit', 'DataPoints', 'StepWidth', 'Resolution', 'nSweeps'});

            for ii = idx
                mergeTable(end+1,:) = {ii,                          ...
                                       obj(ii).Receiver,            ...
                                       obj(ii).MetaData.DataType,   ...
                                       obj(ii).MetaData.FreqStart,  ...
                                       obj(ii).MetaData.FreqStop,   ...
                                       obj(ii).MetaData.LevelUnit,  ...
                                       obj(ii).MetaData.DataPoints, ...
                                       (obj(ii).MetaData.FreqStop - obj(ii).MetaData.FreqStart) / (obj(ii).MetaData.DataPoints - 1), ...
                                       obj(ii).MetaData.Resolution, ...
                                       numel(obj(ii).Data{1})};
            end
            mergeTable = sortrows(mergeTable, 'FreqStart');

            % Validação inicial, aplicável a todos os tipos de mesclagem.
            if ~isscalar(unique(mergeTable.Receiver)) || ...
               ~isscalar(unique(mergeTable.DataType)) || ...
               ~isscalar(unique(mergeTable.LevelUnit))
               
                error(ErrorMessage(obj, 'merge'))
            end

            % FAIXAS DE FREQUÊNCIA IDÊNTICAS
            if isscalar(unique(mergeTable.FreqStart)) && ...
               isscalar(unique(mergeTable.FreqStop))  && ...
               isscalar(unique(mergeTable.DataPoints))
                mergeType = 'co-channel';

            % FAIXAS DE FREQUÊNCIA ADJACENTES
            elseif issorted(mergeTable.FreqStart, "strictascend")                                             && ...
               all(mergeTable.FreqStart(2:height(mergeTable)) <= mergeTable.FreqStop(1:height(mergeTable)-1)) && ...
               isscalar(unique(mergeTable.nSweeps))
                mergeType = 'adjacent-channel';
            
            else
                error(ErrorMessage(obj, 'merge'))
            end

            resolutionList = unique(mergeTable.Resolution);
            if (numel(resolutionList)  > 1)
                msg = {};
                for ii = 1:height(mergeTable)
                    msg{end+1} = sprintf('• %.3f - %.3f MHz (Resolução = %.3f kHz)', mergeTable.FreqStart(ii)/1e+6, mergeTable.FreqStop(ii)/1e+6, mergeTable.Resolution(ii)/1000);
                end
                msg = sprintf(['<font style="font-size:12;">Os fluxos espectrais a mesclar possuem valores diferentes de resolução.\n%s\n\n' ...
                               'Deseja continuar esse processo de mesclagem, o que resultará em um fluxo que armazenará como metadado a maior ' ...
                               'resolução (no caso, %.3f kHz)?</font>'], strjoin(msg, '\n'), max(mergeTable.Resolution)/1000);
                selection = uiconfirm(uiFigure, msg, '', 'Options', {'Sim', 'Não'}, 'DefaultOption', 2, 'CancelOption', 2, 'Icon', 'question', 'Interpreter', 'html');

                if strcmp(selection, 'Não')
                    return
                end
            end

            stepWidthList = unique(mergeTable.StepWidth);
            if (numel(stepWidthList)  > 1)
                msg = {};
                for ii = 1:height(mergeTable)
                    msg{end+1} = sprintf('• %.3f - %.3f MHz (Passo da varredura = %.3f kHz)', mergeTable.FreqStart(ii)/1e+6, mergeTable.FreqStop(ii)/1e+6, mergeTable.StepWidth(ii)/1000);
                end
                msg = sprintf(['<font style="font-size:12;">Os fluxos espectrais a mesclar possuem valores diferentes de passos de varredura.\n%s\n\n'   ...
                               'Deseja continuar esse processo de mesclagem, o que poderá demandar a interpolação da(s) matriz(es) de níveis do(s) fluxo(s), ' ...
                               'resultando em um único passo de varredura (no caso, %.3f kHz)?</font>'], strjoin(msg, '\n'), mode(mergeTable.StepWidth)/1000);
                selection = uiconfirm(uiFigure, msg, '', 'Options', {'Sim', 'Não'}, 'DefaultOption', 2, 'CancelOption', 2, 'Icon', 'question', 'Interpreter', 'html');

                if strcmp(selection, 'Não')
                    return
                end
            end
            
            switch mergeType
                case 'co-channel'
                    timeArray    = [];
                    dataMatrix   = [];
                    relatedFiles = [];
                    
                    for ii = idx
                        timeArray    = [timeArray,    obj(ii).Data{1}]; 
                        dataMatrix   = [dataMatrix,   obj(ii).Data{2}];
                        relatedFiles = [relatedFiles; obj(ii).RelatedFiles];
                    end
    
                    if ~issorted(timeArray)
                        [timeArray, idxSort] = sort(timeArray);
                        dataMatrix           = dataMatrix(:,idxSort);
                    end
    
                    obj(idx(1)).GPS = rmfield(fcn.gpsSummary(relatedFiles.GPS), 'Matrix');
                    obj(idx(1)).RelatedFiles = relatedFiles;

                case 'adjacent-channel'
                    timeArray    = obj(idx(1)).Data{1};
                    dataMatrix   = [];
                    relatedFiles = obj(idx(1)).RelatedFiles;

                    stepWidthRef = mode(mergeTable.StepWidth);

                    for ii = 1:numel(idx)
                        newDataPoints = round((mergeTable.FreqStop(ii) - mergeTable.FreqStart(ii))/stepWidthRef + 1);
                        
                        x  = linspace(mergeTable.FreqStart(ii), mergeTable.FreqStop(ii), mergeTable.DataPoints(ii));
                        xq = linspace(mergeTable.FreqStart(ii), mergeTable.FreqStop(ii), newDataPoints);

                        if ii > 1
                            if mergeTable.FreqStart(ii) < mergeTable.FreqStop(ii-1)
                                newFreqStart = mergeTable.FreqStop(ii-1);
                                newDataPoints = round((mergeTable.FreqStop(ii) - newFreqStart)/stepWidthRef + 1);
    
                                xq = linspace(newFreqStart, mergeTable.FreqStop(ii), newDataPoints);
                            end                            
                        end

                        if isequal(x, xq)
                            newDataMatrix = obj(idx(ii)).Data{2};

                        else
                            nSweeps = mergeTable.nSweeps(ii);
                            newDataMatrix = zeros(newDataPoints, nSweeps, 'single');

                            for jj = 1:nSweeps
                                newDataMatrix(:,jj) = interp1(x, obj(idx(ii)).Data{2}(:,jj), xq);
                            end
                        end

                        dataMatrix = [dataMatrix; newDataMatrix];
                    end

                    obj(idx(1)).MetaData.DataPoints = height(dataMatrix);
                    obj(idx(1)).MetaData.FreqStop   = mergeTable.FreqStop(end);
            end            

            % Ajustando os valores comuns aos dois tipos de mesclagem...
            obj(idx(1)).MetaData.Resolution = max(resolutionList);

            obj(idx(1)).Data{1} = timeArray;
            obj(idx(1)).Data{2} = dataMatrix;
            obj(idx(1)).Data{3} = class.specData.read_StatsData(dataMatrix);

            % Excluindo os fluxos mesclados (exceto o "fluxo guia")...
            delete(obj(idx(2:numel(idx))))
            obj(idx(2:numel(idx))) = [];

            % Atualizando o mapeamento com os fluxos de ocupação...
            dataTypesArray = arrayfun(@(x) x.MetaData.DataType, obj);
            if any(ismember(dataTypesArray, class.Constants.occDataTypes))
                for ii = 1:numel(obj)
                    [relatedIndex, selectedIndex] = class.specData.read_OCCMap(obj, ii);

                    if ~isempty(relatedIndex)
                        obj(ii).UserData(1).occMethod.RelatedIndex  = relatedIndex;
                        obj(ii).UserData(1).occMethod.SelectedIndex = selectedIndex;
                    end
                end
            end
        end
    end


    methods (Access = protected)
        %-----------------------------------------------------------------%
        function errorMessage = ErrorMessage(obj, errorType)
            switch errorType
                case 'merge'
                    errorMessage = sprintf(['Os fluxos espectrais a mesclar não atendem aos requisitos dos dois tipos de mesclagem implantados no <i>app</i>, quais sejam:\n\n'    ...
                                           '• Tipo "co-channel": os fluxos devem possuir os campos "FreqStart", "FreqStop", "LevelUnit", "DataPoints" e "DataType" idênticos;\n\n' ...
                                           '• Tipo "adjacent-channel": os fluxos devem estar relacionados a faixas de frequências adjacentes, podendo ter sobreposição espectral entre fluxos, além de possuírem os campos "LevelUnit", "nSweeps" e "DataType" idênticos.']);
                otherwise
                    errorMessage = 'Unknown error';
            end
        end
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function str = id2str(Type, id)
            switch Type
                case 'TraceMode'
                    switch id
                        case 1; str = 'ClearWrite';
                        case 2; str = 'Average';
                        case 3; str = 'MaxHold';
                        case 4; str = 'MinHold';
                    end

                % Em tese, os IDs deveriam ser apenas 1 a 4 representando,
                % respectivamente, "Sample", "Average/RMS", "Positive Peak" 
                % e "Negative Peak".
                %
                % Notei, contudo, arquivos de monitoração gerados pelo appColeta
                % v. 1.11 nos quais esse ID estava igual a "0". Foram monitorações 
                % conduzidas com o R&S EB500.
                case 'Detector'
                    switch id
                        case 0; str = 'Sample';
                        case 1; str = 'Sample';
                        case 2; str = 'Average/RMS';
                        case 3; str = 'Positive Peak';
                        case 4; str = 'Negative Peak';
                    end        

                case 'LevelUnit'
                    switch id
                        case 1; str = 'dBm';
                        case 2; str = 'dBµV';
                        case 3; str = 'dBµV/m';
                    end
            end        
        end


        %-----------------------------------------------------------------%
        function ID = str2id(Type, Value)
            switch Type
                case 'TraceMode'
                    switch Value
                        case 'ClearWrite'; ID = 1;
                        case 'Average';    ID = 2;
                        case 'MaxHold';    ID = 3;
                        case 'MinHold';    ID = 4;
                    end
        
                case 'Detector'
                    switch Value
                        case 'Sample';        ID = 1;
                        case 'Average/RMS';   ID = 2;
                        case 'Positive Peak'; ID = 3;
                        case 'Negative Peak'; ID = 4;
                    end
        
                case 'LevelUnit'
                    switch Value
                        case 'dBm';                ID = 1;
                        case {'dBµV', 'dBμV'};     ID = 2;
                        case {'dBµV/m', 'dBμV/m'}; ID = 3;
                    end
            end        
        end


        %-----------------------------------------------------------------%
        function Value = str2str(Value)
            Value = replace(Value, 'μ', 'µ');
        end


        %-----------------------------------------------------------------%
        function read(app, d)
            if ~isempty(app.specData)
                delete(app.specData)
            end

            % Organização dos fluxos de dados.
            class.specData.read_Map(app)
        
            prjInfoFlag = true;
            for ii = 1:numel(app.metaData)
                [~, name, ext] = fileparts(app.metaData(ii).File);
                d.Message = sprintf('<font style="font-size:12;">Em andamento a leitura dos dados de espectro do arquivo:\n• %s\n\n%d de %d</font>', [name ext], ii, numel(app.metaData));
                
                prjInfo = [];
                switch lower(ext)
                    case '.bin'
                        fileID = fopen(app.metaData(ii).File);
                        Format = fread(fileID, [1 36], '*char');
                        fclose(fileID);
        
                        if contains(Format, 'CRFS', "IgnoreCase", true)
                            SpecInfo = fileReader.CRFSBin(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                        elseif contains(Format, 'RFlookBin v.1', "IgnoreCase", true)
                            SpecInfo = fileReader.RFlookBinV1(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                        elseif contains(Format, 'RFlookBin v.2', "IgnoreCase", true)
                            SpecInfo = fileReader.RFlookBinV2(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                        end
        
                    case '.dbm'
                        SpecInfo = fileReader.CellPlanDBM(app.metaData(ii).File, 'SpecData', app.metaData(ii));                        
        
                    case '.sm1809'
                        SpecInfo = fileReader.SM1809(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                    
                    case '.csv'
                        SpecInfo = fileReader.ArgusCSV(app.metaData(ii).File, 'SpecData', app.metaData(ii));
        
                    case '.mat'
                        [SpecInfo, prjInfo] = fileReader.MAT(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                end
                
                % Mapeamento entre o fluxo cujos dados de espectro acabaram de ser 
                % lidos (SpecInfo) e os fluxos já organizados na principal variável
                % do app (app.specData).
                for jj = 1:numel(SpecInfo)
                    for kk = 1:numel(app.specData)
                        idx1 = find(cellfun(@(x) ismember(x, unique(SpecInfo(jj).RelatedFiles.uuid)), app.specData(kk).RelatedFiles.uuid, 'UniformOutput', true));
        
                        if ~isempty(idx1)
                            break
                        end
                    end
        
                    if isempty(idx1)
                        continue
                    end
                    
                    if min(idx1) == 1
                        idx2 = 1;
                    else
                        idx2 = sum(app.specData(kk).RelatedFiles.nSweeps(1:(min(idx1)-1)))+1;
                    end
                    idx3 = sum(app.specData(kk).RelatedFiles.nSweeps(1:max(idx1)));
                    
                    app.specData(kk).Data{1}(1,idx2:idx3) = SpecInfo(jj).Data{1};
                    app.specData(kk).Data{2}(:,idx2:idx3) = SpecInfo(jj).Data{2};
        
                    if ~isempty(prjInfo)
                        app.specData(kk).UserData(1) = SpecInfo(jj).UserData;
        
                        if prjInfoFlag
                            prjInfoFlag = false;
        
                            app.report_ProjectName.Value     = prjInfo.Name;
                            app.report_ProjectFilename.Value = app.metaData(ii).File;
                            app.report_Issue.Value           = prjInfo.reportInfo.Issue;

                            prjModelIndex = find(strcmp(app.report_Type.Items, prjInfo.reportInfo.Model.Name), 1);
                            if ~isempty(prjModelIndex)
                                app.report_Type.Value = app.report_Type.Items{prjModelIndex};
                            end
        
                            if ~isempty(prjInfo.exceptionList)                    
                                app.exceptionList     = prjInfo.exceptionList;
                                app.exceptionList.Tag = replace(prjInfo.exceptionList.Tag, 'ThreadID', 'ID');
                            end                 
                        end
                    end
                end
            end
            
            % Manipulações acessórias.
            d.Message = '<font style="font-size:12;">Em andamento outras manipulações, como aferição de dados estatísticas e identificação do fluxo de ocupação...</font>';
            class.specData.read_FinalOperation(app)
        end
        
        
        %-----------------------------------------------------------------%
        function read_Map(app)
        
            for ii = 1:numel(app.metaData)
                SpecInfo  = copy(app.metaData(ii).Data, {'RelatedFiles', 'FileMap'});
        
                if ii == 1
                    app.specData = SpecInfo;
                    fileIndexMap = num2cell((1:numel(app.metaData(ii).Data))');
                    continue
                end
        
                % Mapeamento entre os fluxos...
                SpecInfo_MetaData = class.specData.read_MetaData(app, SpecInfo);
                for jj = 1:numel(SpecInfo)
                    SpecInfo_GPS      = [SpecInfo(jj).GPS.Latitude, SpecInfo(jj).GPS.Longitude];
                    specData_MetaData = class.specData.read_MetaData(app, app.specData);
        
                    idx1 = [];
                    for kk = 1:numel(app.specData)
                        specData_GPS = [app.specData(kk).GPS.Latitude, app.specData(kk).GPS.Longitude];
                        Distance_GPS = fcn.gpsDistance(SpecInfo_GPS, specData_GPS) * 1000;
        
                        if isequal(specData_MetaData(kk), SpecInfo_MetaData(jj)) && (Distance_GPS <= app.General.Merge.Distance)
                            idx1 = kk;
        
                            if width(fileIndexMap) < ii
                                fileIndexMap{idx1, ii} = jj;
                            else
                                fileIndexMap{idx1, ii} = [fileIndexMap{idx1, ii}, jj];
                            end
                            break
                        end
                    end
        
                    if isempty(idx1)
                        idx2 = numel(app.specData)+1;
                        
                        app.specData(idx2)     = SpecInfo(jj);
                        fileIndexMap{idx2, ii} = jj;
                    end
                end
            end
            
            % Pré-alocação
            class.specData.read_PreAllocationData(app, fileIndexMap);
        end
        
        
        %-----------------------------------------------------------------%
        function read_PreAllocationData(app, fileIndexMap)
        
            for ii = numel(app.specData):-1:1
                % Elimina fluxos filtrados...
                if ~app.specData(ii).Enable
                    app.specData(ii)   = [];
                    fileIndexMap(ii,:) = [];
        
                    continue
                end
        
                for jj = 1:width(fileIndexMap)
                    idx = fileIndexMap{ii,jj};
                    for kk = idx
                        NN = height(app.metaData(jj).Data(kk).RelatedFiles);
                        app.specData(ii).RelatedFiles(end+1:end+NN,:) = app.metaData(jj).Data(kk).RelatedFiles;
                    end
                end
                app.specData(ii) = PreAllocationData(app.specData(ii));
            end
        end
        
        
        %-----------------------------------------------------------------%
        function read_FinalOperation(app)
        
            % Ordenação dos fluxos dos dados:
            % - Primário:   Receiver
            % - Secundário: ID
            idx1 = class.specData.read_SortData(app.specData);
            app.specData = app.specData(idx1);
            
            for ii = 1:numel(app.specData)
                % Ordenando os dados...
                if ~issorted(app.specData(ii).Data{1})
                    [app.specData(ii).Data{1}, idx2] = sort(app.specData(ii).Data{1});
                    app.specData(ii).Data{2}         = app.specData(ii).Data{2}(:,idx2);
                end
        
                % GPS
                if height(app.specData(ii).RelatedFiles) > 1
                    fcn.gpsProperty(app, ii)
                end
        
                % Estatística básica dos dados:
                app.specData(ii).Data{3}(:) = class.specData.read_StatsData(app.specData(ii).Data{2});

                app.specData(ii).UserData(1).occMethod.RelatedIndex = [];
                if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
                    % Mapeamento entre os fluxos de espectro e os de ocupação
                    % (eventualmente gerados pelo Logger):
                    [relatedIndex, selectedIndex] = class.specData.read_OCCMap(app.specData, ii);

                    if ~isempty(relatedIndex)
                        app.specData(ii).UserData(1).occMethod.RelatedIndex  = relatedIndex;
                        app.specData(ii).UserData(1).occMethod.SelectedIndex = selectedIndex;
                    end
        
                    % Mapeamento entre os fluxos de espectro e as canalizações
                    % aplicáveis à cada faixa.
                    app.specData(ii).UserData(1).channelLibIndex = app.channelObj.FindRelatedBands(app.specData(ii));
                end
            end
        
            idx3 = find(arrayfun(@(x) x.UserData.reportFlag, app.specData));
            class.userData.reportProperties_DefaultValues(app, idx3)
        end


        %-----------------------------------------------------------------%
        function [relatedIndex, selectedIndex] = read_OCCMap(Data, ii)

            relatedIndex  = [];
            selectedIndex = [];

            idx = [];
            for jj = 1:numel(Data)
                if ismember(Data(jj).MetaData.DataType, class.Constants.occDataTypes)
                    idx = [idx, jj];
                end
            end

            for kk = idx
                logEvaluation = strcmp(Data(ii).Receiver, Data(kk).Receiver)                 & ...
                                Data(ii).MetaData.FreqStart  == Data(kk).MetaData.FreqStart  & ...
                                Data(ii).MetaData.FreqStop   == Data(kk).MetaData.FreqStop   & ...
                                Data(ii).MetaData.DataPoints == Data(kk).MetaData.DataPoints;
    
                if logEvaluation
                    relatedIndex = [relatedIndex, kk];
                end
            end
            
            if ~isempty(relatedIndex)
                selectedIndex = relatedIndex(1);
            end
        end


        %-----------------------------------------------------------------%
        function sortIndex = read_SortData(Data)

            % Ordenação dos fluxos dos dados:
            % - Primário:   Receiver
            % - Secundário: ID
            ID = [];
            for ii = 1:numel(Data)
                ID = [ID; Data(ii).RelatedFiles.ID(1)];
            end
            [~, sortIndex] = sortrows(table({Data.Receiver}', ID));
        end


        %-----------------------------------------------------------------%
        function statsData = read_StatsData(Data)

            statsData = [ min(Data, [], 2), ...
                         mean(Data,     2), ...
                          max(Data, [], 2)];
        end
        
        
        %-----------------------------------------------------------------%
        function comparableData = read_MetaData(app, Data)
        
            % Trata-se de função que define as características primárias (listadas 
            % abaixo) que identificam uma monitoração, possibilitando juntar informações 
            % registradas em diferentes arquivos.
            % - Receiver
            % - FreqStart, FreqStop
            % - LevelUnit
            % - DataPoints
            % - Resolution e VBW
            % - Threshold
            % - TraceMode, TraceIntegration e Detector
        
            % Pode-se excluir, dentre os campos de "MetaData", os campos DataType, 
            % Antenna e Others.
            % - O DataType por não estar relacionado à monitoração; 
            % - A Antenna que é um metadado comumente incluso manualmente pelo 
            %   fiscal (exceção à monitoração conduzida na EMSat);
            % - E o novo campo Others, que vai armazenar metadados secundários.

            % Lista de metadados a excluir:
            metaData2Delete = {'Others'};
            if app.General.Merge.Antenna == "remove"
                metaData2Delete{end+1} = 'Antenna';
            end
            if app.General.Merge.DataType == "remove"
                metaData2Delete{end+1} = 'DataType';
            end

            % Estrutura de referência:        
            for ii = 1:numel(Data)
                tempStruct = rmfield(Data(ii).MetaData, metaData2Delete);
                tempStruct.Receiver = Data(ii).Receiver;

                if isfield(tempStruct, 'Antenna')
                    antennaFields = fields(tempStruct.Antenna);
                    antennaFields = antennaFields(~ismember(antennaFields, app.General.Merge.AntennaAttributes));
                    
                    tempStruct.Antenna = rmfield(tempStruct.Antenna, antennaFields);
                end
        
                comparableData(ii) = tempStruct;
            end
        end


        %-----------------------------------------------------------------%
        function secundaryMetaData = SecundaryMetaData(fileFormat, originalMetaData)
            switch fileFormat
                case 'RFlookBin v.2'
                    fieldsList = {'Receiver',         ...
                                  'AntennaInfo',      ...
                                  'ID',               ...
                                  'Description',      ...
                                  'FreqStart',        ...
                                  'FreqStop',         ...
                                  'DataPoints',       ...
                                  'Resolution',       ...
                                  'Unit',             ...
                                  'TraceMode',        ...
                                  'TraceIntegration', ...
                                  'Detector'};
                otherwise
                    fieldsList = [];
            end

            secundaryMetaData = rmfield(originalMetaData, fieldsList);
            secundaryMetaData.FileFormat = fileFormat;
            secundaryMetaData = class.specData.sortStructByFieldNames(secundaryMetaData);
            secundaryMetaData = jsonencode(secundaryMetaData);
        end


        %-----------------------------------------------------------------%
        function sortedStruct = sortStructByFieldNames(originalStruct)
            fieldNames      = fieldnames(originalStruct);
            [~,sortedIndex] = sort(lower(fieldNames));
            fieldNames      = fieldNames(sortedIndex);
            sortedStruct    = struct();

            for ii = 1:numel(fieldNames)
                sortedStruct.(fieldNames{ii}) = originalStruct.(fieldNames{ii});
            end
        end
    end
end