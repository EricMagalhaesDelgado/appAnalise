function [newIndex, newFreq, newBW] = Detection_findpeaks(app, idx1, Attributes)

    newIndex = [];
    newFreq  = [];
    newBW    = [];

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


    %---------------------------------------------------------------------%
    % ## METHOD 2: edited findpeaks ##
    %---------------------------------------------------------------------%
    idxRange = matlab.findpeaks(app.specData(idx1).Data{3}(:,idx2), 'NPeaks',            Attributes.NPeaks,                           ...
                                                                    'MinPeakHeight',     Attributes.THR,                              ...
                                                                    'MinPeakProminence', Attributes.Prominence,                       ...
                                                                    'MinPeakDistance',   1000 * Attributes.Distance / app.Band.aCoef, ...
                                                                    'MinPeakWidth',      1000 * Attributes.BW       / app.Band.aCoef, ...
                                                                    'SortStr',           'descend');

    if ~isempty(idxRange)
        newIndex = mean(idxRange, 2);
        newFreq  = (app.Band.aCoef .* newIndex + app.Band.bCoef) ./ 1e+6;   % Em MHz
        newBW    = (idxRange(:,2)-idxRange(:,1)) * app.Band.aCoef / 1e+6;   % Em MHz

        newIndex = round(newIndex);
    end
end