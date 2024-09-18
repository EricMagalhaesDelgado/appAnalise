function Peaks = ReportGenerator_Peaks(app, idxThread, DetectionMode)
    
    % Detecção automática relacionada ao algoritmo escolhido no modo
    % "RELATÓRIO". As emissões aqui identificadas ficarão visíveis no
    % modo "PLAYBACK" também.

    if strcmp(DetectionMode, 'Automatic+Manual') && ~app.specData(idxThread).UserData.reportDetection.ManualMode
        Algorithm  = app.specData(idxThread).UserData.reportDetection.Algorithm;
        Attributes = app.specData(idxThread).UserData.reportDetection.Parameters;
        Attributes.Algorithm = Algorithm;

        switch Algorithm
            case 'FindPeaks'
                [newIndex, newFreq, newBW, Method] = fcn.Detection_FindPeaks(app.specData, idxThread, Attributes);
            case 'FindPeaks+OCC'
                [newIndex, newFreq, newBW, Method] = fcn.Detection_FindPeaksPlusOCC(app, app.specData, idxThread, Attributes);
        end
        newBW  = newBW * 1000;

        if ~isempty(newIndex)
            play_AddEmission2List(app, idxThread, newIndex, newFreq, newBW, Method)
        end
    end

    Peaks = app.specData(idxThread).UserData.Emissions(:,1:5);

    % Outros campos...
    if ~isempty(Peaks)
        Tag = sprintf('%s\n%.3f - %.3f MHz', app.specData(idxThread).Receiver,                  ...
                                             app.specData(idxThread).MetaData.FreqStart / 1e+6, ...
                                             app.specData(idxThread).MetaData.FreqStop  / 1e+6);
     
        Peaks.Tag(:)       = {Tag};
        Peaks.Latitude(:)  = single(app.specData(idxThread).GPS.Latitude);
        Peaks.Longitude(:) = single(app.specData(idxThread).GPS.Longitude);
        
        Peaks = movevars(Peaks, {'Tag', 'Latitude', 'Longitude'}, 'Before', 1);

        % E a classificação de cada emissão...
        Peaks = fcn.Classification(app, app.specData, idxThread, Peaks);
    end
end