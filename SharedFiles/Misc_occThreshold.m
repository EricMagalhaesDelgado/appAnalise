function occTHR = Misc_occThreshold(Type, Data, occInfo)

    statsFcn  = occInfo.Fcn;
    tSamples  = occInfo.Samples(1);                     
    uSamples  = occInfo.Samples(2);
    Offset    = occInfo.Offset;

    switch statsFcn
        case 'Mediana'; indStats = 2;
        case 'Média';   indStats = 3;
    end
    occTHR = Data.statsData(:, indStats)';
    
    ind1 = ceil((tSamples/100) * Data.MetaData.DataPoints);
    ind2 = ind1 + ceil((uSamples/100) * Data.MetaData.DataPoints);
    
    if ~ind1; ind1 = 1;
    end
    
    if ind2 > Data.MetaData.DataPoints; ind2 = Data.MetaData.DataPoints;
    end

    switch Type
        case 'Linear adaptativo'
            occTHR = occTHR(ind1:ind2);
            
            if ~mod(numel(occTHR), 2); occTHR(end) = [];
            end
            
            switch statsFcn
                case 'Mediana'; occTHR = ceil(median(occTHR) + Offset);
                case 'Média';   occTHR = ceil(mean(occTHR)   + Offset);
            end
            
            
        case 'Piso de ruído (Offset)'
            ConfLevel = occInfo.Factor;
            
            auxMatrix = sort(Data.Data{2});
            auxMatrix = auxMatrix(ind1:ind2, :);
            
            noiseMean = mean(auxMatrix,    'all');
            noiseStd  =  std(auxMatrix, 1, 'all');
            
            switch ConfLevel
                case '68'; Factor = 1;
                case '95'; Factor = 2;
                case '99'; Factor = 3;
            end
            occTHR(occTHR < noiseMean - Factor*noiseStd) = noiseMean - Factor*noiseStd;
            occTHR(occTHR > noiseMean + Factor*noiseStd) = noiseMean + Factor*noiseStd;
            
            occTHR = occTHR + Offset;
    end

end