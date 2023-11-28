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
            RFDataHub.("Entidade") = regexprep(lower(RFDataHub.("Entidade")), '(\<\w)', '${upper($1)}');
            RFDataHub.("Fistel")   = int64(RFDataHub.("Fistel"));
            RFDataHub.("Serviço")  = int16(RFDataHub.("Serviço"));
            RFDataHub.("Estação")  = int32(str2double(RFDataHub.("Estação")));
            
            RFDataHub.("Fistel")(RFDataHub.("Fistel")==0)   = -1;            
            RFDataHub.("Serviço")(RFDataHub.("Serviço")==0) = -1;

            for ii = 1:width(RFDataHub)
                if isnumeric(RFDataHub{:,ii})
                    idx = isnan(RFDataHub{:,ii});
                    RFDataHub{idx,ii} = -1;
                end
            end

            RFDataHub = convertvars(RFDataHub, [2, 8, 17:29], 'categorical');
            RFDataHub = renamevars(RFDataHub, ["Frequência", "Entidade", "Serviço", "Estação", "Código_Município", "Município", "UF", "Fonte", "Multiplicidade", "Classe", "Classe_Emissão", "Largura_Emissão(kHz)", "Relatório_Canal"], ...
                                              ["Frequency", "Name", "Service", "Station", "LocationID", "Location", "State", "Source", "MergeCount", "StationClass", "EmissionClass", "BW", "URL"]);
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
                        
            Distance    = fcn.geoDistance_v1([latNode, longNode], [Latitude, Longitude]);    
            stationInfo = struct('ID', ID, 'Frequency', Frequency, 'Service', Service, 'Station', Station, 'Description', Description, 'Distance', Distance);
        end
    end
end