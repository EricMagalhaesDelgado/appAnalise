function peaksTable = PreviewGenerator(app, idxThreads, DetectionMode)
    peaksTable = [];
    for ii = idxThreads
        Peaks = report.ReportGenerator_Peaks(app, ii, DetectionMode);

        if ~isempty(Peaks)
            if isempty(peaksTable); peaksTable = Peaks;
            else;                   peaksTable = [peaksTable; Peaks];
            end
        end
    end
end