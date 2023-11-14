classdef specData < handle

    properties
        %-----------------------------------------------------------------%
        Receiver
        MetaData     = struct('DataType',         [], ...                   % Valor numérico: RFlookBin (1-2), CRFSBin (4, 7-8, 60-65 e 67-69), Argus (167-168), CellPlan (1000) e SM1809 (1809)
                              'FreqStart',        [], ...                   % Valor numérico (em Hertz)
                              'FreqStop',         [], ...                   % Valor numérico (em Hertz)
                              'LevelUnit',        [], ...                   % dBm | dBµV | dBµV/m
                              'DataPoints',       [], ...
                              'Resolution',       -1, ...                   % Valor numérico (em Hertz) ou -1 (caso não registrado em arquivo)
                              'VBW',              -1, ...
                              'Threshold',        -1, ...
                              'TraceMode',        '', ...                   % "ClearWrite" | "Average" | "MaxHold" | "MinHold" | "OCC" | "SingleMeasurement" | "Mean" | "Peak" | "Minimum"
                              'TraceIntegration', -1, ...                   % Aplicável apenas p/ "Average", "MaxHold" ou "MinHold"
                              'Detector',         '', ...                   % "Sample" | "Average/RMS" | "Positive Peak" | "Negative Peak"
                              'Antenna',          [])
        Data                                                                % Data{1}: timestamp; Data{2}: matrix; and Data{3}: stats
        GPS
        RelatedFiles = table('Size', [0,10],                                                                                                  ...
                             'VariableTypes', {'cell', 'cell', 'double', 'cell', 'datetime', 'datetime', 'double', 'double', 'cell', 'cell'}, ...
                             'VariableNames', {'File', 'Task', 'ID', 'Description', 'BeginTime', 'EndTime', 'nSweeps', 'RevisitTime', 'GPS', 'uuid'})
        UserData     = class.userData.empty
        FileMap                                                             % Auxilia o processo de leitura dos dados de espectro
        Enable       = true
    end


    methods
        %-----------------------------------------------------------------%
        function obj = PreAllocationData(obj, idx)

            if nargin == 1
                idx = 1;
            end

            obj(idx).Data = {repmat(datetime([0 0 0 0 0 0], 'Format', 'dd/MM/yyyy HH:mm:ss'), 1, sum(obj(idx).RelatedFiles.nSweeps)), ...
                             zeros(obj(idx).MetaData.DataPoints, sum(obj(idx).RelatedFiles.nSweeps), 'single'),                       ...
                             zeros(obj(idx).MetaData.DataPoints, 3, 'single')};
        end


        %-----------------------------------------------------------------%
        function copyObj = copy(obj, fields2remove)            
            copyObj  = class.specData();
            propList = setdiff(properties(copyObj), fields2remove);

            for ii = 1:numel(obj)
                for jj = 1:numel(propList)
                    copyObj(ii).(propList{jj}) = obj(ii).(propList{jj});                
                end
            end
        end


        %-----------------------------------------------------------------%
        function IDs = IDList(obj)
            IDs = arrayfun(@(x) x.RelatedFiles.ID(1), obj);
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

                % Em tese, os IDs deveriam ser apenas 1 a 4 representando,
                % respectivamente, "Sample", "Average/RMS", "Positive Peak" 
                % e "Negative Peak".
                %
                % Notei, contudo, arquivos de monitoração gerados pelo appColeta
                % v. 1.11 nos quais esse ID estava igual a "0". Foram monitorações 
                % conduzidas com o R&S EB500.
                case 'Detector'
                    switch id
                        case 0; str = 'Sample';
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