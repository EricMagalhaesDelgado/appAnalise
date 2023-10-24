function auxDistance = geoDistance_v2(Node, rawTable)

    radius = 6371;
    
    lat = Node.lat * pi / 180;
    lon = Node.lon * pi / 180;
    
    rawTable.lat = rawTable.Latitude  * pi / 180;
    rawTable.lon = rawTable.Longitude * pi / 180;
    
    rawTable.deltaLat = rawTable.lat - lat;
    rawTable.deltaLon = rawTable.lon - lon;
    
    a = sin((rawTable.deltaLat)/2).^2 + cos(lat) .* cos(rawTable.lat) .* sin(rawTable.deltaLon/2).^2;
    c = 2*atan2(sqrt(a), sqrt(1-a));
    
    rawTable.Distance = radius*c;    % Haversine distance
    auxDistance = rawTable.Distance;

end