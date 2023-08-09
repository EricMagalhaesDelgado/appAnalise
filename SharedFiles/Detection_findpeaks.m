function [newIndex, newFreq, newBW] = Detection_findpeaks(Data, Attributes)

    newIndex = [];
    newFreq  = [];
    newBW    = [];

    Span     = Data.MetaData.FreqStop - Data.MetaData.FreqStart;
    aCoef    = Span ./ (Data.MetaData.DataPoints - 1);
    bCoef    = Data.MetaData.FreqStart - aCoef;

    switch Attributes.Fcn
        case 'Mediana'; idx1 = 2;
        case 'Média';   idx1 = 3;
        case 'MaxHold'; idx1 = 4;
    end

    delete(findobj(Type='Line', Tag='HalfProminenceWidth'))
    drawnow nocallbacks

    tempFig = figure;
    findpeaks(Data.statsData(:,idx1), 'NPeaks',            Attributes.NPeaks,                  ...
                                      'MinPeakHeight',     Attributes.THR,                     ...
                                      'MinPeakProminence', Attributes.Proeminence,             ...
                                      'MinPeakDistance',   1000 * Attributes.Distance / aCoef, ...
                                      'MinPeakWidth',      1000 * Attributes.BW / aCoef,       ...
                                      'SortStr',           'descend',                          ...
                                      'Annotate',          'extents');
             

    h = findobj(Type='Line', Tag='HalfProminenceWidth');
    if ~isempty(h)
        for ii = 1:numel(h.XData)/3
            newIndex(ii,1)    = round(mean(h.XData(3*(ii-1)+1:3*(ii-1)+2)));
            newBW_Index(ii,1) = diff(h.XData(3*(ii-1)+1:3*(ii-1)+2));
        end

        newFreq = (aCoef .* newIndex + bCoef) ./ 1e+6;                                                  % Em MHz
        newBW   = newBW_Index * aCoef / 1e+6;                                                           % Em MHz
    end
    delete(tempFig)

end