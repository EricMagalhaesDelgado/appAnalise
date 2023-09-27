function [versionLink, anateldbLink] = Misc_PublicLinks(RootFolder)

    arguments
        RootFolder char
    end

    versionLink  = fileread(fullfile(RootFolder, 'Settings', 'PublicLink.json'));
    anateldbLink = fileread(fullfile(RootFolder, 'Settings', 'PublicLink_anateldb.json'));

%%    QUANDO DISPONIBILIZADA UMA NOVA VERSÃO DO SPLASH SCREEN, AJUSTAR PUBLICLINKS.JSON 
%%    MANTENDO TODOS OS LINKS NUM ÚNICO ARQUIVO.

%     PublicLinks = jsondecode(fileread(fullfile(RootFolder, 'Settings', 'PublicLinks.json')));
%     
%     versionLink  = PublicLinks.version;
%     anateldbLink = PublicLinks.anateldb;

end