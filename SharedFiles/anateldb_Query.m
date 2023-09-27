function StationInfo = anateldb_Query(StationID, latNode, longNode, RootFolder)

    arguments
        StationID  char
        latNode    double
        longNode   double
        RootFolder char
    end
    
    % Station é uma string com o número da estação real ou virtual (quando possui o caractere "#" à frente do número).
    % latNode e longNode são as coordenadas geográficas do local onde ocorreu a monitoração.
    
    global AnatelDB
    
    if isempty(AnatelDB)
        anateldb_Read(RootFolder)
    end

    if ~contains(StationID, '#')
        ind = find(AnatelDB.Station == str2double(StationID));
    else
        ind = find(strcmp(AnatelDB.Id, StationID), 1);
    end    
    
    if isempty(ind)
        error('Estação não consta na base <i>offline</i>. Favor confirmar que foi digitado o número corretamente.')
    end
    
    Latitude    = AnatelDB.Latitude(ind(1));
    Longitude   = AnatelDB.Longitude(ind(1));
    
    Frequency   = sprintf('%.3f, ', AnatelDB.Frequency(ind));
    Frequency   = Frequency(1:end-2);

    ID          = strjoin(AnatelDB.Id(ind), ', ');
    Service     = AnatelDB.Service(ind(1));
    Station     = AnatelDB.Station(ind(1));
    Description = AnatelDB.Description(ind(1));
                
    Distance    = geo_lldistkm_v1([latNode, longNode], [Latitude, Longitude]);    
    StationInfo = struct('ID', ID, 'Frequency', Frequency, 'Service', Service, 'Station', Station, 'Description', Description, 'Distance', Distance);
    
end