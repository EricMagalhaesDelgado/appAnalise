function ChannelPower = chPower(rawData, chLimits)

    Start  = rawData.MetaData.FreqStart;
    Stop   = rawData.MetaData.FreqStop;
    Span   = Stop - Start;
    Points = rawData.MetaData.DataPoints;
    RBW    = rawData.MetaData.Resolution;
    
    if (chLimits(1) > Stop) || (chLimits(2) < Start)
        error('Out of range')
    end

    chLimits(1) = max(chLimits(1), Start);
    chLimits(2) = min(chLimits(2), Stop);
    
    % Freq_Hz = aCoef*idx + bCoef;
    aCoef  = Span ./ (Points - 1);
    bCoef  = Start - aCoef;    
    xData  = linspace(Start, Stop, Points)';

    switch rawData.MetaData.LevelUnit
        case 'dBm';  yData = rawData.Data{2};
        case 'dBµV'; yData = rawData.Data{2} - 107;
        otherwise;   error('Unexpected unit level.')
    end

    % Channel Limits (idx)
    idx1 = round((chLimits(1) - bCoef)/aCoef);
    idx2 = round((chLimits(2) - bCoef)/aCoef);
   
    xData_ch = xData(idx1:idx2);
    yData_ch = yData(idx1:idx2,:);

    if idx1 ~= idx2
        ChannelPower = pow2db((trapz(xData_ch, db2pow(yData_ch)/RBW, 1)))';
    else
        ChannelPower = yData_ch';
    end
end