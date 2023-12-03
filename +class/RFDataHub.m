classdef (Abstract) RFDataHub
    
    methods (Static = true)
        %-----------------------------------------------------------------%
        function read(RootFolder)
            global RFDataHub
            global RFDataHub_info
            
            if isempty(RFDataHub) || isempty(RFDataHub_info)
                filename_mat = fullfile(RootFolder, 'DataBase', 'RFDataHub.mat');
        
                if isfile(filename_mat)
                    load(filename_mat, 'RFDataHub', 'RFDataHub_info', '-mat')
                
                else
                    filename_parquet = fullfile(RootFolder, 'Temp', 'estacoes.parquet.gzip');
        
                    try
                        RFDataHub   = parquetread(filename_parquet, "VariableNamingRule", "preserve");
                        RFDataHub   = class.RFDataHub.parquet2mat(RFDataHub);

                        FileVersion = webread(fcn.PublicLinks(RootFolder));
                        if isfield(FileVersion, 'RFDataHub')
                            RFDataHub_info = FileVersion.RFDataHub;
                        else
                            RFDataHub_info = jsondecode('{"ReleaseDate": "27/11/2023 08:13:01", "ANATEL": "27/11/2023 08:13:01", "AERONAUTICA": "27/11/2023 08:13:01"}');
                        end
                                        
                        save(filename_mat, 'RFDataHub', 'RFDataHub_info')
                    
                    catch ME
                        filename_mat_old = fullfile(RootFolder, 'DataBase', 'RFDataHub_old.mat');
        
                        if isfile(filename_mat_old)
                            load(filename_mat_old, 'RFDataHub', 'RFDataHub_info', '-mat')
                            error('A base do RFDataHub não foi atualizada pelas razões expostas a seguir, sendo usada a base antiga armazenada no arquivo "RFDataHub_old.mat".\n\n%s', getReport(ME))
                        else
                            error('A base do RFDataHub não foi localizada.')
                        end
                    end
                end
            end
        end


        %-----------------------------------------------------------------%
        function RFDataHub = parquet2mat(RFDataHub)
            % Em 28/11/2023 o RFDataHub se apresenta como uma tabela formada 
            % por 979522 linhas e 29 colunas. Todas as colunas são categóricas 
            % (inclusive as de natureza numérica, como "Frequência", por exemplo).

            % Nomes e tipologia das principais colunas pós-conversões aqui 
            % realizadas:
            % Col.  1: "Frequência"           >> "Frequency" {double}
            % Col.  2: "Entidade"             >> "Name"      {categorical}
            % Col.  3: "Fistel"               >> "Fistel"    {int64}
            % Col.  4: "Serviço"              >> "Service"   {int16}
            % Col.  5: "Estação"              >> "Station"   {int32}
            % Col.  6: "Latitude"             >> "Latitude"  {single}
            % Col.  7: "Longitude"            >> "Longitude" {single}
            % Col. 13: "Largura_Emissão(kHz)" >> "BW"        {single}
            % Col. 29: "Relatório_Canal"      >> "URL"       {categorical}

            RFDataHub = class.RFDataHub.ColumnNames(RFDataHub, 'port2eng');
            RFDataHub = convertvars(RFDataHub, [1:7, 13], 'string');

            RFDataHub.Frequency = str2double(RFDataHub.Frequency);
            RFDataHub.Name      = categorical(regexprep(lower(RFDataHub.Name), '(\<\w)', '${upper($1)}'));
            RFDataHub.Fistel    = int64(str2double(RFDataHub.Fistel));
            RFDataHub.Service   = int16(str2double(RFDataHub.Service));
            RFDataHub.Station   = int32(str2double(RFDataHub.Station));
            RFDataHub.Latitude  = single(str2double(RFDataHub.Latitude));
            RFDataHub.Longitude = single(str2double(RFDataHub.Longitude));
            RFDataHub.BW        = single(str2double(RFDataHub.BW));

            for ii = 1:width(RFDataHub)
                if isnumeric(RFDataHub{:,ii})
                    idx = isnan(RFDataHub{:,ii});
                    RFDataHub{idx,ii} = -1;
                end
            end
        end


        %-----------------------------------------------------------------%
        function RFDataHub = ColumnNames(RFDataHub, Type)
            rawColumnNames    = ["Frequência", "Entidade", "Fistel", "Serviço", "Estação", "Latitude", "Longitude", "Código_Município", "Município", "UF",                                      ... %  1 a 10
                                 "Classe", "Classe_Emissão", "Largura_Emissão(kHz)", "Validade_RF", "Status", "Fonte", "Multiplicidade","Log", "Cota_Base_Torre(m)", "Potência_Transmissor(W)", ... % 11 a 20
                                 "Ganho_Antena(dBd)", "Ângulo_Elevação_Antena", "Azimute_Antena", "Altura_Antena(m)", "Atenuação_Linha(db/100m)", "Perdas_Acessórias_Linha(db)",                ... % 21 a 26
                                 "Padrão_Antena(dBd)", "Comprimento_Linha(m)", "Relatório_Canal"];                                                                                                  % 27 a 29

            editedColumnNames = ["Frequency", "Name", "Fistel", "Service", "Station", "Latitude", "Longitude", "LocationID", "Location", "State",                                               ... %  1 a 10
                                 "StationClass", "EmissionClass", "BW", "SpectrumActValidity", "Status", "Source", "MergeCount", "Log", "TowerBaseElevation", "TransmitterPower",               ... % 11 a 20
                                 "AntennaGain", "AntennaElevation", "AntennaAzimuth", "AntennaHeight", "LineAttenuation", "LineAccessoryLosses", "AntennaPattern", "LineLength", "URL"];            % 21 a 29

            switch Type
                case 'port2eng'
                    RFDataHub = renamevars(RFDataHub, rawColumnNames, editedColumnNames);
                case 'eng2port'
                    RFDataHub = renamevars(RFDataHub, editedColumnNames, rawColumnNames);
            end
        end


        %-----------------------------------------------------------------%
        function stdDescription = Description(RFDataHub, idx)
            mergeCount = RFDataHub.MergeCount(idx);
            if mergeCount == "1"; mergeNote = '';
            else;                 mergeNote = sprintf(', M=%s', mergeCount);
            end

            stdDescription = sprintf('[%s] %s, %s, %s (Fistel=%d, Estação=%d%s), %s/%s', RFDataHub.Source(idx),       ...
                                                                                         RFDataHub.Status(idx),       ...
                                                                                         RFDataHub.StationClass(idx), ...
                                                                                         RFDataHub.Name(idx),         ...
                                                                                         RFDataHub.Fistel(idx),       ...
                                                                                         RFDataHub.Station(idx),      ...
                                                                                         mergeNote,                   ...
                                                                                         RFDataHub.Location(idx),     ...
                                                                                         RFDataHub.State(idx));
        end


        %-----------------------------------------------------------------%
        function stationInfo = query(RFDataHub, stationID, latNode, longNode)            
            % stationID é uma string com o número da estação real ou virtual 
            % (quando possui o caractere "#" à frente do número). latNode e 
            % longNode são as coordenadas geográficas do local onde ocorreu 
            % a monitoração.

            if contains(stationID, '#')
                idx = str2double(stationID(2:end));
                if (idx < 1) || (idx > height(RFDataHub))
                    idx = [];
                end
            else
                idx = find(RFDataHub.Station == str2double(stationID));
            end    
            
            if isempty(idx)
                error('Estação não consta na base <i>offline</i>. Favor confirmar que foi digitado o número corretamente.')
            end
            
            Latitude    = RFDataHub.Latitude(idx(1));
            Longitude   = RFDataHub.Longitude(idx(1));

            Frequency   = sprintf('%.3f, ', RFDataHub.Frequency(idx));
            Frequency   = Frequency(1:end-2);
        
            ID          = strjoin(string(idx), ', ');
            Service     = RFDataHub.Service(idx(1));
            Station     = RFDataHub.Station(idx(1));
            Description = class.RFDataHub.Description(RFDataHub, idx(1));
                        
            Distance    = fcn.gpsDistance([latNode, longNode], [Latitude, Longitude]);
            stationInfo = struct('ID', ID, 'Frequency', Frequency, 'Service', Service, 'Station', Station, 'Description', Description, 'Distance', Distance);
        end
    end
end