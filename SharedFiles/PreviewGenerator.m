function peaksTable = PreviewGenerator(Data, reportInfo)

    global specData
    global ID_img    

    specData = Misc_TimeStampFilter(Data, reportInfo.TimeStamp, 1);
    ID_img   = 0;
    
    peaksTable    = [];
    RootFolder    = reportInfo.General.RootFolder;
    
    specDataTypes = [1, 4, 7, 60, 61, 63, 64, 67, 68, 167, 168, 1809];
    
    for ii = 1:numel(specData)
        if ismember(specData(ii).MetaData.DataType, specDataTypes)
            if isempty(specData(ii).reportOCC.Index)
                ReportGenerator_OCC(ii)
            end

            Peaks = ReportGenerator_Peaks(specData(ii), RootFolder);

            if ~isempty(Peaks)
                if isempty(peaksTable); peaksTable = Peaks;
                else;                   peaksTable(end+1:end+height(Peaks),:) = Peaks;
                end
            end

            specData(ii).Peaks = Peaks;
            
            ID_img = ID_img+1;
            ReportGenerator_Plot(ii, reportInfo);

        end
    end

    clear global specData

end