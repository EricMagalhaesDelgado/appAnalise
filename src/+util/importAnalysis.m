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

    % EMISSIONS TABLE
    emissionsTable      = arrayfun(@(x) x.UserData.Emissions, prj_specData, 'UniformOutput', false);
    emissionsTable      = vertcat(emissionsTable{:});

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


%-------------------------------------------------------------------------%
function idxArray = freq2idx(FreqStart, FreqStop, DataPoints, FreqArrayInMHz)
    aCoef    = (FreqStop - FreqStart) / (DataPoints - 1);
    bCoef    = FreqStart - aCoef;
    idxArray = round((FreqArrayInMHz*1e+6 - bCoef) / aCoef);
end