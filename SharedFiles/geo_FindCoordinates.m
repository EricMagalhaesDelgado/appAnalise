function [City, Latitude, Longitude] = geo_FindCoordinates(City)

    arguments
        City char
    end
    
    load('IBGE.mat', 'IBGE');
    
    ind = find(strcmpi(IBGE.City, City));
    if ~isempty(ind)
        City      = IBGE.City{ind};
        Latitude  = IBGE.Latitude(ind);
        Longitude = IBGE.Longitude(ind);
    else
        City      = '';
        Latitude  = [];
        Longitude = [];
    end
end