function postCompile(projectName, rootCompiledVersions, matlabRuntimeCache)

    % Trata-se de script a ser executado posteriormente à compilação das
    % versões desktop e webapp de aplicativos construídos no MATLAB.

    % Release: MATLAB R2024a Update6
    % Data...: 20/03/2025
    
    arguments
        projectName          char {mustBeMember(projectName, {'appAnalise'})} = 'appAnalise'
        rootCompiledVersions char = 'D:\_Versões Compiladas dos Apps'
        matlabRuntimeCache   char = 'E:\MATLAB Runtime\MATLAB Runtime (Custom)\R2024a'
    end

    initFolder = fileparts(mfilename('fullpath'));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MAPEAMENTO DE PASTAS                                                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    applicationRootFolder = fullfile(fileparts(initFolder), 'src');
    cd(applicationRootFolder)
    
    applicationName       = class.Constants.appName;
    applicationRelease    = class.Constants.appRelease;
    applicationVersion    = class.Constants.appVersion;

    % No processo de compilação da versão desktop, usando o deploytools, o 
    % MATLAB cria as pastas "for_redistribution", "for_redistribution_files_only" 
    % e "for_testing", além do arquivo "PackagingLog.html". Por outro lado,
    % se a compilação for programaticamente realizada, usando "compile.m",
    % será criada apenas a pasta "application".
    desktopCompilerFolder = fullfile(initFolder, 'desktop');
    desktopCompilerNew    = fullfile(desktopCompilerFolder, 'application');

    % No processo de compilação da versão webapp, o MATLAB cria os arquivos
    % "includedSupportPackages.txt", "mccExcludedFiles.log", "monitorRNI.ctf" 
    % (no caso do monitorRNI), "PackagingLog.html", "requiredMCRProducts.txt" 
    % e "unresolvedSymbols.txt".
    webappCompilerFolder  = fullfile(fileparts(applicationRootFolder), 'deploy', 'webapp');

    % Pastas p/ as quais serão movidos os arquivos compilados que irão compor
    % as versões de distribuição dos apps:
    appCompiledVersions   = fullfile(rootCompiledVersions, projectName);
    desktopFinalFolder    = fullfile(appCompiledVersions, 'Desktop');
    webappFinalFolder     = fullfile(appCompiledVersions, 'Webapp');
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % VERSÃO DESKTOP                                                      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CONFIRMA SE A VERSÃO CUSTOMIZADA DO MATLAB RUNTIME CONTÉM TODOS OS 
    % MÓDULOS NECESSÁRIOS P/ CORRETA EXECUÇÃO DO APP.
    if isfolder(matlabRuntimeCache)
        fileContent  = strsplit(strtrim(fileread(fullfile(desktopCompilerNew, 'requiredMCRProducts.txt'))), '\t');
        mcrProducts  = cellfun(@(x) int64(str2double(x)), fileContent);
    
        cacheContent = dir(fullfile(matlabRuntimeCache, '*.zip'));
        for ii = 1:numel(cacheContent)
            cacheFileString  = char(extractBetween(cacheContent(ii).name, 'InstallAgent_', '.zip'));
            cacheFileProduts = compiler.internal.utils.hexString2RuntimeProducts(cacheFileString);
    
            if any(~ismember(mcrProducts, cacheFileProduts))
                warning('Necessário atualizar a versão customizada do MATLAB Runtime.')
            end
        end
    end

    % ATUALIZA BASES DE DADOS QUE SUPORTAM O APP, CASO APLICÁVEL.
    programDataFolder = fullfile(ccTools.fcn.OperationSystem('programData'), 'ANATEL', applicationName);
    databaseFile      = fullfile(programDataFolder, 'DataBase', 'RFDataHub.mat');
    if isfile(databaseFile)
        copyfile(databaseFile, fullfile(desktopCompilerNew, 'config', 'DataBase', 'RFDataHub.mat'), 'f');
    end

    % CRIA ARQUIVO DE INTEGRIDADE "appIntegrity.json", O QUAL SERÁ INSPECIONADO 
    % PELO SPLASHSCREEN.
    cd(desktopCompilerNew)
    
    fileName    = [applicationName '.exe'];
    codeRepo    = ['https://github.com/InovaFiscaliza/' projectName];
    customFiles = {};
    
    % Executable file hash
    [~, cmdout] = system(sprintf('certUtil -hashfile %s.exe SHA256', applicationName));
    cmdout = strsplit(cmdout, '\n');
    exeHash = cmdout{2};
    
    % Executable file size
    fileObj = dir(fileName);    
    exeSize = uint32(fileObj.bytes);
    
    % appIntegrity.json
    appIntegrity = struct('appName',     applicationName,       ...
                          'appRelease',  applicationRelease,    ...
                          'appVersion',  applicationVersion,    ...
                          'codeRepo',    codeRepo,      ...
                          'customFiles', {customFiles}, ...
                          'fileName',    fileName,      ...
                          'fileHash',    exeHash,       ...
                          'fileSize',    exeSize);
    
    writematrix(jsonencode(appIntegrity, 'PrettyPrint', true), fullfile(desktopCompilerNew, 'config', 'appIntegrity.json'), 'FileType', 'text', 'QuoteStrings', 'none')

    % CRIA ARQUIVO ZIPADO QUE POSSIBILITARÁ A ATUALIZAÇÃO DO APLICATIVO
    % POR MEIO DO SPLASHSCREEN.
    zipProcess(desktopCompilerNew, sprintf('%s_Matlab.zip', applicationName))

    % 6/7: ORGANIZA PASTA LOCAL QUE ARMAZENA VERSÕES COMPILADAS DO APLICATIVO.
    if isfolder(fullfile(desktopFinalFolder, 'application'))
        rmdir(fullfile(desktopFinalFolder, 'application'), 's')
    end
    
    delete(fullfile(appCompiledVersions, sprintf('%s.zip', applicationName)))
    delete(fullfile(appCompiledVersions, sprintf('%s_Matlab.zip', applicationName)))

    movefile(fullfile(desktopCompilerFolder, sprintf('%s_Matlab.zip', applicationName)), appCompiledVersions, 'f')
    movefile(desktopCompilerNew, fullfile(desktopFinalFolder, 'application'), 'f')
    zipProcess(desktopFinalFolder, sprintf('%s.zip', applicationName))    


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % VERSÃO WEBAPP                                                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isfolder(webappCompilerFolder)
        copyfile(webappCompilerFolder, webappFinalFolder, 'f')
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % EXCLUI ARQUIVOS NÃO MAIS NECESSÁRIOS                                %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    deleteTrash(desktopCompilerFolder)
    if isfolder(webappCompilerFolder)
        deleteTrash(webappCompilerFolder)
    end

    cd(initFolder)
end


%-------------------------------------------------------------------------%
function zipProcess(zipFolder, zipFileName)
    cd(zipFolder)

    zipObj = struct2table(dir);
    zipObj = zipObj.name(3:end)';
    
    zip(zipFileName, zipObj)
    movefile(zipFileName, fileparts(zipFolder), 'f');
end


%-------------------------------------------------------------------------%
function deleteTrash(trashFolder)
    cd(trashFolder)
    files2Delete = struct2table(dir);
    files2Delete = files2Delete.name(3:end)';

    cellfun(@(x) rmdir(x, 's'), files2Delete( isfolder(files2Delete)));
    cellfun(@(x) delete(x),     files2Delete(~isfolder(files2Delete)));
end