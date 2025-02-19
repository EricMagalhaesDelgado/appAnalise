classdef (Abstract) EMSatDataHubLib
    
    methods (Static = true)
        %-----------------------------------------------------------------%
        function chList = importSatelliteChannels(chTable)
            chList  = struct('Name',          {}, ...
                             'Band',          [], ...
                             'FirstChannel',  [], ...
                             'LastChannel',   [], ...
                             'StepWidth',     [], ...
                             'ChannelBW',     [], ...
                             'FreqList',      [], ...
                             'Reference',     '', ...
                             'FindPeaksName', '');

            for ii = 1:height(chTable)
                CF = chTable.FREQ_CENTRAL_DOWN(ii);
                BW = chTable.BW(ii);

                chList(ii).Name          = sprintf('%s %s %s @ %.1f MHz', chTable.DESIG_INT(ii), chTable.CODE(ii), chTable.FEIXE_POLARIZ_DOWN(ii), CF);
                chList(ii).Band          = [CF-BW/2, CF+BW/2];
                chList(ii).FirstChannel  = CF;
                chList(ii).LastChannel   = CF;
                chList(ii).StepWidth     = -1;
                chList(ii).ChannelBW     = BW;
                chList(ii).FreqList      = [];
                chList(ii).Reference     = jsonencode(chTable(ii, {'SNAPSHOT_DT', 'SAT_ANATEL_ID', 'LICENCIADO_BRASIL', 'TECNOLOGIA', 'SENTIDO_GATEWAY', 'FEIXE_UP', 'FEIXE_DOWN', 'FREQ_CENTRAL_UP', 'OCUPACAO_TOTAL', 'METRICA_OCUPACAO', 'OBS'}));
                chList(ii).FindPeaksName = 'Satellite';
            end    
        end

        %-----------------------------------------------------------------%
        function chTable = importRawCSVFile(fileFullName)
            [~, ~, fileExt] = fileparts(fileFullName);
            if ~strcmpi(fileExt, '.csv')
                error('FileMustBeCSV')
            end
        
            % Set up the Import Options and import the data
            opts = delimitedTextImportOptions("NumVariables", 19, "Encoding", "UTF-8");
            
            % Specify range and delimiter
            opts.DataLines = [2, Inf];
            opts.Delimiter = ";";
            
            % Specify column names and types
            opts.VariableNames = ["SNAPSHOT_DT", "SAT_ANATEL_ID", "DESIG_INT", "CODE", "LICENCIADO_BRASIL", "TECNOLOGIA", "SENTIDO_GATEWAY", "FEIXE_UP", "FEIXE_DOWN", "FEIXE_POLARIZ_UP", "FEIXE_POLARIZ_DOWN", "BW", "FREQ_CENTRAL_UP", "FREQ_CENTRAL_DOWN", "OCUPACAO_TOTAL", "OCUPACAO_BR", "METRICA_OCUPACAO", "RESTRICAO_DADO", "OBS"];
            opts.VariableTypes = ["datetime", "categorical", "categorical", "categorical", "double", "double", "double", "categorical", "categorical", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "string"];
            
            % Specify file level properties
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
            
            % Specify variable properties
            opts = setvaropts(opts, "OBS", "WhitespaceRule", "preserve");
            opts = setvaropts(opts, ["SAT_ANATEL_ID", "DESIG_INT", "CODE", "FEIXE_UP", "FEIXE_DOWN", "FEIXE_POLARIZ_UP", "FEIXE_POLARIZ_DOWN", "OBS"], "EmptyFieldRule", "auto");
            opts = setvaropts(opts, "SNAPSHOT_DT", "InputFormat", "dd/MM/yyyy", "DatetimeFormat", "preserveinput");
            opts = setvaropts(opts, ["LICENCIADO_BRASIL", "TECNOLOGIA", "SENTIDO_GATEWAY", "BW", "FREQ_CENTRAL_UP", "FREQ_CENTRAL_DOWN", "OCUPACAO_TOTAL", "OCUPACAO_BR", "METRICA_OCUPACAO", "RESTRICAO_DADO"], "DecimalSeparator", ",");
            opts = setvaropts(opts, ["LICENCIADO_BRASIL", "TECNOLOGIA", "SENTIDO_GATEWAY", "BW", "FREQ_CENTRAL_UP", "FREQ_CENTRAL_DOWN", "OCUPACAO_TOTAL", "OCUPACAO_BR", "METRICA_OCUPACAO", "RESTRICAO_DADO"], "ThousandsSeparator", ".");
            
            % Import the data
            chTable = readtable(fileFullName, opts);
        end
    end
end