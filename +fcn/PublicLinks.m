function [versionLink, anateldbLink] = PublicLinks(RootFolder)

    PublicLinks  = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'PublicLinks.json')));

    versionLink  = PublicLinks.VersionFile;
    anateldbLink = PublicLinks.anateldb;
end