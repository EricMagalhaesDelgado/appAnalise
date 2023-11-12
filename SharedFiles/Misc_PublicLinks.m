function [versionLink, anateldbLink] = Misc_PublicLinks(RootFolder)

    arguments
        RootFolder char
    end

    PublicLinks = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'PublicLinks.json')));

    versionLink  = PublicLinks.VersionFile;
    anateldbLink = PublicLinks.anateldb;

end