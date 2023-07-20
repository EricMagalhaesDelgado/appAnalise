function rawData = Misc_chPower_EmissionSimulator(specTask, Emissions)

    arguments 
        specTask  struct = struct('FreqStart', 2.4e+9, 'FreqStop', 2.5e+9, 'DataPoints', 501, 'Resolution', 100e+3, 'NoiseLevel', -90)
        Emissions struct = struct('FreqCenter', 2420e+6, 'BW', 20e+6, 'chPower', -10)
    end

    rawData = struct('MetaData', [], 'Data', {});

    Start  = specTask.FreqStart;
    Stop   = specTask.FreqStop;
    Span   = Stop - Start;
    Points = specTask.DataPoints;
    RBW    = specTask.Resolution;
    Noise  = specTask.NoiseLevel;
    
    xData = linspace(Start, Stop, Points)';
    yData = Noise*ones(Points, 1, 'single') + randn(Points, 1);                     % dBm
    
    % Freq = aCoef * idx + bCoef
    aCoef = Span/(Points-1);
    bCoef = Start - aCoef;
    
    for ii = 1:numel(Emissions)
        binPower = Emissions(ii).chPower + pow2db(RBW/Emissions.BW);
    
        idx1 = round((Emissions(ii).FreqCenter-Emissions(ii).BW/2 - bCoef)/aCoef);
        idx2 = round((Emissions(ii).FreqCenter+Emissions(ii).BW/2 - bCoef)/aCoef);
    
        if (idx1 > Points) | (idx2 < 1)
            continue
        end
    
        if idx1 < 1
            idx1 = 1;
        end
    
        if idx2 > Points
            idx2 = Points;
        end
    
        yData(idx1:idx2) = yData(idx1:idx2) + (binPower-Noise);
    end

    rawData(1).MetaData = struct('FreqStart', Start, 'FreqStop', Stop, 'DataPoints', Points, 'Resolution', RBW);
    rawData.MetaData.metaString = {'dBm', sprintf('%.3f kHz', RBW/1000), 'ClearWrite', 'Average/RMS', ''};
    rawData.Data                = {datetime("now"), yData};

    figure, plot(xData/1e+6, yData)

end