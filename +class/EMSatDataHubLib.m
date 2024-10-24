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
                CF = chTable.TPDR_FREQ_CENTRAL_DOWN(ii);
                BW = chTable.TPDR_BW(ii);

                chList(ii).Name          = sprintf('%s %s %s @ %.1f MHz', chTable.TPDR_DESIG_INT(ii), chTable.TPDR_CODE(ii), chTable.TPDR_FEIXE_POLARIZ_DOWN(ii), CF);
                chList(ii).Band          = [CF-BW/2, CF+BW/2];
                chList(ii).FirstChannel  = CF;
                chList(ii).LastChannel   = CF;
                chList(ii).StepWidth     = -1;
                chList(ii).ChannelBW     = BW;
                chList(ii).FreqList      = [];
                chList(ii).Reference     = jsonencode(chTable(ii, :));
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
            opts.VariableNames = ["TPDR_SNAPSHOT_DT", "TPDR_SAT_ANATEL_ID", "TPDR_DESIG_INT", "TPDR_CODE", "TPDR_LICENCIADO_BRASIL", "TPDR_TECNOLOGIA", "TPDR_SENTIDO_GATEWAY", "TPDR_FEIXE_UP", "TPDR_FEIXE_DOWN", "TPDR_FEIXE_POLARIZ_UP", "TPDR_FEIXE_POLARIZ_DOWN", "TPDR_BW", "TPDR_FREQ_CENTRAL_UP", "TPDR_FREQ_CENTRAL_DOWN", "TPDR_OCUPACAO_TOTAL", "TPDR_OCUPACAO_BR", "TPDR_METRICA_OCUPACAO", "TPDR_RESTRICAO_DADO", "TPDR_OBS"];
            opts.VariableTypes = ["datetime", "categorical", "categorical", "categorical", "double", "double", "double", "categorical", "categorical", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "string"];
            
            % Specify file level properties
            opts.ExtraColumnsRule = "ignore";
            opts.EmptyLineRule = "read";
            
            % Specify variable properties
            opts = setvaropts(opts, "TPDR_OBS", "WhitespaceRule", "preserve");
            opts = setvaropts(opts, ["TPDR_SAT_ANATEL_ID", "TPDR_DESIG_INT", "TPDR_CODE", "TPDR_FEIXE_UP", "TPDR_FEIXE_DOWN", "TPDR_FEIXE_POLARIZ_UP", "TPDR_FEIXE_POLARIZ_DOWN", "TPDR_OBS"], "EmptyFieldRule", "auto");
            opts = setvaropts(opts, "TPDR_SNAPSHOT_DT", "InputFormat", "dd/MM/yyyy", "DatetimeFormat", "preserveinput");
            opts = setvaropts(opts, ["TPDR_LICENCIADO_BRASIL", "TPDR_TECNOLOGIA", "TPDR_SENTIDO_GATEWAY", "TPDR_BW", "TPDR_FREQ_CENTRAL_UP", "TPDR_FREQ_CENTRAL_DOWN", "TPDR_OCUPACAO_TOTAL", "TPDR_OCUPACAO_BR", "TPDR_METRICA_OCUPACAO", "TPDR_RESTRICAO_DADO"], "DecimalSeparator", ",");
            opts = setvaropts(opts, ["TPDR_LICENCIADO_BRASIL", "TPDR_TECNOLOGIA", "TPDR_SENTIDO_GATEWAY", "TPDR_BW", "TPDR_FREQ_CENTRAL_UP", "TPDR_FREQ_CENTRAL_DOWN", "TPDR_OCUPACAO_TOTAL", "TPDR_OCUPACAO_BR", "TPDR_METRICA_OCUPACAO", "TPDR_RESTRICAO_DADO"], "ThousandsSeparator", ".");
            
            % Import the data
            chTable = readtable(fileFullName, opts);
        end
    end
end