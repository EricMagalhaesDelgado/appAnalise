function peaksTable = PreviewGenerator(app, idx, reportInfo)

    SpecInfo   = report.TimeStampFilter(app, idx, reportInfo.TimeStamp);
    ID_img     = 0;    
    peaksTable = [];

    for ii = 1:numel(SpecInfo)
        Peaks = report.ReportGenerator_Peaks(app, SpecInfo, ii);

        if ~isempty(Peaks)
            if isempty(peaksTable); peaksTable = Peaks;
            else;                   peaksTable = [peaksTable; Peaks];
            end
        end

        SpecInfo(ii).Peaks = Peaks;
        
        ID_img = ID_img+1;
        ReportGenerator_Plot(SpecInfo, ii, ID_img, reportInfo);
    end
end