function peaksTable = PreviewGenerator(app, idx, reportInfo)

    global ID_img
    ID_img = 0;

    SpecInfo   = report.TimeStampFilter(app, idx, reportInfo.TimeStamp);
    peaksTable = [];

    for ii = 1:numel(SpecInfo)
        Peaks = report.ReportGenerator_Peaks(app, SpecInfo, ii);

        if ~isempty(Peaks)
            if isempty(peaksTable); peaksTable = Peaks;
            else;                   peaksTable = [peaksTable; Peaks];
            end
        end
        
        ID_img = ID_img+1;
        report.ReportGenerator_Plot(SpecInfo, ii, reportInfo);
    end
end