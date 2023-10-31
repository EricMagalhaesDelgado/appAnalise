function Detection_BandLimits(SpecInfo)

    bandLimitsTable = SpecInfo.UserData.bandLimitsTable;
    emissionsTable  = SpecInfo.UserData.Emissions;

    if SpecInfo.UserData.bandLimitsStatus && ~isempty(bandLimitsTable)
        for ii = height(emissionsTable):-1:1
            if ~any((emissionsTable.FreqCenter(ii) >= bandLimitsTable.FreqStart) & ...
                    (emissionsTable.FreqCenter(ii) <= bandLimitsTable.FreqStop))
                emissionsTable(ii,:) = [];
            end
        end
    end

    [~, uniqueIndex] = unique(emissionsTable.idx);
    emissionsTable   = emissionsTable(uniqueIndex,:);
    
    SpecInfo.UserData.Emissions = emissionsTable;
end