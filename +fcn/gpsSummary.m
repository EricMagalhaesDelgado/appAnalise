 function gps = gpsSummary(RelatedGPS)

    % Organizando informação de GPS proveniente de mais de um arquivo
    % (aplicável para os arquivos MAT gerados no appAnalise, por exemplo)
    % em uma única variável.
    GPS = struct('Status', [], ...
                 'Matrix', []);
    for ii = 1:numel(RelatedGPS)
        if RelatedGPS{ii}.Status
            GPS.Status = [GPS.Status, RelatedGPS{ii}.Status];
            GPS.Matrix = [GPS.Matrix; RelatedGPS{ii}.Matrix];
        end
    end

    % Sumarizando a informação... essa estrutura de GPS é diferente da
    % estrutura usada na v. 1.35 do appAnalise, inserindo os campos
    % "Latitude_std", "Longitude_std" e "stdRange".
    if ~isempty(GPS.Matrix)
        gps = struct('Status',        max(GPS.Status),         ...
                     'Count',         height(GPS.Matrix),      ...
                     'Latitude',      mean(GPS.Matrix(:,1)),   ...
                     'Longitude',     mean(GPS.Matrix(:,2)),   ...
                     'Latitude_std',  std(GPS.Matrix(:,1), 1), ...
                     'Longitude_std', std(GPS.Matrix(:,2), 1));

        stdRange = ones(1,3);
        for kk = 1:3
            lat_min  = gps.Latitude  - kk*gps.Latitude_std;
            lat_max  = gps.Latitude  + kk*gps.Latitude_std;
            long_min = gps.Longitude - kk*gps.Longitude_std;
            long_max = gps.Longitude + kk*gps.Longitude_std;
    
            stdRange(kk) = 100 * sum(GPS.Matrix(:,1) >= lat_min  & GPS.Matrix(:,1) <= lat_max ...
                                   & GPS.Matrix(:,2) >= long_min & GPS.Matrix(:,2) <= long_max) / height(GPS.Matrix);
        end
        gps.stdRange = stdRange;

        [cityName, ~, locInfo] = fcn.gpsFindCity(gps);
        gps.Location = cityName;
        gps.LocationSource = locInfo.infoSource;
        gps.Matrix = GPS.Matrix;
        
    else
        gps = struct('Status',          0, ...
                     'Count',           0, ...
                     'Latitude',       -1, ...
                     'Longitude',      -1, ...
                     'Latitude_std',   -1, ...
                     'Longitude_std',  -1, ...
                     'stdRange',       -1, ...
                     'Location',       '', ...
                     'LocationSource', '', ...
                     'Matrix',         []);
    end
end