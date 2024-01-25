function [cityName, distValue_km, locInfo] = gpsFindCity(gps, method)

    arguments
        gps    struct
        method {mustBeMember(method, {'API/IBGE', 'API', 'IBGE'})} = 'API/IBGE'
    end
    
    load('IBGE.mat', 'IBGE');

    switch method
        case 'API/IBGE'
            [cityName, distValue_km, locInfo] = FindCity_API_IBGE(gps, IBGE);

        case 'API'
            [cityName, distValue_km, locInfo] = FindCity_API(gps, IBGE);

        case 'IBGE'
            [cityName, distValue_km, locInfo] = FindCity_IBGE(gps, IBGE, '');
    end
end


%-------------------------------------------------------------------------%
function [cityName, distValue_km, locInfo] = FindCity_API_IBGE(gps, IBGE)
    [cityName, distValue_km, locInfo] = FindCity_API(gps, IBGE);

    if isempty(cityName) || (distValue_km == -1) || isempty(locInfo)
        [cityName, distValue_km, locInfo] = FindCity_IBGE(gps, IBGE, locInfo);
    end
end


%-------------------------------------------------------------------------%
function [cityName, distValue_km, locInfo] = FindCity_API(gps, IBGE)
    cityName     = '';
    distValue_km = -1;
    locInfo      = '';

    try
        locInfo = webread(replace(class.Constants.gps2locAPI, {'<Latitude>', '<Longitude>'}, {num2str(gps.Latitude), num2str(gps.Longitude)}));
        locInfo.infoSource = 'API';

        if ~isempty(locInfo.(class.Constants.gps2loc_City))
            cityName = sprintf('%s/%s', locInfo.(class.Constants.gps2loc_City), locInfo.(class.Constants.gps2loc_Unit)(end-1:end));
        end

        idx = find(IBGE.City == string(cityName), 1);
        if ~isempty(idx)
            distValue_km = FindCity_Distance(gps, IBGE(idx,:));
        end
    
    catch
    end
end


%-------------------------------------------------------------------------%
function [cityName, distValue_km, locInfo] = FindCity_IBGE(gps, IBGE, locInfo)
    [distValue_km, idx] = min(FindCity_Distance(gps, IBGE));
    cityName = IBGE.City{idx};
    locInfo.infoSource = 'IBGE';
end


%-------------------------------------------------------------------------%
function dArray = FindCity_Distance(gps, IBGE)
    radEarth = 6371;
    
    latErrs = abs(IBGE.Latitude  - gps.Latitude);
    lonErrs = abs(IBGE.Longitude - gps.Longitude);
    
    latDists = deg2rad(latErrs) .* radEarth;
    lonDists = cos(deg2rad(latErrs)) .* deg2rad(lonErrs) .* radEarth;
    
    dArray   = (latDists.^2+lonDists.^2).^0.5;
end