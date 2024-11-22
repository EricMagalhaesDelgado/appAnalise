classdef specData < handle

    properties
        %-----------------------------------------------------------------%
        Receiver
        MetaData     = struct(class.MetaDataList)
        Data
        GPS
        RelatedFiles = table('Size', [0,10],                                                                                                  ...
                             'VariableTypes', {'cell', 'cell', 'double', 'cell', 'datetime', 'datetime', 'double', 'double', 'cell', 'cell'}, ...
                             'VariableNames', {'File', 'Task', 'ID', 'Description', 'BeginTime', 'EndTime', 'nSweeps', 'RevisitTime', 'GPS', 'uuid'})
        UserData     = class.userData.empty
        FileMap
        Enable       = true
    end

    properties (Access = private)
        %-----------------------------------------------------------------%
        callingApp
        sortType
    end

    methods
        %-----------------------------------------------------------------%
        function [obj, builtinDialog] = read(obj, metaData, callingApp)
            builtinDialog  = appUtil.modalWindow(callingApp.UIFigure, 'progressdlg', 'Em andamento...');

            obj = FileMapping(obj, metaData, callingApp.General);
            arrayfun(@(x) setProperty(x, 'callingApp', callingApp),                        obj)
            arrayfun(@(x) setProperty(x, 'sortType',   callingApp.play_TreeSort.UserData), obj)

            nFiles2Read    = numel(metaData);
            prjInfoFlag    = true;

            for ii = 1:nFiles2Read
                [~, fileName, fileExt] = fileparts(metaData(ii).File);
                builtinDialog.Message = textFormatGUI.HTMLParagraph(sprintf('Em andamento a leitura dos dados de espectro do arquivo:\n•&thinsp;%s\n\n%d de %d', [fileName fileExt], ii, nFiles2Read));
                
                prjInfo = [];
                switch lower(fileExt)
                    case '.bin'
                        switch checkBINFormat(metaData(ii))
                            case 'CRFS'
                                SpecInfo = fileReader.CRFSBin(metaData(ii).File,     'SpecData', metaData(ii));
                            case 'RFlookBin v.1'
                                SpecInfo = fileReader.RFlookBinV1(metaData(ii).File, 'SpecData', metaData(ii));
                            case 'RFlookBin v.2'
                                SpecInfo = fileReader.RFlookBinV2(metaData(ii).File, 'SpecData', metaData(ii));
                        end
                    case '.dbm'
                        SpecInfo = fileReader.CellPlanDBM(metaData(ii).File,         'SpecData', metaData(ii));                                
                    case '.sm1809'
                        SpecInfo = fileReader.SM1809(metaData(ii).File,              'SpecData', metaData(ii));                    
                    case '.csv'
                        SpecInfo = fileReader.ArgusCSV(metaData(ii).File,            'SpecData', metaData(ii));        
                    case '.mat'
                        [SpecInfo, prjInfo] = fileReader.MAT(metaData(ii).File,      'SpecData', metaData(ii));
                end
                
                % Mapeamento entre o fluxo cujos dados de espectro acabaram de ser 
                % lidos (SpecInfo) e os fluxos já organizados na principal variável
                % do app (app.specData).
                for jj = 1:numel(SpecInfo)
                    for kk = 1:numel(obj)
                        idx1 = find(cellfun(@(x) ismember(x, unique(SpecInfo(jj).RelatedFiles.uuid)), obj(kk).RelatedFiles.uuid, 'UniformOutput', true));
        
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
                        idx2 = sum(obj(kk).RelatedFiles.nSweeps(1:(min(idx1)-1)))+1;
                    end
                    idx3 = sum(obj(kk).RelatedFiles.nSweeps(1:max(idx1)));
                    
                    obj(kk).Data{1}(1,idx2:idx3) = SpecInfo(jj).Data{1};
                    obj(kk).Data{2}(:,idx2:idx3) = SpecInfo(jj).Data{2};
        
                    if ~isempty(prjInfo)
                        obj(kk).UserData(1) = SpecInfo(jj).UserData;
        
                        if prjInfoFlag
                            prjInfoFlag = false;
        
                            callingApp.report_ProjectName.Value  = fullfile(fileparts(metaData(ii).File), prjInfo.Name);
                            callingApp.report_Issue.Value        = prjInfo.reportInfo.Issue;

                            if isfield(prjInfo.reportInfo, 'Model')
                                prjModelIndex = find(strcmp(callingApp.report_ModelName.Items, prjInfo.reportInfo.Model.Name), 1);
                                if ~isempty(prjModelIndex)
                                    callingApp.report_ModelName.Value = callingApp.report_ModelName.Items{prjModelIndex};
                                end
                            end

                            if ~isempty(prjInfo.generatedFiles) && isfield(prjInfo.generatedFiles, 'lastZIPFullPath') && isfile(prjInfo.generatedFiles.lastZIPFullPath)
                                unzipFiles = unzip(prjInfo.generatedFiles.lastZIPFullPath, callingApp.General.fileFolder.tempPath);
                                for ll = 1:numel(unzipFiles)
                                    [~, ~, unizipFileExt] = fileparts(unzipFiles{ll});
                                    switch lower(unizipFileExt)
                                        case '.html'
                                            callingApp.projectData.generatedFiles.lastHTMLDocFullPath = unzipFiles{ll};
                                        case '.json'
                                            callingApp.projectData.generatedFiles.lastTableFullPath   = unzipFiles{ll};
                                        case '.mat'
                                            callingApp.projectData.generatedFiles.lastMATFullPath     = unzipFiles{ll};
                                    end
                                end
                            end

                            callingApp.projectData.peaksTable     = prjInfo.peaksTable;
                            callingApp.projectData.exceptionList  = prjInfo.exceptionList;
                        end
                    end
                end
            end
            
            builtinDialog.Message = textFormatGUI.HTMLParagraph('Em andamento outras manipulações, como a aferição de dados estatísticos e a identificação do fluxo de ocupação.');
            obj = FinalOrganizationOfData(obj, prjInfo);
        end
        
        %-----------------------------------------------------------------%
        function sortedObj = sort(obj, sortType)
            arguments 
                obj
                sortType char {mustBeMember(sortType, {'Receiver+ID', 'Receiver+Frequency'})}
            end

            idx = 1:numel(obj);
            switch sortType
                case 'Receiver+ID'
                    [~, sortIndex] = createSortableTable(obj, idx, {'Receiver', 'ID', 'FreqStart', 'FreqStop', 'DataType'});
                case 'Receiver+Frequency'
                    [~, sortIndex] = createSortableTable(obj, idx, {'FreqStart', 'FreqStop', 'DataType'});
            end

            sortedObj = obj(sortIndex);
            OccupancyMapping(sortedObj)
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
        function obj = merge(obj, idxThreads, hFigure)
            % "obj" como saída é ESSENCIAL para garantir que tenha efeito
            % a diretriz: obj(idxThreads(2:nThreads)) = []; 
            arguments 
                obj
                idxThreads
                hFigure    (1,1) matlab.ui.Figure
            end
            
            % VALIDAÇÕES
            if numel(idxThreads) < 2
                error(ErrorMessage(obj, 'merge'))
            end

            mergeTable = createSortableTable(obj, idxThreads, {'FreqStart', 'FreqStop'});

            if ~isscalar(unique(mergeTable.Receiver)) || ~isscalar(unique(mergeTable.DataType)) || ~isscalar(unique(mergeTable.LevelUnit))               
                error(ErrorMessage(obj, 'merge'))
            end

            resolutionList = unique(mergeTable.Resolution);
            if ~isscalar(resolutionList)
                msgQuestion = {};
                for ii = 1:height(mergeTable)
                    msgQuestion{end+1} = sprintf('• %.3f - %.3f MHz (Resolução = %.3f kHz)', mergeTable.FreqStart(ii)/1e+6, mergeTable.FreqStop(ii)/1e+6, mergeTable.Resolution(ii)/1000);
                end
                msgQuestion   = sprintf(['Os fluxos espectrais a mesclar possuem valores diferentes de resolução.\n%s\n\n'                                ...
                                         'Deseja continuar esse processo de mesclagem, o que resultará em um fluxo que armazenará como metadado a maior ' ...
                                         'resolução (no caso, %.3f kHz)?'], strjoin(msgQuestion, '\n'), max(mergeTable.Resolution)/1000);
                userSelection = appUtil.modalWindow(hFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                if userSelection == "Não"
                    return
                end
            end

            stepWidthList = unique(mergeTable.StepWidth);
            if ~isscalar(stepWidthList)
                msgQuestion = {};
                for ii = 1:height(mergeTable)
                    msgQuestion{end+1} = sprintf('• %.3f - %.3f MHz (Passo da varredura = %.3f kHz)', mergeTable.FreqStart(ii)/1e+6, mergeTable.FreqStop(ii)/1e+6, mergeTable.StepWidth(ii)/1000);
                end
                msgQuestion   = sprintf(['Os fluxos espectrais a mesclar possuem valores diferentes de passos de varredura.\n%s\n\n'             ...
                                         'Deseja continuar esse processo de mesclagem, o que poderá demandar a interpolação da(s) '              ...
                                         'matriz(es) de níveis do(s) fluxo(s), resultando em um único passo de varredura (no caso, %.3f kHz)?'], ...
                                         strjoin(msgQuestion, '\n'), mode(mergeTable.StepWidth)/1000);
                userSelection = appUtil.modalWindow(hFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                if userSelection == "Não"
                    return
                end
            end
            
            % MESCLAGEM
            mergeType = identifyMergeType(obj, mergeTable);
            nThreads  = numel(idxThreads);

            switch mergeType
                case 'co-channel'
                    timeArray    = [];
                    dataMatrix   = [];
                    relatedFiles = [];
                    
                    for ii = 1:nThreads
                        timeArray    = [timeArray,    obj(idxThreads(ii)).Data{1}]; 
                        dataMatrix   = [dataMatrix,   obj(idxThreads(ii)).Data{2}];
                        relatedFiles = [relatedFiles; obj(idxThreads(ii)).RelatedFiles];
                    end
    
                    if ~issorted(timeArray)
                        [timeArray, idxSort] = sort(timeArray);
                        dataMatrix           = dataMatrix(:,idxSort);
                    end
    
                    obj(idxThreads(1)).GPS = rmfield(fcn.gpsSummary(relatedFiles.GPS), 'Matrix');
                    obj(idxThreads(1)).RelatedFiles = relatedFiles;

                case 'adjacent-channel'
                    stepWidthRef = mode(mergeTable.StepWidth);
                    [nSweepsRef, nSweepsRefIndex] = min(mergeTable.nSweeps);

                    timeArray    = obj(idxThreads(nSweepsRefIndex)).Data{1};
                    dataMatrix   = [];

                    for ii = 1:nThreads
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
                            newDataMatrix = obj(idxThreads(ii)).Data{2}(:, 1:nSweepsRef);
                        else
                            newDataMatrix = zeros(newDataPoints, nSweepsRef, 'single');

                            for jj = 1:nSweepsRef
                                newDataMatrix(:,jj) = interp1(x, obj(idxThreads(ii)).Data{2}(:, jj), xq);
                            end
                        end

                        % Elimina o primeiro bin do conjunto de dados atual 
                        % pois ele coincide com o último do conjunto de dados 
                        % anterior.
                        if ii > 1
                            newDataMatrix = newDataMatrix(2:end,:);
                        end

                        dataMatrix = [dataMatrix; newDataMatrix];
                    end

                    obj(idxThreads(1)).MetaData.DataPoints = height(dataMatrix);
                    obj(idxThreads(1)).MetaData.FreqStop   = mergeTable.FreqStop(end);
            end

            obj(idxThreads(1)).MetaData.Resolution = max(resolutionList);
            obj(idxThreads(1)).Data{1}      = timeArray;
            obj(idxThreads(1)).Data{2}      = dataMatrix;
            basicStats(obj, idxThreads(1))

            % PÓS-MESCLAGEM
            delete(obj(idxThreads(2:nThreads)))
            obj(idxThreads(2:nThreads)) = [];

            OccupancyMapping(obj)
        end

        %-----------------------------------------------------------------%
        function obj = filter(obj, FilterLOG, FilterLogicalArray)
            if ~isscalar(obj)
                error('UnexpectedNonScalarObject')
            end

            % FILTRAGEM
            obj.Data{1}(~FilterLogicalArray)    = [];
            obj.Data{2}(:, ~FilterLogicalArray) = [];

            % LOG
            obj.UserData.LOG{end+1} = jsonencode(FilterLOG);
            
            % ESTATÍSTICA BÁSICA
            basicStats(obj, 1)

            % Ajusta a informação da propriedade "RelatedFiles", que armazena
            % o período de observação de cada arquivo, o número de amostras
            % e uma estimativa do tempo de revisita.
            HH = height(obj.RelatedFiles);
            for ii = HH:-1:1
                idxSweepsInFile = find((obj.Data{1} >= obj.RelatedFiles.BeginTime(ii)) & (obj.Data{1} <= obj.RelatedFiles.EndTime(ii)));
                if isempty(idxSweepsInFile)
                    obj.RelatedFiles(ii,:) = [];

                else
                    BeginTime = obj.Data{1}(idxSweepsInFile(1));
                    EndTime   = obj.Data{1}(idxSweepsInFile(end));
                    nSweeps   = numel(idxSweepsInFile);

                    obj.RelatedFiles(ii,5:8) = {BeginTime, EndTime, nSweeps, seconds(EndTime-BeginTime)/(nSweeps-1)};
                end
            end
        end

        %-----------------------------------------------------------------%
        function PreAllocationData(obj, idx, fileType)
            arguments
                obj
                idx = 1
                fileType = ''
            end

            DataPoints    = obj(idx).MetaData.DataPoints;
            nSweeps       = sum(obj(idx).RelatedFiles.nSweeps);

            obj(idx).Data = {repmat(datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss'), 1, nSweeps), ...
                             zeros(DataPoints, nSweeps, 'single'),                                         ...
                             zeros(DataPoints, 3, 'single')};

            if fileType == "RFlookBin v.2/2"
                obj(idx).Data{4} = zeros(obj(idx).MetaData.DataPoints, sum(obj(idx).RelatedFiles.nSweeps), 'single');
                obj(idx).Data{5} = zeros(obj(idx).MetaData.DataPoints, sum(obj(idx).RelatedFiles.nSweeps), 'single');
            end
        end

        %-----------------------------------------------------------------%
        function IDs = IDList(obj)
            IDs = arrayfun(@(x) x.RelatedFiles.ID(1), obj);
        end

        %-----------------------------------------------------------------%
        function antennaHeight = AntennaHeight(obj, idx, referenceValue)
            antennaHeight = NaN;

            if ~isempty(obj(idx).UserData.AntennaHeight)
                antennaHeight = obj(idx).UserData.AntennaHeight;
                
            elseif isfield(obj(idx).MetaData.Antenna, 'Height')
                Height = obj(idx).MetaData.Antenna.Height;

                if isnumeric(Height) && isfinite(Height) && (Height > 0)
                    antennaHeight = Height;
                elseif ischar(Height)
                    antennaHeight = str2double(extractBefore(Height, 'm'));
                end
            end

            if isnan(antennaHeight)
                antennaHeight = referenceValue;
            end
        end

        %-----------------------------------------------------------------%
        function tag = Tag(obj, idx)
            tag = sprintf('%s\n%.3f - %.3f MHz', obj(idx).Receiver,                  ...
                                                 obj(idx).MetaData.FreqStart / 1e+6, ...
                                                 obj(idx).MetaData.FreqStop  / 1e+6);
        end
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        function setProperty(obj, propName, propValue)
            obj.(propName) = propValue;
        end

        %-----------------------------------------------------------------%
        function status = checkIfSameMetaData(obj, idx1, idx2)
            status = strcmp(obj(idx1).Receiver, obj(idx2).Receiver)                && ...
                     obj(idx1).MetaData.FreqStart  == obj(idx2).MetaData.FreqStart && ...
                     obj(idx1).MetaData.FreqStop   == obj(idx2).MetaData.FreqStop  && ...
                     obj(idx1).MetaData.DataPoints == obj(idx2).MetaData.DataPoints;
        end

        %-----------------------------------------------------------------%
        function OccupancyMapping(obj)
            dataTypesArray = arrayfun(@(x) x.MetaData.DataType, obj);
            idxOCCThreads  = find(ismember(dataTypesArray, class.Constants.occDataTypes));

            if ~isempty(idxOCCThreads)
                for ii = 1:numel(obj)                         
                    relatedIndex  = [];
                    for jj = idxOCCThreads
                        if checkIfSameMetaData(obj, ii, jj)
                            relatedIndex = [relatedIndex, jj];
                        end
                    end
                    
                    if ~isempty(relatedIndex)
                        obj(ii).UserData(1).occMethod.RelatedIndex  = relatedIndex;
                        obj(ii).UserData(1).occMethod.SelectedIndex = relatedIndex(1);
                    end
                end
            end
        end

        %-----------------------------------------------------------------%
        function [sortTable, sortIndex] = createSortableTable(obj, idxThreads, columnNames)
            NN = numel(idxThreads);
            sortTable = table('Size',          [NN, 11],                                                                                                   ...
                              'VariableTypes', {'double', 'cell', 'double', 'double', 'double', 'double', 'cell', 'double', 'double', 'double', 'double'}, ...
                              'VariableNames', {'idx', 'Receiver', 'ID', 'DataType', 'FreqStart', 'FreqStop', 'LevelUnit', 'DataPoints', 'StepWidth', 'Resolution', 'nSweeps'});

            for ii = 1:NN
                idx = idxThreads(ii);
                sortTable(ii,:) = {idx,                          ...
                                   obj(idx).Receiver,            ...
                                   obj(idx).RelatedFiles.ID(1),  ...
                                   obj(idx).MetaData.DataType,   ...
                                   obj(idx).MetaData.FreqStart,  ...
                                   obj(idx).MetaData.FreqStop,   ...
                                   obj(idx).MetaData.LevelUnit,  ...
                                   obj(idx).MetaData.DataPoints, ...
                                   (obj(idx).MetaData.FreqStop - obj(idx).MetaData.FreqStart) / (obj(idx).MetaData.DataPoints - 1), ...
                                   obj(idx).MetaData.Resolution, ...
                                   numel(obj(idx).Data{1})};
            end
            
            sortTable = sortrows(sortTable, columnNames);
            sortIndex = sortTable.idx;
        end

        %-----------------------------------------------------------------%
        function obj = FileMapping(obj, metaData, generalSettings)
            % O argumento de entrada "obj" aponta para um objeto vazio. Ao 
            % executar "obj(1:nThreads) = SpecInfo;" estou apontando essa
            % variável "obj" para outro objeto - o SpecInfo. Por isso, devo 
            % ter "obj" como argumento de saída.

            for ii = 1:numel(metaData)
                SpecInfo = copy(metaData(ii).Data, {'RelatedFiles', 'FileMap'});
        
                if ii == 1
                    nThreads        = numel(metaData(ii).Data);
                    obj(1:nThreads) = SpecInfo;
                    fileIndexMap    = num2cell((1:nThreads)');
                    continue
                end
        
                % Mapeamento entre os fluxos...
                SpecInfo_MetaData = ComparableMetaData(SpecInfo, generalSettings);
                for mm = 1:numel(SpecInfo)
                    specData_MetaData = ComparableMetaData(obj, generalSettings);
        
                    idx1 = [];
                    for kk = 1:numel(obj)
                        Distance_GPS = deg2km(distance(SpecInfo(mm).GPS.Latitude, SpecInfo(mm).GPS.Longitude, obj(kk).GPS.Latitude, obj(kk).GPS.Longitude)) * 1000;
        
                        if isequal(specData_MetaData(kk), SpecInfo_MetaData(mm)) && (Distance_GPS <= generalSettings.Merge.Distance)
                            idx1 = kk;
        
                            if width(fileIndexMap) < ii
                                fileIndexMap{idx1, ii} = mm;
                            else
                                fileIndexMap{idx1, ii} = [fileIndexMap{idx1, ii}, mm];
                            end
                            break
                        end
                    end
        
                    if isempty(idx1)
                        idx2 = numel(obj)+1;
                        
                        obj(idx2)     = SpecInfo(mm);
                        fileIndexMap{idx2, ii} = mm;
                    end
                end
            end
            
            % Pré-alocação:
            for ll = numel(obj):-1:1
                % Elimina fluxos filtrados...
                if ~obj(ll).Enable
                    delete(obj(ll))
                    obj(ll) = [];

                    fileIndexMap(ll,:) = [];        
                    continue
                end
        
                for mm = 1:width(fileIndexMap)
                    idxMap = fileIndexMap{ll,mm};

                    for kk = idxMap
                        nFiles = height(metaData(mm).Data(kk).RelatedFiles);
                        obj(ll).RelatedFiles(end+1:end+nFiles,:) = metaData(mm).Data(kk).RelatedFiles;
                    end
                end
                PreAllocationData(obj(ll));
            end
        end

        %-----------------------------------------------------------------%
        function comparableData = ComparableMetaData(obj, generalSettings)        
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
            if generalSettings.Merge.Antenna == "remove"
                metaData2Delete{end+1} = 'Antenna';
            end
            if generalSettings.Merge.DataType == "remove"
                metaData2Delete{end+1} = 'DataType';
            end

            % Estrutura de referência:        
            for ii = 1:numel(obj)
                tempStruct = rmfield(obj(ii).MetaData, metaData2Delete);
                tempStruct.Receiver = obj(ii).Receiver;

                if isfield(tempStruct, 'Antenna') && ~isempty(tempStruct.Antenna)
                    antennaFields = fields(tempStruct.Antenna);
                    antennaFields = antennaFields(~ismember(antennaFields, generalSettings.Merge.AntennaAttributes));
                    
                    tempStruct.Antenna = rmfield(tempStruct.Antenna, antennaFields);
                end
        
                comparableData(ii) = tempStruct;
            end
        end

        %-----------------------------------------------------------------%
        function obj = FinalOrganizationOfData(obj, prjInfo)
            obj = sort(obj, obj(1).sortType);

            for ii = 1:numel(obj)
                % Ordenando os dados...
                if ~issorted(obj(ii).Data{1})
                    [obj(ii).Data{1}, idx2] = sort(obj(ii).Data{1});
                    obj(ii).Data{2}         = obj(ii).Data{2}(:,idx2);
                end
        
                % GPS
                if height(obj(ii).RelatedFiles) > 1
                    fcn.gpsProperty(obj, ii)
                end
        
                % Estatística básica dos dados:
                basicStats(obj, ii)

                if ismember(obj(ii).MetaData.DataType, class.Constants.specDataTypes) && isempty(prjInfo)
                    % Mapeamento entre os fluxos de espectro e as canalizações
                    % aplicáveis à cada faixa.
                    obj(ii).UserData(1).channelLibIndex = FindRelatedBands(obj(ii).callingApp.channelObj, obj(ii));
                end
            end
        
            idxThreads = find(arrayfun(@(x) x.UserData.reportFlag, obj));
            class.userData.reportProperties_DefaultValues(obj, idxThreads, obj(1).callingApp)
        end

        %-----------------------------------------------------------------%
        function basicStats(obj, idx)
            obj(idx).Data{3} = [ min(obj(idx).Data{2}, [], 2), ...
                                mean(obj(idx).Data{2},     2), ...
                                 max(obj(idx).Data{2}, [], 2)];
        end

        %-----------------------------------------------------------------%
        function mergeType = identifyMergeType(obj, mergeTable)
            if isscalar(unique(mergeTable.FreqStart)) && ...
               isscalar(unique(mergeTable.FreqStop))  && ...
               isscalar(unique(mergeTable.DataPoints))
                mergeType = 'co-channel';

            elseif issorted(mergeTable.FreqStart, "strictascend")                                             && ...
               all(mergeTable.FreqStart(2:height(mergeTable)) <= mergeTable.FreqStop(1:height(mergeTable)-1))
                mergeType = 'adjacent-channel';
            
            else
                error(ErrorMessage(obj, 'merge'))
            end
        end

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
        function str = id2str(Type, ID)
            switch Type
                case 'TraceMode'
                    switch ID
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
                    switch ID
                        case 0; str = 'Sample';
                        case 1; str = 'Sample';
                        case 2; str = 'Average/RMS';
                        case 3; str = 'Positive Peak';
                        case 4; str = 'Negative Peak';
                    end        

                case 'LevelUnit'
                    switch ID
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
                                  'VBW',              ...
                                  'Unit',             ...
                                  'TraceMode',        ...
                                  'TraceIntegration', ...
                                  'Detector',         ...
                                  'gpsType',          ...
                                  'Latitude',         ...
                                  'Longitude'};
                otherwise
                    fieldsList = {};
            end

            fieldList2Remove  = fieldnames(originalMetaData);
            fieldList2Remove  = fieldList2Remove(ismember(fieldList2Remove, fieldsList));

            secundaryMetaData = rmfield(originalMetaData, fieldList2Remove);
            secundaryMetaData.FileFormat = fileFormat;

            secundaryMetaData = structUtil.sortByFieldNames(secundaryMetaData);
            secundaryMetaData = jsonencode(secundaryMetaData);
        end
    end
end