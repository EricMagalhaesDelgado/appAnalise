function emissionsAddedFlag = importAnalysis(app, specData, fileName)

    % Author.: Eric Magalhães Delgado
    % Date...: February 20, 2025
    % Version: 1.01

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

    emissionsDetection  = jsonencode(struct('Algorithm', 'Manual'));

    for ii = 1:numel(specData)
        FreqStart  = specData(ii).MetaData.FreqStart;
        FreqStop   = specData(ii).MetaData.FreqStop;
        DataPoints = specData(ii).MetaData.DataPoints;

        idxNewEmissions = find((emissionsTable.Lim1 >= FreqStart) & (emissionsTable.Lim2 <= FreqStop));
        if ~isempty(idxNewEmissions)
            emissionsAddedFlag = true;

            % Frequency-Index Mapping
            [aCoef, ...
             bCoef]   = idxFrequencyMap(FreqStart, FreqStop, DataPoints);

            newIndex  = round((newFreq*1e+6 - bCoef) / aCoef);
            newFreq   = emissionsTable.Frequency(idxNewEmissions);
            newBW_kHz = emissionsTable.BW_kHz(idxNewEmissions);
            Method    = repmat(emissionsDetection, numel(idxNewEmissions), 1);

            update(specData(ii), 'UserData:Emissions', 'Add', newIndex, newFreq, newBW_kHz, Method)

            play_BandLimits_updateEmissions(app, ii, newIndex, updatePlotFlag)
            play_UpdatePeaksTable(app, ii, 'playback.AddEditOrDeleteEmission')

            % Verifica se as frequências das emissões constam na lista de exceção.
            % Caso sim, adiciona a informação em app.exceptionList, editando 
            % o "Tag" de cada registro. Caso já exista registro com uma das
            % frequências, por outro lado, essa informação não é acrescida.
            if ~isempty(prj_Info.exceptionList)
                threadTag = Tag(specData, ii);

                for kk = 1:numel(newFreq)
                    idx3 = find(abs(prj_Info.exceptionList.Frequency - newFreq(kk)) <= class.Constants.floatDiffTolerance);
                    for ll = idx3'
                        idx4 = find(strcmp(app.projectData.exceptionList.Tag, threadTag) & (abs(app.projectData.exceptionList.Frequency-prj_Info.exceptionList.Frequency(ll)) <= class.Constants.floatDiffTolerance), 1);
                        
                        if isempty(idx4)
                            app.projectData.exceptionList(end+1,:) = prj_Info.exceptionList(ll,:);
                            app.projectData.exceptionList.Tag{end} = threadTag;
                        end
                    end
                end
            end
        end
    end
end


%-------------------------------------------------------------------------%
function [aCoef, bCoef] = idxFrequencyMap(FreqStart, FreqStop, DataPoints)
    aCoef = (FreqStop - FreqStart) / (DataPoints - 1);
    bCoef = FreqStart - aCoef;
end