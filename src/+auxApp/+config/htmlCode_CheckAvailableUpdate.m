function [htmlContent, stableVersion, updatedModule] = htmlCode_CheckAvailableUpdate(appGeneral, rootFolder)

    try
        % Versão instalada no computador:
        appName          = class.Constants.appName;
        presentVersion   = struct(appName,     appGeneral.AppVersion.(appName).version, ...
                                  'fiscaliza', appGeneral.AppVersion.fiscaliza,         ...
                                  'rfDataHub', appGeneral.AppVersion.rfDataHub); 
        
        % Versão estável, indicada nos arquivos de referência (na nuvem):
        [versionFileURL, rfDataHubURL] = util.publicLink(appName, rootFolder, 'VersionFile+RFDataHub');


        generalVersions  = webread(versionFileURL,       weboptions("ContentType", "json"));
        rfdatahubVersion = webread(rfDataHubURL.Release, weboptions("ContentType", "json"));

        stableVersion    = struct(appName,     generalVersions.(appName).Version, ...
                                  'fiscaliza', generalVersions.fiscaliza.Version, ...
                                  'rfDataHub', rfdatahubVersion.rfdatahub);
        
        % Validação:
        if isequal(presentVersion, stableVersion)
            msgWarning   = 'O appAnalise e os seus módulos - fiscaliza e RFDataHub - estão atualizados.';
            
        else
            updatedModule    = {};
            nonUpdatedModule = {};
            if strcmp(presentVersion.(appName), stableVersion.(appName))
                updatedModule(end+1)    = {'appAnalise'};
            else
                nonUpdatedModule(end+1) = {'appAnalise'};
            end

            if strcmp(presentVersion.fiscaliza,  stableVersion.fiscaliza)
                updatedModule(end+1)    = {'fiscaliza'};
            else
                nonUpdatedModule(end+1) = {'fiscaliza'};
            end

            if isequal(presentVersion.rfDataHub, stableVersion.rfDataHub)
                updatedModule(end+1)    = {'RFDataHub'};
            else
                nonUpdatedModule(end+1) = {'RFDataHub'};
            end

            dataStruct    = struct('group', 'VERSÃO INSTALADA', 'value', presentVersion);
            dataStruct(2) = struct('group', 'VERSÃO ESTÁVEL',   'value', stableVersion);
            dataStruct(3) = struct('group', 'SITUAÇÃO',         'value', struct('updated', strjoin(updatedModule, ', '), 'nonupdated', strjoin(nonUpdatedModule, ', ')));

            msgWarning = textFormatGUI.struct2PrettyPrintList(dataStruct);
        end
        
    catch ME
        msgWarning = ME.message;
    end

    htmlContent = msgWarning;
end