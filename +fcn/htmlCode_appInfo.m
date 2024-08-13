function appInfo = htmlCode_appInfo(appGeneral, rootFolder, executionMode)

    global RFDataHub
    global RFDataHub_info

    appName       = class.Constants.appName;
    appVersion    = fcn.envVersion(rootFolder);
    [~, appAnaliseLink] = fcn.PublicLinks(rootFolder);

    switch executionMode
        case {'MATLABEnvironment', 'desktopStandaloneApp'}                  % MATLAB | MATLAB RUNTIME
            appMode = 'desktopApp';

        case 'webApp'                                                       % MATLAB WEBSERVER + RUNTIME
            computerName = ccTools.fcn.OperationSystem('computerName');
            if strcmpi(computerName, appGeneral.computerName.webServer)
                appMode = 'webServer';
            else
                appMode = 'deployServer';                    
            end
    end

    dataStruct    = struct('group', 'COMPUTADOR',   'value', struct('Machine', appVersion.Machine, 'Mode', sprintf('%s - %s', executionMode, appMode)));
    dataStruct(2) = struct('group', appName,        'value', appVersion.(appName));
    dataStruct(3) = struct('group', 'RFDataHub',    'value', struct('releasedDate', RFDataHub_info.ReleaseDate, 'numberOfRows', height(RFDataHub), 'numberOfUniqueStations', numel(unique(RFDataHub.("Station")))));
    dataStruct(4) = struct('group', 'MATLAB',       'value', appVersion.Matlab);

    appInfo = sprintf(['<p style="font-size: 12px; text-align:justify;">O repositório das '   ...
                       'ferramentas desenvolvidas no Escritório de inovação da SFI pode ser ' ...
                       'acessado <a href="%s">aqui</a>.\n\n</p>%s'], appAnaliseLink.Sharepoint, textFormatGUI.struct2PrettyPrintList(dataStruct));   
end