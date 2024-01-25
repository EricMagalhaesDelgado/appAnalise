function [City, Latitude, Longitude] = gpsFindCoordinates(City)
    
    load('IBGE.mat', 'IBGE');
    
    idx = find(strcmpi(IBGE.City, City));
    if ~isempty(idx)
        City      = IBGE.City{idx};
        Latitude  = IBGE.Latitude(idx);
        Longitude = IBGE.Longitude(idx);
    else
        City      = '';
        Latitude  = [];
        Longitude = [];
    end
end