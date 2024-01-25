function [newIndex, newFreq, newBW, Method] = Detection_FindPeaks(SpecInfo, idx1, Attributes)

    newIndex = [];
    newFreq  = [];
    newBW    = [];
    Method   = [];

    switch Attributes.Fcn
        case 'MinHold'; idx2 = 1;
        case 'Média';   idx2 = 2;
        case 'MaxHold'; idx2 = 3;
    end

    %---------------------------------------------------------------------%
    % ## METHOD 1: internal findpeaks ##
    %---------------------------------------------------------------------%
    % delete(findobj(Type='Line', Tag='HalfProminenceWidth'))
    % drawnow nocallbacks
    % 
    % tempFig = figure('Visible', 'on');
    % findpeaks(Data.statsData(:,idx1), 'NPeaks',            Attributes.NPeaks,                  ...
    %                                   'MinPeakHeight',     Attributes.THR,                     ...
    %                                   'MinPeakProminence', Attributes.Proeminence,             ...
    %                                   'MinPeakDistance',   1000 * Attributes.Distance / aCoef, ...
    %                                   'MinPeakWidth',      1000 * Attributes.BW / aCoef,       ...
    %                                   'SortStr',           'descend',                          ...
    %                                   'Annotate',          'extents');
    % 
    % h = findobj(Type='Line', Tag='HalfProminenceWidth');
    % if ~isempty(h)
    %     for ii = 1:numel(h.XData)/3
    %         newIndex(ii,1)    = mean(h.XData(3*(ii-1)+1:3*(ii-1)+2));
    %         newBW_Index(ii,1) = diff(h.XData(3*(ii-1)+1:3*(ii-1)+2));
    %     end
    % 
    %     newFreq  = (aCoef .* newIndex + bCoef) ./ 1e+6;
    %     newBW    = newBW_Index * aCoef / 1e+6;
    %     newIndex = round(newIndex);
    % end
    % delete(tempFig)

    DataPoints = SpecInfo(idx1).MetaData.DataPoints;
    FreqStart  = SpecInfo(idx1).MetaData.FreqStart;
    FreqStop   = SpecInfo(idx1).MetaData.FreqStop;

    aCoef      = (FreqStop-FreqStart)/(DataPoints-1);
    bCoef      = FreqStart-aCoef;

    %---------------------------------------------------------------------%
    % ## METHOD 2: edited findpeaks ##
    %---------------------------------------------------------------------%
    idxRange = matlab.findpeaks(SpecInfo(idx1).Data{3}(:,idx2), 'NPeaks',            Attributes.NPeaks,                  ...
                                                                'MinPeakHeight',     Attributes.THR,                     ...
                                                                'MinPeakProminence', Attributes.Prominence,              ...
                                                                'MinPeakDistance',   1000 * Attributes.Distance / aCoef, ... % kHz >> Hertz
                                                                'MinPeakWidth',      1000 * Attributes.BW       / aCoef, ... % kHz >> Hertz
                                                                'SortStr',           'descend');

    if ~isempty(idxRange)
        newIndex = mean(idxRange, 2);
        newFreq  = (aCoef .* newIndex + bCoef) ./ 1e+6;                     % Em MHz
        newBW    = (idxRange(:,2)-idxRange(:,1)) * aCoef / 1e+6;            % Em MHz

        newIndex = round(newIndex);
        Method   = repmat({jsonencode(struct('Algorithm',  Attributes.Algorithm, ...
                                             'Parameters', rmfield(Attributes, 'Algorithm')))}, numel(newIndex), 1);
    end
end