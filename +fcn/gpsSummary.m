function gps = gpsSummary(RelatedGPS)

    gps = struct('Status',          0, ...
                 'Count',           0, ...
                 'Latitude',       -1, ...
                 'Longitude',      -1, ...
                 'Latitude_std',   -1, ...
                 'Longitude_std',  -1, ...
                 'stdRange',       -1, ...
                 'Location',       '', ...
                 'LocationSource', '', ...
                 'Matrix',         [], ...
                 'Edited',         false);

    % Organizando informação de GPS proveniente de mais de um arquivo
    % (aplicável para os arquivos MAT gerados no appAnalise, por exemplo)
    % em uma única variável.
    GPS = struct('Status', max(cellfun(@(x) x.Status, RelatedGPS)), ...
                 'Matrix', cell2mat(cellfun(@(x) x.Matrix, RelatedGPS, 'UniformOutput', false)));

    % Sumarizando a informação... essa estrutura de GPS é diferente da
    % estrutura usada na v. 1.35 do appAnalise, inserindo os campos
    % "Latitude_std", "Longitude_std" e "stdRange".
    if ~isempty(GPS.Matrix)
        gps.Status        = max(GPS.Status);
        gps.Count         = height(GPS.Matrix);
        gps.Latitude      = mean(GPS.Matrix(:,1));
        gps.Longitude     = mean(GPS.Matrix(:,2));
        gps.Latitude_std  = std(GPS.Matrix(:,1), 1);
        gps.Longitude_std = std(GPS.Matrix(:,2), 1);
        gps.Matrix        = GPS.Matrix;

        stdRange = ones(1,3);
        for kk = 1:3
            lat_min  = gps.Latitude  - kk*gps.Latitude_std;
            lat_max  = gps.Latitude  + kk*gps.Latitude_std;
            long_min = gps.Longitude - kk*gps.Longitude_std;
            long_max = gps.Longitude + kk*gps.Longitude_std;
    
            stdRange(kk) = 100 * sum(GPS.Matrix(:,1) >= lat_min  & GPS.Matrix(:,1) <= lat_max ...
                                   & GPS.Matrix(:,2) >= long_min & GPS.Matrix(:,2) <= long_max) / height(GPS.Matrix);
        end
        gps.stdRange           = stdRange;
        [cityName, ~, locInfo] = fcn.gpsFindCity(gps);
        gps.Location           = cityName;
        gps.LocationSource     = locInfo.infoSource;
    end
end