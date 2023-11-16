function gpsProperty(app, idx)

    arguments
        app
        idx (1,:) {mustBeVector}
    end

    for ii = idx
        gpsData   = struct('Status', 0, 'Matrix', []);    
        gpsStatus = max(cellfun(@(x) x.Status, app.specData(ii).RelatedFiles.GPS));
    
        if gpsStatus
            gpsData.Status = gpsStatus;
            gpsData.Matrix = cell2mat(cellfun(@(x) x.Matrix, app.specData(ii).RelatedFiles.GPS, 'UniformOutput', false));
        end
    
        app.specData(ii).GPS = rmfield(fcn.gpsSummary({gpsData}), 'Matrix');
    end
end