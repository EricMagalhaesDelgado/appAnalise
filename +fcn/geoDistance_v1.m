function Distance = geoDistance_v1(latlon1, latlon2)

    radius = 6371;
    
    lat1 = latlon1(1)*pi/180;
    lon1 = latlon1(2)*pi/180;
    
    lat2 = latlon2(1)*pi/180;
    lon2 = latlon2(2)*pi/180;
    
    deltaLat = lat2-lat1;
    deltaLon = lon2-lon1;
    
    a = sin((deltaLat)/2)^2 + cos(lat1) * cos(lat2) * sin(deltaLon/2)^2;
    c = 2*atan2(sqrt(a), sqrt(1-a));
    
    Distance = radius*c;    % Haversine distance

end