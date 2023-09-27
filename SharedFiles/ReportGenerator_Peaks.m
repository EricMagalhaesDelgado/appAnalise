function Peaks = ReportGenerator_Peaks(Data, RootFolder)

    % Detecção feita no modo "PLAYBACK"
    Peaks = Detection_manual(Data);
    
    % Detecção automática (relacionada ao algoritmo escolhido no modo
    % "RELATÓRIO"
    auxPeaks = [];
    if ~Data.reportDetection.ManualMode
        DetectionType = 'FindPeaks';
        % Data.report_peakInfo.DetectionType = 'FindPeaks';                                                 % Inserir esse campo na estrutura "report_peakInfo"

        switch DetectionType
            case 'FindPeaks'    
                auxPeaks = Detection_algorithm1(Data);

            case 'Algoritmo de detecção 2'
                % Pendente

        end
    end

    if ~isempty(auxPeaks)
        Peaks = Detection_validation(Data, Peaks, auxPeaks);
    end

    % Classificação
    ClassificationType = 'appAnálise v. 1.00';
    % Data.report_peakInfo.ClassificationType = 'appAnálise v. 1.00';                                       % Inserir esse campo na estrutura "report_peakInfo"

    switch ClassificationType
        case 'appAnálise v. 1.00'
            Peaks = Classification_algorithm1(Data, Peaks, RootFolder);

        case 'Algoritmo de classificação 2'
            % Pendente

    end

end