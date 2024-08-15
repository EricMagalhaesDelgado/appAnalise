function xytLimits = axesLimits(specData)

    xytLimits = [];

    % Inicialmente, avalia se o objeto possui a propriedade "customPlayback" 
    % configurada para "manual". Lembrando que o controle desses atributos
    % é recente, então um .MAT antigo pode registrar controle "manual", mas
    % não possuir esses atributos. Dessa forma, xyLimits retornará vazia.
    if specData.UserData.customPlayback.Type == "manual"
        xytLimits = playback.customPlayback('updateXYLimits', specData);
    end

    if isempty(xytLimits)
        % xLimits
        FreqStart = specData.MetaData.FreqStart / 1e+6;
        FreqStop  = specData.MetaData.FreqStop  / 1e+6;
        xLimits   = [FreqStart, FreqStop];
    
        % yLimits
        if ismember(specData.MetaData.DataType, class.Constants.specDataTypes)
            auxValue = min(specData.Data{3}(:,1));
            downYLim = auxValue - mod(auxValue, 10);
        
            auxValue = max(specData.Data{3}(:,3));
            upYLim   = auxValue - mod(auxValue, 10) + 10;
    
        else
            downYLim = 0;
            upYLim   = 100;
        end
        yLimits = [downYLim, upYLim];
    
        if diff(yLimits) > class.Constants.yMaxLimRange
            yLimits(1) = yLimits(1) + diff(yLimits) - class.Constants.yMaxLimRange;
        end

        xytLimits.xLim = xLimits;
        xytLimits.yLim = yLimits;
    end

    xytLimits.tLim = [specData.Data{1}(1), specData.Data{1}(end)];
    if specData.Data{1}(1) == specData.Data{1}(end)
        xytLimits.tLim(2) = xytLimits.tLim(2) + seconds(1);
    end
end