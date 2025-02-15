classdef UserData

    properties
        %-----------------------------------------------------------------%
        customPlayback        = struct('Type', 'auto', 'Parameters', [])

        occCache              = struct('Info', {}, 'THR', {}, 'Data', {})
        occMethod             = struct('RelatedIndex', [], 'SelectedIndex', [], 'CacheIndex', [])

        channelLibIndex       = []
        channelManual         = struct('Name', {}, 'Band', {}, 'FirstChannel', {}, 'LastChannel', {}, 'StepWidth', {}, 'ChannelBW', {}, 'FreqList', {}, 'Reference', {}, 'FindPeaksName', {})

        bandLimitsStatus      = false
        bandLimitsTable       = table('Size', [0, 2],                        ...
                                      'VariableTypes', {'double', 'double'}, ...
                                      'VariableNames', {'FreqStart', 'FreqStop'})

        Emissions             = table(uint32([]), [], [], true(0,1), string.empty,                                                                                                                                            ...
                                      struct('Detection', {}, 'Classification', {}, 'Occupancy', {}, 'BandWidth', {}),                                                                                                        ...
                                      struct('Level', {}, 'FCO', {}, 'FBO', {}, 'BandWidth', {}),                                                                                                                             ...
                                      struct('Regulatory', {}, 'Service', {}, 'Station', {}, 'Latitude', {}, 'Longitude', {}, 'Description', {}, 'Distance', {}, 'EmissionType', {}, 'Irregular', {}, 'RiskLevel', {}), ...
                                      struct('Regulatory', {}, 'Service', {}, 'Station', {}, 'Latitude', {}, 'Longitude', {}, 'Description', {}, 'Distance', {}, 'EmissionType', {}, 'Irregular', {}, 'RiskLevel', {}), ...
                                      struct('SignalAnalysis', {}, 'DriveTest', {}),                                                                                                                                          ...
                                      'VariableNames', {'idxFrequency', 'Frequency', 'BW_kHz', 'isTruncated', 'Description', 'Algorithm', 'Measures', 'suggestedClassification', 'pointedClassification', 'auxAppData'})

        measCalibration       = table('Size', [0, 4],                                    ...
                                      'VariableTypes', {'cell', 'cell', 'cell', 'cell'}, ...
                                      'VariableNames', {'Name', 'Type', 'oldUnitLevel', 'newUnitLevel'})

        reportFlag            = false
        reportOCC             = []
        reportDetection       = [] % struct('ManualMode', 0, 'Algorithm', {}, 'Parameters', {})
        reportClassification  = [] % struct('Algorithm', {}, 'Parameters', {})
        reportPeaksTable      = []
        reportExternalFiles   = table('Size', [0, 4],                                    ...
                                      'VariableTypes', {'cell', 'cell', 'cell', 'int8'}, ...
                                      'VariableNames', {'Type', 'Tag', 'Filename', 'ID'});
        reportChannelTable    = []
        reportChannelAnalysis = []

        AntennaHeight         = []

        % Registrar operações não contempladas nas outras propriedades. Por
        % exemplo: filtragem temporal do fluxo espectral.
        LOG                   = {}
    end


    %---------------------------------------------------------------------%
    % TEMPLATES METHODS
    %---------------------------------------------------------------------%
    methods (Static = true)
        %-----------------------------------------------------------------%
        function fieldTemplate = getFieldTemplate(dataType)
            arguments
                dataType {mustBeMember(dataType, {'Measures:Level',              ...
                                                  'Measures:BandWidth',          ...
                                                  'Measures:FCO',                ...
                                                  'Measures:FBO',                ...
                                                  'auxAppData:SignalAnalysis',   ...
                                                  'DefaultAlgorithm: Occupancy', ...
                                                  'DefaultAlgorithm: Detection', ...
                                                  'DefaultAlgorithm: Classification'})}
            end

            switch dataType
                case 'Measures:Level'
                    fieldTemplate = struct('FreqCenter_Min',      {},  ...
                                           'FreqCenter_Mean',     {},  ...
                                           'FreqCenter_Max',      {},  ...
                                           'Channel_Min',         {},  ...
                                           'Channel_Mean',        {},  ...
                                           'Channel_Max',         {});

                case 'Measures:BandWidth'
                    fieldTemplate = struct('Min',                 {},  ...
                                           'Mean',                {},  ...
                                           'Max',                 {});

                case 'Measures:FCO'
                    fieldTemplate = struct('FreqCenter_Infinite', {},  ...
                                           'Channel_Infinite',    {},  ...
                                           'Channel_Finite_Min',  {},  ...
                                           'Channel_Finite_Mean', {},  ...
                                           'Channel_Finite_Max',  {});

                case 'Measures:FBO'
                    fieldTemplate = struct('Channel_Min',         {},  ...
                                           'Channel_Mean',        {},  ...
                                           'Channel_Max',         {});

                case 'auxAppData:SignalAnalysis'
                    fieldTemplate = struct('ChannelAssigned', struct('Frequency', {}, 'ChannelBW', {}));

                case 'DefaultAlgorithm: Occupancy'
                    fieldTemplate = struct('Method',              'Linear adaptativo', ...
                                           'IntegrationTime',     15,                  ...
                                           'Offset',              12,                  ...
                                           'noiseFcn',            'mean',              ...
                                           'noiseTrashSamples',   0.10,                ...
                                           'noiseUsefulSamples',  0.20);

                case 'DefaultAlgorithm: Detection'
                    fieldTemplate = struct('ManualMode', 0,                         ...
                                           'Algorithm', 'FindPeaks+OCC',            ...
                                           'Parameters', struct('Distance_kHz', 25, ... % kHz
                                                                'BW_kHz',       10, ... % kHz
                                                                'Prominence1',  10, ...
                                                                'Prominence2',  30, ...
                                                                'meanOCC',      10, ...
                                                                'maxOCC',       67));

                case 'DefaultAlgorithm: Classification'
                    fieldTemplate = struct('Algorithm',  'Frequency+Distance Type 1', ...
                                           'Parameters', struct('Contour', 30,        ...
                                                                'ClassMultiplier', 2, ...
                                                                'bwFactors', [100, 300]));

                case 'DefaultClassification'
                    fieldTemplate = struct('Regulatory',   'Não licenciada',         ...
                                           'Service',      int16(-1),                ...
                                           'Station',      int32(-1),                ...
                                           'Latitude',     -1,                       ...
                                           'Longitude',    -1,                       ...
                                           'Description',  '-',                      ...
                                           'Distance',     -1,                       ...
                                           'EmissionType', 'Pendente identificação', ...
                                           'Irregular',    'Sim',                    ...
                                           'RiskLevel',    'Baixo');
            end
        end
    end

    
    %---------------------------------------------------------------------%
    % UPDATE METHODS
    %---------------------------------------------------------------------%
    methods (Static = true)
        %-----------------------------------------------------------------%
        function updateEmissionsTable(updateType, varargin)
            arguments
                updateType char {mustBeMember(updateType, {'Add', 'Edit', 'Delete'})}
            end

            arguments (Repeating)
                varargin
            end

            switch updateType
                case 'Add'
                    specData   = varargin{1};                    
                    idxFreq    = varargin{2};
                    FreqCenter = varargin{3};
                    BandWidth  = varargin{4};
                    Algorithm  = varargin{5};

                    for ii = 1:numel(idxFreq)
                        idxEmission = height(specData.UserData.Emissions) + 1;
                        specData.UserData.Emissions(idxEmission, 1:4) = table(idxFreq(ii), FreqCenter(ii), BandWidth(ii), true);                        

                        userDescription = '';
                        parsedAlgorithm = jsondecode(Algorithm{ii});

                        if isfield(parsedAlgorithm, 'Description')
                            userDescription = parsedAlgorithm.Description;
                            Algorithm{ii}   = jsonencode(rmfield(parsedAlgorithm, 'Description'));
                        end

                        specData.UserData.Emissions.Description(idxEmission) = userDescription;
                        specData.UserData.Emissions.Algorithm(idxEmission).Detection = Algorithm{ii};

                        RF.Measures(specData, idxEmission)
                    end

                case 'Edit'
                    editionType = varargin{1};

                    specData    = varargin{2};
                    idxEmission = varargin{3};

                    Algorithm   = jsondecode(specData.UserData.Emissions.Algorithm(idxEmission).Detection);

                    % Ao alterar as características de frequência e BW de uma emissão, 
                    % a emissão alterada é considerada como uma NOVA emissão. Logo,
                    % as informações eventualmente geradas em módulos auxiliares, como
                    % "Drive-Test" e "SignalAnalysis" são perdidas.

                    switch editionType
                        case 'Frequency'                            
                            Algorithm.Algorithm = 'Manual';        
                            specData.UserData.Emissions.idxFrequency(idxEmission)         = varargin{4};
                            specData.UserData.Emissions.Frequency(idxEmission)            = varargin{5};
                            specData.UserData.Emissions.Algorithm(idxEmission).Detection  = jsonencode(Algorithm, 'ConvertInfAndNaN', false);                            
                            specData.UserData.Emissions.auxAppData(idxEmission)           = structfun(@(x) [], specData.UserData.Emissions.auxAppData(idxEmission), "UniformOutput", false);

                        case 'BandWidth'
                            Algorithm.Algorithm = 'Manual';
                            specData.UserData.Emissions.BW_kHz(idxEmission)               = varargin{4};
                            specData.UserData.Emissions.Algorithm(idxEmission).Detection  = jsonencode(Algorithm, 'ConvertInfAndNaN', false);
                            specData.UserData.Emissions.auxAppData(idxEmission)           = structfun(@(x) [], specData.UserData.Emissions.auxAppData(idxEmission), "UniformOutput", false);
                        
                        case 'Description'
                            specData.UserData.Emissions.Description(idxEmission)          = varargin{4};
                            return
                    end

                    RF.Measures(specData, idxEmission)

                case 'Delete'
                    specData     = varargin{1};
                    idxEmissions = varargin{2};

                    specData.UserData.Emissions(idxEmissions, :) = [];
            end
        end

        %-----------------------------------------------------------------%
        function updateReportFields(updateType, varargin)
            arguments
                updateType char {mustBeMember(updateType, {'Creation', 'Edition'})}
            end

            arguments (Repeating)
                varargin
            end

            switch updateType
                case 'Creation'
                    specData     = varargin{1};
                    idxThreads   = varargin{2};
                    channelObj   = varargin{3};
                    occFcnHandle = varargin{4};

                    for ii = idxThreads
                        specData(ii).UserData.reportFlag = true;
                        
                        % Ocupação
                        if isempty(specData(ii).UserData.reportOCC)
                            if isempty(specData(ii).UserData.occMethod.CacheIndex)
                                if isempty(specData(ii).UserData.occMethod.RelatedIndex)        
                                    specData(ii).UserData.reportOCC = model.UserData.getFieldTemplate('DefaultAlgorithm: Occupancy');        
                                else
                                    idx2 = specData(ii).UserData.occMethod.SelectedIndex;
                                    specData(ii).UserData.reportOCC = struct('Method',                  'Linear fixo (COLETA)',                           ...
                                                                             'IntegrationTimeCaptured', mean(specData(idx2).RelatedFiles.RevisitTime)/60, ...
                                                                             'THRCaptured',             specData(idx2).MetaData.Threshold);
                                end
                                occIndex = occFcnHandle(ii, 'REPORT');
                
                            else
                                occIndex = specData(ii).UserData.occMethod.CacheIndex;
                            end
                            specData(ii).UserData.reportOCC = specData(ii).UserData.occCache(occIndex).Info;
                        end
        
                        % Detecção de emissões
                        if isempty(specData(ii).UserData.reportDetection)
                            specData(ii).UserData.reportDetection = model.UserData.getFieldTemplate('DefaultAlgorithm: Detection');

                            findPeaks = FindPeaksOfPrimaryBand(channelObj, specData(ii));
                            if ~isempty(findPeaks)
                                specData(ii).UserData.reportDetection.Parameters = struct('Distance_kHz', 1000 * findPeaks.Distance, ... % MHz >> kHz
                                                                                          'BW_kHz',       1000 * findPeaks.BW,       ... % MHz >> kHz
                                                                                          'Prominence1',  findPeaks.Prominence1,     ...
                                                                                          'Prominence2',  findPeaks.Prominence2,     ...
                                                                                          'meanOCC',      findPeaks.meanOCC,         ...
                                                                                          'maxOCC',       findPeaks.maxOCC);
                            end
                        end
        
                        % Classificação das emissões
                        if isempty(specData(ii).UserData.reportClassification)
                            specData(ii).UserData.reportClassification = model.UserData.getFieldTemplate('DefaultAlgorithm: Classification');
                        end
                    end

                case 'Edition'
                    % PENDENTE



            end
        end
    end
end