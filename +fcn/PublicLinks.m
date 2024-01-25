function [versionLink, RFDataHubLink] = PublicLinks(RootFolder)

    PublicLinks  = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'PublicLinks.json')));

    versionLink   = PublicLinks.VersionFile;
    RFDataHubLink = PublicLinks.RFDataHub;
end