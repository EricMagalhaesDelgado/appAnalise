function peaksTable = Peaks(app, idxThreads, DetectionMode, exceptionList)
    peaksTable = [];
    for ii = idxThreads
        Peaks = report.ReportGenerator_Peaks(app, ii, DetectionMode);

        if ~isempty(Peaks)
            if isempty(peaksTable); peaksTable = Peaks;
            else;                   peaksTable = [peaksTable; Peaks];
            end
        end

        Peaks = Fcn_exceptionList(Peaks, exceptionList);
        Peaks = Fcn_userDescription(Peaks, app.specData(ii).UserData.Emissions);

        app.specData(ii).UserData.reportPeaksTable = Peaks;
    end
end