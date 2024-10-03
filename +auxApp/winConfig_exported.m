classdef winConfig_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        GridLayout6                     matlab.ui.container.GridLayout
        jsBackDoor                      matlab.ui.control.HTML
        tool_FiscalizaButton            matlab.ui.control.Image
        tool_PythonButton               matlab.ui.control.Image
        tool_RFDataHubButton            matlab.ui.control.Image
        config_mainGrid                 matlab.ui.container.GridLayout
        GridLayout7                     matlab.ui.container.GridLayout
        graphics_Refresh                matlab.ui.control.Image
        Panel                           matlab.ui.container.Panel
        GridLayout5                     matlab.ui.container.GridLayout
        config_openAuxiliarAppAsDocked  matlab.ui.control.CheckBox
        imgResolution                   matlab.ui.control.DropDown
        imgResolutionLabel              matlab.ui.control.Label
        imgFormat                       matlab.ui.control.DropDown
        imgFormatLabel                  matlab.ui.control.Label
        gpuType                         matlab.ui.control.DropDown
        gpuTypeLabel                    matlab.ui.control.Label
        config_openAuxiliarApp2Debug    matlab.ui.control.CheckBox
        GRFICOLabel                     matlab.ui.control.Label
        misc_ElevationSourcePanel       matlab.ui.container.Panel
        misc_ElevationSourceGrid        matlab.ui.container.GridLayout
        misc_ElevationForceSearch       matlab.ui.control.CheckBox
        misc_ElevationNPoints           matlab.ui.control.DropDown
        misc_ElevationNPointsLabel      matlab.ui.control.Label
        misc_ElevationAPISource         matlab.ui.control.DropDown
        misc_ElevationAPISourceLabel    matlab.ui.control.Label
        ELEVAOLabel                     matlab.ui.control.Label
        GridLayout4                     matlab.ui.container.GridLayout
        mergeRefresh                    matlab.ui.control.Image
        mergePanel                      matlab.ui.container.Panel
        mergeGrid                       matlab.ui.container.GridLayout
        mergeGPSValue                   matlab.ui.control.Spinner
        mergeGPSLabel                   matlab.ui.control.Label
        mergeAntennaCheckbox            matlab.ui.control.CheckBox
        mergeDataTypeCheckbox           matlab.ui.control.CheckBox
        mergeLabel                      matlab.ui.control.Label
        mergePanelTitle                 matlab.ui.control.Label
        GridLayout2                     matlab.ui.container.GridLayout
        tool_RefreshButton              matlab.ui.control.Image
        Tab1_Panel                      matlab.ui.container.Panel
        Tab1_Grid                       matlab.ui.container.GridLayout
        VersionInfo                     matlab.ui.control.HTML
        config_SearchModeLabel_2        matlab.ui.control.Label
        config_Label                    matlab.ui.control.Label
        config_ButtonGroup              matlab.ui.container.ButtonGroup
        config_Option_Folder            matlab.ui.control.RadioButton
        config_Option_Fiscaliza         matlab.ui.control.RadioButton
        config_Option_Elevation         matlab.ui.control.RadioButton
        config_Option_Graphics          matlab.ui.control.RadioButton
        config_Option_File              matlab.ui.control.RadioButton
        config_Option_Search            matlab.ui.control.RadioButton
        config_Option3Grid              matlab.ui.container.GridLayout
        config_DefaultIssueValuesPanel  matlab.ui.container.Panel
        config_DefaultIssueValuesGrid   matlab.ui.container.GridLayout
        config_ServicoInspecao          matlab.ui.container.CheckBoxTree
        config_ServicoInspecaoLabel     matlab.ui.control.Label
        config_MotivoLAI                matlab.ui.container.CheckBoxTree
        config_MotivoLAILabel           matlab.ui.control.Label
        config_TipoPLAI                 matlab.ui.control.DropDown
        config_TipoPLAILabel            matlab.ui.control.Label
        config_GerarPLAI                matlab.ui.control.DropDown
        config_GerarPLAILabel           matlab.ui.control.Label
        config_CadastroSTEL             matlab.ui.control.DropDown
        config_CadastroSTELLabel        matlab.ui.control.Label
        config_DefaultIssueValuesLock   matlab.ui.control.Image
        config_DefaultIssueValuesLabel  matlab.ui.control.Label
        config_FiscalizaVersion         matlab.ui.container.ButtonGroup
        config_FiscalizaHM              matlab.ui.control.RadioButton
        config_FiscalizaPD              matlab.ui.control.RadioButton
        config_FiscalizaVersionLabel    matlab.ui.control.Label
        config_Option1Grid              matlab.ui.container.GridLayout
        config_FolderMapPanel           matlab.ui.container.Panel
        config_FolderMapGrid            matlab.ui.container.GridLayout
        config_Folder_userPathButton    matlab.ui.control.Image
        config_Folder_userPath          matlab.ui.control.DropDown
        config_Folder_userPathLabel     matlab.ui.control.Label
        config_Folder_pythonPathButton  matlab.ui.control.Image
        config_Folder_pythonPath        matlab.ui.control.EditField
        config_Folder_pythonPathLabel   matlab.ui.control.Label
        config_Folder_DataHubPOSTButton  matlab.ui.control.Image
        config_Folder_DataHubPOST       matlab.ui.control.EditField
        config_Folder_DataHubPOSTLabel  matlab.ui.control.Label
        config_Folder_DataHubGETButton  matlab.ui.control.Image
        config_Folder_DataHubGET        matlab.ui.control.EditField
        config_Folder_DataHubGETLabel   matlab.ui.control.Label
        config_FolderMapLabel           matlab.ui.control.Label
    end

    
    properties
        %-----------------------------------------------------------------%
        Container
        isDocked = false
        
        CallingApp
        General
        rootFolder

        % A função do timer é executada uma única vez após a renderização
        % da figura, lendo arquivos de configuração, iniciando modo de operação
        % paralelo etc. A ideia é deixar o MATLAB focar apenas na criação dos 
        % componentes essenciais da GUI (especificados em "createComponents"), 
        % mostrando a GUI para o usuário o mais rápido possível.
        timerObj

        % Janela de progresso já criada no DOM. Dessa forma, controla-se 
        % apenas a sua visibilidade - e tornando desnecessário criá-la a
        % cada chamada (usando uiprogressdlg, por exemplo).
        progressDialog

        stableVersion
    end


    methods
        %-----------------------------------------------------------------%
        function undockingApp(app)
            % Executa operacões que não são realizadas quando um app está
            % em modo DOCK.
            % (a) Cria figura, configurando o seu tamanho mínimo.
            [xPosition, ...
             yPosition]  = appUtil.winXYPosition(1244, 660);
            app.UIFigure = uifigure('Name',               'appAnalise',                   ...
                                    'Icon',               'icon_48.png',                  ...
                                    'Position',           [xPosition yPosition 1244 660], ...
                                    'AutoResizeChildren', 'off',                          ...
                                    'CloseRequestFcn',    createCallbackFcn(app, @closeFcn, true));
            appUtil.winMinSize(app.UIFigure, class.Constants.windowMinSize)

            % (b) Move os componentes do container antigo para o novo, ajustando
            %     o modo de visualização da tabela.
            app.Container.Children.Parent = app.UIFigure;
            drawnow 

            if ~isempty(app.UITable.Selection)
                scroll(app.UITable, 'Row', app.UITable.Selection(1))
            end
            
            % (c) Reinicia as propriedades "Container" e "isDocked".
            app.Container = app.UIFigure;
            app.isDocked  = false;

            % (d) Customiza aspectos estéticos da janela.
            jsBackDoor_Customizations(app)
        end
    end
    

    methods (Access = private)
        %-----------------------------------------------------------------%
        function jsBackDoor_Initialization(app)
            app.jsBackDoor.HTMLSource = ccTools.fcn.jsBackDoorHTMLSource();
        end

        %-----------------------------------------------------------------%
        function jsBackDoor_Customizations(app)
            if app.isDocked
                app.progressDialog = app.CallingApp.progressDialog;
            else
                app.progressDialog = ccTools.ProgressDialog(app.jsBackDoor);
            end
        end

        %-----------------------------------------------------------------%
        function startup_timerCreation(app)            
            % A criação desse timer tem como objetivo garantir uma renderização 
            % mais rápida dos componentes principais da GUI, possibilitando a 
            % visualização da sua tela inicialpelo usuário. Trata-se de aspecto 
            % essencial quando o app é compilado como webapp.

            app.timerObj = timer("ExecutionMode", "fixedSpacing", ...
                                 "StartDelay",    1.5,            ...
                                 "Period",        .1,             ...
                                 "TimerFcn",      @(~,~)app.startup_timerFcn);
            start(app.timerObj)
        end

        %-----------------------------------------------------------------%
        function startup_timerFcn(app)
            if ccTools.fcn.UIFigureRenderStatus(app.UIFigure)
                stop(app.timerObj)
                delete(app.timerObj)                
                startup_Controller(app)
            end
        end

        %-----------------------------------------------------------------%
        function startup_Controller(app)
            % Customiza as aspectos estéticos de alguns dos componentes da GUI 
            % (diretamente em JS).
            jsBackDoor_Customizations(app)

            % Define tamanho mínimo do app (não aplicável à versão webapp).
            if ~strcmp(app.CallingApp.executionMode, 'webApp') && ~app.isDocked
                appUtil.winMinSize(app.UIFigure, class.Constants.windowMinSize)
            end

            app.progressDialog.Visible = 'visible';

            checkPythonVersion(app)
            
            initialValues_General(app)
            initialValues_File(app)
            initialValues_Graphics(app)
            initialValues_Elevation(app)
            initialValues_APIFiscaliza(app)
            initialValues_Folders(app)

            app.progressDialog.Visible = 'hidden';
        end

        %-----------------------------------------------------------------%
        function checkPythonVersion(app)
            if isempty(app.CallingApp.General.AppVersion.fiscaliza)
                app.CallingApp.General.AppVersion = fcn.envVersion(app.rootFolder, 'full+Python');
            end
            app.General = app.CallingApp.General;
        end

        %-----------------------------------------------------------------%
        function initialValues_General(app)
            % Versão
            htmlContent = auxApp.config.htmlCode_AppVersion(app.General, app.CallingApp.executionMode);
            app.VersionInfo.HTMLSource = htmlContent;
        end

        %-----------------------------------------------------------------%
        function initialValues_File(app)
            % Mesclagem de fluxos espectrais
            switch app.General.Merge.DataType
                case 'keep';   app.mergeDataTypeCheckbox.Value = 0;
                case 'remove'; app.mergeDataTypeCheckbox.Value = 1;
            end

            switch app.General.Merge.Antenna
                case 'keep';   app.mergeAntennaCheckbox.Value = 0;
                case 'remove'; app.mergeAntennaCheckbox.Value = 1;
            end

            app.mergeGPSValue.Value = app.General.Merge.Distance;
        end

        %-----------------------------------------------------------------%
        function initialValues_Graphics(app)
            % Imagem relatório
            app.imgFormat.Value     = app.General.Image.Format;
            app.imgResolution.Value = string(app.General.Image.Resolution);

            % Renderizador
            graphRender = opengl('data');
            switch graphRender.HardwareSupportLevel
                case 'basic'; graphRenderSupport = 'hardwarebasic';
                case 'full';  graphRenderSupport = 'hardware';
                case 'none';  graphRenderSupport = 'software';
                otherwise;    graphRenderSupport = graphRender.HardwareSupportLevel; % "driverissue"
            end

            if ~ismember(graphRenderSupport, app.gpuType.Items)
                app.gpuType.Items{end+1} = graphRenderSupport;
            end

            app.gpuType.Value = graphRenderSupport;

            % Modo de operação
            app.config_openAuxiliarAppAsDocked.Value = app.General.operationMode.Dock;
            app.config_openAuxiliarApp2Debug.Value   = app.General.operationMode.Debug;
        end

        %-----------------------------------------------------------------%
        function initialValues_Elevation(app)
            app.misc_ElevationNPoints.Value     = num2str(app.General.Elevation.Points);
            app.misc_ElevationForceSearch.Value = app.General.Elevation.ForceSearch;
            app.misc_ElevationAPISource.Value   = app.General.Elevation.Server;
        end

        %-----------------------------------------------------------------%
        function initialValues_APIFiscaliza(app)
            switch app.General.fiscaliza.systemVersion
                case 'PROD'
                    app.config_FiscalizaPD.Value = 1;
                case 'HOM'
                    app.config_FiscalizaHM.Value = 1;
            end
            fiscalizaLibConnection.config_DefaultValues(app)
        end

        %-----------------------------------------------------------------%
        function initialValues_Folders(app)
            % userPath
            if strcmp(app.CallingApp.executionMode, 'webApp')
                app.config_Option_Folder.Enable = 0;
            else
                userPaths = appUtil.UserPaths(app.General.fileFolder.userPath);
                set(app.config_Folder_userPath, 'Items', userPaths, 'Value', app.General.fileFolder.userPath)
            end

            % DataHub
            DataHub_GET  = app.General.fileFolder.DataHub_GET;
            DataHub_POST = app.General.fileFolder.DataHub_POST;
            if isfolder(DataHub_GET)
                app.config_Folder_DataHubGET.Value  = DataHub_GET;
            end

            if isfolder(DataHub_POST)
                app.config_Folder_DataHubPOST.Value = DataHub_POST;
            end

            % Python
            pythonPath = app.General.fileFolder.pythonPath;
            if isfile(pythonPath)
                app.config_Folder_pythonPath.Value = pythonPath;
            else
                pyEnv = pyenv;
                app.config_Folder_pythonPath.Value = pyEnv.Executable;
            end
        end

        %-----------------------------------------------------------------%
        function SaveFile(app)
            % Salva uma nova versão do arquivo "GeneralSettings.json".
            appUtil.generalSettingsSave(class.Constants.appName, app.rootFolder, app.CallingApp.General, {'AppVersion', 'Models', 'Report'})
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            
            % A razão de ser deste app é possibilitar visualização/edição 
            % de algumas das informações do arquivo "GeneralSettings.json",
            % além de possibilitar o mapeamento do PYTHON, a atualização da
            % lib FISCALIZA e da ETL RFDATAHUB.

            app.CallingApp = mainapp;
            app.rootFolder = app.CallingApp.rootFolder;

            jsBackDoor_Initialization(app)
            config_ButtonGroupSelectionChanged(app)

            if app.isDocked
                drawnow
                startup_Controller(app)
            else
                appUtil.winPosition(app.UIFigure)
                startup_timerCreation(app)
            end
            
        end

        % Close request function: UIFigure
        function closeFcn(app, event)
            
            appBackDoor(app.CallingApp, app, 'closeFcn')
            delete(app)
            
        end

        % Selection changed function: config_ButtonGroup
        function config_ButtonGroupSelectionChanged(app, event)
            
            selectedButton = app.config_ButtonGroup.SelectedObject;
            switch selectedButton
                case app.config_Option_Search;    app.config_mainGrid.ColumnWidth(2:end) = {'1x',0,0,0,0,0};
                case app.config_Option_File;      app.config_mainGrid.ColumnWidth(2:end) = {0,'1x',0,0,0,0};
                case app.config_Option_Graphics;  app.config_mainGrid.ColumnWidth(2:end) = {0,0,'1x',0,0,0};
                case app.config_Option_Elevation; app.config_mainGrid.ColumnWidth(2:end) = {0,0,0,'1x',0,0};
                case app.config_Option_Fiscaliza; app.config_mainGrid.ColumnWidth(2:end) = {0,0,0,0,'1x',0};
                case app.config_Option_Folder;    app.config_mainGrid.ColumnWidth(2:end) = {0,0,0,0,0,'1x'};
            end
            
        end

        % Image clicked function: tool_RefreshButton
        function tool_RefreshButtonPushed(app, event)
            
            app.progressDialog.Visible = 'visible';

            try
                appName = class.Constants.appName;
                presentVersion = struct(appName,     app.General.AppVersion.(appName).version, ...
                                        'fiscaliza', app.General.AppVersion.fiscaliza,         ...
                                        'RFDataHub', app.General.AppVersion.RFDataHub); 
                
                [versionLink, RFDataHubLink] = fcn.PublicLinks(app.rootFolder);
                generalVersions  = webread(versionLink,           weboptions("ContentType", "json"));
                rfdatahubVersion = webread(RFDataHubLink.Release, weboptions("ContentType", "json"));

                app.stableVersion = struct(appName,     generalVersions.(appName).Version, ...
                                           'fiscaliza', generalVersions.fiscaliza.Version, ...
                                           'RFDataHub', rfdatahubVersion.rfdatahub);
                
                if isequal(presentVersion, app.stableVersion)
                    msgWarning = 'O appAnalise e os seus módulos - fiscaliza e RFDataHub - estão atualizados.';
                    
                else
                    StableModule    = {};
                    nonStableModule = {};
                    if strcmp(presentVersion.(appName), app.stableVersion.(appName));   StableModule(end+1)    = {'appAnalise'};
                    else;                                                               nonStableModule(end+1) = {'appAnalise'};
                    end

                    if strcmp(presentVersion.fiscaliza,  app.stableVersion.fiscaliza);  StableModule(end+1)    = {'fiscaliza'};
                    else;                                                               nonStableModule(end+1) = {'fiscaliza'}; app.tool_FiscalizaButton.Enable = 1;
                    end

                    if isequal(presentVersion.RFDataHub, app.stableVersion.RFDataHub);  StableModule(end+1)    = {'RFDataHub'};
                    else;                                                               nonStableModule(end+1) = {'RFDataHub'}; app.tool_RFDataHubButton.Enable = 1;
                    end
                    
                    if ~isempty(StableModule) && ~isempty(nonStableModule); msgWarning = sprintf('Módulo(s) atualizado(s):\n• %s\n\nMódulo(s) cuja(s) versão(ões) difere(m) da(s) indicada(s) no arquivo de versões:\n• %s', strjoin(StableModule, ', '), strjoin(nonStableModule, ', '));
                    else;                                                   msgWarning = sprintf('Módulo(s) cuja(s) versão(ões) difere(m) da(s) indicada(s) no arquivo de versões:\n• %s', strjoin(nonStableModule, ', '));
                    end

                    msgWarning = sprintf('Arquivo de versões: %s\n\n%s', jsonencode(app.stableVersion), msgWarning);
                end
                
            catch ME
                msgWarning = ME.message;                
            end

            app.progressDialog.Visible = 'hidden';
            appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);            

        end

        % Image clicked function: tool_PythonButton
        function tool_PythonButtonPushed(app, event)
            
            Python = pyenv;
            
            [fileName, filePath] = uigetfile({'python*.exe', 'python*.exe'}, '', Python.Executable);
            figure(app.UIFigure)

            if isequal(fileName, 0)
                return
            end

            app.progressDialog.Visible = 'visible';
            
            try
                pyPath = fullfile(filePath, fileName);
                pyenv('Version', pyPath);

                app.CallingApp.General.AppVersion.fiscaliza = [];
                checkPythonVersion(app)
                initialValues_General(app)

                SaveFile(app)

            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', ME.message);
            end

            app.progressDialog.Visible = 'hidden';

        end

        % Image clicked function: tool_FiscalizaButton
        function tool_FiscalizaButtonPushed(app, event)
            
            if strcmp(app.CallingApp.General.AppVersion.fiscaliza, app.stableVersion.fiscaliza)
                app.tool_FiscalizaButton.Enable = 0;
                appUtil.modalWindow(app.UIFigure, 'warning', 'Módulo fiscaliza já atualizado!');
                return
            end

            app.progressDialog.Visible = 'visible';

            try
                Python = pyenv;
                system(sprintf('"%s" %s', fullfile(Python.Home, 'Scripts', 'pip'), sprintf('install fiscaliza==%s', app.stableVersion.fiscaliza)));

                app.CallingApp.General.AppVersion.fiscaliza = app.stableVersion.fiscaliza;
                app.tool_FiscalizaButton.Enable = 0;

                Layout(app)

            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', ME.message);
            end

            app.progressDialog.Visible = 'hidden';

        end

        % Image clicked function: tool_RFDataHubButton
        function tool_RFDataHubButtonPushed(app, event)
            
            if strcmp(app.CallingApp.General.AppVersion.RFDataHub,  app.stableVersion.RFDataHub)
                app.tool_RFDataHubButton.Enable = 0;
                appUtil.modalWindow(app.UIFigure, 'warning', 'Módulo RFDataHub já atualizado!');
                return
            end

            d = uiprogressdlg(app.UIFigure, 'Indeterminate', 'on', 'Interpreter', 'html', 'Message', '<font style="font-size:12;">Em andamento... esse processo pode demorar alguns minutos!</font>');
            try
                [~, RFDataHubLink] = fcn.PublicLinks(app.rootFolder);
                websave(fullfile(app.rootFolder, 'Temp', 'estacoes.parquet.gzip'), RFDataHubLink.Table);
                websave(fullfile(app.rootFolder, 'Temp', 'log.parquet.gzip'),      RFDataHubLink.Log);
                websave(fullfile(app.rootFolder, 'Temp', 'Release.json'),          RFDataHubLink.Release);

                if isfile(fullfile(app.rootFolder, 'DataBase', 'RFDataHub_old.mat'))
                    delete(fullfile(app.rootFolder, 'DataBase', 'RFDataHub_old.mat'))
                end

                while true
                    status = system(sprintf('rename "%s" "%s"', fullfile(app.rootFolder, 'DataBase', 'RFDataHub.mat'), 'RFDataHub_old.mat'));
                    if ~status
                        break
                    end
                    pause(.1)
                end

                clear global RFDataHub
                clear global RFDataHubLog
                clear global RFDataHub_info
                class.RFDataHub.read(app.rootFolder)
                
                global RFDataHub_info
                app.CallingApp.General.AppVersion.RFDataHub = RFDataHub_info;
                app.tool_RFDataHubButton.Enable = 0;

                Layout(app)
                
            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', ME.message);
            end
            delete(d)

        end

        % Callback function: mergeAntennaCheckbox, mergeDataTypeCheckbox, 
        % ...and 2 other components
        function File_ParameterValueChanged(app, event)
            
            switch event.Source
                %---------------------------------------------------------%
                case {app.mergeDataTypeCheckbox, app.mergeAntennaCheckbox, app.mergeGPSValue}                    
                    switch app.mergeDataTypeCheckbox.Value
                        case 0; DataTypeStatus = 'keep';
                        case 1; DataTypeStatus = 'remove';
                    end
                    
                    switch app.mergeAntennaCheckbox.Value
                        case 0; AntennaStatus  = 'keep';
                        case 1; AntennaStatus  = 'remove';
                    end
                                
                    app.CallingApp.General.Merge.DataType = DataTypeStatus;
                    app.CallingApp.General.Merge.Antenna  = AntennaStatus;
                    app.CallingApp.General.Merge.Distance = app.mergeGPSValue.Value;

                %---------------------------------------------------------%
                case app.mergeRefresh
                    app.CallingApp.General.Merge = struct('DataType', 'keep', ...
                                                          'Antenna',  'keep',  ...
                                                          'Distance', 100);
            end
            
            Layout(app)
            SaveFile(app)

        end

        % Callback function: config_openAuxiliarApp2Debug, 
        % ...and 5 other components
        function Graphics_ParameterValueChanged(app, event)
            
            switch event.Source
                case app.gpuType
                    if ismember(app.gpuType.Value, {'software', 'hardware', 'hardwarebasic'})
                        eval(sprintf('opengl %s', app.gpuType.Value))

                        graphRender = opengl('data');
                        
                        app.CallingApp.General.openGL = app.gpuType.Value;
                        app.CallingApp.General.AppVersion.OpenGL = rmfield(graphRender, {'MaxTextureSize', 'Visual', 'SupportsGraphicsSmoothing', 'SupportsDepthPeelTransparency', 'SupportsAlignVertexCenters', 'Extensions', 'MaxFrameBufferSize'});
                    end

                case {app.imgFormat, app.imgResolution}
                    app.CallingApp.General.Image = struct('Format', app.imgFormat.Value, 'Resolution', str2double(app.imgResolution.Value));

                case app.config_openAuxiliarAppAsDocked
                    app.CallingApp.General.operationMode.Dock = app.config_openAuxiliarAppAsDocked.Value;

                case app.config_openAuxiliarApp2Debug
                    app.CallingApp.General.operationMode.Debug = app.config_openAuxiliarApp2Debug.Value;

                case app.graphics_Refresh
                    app.CallingApp.General.Image = struct('Format', 'Resolution', 120);
                    app.Callingapp.General.operationMode.Dock = true;
                    app.Callingapp.General.operationMode.Debug = false;
            end
            
            Layout(app)
            SaveFile(app)

        end

        % Value changed function: misc_ElevationAPISource
        function misc_ElevationAPISourceValueChanged(app, event)

            app.CallingApp.General.Elevation = struct('Points',      app.misc_ElevationNPoints.Value,     ...
                                                      'ForceSearch', app.misc_ElevationForceSearch.Value, ...
                                                      'Server',      app.misc_ElevationAPISource>Value);
            
            Layout(app)
            SaveFile(app)
            
        end

        % Selection changed function: config_FiscalizaVersion
        function config_FiscalizaVersionSelectionChanged(app, event)
            selectedButton = app.config_FiscalizaVersion.SelectedObject;
            
        end

        % Image clicked function: config_Folder_DataHubGETButton, 
        % ...and 3 other components
        function config_Folder_DataHubGETButtonImageClicked(app, event)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app, Container)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            if isempty(Container)
                app.UIFigure = uifigure('Visible', 'off');
                app.UIFigure.AutoResizeChildren = 'off';
                app.UIFigure.Position = [100 100 1244 660];
                app.UIFigure.Name = 'appAnalise';
                app.UIFigure.Icon = 'icon_48.png';
                app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @closeFcn, true);

                app.Container = app.UIFigure;

            else
                if ~isempty(Container.Children)
                    delete(Container.Children)
                end

                app.UIFigure  = ancestor(Container, 'figure');
                app.Container = Container;
                app.isDocked  = true;
            end

            % Create GridLayout
            app.GridLayout = uigridlayout(app.Container);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x', 34};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create config_mainGrid
            app.config_mainGrid = uigridlayout(app.GridLayout);
            app.config_mainGrid.ColumnWidth = {320, '1x', 0, 0, 0, 0, 0};
            app.config_mainGrid.RowHeight = {22, '1x'};
            app.config_mainGrid.RowSpacing = 5;
            app.config_mainGrid.Padding = [5 5 5 5];
            app.config_mainGrid.Layout.Row = 1;
            app.config_mainGrid.Layout.Column = 1;
            app.config_mainGrid.BackgroundColor = [1 1 1];

            % Create config_Option1Grid
            app.config_Option1Grid = uigridlayout(app.config_mainGrid);
            app.config_Option1Grid.ColumnWidth = {'1x'};
            app.config_Option1Grid.RowHeight = {22, 5, '1x', 1};
            app.config_Option1Grid.RowSpacing = 0;
            app.config_Option1Grid.Padding = [0 0 0 0];
            app.config_Option1Grid.Layout.Row = [1 2];
            app.config_Option1Grid.Layout.Column = 7;
            app.config_Option1Grid.BackgroundColor = [1 1 1];

            % Create config_FolderMapLabel
            app.config_FolderMapLabel = uilabel(app.config_Option1Grid);
            app.config_FolderMapLabel.VerticalAlignment = 'bottom';
            app.config_FolderMapLabel.FontSize = 10;
            app.config_FolderMapLabel.Layout.Row = 1;
            app.config_FolderMapLabel.Layout.Column = 1;
            app.config_FolderMapLabel.Text = 'MAPEAMENTO DE PASTAS';

            % Create config_FolderMapPanel
            app.config_FolderMapPanel = uipanel(app.config_Option1Grid);
            app.config_FolderMapPanel.AutoResizeChildren = 'off';
            app.config_FolderMapPanel.Layout.Row = 3;
            app.config_FolderMapPanel.Layout.Column = 1;

            % Create config_FolderMapGrid
            app.config_FolderMapGrid = uigridlayout(app.config_FolderMapPanel);
            app.config_FolderMapGrid.ColumnWidth = {'1x', 20};
            app.config_FolderMapGrid.RowHeight = {17, 22, 17, 22, 17, 22, 17, 22, '1x', '1x'};
            app.config_FolderMapGrid.ColumnSpacing = 5;
            app.config_FolderMapGrid.RowSpacing = 5;
            app.config_FolderMapGrid.BackgroundColor = [1 1 1];

            % Create config_Folder_DataHubGETLabel
            app.config_Folder_DataHubGETLabel = uilabel(app.config_FolderMapGrid);
            app.config_Folder_DataHubGETLabel.VerticalAlignment = 'bottom';
            app.config_Folder_DataHubGETLabel.FontSize = 10;
            app.config_Folder_DataHubGETLabel.Layout.Row = 1;
            app.config_Folder_DataHubGETLabel.Layout.Column = 1;
            app.config_Folder_DataHubGETLabel.Text = 'DataHub - GET:';

            % Create config_Folder_DataHubGET
            app.config_Folder_DataHubGET = uieditfield(app.config_FolderMapGrid, 'text');
            app.config_Folder_DataHubGET.Editable = 'off';
            app.config_Folder_DataHubGET.FontSize = 11;
            app.config_Folder_DataHubGET.Layout.Row = 2;
            app.config_Folder_DataHubGET.Layout.Column = 1;

            % Create config_Folder_DataHubGETButton
            app.config_Folder_DataHubGETButton = uiimage(app.config_FolderMapGrid);
            app.config_Folder_DataHubGETButton.ImageClickedFcn = createCallbackFcn(app, @config_Folder_DataHubGETButtonImageClicked, true);
            app.config_Folder_DataHubGETButton.Tag = 'DataHub_GET';
            app.config_Folder_DataHubGETButton.Layout.Row = 2;
            app.config_Folder_DataHubGETButton.Layout.Column = 2;
            app.config_Folder_DataHubGETButton.ImageSource = 'OpenFile_36x36.png';

            % Create config_Folder_DataHubPOSTLabel
            app.config_Folder_DataHubPOSTLabel = uilabel(app.config_FolderMapGrid);
            app.config_Folder_DataHubPOSTLabel.VerticalAlignment = 'bottom';
            app.config_Folder_DataHubPOSTLabel.FontSize = 10;
            app.config_Folder_DataHubPOSTLabel.Layout.Row = 3;
            app.config_Folder_DataHubPOSTLabel.Layout.Column = 1;
            app.config_Folder_DataHubPOSTLabel.Text = 'DataHub - POST:';

            % Create config_Folder_DataHubPOST
            app.config_Folder_DataHubPOST = uieditfield(app.config_FolderMapGrid, 'text');
            app.config_Folder_DataHubPOST.Editable = 'off';
            app.config_Folder_DataHubPOST.FontSize = 11;
            app.config_Folder_DataHubPOST.Layout.Row = 4;
            app.config_Folder_DataHubPOST.Layout.Column = 1;

            % Create config_Folder_DataHubPOSTButton
            app.config_Folder_DataHubPOSTButton = uiimage(app.config_FolderMapGrid);
            app.config_Folder_DataHubPOSTButton.ImageClickedFcn = createCallbackFcn(app, @config_Folder_DataHubGETButtonImageClicked, true);
            app.config_Folder_DataHubPOSTButton.Tag = 'DataHub_POST';
            app.config_Folder_DataHubPOSTButton.Layout.Row = 4;
            app.config_Folder_DataHubPOSTButton.Layout.Column = 2;
            app.config_Folder_DataHubPOSTButton.ImageSource = 'OpenFile_36x36.png';

            % Create config_Folder_pythonPathLabel
            app.config_Folder_pythonPathLabel = uilabel(app.config_FolderMapGrid);
            app.config_Folder_pythonPathLabel.VerticalAlignment = 'bottom';
            app.config_Folder_pythonPathLabel.FontSize = 10;
            app.config_Folder_pythonPathLabel.Layout.Row = 5;
            app.config_Folder_pythonPathLabel.Layout.Column = 1;
            app.config_Folder_pythonPathLabel.Text = 'Pasta do ambiente virtual Python (lib fiscaliza):';

            % Create config_Folder_pythonPath
            app.config_Folder_pythonPath = uieditfield(app.config_FolderMapGrid, 'text');
            app.config_Folder_pythonPath.Editable = 'off';
            app.config_Folder_pythonPath.FontSize = 11;
            app.config_Folder_pythonPath.Layout.Row = 6;
            app.config_Folder_pythonPath.Layout.Column = 1;

            % Create config_Folder_pythonPathButton
            app.config_Folder_pythonPathButton = uiimage(app.config_FolderMapGrid);
            app.config_Folder_pythonPathButton.ImageClickedFcn = createCallbackFcn(app, @config_Folder_DataHubGETButtonImageClicked, true);
            app.config_Folder_pythonPathButton.Tag = 'pythonPath';
            app.config_Folder_pythonPathButton.Layout.Row = 6;
            app.config_Folder_pythonPathButton.Layout.Column = 2;
            app.config_Folder_pythonPathButton.ImageSource = 'OpenFile_36x36.png';

            % Create config_Folder_userPathLabel
            app.config_Folder_userPathLabel = uilabel(app.config_FolderMapGrid);
            app.config_Folder_userPathLabel.VerticalAlignment = 'bottom';
            app.config_Folder_userPathLabel.FontSize = 10;
            app.config_Folder_userPathLabel.Layout.Row = 7;
            app.config_Folder_userPathLabel.Layout.Column = 1;
            app.config_Folder_userPathLabel.Text = 'Pasta do usuário:';

            % Create config_Folder_userPath
            app.config_Folder_userPath = uidropdown(app.config_FolderMapGrid);
            app.config_Folder_userPath.Items = {''};
            app.config_Folder_userPath.FontSize = 11;
            app.config_Folder_userPath.BackgroundColor = [1 1 1];
            app.config_Folder_userPath.Layout.Row = 8;
            app.config_Folder_userPath.Layout.Column = 1;
            app.config_Folder_userPath.Value = '';

            % Create config_Folder_userPathButton
            app.config_Folder_userPathButton = uiimage(app.config_FolderMapGrid);
            app.config_Folder_userPathButton.ImageClickedFcn = createCallbackFcn(app, @config_Folder_DataHubGETButtonImageClicked, true);
            app.config_Folder_userPathButton.Tag = 'userPath';
            app.config_Folder_userPathButton.Layout.Row = 8;
            app.config_Folder_userPathButton.Layout.Column = 2;
            app.config_Folder_userPathButton.ImageSource = 'OpenFile_36x36.png';

            % Create config_Option3Grid
            app.config_Option3Grid = uigridlayout(app.config_mainGrid);
            app.config_Option3Grid.ColumnWidth = {'1x', 20};
            app.config_Option3Grid.RowHeight = {22, 5, 68, 15, 12, 5, '1x', 1};
            app.config_Option3Grid.RowSpacing = 0;
            app.config_Option3Grid.Padding = [0 0 0 0];
            app.config_Option3Grid.Layout.Row = [1 2];
            app.config_Option3Grid.Layout.Column = 6;
            app.config_Option3Grid.BackgroundColor = [1 1 1];

            % Create config_FiscalizaVersionLabel
            app.config_FiscalizaVersionLabel = uilabel(app.config_Option3Grid);
            app.config_FiscalizaVersionLabel.VerticalAlignment = 'bottom';
            app.config_FiscalizaVersionLabel.FontSize = 10;
            app.config_FiscalizaVersionLabel.Layout.Row = 1;
            app.config_FiscalizaVersionLabel.Layout.Column = 1;
            app.config_FiscalizaVersionLabel.Text = 'API FISCALIZA';

            % Create config_FiscalizaVersion
            app.config_FiscalizaVersion = uibuttongroup(app.config_Option3Grid);
            app.config_FiscalizaVersion.SelectionChangedFcn = createCallbackFcn(app, @config_FiscalizaVersionSelectionChanged, true);
            app.config_FiscalizaVersion.BackgroundColor = [1 1 1];
            app.config_FiscalizaVersion.Layout.Row = 3;
            app.config_FiscalizaVersion.Layout.Column = [1 2];

            % Create config_FiscalizaPD
            app.config_FiscalizaPD = uiradiobutton(app.config_FiscalizaVersion);
            app.config_FiscalizaPD.Text = 'FISCALIZA PRODUÇÃO';
            app.config_FiscalizaPD.FontSize = 11;
            app.config_FiscalizaPD.Position = [10 36 146 22];

            % Create config_FiscalizaHM
            app.config_FiscalizaHM = uiradiobutton(app.config_FiscalizaVersion);
            app.config_FiscalizaHM.Text = 'FISCALIZA <font style="color: red;">HOMOLOGAÇÃO</font> (versão destinada a testes)';
            app.config_FiscalizaHM.FontSize = 11;
            app.config_FiscalizaHM.Interpreter = 'html';
            app.config_FiscalizaHM.Position = [10 10 310 22];
            app.config_FiscalizaHM.Value = true;

            % Create config_DefaultIssueValuesLabel
            app.config_DefaultIssueValuesLabel = uilabel(app.config_Option3Grid);
            app.config_DefaultIssueValuesLabel.VerticalAlignment = 'bottom';
            app.config_DefaultIssueValuesLabel.FontSize = 10;
            app.config_DefaultIssueValuesLabel.Layout.Row = [4 5];
            app.config_DefaultIssueValuesLabel.Layout.Column = 1;
            app.config_DefaultIssueValuesLabel.Text = 'VALORES PADRÕES DE CAMPOS DA INSPEÇÃO';

            % Create config_DefaultIssueValuesLock
            app.config_DefaultIssueValuesLock = uiimage(app.config_Option3Grid);
            app.config_DefaultIssueValuesLock.Layout.Row = [5 6];
            app.config_DefaultIssueValuesLock.Layout.Column = 2;
            app.config_DefaultIssueValuesLock.ImageSource = 'lockClose_18Gray.png';

            % Create config_DefaultIssueValuesPanel
            app.config_DefaultIssueValuesPanel = uipanel(app.config_Option3Grid);
            app.config_DefaultIssueValuesPanel.Layout.Row = 7;
            app.config_DefaultIssueValuesPanel.Layout.Column = [1 2];

            % Create config_DefaultIssueValuesGrid
            app.config_DefaultIssueValuesGrid = uigridlayout(app.config_DefaultIssueValuesPanel);
            app.config_DefaultIssueValuesGrid.ColumnWidth = {150, '1x'};
            app.config_DefaultIssueValuesGrid.RowHeight = {17, 22, 17, 22, 17, '1x', 17, '1x'};
            app.config_DefaultIssueValuesGrid.RowSpacing = 5;
            app.config_DefaultIssueValuesGrid.BackgroundColor = [1 1 1];

            % Create config_CadastroSTELLabel
            app.config_CadastroSTELLabel = uilabel(app.config_DefaultIssueValuesGrid);
            app.config_CadastroSTELLabel.VerticalAlignment = 'bottom';
            app.config_CadastroSTELLabel.FontSize = 10;
            app.config_CadastroSTELLabel.Layout.Row = 1;
            app.config_CadastroSTELLabel.Layout.Column = [1 2];
            app.config_CadastroSTELLabel.Text = 'Entidade com cadastro STEL?';

            % Create config_CadastroSTEL
            app.config_CadastroSTEL = uidropdown(app.config_DefaultIssueValuesGrid);
            app.config_CadastroSTEL.Items = {};
            app.config_CadastroSTEL.Enable = 'off';
            app.config_CadastroSTEL.FontSize = 11;
            app.config_CadastroSTEL.BackgroundColor = [1 1 1];
            app.config_CadastroSTEL.Layout.Row = 2;
            app.config_CadastroSTEL.Layout.Column = 1;
            app.config_CadastroSTEL.Value = {};

            % Create config_GerarPLAILabel
            app.config_GerarPLAILabel = uilabel(app.config_DefaultIssueValuesGrid);
            app.config_GerarPLAILabel.VerticalAlignment = 'bottom';
            app.config_GerarPLAILabel.FontSize = 10;
            app.config_GerarPLAILabel.Layout.Row = 3;
            app.config_GerarPLAILabel.Layout.Column = 1;
            app.config_GerarPLAILabel.Text = 'Gerar PLAI?';

            % Create config_GerarPLAI
            app.config_GerarPLAI = uidropdown(app.config_DefaultIssueValuesGrid);
            app.config_GerarPLAI.Items = {};
            app.config_GerarPLAI.Enable = 'off';
            app.config_GerarPLAI.FontSize = 11;
            app.config_GerarPLAI.BackgroundColor = [1 1 1];
            app.config_GerarPLAI.Layout.Row = 4;
            app.config_GerarPLAI.Layout.Column = 1;
            app.config_GerarPLAI.Value = {};

            % Create config_TipoPLAILabel
            app.config_TipoPLAILabel = uilabel(app.config_DefaultIssueValuesGrid);
            app.config_TipoPLAILabel.VerticalAlignment = 'bottom';
            app.config_TipoPLAILabel.FontSize = 10;
            app.config_TipoPLAILabel.Layout.Row = 3;
            app.config_TipoPLAILabel.Layout.Column = 2;
            app.config_TipoPLAILabel.Text = 'Tipo do PLAI:';

            % Create config_TipoPLAI
            app.config_TipoPLAI = uidropdown(app.config_DefaultIssueValuesGrid);
            app.config_TipoPLAI.Items = {};
            app.config_TipoPLAI.Enable = 'off';
            app.config_TipoPLAI.FontSize = 11;
            app.config_TipoPLAI.BackgroundColor = [1 1 1];
            app.config_TipoPLAI.Layout.Row = 4;
            app.config_TipoPLAI.Layout.Column = 2;
            app.config_TipoPLAI.Value = {};

            % Create config_MotivoLAILabel
            app.config_MotivoLAILabel = uilabel(app.config_DefaultIssueValuesGrid);
            app.config_MotivoLAILabel.VerticalAlignment = 'bottom';
            app.config_MotivoLAILabel.FontSize = 10;
            app.config_MotivoLAILabel.Layout.Row = 5;
            app.config_MotivoLAILabel.Layout.Column = 1;
            app.config_MotivoLAILabel.Text = 'Motivo de LAI:';

            % Create config_MotivoLAI
            app.config_MotivoLAI = uitree(app.config_DefaultIssueValuesGrid, 'checkbox');
            app.config_MotivoLAI.Enable = 'off';
            app.config_MotivoLAI.FontSize = 10;
            app.config_MotivoLAI.Layout.Row = 6;
            app.config_MotivoLAI.Layout.Column = [1 2];

            % Create config_ServicoInspecaoLabel
            app.config_ServicoInspecaoLabel = uilabel(app.config_DefaultIssueValuesGrid);
            app.config_ServicoInspecaoLabel.VerticalAlignment = 'bottom';
            app.config_ServicoInspecaoLabel.FontSize = 10;
            app.config_ServicoInspecaoLabel.Layout.Row = 7;
            app.config_ServicoInspecaoLabel.Layout.Column = 1;
            app.config_ServicoInspecaoLabel.Text = 'Serviços da Inspeção:';

            % Create config_ServicoInspecao
            app.config_ServicoInspecao = uitree(app.config_DefaultIssueValuesGrid, 'checkbox');
            app.config_ServicoInspecao.Enable = 'off';
            app.config_ServicoInspecao.FontSize = 10;
            app.config_ServicoInspecao.Layout.Row = 8;
            app.config_ServicoInspecao.Layout.Column = [1 2];

            % Create config_ButtonGroup
            app.config_ButtonGroup = uibuttongroup(app.config_mainGrid);
            app.config_ButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @config_ButtonGroupSelectionChanged, true);
            app.config_ButtonGroup.BackgroundColor = [1 1 1];
            app.config_ButtonGroup.Layout.Row = 2;
            app.config_ButtonGroup.Layout.Column = 1;
            app.config_ButtonGroup.FontSize = 11;

            % Create config_Option_Search
            app.config_Option_Search = uiradiobutton(app.config_ButtonGroup);
            app.config_Option_Search.Text = 'Aspectos gerais';
            app.config_Option_Search.FontSize = 11;
            app.config_Option_Search.Position = [11 560 100 22];
            app.config_Option_Search.Value = true;

            % Create config_Option_File
            app.config_Option_File = uiradiobutton(app.config_ButtonGroup);
            app.config_Option_File.Text = 'Leitura de arquivos';
            app.config_Option_File.FontSize = 11;
            app.config_Option_File.Position = [11 538 116 22];

            % Create config_Option_Graphics
            app.config_Option_Graphics = uiradiobutton(app.config_ButtonGroup);
            app.config_Option_Graphics.Text = 'Gráfico';
            app.config_Option_Graphics.FontSize = 11;
            app.config_Option_Graphics.Position = [11 516 57 22];

            % Create config_Option_Elevation
            app.config_Option_Elevation = uiradiobutton(app.config_ButtonGroup);
            app.config_Option_Elevation.Text = 'Elevação';
            app.config_Option_Elevation.FontSize = 11;
            app.config_Option_Elevation.Position = [11 494 67 22];

            % Create config_Option_Fiscaliza
            app.config_Option_Fiscaliza = uiradiobutton(app.config_ButtonGroup);
            app.config_Option_Fiscaliza.Text = 'API Fiscaliza';
            app.config_Option_Fiscaliza.FontSize = 11;
            app.config_Option_Fiscaliza.Position = [11 472 86 22];

            % Create config_Option_Folder
            app.config_Option_Folder = uiradiobutton(app.config_ButtonGroup);
            app.config_Option_Folder.Text = 'Mapeamento de pastas';
            app.config_Option_Folder.FontSize = 11;
            app.config_Option_Folder.Position = [11 450 137 22];

            % Create config_Label
            app.config_Label = uilabel(app.config_mainGrid);
            app.config_Label.VerticalAlignment = 'bottom';
            app.config_Label.FontSize = 10;
            app.config_Label.Layout.Row = 1;
            app.config_Label.Layout.Column = 1;
            app.config_Label.Text = 'PARÂMETROS A CONFIGURAR';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.config_mainGrid);
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x', 16};
            app.GridLayout2.RowHeight = {22, 5, 17, '1x'};
            app.GridLayout2.ColumnSpacing = 2;
            app.GridLayout2.RowSpacing = 0;
            app.GridLayout2.Padding = [0 0 0 0];
            app.GridLayout2.Layout.Row = [1 2];
            app.GridLayout2.Layout.Column = 2;
            app.GridLayout2.BackgroundColor = [1 1 1];

            % Create config_SearchModeLabel_2
            app.config_SearchModeLabel_2 = uilabel(app.GridLayout2);
            app.config_SearchModeLabel_2.VerticalAlignment = 'bottom';
            app.config_SearchModeLabel_2.FontSize = 10;
            app.config_SearchModeLabel_2.Layout.Row = 1;
            app.config_SearchModeLabel_2.Layout.Column = [1 2];
            app.config_SearchModeLabel_2.Text = 'ASPECTOS GERAIS';

            % Create Tab1_Panel
            app.Tab1_Panel = uipanel(app.GridLayout2);
            app.Tab1_Panel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Tab1_Panel.Layout.Row = [3 4];
            app.Tab1_Panel.Layout.Column = [1 3];

            % Create Tab1_Grid
            app.Tab1_Grid = uigridlayout(app.Tab1_Panel);
            app.Tab1_Grid.ColumnWidth = {'1x'};
            app.Tab1_Grid.RowHeight = {'1x'};
            app.Tab1_Grid.Padding = [0 0 0 0];
            app.Tab1_Grid.BackgroundColor = [1 1 1];

            % Create VersionInfo
            app.VersionInfo = uihtml(app.Tab1_Grid);
            app.VersionInfo.HTMLSource = ' ';
            app.VersionInfo.Layout.Row = 1;
            app.VersionInfo.Layout.Column = 1;

            % Create tool_RefreshButton
            app.tool_RefreshButton = uiimage(app.GridLayout2);
            app.tool_RefreshButton.ImageClickedFcn = createCallbackFcn(app, @tool_RefreshButtonPushed, true);
            app.tool_RefreshButton.Layout.Row = 3;
            app.tool_RefreshButton.Layout.Column = 4;
            app.tool_RefreshButton.ImageSource = 'Refresh_18.png';

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.config_mainGrid);
            app.GridLayout4.ColumnWidth = {'1x', 16};
            app.GridLayout4.RowHeight = {22, 22, '1x'};
            app.GridLayout4.ColumnSpacing = 2;
            app.GridLayout4.RowSpacing = 5;
            app.GridLayout4.Padding = [0 0 0 0];
            app.GridLayout4.Layout.Row = [1 2];
            app.GridLayout4.Layout.Column = 3;
            app.GridLayout4.BackgroundColor = [1 1 1];

            % Create mergePanelTitle
            app.mergePanelTitle = uilabel(app.GridLayout4);
            app.mergePanelTitle.VerticalAlignment = 'bottom';
            app.mergePanelTitle.FontSize = 10;
            app.mergePanelTitle.Layout.Row = 1;
            app.mergePanelTitle.Layout.Column = 1;
            app.mergePanelTitle.Text = 'LEITURA DE ARQUIVOS';

            % Create mergePanel
            app.mergePanel = uipanel(app.GridLayout4);
            app.mergePanel.Layout.Row = [2 3];
            app.mergePanel.Layout.Column = 1;

            % Create mergeGrid
            app.mergeGrid = uigridlayout(app.mergePanel);
            app.mergeGrid.ColumnWidth = {110, '1x'};
            app.mergeGrid.RowHeight = {17, 22, 22, 32, 22};
            app.mergeGrid.RowSpacing = 5;
            app.mergeGrid.BackgroundColor = [1 1 1];

            % Create mergeLabel
            app.mergeLabel = uilabel(app.mergeGrid);
            app.mergeLabel.VerticalAlignment = 'bottom';
            app.mergeLabel.FontSize = 10;
            app.mergeLabel.Layout.Row = 1;
            app.mergeLabel.Layout.Column = [1 2];
            app.mergeLabel.Text = 'Lista de metadados a ignorar no processo de mesclagem de fluxos espectrais:';

            % Create mergeDataTypeCheckbox
            app.mergeDataTypeCheckbox = uicheckbox(app.mergeGrid);
            app.mergeDataTypeCheckbox.ValueChangedFcn = createCallbackFcn(app, @File_ParameterValueChanged, true);
            app.mergeDataTypeCheckbox.Text = 'DataType';
            app.mergeDataTypeCheckbox.FontSize = 11;
            app.mergeDataTypeCheckbox.FontColor = [0.149 0.149 0.149];
            app.mergeDataTypeCheckbox.Layout.Row = 2;
            app.mergeDataTypeCheckbox.Layout.Column = 1;

            % Create mergeAntennaCheckbox
            app.mergeAntennaCheckbox = uicheckbox(app.mergeGrid);
            app.mergeAntennaCheckbox.ValueChangedFcn = createCallbackFcn(app, @File_ParameterValueChanged, true);
            app.mergeAntennaCheckbox.Text = 'Antenna';
            app.mergeAntennaCheckbox.FontSize = 11;
            app.mergeAntennaCheckbox.FontColor = [0.149 0.149 0.149];
            app.mergeAntennaCheckbox.Layout.Row = 3;
            app.mergeAntennaCheckbox.Layout.Column = 1;

            % Create mergeGPSLabel
            app.mergeGPSLabel = uilabel(app.mergeGrid);
            app.mergeGPSLabel.VerticalAlignment = 'bottom';
            app.mergeGPSLabel.WordWrap = 'on';
            app.mergeGPSLabel.FontSize = 10;
            app.mergeGPSLabel.Layout.Row = 4;
            app.mergeGPSLabel.Layout.Column = [1 2];
            app.mergeGPSLabel.Text = 'Distância máxima entre locais de monitoração registrados em diferentes arquivos para que fluxos espectrais possam ser mesclados, na hipótese deles possuírem as mesmas características primárias - Faixa de Frequência, Pontos por Varredura. Resolução etc (metros):';

            % Create mergeGPSValue
            app.mergeGPSValue = uispinner(app.mergeGrid);
            app.mergeGPSValue.Step = 50;
            app.mergeGPSValue.Limits = [50 Inf];
            app.mergeGPSValue.RoundFractionalValues = 'on';
            app.mergeGPSValue.ValueDisplayFormat = '%.0f';
            app.mergeGPSValue.ValueChangedFcn = createCallbackFcn(app, @File_ParameterValueChanged, true);
            app.mergeGPSValue.FontSize = 11;
            app.mergeGPSValue.FontColor = [0.149 0.149 0.149];
            app.mergeGPSValue.Layout.Row = 5;
            app.mergeGPSValue.Layout.Column = 1;
            app.mergeGPSValue.Value = 100;

            % Create mergeRefresh
            app.mergeRefresh = uiimage(app.GridLayout4);
            app.mergeRefresh.ImageClickedFcn = createCallbackFcn(app, @File_ParameterValueChanged, true);
            app.mergeRefresh.Layout.Row = 2;
            app.mergeRefresh.Layout.Column = 2;
            app.mergeRefresh.ImageSource = 'Refresh_18.png';

            % Create ELEVAOLabel
            app.ELEVAOLabel = uilabel(app.config_mainGrid);
            app.ELEVAOLabel.VerticalAlignment = 'bottom';
            app.ELEVAOLabel.FontSize = 10;
            app.ELEVAOLabel.Layout.Row = 1;
            app.ELEVAOLabel.Layout.Column = 5;
            app.ELEVAOLabel.Text = 'ELEVAÇÃO';

            % Create misc_ElevationSourcePanel
            app.misc_ElevationSourcePanel = uipanel(app.config_mainGrid);
            app.misc_ElevationSourcePanel.AutoResizeChildren = 'off';
            app.misc_ElevationSourcePanel.Layout.Row = 2;
            app.misc_ElevationSourcePanel.Layout.Column = 5;

            % Create misc_ElevationSourceGrid
            app.misc_ElevationSourceGrid = uigridlayout(app.misc_ElevationSourcePanel);
            app.misc_ElevationSourceGrid.ColumnWidth = {'1x', 130};
            app.misc_ElevationSourceGrid.RowHeight = {17, 22, 32};
            app.misc_ElevationSourceGrid.RowSpacing = 5;
            app.misc_ElevationSourceGrid.Padding = [10 10 10 5];
            app.misc_ElevationSourceGrid.BackgroundColor = [1 1 1];

            % Create misc_ElevationAPISourceLabel
            app.misc_ElevationAPISourceLabel = uilabel(app.misc_ElevationSourceGrid);
            app.misc_ElevationAPISourceLabel.VerticalAlignment = 'bottom';
            app.misc_ElevationAPISourceLabel.FontSize = 10;
            app.misc_ElevationAPISourceLabel.Layout.Row = 1;
            app.misc_ElevationAPISourceLabel.Layout.Column = 1;
            app.misc_ElevationAPISourceLabel.Text = 'Fonte:';

            % Create misc_ElevationAPISource
            app.misc_ElevationAPISource = uidropdown(app.misc_ElevationSourceGrid);
            app.misc_ElevationAPISource.Items = {'Open-Elevation', 'MathWorks WMS Server'};
            app.misc_ElevationAPISource.ValueChangedFcn = createCallbackFcn(app, @misc_ElevationAPISourceValueChanged, true);
            app.misc_ElevationAPISource.FontSize = 11;
            app.misc_ElevationAPISource.BackgroundColor = [1 1 1];
            app.misc_ElevationAPISource.Layout.Row = 2;
            app.misc_ElevationAPISource.Layout.Column = 1;
            app.misc_ElevationAPISource.Value = 'Open-Elevation';

            % Create misc_ElevationNPointsLabel
            app.misc_ElevationNPointsLabel = uilabel(app.misc_ElevationSourceGrid);
            app.misc_ElevationNPointsLabel.VerticalAlignment = 'bottom';
            app.misc_ElevationNPointsLabel.FontSize = 10;
            app.misc_ElevationNPointsLabel.Layout.Row = 1;
            app.misc_ElevationNPointsLabel.Layout.Column = 2;
            app.misc_ElevationNPointsLabel.Text = 'Pontos enlace:';

            % Create misc_ElevationNPoints
            app.misc_ElevationNPoints = uidropdown(app.misc_ElevationSourceGrid);
            app.misc_ElevationNPoints.Items = {'64', '128', '256', '512', '1024'};
            app.misc_ElevationNPoints.FontSize = 11;
            app.misc_ElevationNPoints.BackgroundColor = [1 1 1];
            app.misc_ElevationNPoints.Layout.Row = 2;
            app.misc_ElevationNPoints.Layout.Column = 2;
            app.misc_ElevationNPoints.Value = '64';

            % Create misc_ElevationForceSearch
            app.misc_ElevationForceSearch = uicheckbox(app.misc_ElevationSourceGrid);
            app.misc_ElevationForceSearch.Text = 'Força consulta ao servidor (ignorando eventual informação em cache).';
            app.misc_ElevationForceSearch.WordWrap = 'on';
            app.misc_ElevationForceSearch.FontSize = 11;
            app.misc_ElevationForceSearch.Layout.Row = 3;
            app.misc_ElevationForceSearch.Layout.Column = [1 2];

            % Create GridLayout7
            app.GridLayout7 = uigridlayout(app.config_mainGrid);
            app.GridLayout7.ColumnWidth = {'1x', 16};
            app.GridLayout7.RowHeight = {22, 17, '1x'};
            app.GridLayout7.ColumnSpacing = 2;
            app.GridLayout7.RowSpacing = 5;
            app.GridLayout7.Padding = [0 0 0 0];
            app.GridLayout7.Layout.Row = [1 2];
            app.GridLayout7.Layout.Column = 4;
            app.GridLayout7.BackgroundColor = [1 1 1];

            % Create GRFICOLabel
            app.GRFICOLabel = uilabel(app.GridLayout7);
            app.GRFICOLabel.VerticalAlignment = 'bottom';
            app.GRFICOLabel.FontSize = 10;
            app.GRFICOLabel.Layout.Row = 1;
            app.GRFICOLabel.Layout.Column = 1;
            app.GRFICOLabel.Text = 'GRÁFICO';

            % Create Panel
            app.Panel = uipanel(app.GridLayout7);
            app.Panel.Layout.Row = [2 3];
            app.Panel.Layout.Column = 1;

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.Panel);
            app.GridLayout5.ColumnWidth = {110, '1x'};
            app.GridLayout5.RowHeight = {22, 22, 22, 22, 22, 22, '1x', 22, 22};
            app.GridLayout5.RowSpacing = 5;
            app.GridLayout5.Padding = [10 10 10 5];
            app.GridLayout5.BackgroundColor = [1 1 1];

            % Create config_openAuxiliarApp2Debug
            app.config_openAuxiliarApp2Debug = uicheckbox(app.GridLayout5);
            app.config_openAuxiliarApp2Debug.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.config_openAuxiliarApp2Debug.Text = 'Modo DEBUG';
            app.config_openAuxiliarApp2Debug.FontSize = 11;
            app.config_openAuxiliarApp2Debug.Layout.Row = 9;
            app.config_openAuxiliarApp2Debug.Layout.Column = [1 2];

            % Create gpuTypeLabel
            app.gpuTypeLabel = uilabel(app.GridLayout5);
            app.gpuTypeLabel.VerticalAlignment = 'bottom';
            app.gpuTypeLabel.FontSize = 10;
            app.gpuTypeLabel.FontColor = [0.149 0.149 0.149];
            app.gpuTypeLabel.Layout.Row = 1;
            app.gpuTypeLabel.Layout.Column = [1 2];
            app.gpuTypeLabel.Text = 'Unidade gráfica:';

            % Create gpuType
            app.gpuType = uidropdown(app.GridLayout5);
            app.gpuType.Items = {'hardwarebasic', 'hardware', 'software'};
            app.gpuType.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.gpuType.FontSize = 11;
            app.gpuType.BackgroundColor = [1 1 1];
            app.gpuType.Layout.Row = 2;
            app.gpuType.Layout.Column = 1;
            app.gpuType.Value = 'hardwarebasic';

            % Create imgFormatLabel
            app.imgFormatLabel = uilabel(app.GridLayout5);
            app.imgFormatLabel.VerticalAlignment = 'bottom';
            app.imgFormatLabel.FontSize = 10;
            app.imgFormatLabel.Layout.Row = 3;
            app.imgFormatLabel.Layout.Column = [1 2];
            app.imgFormatLabel.Text = 'Formato da imagem a ser criada no processo de geração de relatório:';

            % Create imgFormat
            app.imgFormat = uidropdown(app.GridLayout5);
            app.imgFormat.Items = {'jpeg', 'png'};
            app.imgFormat.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.imgFormat.FontSize = 11;
            app.imgFormat.BackgroundColor = [1 1 1];
            app.imgFormat.Layout.Row = 4;
            app.imgFormat.Layout.Column = 1;
            app.imgFormat.Value = 'jpeg';

            % Create imgResolutionLabel
            app.imgResolutionLabel = uilabel(app.GridLayout5);
            app.imgResolutionLabel.VerticalAlignment = 'bottom';
            app.imgResolutionLabel.FontSize = 10;
            app.imgResolutionLabel.Layout.Row = 5;
            app.imgResolutionLabel.Layout.Column = [1 2];
            app.imgResolutionLabel.Text = 'Resolução da imagem a ser criada no processo de geração de relatório (dpi):';

            % Create imgResolution
            app.imgResolution = uidropdown(app.GridLayout5);
            app.imgResolution.Items = {'100', '120', '150', '200'};
            app.imgResolution.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.imgResolution.FontSize = 11;
            app.imgResolution.BackgroundColor = [1 1 1];
            app.imgResolution.Layout.Row = 6;
            app.imgResolution.Layout.Column = 1;
            app.imgResolution.Value = '120';

            % Create config_openAuxiliarAppAsDocked
            app.config_openAuxiliarAppAsDocked = uicheckbox(app.GridLayout5);
            app.config_openAuxiliarAppAsDocked.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.config_openAuxiliarAppAsDocked.Text = 'Modo DOCK: janelas de módulos auxiliares são abertas na própria janela principal do app.';
            app.config_openAuxiliarAppAsDocked.FontSize = 11;
            app.config_openAuxiliarAppAsDocked.Layout.Row = 8;
            app.config_openAuxiliarAppAsDocked.Layout.Column = [1 2];

            % Create graphics_Refresh
            app.graphics_Refresh = uiimage(app.GridLayout7);
            app.graphics_Refresh.ImageClickedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.graphics_Refresh.Layout.Row = 2;
            app.graphics_Refresh.Layout.Column = 2;
            app.graphics_Refresh.ImageSource = 'Refresh_18.png';

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.GridLayout);
            app.GridLayout6.ColumnWidth = {22, 22, 22, '1x'};
            app.GridLayout6.RowHeight = {4, 17, '1x'};
            app.GridLayout6.ColumnSpacing = 5;
            app.GridLayout6.RowSpacing = 0;
            app.GridLayout6.Padding = [5 5 0 5];
            app.GridLayout6.Layout.Row = 2;
            app.GridLayout6.Layout.Column = 1;

            % Create tool_RFDataHubButton
            app.tool_RFDataHubButton = uiimage(app.GridLayout6);
            app.tool_RFDataHubButton.ImageClickedFcn = createCallbackFcn(app, @tool_RFDataHubButtonPushed, true);
            app.tool_RFDataHubButton.Enable = 'off';
            app.tool_RFDataHubButton.Layout.Row = 2;
            app.tool_RFDataHubButton.Layout.Column = 1;
            app.tool_RFDataHubButton.ImageSource = 'mosaic_32.png';

            % Create tool_PythonButton
            app.tool_PythonButton = uiimage(app.GridLayout6);
            app.tool_PythonButton.ImageClickedFcn = createCallbackFcn(app, @tool_PythonButtonPushed, true);
            app.tool_PythonButton.Enable = 'off';
            app.tool_PythonButton.Layout.Row = 2;
            app.tool_PythonButton.Layout.Column = 2;
            app.tool_PythonButton.ImageSource = 'Python_32.png';

            % Create tool_FiscalizaButton
            app.tool_FiscalizaButton = uiimage(app.GridLayout6);
            app.tool_FiscalizaButton.ImageClickedFcn = createCallbackFcn(app, @tool_FiscalizaButtonPushed, true);
            app.tool_FiscalizaButton.Enable = 'off';
            app.tool_FiscalizaButton.Layout.Row = 2;
            app.tool_FiscalizaButton.Layout.Column = 3;
            app.tool_FiscalizaButton.ImageSource = 'Redmine_32.png';

            % Create jsBackDoor
            app.jsBackDoor = uihtml(app.GridLayout6);
            app.jsBackDoor.Layout.Row = 2;
            app.jsBackDoor.Layout.Column = 4;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = winConfig_exported(Container, varargin)

            % Create UIFigure and components
            createComponents(app, Container)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            if app.isDocked
                delete(app.Container.Children)
            else
                delete(app.UIFigure)
            end
        end
    end
end
