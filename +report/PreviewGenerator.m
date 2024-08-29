function peaksTable = PreviewGenerator(app, idx, DetectionMode)

    %SpecInfo   = report.TimeStampFilter(app, idx, reportInfo.TimeStamp);
    SpecInfo = app.specData(idx);
    peaksTable = [];

    for ii = 1:numel(SpecInfo)
        Peaks = report.ReportGenerator_Peaks(app, SpecInfo, ii, DetectionMode);

        if ~isempty(Peaks)
            if isempty(peaksTable); peaksTable = Peaks;
            else;                   peaksTable = [peaksTable; Peaks];
            end
        end
    end
end