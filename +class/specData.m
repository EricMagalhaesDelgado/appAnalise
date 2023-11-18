classdef specData < handle

    properties
        %-----------------------------------------------------------------%
        Receiver
        MetaData     = struct('DataType',         [], ...                   % Valor numérico: RFlookBin (1-2), CRFSBin (4, 7-8, 60-65 e 67-69), Argus (167-168), CellPlan (1000) e SM1809 (1809)
                              'FreqStart',        [], ...                   % Valor numérico (em Hertz)
                              'FreqStop',         [], ...                   % Valor numérico (em Hertz)
                              'LevelUnit',        [], ...                   % dBm | dBµV | dBµV/m
                              'DataPoints',       [], ...
                              'Resolution',       -1, ...                   % Valor numérico (em Hertz) ou -1 (caso não registrado em arquivo)
                              'VBW',              -1, ...
                              'Threshold',        -1, ...
                              'TraceMode',        '', ...                   % "ClearWrite" | "Average" | "MaxHold" | "MinHold" | "OCC" | "SingleMeasurement" | "Mean" | "Peak" | "Minimum"
                              'TraceIntegration', -1, ...                   % Aplicável apenas p/ "Average", "MaxHold" ou "MinHold"
                              'Detector',         '', ...                   % "Sample" | "Average/RMS" | "Positive Peak" | "Negative Peak"
                              'Antenna',          [])
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
        function obj = PreAllocationData(obj, idx)

            if nargin == 1
                idx = 1;
            end

            obj(idx).Data = {repmat(datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss'), 1, sum(obj(idx).RelatedFiles.nSweeps)), ...
                             zeros(obj(idx).MetaData.DataPoints, sum(obj(idx).RelatedFiles.nSweeps), 'single'),                       ...
                             zeros(obj(idx).MetaData.DataPoints, 3, 'single')};
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
                        elseif contains(Format, 'RFlookBin v.1/1', "IgnoreCase", true)
                            SpecInfo = fileReader.RFlookBinV1(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                        elseif contains(Format, 'RFlookBin v.2/1', "IgnoreCase", true)
                            SpecInfo = fileReader.RFlookBinV2(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                        end
        
                    case '.dbm'
                        SpecInfo = fileReader.CellPlanDBM(app.metaData(ii).File, 'SpecData', app.metaData(ii), app.RootFolder);                        
        
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
                        idx1 = find(strcmp(app.specData(kk).RelatedFiles.uuid, unique(SpecInfo(jj).RelatedFiles.uuid)));
        
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
                SpecInfo_MetaData = class.specData.read_MetaData(SpecInfo);
                for jj = 1:numel(SpecInfo)
                    SpecInfo_GPS      = [SpecInfo(jj).GPS.Latitude, SpecInfo(jj).GPS.Longitude];
                    specData_MetaData = class.specData.read_MetaData(app.specData);
        
                    idx1 = [];
                    for kk = 1:numel(app.specData)
                        specData_GPS = [app.specData(kk).GPS.Latitude, app.specData(kk).GPS.Longitude];
                        Distance_GPS = fcn.geoDistance_v1(SpecInfo_GPS, specData_GPS) * 1000;
        
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
            ID = [];
            for ii = 1:numel(app.specData)
                ID = [ID; app.specData(ii).RelatedFiles.ID(1)];
            end
            [~,    idx1] = sortrows(table({app.specData.Receiver}', ID));
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
                app.specData(ii).Data{3}(:) = [ min(app.specData(ii).Data{2}, [], 2), ...
                                               mean(app.specData(ii).Data{2},     2), ...
                                                max(app.specData(ii).Data{2}, [], 2)];
        
                if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
                    % Mapeamento entre os fluxos de espectro e os de ocupação
                    % (eventualmente gerados pelo Logger):
                    idx3 = [];
                    for jj = 1:numel(app.specData)
                        if ismember(app.specData(jj).MetaData.DataType, class.Constants.occDataTypes)
                            idx3 = [idx3, jj];
                        end
                    end
        
                    for kk = idx3
                        logEvaluation = strcmp(app.specData(ii).Receiver, app.specData(kk).Receiver)                 & ...
                                        app.specData(ii).MetaData.FreqStart  == app.specData(kk).MetaData.FreqStart  & ...
                                        app.specData(ii).MetaData.FreqStop   == app.specData(kk).MetaData.FreqStop   & ...
                                        app.specData(ii).MetaData.DataPoints == app.specData(kk).MetaData.DataPoints;
            
                        if logEvaluation
                            app.specData(ii).UserData(1).occMethod.RelatedIndex = [app.specData(ii).UserData.occMethod.RelatedIndex, kk];
                        end
                    end
                    
                    try
                        if ~isempty(app.specData(ii).UserData.occMethod.RelatedIndex)
                            app.specData(ii).UserData.occMethod.SelectedIndex = app.specData(ii).UserData.occMethod.RelatedIndex(1);
                        end
                    catch
                    end
        
                    % Mapeamento entre os fluxos de espectro e as canalizações
                    % aplicáveis à cada faixa.
                    app.specData(ii).UserData(1).channelLibIndex = app.channelObj.FindRelatedBands(app.specData(ii));
                end
            end
        
            idx4 = find(arrayfun(@(x) x.UserData.reportFlag, app.specData));
            class.userData.reportProperties_DefaultValues(app, idx4)
        end
        
        
        %-----------------------------------------------------------------%
        function comparableData = read_MetaData(Data)
        
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
        
            % Exclui-se, dentre as campos de "MetaData", apenas DataType e Antenna.
            % O DataType por não estar relacionado à monitoração, mas como ela é
            % armazenada em arquivo; e a Antenna que é um metadado comumente incluso
            % manualmente pelo fiscal (exceção à monitoração conduzida na EMSat).
        
            for ii = 1:numel(Data)
                tempStruct = rmfield(Data(ii).MetaData, {'DataType', 'Antenna'});
                tempStruct.Receiver = Data(ii).Receiver;
        
                comparableData(ii) = tempStruct;
            end
        end
    end
end