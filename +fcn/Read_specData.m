function Read_specData(app, d)
    
    % Organização dos fluxos de dados.
    specDataReader_Map(app)

    exceptionListFlag = true;
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

                if ~isempty(prjInfo.exceptionList) && exceptionListFlag
                    exceptionListFlag     = false;
                    
                    app.exceptionList     = prjInfo.exceptionList;
                    app.exceptionList.Tag = replace(prjInfo.exceptionList.Tag, 'ThreadID', 'ID');
                end
            end
        end
    end
    
    % Manipulações acessórias.
    d.Message = '<font style="font-size:12;">Em andamento outras manipulações, como aferição de dados estatísticas e identificação do fluxo de ocupação...</font>';
    specDataReader_FinalOperation(app)
end


%-------------------------------------------------------------------------%
function specDataReader_Map(app)

    for ii = 1:numel(app.metaData)
        SpecInfo  = copy(app.metaData(ii).Data, {'RelatedFiles', 'FileMap'});

        if ii == 1
            app.specData = SpecInfo;
            fileIndexMap = num2cell((1:numel(app.metaData(ii).Data))');
            continue
        end

        % Mapeamento entre os fluxos...
        SpecInfo_MetaData = specDataReader_MetaData(app, SpecInfo);
        for jj = 1:numel(SpecInfo)
            SpecInfo_GPS      = [SpecInfo(jj).GPS.Latitude, SpecInfo(jj).GPS.Longitude];
            specData_MetaData = specDataReader_MetaData(app, app.specData);

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
    specDataReader_PreAllocationData(app, fileIndexMap);
end


%-------------------------------------------------------------------------%
function specDataReader_PreAllocationData(app, fileIndexMap)

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
        app.specData(ii) = app.specData(ii).PreAllocationData();
    end
end


%-------------------------------------------------------------------------%
function specDataReader_FinalOperation(app)

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
            gpsStatus = max(cellfun(@(x) x.Status, app.specData(ii).RelatedFiles.GPS));
            if gpsStatus
                gpsData = struct('Status', gpsStatus, ...
                                 'Matrix', cell2mat(cellfun(@(x) x.Matrix, app.specData(ii).RelatedFiles.GPS, 'UniformOutput', false)));
                app.specData(ii).GPS = rmfield(fcn.gpsSummary({gpsData}), 'Matrix');
            end
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


%-------------------------------------------------------------------------%
function ComparableData = specDataReader_MetaData(app, RawData)

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

    for ii = 1:numel(RawData)
        tempStruct = rmfield(RawData(ii).MetaData, {'DataType', 'Antenna'});
        tempStruct.Receiver = RawData(ii).Receiver;

        ComparableData(ii) = tempStruct;
    end
end