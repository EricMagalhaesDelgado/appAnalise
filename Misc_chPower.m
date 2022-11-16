function chPower = Misc_chPower(rawData, chLimits)

    Start  = rawData.MetaData.FreqStart;
    Stop   = rawData.MetaData.FreqStop;
    
    
    % VALIDATIONS
    if (chLimits(1) > Stop) | (chLimits(2) < Start)
        error('Out of range')
    end

    if chLimits(1) < Start
        chLimits(1) = Start;
    end

    if chLimits(2) > Stop
        chLimits(2) = Stop;
    end


    % CHANNEL POWER
    Span   = Stop - Start;
    Points = rawData.MetaData.DataPoints;
    RBW    = rawData.MetaData.Resolution;
    
    % Freq_Hz = aCoef*idx + bCoef;
    aCoef  = Span ./ (Points - 1);
    bCoef  = Start - aCoef;
    
    xData  = linspace(Start, Stop, Points)';

    switch rawData.MetaData.metaString{1}
        case 'dBm';  yData = rawData.Data{2};
        case 'dBµV'; yData = rawData.Data{2} - 107;
        otherwise;   error('Unidade ainda não tratada...')
    end

    % Channel Limits (idx)
    idx1 = round((chLimits(1) - bCoef)/aCoef);
    idx2 = round((chLimits(2) - bCoef)/aCoef);
   
    xData_ch = xData(idx1:idx2);
    yData_ch = yData(idx1:idx2,:);

    if idx1 ~= idx2
        chPower = pow2db((trapz(xData_ch, db2pow(yData_ch)/RBW, 1)))';
    else
        chPower = yData_ch';
    end

end