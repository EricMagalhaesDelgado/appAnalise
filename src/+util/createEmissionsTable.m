function emissionsTable = createEmissionsTable(specData, operationType)

    arguments
        specData
        operationType {mustBeMember(operationType, {'SIGNALANALYSIS: GUI', 'SIGNALANALYSIS: JSONFile', 'REPORT: JSONFile'})}
    end

    emissionsTable = [];
    emissionsTempTableCellArray = {};

    for ii = 1:numel(specData)
        emissionsTempTable                                = specData(ii).UserData.Emissions;

        emissionsTempTable.Truncated                      = arrayfun(@(x) x.userModified.Frequency,     emissionsTempTable.ChannelAssigned);
        if any(~emissionsTempTable.isTruncated)
            idxUntruncated = find(~emissionsTempTable.isTruncated);
            emissionsTempTable.Truncated(idxUntruncated)  = emissionsTempTable.Frequency(idxUntruncated);
        end

        emissionsTempTable.Band(:)                        = {sprintf('%.3f - %.3f MHz', specData(ii).MetaData.FreqStart/1e6, specData(ii).MetaData.FreqStop/1e6)};
        emissionsTempTable.idxThread(:)                   = ii;
        emissionsTempTable.idxEmission                    = (1:height(emissionsTempTable))';

        emissionsTempTable.Level_FreqCenter_Min           = arrayfun(@(x) x.Level.FreqCenter_Min,       emissionsTempTable.Measures);
        emissionsTempTable.Level_FreqCenter_Mean          = arrayfun(@(x) x.Level.FreqCenter_Mean,      emissionsTempTable.Measures);
        emissionsTempTable.Level_FreqCenter_Max           = arrayfun(@(x) x.Level.FreqCenter_Max,       emissionsTempTable.Measures);
        emissionsTempTable.FCO_FreqCenter_Infinite        = arrayfun(@(x) x.FCO.FreqCenter_Infinite,    emissionsTempTable.Measures);
        emissionsTempTable.FCO_FreqCenter_Finite_Min      = arrayfun(@(x) x.FCO.FreqCenter_Finite_Min,  emissionsTempTable.Measures);
        emissionsTempTable.FCO_FreqCenter_Finite_Mean     = arrayfun(@(x) x.FCO.FreqCenter_Finite_Mean, emissionsTempTable.Measures);
        emissionsTempTable.FCO_FreqCenter_Finite_Max      = arrayfun(@(x) x.FCO.FreqCenter_Finite_Max,  emissionsTempTable.Measures);
        emissionsTempTable.RFDataHubDescription           = arrayfun(@(x) x.userModified.Description,   emissionsTempTable.Classification, 'UniformOutput', false);

        if ismember(operationType, {'SIGNALANALYSIS: JSONFile', 'REPORT: JSONFile'})    
            emissionsTempTable.Type                       = arrayfun(@(x) x.userModified.EmissionType,  emissionsTempTable.Classification, 'UniformOutput', false);
            emissionsTempTable.Regulatory                 = arrayfun(@(x) x.userModified.Regulatory,    emissionsTempTable.Classification, 'UniformOutput', false);
            emissionsTempTable.Service                    = arrayfun(@(x) x.userModified.Service,       emissionsTempTable.Classification);
            emissionsTempTable.Station                    = arrayfun(@(x) x.userModified.Station,       emissionsTempTable.Classification);
            emissionsTempTable.Distance                   = arrayfun(@(x) x.userModified.Distance,      emissionsTempTable.Classification);            
            emissionsTempTable.Irregular                  = arrayfun(@(x) x.userModified.Irregular,     emissionsTempTable.Classification, 'UniformOutput', false);
            emissionsTempTable.RiskLevel                  = arrayfun(@(x) x.userModified.RiskLevel,     emissionsTempTable.Classification, 'UniformOutput', false);
    
            emissionsTempTable.RFDataHubSource            = repmat({''}, height(emissionsTempTable), 1);
            emissionsTempTable.RFDataHubClass             = repmat({''}, height(emissionsTempTable), 1);    
            for kk = 1:height(emissionsTempTable)
                try
                    stationInfo = jsondecode(emissionsTempTable.Classification(kk).userModified.Details);
    
                    emissionsTempTable.RFDataHubSource{kk} = stationInfo.Source;
                    emissionsTempTable.RFDataHubClass{kk}  = stationInfo.StationClass(1);
                catch
                end
            end
        end

        emissionsTempTableCellArray{end+1}                      = emissionsTempTable;
    end

    if ~isempty(emissionsTempTableCellArray)
        emissionsTable = sortrows(vertcat(emissionsTempTableCellArray{:}), {'Frequency', 'BW_kHz'});
    end
end