function Peaks = ReportGenerator_Peaks(app, SpecInfo, idx)
    
    % Detecção automática relacionada ao algoritmo escolhido no modo
    % "RELATÓRIO". Caso o fluxo de dados não for filtrado temporalmente, o 
    % que demanda trabalhar com uma cópia do app.specData, ao invés do próprio
    % app.specData, as emissões aqui identificadas ficarão visíveis no
    % modo "PLAYBACK" também.

    if ~SpecInfo(idx).UserData.reportDetection.ManualMode
        Algorithm  = SpecInfo(idx).UserData.reportDetection.Algorithm;

        Attributes = SpecInfo(idx).UserData.reportDetection.Parameters;
        Attributes.Algorithm = Algorithm;

        switch Algorithm
            case 'FindPeaks'
                [newIndex, newFreq, newBW, Method] = fcn.Detection_FindPeaks(SpecInfo, idx, Attributes);

            case 'FindPeaks+OCC'
                [newIndex, newFreq, newBW, Method] = fcn.Detection_FindPeaksPlusOCC(app, SpecInfo, idx, Attributes);
        end
        newBW  = newBW * 1000;

        if ~isempty(newIndex)
            NN = numel(newIndex);
            SpecInfo(idx).UserData.Emissions(end+1:end+NN,:) = table(newIndex, newFreq, newBW, true(numel(newIndex),1), Method);
            fcn.Detection_BandLimits(SpecInfo(idx))
        end
    end

    Peaks = SpecInfo(idx).UserData.Emissions;

    % Outros campos...
    if ~isempty(Peaks)
        Tag = sprintf('%s\nID %d: %.3f - %.3f MHz', SpecInfo(idx).Receiver,                  ...
                                                    SpecInfo(idx).RelatedFiles.ID(1),        ...
                                                    SpecInfo(idx).MetaData.FreqStart / 1e+6, ...
                                                    SpecInfo(idx).MetaData.FreqStop  / 1e+6);
     
        Peaks.Tag(:)       = {Tag};
        Peaks.Latitude(:)  = single(SpecInfo(idx).GPS.Latitude);
        Peaks.Longitude(:) = single(SpecInfo(idx).GPS.Longitude);
        
        Peaks = movevars(Peaks, {'Tag', 'Latitude', 'Longitude'}, 'Before', 1);


        % E a classificação de cada emissão...
        Peaks = fcn.Classification(app, SpecInfo, idx, Peaks);
    end
end