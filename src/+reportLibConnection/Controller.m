classdef (Abstract) Controller

    properties (Constant)
        %-----------------------------------------------------------------%
        fileName   = 'reportLibConfig.cfg'
        docVersion = dictionary(["Preliminar", "Definitiva"], ["preview", "final"])
    end

    methods (Static)
        %-----------------------------------------------------------------%
        function [modelFileContent, projectFolder, programDataFolder] = Read(rootFolder)
            [projectFolder, ...
             programDataFolder]  = appUtil.Path(class.Constants.appName, rootFolder);
            fileName             = reportLibConnection.Controller.fileName;
        
            projectFilePath      = fullfile(projectFolder,     fileName);
            programDataFilePath  = fullfile(programDataFolder, fileName);
        
            try
                modelFileContent = jsondecode(fileread(programDataFilePath));
            catch
                modelFileContent = jsondecode(fileread(projectFilePath));
            end        
        end


        %-----------------------------------------------------------------%
        function [HTMLDocFullPath, CSVDocFullPath] = Run(app, webView)
            % A função Controller, da reportLib, espera os argumentos reportInfo 
            % e dataOverview.
            [modelFileContent, ...
             projectFolder,    ...
             programDataFolder] = reportLibConnection.Controller.Read(app.rootFolder);

            docIndex   = find(strcmp({modelFileContent.Name}, app.report_ModelName.Value), 1);
            docType    = modelFileContent(docIndex).DocumentType;
            docScript  = jsondecode(fileread(fullfile(programDataFolder, modelFileContent(docIndex).File)));            
            docVersion = reportLibConnection.Controller.docVersion(app.report_Version.Value);
            
            % reportInfo
            reportInfo = struct('App',      app,                                         ...
                                'Version',  fcn.envVersion(app.rootFolder, 'reportLib'), ...
                                'Path',     struct('rootFolder',     app.rootFolder,     ...
                                                   'appConnection',  projectFolder,      ...
                                                   'appDataFolder',  programDataFolder),     ...
                                'Model',    struct('Name',           app.report_ModelName.Value, ...
                                                   'DocumentType',   docType,                    ...
                                                   'Script',         docScript,                  ...
                                                   'Version',        docVersion),                ...
                                'Function', struct('var_Issue',      num2str(app.report_Issue.Value),   ...
                                                   'tableFcn1',      'reportLibConnection.reportTable_type1(analyzedData.InfoSet.reportTable, tableSettings)', ...
                                                   'tableFcn2',      'reportLibConnection.reportTable_type2(analyzedData.InfoSet.reportTable, tableSettings)'));
            
            % dataOverview (aceita recorrência, registra imagens e tabelas externas
            % no campo "HTML")
            dataOverview(1).ID      = app.report_EntityID.Value;
            dataOverview(1).InfoSet = struct('EntityName',  upper(app.report_Entity.Value),     ...
                                             'EntityID',    app.report_EntityID.Value,          ...
                                             'EntityType',  upper(app.report_EntityType.Value), ...
                                             'reportTable', app.listOfProducts);
            dataOverview(1).HTML    = [];
            
            % Documentos:
            switch docVersion
                case 'preview'; tempFullPath = tempname;
                case 'final';   tempFullPath = class.Constants.DefaultFileName(app.config_Folder_userPath.Value, 'Report', app.report_Issue.Value);
            end
            HTMLDocFullPath = [tempFullPath '.html'];
            JSONDocFullPath = [tempFullPath '.json'];
            MATDocFullPath  = [tempFullPath '.mat'];
            
            HTMLDocContent  = reportLib.Controller(reportInfo, dataOverview);
            writematrix(HTMLDocContent, HTMLDocFullPath, 'QuoteStrings', 'none', 'FileType', 'text')
            if webView                
                web(HTMLDocFullPath)
            end

            JSONDoc = '...';
            MATDoc  = '...';

            writematrix(JSONDoc, JSONDocFullPath, "Content", "text", "QuoteStrings", "none");
            save(MATDoc, MATDocFullPath, '-mat', '-nocompression');
        end
    end
end