classdef specData

    properties
        %-----------------------------------------------------------------%
        Receiver
        TaskData = struct('Name',             '', ...
                          'ID',               [], ...
                          'Description',      '')
        MetaData = struct('DataType',         [], ...                       % Valor numérico: RFlookBin (1-2), CRFSBin (4, 7-8, 60-65 e 67-69), Argus (167-168), CellPlan (1000) e SM1809 (1809)
                          'FreqStart',        [], ...                       % Valor numérico (em Hertz)
                          'FreqStop',         [], ...                       % Valor numérico (em Hertz)
                          'LevelUnit',        [], ...                       % dBm | dBµV | dBµV/m
                          'DataPoints',       [], ...
                          'Resolution',       -1, ...                       % Valor numérico (em Hertz) ou -1 (caso não registrado em arquivo)
                          'Threshold',        -1, ...
                          'TraceMode',        [], ...                       % ClearWrite | Average | MaxHold | MinHold
                          'TraceIntegration', -1, ...                       % Aplicável apenas p/ "Average", "MaxHold" ou "MinHold"
                          'Detector',         '', ...                       % 1 (Sample) | 2 (Average/RMS) | 3 (Positive Peak) | 4 (Negative Peak)
                          'Antenna',          '')
        Data                                                                % Data{1}: timestamp; Data{2}: matrix; and Data{3}: stats
        ObservationTime
        Samples
        RelatedFiles = table('Size', [0,5],                                                         ...
                             'VariableTypes', {'cell', 'datetime', 'datetime', 'double', 'double'}, ...
                             'VariableNames', {'Name', 'BeginTime', 'EndTime', 'Samples', 'RevisitTime'})
        RelatedGPS
        GPS
        UserData     = class.userData
        FileMap                                                             % Auxilia o processo de leitura dos dados de espectro
    end


    methods
        %-----------------------------------------------------------------%
        function obj = PreAllocationData(obj)
            obj.Data = {repmat(datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss'), 1, obj.Samples), ...
                        zeros(obj.MetaData.DataPoints, obj.Samples, 'single'),                            ...
                        zeros(obj.MetaData.DataPoints, 3)};
        end
    end


    methods (Static = true)
        %-----------------------------------------------------------------%
        function str = id2str(Type, id)        
            switch Type
                case 'TraceMode'
                    switch id
                        case 1; str = 'ClearWrite';
                        case 2; str = 'Average';
                        case 3; str = 'MaxHold';
                        case 4; str = 'MinHold';
                    end
        
                case 'Detector'
                    switch id
                        case 1; str = 'Sample';
                        case 2; str = 'Average/RMS';
                        case 3; str = 'Positive Peak';
                        case 4; str = 'Negative Peak';
                    end
        
                case 'LevelUnit'
                    switch id
                        case 1; str = 'dBm';
                        case 2; str = 'dBµV';
                        case 3; str = 'dBµV/m';
                    end
            end        
        end


        %-----------------------------------------------------------------%
        function ID = str2id(Type, Value)        
            switch Type
                case 'TraceMode'
                    switch Value
                        case 'ClearWrite'; ID = 1;
                        case 'Average';    ID = 2;
                        case 'MaxHold';    ID = 3;
                        case 'MinHold';    ID = 4;
                    end
        
                case 'Detector'
                    switch Value
                        case 'Sample';        ID = 1;
                        case 'Average/RMS';   ID = 2;
                        case 'Positive Peak'; ID = 3;
                        case 'Negative Peak'; ID = 4;
                    end
        
                case 'LevelUnit'
                    switch Value
                        case 'dBm';                ID = 1;
                        case {'dBµV', 'dBμV'};     ID = 2;
                        case {'dBµV/m', 'dBμV/m'}; ID = 3;
                    end
            end        
        end


        %-----------------------------------------------------------------%
        function Value = str2str(Value)
            Value = replace(Value, 'μ', 'µ');
        end
    end
end