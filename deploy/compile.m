function results = compile(prjFileName)

    % Ao compilar aplicativo construído no AppDesigner, usando o deploytool,
    % o MATLAB cria três pastas: 
    % • "for_testing"
    % • "for_redistribution_files_only"
    % • "for_redistribution"

    % Outras informações:
    % https://www.mathworks.com/help/compiler/files-generated-after-packaging-application-compiler.html

    % Simplifica-se esse processo, gerando apenas uma única pasta de saída
    % chamada "application".

    arguments
        prjFileName {mustBeFile} = 'desktop.prj'
    end

    %-------------------------------------------------------------%
    % PRÉ-COMPILAÇÃO
    %
    % Cria versões .M para cada um dos arquivos .MLAPP, possibilitando que
    % a figura do app principal (winAppAnalise.mlapp) seja um container para
    % os apps auxiliares.
    %-------------------------------------------------------------%
    initFolder   = fileparts(mfilename('fullpath'));
    logFile      = fullfile(initFolder, 'desktop', 'PackagingLog.txt');
    if isfile(logFile)
        delete(logFile)
    end
    diary(logFile)

    xmlProject   = readstruct(prjFileName, 'FileType', 'xml');
    appName      = char(xmlProject.configuration.param_appname);

    try
        prjInfo  = currentProject;

        if ~strcmp(prjInfo.Name, appName)
            error('UnexpectedProject')
        end
    catch
        openProject(fullfile(fileparts(initFolder), [appName '.prj']));
    end

    preCompile()


    %-------------------------------------------------------------%
    % COMPILAÇÃO
    %
    % Cria appAnalise.exe e os arquivos auxiliares.
    %-------------------------------------------------------------%
    deployFolder = fullfile(initFolder, 'desktop', 'application');
    if isfolder(deployFolder)
        rmdir(deployFolder, 's')
    end

    appIcon      = fullfile(initFolder, 'desktop_resources', 'icon_48.png');
    appVersion   = class.Constants.appVersion;
    appMainFile  = char(xmlProject.configuration.fileset_main.file);
    appResources = cellstr(xmlProject.configuration.fileset_resources.file);
    appPackages  = cellstr(xmlProject.configuration.fileset_package.file);

    % O "pwd" do MATLAB, ao executar o mcc, precisa ser a pasta onde está o
    % arquivo principal...
    cd(fileparts(appMainFile))

    % APPROACH 1
    % Abstração criada p/ deploytool
    compilerOpts = compiler.build.StandaloneApplicationOptions(appMainFile, ...
        'ExecutableIcon',    appIcon,      ...
        'ExecutableName',    appName,      ...
        'ExecutableVersion', appVersion,   ...
        'AdditionalFiles',   appResources, ...
        'Verbose',           true,         ...
        'OutputDir',         deployFolder);

    results = compiler.build.standaloneApplication(compilerOpts);
    cd(initFolder)


    %-------------------------------------------------------------%
    % PÓS-COMPILAÇÃO
    %
    % Copia arquivos para a pasta do usuário, além de criar vínculo entre o
    % appAnalise e o seu splashscreen (construído em C#, no Visual Studio).
    %-------------------------------------------------------------%
    for ii = 1:numel(appPackages)
        appPackage = appPackages{ii};

        if isfolder(appPackage)
            [~, folderName] = fileparts(appPackage);
            copyfile(appPackage, fullfile(deployFolder, folderName), 'f')
        else
            copyfile(appPackage, deployFolder, 'f')
        end
    end

    postCompile(appName)    
    diary off
end