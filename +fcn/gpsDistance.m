function distance_km = gpsDistance(latlong1, latlong2)

    % - latlong1 pode ser uma estrutura com os campos "lat" e "lon" ou um
    %   vetor numérico.
    % - latlong2 pode ser uma tabela com as colunas "Latitude" e "Longitude"
    %   ou um vetor numérico.

    % latlong1 e latlong2, em sendo vetores numéricos, serão convertidos para 
    % estruturas.

    if isnumeric(latlong1) && isnumeric(latlong2)
        latlong1 = struct('lat',      latlong1(1), 'lon',       latlong1(2));
        latlong2 = struct('Latitude', latlong2(1), 'Longitude', latlong2(2));
    end

    radius = 6371; % km
    
    lat = latlong1.lat * pi / 180;
    lon = latlong1.lon * pi / 180;
    
    latlong2.lat = latlong2.Latitude  * pi / 180;
    latlong2.lon = latlong2.Longitude * pi / 180;
    
    latlong2.deltaLat = latlong2.lat - lat;
    latlong2.deltaLon = latlong2.lon - lon;
    
    a = sin((latlong2.deltaLat)/2).^2 + cos(lat) .* cos(latlong2.lat) .* sin(latlong2.deltaLon/2).^2;
    c = 2*atan2(sqrt(a), sqrt(1-a));
    
    latlong2.Distance = radius*c;    % Haversine distance
    distance_km = latlong2.Distance;
end