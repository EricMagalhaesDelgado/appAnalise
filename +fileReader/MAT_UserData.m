function MAT_UserData(app, fileName)

    % Author.: Eric Magalhães Delgado
    % Date...: November 27, 2023
    % Version: 1.00

    load(fileName, '-mat', 'prj_Type', 'prj_specData', 'prj_Info')

    if ~strcmp(prj_Type, 'User data')
        error('fileReader:MAT_UserData', 'Not expected MAT-file type.')
    end

    % Concatena todas as tabelas de emissões...
    Emissions = table(uint32([]), [], [], true(0,1), {}, struct('Description', {}, 'ChannelAssigned', {}, 'DriveTest', {}), ...
                      'VariableNames', {'Index', 'Frequency', 'BW', 'isTruncated', 'Detection', 'UserData'});

    for ii = 1:numel(prj_specData)
        Emissions = [Emissions; prj_specData(ii).UserData.Emissions];
    end

    Emissions.Lim1 = Emissions.Frequency*1e+6 - (Emissions.BW/2)*1000;      % Em Hz
    Emissions.Lim2 = Emissions.Frequency*1e+6 + (Emissions.BW/2)*1000;      % Em Hz

    % Verifica se as emissões pertencem ao fluxo espectral, atualizando a lista...
    idx1 = app.play_PlotPanel.UserData.NodeData;

    for ii = 1:numel(app.specData)
        FreqStart  = app.specData(ii).MetaData.FreqStart;
        FreqStop   = app.specData(ii).MetaData.FreqStop;
        DataPoints = app.specData(ii).MetaData.DataPoints;

        idx2 = find((Emissions.Lim1 >= FreqStart) & (Emissions.Lim2 <= FreqStop));
        if ~isempty(idx2)
            [aCoef, bCoef] = idxFrequencyMap(FreqStart, FreqStop, DataPoints);

            newFreq  = [];
            newBW    = [];
            Method   = {};            
            for jj = idx2'
                newFreq  = [newFreq; Emissions.Frequency(jj)];
                newBW    = [newBW;   Emissions.BW(jj)];
                Method   = [Method;  Emissions.Detection(jj)];
            end
            newIndex = round((newFreq*1e+6 - bCoef) / aCoef);
            
            NN = numel(newIndex);
            app.specData(ii).UserData.Emissions(end+1:end+NN,1:5) = table(newIndex, newFreq, newBW, true(numel(newIndex),1), Method);

            updatePlotFlag = false;
            if ii == idx1
                updatePlotFlag = true;
            end
            play_BandLimits_updateEmissions(app, ii, newIndex, updatePlotFlag)
            play_UpdatePeaksTable(app, ii)

            % Verifica se as frequências das emissões constam na lista de exceção.
            % Caso sim, adiciona a informação em app.exceptionList, editando 
            % o "Tag" de cada registro. Caso já exista registro com uma das
            % frequências, por outro lado, essa informação não é acrescida.
            if ~isempty(prj_Info.exceptionList)
                Tag = ReferenceTag(app, ii);

                for kk = 1:numel(newFreq)
                    idx3 = find(abs(prj_Info.exceptionList.Frequency - newFreq(kk)) <= class.Constants.floatDiffTolerance);
                    for ll = idx3'
                        idx4 = find(strcmp(app.projectData.exceptionList.Tag, Tag) & (abs(app.projectData.exceptionList.Frequency-prj_Info.exceptionList.Frequency(ll)) <= class.Constants.floatDiffTolerance), 1);
                        
                        if isempty(idx4)
                            app.projectData.exceptionList(end+1,:) = prj_Info.exceptionList(ll,:);
                            app.projectData.exceptionList.Tag{end} = Tag;
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


%-------------------------------------------------------------------------%
function Tag = ReferenceTag(app, idx)
    Tag = sprintf('%s\n%.3f - %.3f MHz', app.specData(idx).Receiver,                  ...
                                         app.specData(idx).MetaData.FreqStart / 1e+6, ...
                                         app.specData(idx).MetaData.FreqStop  / 1e+6);
end