function ReportGenerator_Peaks(app, idxThread, DetectionMode)
    
    % Detecção automática relacionada ao algoritmo escolhido no modo
    % "RELATÓRIO". As emissões aqui identificadas ficarão visíveis no
    % modo "PLAYBACK" também.

    if strcmp(DetectionMode, 'Automatic+Manual') && ~app.specData(idxThread).UserData.reportAlgorithms.Detection.ManualMode
        Algorithm  = app.specData(idxThread).UserData.reportAlgorithms.Detection.Algorithm;
        Attributes = app.specData(idxThread).UserData.reportAlgorithms.Detection.Parameters;
        Attributes.Algorithm = Algorithm;

        switch Algorithm
            case 'FindPeaks'
                [newIndex, newFreq, newBW, Method] = util.Detection.FindPeaks(       app.specData, idxThread, Attributes);
            case 'FindPeaks+OCC'
                [newIndex, newFreq, newBW, Method] = util.Detection.FindPeaksPlusOCC(app.specData, idxThread, Attributes);
        end
        newBW  = newBW * 1000;

        if ~isempty(newIndex)
            play_AddEmission2List(app, idxThread, newIndex, newFreq, newBW, Method)
        end
    end
end