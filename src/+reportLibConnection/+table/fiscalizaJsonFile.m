function tableStr = fiscalizaJsonFile(specData, idxThreads, emissionsTable)
    
    % Tabelas que irão compor o JSON que será carregado como anexo
    % à inspeção (no Fiscaliza).
    TaskTable   = table('Size', [0, 12],                                                                                                                 ...
                        'VariableTypes', {'uint16', 'cell', 'single', 'single', 'double', 'double', 'cell', 'cell', 'uint32', 'double', 'cell', 'cell'}, ...
                        'VariableNames', {'PK1', 'Node', 'Latitude', 'Longitude', 'FreqStart', 'FreqStop', 'BeginTime', 'EndTime', 'Samples', 'timeOCC', 'Description', 'RelatedFiles'});

    occMethodTable      = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK2', 'occMethod'});
    DetectionTable      = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK3', 'Detection'});
    ClassificationTable = table('Size', [0, 2], 'VariableTypes', {'uint16', 'cell'}, 'VariableNames', {'PK4', 'Classification'});
    
    PeakTable           = emissionsTable; % countTable(:,5:21);
    PeakTable.Frequency = round(PeakTable.Frequency, 3);
    PeakTable.BW        = round(PeakTable.BW_kHz, 1);

    jj = 0;
    for ii = idxThreads
        if ismember(specData(ii).MetaData.DataType, class.Constants.specDataTypes)
            jj = jj+1;

            occInfo = specData(ii).UserData.reportAlgorithms.Occupancy;
            if ~isempty(occInfo.IntegrationTime)
                IntegrationTime = occInfo.IntegrationTime;
            else
                IntegrationTime = occInfo.IntegrationTimeCaptured;
            end
            
            TaskTable(end+1,:) = {jj,                              ...
                                  specData(ii).Receiver,           ...
                                  specData(ii).GPS.Latitude,       ...
                                  specData(ii).GPS.Longitude,      ...
                                  specData(ii).MetaData.FreqStart / 1e+6, ...
                                  specData(ii).MetaData.FreqStop  / 1e+6, ...
                                  datestr(specData(ii).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), ...
                                  datestr(specData(ii).Data{1}(end), 'dd/mm/yyyy HH:MM:SS'), ...
                                  numel(specData(ii).Data{1}),      ...
                                  IntegrationTime,                      ...
                                  specData(ii).RelatedFiles.Description{1}, ...
                                  strjoin(specData(ii).RelatedFiles.File, ', ')};
            
            Tag = sprintf('%s\n%.3f - %.3f MHz', specData(ii).Receiver,                  ...
                                                 specData(ii).MetaData.FreqStart / 1e+6, ...
                                                 specData(ii).MetaData.FreqStop  / 1e+6);
            
            idx1 = find(PeakTable.idxThread == ii);
            if ~isempty(idx1)
                PeakTable.FK1(idx1) = uint16(jj);
            end
        end
    end

    % occMethod, detection and classification tables
    occMethodList      = arrayfun(@(x) x.Occupancy,      emissionsTable.Algorithms, 'UniformOutput', false);
    DetectionList      = arrayfun(@(x) x.Detection,      emissionsTable.Algorithms, 'UniformOutput', false);
    ClassificationList = arrayfun(@(x) x.Classification, emissionsTable.Algorithms, 'UniformOutput', false);

    occMethod          = unique(occMethodList);
    Detection          = unique(DetectionList);
    Classification     = unique(ClassificationList);

    occMethodTable(1:numel(occMethod),:)           = [num2cell((1:numel(occMethod))'), occMethod];
    DetectionTable(1:numel(Detection),:)           = [num2cell((1:numel(Detection))'), Detection];    
    ClassificationTable(1:numel(Classification),:) = [num2cell((1:numel(Classification))'), Classification];

    for ii = 1:numel(occMethod)
        idx_OCC = find(strcmp(occMethodList, occMethod(ii)));

        if ~isempty(idx_OCC); PeakTable.FK2(idx_OCC) = uint16(ii);
        end                
    end

    for ii = 1:numel(Detection)
        idx_Det = find(strcmp(DetectionList, Detection(ii)));

        if ~isempty(idx_Det); PeakTable.FK3(idx_Det) = uint16(ii);
        end
    end

    for ii = 1:numel(Classification)
        idx_Cla = find(strcmp(ClassificationList, Classification(ii)));

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