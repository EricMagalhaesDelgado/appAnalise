classdef (Abstract) Constants

    properties (Constant)
        %-----------------------------------------------------------------%
        appName       = 'appAnalise'
        appRelease    = 'R2024b'
        appVersion    = '1.86'

        windowSize    = [1244, 660]
        windowMinSize = [ 950, 660]

        gps2locAPI    = 'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=<Latitude>&longitude=<Longitude>&localityLanguage=pt'
        gps2loc_City  = 'city'
        gps2loc_Unit  = 'principalSubdivisionCode'

        Interactions  = {'datacursor', 'zoomin', 'restoreview'}

        yMinLimRange  = 80                                                  % Minimum y-Axis limit range
        yMaxLimRange  = 100                                                 % Maximum y-Axis limit range

        specDataTypes = [1, 2, 4, 7, 60, 61, 63, 64, 67, 68, 167, 168, 1000, 1809];
        occDataTypes  = [8, 62, 65, 69];

        xDecimals     = 5
        
        floatDiffTolerance    = 1e-5
        nMaxWaterFallPoints   = 1474560
        nMaxPersistancePoints = 51200512                                    % nMaxPointsFSW * nMaxPersistanceOption (GUI) = 100001 * 512
        ElevationTolerance    = .85

        reportOCC            = struct('Method',    'Linear adaptativo',           ...
                                                   'IntegrationTime',     15,     ...
                                                   'Offset',              12,     ...
                                                   'noiseFcn',            'mean', ...
                                                   'noiseTrashSamples',   0.10,   ...
                                                   'noiseUsefulSamples',  0.20)
        reportDetection      = struct('ManualMode', 0,                            ...
                                      'Algorithm', 'FindPeaks+OCC',               ...
                                      'Parameters', struct('Distance',    25,     ... % kHz
                                                           'BW',          10,     ... % kHz
                                                           'Prominence1', 10,     ...
                                                           'Prominence2', 30,     ...
                                                           'meanOCC',     10,     ...
                                                           'maxOCC',      67))
        reportClassification = struct('Algorithm',  'Frequency+Distance Type 1',  ...
                                      'Parameters', struct('Contour', 30,         ...
                                                           'ClassMultiplier', 2,  ...
                                                           'bwFactors', [100, 300]))
    end

    
    methods (Static = true)
        %-----------------------------------------------------------------%
        function fileName = DefaultFileName(userPath, Prefix, Issue)
            fileName = fullfile(userPath, sprintf('%s_%s', Prefix, datestr(now,'yyyy.mm.dd_THH.MM.SS')));

            if Issue > 0
                fileName = sprintf('%s_%d', fileName, Issue);
            end
        end

        %-----------------------------------------------------------------%
        function [upYLim, strUnit] = yAxisUpLimit(Unit)
            switch lower(Unit)
                case 'dbm';                    upYLim = -20; strUnit = 'dBm';
                case {'dbµv', 'dbμv', 'dbuv'}; upYLim =  87; strUnit = 'dBµV';
                case {'dbµv/m', 'dbμv/m'};     upYLim = 100; strUnit = 'dBµV/m';
            end
        end

        %-----------------------------------------------------------------%
        function d = english2portuguese()
            names  = ["Algorithm", ...
                      "AntennaHeight", ...
                      "Azimuth", ...
                      "Band", ...
                      "BitsPerSample", ...
                      "Count", ...
                      "DataPoints", ...
                      "Description", ...
                      "Detection", ...
                      "Distance", ...
                      "Elevation", ...
                      "Family", ...
                      "File", ...
                      "FileVersion", ...
                      "Frequency", ...
                      "FreqStart", ...
                      "FreqStop", ...
                      "gpsType", ...
                      "Height", ...
                      "Installation", ...
                      "IntegrationFactor", ...
                      "IntegrationTime", ...
                      "LevelUnit", ...
                      "Location", ...
                      "LocationSource", ...
                      "Memory", ...
                      "MetaData", ...
                      "Method", ...
                      "Name", ...
                      "nData", ...
                      "nSweeps", ...
                      "Observation", ...
                      "ObservationSamples", ...
                      "ObservationTime", ...
                      "ObservationType", ...
                      "Occupancy", ...
                      "Parameters", ...
                      "Polarization", ...
                      "Position", ...
                      "Prominence", ...
                      "Receiver", ...
                      "Regulatory", ...
                      "Resolution", ...
                      "RevisitTime", ...
                      "RiskLevel", ...
                      "RFMode", ...
                      "Service", ...
                      "Sync", ...
                      "Station", ...
                      "StepWidth", ...
                      "switchPort", ...
                      "Target", ...
                      "Task", ...
                      "taskType", ...
                      "Type", ...
                      "TraceIntegration", ...
                      "TraceMode", ...
                      "TrackingMode"];
            values = ["Algoritmo", ...
                      "Altura da antena", ...
                      "Azimute", ...
                      "Banda", ...
                      "Codificação", ...
                      "Qtd. amostras", ...
                      "Pontos por varredura", ...
                      "Descrição", ...
                      "Detecção", ...
                      "Distância", ...
                      "Elevação", ...
                      "Família", ...
                      "Arquivo", ...
                      "Arquivo", ...
                      "Frequência", ...
                      "Frequência inicial", ...
                      "Frequência final", ...
                      "GPS", ...
                      "Altura", ...
                      "Instalação", ...
                      "Integração", ...
                      "Tempo de integração", ...
                      "Unidade", ...
                      "Localidade", ...
                      "Fonte", ...
                      "Memória", ...
                      "Metadados", ...
                      "Método", ...
                      "Nome", ...
                      "Qtd. fluxos", ...
                      "Qtd. varreduras", ...
                      "Observação", ...
                      "Amostras a coletar", ...
                      "Observação", ...
                      "Tipo de observação", ...
                      "Ocupação", ...
                      "Parâmetros", ...
                      "Polarização", ...
                      "Posição", ...
                      "Proeminência", ...
                      "Receptor", ...
                      "Situação", ...
                      "Resolução", ...
                      "Tempo de revisita", ...
                      "Potencial lesivo", ...
                      "Modo RF", ...
                      "Serviço", ...
                      "Sincronismo", ...
                      "Estação", ...
                      "Passo da varredura", ...
                      "Porta da matriz", ...
                      "Alvo", ...
                      "Tarefa", ...
                      "Tipo de tarefa", ...
                      "Tipo", ...
                      "Integração", ...
                      "Traço", ...
                      "Modo de apontamento"];
        
            d = dictionary(names, values);
        end

        %-----------------------------------------------------------------%
        function winMinSize = WindowMinSize(auxiliarApp)
            switch auxiliarApp
                case 'CONFIG'
                    winMinSize = [760, 588];
            end
        end
    end
end