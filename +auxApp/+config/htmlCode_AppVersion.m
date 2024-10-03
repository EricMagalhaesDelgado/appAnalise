function htmlContent = htmlCode_AppVersion(appGeneral, executionMode)

    global RFDataHub
    global RFDataHub_info

    appName    = class.Constants.appName;
    appVersion = appGeneral.AppVersion;

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

    if ~isempty(appVersion.Python)
        dataStruct(end+1) = struct('group', 'PYTHON', 'value', appVersion.Python);
    end

    if ~isempty(appVersion.fiscaliza)
        dataStruct(end+1) = struct('group', 'FISCALIZA', 'value', appVersion.fiscaliza);
    end

    htmlContent = textFormatGUI.struct2PrettyPrintList(dataStruct);
end