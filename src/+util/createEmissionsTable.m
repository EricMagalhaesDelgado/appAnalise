function emissionsTable = createEmissionsTable(specData, idxThreads, operationType)

    arguments
        specData
        idxThreads
        operationType {mustBeMember(operationType, {'SIGNALANALYSIS: GUI', 'SIGNALANALYSIS: JSONFile', 'REPORT: JSONFile', 'REPORT: HTMLFile'})}
    end

    if isempty(idxThreads)
        % Cria-se um objeto "SpecData" apenas p/ identificar formato base
        % da tabela Emissions. Adiciona-se as colunas requeridas pela GUI.
        
        % ToDo: 
        % Evoluir, estabelecendo estrutura de emissionsTable.
        specTempData = model.SpecData;
        specTempData.UserData(1).LOG = '';

        emissionsTable                               = specTempData.UserData.Emissions;
        emissionsTable.Truncated(:)                  = zeros(0);
        emissionsTable.Level_FreqCenter_Min(:)       = zeros(0);
        emissionsTable.Level_FreqCenter_Mean(:)      = zeros(0);
        emissionsTable.Level_FreqCenter_Max(:)       = zeros(0);
        emissionsTable.FCO_FreqCenter_Infinite(:)    = zeros(0);
        emissionsTable.FCO_FreqCenter_Finite_Min(:)  = zeros(0);
        emissionsTable.FCO_FreqCenter_Finite_Mean(:) = zeros(0);
        emissionsTable.FCO_FreqCenter_Finite_Max(:)  = zeros(0);
        emissionsTable.RFDataHubDescription(:)       = {};

    else
        emissionsTempTableCellArray = {};
    
        for ii = idxThreads
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
    
            emissionsTempTable.RFDataHubDescription_auto      = arrayfun(@(x) x.autoSuggested.Description,  emissionsTempTable.Classification, 'UniformOutput', false);
            emissionsTempTable.RFDataHubDescription           = arrayfun(@(x) x.userModified.Description,   emissionsTempTable.Classification, 'UniformOutput', false);
    
            if ismember(operationType, {'SIGNALANALYSIS: JSONFile', 'REPORT: JSONFile', 'REPORT: HTMLFile'})
                emissionsTempTable.Type                       = arrayfun(@(x) x.userModified.EmissionType,  emissionsTempTable.Classification, 'UniformOutput', false);
                emissionsTempTable.Regulatory                 = arrayfun(@(x) x.userModified.Regulatory,    emissionsTempTable.Classification, 'UniformOutput', false);
                emissionsTempTable.Service                    = arrayfun(@(x) x.userModified.Service,       emissionsTempTable.Classification);
                emissionsTempTable.Station                    = arrayfun(@(x) x.userModified.Station,       emissionsTempTable.Classification);
                
                emissionsTempTable.Distance_auto              = arrayfun(@(x) x.autoSuggested.Distance,     emissionsTempTable.Classification);
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
    
            emissionsTempTableCellArray{end+1}                 = emissionsTempTable;
        end
    
        emissionsTable = sortrows(vertcat(emissionsTempTableCellArray{:}), {'Frequency', 'BW_kHz'});
    
        % Mesclar descrição obtida do RFDataHub com a inserida pelo usuário.
        switch operationType
            case {'SIGNALANALYSIS: JSONFile', 'REPORT: JSONFile'}
                emissionsTable.MergedDescriptions = emissionsTable.RFDataHubDescription;
    
                idxUserDescription = find(emissionsTable.Description ~= "" & ~ismissing(emissionsTable.Description));
                if ~isempty(idxUserDescription)
                    emissionsTable.MergedDescriptions(idxUserDescription) = strcat(emissionsTable.RFDataHubDescription(idxUserDescription), ' (',  cellstr(emissionsTable.Description(idxUserDescription)), ')');
                end
    
            case {'REPORT: HTMLFile'}
                emissionsTable.Distance_auto    = replace(arrayfun(@(x) sprintf('%.1f', x), emissionsTable.Distance_auto, 'UniformOutput', false), '-1.0', '-');
                emissionsTable.Distance         = replace(arrayfun(@(x) sprintf('%.1f', x), emissionsTable.Distance,      'UniformOutput', false), '-1.0', '-');
    
                emissionsTable.MergedDescriptions = emissionsTable.RFDataHubDescription;
    
                idxClassification  = find(cellfun(@(x,y) ~isequal(x,y), emissionsTable.RFDataHubDescription_auto, emissionsTable.RFDataHubDescription));
                for jj = idxClassification'
                    if emissionsTable.RFDataHubDescription_auto{jj} == "-"
                        Description = sprintf('<font style="color: #ff0000;">%s</font>', emissionsTable.RFDataHubDescription{jj});
                        Distance    = sprintf('<font style="color: #ff0000;">%s</font>', emissionsTable.Distance{jj});
                    else
                        Description = sprintf('<del>%s</del></p> <p class="Tabela_Texto_8" contenteditable="false" style="color: #ff0000;">%s', emissionsTable.RFDataHubDescription_auto{jj}, emissionsTable.RFDataHubDescription{jj});
                        Distance    = sprintf('<del>%s</del></p> <p class="Tabela_Texto_8" contenteditable="false" style="color: #ff0000;">%s', emissionsTable.Distance_auto{jj},             emissionsTable.Distance{jj});
                    end
    
                    emissionsTable.MergedDescriptions{jj} = Description;
                    emissionsTable.Distance{jj}           = Distance;
                end
    
                idxUserDescription = find(emissionsTable.Description ~= "" & ~ismissing(emissionsTable.Description));
                for kk = idxUserDescription'
                    emissionsTable.MergedDescriptions{kk} = sprintf('%s</p> <p class="Tabela_Texto_8" contenteditable="false" style="color: #0000ff;">(%s)', emissionsTable.MergedDescriptions{kk}, emissionsTable.Description(kk));
                end
        end
    end
end