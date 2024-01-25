function GeneralSettings(appGeneral, RootFolder)

    appGeneral = rmfield(appGeneral, {'version', 'Models', 'Report'});
    
    if ismember(appGeneral.userPath, class.Constants.userPaths)
        appGeneral.userPath = '';
    end

    try
        fileID = fopen(fullfile(RootFolder, 'Settings', 'GeneralSettings.json'), 'wt');
        fwrite(fileID, jsonencode(appGeneral, 'PrettyPrint', true));
        fclose(fileID);
    catch
    end
end