function occData = OCC(app, idx1)
    
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
        case {'Linear adaptativo', 'Piso de ruído (Offset)'}
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
end


%-------------------------------------------------------------------------%
