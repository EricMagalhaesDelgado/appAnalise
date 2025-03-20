function emissionsAddedFlag = importAnalysis(app, specData, fileName)

    % Author.: Eric Magalhães Delgado
    % Date...: March 18, 2025
    % Version: 1.02

    load(fileName, '-mat', 'prj_Type', 'prj_Version', 'prj_specData', 'prj_Info')
    if ~strcmp(prj_Type, 'User data')
        error('Unexpected project type')
    elseif prj_Version ~= 3
        error('Unexpected project MAT-file version')
    end

    emissionsAddedFlag  = false;
    emissionsTable      = arrayfun(@(x) x.UserData.Emissions, prj_specData, 'UniformOutput', false);
    emissionsTable      = vertcat(emissionsTable{:});

    % class.specData é um objeto legado, usado até o appAnalise v. 1.85. 
    % Migrado p/ model.SpecDataBase (SupportPackage) e model.SpecData, mas 
    % mantido no projeto p/ garantir compatibilidade com a versão atual do 
    % appAnalise.
    if isa(prj_specData, 'class.specData')
        emissionsTable  = renamevars(emissionsTable, 'BW', 'BW_kHz');
        emissionsTable.Description = arrayfun(@(x) string(x.Description), emissionsTable.UserData);
    end

    emissionsTable.Lim1 = emissionsTable.Frequency*1e+6 - (emissionsTable.BW_kHz/2)*1000;      % Em Hz
    emissionsTable.Lim2 = emissionsTable.Frequency*1e+6 + (emissionsTable.BW_kHz/2)*1000;      % Em Hz

    for ii = 1:numel(specData)
        FreqStart  = specData(ii).MetaData.FreqStart;
        FreqStop   = specData(ii).MetaData.FreqStop;
        DataPoints = specData(ii).MetaData.DataPoints;

        idxNewEmissions = find((emissionsTable.Lim1 >= FreqStart) & (emissionsTable.Lim2 <= FreqStop));
        numEmissions    = numel(idxNewEmissions);
        if numEmissions
            newFreq     = emissionsTable.Frequency(idxNewEmissions);
            newIndex    = freq2idx(FreqStart, FreqStop, DataPoints, newFreq);
            newBW_kHz   = emissionsTable.BW_kHz(idxNewEmissions);
            Method      = repmat({jsonencode(struct('Algorithm', 'Manual'))}, numEmissions, 1);
            Description = emissionsTable.Description(idxNewEmissions);

            update(specData(ii), 'UserData:Emissions', 'Add', newIndex, newFreq, newBW_kHz, Method, Description, app.channelObj)

            % Insere as anotações manuais, mas precisa validar que a
            % emissão de fato foi incluída porque ela pode ter sido
            % eliminada por coincidência com outra, ou por não atender
            % algum filtro.
            if isa(prj_specData, 'class.specData')
                global RFDataHub
                exceptionList = prj_Info.exceptionList;

                for jj = 1:height(exceptionList)
                    idxException = find(abs(newFreq - exceptionList.Frequency(jj)) < 1e-5, 1);

                    if ~isempty(idxException)
                        if exceptionList.Station(jj) ~= -1
                            receiverLatitude  = specData(ii).GPS.Latitude;
                            receiverLongitude = specData(ii).GPS.Longitude;
                            stationInfo       = model.RFDataHub.query(RFDataHub, string(exceptionList.Station(jj)), receiverLatitude, receiverLongitude);

                            specData(ii).UserData.Emissions.Classification(idxException).userModified.Service       = stationInfo.Service;
                            specData(ii).UserData.Emissions.Classification(idxException).userModified.Station       = stationInfo.Station;
                            specData(ii).UserData.Emissions.Classification(idxException).userModified.Latitude      = stationInfo.Latitude;
                            specData(ii).UserData.Emissions.Classification(idxException).userModified.Longitude     = stationInfo.Longitude;
                            specData(ii).UserData.Emissions.Classification(idxException).userModified.AntennaHeight = stationInfo.AntennaHeight;
                            specData(ii).UserData.Emissions.Classification(idxException).userModified.Description   = stationInfo.Description;
                            specData(ii).UserData.Emissions.Classification(idxException).userModified.Details       = stationInfo.Details;
                            specData(ii).UserData.Emissions.Classification(idxException).userModified.Distance      = stationInfo.Distance;
                        end

                        specData(ii).UserData.Emissions.Classification(idxException).userModified.Regulatory        = exceptionList.Regulatory{jj};
                        specData(ii).UserData.Emissions.Classification(idxException).userModified.EmissionType      = exceptionList.Type{jj};
                        specData(ii).UserData.Emissions.Classification(idxException).userModified.Irregular         = exceptionList.Irregular{jj};
                        specData(ii).UserData.Emissions.Classification(idxException).userModified.RiskLevel         = exceptionList.RiskLevel{jj};
                    end
                end

            else
                for jj = 1:numEmissions
                    idxNewEmissionFrequency = find(specData(ii).UserData.Emissions.idxFrequency == newIndex(jj) & abs(specData(ii).UserData.Emissions.BW_kHz - newBW_kHz(jj)) < 1e-5, 1);
    
                    if ~isempty(idxNewEmissionFrequency)
                        emissionsAddedFlag = true;
    
                        if ~isequal(emissionsTable.Classification(idxNewEmissions(jj)).autoSuggested, emissionsTable.Classification(idxNewEmissions(jj)).userModified)
                            specData(ii).UserData.Emissions.Classification(idxNewEmissionFrequency).userModified = emissionsTable.Classification(idxNewEmissions(jj)).userModified;
                        end
    
                        if ~isequal(emissionsTable.ChannelAssigned(idxNewEmissions(jj)).autoSuggested, emissionsTable.ChannelAssigned(idxNewEmissions(jj)).userModified)
                            specData(ii).UserData.Emissions.ChannelAssigned(idxNewEmissionFrequency).userModified = emissionsTable.ChannelAssigned(idxNewEmissions(jj)).userModified;
                        end
                    end
                end
            end
        end
    end
end


%-------------------------------------------------------------------------%
function idxArray = freq2idx(FreqStart, FreqStop, DataPoints, FreqArrayInMHz)
    aCoef    = (FreqStop - FreqStart) / (DataPoints - 1);
    bCoef    = FreqStart - aCoef;
    idxArray = round((FreqArrayInMHz*1e+6 - bCoef) / aCoef);
end