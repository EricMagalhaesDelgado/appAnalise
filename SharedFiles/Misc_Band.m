function [idx, Band] = Misc_Band(Data)

    global peaksReference

    CF   = (Data.MetaData.FreqStart + Data.MetaData.FreqStop)/2;
    Span =  Data.MetaData.FreqStop  - Data.MetaData.FreqStart;

    idx  = [];
    Band = '';

    for ii = 1:numel(peaksReference)
        if (CF > peaksReference(ii).Band(1)) && (CF < peaksReference(ii).Band(2)) && (Span >= 10e+6)
            idx  = ii;
            Band = peaksReference(ii).Description;
            break
        end
    end

end