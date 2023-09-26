function Read_specData(app, d)
    
    % Organização dos fluxos de dados.
    specDataReader_Map(app)

    for ii = 1:numel(app.metaData)
        [~, name, ext] = fileparts(app.metaData(ii).File);
        fileName = [name ext];
        d.Message = sprintf('<font style="font-size:12;">Em andamento a leitura dos dados de espectro do arquivo:\n• %s\n\n%d de %d</font>', fileName, ii, numel(app.metaData));
        
        switch lower(ext)
            case '.bin'
                fileID = fopen(app.metaData(ii).File);
                Format = fread(fileID, [1 36], '*char');
                fclose(fileID);

                if contains(Format, 'CRFS', "IgnoreCase", true)
                    SpecInfo = fileReader.CRFSBin(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                elseif contains(Format, 'RFlookBin v.1/1', "IgnoreCase", true)
                    SpecInfo = fileReader.RFLookBin(app.metaData(ii).File, 'SingleFile');
                elseif contains(Format, 'RFlookBin v.2/1', "IgnoreCase", true)
                    SpecInfo = fileReader.RFlookBinV2(app.metaData(ii).File, 'SpecData', app.metaData(ii));
                end

            case '.dbm'
                SpecInfo = fileReader.CellPlanDBM(app.metaData(ii).File, 'SpecData', app.metaData(ii), app.RootFolder);                        

            case '.sm1809'
                SpecInfo = fileReader.SM1809(app.metaData(ii).File, 'SpecData', app.metaData(ii));
            
            case '.csv'
                SpecInfo = app.metaData(ii).Data;

            case '.mat'
                load(app.metaData(ii).File, '-mat', 'prj_specData', 'prj_Info');
                
                if strcmp(app.metaData(ii).Type{1}, 'Spectral data')
                    SpecInfo = prj_specData;
                else
                    SpecInfo = rmfield(prj_specData, {'Emissions', 'reportFlag', 'reportOCC', 'reportDetection', 'reportClassification', 'reportAttachments'});
                    specDataReader_OpenProject(app, prj_Info)
                end
        end
        
        % Identificar fluxo lido (SpecInfo) com o já salvo (app.specData)
        
        for jj = 1:numel(SpecInfo)
            for kk = 1:numel(app.specData)
                idx1 = find(strcmp(app.specData(kk).RelatedFiles.uuid, SpecInfo(jj).RelatedFiles.uuid));

                if ~isempty(idx1)
                    break
                end
            end

            if isempty(idx1)
                continue
            end
            
            if idx1 == 1; idx2 = 1;
            else;         idx2 = sum(app.specData(kk).RelatedFiles.nSweeps(1:(idx1-1)))+1;
            end
            idx3 = sum(app.specData(kk).RelatedFiles.nSweeps(1:idx1));
            
            app.specData(kk).Data{1}(1,idx2:idx3) = SpecInfo(jj).Data{1};
            app.specData(kk).Data{2}(:,idx2:idx3) = SpecInfo(jj).Data{2};
        end
    end
    
    % Manipulações acessórias.
    d.Message = '<font style="font-size:12;">Em andamento outras manipulações, como aferição de dados estatísticas e identificaçã do fluxo de ocupação...</font>';
    specDataReader_FinalOperation(app)
end


%-------------------------------------------------------------------------%
function specDataReader_Map(app)

    for ii = 1:numel(app.metaData)
        SpecInfo  = copy(app.metaData(ii).Data, {'RelatedFiles', 'FileMap'});

        % auxSamples e fileIndexMap são duas matrizes que mapeiam o número de 
        % amostras e a sua posição em app.metaData(ii).Data(jj), respectivamente. 
        % São essenciais na leitura das matrizes de níveis, visto que possibilitam 
        % a pré-alocação.
        auxSamples = app.metaData(ii).Samples;
        if isempty(auxSamples)
            auxSamples = 0;
        end

        % Inicialização de app.specData...
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
                app.specData(ii).RelatedFiles(end+1,:) = app.metaData(jj).Data(kk).RelatedFiles;
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
        app.specData(ii).UserData(1).reportFlag = false;

        % Sorting data...
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

        % Basic statistical of the data, and OCC map
        app.specData(ii).Data{3} = [min(app.specData(ii).Data{2}, [], 2), ...
                                    mean(app.specData(ii).Data{2}, 2),    ...
                                    max(app.specData(ii).Data{2}, [], 2)];

        if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            idxOCC = [];
            for jj = 1:numel(app.specData)
                if ismember(app.specData(jj).MetaData.DataType, class.Constants.occDataTypes)
                    idxOCC = [idxOCC, jj];
                end
            end

            for kk = idxOCC
                logEvaluation = strcmp(app.specData(ii).Receiver, app.specData(kk).Receiver)                 & ...
                                app.specData(ii).MetaData.FreqStart  == app.specData(kk).MetaData.FreqStart  & ...
                                app.specData(ii).MetaData.FreqStop   == app.specData(kk).MetaData.FreqStop   & ...
                                app.specData(ii).MetaData.DataPoints == app.specData(kk).MetaData.DataPoints;
    
                if logEvaluation
                    app.specData(ii).UserData.reportOCC.Related = [app.specData(ii).UserData.reportOCC.Related, kk];
                end
            end
            
            if ~isempty(app.specData(ii).UserData.reportOCC.Related)
                app.specData(ii).UserData.reportOCC.idx = app.specData(ii).UserData.reportOCC.Related(1);
            end
        end
    end
end


%-------------------------------------------------------------------------%
function ComparableData = specDataReader_MetaData(app, RawData)

    % Inicialmente, busca-se no arquivo de configuração (GeneralSettings.json)
    % se campos opcionais devem ser desconsiderados dessa análise.
    % Atualmente, apenas dois campos opcionais - "DataType" e "Antenna". Os
    % outros são todos essenciais, não podendo ser desconsiderados da análise.

    field2remove = {};
    if strcmp(app.General.Merge.DataType, 'remove')
        field2remove = {'DataType'};
    end
    
    if strcmp(app.General.Merge.Antenna, 'remove')
        field2remove = [field2remove, 'Antenna'];
    end

    for ii = 1:numel(RawData)
        tempStruct = RawData(ii).MetaData;
        tempStruct.Receiver = RawData(ii).Receiver;

        if ~isempty(field2remove)
            tempStruct = rmfield(tempStruct, field2remove);
        end

        ComparableData(ii) = tempStruct;
    end
end


%-------------------------------------------------------------------------%
function specDataReader_OpenProject(app, prj_Info)

    idx = find(ismember([app.metaData.Type], {'Project data'}));
    app.ProjectFilename.Value = app.metaData(idx).File;
    
    app.ProjectName.Value    = prj_Info.Name;
    app.peaksTable           = prj_Info.peaksTable;
    app.exceptionList        = prj_Info.exceptionList;
    app.Report_Issue.Value   = prj_Info.reportInfo.Issue;
    app.Report_Version.Value = prj_Info.reportInfo.General.Version;

    Type = prj_Info.reportInfo.Model.Name;
    if ismember(Type, app.Report_Type.Items)
        app.Report_Type.Value        = Type;
    else
        app.Report_Type.Items{end+1} = Type;
        app.Report_Type.Value        = app.Report_Type{end};
        
        app.General.Models(end+1,:)  = prj_Info.reportInfo.Name;
    end

    app.projData                 = prj_Info.reportInfo.Attachments;

    app.Report_DatePicker1.Value = prj_Info.reportInfo.TimeStamp(1);
    app.Report_Spinner1.Value    = hour(prj_Info.reportInfo.TimeStamp(1));
    app.Report_Spinner2.Value    = minute(prj_Info.reportInfo.TimeStamp(1));
                
    app.Report_DatePicker2.Value = prj_Info.reportInfo.TimeStamp(2);
    app.Report_Spinner3.Value    = hour(prj_Info.reportInfo.TimeStamp(2));
    app.Report_Spinner4.Value    = minute(prj_Info.reportInfo.TimeStamp(2));
    
    app.Report_ImageWarn.Visible = 0;                
end