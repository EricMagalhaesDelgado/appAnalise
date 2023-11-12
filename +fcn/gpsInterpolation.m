function gpsData = gpsInterpolation(gpsArray)

    gpsData   = struct('Status', 0, 'Matrix', []);
    gpsStatus = max(gpsArray(:,1));
    
    if gpsStatus
        gpsData.Status = gpsStatus;

        idx_invalid = find(gpsArray(:,1) == 0);
        if ~isempty(idx_invalid)
            idx_valid = find(gpsArray(:,1) == 1);

            latArray  = interp1(idx_valid, gpsArray(idx_valid,2), idx_invalid, 'linear', 'extrap');
            longArray = interp1(idx_valid, gpsArray(idx_valid,3), idx_invalid, 'linear', 'extrap');
            gpsArray(idx_invalid,2:3) = [latArray, longArray];
        end

        gpsData.Matrix = gpsArray(:,2:3);
    end
end