function Read_specData(app, d)
    
    % Organização dos fluxos de dados e pré-alocação
    samplesMap = specDataReader_Map(app);

    for ii = 1:numel(app.metaData)
        [~, name, ext] = fileparts(app.metaData(ii).File);
        fileName = [name ext];
        d.Message = sprintf('<font style="font-size:12;">In progress reading spectral data from the file below:\n• %s\n\n%d of %d</font>', fileName, ii, numel(app.metaData));
        
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
                    File_specDataReader_OpenProject(app, prj_Info)
                end
        end
        
        % Eliminar alguns campos para possibilitar comparar o fluxo
        % lido (SpecInfo >> auxSpecInfo) com o já salvo (app.specData >> auxSpecData)
        auxSpecInfo = specDataReader_MetaData(SpecInfo);
        auxSpecData = specDataReader_MetaData(app.specData);
        
        for jj = 1:numel(SpecInfo)
            % Necessário pois no leitor do RFLookBin, por exemplo, não é lida a
            % informação de GPS.
            if isempty(SpecInfo(jj).RelatedFiles) || isempty(SpecInfo(jj).RelatedGPS) || isempty(SpecInfo(jj).GPS)
                SpecInfo(jj).RelatedFiles = app.metaData(ii).Data(jj).RelatedFiles;
                SpecInfo(jj).RelatedGPS   = app.metaData(ii).Data(jj).RelatedGPS;
                SpecInfo(jj).GPS          = app.metaData(ii).Data(jj).GPS;
            end
            auxSpecInfo_GPS = [SpecInfo(jj).GPS.Latitude, SpecInfo(jj).GPS.Longitude];
            
            ind1 = [];
            for kk = 1:numel(app.specData)
                auxSpecData_GPS = [app.specData(kk).GPS.Latitude, app.specData(kk).GPS.Longitude];
                Distance_GPS    = geoDistance_v1(auxSpecInfo_GPS, auxSpecData_GPS) * 1000;
                
                if isequal(auxSpecData(kk), auxSpecInfo(jj)) && (Distance_GPS <= class.Constants.mergeDistance)
                    ind1 = kk;
                    break
                end
            end

            if isempty(ind1)
                continue
            end
            
            if ii == 1; ind2 = 1;
            else;       ind2 = sum(samplesMap(ind1, 1:(ii-1)))+1;
            end
            ind3 = sum(samplesMap(ind1, 1:ii));
            
            try
                app.specData(ind1).Data{1}(1,ind2:ind3) = SpecInfo(jj).Data{1};
                app.specData(ind1).Data{2}(:,ind2:ind3) = SpecInfo(jj).Data{2};
            catch
                pause(1)
            end
            
            if ~any(contains(app.specData(ind1).RelatedFiles.Name, SpecInfo(jj).RelatedFiles.Name))
                app.specData(ind1).RelatedFiles(end+1:end+height(SpecInfo(jj).RelatedFiles), :) = SpecInfo(jj).RelatedFiles; 
                app.specData(ind1).RelatedGPS   = [app.specData(ind1).RelatedGPS,   SpecInfo(jj).RelatedGPS];
            end
        end
    end
    
    % Manipulações acessórias
    d.Message = '<font style="font-size:12;">In progress others manipulations, such as statistical measures and identification of occupancy flow...</font>';
    specDataReader_FinalOperation(app)
end


%-------------------------------------------------------------------------%
function samplesMap = specDataReader_Map(app)
    for ii = 1:numel(app.metaData)
        SpecInfo         = app.metaData(ii).Data;
        SpecInfo.FileMap = [];

        auxSamples = app.metaData(ii).Samples;
        if isempty(auxSamples); auxSamples = 0;
        end

        % Inicialização de app.specData...
        if ii == 1
            app.specData = SpecInfo;
            samplesMap   = auxSamples;
            continue
        end

        % Mapeamento entre os fluxos...
        auxSpecInfo = specDataReader_MetaData(SpecInfo);
        for jj = 1:numel(SpecInfo)
            auxSpecInfo_GPS = [SpecInfo(jj).GPS.Latitude, SpecInfo(jj).GPS.Longitude];
            auxSpecData     = specDataReader_MetaData(app.specData);

            idx1 = [];
            for kk = 1:numel(app.specData)
                auxSpecData_GPS = [app.specData(kk).GPS.Latitude, app.specData(kk).GPS.Longitude];
                Distance_GPS    = geoDistance_v1(auxSpecInfo_GPS, auxSpecData_GPS) * 1000;

                if isequal(auxSpecData(kk), auxSpecInfo(jj)) && (Distance_GPS <= class.Constants.mergeDistance)
                    idx1 = kk;
                    samplesMap(kk, ii) = auxSamples(jj);
                    break
                end
            end

            if isempty(idx1)
                idx2 = numel(app.specData)+1;
                
                app.specData(idx2)    = SpecInfo(jj);
                samplesMap(idx2, ii) = auxSamples(jj);
            end
        end
    end
    
    % Pré-alocação
    totalSamples = sum(samplesMap, 2);
    for ii = 1:numel(app.specData)
        app.specData(ii).Samples = totalSamples(ii);
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
        ID = [ID; app.specData(ii).TaskData.ID];
    end
    [~,    idx1] = sortrows(table({app.specData.Receiver}', ID));
    app.specData = app.specData(idx1);
    
    for ii = 1:numel(app.specData)
        % Sorting data...
        if ~issorted(app.specData(ii).Data{1})
            [app.specData(ii).Data{1}, idx2] = sort(app.specData(ii).Data{1});
            app.specData(ii).Data{2}         = app.specData(ii).Data{2}(:,idx2);
        end

        if height(app.specData(ii).RelatedFiles) > 1
            app.specData(ii).ObservationTime = sprintf('%s - %s', datestr(app.specData(ii).Data{1}(1), 'dd/mm/yyyy HH:MM:SS'), datestr(app.specData(ii).Data{1}(end), 'dd/mm/yyyy HH:MM:SS'));
        end

        % GPS
        if numel(app.specData(ii).RelatedGPS) > 1
            app.specData(ii).GPS = rmfield(gpsSummary(app.specData(ii).RelatedGPS), 'Matrix');
        end

        % Basic statistical of the data, and OCC map
        if ismember(app.specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            app.specData(ii).Data{3} = [min(app.specData(ii).Data{2}, [], 2),                                         ...
                                        eval(sprintf('%s(app.specData(ii).Data{2}, 2)', class.Constants.averageFcn)), ...
                                        max(app.specData(ii).Data{2}, [], 2)];
    
            occInd = [];
            for jj = 1:numel(app.specData)
                if ismember(app.specData(jj).MetaData.DataType, class.Constants.occDataTypes)
                    occInd = [occInd, jj];
                end
            end

            for kk = occInd
                logEvaluation = strcmp(app.specData(ii).Receiver, app.specData(kk).Receiver)                 & ...
                                app.specData(ii).MetaData.FreqStart  == app.specData(kk).MetaData.FreqStart  & ...
                                app.specData(ii).MetaData.FreqStop   == app.specData(kk).MetaData.FreqStop   & ...
                                app.specData(ii).MetaData.DataPoints == app.specData(kk).MetaData.DataPoints;
    
                if logEvaluation
                    app.specData(ii).UserData.reportOCC.Related = [app.specData(ii).UserData.reportOCC.Related, kk];
                end
            end
            
            if ~isempty(app.specData(ii).UserData.reportOCC.Related)
                app.specData(ii).UserData.reportOCC.Index = app.specData(ii).UserData.reportOCC.Related(1);
            end
            
        elseif ismember(app.specData(ii).MetaData.DataType, class.Constants.occDataTypes)
            app.specData(ii).Data{3} = [min(app.specData(ii).Data{2}, [], 2),                                         ...
                                        eval(sprintf('%s(app.specData(ii).Data{2}, 2)', class.Constants.averageFcn)), ...
                                        max(app.specData(ii).Data{2}, [], 2)];
        end
    end    
end


%-------------------------------------------------------------------------%
function ComparableData = specDataReader_MetaData(RawData)

    for ii = 1:numel(RawData)
        tempStruct = RawData(ii).MetaData;
        tempStruct.Receiver = RawData(ii).Receiver;

        ComparableData(ii) = tempStruct;
    end
end