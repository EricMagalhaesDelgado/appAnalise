function [version, appAnalise, RFDataHub] = PublicLinks(rootFolder)

    [projectFolder, ...
     programDataFolder] = appUtil.Path(class.Constants.appName, rootFolder);
    fileName            = 'PublicLinks.json';

    try
        fileParser = jsondecode(fileread(fullfile(programDataFolder, fileName)));
    catch
        fileParser = jsondecode(fileread(fullfile(projectFolder,     fileName)));
    end

    version    = fileParser.VersionFile;
    appAnalise = fileParser.appAnalise;
    RFDataHub  = fileParser.RFDataHub;

end