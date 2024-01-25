function Detection_BandLimits(SpecInfo)

    bandLimitsTable = SpecInfo.UserData.bandLimitsTable;
    emissionsTable  = SpecInfo.UserData.Emissions;

    if SpecInfo.UserData.bandLimitsStatus && ~isempty(bandLimitsTable)
        for ii = height(emissionsTable):-1:1
            if ~any((emissionsTable.Frequency(ii) >= bandLimitsTable.FreqStart) & ...
                    (emissionsTable.Frequency(ii) <= bandLimitsTable.FreqStop))
                emissionsTable(ii,:) = [];
            end
        end
    end

    [~, uniqueIndex] = unique(emissionsTable.Index);
    emissionsTable   = emissionsTable(uniqueIndex,:);
    
    SpecInfo.UserData.Emissions = emissionsTable;
end