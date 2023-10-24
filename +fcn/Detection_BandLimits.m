function [newIndex, newFreq, newBW] = Detection_BandLimits(app, idx, newIndex, newFreq, newBW)

    if app.specData(idx).UserData.bandLimitsStatus && height(app.specData(idx).UserData.bandLimitsTable)
        bandLimitsTable = app.specData(idx).UserData.bandLimitsTable;

        for ii = height(newFreq):-1:1
            if ~any((newFreq(ii) >= bandLimitsTable.FreqStart) & (newFreq(ii) <= bandLimitsTable.FreqStop))
                newIndex(ii) = [];
                newFreq(ii)  = [];
                newBW(ii)    = [];
            end
        end
    end
end