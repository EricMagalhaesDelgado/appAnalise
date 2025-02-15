function gpsProperty(specData, idxThreads)
    arguments
        specData   model.SpecData
        idxThreads (1,:) {mustBeVector}
    end

    for ii = idxThreads
        gpsData   = struct('Status', 0, 'Matrix', []);
        gpsStatus = max(cellfun(@(x) x.Status, specData(ii).RelatedFiles.GPS));
        if gpsStatus
            gpsData.Status = gpsStatus;
            gpsData.Matrix = cell2mat(cellfun(@(x) x.Matrix, specData(ii).RelatedFiles.GPS, 'UniformOutput', false));
        end
    
        specData(ii).GPS = rmfield(fcn.gpsSummary({gpsData}), 'Matrix');
    end
end