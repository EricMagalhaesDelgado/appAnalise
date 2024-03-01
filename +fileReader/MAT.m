function [specData, prjInfo] = MAT(fileName, ReadType, metaData)

    % Author.: Eric Magalhães Delgado
    % Date...: November 13, 2023
    % Version: 1.00

    arguments
        fileName char
        ReadType char   = 'SingleFile'
        metaData struct = []
    end

    switch ReadType
        case {'MetaData', 'SingleFile'}
            specData = Fcn_MetaDataReader(fileName);
            prjInfo  = [];

            if strcmp(ReadType, 'SingleFile')
                [specData, prjInfo] = Fcn_SpecDataReader(specData, fileName);
            end
            
        case 'SpecData'
            specData = copy(metaData(1).Data, {});
            [specData, prjInfo] = Fcn_SpecDataReader(specData, fileName);
    end
end


%-------------------------------------------------------------------------%
function specData = Fcn_MetaDataReader(fileName)

    specData = class.specData.empty;
    load(fileName, '-mat', 'prj_Version', 'prj_metaData')

    switch prj_Version
        case 2
            for ii = 1:numel(prj_metaData)
                specData(ii).Receiver               = prj_metaData(ii).Node;

                % MetaData
                specData(ii).MetaData.DataType      = prj_metaData(ii).MetaData.DataType;
                specData(ii).MetaData.FreqStart     = prj_metaData(ii).MetaData.FreqStart;
                specData(ii).MetaData.FreqStop      = prj_metaData(ii).MetaData.FreqStop;
                specData(ii).MetaData.LevelUnit     = prj_metaData(ii).MetaData.metaString{1};
                specData(ii).MetaData.DataPoints    = prj_metaData(ii).MetaData.DataPoints;
                specData(ii).MetaData.Resolution    = prj_metaData(ii).MetaData.Resolution;

                if ~isempty(prj_metaData(ii).MetaData.Threshold)
                    specData(ii).MetaData.Threshold = prj_metaData(ii).MetaData.Threshold;
                end
                
                specData(ii).MetaData.TraceMode     = prj_metaData(ii).MetaData.metaString{3};
                specData(ii).MetaData.Detector      = prj_metaData(ii).MetaData.metaString{4};
                specData(ii).MetaData.Antenna       = struct('Name', prj_metaData(ii).MetaData.metaString{5});

                if isfield(prj_metaData(ii).MetaData, 'TraceIntegration') && ~isempty(prj_metaData(ii).MetaData.TraceIntegration)
                    specData(ii).MetaData.TraceIntegration = prj_metaData(ii).MetaData.TraceIntegration;
                end

                % RelatedFiles
                UUID = char(matlab.lang.internal.uuid());
                for jj = 1:height(prj_metaData(ii).RelatedFiles)
                    specData(ii).RelatedFiles(jj,:) = {prj_metaData(ii).RelatedFiles.Name{jj},        ...
                                                       prj_metaData(ii).TaskName,                     ...
                                                       prj_metaData(ii).ThreadID,                     ...
                                                       prj_metaData(ii).Description,                  ...
                                                       prj_metaData(ii).RelatedFiles.BeginTime(jj),   ...
                                                       prj_metaData(ii).RelatedFiles.EndTime(jj),     ...
                                                       prj_metaData(ii).RelatedFiles.Samples(jj),     ...
                                                       prj_metaData(ii).RelatedFiles.RevisitTime(jj), ...
                                                       {rmfield(prj_metaData(ii).RelatedGPS{jj}, {'Latitude', 'Longitude', 'Count', 'Location'})}, ...
                                                       UUID};
                end

                % gpsData
                gpsData = fcn.gpsSummary(prj_metaData(ii).RelatedGPS);
                specData(ii).GPS = rmfield(gpsData, 'Matrix');
            end


        case 3
            currentMetaData     = struct(class.MetaDataList);
            currentMetaDataList = fields(currentMetaData);
            ProjectMetaDataList = fields(prj_metaData(1).MetaData);

            checkIndex          = find(cellfun(@(x) ~ismember(x, ProjectMetaDataList), currentMetaDataList))';
            if ~isempty(checkIndex)
                for ii = 1:numel(prj_metaData)
                    for jj = checkIndex
                        prj_metaData(ii).MetaData.(currentMetaDataList{jj}) = currentMetaData.(currentMetaDataList{jj});
                    end
                end
            end

            specData = prj_metaData;


        otherwise
            error('fileReader:MAT', 'Not expected MAT-file version.')
    end
end


%-------------------------------------------------------------------------%
function [specData, prjInfo] = Fcn_SpecDataReader(specData, fileName)

    load(fileName, '-mat', 'prj_Version', 'prj_specData', 'prj_Type', 'prj_Info')
    prjInfo = prj_Info;

    switch prj_Version
        case 2
            for ii = 1:numel(specData)
                specData(ii).Data    = prj_specData(ii).Data;
                specData(ii).Data{3} = zeros(specData(ii).MetaData.DataPoints, 3, 'single');

                if strcmp(prj_Type, 'Project data') && ismember(prj_specData(ii).MetaData.DataType, class.Constants.specDataTypes)
                    % Quase todas as informações relacionadas a um fluxo espectral 
                    % incluso num projeto (e registradas num arquivo MAT) são 
                    % aproveitadas. Exceção às seguintes:
                    % (a) reportOCC
                    % (b) TimeStamp
                    % (c) Emissions: emissões incluídas no PLAYBACK de versões 
                    %     antigas do appAnalise podem "desrespeitar" os limites
                    %     de busca, aplicáveis apenas para o algoritmo automatizado.
                    %     Agora, após a carga dos limites de busca e das emissões
                    %     é feita uma validação, excluindo emissões, caso fora 
                    %     dos limites de busca.

                    % UserData.bandLimitStatus & UserData.bandLimitsTable
                    Band = [specData(ii).MetaData.FreqStart, specData(ii).MetaData.FreqStop] / 1e+6;
                    if ~isequal(Band, prj_specData(ii).reportDetection.Band)
                        specData(ii).UserData(1).bandLimitsStatus      = true;
                        specData(ii).UserData.bandLimitsTable(end+1,:) = {prj_specData(ii).reportDetection.Band(1), prj_specData(ii).reportDetection.Band(2)};
                    end
                    
                    % UserData.Emissions
                    if ~isempty(prj_specData(ii).Emissions)
                        oldDetectionType = unique(prj_specData(ii).Emissions.Detection);
                        newDetectionType = {};

                        for jj = 1:numel(oldDetectionType)
                            switch oldDetectionType{jj}
                                case 'Detecção manual'
                                    newDetectionType{end+1,1} = jsonencode(struct('Algorithm', 'Manual'));
                                otherwise
                                    newTempDetectionType      = jsonencode(struct('Algorithm',  'FindPeaks', ...
                                                                                  'Parameters', jsondecode(extractAfter(prj_specData(ii).Emissions.Detection{jj}, '- '))));
                                    newDetectionType{end+1,1} = replace(newTempDetectionType, 'Proeminence', 'Prominence');
                            end
                        end

                        NN = height(prj_specData(ii).Emissions.Detection);
                        specData(ii).UserData(1).Emissions(1:NN,:) = prj_specData(ii).Emissions;
                        specData(ii).UserData.Emissions.Detection  = replace(specData(ii).UserData.Emissions.Detection, oldDetectionType, newDetectionType);
                    end
                    fcn.Detection_BandLimits(specData(ii))

                    % UserData.reportFlag & UserData.reportAttachments
                    specData(ii).UserData.reportFlag        = true;
                    specData(ii).UserData.reportAttachments = prj_specData(ii).reportAttachments;

                    % UserData.reportDetection
                    oldDetectionParameters = jsondecode(prj_specData(ii).reportDetection.Parameters);
                    specData(ii).UserData.reportDetection   = struct('ManualMode', prj_specData(ii).reportDetection.ManualMode,                 ...
                                                                     'Algorithm', 'FindPeaks+OCC',                                              ...
                                                                     'Parameters', struct('Distance',    oldDetectionParameters.Cn_minDist,     ... % kHz
                                                                                          'BW',          oldDetectionParameters.Cn_BW,          ... % kHz
                                                                                          'Prominence1', oldDetectionParameters.C1_Proeminence, ...
                                                                                          'Prominence2', oldDetectionParameters.C2_Proeminence, ...
                                                                                          'meanOCC',     oldDetectionParameters.C2_meanOCC,     ...
                                                                                          'maxOCC',      oldDetectionParameters.C2_maxOCC));

                    % UserData.reportClassification
                    oldClassificationParameters = jsondecode(prj_specData(ii).reportClassification.Parameters);
                    specData(ii).UserData.reportClassification = struct('Algorithm', 'Frequency+Distance Type 1',                                         ...
                                                                     'Parameters', struct('Contour',         oldClassificationParameters.Contour,         ...
                                                                                          'ClassMultiplier', oldClassificationParameters.ClassMultiplier, ...
                                                                                          'bwFactors',       oldClassificationParameters.bwFactors));
                end
            end


        case 3
            specData = prj_specData;


        otherwise
            error('fileReader:MAT', 'Not expected MAT-file version.')
    end
end