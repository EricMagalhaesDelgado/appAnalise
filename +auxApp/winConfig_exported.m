classdef winConfig_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        jsBackDoor                      matlab.ui.control.HTML
        tool_RFDataHubButton            matlab.ui.control.Image
        tool_FiscalizaButton            matlab.ui.control.Image
        tool_LeftPanelVisibility        matlab.ui.control.Image
        Document                        matlab.ui.container.GridLayout
        Folders_Grid                    matlab.ui.container.GridLayout
        config_FolderMapPanel           matlab.ui.container.Panel
        config_FolderMapGrid            matlab.ui.container.GridLayout
        config_Folder_userPathButton    matlab.ui.control.Image
        config_Folder_userPath          matlab.ui.control.EditField
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
        APIFiscaliza_Grid               matlab.ui.container.GridLayout
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
        General_Grid                    matlab.ui.container.GridLayout
        general_ElevationPanel          matlab.ui.container.Panel
        general_ElevationGrid           matlab.ui.container.GridLayout
        ElevationForceSearch            matlab.ui.control.CheckBox
        ElevationNPoints                matlab.ui.control.DropDown
        ElevationNPointsLabel           matlab.ui.control.Label
        ElevationAPIServer              matlab.ui.control.DropDown
        ElevationAPIServerLabel         matlab.ui.control.Label
        general_ElevationRefresh        matlab.ui.control.Image
        general_ElevationLabel          matlab.ui.control.Label
        general_GraphicsPanel           matlab.ui.container.Panel
        general_GraphicsGrid            matlab.ui.container.GridLayout
        openAuxiliarApp2Debug           matlab.ui.control.CheckBox
        openAuxiliarAppAsDocked         matlab.ui.control.CheckBox
        imgResolution                   matlab.ui.control.DropDown
        imgResolutionLabel              matlab.ui.control.Label
        imgFormat                       matlab.ui.control.DropDown
        imgFormatLabel                  matlab.ui.control.Label
        gpuType                         matlab.ui.control.DropDown
        gpuTypeLabel                    matlab.ui.control.Label
        graphics_Refresh                matlab.ui.control.Image
        general_GraphicsLabel           matlab.ui.control.Label
        general_FilePanel               matlab.ui.container.Panel
        general_FileGrid                matlab.ui.container.GridLayout
        mergeDistance                   matlab.ui.control.Spinner
        mergeLabel2                     matlab.ui.control.Label
        mergeAntenna                    matlab.ui.control.CheckBox
        mergeDataType                   matlab.ui.control.CheckBox
        mergeLabel1                     matlab.ui.control.Label
        general_mergeRefresh            matlab.ui.control.Image
        general_FileLabel               matlab.ui.control.Label
        general_AppVersionPanel         matlab.ui.container.Panel
        general_AppVersionGrid          matlab.ui.container.GridLayout
        AppVersion                      matlab.ui.control.HTML
        general_AppVersionRefresh       matlab.ui.control.Image
        general_AppVersionLabel         matlab.ui.control.Label
        LeftPanel                       matlab.ui.container.Panel
        LeftPanelGrid                   matlab.ui.container.GridLayout
        LeftPanelRadioGroup             matlab.ui.container.ButtonGroup
        btnFolder                       matlab.ui.control.RadioButton
        btnFiscaliza                    matlab.ui.control.RadioButton
        btnGeneral                      matlab.ui.control.RadioButton
        LeftPanelTitle                  matlab.ui.container.GridLayout
        menuUnderline                   matlab.ui.control.Image
        menu_ButtonGrid                 matlab.ui.container.GridLayout
        menu_ButtonIcon                 matlab.ui.control.Image
        menu_ButtonLabel                matlab.ui.control.Label
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


    properties (Access = private)
        %-----------------------------------------------------------------%
        DefaultValues = struct('File',      struct('DataType', true, 'DataTypeLabel', 'remove', 'Antenna', true, 'AntennaLabel', 'remove', 'Distance', 100), ...
                               'Graphics',  struct('openGL', 'hardware', 'Format', 'jpeg', 'Resolution', '120', 'Dock', true),                               ...
                               'Elevation', struct('Points', '256', 'ForceSearch', false, 'Server', 'Open-Elevation'))
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
            
            % (b) Move os componentes do container antigo para o novo, ajustando
            %     o modo de visualização da tabela.
            app.Container.Children.Parent = app.UIFigure;
            drawnow
            
            % (c) Reinicia as propriedades "Container" e "isDocked".
            app.Container = app.UIFigure;
            app.isDocked  = false;

            % (d) Customiza aspectos estéticos da janela.
            jsBackDoor_Customizations(app)
            appUtil.winMinSize(app.UIFigure, class.Constants.WindowMinSize('CONFIG'))
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
            drawnow
            
            % Customiza as aspectos estéticos de alguns dos componentes da GUI 
            % (diretamente em JS).
            jsBackDoor_Customizations(app)

            switch app.CallingApp.executionMode
                case 'webApp'
                    app.general_AppVersionRefresh.Enable = 0;
                    app.openAuxiliarAppAsDocked.Enable   = 0;
                    app.openAuxiliarApp2Debug.Enable     = 0;

                otherwise
                    if ~app.isDocked
                        appUtil.winMinSize(app.UIFigure, class.Constants.WindowMinSize('CONFIG'))
                    end
            end

            % Atualização dos painéis...
            app.progressDialog.Visible = 'visible';

            startup_checkPythonVersion(app)
            
            AppVersion_updatePanel(app)
            File_updatePanel(app)
            Graphics_updatePanel(app)
            Elevation_updatePanel(app)
            APIFiscaliza_updatePanel(app)
            Folder_updatePanel(app)

            app.progressDialog.Visible = 'hidden';
        end

        %-----------------------------------------------------------------%
        function startup_checkPythonVersion(app)
            if isempty(app.CallingApp.General.AppVersion.fiscaliza)
                app.CallingApp.General.AppVersion = fcn.envVersion(app.rootFolder, 'full+Python');
            end
            app.General = app.CallingApp.General;
        end

        %-----------------------------------------------------------------%
        function AppVersion_updatePanel(app)
            % Versão
            htmlContent = auxApp.config.htmlCode_AppVersion(app.General, app.CallingApp.executionMode);
            app.AppVersion.HTMLSource = htmlContent;
        end

        %-----------------------------------------------------------------%
        function File_updatePanel(app)
            % Mesclagem de fluxos espectrais
            switch app.General.Merge.DataType
                case 'keep';   app.mergeDataType.Value = 0;
                case 'remove'; app.mergeDataType.Value = 1;
            end

            switch app.General.Merge.Antenna
                case 'keep';   app.mergeAntenna.Value = 0;
                case 'remove'; app.mergeAntenna.Value = 1;
            end

            app.mergeDistance.Value = app.General.Merge.Distance;

            if File_checkEdition(app)
                app.general_mergeRefresh.Visible = 1;
            else
                app.general_mergeRefresh.Visible = 0;
            end
        end

        %-----------------------------------------------------------------%
        function editionFlag = File_checkEdition(app)
            editionFlag = false;

            if (app.mergeDataType.Value ~= app.DefaultValues.File.DataType) || ...
               (app.mergeAntenna.Value  ~= app.DefaultValues.File.Antenna)  || ...
               (abs(app.mergeDistance.Value - app.DefaultValues.File.Distance) > class.Constants.floatDiffTolerance)

                editionFlag = true;
            end
        end

        %-----------------------------------------------------------------%
        function Graphics_updatePanel(app)
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
            app.openAuxiliarAppAsDocked.Value = app.General.operationMode.Dock;
            app.openAuxiliarApp2Debug.Value   = app.General.operationMode.Debug;

            if Graphics_checkEdition(app)
                app.graphics_Refresh.Visible = 1;
            else
                app.graphics_Refresh.Visible = 0;
            end
        end

        %-----------------------------------------------------------------%
        function editionFlag = Graphics_checkEdition(app)
            editionFlag = false;

            if ~strcmp(app.gpuType.Value,            app.DefaultValues.Graphics.openGL)     || ...
               ~strcmp(app.imgFormat.Value,          app.DefaultValues.Graphics.Format)     || ...
               ~strcmp(app.imgResolution.Value,      app.DefaultValues.Graphics.Resolution) || ...
               (app.openAuxiliarAppAsDocked.Value ~= app.DefaultValues.Graphics.Dock)

                editionFlag = true;
            end
        end

        %-----------------------------------------------------------------%
        function Elevation_updatePanel(app)
            app.ElevationNPoints.Value     = num2str(app.General.Elevation.Points);
            app.ElevationForceSearch.Value = app.General.Elevation.ForceSearch;
            app.ElevationAPIServer.Value   = app.General.Elevation.Server;

            if Elevation_checkEdition(app)
                app.general_ElevationRefresh.Visible = 1;
            else
                app.general_ElevationRefresh.Visible = 0;
            end
        end

        %-----------------------------------------------------------------%
        function editionFlag = Elevation_checkEdition(app)
            editionFlag = false;

            if ~strcmp(app.ElevationNPoints.Value, app.DefaultValues.Elevation.Points)     || ...
               (app.ElevationForceSearch.Value ~= app.DefaultValues.Elevation.ForceSearch) || ...
               ~strcmp(app.ElevationAPIServer.Value, app.DefaultValues.Elevation.Server)
                
                editionFlag = true;
            end
        end

        %-----------------------------------------------------------------%
        function APIFiscaliza_updatePanel(app)
            switch app.General.fiscaliza.systemVersion
                case 'PROD'
                    app.config_FiscalizaPD.Value = 1;
                case 'HOM'
                    app.config_FiscalizaHM.Value = 1;
            end
            fiscalizaLibConnection.config_DefaultValues(app)
        end

        %-----------------------------------------------------------------%
        function Folder_updatePanel(app)
            % Na versão webapp, a configuração das pastas não é habilitada.

            switch app.CallingApp.executionMode
                case 'webApp'
                    app.btnFolder.Enable = 0;

                otherwise
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
    
                    % userPath
                    app.config_Folder_userPath.Value = app.General.fileFolder.userPath;
            end
        end

        %-----------------------------------------------------------------%
        function saveGeneralSettings(app)
            app.General = app.CallingApp.General;
            appUtil.generalSettingsSave(class.Constants.appName, app.rootFolder, app.CallingApp.General, app.CallingApp.executionMode, {'AppVersion', 'Models', 'Report'})
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
            LeftPanelRadioGroupSelectionChanged(app)

            if app.isDocked
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

        % Image clicked function: tool_LeftPanelVisibility
        function tool_LeftPanelVisibilityClicked(app, event)
            
            focus(app.jsBackDoor)

            if app.Document.ColumnWidth{1}
                app.tool_LeftPanelVisibility.ImageSource = 'ArrowRight_32.png';
                app.Document.ColumnWidth{1} = 0;
            else
                app.tool_LeftPanelVisibility.ImageSource = 'ArrowLeft_32.png';
                app.Document.ColumnWidth{1} = 320;
            end

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
            
            if isequal(app.CallingApp.General.AppVersion.RFDataHub,  app.stableVersion.RFDataHub)
                app.tool_RFDataHubButton.Enable = 0;
                appUtil.modalWindow(app.UIFigure, 'warning', 'Módulo RFDataHub já atualizado!');
                return
            end

            d = appUtil.modalWindow(app.UIFigure, "progressdlg", 'Em andamento... esse processo pode demorar alguns minutos!');

            try
                [~, ~, rfdatahubLink] = fcn.PublicLinks(app.rootFolder);

                tempDir = tempname;
                mkdir(tempDir)

                websave(fullfile(tempDir, 'estacoes.parquet.gzip'), rfdatahubLink.Table);
                websave(fullfile(tempDir, 'log.parquet.gzip'),      rfdatahubLink.Log);
                websave(fullfile(tempDir, 'Release.json'),          rfdatahubLink.Release);

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

                % Apaga as variáveis globais, lendo os novos arquivos.
                clear global RFDataHub
                clear global RFDataHubLog
                clear global RFDataHub_info
                class.RFDataHub.read(app.rootFolder, tempDir)

                % Apaga os arquivos temporários.
                rmdir(tempDir, 's')

                % Atualiza versão.
                global RFDataHub_info
                app.CallingApp.General.AppVersion.RFDataHub = RFDataHub_info;
                app.tool_RFDataHubButton.Enable = 0;
                
            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', ME.message);
            end

            AppVersion_updatePanel(app)

            delete(d)

        end

        % Selection changed function: LeftPanelRadioGroup
        function LeftPanelRadioGroupSelectionChanged(app, event)
            
            selectedButton = app.LeftPanelRadioGroup.SelectedObject;
            switch selectedButton
                case app.btnGeneral;   app.Document.ColumnWidth(2:end) = {'1x',0,0};
                case app.btnFiscaliza; app.Document.ColumnWidth(2:end) = {0,'1x',0};
                case app.btnFolder;    app.Document.ColumnWidth(2:end) = {0,0,'1x'};
            end
            
        end

        % Image clicked function: general_AppVersionRefresh
        function AppVersion_refreshButtonPushed(app, event)
            
            app.progressDialog.Visible = 'visible';

            [htmlContent, app.stableVersion, updatedModule] = auxApp.config.htmlCode_CheckAvailableUpdate(app.General, app.rootFolder);
            appUtil.modalWindow(app.UIFigure, "info", htmlContent);
            
            if ~ismember('RFDataHub', updatedModule)
                app.tool_RFDataHubButton.Enable = 1;
            end

            if ~ismember('fiscaliza', updatedModule)
                app.tool_FiscalizaButton.Enable = 1;
            end            

            app.progressDialog.Visible = 'hidden';

        end

        % Callback function: general_mergeRefresh, mergeAntenna, 
        % ...and 2 other components
        function File_ParameterValueChanged(app, event)
            
            switch event.Source
                %---------------------------------------------------------%
                case {app.mergeDataType, app.mergeAntenna, app.mergeDistance}                    
                    switch app.mergeDataType.Value
                        case 0; DataTypeStatus = 'keep';
                        case 1; DataTypeStatus = 'remove';
                    end
                    
                    switch app.mergeAntenna.Value
                        case 0; AntennaStatus  = 'keep';
                        case 1; AntennaStatus  = 'remove';
                    end
                                
                    app.CallingApp.General.Merge.DataType = DataTypeStatus;
                    app.CallingApp.General.Merge.Antenna  = AntennaStatus;
                    app.CallingApp.General.Merge.Distance = app.mergeDistance.Value;

                %---------------------------------------------------------%
                case app.general_mergeRefresh
                    app.CallingApp.General.Merge = struct('DataType', app.DefaultValues.File.DataTypeLabel, ...
                                                          'Antenna',  app.DefaultValues.File.AntennaLabel,  ...
                                                          'Distance', app.DefaultValues.File.Distance);
            end
            
            saveGeneralSettings(app)
            File_updatePanel(app)  

        end

        % Callback function: gpuType, graphics_Refresh, imgFormat, 
        % ...and 3 other components
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

                case app.openAuxiliarAppAsDocked
                    app.CallingApp.General.operationMode.Dock = app.openAuxiliarAppAsDocked.Value;

                case app.openAuxiliarApp2Debug
                    app.CallingApp.General.operationMode.Debug = app.openAuxiliarApp2Debug.Value;

                case app.graphics_Refresh
                    if ~strcmp(app.gpuType.Value, app.DefaultValues.Graphics.openGL)
                        app.gpuType.Value = app.DefaultValues.Graphics.openGL;
                        Graphics_ParameterValueChanged(app, struct('Source', app.gpuType))
                    end

                    app.CallingApp.General.Image = struct('Format', app.DefaultValues.Graphics.Format, 'Resolution', app.DefaultValues.Graphics.Resolution);
                    app.CallingApp.General.operationMode.Dock  = app.DefaultValues.Graphics.Dock;
            end

            saveGeneralSettings(app)
            Graphics_updatePanel(app)

        end

        % Callback function: ElevationAPIServer, ElevationForceSearch, 
        % ...and 2 other components
        function Elevation_ParameterValueChanged(app, event)

            switch event.Source
                case app.ElevationNPoints
                    app.CallingApp.General.Elevation.Points      = str2double(app.ElevationNPoints.Value);

                case app.ElevationForceSearch
                    app.CallingApp.General.Elevation.ForceSearch = app.ElevationForceSearch.Value;

                case app.ElevationAPIServer
                    app.CallingApp.General.Elevation.Server      = app.ElevationAPIServer.Value;

                case app.general_ElevationRefresh
                    app.CallingApp.General.Elevation = struct('Points',      str2double(app.DefaultValues.Elevation.Points), ...
                                                              'ForceSearch', app.DefaultValues.Elevation.ForceSearch,        ...
                                                              'Server',      app.DefaultValues.Elevation.Server);
            end

            saveGeneralSettings(app)
            Elevation_updatePanel(app)
            
        end

        % Selection changed function: config_FiscalizaVersion
        function config_FiscalizaMode(app, event)
            
            selectedButton = app.config_FiscalizaVersion.SelectedObject;
            switch selectedButton
                case app.config_FiscalizaPD
                    app.CallingApp.General.fiscaliza.systemVersion = 'PROD';
                case app.config_FiscalizaHM
                    app.CallingApp.General.fiscaliza.systemVersion = 'HOM';
            end

            saveGeneralSettings(app)
            appBackDoor(app.CallingApp, app, 'FiscalizaModeChanged')
            
        end

        % Image clicked function: config_DefaultIssueValuesLock
        function config_FiscalizaUnlockEdition(app, event)
            
            focus(app.jsBackDoor)
            
            hComponents = findobj(app.config_DefaultIssueValuesGrid, 'Type', 'uidropdown', '-or', 'Type', 'uicheckboxtree');
            if ~isempty(hComponents)
                if hComponents(1).Enable
                    app.config_DefaultIssueValuesLock.ImageSource = 'lockClose_18Gray.png';
                    set(hComponents, 'Enable', 0)                    
                else
                    app.config_DefaultIssueValuesLock.ImageSource = 'lockOpen_18Gray.png';
                    set(hComponents, 'Enable', 1)
                end
            end           

        end

        % Callback function: config_CadastroSTEL, config_GerarPLAI, 
        % ...and 3 other components
        function config_FiscalizaDefaultValueChanged(app, event)
            
            app.CallingApp.General.fiscaliza.defaultValues.entidade_com_cadastro_stel.value = app.config_CadastroSTEL.Value;
            app.CallingApp.General.fiscaliza.defaultValues.gerar_plai.value                 = app.config_GerarPLAI.Value;
            app.CallingApp.General.fiscaliza.defaultValues.tipo_do_processo_plai.value      = app.config_TipoPLAI.Value;

            if ~isempty(app.config_MotivoLAI.CheckedNodes)
                app.CallingApp.General.fiscaliza.defaultValues.motivo_de_lai.value          = {app.config_MotivoLAI.CheckedNodes.Text};
            else
                app.CallingApp.General.fiscaliza.defaultValues.motivo_de_lai.value          = {};
            end

            if ~isempty(app.config_ServicoInspecao.CheckedNodes)
                app.CallingApp.General.fiscaliza.defaultValues.servicos_da_inspecao.value   = {app.config_ServicoInspecao.CheckedNodes.Text};
            else
                app.CallingApp.General.fiscaliza.defaultValues.servicos_da_inspecao.value   = {};
            end
            
            saveGeneralSettings(app)
            app.General = app.CallingApp.General;

        end

        % Image clicked function: config_Folder_DataHubGETButton, 
        % ...and 3 other components
        function config_getFolder(app, event)
            
            try
                relatedFolder = eval(sprintf('app.config_Folder_%s.Value', event.Source.Tag));                    
            catch
                relatedFolder = app.CallingApp.General.fileFolder.(event.Source.Tag);
            end
            
            if isfolder(relatedFolder)
                initialFolder = relatedFolder;
            elseif isfile(relatedFolder)
                initialFolder = fileparts(relatedFolder);
            else
                initialFolder = app.config_Folder_userPath.Value;
            end
            
            selectedFolder = uigetdir(initialFolder);
            figure(app.UIFigure)

            if selectedFolder
                switch event.Source
                    case app.config_Folder_DataHubGETButton
                        appName  = class.Constants.appName;
                        repoName = 'DataHub - GET';

                        if strcmp(app.CallingApp.General.fileFolder.DataHub_GET, selectedFolder) 
                            return
                        elseif all(cellfun(@(x) contains(selectedFolder, x), {repoName, appName}))
                            app.progressDialog.Visible = 'visible';

                            app.config_Folder_DataHubGET.Value = selectedFolder;
                            app.CallingApp.General.fileFolder.DataHub_GET = selectedFolder;
                        else
                            appUtil.modalWindow(app.UIFigure, 'error', sprintf('Não identificado se tratar da pasta "%s" do repositório "%s".', appName, repoName));
                        end

                    case app.config_Folder_DataHubPOSTButton
                        appName  = class.Constants.appName;
                        repoName = 'DataHub - POST';

                        if strcmp(app.CallingApp.General.fileFolder.DataHub_POST, selectedFolder) 
                            return
                        elseif all(cellfun(@(x) contains(selectedFolder, x), {repoName, appName}))
                            app.config_Folder_DataHubPOST.Value = selectedFolder;
                            app.CallingApp.General.fileFolder.DataHub_POST = selectedFolder;
                        else
                            appUtil.modalWindow(app.UIFigure, 'error', sprintf('Não identificado se tratar da pasta "%s" do repositório "%s".', appName, repoName));
                        end

                    case app.config_Folder_pythonPathButton
                        pythonPath = fullfile(selectedFolder, ccTools.fcn.OperationSystem('pythonExecutable'));
                        if isfile(pythonPath)
                            app.progressDialog.Visible = 'visible';

                            try
                                pyenv('Version', pythonPath);
                                app.CallingApp.General.fileFolder.pythonPath = pythonPath;

                            catch ME
                                appUtil.modalWindow(app.UIFigure, 'error', 'O <i>app</i> deverá ser reinicializado para que a alteração tenha efeito.');
                            end

                            app.progressDialog.Visible = 'hidden';

                        else
                            appUtil.modalWindow(app.UIFigure, 'error', 'Não encontrado o arquivo executável do Python.');
                            return
                        end

                    case app.config_Folder_userPathButton
                        app.config_Folder_userPath.Value = selectedFolder;
                        app.CallingApp.General.fileFolder.userPath = selectedFolder;
                end

                saveGeneralSettings(app)
                app.General = app.CallingApp.General;
                Folder_updatePanel(app)
            end

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
            app.GridLayout.ColumnWidth = {22, 22, 22, '1x', 22};
            app.GridLayout.RowHeight = {'1x', 9, 17, 8};
            app.GridLayout.ColumnSpacing = 5;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create Document
            app.Document = uigridlayout(app.GridLayout);
            app.Document.ColumnWidth = {320, '1x', 0, 0};
            app.Document.RowHeight = {27, '1x'};
            app.Document.RowSpacing = 5;
            app.Document.Padding = [5 5 5 5];
            app.Document.Layout.Row = 1;
            app.Document.Layout.Column = [1 5];
            app.Document.BackgroundColor = [1 1 1];

            % Create LeftPanelTitle
            app.LeftPanelTitle = uigridlayout(app.Document);
            app.LeftPanelTitle.ColumnWidth = {'1x'};
            app.LeftPanelTitle.RowHeight = {'1x', 3};
            app.LeftPanelTitle.ColumnSpacing = 1;
            app.LeftPanelTitle.RowSpacing = 0;
            app.LeftPanelTitle.Padding = [0 0 0 0];
            app.LeftPanelTitle.Layout.Row = 1;
            app.LeftPanelTitle.Layout.Column = 1;
            app.LeftPanelTitle.BackgroundColor = [1 1 1];

            % Create menu_ButtonGrid
            app.menu_ButtonGrid = uigridlayout(app.LeftPanelTitle);
            app.menu_ButtonGrid.ColumnWidth = {18, '1x'};
            app.menu_ButtonGrid.RowHeight = {'1x'};
            app.menu_ButtonGrid.ColumnSpacing = 3;
            app.menu_ButtonGrid.Padding = [2 0 0 0];
            app.menu_ButtonGrid.Layout.Row = 1;
            app.menu_ButtonGrid.Layout.Column = 1;
            app.menu_ButtonGrid.BackgroundColor = [0.749 0.749 0.749];

            % Create menu_ButtonLabel
            app.menu_ButtonLabel = uilabel(app.menu_ButtonGrid);
            app.menu_ButtonLabel.FontSize = 11;
            app.menu_ButtonLabel.Layout.Row = 1;
            app.menu_ButtonLabel.Layout.Column = 2;
            app.menu_ButtonLabel.Text = 'CONFIGURAÇÕES';

            % Create menu_ButtonIcon
            app.menu_ButtonIcon = uiimage(app.menu_ButtonGrid);
            app.menu_ButtonIcon.ScaleMethod = 'none';
            app.menu_ButtonIcon.Tag = '1';
            app.menu_ButtonIcon.Layout.Row = 1;
            app.menu_ButtonIcon.Layout.Column = 1;
            app.menu_ButtonIcon.HorizontalAlignment = 'left';
            app.menu_ButtonIcon.ImageSource = 'Settings_18.png';

            % Create menuUnderline
            app.menuUnderline = uiimage(app.LeftPanelTitle);
            app.menuUnderline.ScaleMethod = 'scaleup';
            app.menuUnderline.Layout.Row = 2;
            app.menuUnderline.Layout.Column = 1;
            app.menuUnderline.ImageSource = 'LineH.png';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.Document);
            app.LeftPanel.Layout.Row = 2;
            app.LeftPanel.Layout.Column = 1;

            % Create LeftPanelGrid
            app.LeftPanelGrid = uigridlayout(app.LeftPanel);
            app.LeftPanelGrid.ColumnWidth = {'1x'};
            app.LeftPanelGrid.RowHeight = {100, '1x'};
            app.LeftPanelGrid.Padding = [0 0 0 0];
            app.LeftPanelGrid.BackgroundColor = [1 1 1];

            % Create LeftPanelRadioGroup
            app.LeftPanelRadioGroup = uibuttongroup(app.LeftPanelGrid);
            app.LeftPanelRadioGroup.AutoResizeChildren = 'off';
            app.LeftPanelRadioGroup.SelectionChangedFcn = createCallbackFcn(app, @LeftPanelRadioGroupSelectionChanged, true);
            app.LeftPanelRadioGroup.BorderType = 'none';
            app.LeftPanelRadioGroup.BackgroundColor = [1 1 1];
            app.LeftPanelRadioGroup.Layout.Row = 1;
            app.LeftPanelRadioGroup.Layout.Column = 1;
            app.LeftPanelRadioGroup.FontSize = 11;

            % Create btnGeneral
            app.btnGeneral = uiradiobutton(app.LeftPanelRadioGroup);
            app.btnGeneral.Text = 'Aspectos gerais';
            app.btnGeneral.FontSize = 11;
            app.btnGeneral.Position = [11 69 100 22];
            app.btnGeneral.Value = true;

            % Create btnFiscaliza
            app.btnFiscaliza = uiradiobutton(app.LeftPanelRadioGroup);
            app.btnFiscaliza.Text = 'API Fiscaliza';
            app.btnFiscaliza.FontSize = 11;
            app.btnFiscaliza.Position = [11 47 86 22];

            % Create btnFolder
            app.btnFolder = uiradiobutton(app.LeftPanelRadioGroup);
            app.btnFolder.Text = 'Mapeamento de pastas';
            app.btnFolder.FontSize = 11;
            app.btnFolder.Position = [11 25 137 22];

            % Create General_Grid
            app.General_Grid = uigridlayout(app.Document);
            app.General_Grid.ColumnWidth = {'1x', 16, 254, 16};
            app.General_Grid.RowHeight = {27, 150, 22, 198, 22, '1x'};
            app.General_Grid.RowSpacing = 5;
            app.General_Grid.Padding = [0 0 0 0];
            app.General_Grid.Layout.Row = [1 2];
            app.General_Grid.Layout.Column = 2;
            app.General_Grid.BackgroundColor = [1 1 1];

            % Create general_AppVersionLabel
            app.general_AppVersionLabel = uilabel(app.General_Grid);
            app.general_AppVersionLabel.VerticalAlignment = 'bottom';
            app.general_AppVersionLabel.FontSize = 10;
            app.general_AppVersionLabel.Layout.Row = 1;
            app.general_AppVersionLabel.Layout.Column = 1;
            app.general_AppVersionLabel.Text = 'ASPECTOS GERAIS';

            % Create general_AppVersionRefresh
            app.general_AppVersionRefresh = uiimage(app.General_Grid);
            app.general_AppVersionRefresh.ImageClickedFcn = createCallbackFcn(app, @AppVersion_refreshButtonPushed, true);
            app.general_AppVersionRefresh.Tooltip = {'Verifica atualizações'};
            app.general_AppVersionRefresh.Layout.Row = 1;
            app.general_AppVersionRefresh.Layout.Column = 2;
            app.general_AppVersionRefresh.VerticalAlignment = 'bottom';
            app.general_AppVersionRefresh.ImageSource = 'Refresh_18.png';

            % Create general_AppVersionPanel
            app.general_AppVersionPanel = uipanel(app.General_Grid);
            app.general_AppVersionPanel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.general_AppVersionPanel.Layout.Row = [2 6];
            app.general_AppVersionPanel.Layout.Column = [1 2];

            % Create general_AppVersionGrid
            app.general_AppVersionGrid = uigridlayout(app.general_AppVersionPanel);
            app.general_AppVersionGrid.ColumnWidth = {'1x'};
            app.general_AppVersionGrid.RowHeight = {'1x'};
            app.general_AppVersionGrid.Padding = [0 0 0 0];
            app.general_AppVersionGrid.BackgroundColor = [1 1 1];

            % Create AppVersion
            app.AppVersion = uihtml(app.general_AppVersionGrid);
            app.AppVersion.HTMLSource = ' ';
            app.AppVersion.Layout.Row = 1;
            app.AppVersion.Layout.Column = 1;

            % Create general_FileLabel
            app.general_FileLabel = uilabel(app.General_Grid);
            app.general_FileLabel.VerticalAlignment = 'bottom';
            app.general_FileLabel.FontSize = 10;
            app.general_FileLabel.Layout.Row = 1;
            app.general_FileLabel.Layout.Column = 3;
            app.general_FileLabel.Text = 'LEITURA DE ARQUIVOS';

            % Create general_mergeRefresh
            app.general_mergeRefresh = uiimage(app.General_Grid);
            app.general_mergeRefresh.ImageClickedFcn = createCallbackFcn(app, @File_ParameterValueChanged, true);
            app.general_mergeRefresh.Visible = 'off';
            app.general_mergeRefresh.Tooltip = {'Volta à configuração inicial'};
            app.general_mergeRefresh.Layout.Row = 1;
            app.general_mergeRefresh.Layout.Column = 4;
            app.general_mergeRefresh.VerticalAlignment = 'bottom';
            app.general_mergeRefresh.ImageSource = 'Refresh_18.png';

            % Create general_FilePanel
            app.general_FilePanel = uipanel(app.General_Grid);
            app.general_FilePanel.Layout.Row = 2;
            app.general_FilePanel.Layout.Column = [3 4];

            % Create general_FileGrid
            app.general_FileGrid = uigridlayout(app.general_FilePanel);
            app.general_FileGrid.ColumnWidth = {110, '1x'};
            app.general_FileGrid.RowHeight = {27, 22, 40, 22};
            app.general_FileGrid.RowSpacing = 5;
            app.general_FileGrid.BackgroundColor = [1 1 1];

            % Create mergeLabel1
            app.mergeLabel1 = uilabel(app.general_FileGrid);
            app.mergeLabel1.VerticalAlignment = 'bottom';
            app.mergeLabel1.WordWrap = 'on';
            app.mergeLabel1.FontSize = 10;
            app.mergeLabel1.Layout.Row = 1;
            app.mergeLabel1.Layout.Column = [1 2];
            app.mergeLabel1.Text = 'Lista de metadados a ignorar no processo de mesclagem de fluxos espectrais:';

            % Create mergeDataType
            app.mergeDataType = uicheckbox(app.general_FileGrid);
            app.mergeDataType.ValueChangedFcn = createCallbackFcn(app, @File_ParameterValueChanged, true);
            app.mergeDataType.Text = 'DataType';
            app.mergeDataType.FontSize = 11;
            app.mergeDataType.FontColor = [0.149 0.149 0.149];
            app.mergeDataType.Layout.Row = 2;
            app.mergeDataType.Layout.Column = 1;
            app.mergeDataType.Value = true;

            % Create mergeAntenna
            app.mergeAntenna = uicheckbox(app.general_FileGrid);
            app.mergeAntenna.ValueChangedFcn = createCallbackFcn(app, @File_ParameterValueChanged, true);
            app.mergeAntenna.Text = 'Antenna';
            app.mergeAntenna.FontSize = 11;
            app.mergeAntenna.FontColor = [0.149 0.149 0.149];
            app.mergeAntenna.Layout.Row = 2;
            app.mergeAntenna.Layout.Column = 2;
            app.mergeAntenna.Value = true;

            % Create mergeLabel2
            app.mergeLabel2 = uilabel(app.general_FileGrid);
            app.mergeLabel2.VerticalAlignment = 'bottom';
            app.mergeLabel2.WordWrap = 'on';
            app.mergeLabel2.FontSize = 10;
            app.mergeLabel2.Layout.Row = 3;
            app.mergeLabel2.Layout.Column = [1 2];
            app.mergeLabel2.Text = 'Distância máxima entre locais de monitoração registrados em diferentes arquivos para que os fluxos espectrais possam ser mesclados (metros):';

            % Create mergeDistance
            app.mergeDistance = uispinner(app.general_FileGrid);
            app.mergeDistance.Step = 50;
            app.mergeDistance.Limits = [50 Inf];
            app.mergeDistance.RoundFractionalValues = 'on';
            app.mergeDistance.ValueDisplayFormat = '%.0f';
            app.mergeDistance.ValueChangedFcn = createCallbackFcn(app, @File_ParameterValueChanged, true);
            app.mergeDistance.FontSize = 11;
            app.mergeDistance.FontColor = [0.149 0.149 0.149];
            app.mergeDistance.Layout.Row = 4;
            app.mergeDistance.Layout.Column = 1;
            app.mergeDistance.Value = 100;

            % Create general_GraphicsLabel
            app.general_GraphicsLabel = uilabel(app.General_Grid);
            app.general_GraphicsLabel.VerticalAlignment = 'bottom';
            app.general_GraphicsLabel.FontSize = 10;
            app.general_GraphicsLabel.Layout.Row = 3;
            app.general_GraphicsLabel.Layout.Column = 3;
            app.general_GraphicsLabel.Text = 'GRÁFICO';

            % Create graphics_Refresh
            app.graphics_Refresh = uiimage(app.General_Grid);
            app.graphics_Refresh.ImageClickedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.graphics_Refresh.Visible = 'off';
            app.graphics_Refresh.Tooltip = {'Volta à configuração inicial'};
            app.graphics_Refresh.Layout.Row = 3;
            app.graphics_Refresh.Layout.Column = 4;
            app.graphics_Refresh.VerticalAlignment = 'bottom';
            app.graphics_Refresh.ImageSource = 'Refresh_18.png';

            % Create general_GraphicsPanel
            app.general_GraphicsPanel = uipanel(app.General_Grid);
            app.general_GraphicsPanel.Layout.Row = 4;
            app.general_GraphicsPanel.Layout.Column = [3 4];

            % Create general_GraphicsGrid
            app.general_GraphicsGrid = uigridlayout(app.general_GraphicsPanel);
            app.general_GraphicsGrid.ColumnWidth = {'1x', 70};
            app.general_GraphicsGrid.RowHeight = {22, 22, 27, 22, 42, 22};
            app.general_GraphicsGrid.RowSpacing = 5;
            app.general_GraphicsGrid.Padding = [10 10 10 5];
            app.general_GraphicsGrid.BackgroundColor = [1 1 1];

            % Create gpuTypeLabel
            app.gpuTypeLabel = uilabel(app.general_GraphicsGrid);
            app.gpuTypeLabel.VerticalAlignment = 'bottom';
            app.gpuTypeLabel.FontSize = 10;
            app.gpuTypeLabel.FontColor = [0.149 0.149 0.149];
            app.gpuTypeLabel.Layout.Row = 1;
            app.gpuTypeLabel.Layout.Column = [1 2];
            app.gpuTypeLabel.Text = 'Unidade gráfica:';

            % Create gpuType
            app.gpuType = uidropdown(app.general_GraphicsGrid);
            app.gpuType.Items = {'hardwarebasic', 'hardware', 'software'};
            app.gpuType.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.gpuType.FontSize = 11;
            app.gpuType.BackgroundColor = [1 1 1];
            app.gpuType.Layout.Row = 2;
            app.gpuType.Layout.Column = [1 2];
            app.gpuType.Value = 'hardware';

            % Create imgFormatLabel
            app.imgFormatLabel = uilabel(app.general_GraphicsGrid);
            app.imgFormatLabel.VerticalAlignment = 'bottom';
            app.imgFormatLabel.WordWrap = 'on';
            app.imgFormatLabel.FontSize = 10;
            app.imgFormatLabel.Layout.Row = 3;
            app.imgFormatLabel.Layout.Column = 1;
            app.imgFormatLabel.Text = 'Formato da imagem a ser criada no relatório:';

            % Create imgFormat
            app.imgFormat = uidropdown(app.general_GraphicsGrid);
            app.imgFormat.Items = {'jpeg', 'png'};
            app.imgFormat.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.imgFormat.FontSize = 11;
            app.imgFormat.BackgroundColor = [1 1 1];
            app.imgFormat.Layout.Row = 4;
            app.imgFormat.Layout.Column = 1;
            app.imgFormat.Value = 'jpeg';

            % Create imgResolutionLabel
            app.imgResolutionLabel = uilabel(app.general_GraphicsGrid);
            app.imgResolutionLabel.VerticalAlignment = 'bottom';
            app.imgResolutionLabel.WordWrap = 'on';
            app.imgResolutionLabel.FontSize = 10;
            app.imgResolutionLabel.Layout.Row = 3;
            app.imgResolutionLabel.Layout.Column = 2;
            app.imgResolutionLabel.Text = {'Resolução'; 'imagem (dpi):'};

            % Create imgResolution
            app.imgResolution = uidropdown(app.general_GraphicsGrid);
            app.imgResolution.Items = {'100', '120', '150', '200'};
            app.imgResolution.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.imgResolution.FontSize = 11;
            app.imgResolution.BackgroundColor = [1 1 1];
            app.imgResolution.Layout.Row = 4;
            app.imgResolution.Layout.Column = 2;
            app.imgResolution.Value = '120';

            % Create openAuxiliarAppAsDocked
            app.openAuxiliarAppAsDocked = uicheckbox(app.general_GraphicsGrid);
            app.openAuxiliarAppAsDocked.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.openAuxiliarAppAsDocked.Text = 'Modo DOCK: módulos auxiliares abertos na própria janela do appAnalise.';
            app.openAuxiliarAppAsDocked.WordWrap = 'on';
            app.openAuxiliarAppAsDocked.FontSize = 11;
            app.openAuxiliarAppAsDocked.Layout.Row = 5;
            app.openAuxiliarAppAsDocked.Layout.Column = [1 2];

            % Create openAuxiliarApp2Debug
            app.openAuxiliarApp2Debug = uicheckbox(app.general_GraphicsGrid);
            app.openAuxiliarApp2Debug.ValueChangedFcn = createCallbackFcn(app, @Graphics_ParameterValueChanged, true);
            app.openAuxiliarApp2Debug.Text = 'Modo DEBUG';
            app.openAuxiliarApp2Debug.FontSize = 11;
            app.openAuxiliarApp2Debug.Layout.Row = 6;
            app.openAuxiliarApp2Debug.Layout.Column = [1 2];

            % Create general_ElevationLabel
            app.general_ElevationLabel = uilabel(app.General_Grid);
            app.general_ElevationLabel.VerticalAlignment = 'bottom';
            app.general_ElevationLabel.FontSize = 10;
            app.general_ElevationLabel.Layout.Row = 5;
            app.general_ElevationLabel.Layout.Column = [3 4];
            app.general_ElevationLabel.Text = 'ELEVAÇÃO';

            % Create general_ElevationRefresh
            app.general_ElevationRefresh = uiimage(app.General_Grid);
            app.general_ElevationRefresh.ImageClickedFcn = createCallbackFcn(app, @Elevation_ParameterValueChanged, true);
            app.general_ElevationRefresh.Visible = 'off';
            app.general_ElevationRefresh.Layout.Row = 5;
            app.general_ElevationRefresh.Layout.Column = 4;
            app.general_ElevationRefresh.VerticalAlignment = 'bottom';
            app.general_ElevationRefresh.ImageSource = 'Refresh_18.png';

            % Create general_ElevationPanel
            app.general_ElevationPanel = uipanel(app.General_Grid);
            app.general_ElevationPanel.AutoResizeChildren = 'off';
            app.general_ElevationPanel.Layout.Row = 6;
            app.general_ElevationPanel.Layout.Column = [3 4];

            % Create general_ElevationGrid
            app.general_ElevationGrid = uigridlayout(app.general_ElevationPanel);
            app.general_ElevationGrid.ColumnWidth = {'1x', 70};
            app.general_ElevationGrid.RowHeight = {17, 22, 42};
            app.general_ElevationGrid.RowSpacing = 5;
            app.general_ElevationGrid.Padding = [10 10 10 5];
            app.general_ElevationGrid.BackgroundColor = [1 1 1];

            % Create ElevationAPIServerLabel
            app.ElevationAPIServerLabel = uilabel(app.general_ElevationGrid);
            app.ElevationAPIServerLabel.VerticalAlignment = 'bottom';
            app.ElevationAPIServerLabel.FontSize = 10;
            app.ElevationAPIServerLabel.Layout.Row = 1;
            app.ElevationAPIServerLabel.Layout.Column = 1;
            app.ElevationAPIServerLabel.Text = 'Fonte:';

            % Create ElevationAPIServer
            app.ElevationAPIServer = uidropdown(app.general_ElevationGrid);
            app.ElevationAPIServer.Items = {'Open-Elevation', 'MathWorks WMS Server'};
            app.ElevationAPIServer.ValueChangedFcn = createCallbackFcn(app, @Elevation_ParameterValueChanged, true);
            app.ElevationAPIServer.FontSize = 11;
            app.ElevationAPIServer.BackgroundColor = [1 1 1];
            app.ElevationAPIServer.Layout.Row = 2;
            app.ElevationAPIServer.Layout.Column = 1;
            app.ElevationAPIServer.Value = 'MathWorks WMS Server';

            % Create ElevationNPointsLabel
            app.ElevationNPointsLabel = uilabel(app.general_ElevationGrid);
            app.ElevationNPointsLabel.VerticalAlignment = 'bottom';
            app.ElevationNPointsLabel.FontSize = 10;
            app.ElevationNPointsLabel.Layout.Row = 1;
            app.ElevationNPointsLabel.Layout.Column = 2;
            app.ElevationNPointsLabel.Text = 'Pontos enlace:';

            % Create ElevationNPoints
            app.ElevationNPoints = uidropdown(app.general_ElevationGrid);
            app.ElevationNPoints.Items = {'64', '128', '256', '512', '1024'};
            app.ElevationNPoints.ValueChangedFcn = createCallbackFcn(app, @Elevation_ParameterValueChanged, true);
            app.ElevationNPoints.FontSize = 11;
            app.ElevationNPoints.BackgroundColor = [1 1 1];
            app.ElevationNPoints.Layout.Row = 2;
            app.ElevationNPoints.Layout.Column = 2;
            app.ElevationNPoints.Value = '256';

            % Create ElevationForceSearch
            app.ElevationForceSearch = uicheckbox(app.general_ElevationGrid);
            app.ElevationForceSearch.ValueChangedFcn = createCallbackFcn(app, @Elevation_ParameterValueChanged, true);
            app.ElevationForceSearch.Text = 'Força consulta ao servidor (ignorando eventual informação em cache).';
            app.ElevationForceSearch.WordWrap = 'on';
            app.ElevationForceSearch.FontSize = 11;
            app.ElevationForceSearch.Layout.Row = 3;
            app.ElevationForceSearch.Layout.Column = [1 2];

            % Create APIFiscaliza_Grid
            app.APIFiscaliza_Grid = uigridlayout(app.Document);
            app.APIFiscaliza_Grid.ColumnWidth = {'1x', 20};
            app.APIFiscaliza_Grid.RowHeight = {27, 5, 68, 15, 12, 5, '1x', 1};
            app.APIFiscaliza_Grid.RowSpacing = 0;
            app.APIFiscaliza_Grid.Padding = [0 0 0 0];
            app.APIFiscaliza_Grid.Layout.Row = [1 2];
            app.APIFiscaliza_Grid.Layout.Column = 3;
            app.APIFiscaliza_Grid.BackgroundColor = [1 1 1];

            % Create config_FiscalizaVersionLabel
            app.config_FiscalizaVersionLabel = uilabel(app.APIFiscaliza_Grid);
            app.config_FiscalizaVersionLabel.VerticalAlignment = 'bottom';
            app.config_FiscalizaVersionLabel.FontSize = 10;
            app.config_FiscalizaVersionLabel.Layout.Row = 1;
            app.config_FiscalizaVersionLabel.Layout.Column = 1;
            app.config_FiscalizaVersionLabel.Text = 'API FISCALIZA';

            % Create config_FiscalizaVersion
            app.config_FiscalizaVersion = uibuttongroup(app.APIFiscaliza_Grid);
            app.config_FiscalizaVersion.SelectionChangedFcn = createCallbackFcn(app, @config_FiscalizaMode, true);
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
            app.config_DefaultIssueValuesLabel = uilabel(app.APIFiscaliza_Grid);
            app.config_DefaultIssueValuesLabel.VerticalAlignment = 'bottom';
            app.config_DefaultIssueValuesLabel.FontSize = 10;
            app.config_DefaultIssueValuesLabel.Layout.Row = [4 5];
            app.config_DefaultIssueValuesLabel.Layout.Column = 1;
            app.config_DefaultIssueValuesLabel.Text = 'VALORES PADRÕES DE CAMPOS DA INSPEÇÃO';

            % Create config_DefaultIssueValuesLock
            app.config_DefaultIssueValuesLock = uiimage(app.APIFiscaliza_Grid);
            app.config_DefaultIssueValuesLock.ImageClickedFcn = createCallbackFcn(app, @config_FiscalizaUnlockEdition, true);
            app.config_DefaultIssueValuesLock.Layout.Row = [5 6];
            app.config_DefaultIssueValuesLock.Layout.Column = 2;
            app.config_DefaultIssueValuesLock.ImageSource = 'lockClose_18Gray.png';

            % Create config_DefaultIssueValuesPanel
            app.config_DefaultIssueValuesPanel = uipanel(app.APIFiscaliza_Grid);
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
            app.config_CadastroSTEL.ValueChangedFcn = createCallbackFcn(app, @config_FiscalizaDefaultValueChanged, true);
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
            app.config_GerarPLAI.ValueChangedFcn = createCallbackFcn(app, @config_FiscalizaDefaultValueChanged, true);
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
            app.config_TipoPLAI.ValueChangedFcn = createCallbackFcn(app, @config_FiscalizaDefaultValueChanged, true);
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

            % Assign Checked Nodes
            app.config_MotivoLAI.CheckedNodesChangedFcn = createCallbackFcn(app, @config_FiscalizaDefaultValueChanged, true);

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

            % Assign Checked Nodes
            app.config_ServicoInspecao.CheckedNodesChangedFcn = createCallbackFcn(app, @config_FiscalizaDefaultValueChanged, true);

            % Create Folders_Grid
            app.Folders_Grid = uigridlayout(app.Document);
            app.Folders_Grid.ColumnWidth = {'1x'};
            app.Folders_Grid.RowHeight = {27, 5, '1x', 1};
            app.Folders_Grid.RowSpacing = 0;
            app.Folders_Grid.Padding = [0 0 0 0];
            app.Folders_Grid.Layout.Row = [1 2];
            app.Folders_Grid.Layout.Column = 4;
            app.Folders_Grid.BackgroundColor = [1 1 1];

            % Create config_FolderMapLabel
            app.config_FolderMapLabel = uilabel(app.Folders_Grid);
            app.config_FolderMapLabel.VerticalAlignment = 'bottom';
            app.config_FolderMapLabel.FontSize = 10;
            app.config_FolderMapLabel.Layout.Row = 1;
            app.config_FolderMapLabel.Layout.Column = 1;
            app.config_FolderMapLabel.Text = 'MAPEAMENTO DE PASTAS';

            % Create config_FolderMapPanel
            app.config_FolderMapPanel = uipanel(app.Folders_Grid);
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
            app.config_Folder_DataHubGETButton.ImageClickedFcn = createCallbackFcn(app, @config_getFolder, true);
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
            app.config_Folder_DataHubPOSTButton.ImageClickedFcn = createCallbackFcn(app, @config_getFolder, true);
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
            app.config_Folder_pythonPathButton.ImageClickedFcn = createCallbackFcn(app, @config_getFolder, true);
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
            app.config_Folder_userPath = uieditfield(app.config_FolderMapGrid, 'text');
            app.config_Folder_userPath.Editable = 'off';
            app.config_Folder_userPath.FontSize = 11;
            app.config_Folder_userPath.Layout.Row = 8;
            app.config_Folder_userPath.Layout.Column = 1;

            % Create config_Folder_userPathButton
            app.config_Folder_userPathButton = uiimage(app.config_FolderMapGrid);
            app.config_Folder_userPathButton.ImageClickedFcn = createCallbackFcn(app, @config_getFolder, true);
            app.config_Folder_userPathButton.Tag = 'userPath';
            app.config_Folder_userPathButton.Layout.Row = 8;
            app.config_Folder_userPathButton.Layout.Column = 2;
            app.config_Folder_userPathButton.ImageSource = 'OpenFile_36x36.png';

            % Create tool_LeftPanelVisibility
            app.tool_LeftPanelVisibility = uiimage(app.GridLayout);
            app.tool_LeftPanelVisibility.ImageClickedFcn = createCallbackFcn(app, @tool_LeftPanelVisibilityClicked, true);
            app.tool_LeftPanelVisibility.Layout.Row = 3;
            app.tool_LeftPanelVisibility.Layout.Column = 1;
            app.tool_LeftPanelVisibility.ImageSource = 'ArrowLeft_32.png';

            % Create tool_FiscalizaButton
            app.tool_FiscalizaButton = uiimage(app.GridLayout);
            app.tool_FiscalizaButton.ImageClickedFcn = createCallbackFcn(app, @tool_FiscalizaButtonPushed, true);
            app.tool_FiscalizaButton.Enable = 'off';
            app.tool_FiscalizaButton.Tooltip = {'Atualiza biblioteca fiscaliza'};
            app.tool_FiscalizaButton.Layout.Row = 3;
            app.tool_FiscalizaButton.Layout.Column = 2;
            app.tool_FiscalizaButton.ImageSource = 'Redmine_32.png';

            % Create tool_RFDataHubButton
            app.tool_RFDataHubButton = uiimage(app.GridLayout);
            app.tool_RFDataHubButton.ImageClickedFcn = createCallbackFcn(app, @tool_RFDataHubButtonPushed, true);
            app.tool_RFDataHubButton.Enable = 'off';
            app.tool_RFDataHubButton.Tooltip = {'Atualiza RFDataHub'};
            app.tool_RFDataHubButton.Layout.Row = 3;
            app.tool_RFDataHubButton.Layout.Column = 3;
            app.tool_RFDataHubButton.ImageSource = 'mosaic_32.png';

            % Create jsBackDoor
            app.jsBackDoor = uihtml(app.GridLayout);
            app.jsBackDoor.Layout.Row = 3;
            app.jsBackDoor.Layout.Column = 5;

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
