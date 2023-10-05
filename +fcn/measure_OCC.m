function measure_OCC(app, idx1)
    
    % Parâmetros
    occInfo = jsondecode(app.specData(idx1).UserData.reportOCC.Parameters);

    % Estimativa da quantidade de amostras que poderá ter o fluxo de ocupação.
    occSamples  = ceil(minutes(app.specData(idx1).Data{1}(end)-app.specData(idx1).Data{1}(1)) / occInfo.IntegrationTime);
    occData     = {repmat(datetime(0,0,0), 1, occSamples), ...
                   zeros(app.specData(idx1).MetaData.DataPoints, occSamples, 'single')};
    
    % Estimativa do piso de ruído.
    switch app.specData(idx1).UserData.reportOCC.Method
        case 'Linear fixo'
            occTHR = occInfo.THR;
        case {'Linear adaptativo' e 'Piso de ruído (Offset)'}
            occTHR = transpose(threshold_OCC(app.specData(idx1).UserData.reportOCC.Method, app.specData(idx1), occInfo));
    end
    specData(idx1).reportOCC.Value = occTHR(end);
    
    % Fluxo de ocupação.
    referenceTime = specData(idx1).Data{1}(1);
    occStamp      = 1;
    
    while referenceTime < specData(idx1).Data{1}(end)
        [~, idx2] = find((specData(idx1).Data{1} >= referenceTime) & ...
                         (specData(idx1).Data{1} <  referenceTime + minutes(occInfo.IntegrationTime)));
        
        if isempty(idx2)
            referenceTime = referenceTime + minutes(occInfo.IntegrationTime);
            
        else
            auxMatrix = specData(idx1).Data{2}(:, idx2);
            
            switch app.specData(idx1).UserData.reportOCC.Method
                case {'Linear fixo', 'Linear adaptativo'}
                % Parece igual, mas não é! :)
                if occTHR < 0
                    auxMatrix(auxMatrix >  occTHR) = 1;
                    auxMatrix(auxMatrix <= occTHR) = 0;
                else
                    auxMatrix(auxMatrix <= occTHR) = 0;
                    auxMatrix(auxMatrix >  occTHR) = 1;
                end

                case 'Piso de ruído (Offset)'
                    auxMatrix = auxMatrix - occTHR;
                    
                    auxMatrix(auxMatrix >  0) = 1;
                    auxMatrix(auxMatrix <= 0) = 0;
            end
            
            occData{1}(occStamp)   = referenceTime;
            occData{2}(:,occStamp) = 100 * sum(auxMatrix, 2) / width(auxMatrix);
            
            referenceTime = referenceTime + minutes(occInfo.IntegrationTime);
            occStamp      = occStamp + 1;    
        end
    end
    nSamples = occStamp-1;
    
    if nSamples < numel(occData{1})
        occData{1}(occStamp:end)   = [];
        occData{2}(:,occStamp:end) = [];
    end

    % Plot
    specData(occIndex).statsData = [min(specData(occIndex).Data{2}, [], 2), ...
                                    mean(specData(occIndex).Data{2},    2), ...
                                    max(specData(occIndex).Data{2}, [], 2)];
    
end


%-------------------------------------------------------------------------%
function occTHR = threshold_OCC(Type, Data, occInfo)

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