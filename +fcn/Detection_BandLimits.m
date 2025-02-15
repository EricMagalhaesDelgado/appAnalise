function Detection_BandLimits(specData)

    bandLimitsTable = specData.UserData.bandLimitsTable;

    % Insere a coluna "Base64", que retorna um Hash do tag da emissão, no
    % formato "100.300 MHz ⌂ 256.0 kHz", por exemplo. Esse Hash é usado p/
    % identificar as emissões únicas.

    emissionsTable  = specData.UserData.Emissions;
    emissionsTable.Base64 = cellfun(@(x) Base64Hash.encode(x), arrayfun(@(x, y) sprintf('%.3f MHz ⌂ %.1f kHz', x, y), emissionsTable.Frequency, emissionsTable.BW_kHz, "UniformOutput", false), 'UniformOutput', false);

    if specData.UserData.bandLimitsStatus && ~isempty(bandLimitsTable)
        for ii = height(emissionsTable):-1:1
            if ~any((emissionsTable.Frequency(ii) >= bandLimitsTable.FreqStart) & ...
                    (emissionsTable.Frequency(ii) <= bandLimitsTable.FreqStop))
                emissionsTable(ii, :) = [];
            end
        end
    end

    [~, uniqueIndex] = unique(emissionsTable.Base64);
    emissionsTable   = sortrows(emissionsTable(uniqueIndex, :), {'idxFrequency', 'BW_kHz'});
    
    % A coluna "Base64" não é emportada para "Emissions".
    specData.UserData.Emissions = emissionsTable(:, 1:end-1);
end