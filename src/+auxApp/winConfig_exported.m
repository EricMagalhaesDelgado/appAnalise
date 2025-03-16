classdef winConfig_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        GridLayout                    matlab.ui.container.GridLayout
        jsBackDoor                    matlab.ui.control.HTML
        tool_RFDataHubButton          matlab.ui.control.Image
        tool_FiscalizaButton          matlab.ui.control.Image
        tool_LeftPanelVisibility      matlab.ui.control.Image
        Document                      matlab.ui.container.GridLayout
        Folders_Grid                  matlab.ui.container.GridLayout
        FolderMapPanel                matlab.ui.container.Panel
        FolderMapGrid                 matlab.ui.container.GridLayout
        tempPath                      matlab.ui.control.EditField
        tempPathLabel                 matlab.ui.control.Label
        userPathButton                matlab.ui.control.Image
        userPath                      matlab.ui.control.EditField
        userPathLabel                 matlab.ui.control.Label
        pythonPathButton              matlab.ui.control.Image
        pythonPath                    matlab.ui.control.EditField
        pythonPathLabel               matlab.ui.control.Label
        DataHubPOSTButton             matlab.ui.control.Image
        DataHubPOST                   matlab.ui.control.EditField
        DataHubPOSTLabel              matlab.ui.control.Label
        DataHubGETButton              matlab.ui.control.Image
        DataHubGET                    matlab.ui.control.EditField
        DataHubGETLabel               matlab.ui.control.Label
        config_FolderMapLabel         matlab.ui.control.Label
        APIFiscaliza_Grid             matlab.ui.container.GridLayout
        config_FiscalizaVersion       matlab.ui.container.ButtonGroup
        config_FiscalizaHM            matlab.ui.control.RadioButton
        config_FiscalizaPD            matlab.ui.control.RadioButton
        config_FiscalizaVersionLabel  matlab.ui.control.Label
        General_Grid                  matlab.ui.container.GridLayout
        general_ElevationPanel        matlab.ui.container.Panel
        general_ElevationGrid         matlab.ui.container.GridLayout
        ElevationForceSearch          matlab.ui.control.CheckBox
        ElevationNPoints              matlab.ui.control.DropDown
        ElevationNPointsLabel         matlab.ui.control.Label
        ElevationAPIServer            matlab.ui.control.DropDown
        ElevationAPIServerLabel       matlab.ui.control.Label
        general_ElevationRefresh      matlab.ui.control.Image
        general_ElevationLabel        matlab.ui.control.Label
        general_GraphicsPanel         matlab.ui.container.Panel
        general_GraphicsGrid          matlab.ui.container.GridLayout
        openAuxiliarApp2Debug         matlab.ui.control.CheckBox
        openAuxiliarAppAsDocked       matlab.ui.control.CheckBox
        imgResolution                 matlab.ui.control.DropDown
        imgResolutionLabel            matlab.ui.control.Label
        imgFormat                     matlab.ui.control.DropDown
        imgFormatLabel                matlab.ui.control.Label
        gpuType                       matlab.ui.control.DropDown
        gpuTypeLabel                  matlab.ui.control.Label
        graphics_Refresh              matlab.ui.control.Image
        general_GraphicsLabel         matlab.ui.control.Label
        general_FilePanel             matlab.ui.container.Panel
        general_FileGrid              matlab.ui.container.GridLayout
        mergeDistance                 matlab.ui.control.Spinner
        mergeLabel2                   matlab.ui.control.Label
        mergeAntenna                  matlab.ui.control.CheckBox
        mergeDataType                 matlab.ui.control.CheckBox
        mergeLabel1                   matlab.ui.control.Label
        general_mergeRefresh          matlab.ui.control.Image
        general_FileLabel             matlab.ui.control.Label
        general_AppVersionPanel       matlab.ui.container.Panel
        general_AppVersionGrid        matlab.ui.container.GridLayout
        AppVersion                    matlab.ui.control.HTML
        general_AppVersionRefresh     matlab.ui.control.Image
        general_AppVersionLabel       matlab.ui.control.Label
        LeftPanel                     matlab.ui.container.Panel
        LeftPanelGrid                 matlab.ui.container.GridLayout
        LeftPanelRadioGroup           matlab.ui.container.ButtonGroup
        btnFolder                     matlab.ui.control.RadioButton
        btnFiscaliza                  matlab.ui.control.RadioButton
        btnGeneral                    matlab.ui.control.RadioButton
        LeftPanelTitle                matlab.ui.container.GridLayout
        menuUnderline                 matlab.ui.control.Image
        menu_ButtonGrid               matlab.ui.container.GridLayout
        menu_ButtonIcon               matlab.ui.control.Image
        menu_ButtonLabel              matlab.ui.control.Label
    end

    
    properties
        %-----------------------------------------------------------------%
        Container
        isDocked = false
        
        mainApp
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
        DefaultValues = struct('File',      struct('DataType', true, 'DataTypeLabel', 'remove', 'Antenna', true, 'AntennaLabel', 'remove', 'AntennaAttributes', {{'Name', 'Azimuth', 'Elevation', 'Polarization', 'Height', 'SwitchPort', 'LNBChannel'}}, 'Distance', 100), ...
                               'Graphics',  struct('openGL', 'hardware', 'Format', 'jpeg', 'Resolution', '120', 'Dock', true),                                                                                                                                              ...
                               'Elevation', struct('Points', '256', 'ForceSearch', false, 'Server', 'Open-Elevation'))
    end
    

    methods (Access = private)
        %-----------------------------------------------------------------%
        % JSBACKDOOR
        %-----------------------------------------------------------------%
        function jsBackDoor_Initialization(app)
            if app.isDocked
                delete(app.jsBackDoor)
                app.jsBackDoor = app.mainApp.jsBackDoor;
            else
                app.jsBackDoor.HTMLSource = appUtil.jsBackDoorHTMLSource();
            end            
        end

        %-----------------------------------------------------------------%
        function jsBackDoor_Customizations(app)
            if app.isDocked
                app.progressDialog = app.mainApp.progressDialog;
            else
                app.progressDialog = ccTools.ProgressDialog(app.jsBackDoor);
            end
        end
    end


    methods (Access = private)
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

            switch app.mainApp.executionMode
                case 'webApp'
                    app.general_AppVersionRefresh.Enable = 0;
                    app.openAuxiliarAppAsDocked.Enable   = 0;

                otherwise
                    if ~app.isDocked
                        appUtil.winMinSize(app.UIFigure, class.Constants.WindowMinSize('CONFIG'))
                    end
            end

            if isdeployed
                app.openAuxiliarApp2Debug.Enable = 0;
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
            if isempty(app.mainApp.General.AppVersion.fiscaliza)
                app.mainApp.General.AppVersion = util.getAppVersion(app.rootFolder, app.mainApp.entryPointFolder, app.mainApp.General.fileFolder.tempPath, 'full+Python');
            end
        end

        %-----------------------------------------------------------------%
        function AppVersion_updatePanel(app)
            % Versão
            htmlContent = auxApp.config.htmlCode_AppVersion(app.mainApp.General, app.mainApp.executionMode);
            app.AppVersion.HTMLSource = htmlContent;
        end

        %-----------------------------------------------------------------%
        function File_updatePanel(app)
            % Mesclagem de fluxos espectrais
            switch app.mainApp.General.Merge.DataType
                case 'keep';   app.mergeDataType.Value = 0;
                case 'remove'; app.mergeDataType.Value = 1;
            end

            switch app.mainApp.General.Merge.Antenna
                case 'keep';   app.mergeAntenna.Value = 0;
                case 'remove'; app.mergeAntenna.Value = 1;
            end

            app.mergeDistance.Value = app.mainApp.General.Merge.Distance;

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
            app.imgFormat.Value     = app.mainApp.General.Image.Format;
            app.imgResolution.Value = string(app.mainApp.General.Image.Resolution);

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
            app.openAuxiliarAppAsDocked.Value = app.mainApp.General.operationMode.Dock;
            app.openAuxiliarApp2Debug.Value   = app.mainApp.General.operationMode.Debug;

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
            app.ElevationNPoints.Value     = num2str(app.mainApp.General.Elevation.Points);
            app.ElevationForceSearch.Value = app.mainApp.General.Elevation.ForceSearch;
            app.ElevationAPIServer.Value   = app.mainApp.General.Elevation.Server;

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
            switch app.mainApp.General.fiscaliza.systemVersion
                case 'PROD'
                    app.config_FiscalizaPD.Value = 1;
                case 'HOM'
                    app.config_FiscalizaHM.Value = 1;
            end
        end

        %-----------------------------------------------------------------%
        function Folder_updatePanel(app)
            % Na versão webapp, a configuração das pastas não é habilitada.

            switch app.mainApp.executionMode
                case 'webApp'
                    app.btnFolder.Enable = 0;

                otherwise
                    % DataHub
                    DataHub_GET  = app.mainApp.General.fileFolder.DataHub_GET;
                    DataHub_POST = app.mainApp.General.fileFolder.DataHub_POST;
                    if isfolder(DataHub_GET)
                        app.DataHubGET.Value  = DataHub_GET;
                    end
        
                    if isfolder(DataHub_POST)
                        app.DataHubPOST.Value = DataHub_POST;
                    end
        
                    % Python
                    pyPath = app.mainApp.General.fileFolder.pythonPath;
                    if isfile(pyPath)
                        app.pythonPath.Value = pyPath;
                    else
                        pyEnv = pyenv;
                        app.pythonPath.Value = pyEnv.Executable;
                    end
    
                    % userPath & tempPath
                    app.userPath.Value = app.mainApp.General.fileFolder.userPath;
                    app.tempPath.Value = app.mainApp.General.fileFolder.tempPath;
            end
        end

        %-----------------------------------------------------------------%
        function saveGeneralSettings(app)
            appUtil.generalSettingsSave(class.Constants.appName, app.rootFolder, app.mainApp.General_I, app.mainApp.executionMode)
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

            app.mainApp    = mainapp;
            app.rootFolder = app.mainApp.rootFolder;

            jsBackDoor_Initialization(app)
            LeftPanelRadioGroupSelectionChanged(app)

            if app.isDocked
                app.GridLayout.Padding(4) = 19;
                startup_Controller(app)
            else
                appUtil.winPosition(app.UIFigure)
                startup_timerCreation(app)
            end
            
        end

        % Close request function: UIFigure
        function closeFcn(app, event)
            
            ipcMainMatlabCallsHandler(app.mainApp, app, 'closeFcn', 'CONFIG')
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
            
            if strcmp(app.mainApp.General.AppVersion.fiscaliza, app.stableVersion.fiscaliza)
                app.tool_FiscalizaButton.Enable = 0;
                appUtil.modalWindow(app.UIFigure, 'warning', 'Módulo fiscaliza já atualizado!');
                return
            end

            app.progressDialog.Visible = 'visible';

            try
                Python = pyenv;
                system(sprintf('"%s" %s', fullfile(Python.Home, 'Scripts', 'pip'), sprintf('install fiscaliza==%s', app.stableVersion.fiscaliza)));

                app.mainApp.General.AppVersion.fiscaliza = app.stableVersion.fiscaliza;
                app.tool_FiscalizaButton.Enable = 0;

                Layout(app)

            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', ME.message);
            end

            app.progressDialog.Visible = 'hidden';

        end

        % Image clicked function: tool_RFDataHubButton
        function tool_RFDataHubButtonPushed(app, event)
            
            if isequal(app.mainApp.General.AppVersion.rfDataHub,  app.stableVersion.rfDataHub)
                app.tool_RFDataHubButton.Enable = 0;
                appUtil.modalWindow(app.UIFigure, 'warning', 'Módulo RFDataHub já atualizado!');
                return
            end

            d = appUtil.modalWindow(app.UIFigure, "progressdlg", 'Em andamento... esse processo pode demorar alguns minutos!');

            try
                appName  = class.Constants.appName;
                rfDataHubLink = util.publicLink(appName, app.rootFolder, 'RFDataHub');
                model.RFDataHub.update(appName, app.rootFolder, app.mainApp.General.fileFolder.tempPath, rfDataHubLink)

                % Atualiza versão.
                global RFDataHub_info

                app.mainApp.General.AppVersion.rfDataHub = RFDataHub_info;
                app.stableVersion.rfDataHub = RFDataHub_info;
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

            [htmlContent, app.stableVersion, updatedModule] = auxApp.config.htmlCode_CheckAvailableUpdate(app.mainApp.General, app.rootFolder);
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
                                
                    app.mainApp.General.Merge.DataType = DataTypeStatus;
                    app.mainApp.General.Merge.Antenna  = AntennaStatus;
                    app.mainApp.General.Merge.Distance = app.mergeDistance.Value;

                %---------------------------------------------------------%
                case app.general_mergeRefresh
                    app.mainApp.General.Merge = struct('DataType',           app.DefaultValues.File.DataTypeLabel,      ...
                                                       'Antenna',            app.DefaultValues.File.AntennaLabel,       ...
                                                       'AntennaAttributes', {app.DefaultValues.File.AntennaAttributes}, ...
                                                       'Distance',           app.DefaultValues.File.Distance);
            end

            app.mainApp.General_I.Merge = app.mainApp.General.Merge;            
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
                        
                        app.mainApp.General.openGL = app.gpuType.Value;
                        app.mainApp.General.AppVersion.openGL = rmfield(graphRender, {'MaxTextureSize', 'Visual', 'SupportsGraphicsSmoothing', 'SupportsDepthPeelTransparency', 'SupportsAlignVertexCenters', 'Extensions', 'MaxFrameBufferSize'});
                    end

                case {app.imgFormat, app.imgResolution}
                    app.mainApp.General.Image = struct('Format', app.imgFormat.Value, 'Resolution', str2double(app.imgResolution.Value));

                case app.openAuxiliarAppAsDocked
                    app.mainApp.General.operationMode.Dock = app.openAuxiliarAppAsDocked.Value;

                case app.openAuxiliarApp2Debug
                    app.mainApp.General.operationMode.Debug = app.openAuxiliarApp2Debug.Value;

                case app.graphics_Refresh
                    if ~strcmp(app.gpuType.Value, app.DefaultValues.Graphics.openGL)
                        app.gpuType.Value = app.DefaultValues.Graphics.openGL;
                        Graphics_ParameterValueChanged(app, struct('Source', app.gpuType))
                    end

                    app.mainApp.General.Image = struct('Format', app.DefaultValues.Graphics.Format, 'Resolution', app.DefaultValues.Graphics.Resolution);
                    app.mainApp.General.operationMode.Dock  = app.DefaultValues.Graphics.Dock;
            end

            app.mainApp.General_I.openGL        = app.mainApp.General.openGL;
            app.mainApp.General_I.Image         = app.mainApp.General.Image;
            app.mainApp.General_I.operationMode = app.mainApp.General.operationMode;
            saveGeneralSettings(app)
            Graphics_updatePanel(app)

        end

        % Callback function: ElevationAPIServer, ElevationForceSearch, 
        % ...and 2 other components
        function Elevation_ParameterValueChanged(app, event)

            switch event.Source
                case app.ElevationNPoints
                    app.mainApp.General.Elevation.Points      = str2double(app.ElevationNPoints.Value);

                case app.ElevationForceSearch
                    app.mainApp.General.Elevation.ForceSearch = app.ElevationForceSearch.Value;

                case app.ElevationAPIServer
                    app.mainApp.General.Elevation.Server      = app.ElevationAPIServer.Value;

                case app.general_ElevationRefresh
                    app.mainApp.General.Elevation = struct('Points',      str2double(app.DefaultValues.Elevation.Points), ...
                                                              'ForceSearch', app.DefaultValues.Elevation.ForceSearch,        ...
                                                              'Server',      app.DefaultValues.Elevation.Server);
            end

            app.mainApp.General_I.Elevation = app.mainApp.General.Elevation;
            saveGeneralSettings(app)
            Elevation_updatePanel(app)
            
        end

        % Selection changed function: config_FiscalizaVersion
        function config_FiscalizaMode(app, event)
            
            selectedButton = app.config_FiscalizaVersion.SelectedObject;
            switch selectedButton
                case app.config_FiscalizaPD
                    app.mainApp.General.fiscaliza.systemVersion = 'PROD';
                case app.config_FiscalizaHM
                    app.mainApp.General.fiscaliza.systemVersion = 'HOM';
            end

            app.mainApp.General_I.fiscaliza = app.mainApp.General.fiscaliza;
            saveGeneralSettings(app)
            ipcMainMatlabCallsHandler(app.mainApp, app, 'FiscalizaModeChanged')
            
        end

        % Image clicked function: DataHubGETButton, DataHubPOSTButton, 
        % ...and 2 other components
        function Folder_ButtonPushed(app, event)
            
            try
                relatedFolder = eval(sprintf('app.config_Folder_%s.Value', event.Source.Tag));                    
            catch
                relatedFolder = app.mainApp.General.fileFolder.(event.Source.Tag);
            end
            
            if isfolder(relatedFolder)
                initialFolder = relatedFolder;
            elseif isfile(relatedFolder)
                initialFolder = fileparts(relatedFolder);
            else
                initialFolder = app.userPath.Value;
            end
            
            selectedFolder = uigetdir(initialFolder);
            figure(app.UIFigure)

            if selectedFolder
                switch event.Source
                    case app.DataHubGETButton
                        if strcmp(app.mainApp.General.fileFolder.DataHub_GET, selectedFolder) 
                            return
                        else
                            appName  = class.Constants.appName;
                            repoName = 'DataHub - GET';

                            if all(cellfun(@(x) contains(selectedFolder, x, "IgnoreCase", true), {repoName, appName})) || contains(selectedFolder, appName, "IgnoreCase", true)
                                % .\OneDrive - ANATEL\DataHub - GET\appAnalise
                                % .\OneDrive - ANATEL\Inova Fiscaliza - appAnalise
                                % .\OneDrive - ANATEL\appAnalise

                                app.DataHubGET.Value = selectedFolder;
                                app.mainApp.General.fileFolder.DataHub_GET = selectedFolder;
                            else
                                appUtil.modalWindow(app.UIFigure, 'error', sprintf('Não identificado se tratar da pasta "%s" do repositório "%s".', appName, repoName));
                                return
                            end
                        end

                    case app.DataHubPOSTButton
                        if strcmp(app.mainApp.General.fileFolder.DataHub_POST, selectedFolder) 
                            return
                        else
                            appName  = class.Constants.appName;
                            repoName = 'DataHub - POST';

                            if all(cellfun(@(x) contains(selectedFolder, x, "IgnoreCase", true), {repoName, appName})) || contains(selectedFolder, appName, "IgnoreCase", true)
                                app.DataHubPOST.Value = selectedFolder;
                                app.mainApp.General.fileFolder.DataHub_POST = selectedFolder;
                            else
                                appUtil.modalWindow(app.UIFigure, 'error', sprintf('Não identificado se tratar da pasta "%s" do repositório "%s".', appName, repoName));
                                return
                            end
                        end

                    case app.pythonPathButton
                        pyPath = fullfile(selectedFolder, ccTools.fcn.OperationSystem('pythonExecutable'));
                        if isfile(pyPath)
                            app.progressDialog.Visible = 'visible';

                            try
                                pyenv('Version', pyPath);
                                app.mainApp.General.fileFolder.pythonPath = pyPath;

                            catch ME
                                appUtil.modalWindow(app.UIFigure, 'error', 'O <i>app</i> deverá ser reinicializado para que a alteração tenha efeito.');
                            end

                            app.progressDialog.Visible = 'hidden';

                        else
                            appUtil.modalWindow(app.UIFigure, 'error', 'Não encontrado o arquivo executável do Python.');
                            return
                        end

                    case app.userPathButton
                        app.userPath.Value = selectedFolder;
                        app.mainApp.General.fileFolder.userPath = selectedFolder;
                end

                app.mainApp.General_I.fileFolder = app.mainApp.General.fileFolder;
                saveGeneralSettings(app)
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
                if ~isprop(Container, 'RunningAppInstance')
                    addprop(app.Container, 'RunningAppInstance');
                end
                app.Container.RunningAppInstance = app;
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
            app.Document.ColumnWidth = {320, 0, 0, '1x'};
            app.Document.RowHeight = {26, '1x'};
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
            app.config_FiscalizaVersion.Layout.Row = [3 8];
            app.config_FiscalizaVersion.Layout.Column = [1 2];

            % Create config_FiscalizaPD
            app.config_FiscalizaPD = uiradiobutton(app.config_FiscalizaVersion);
            app.config_FiscalizaPD.Text = 'FISCALIZA PRODUÇÃO';
            app.config_FiscalizaPD.FontSize = 11;
            app.config_FiscalizaPD.Position = [10 552 146 22];

            % Create config_FiscalizaHM
            app.config_FiscalizaHM = uiradiobutton(app.config_FiscalizaVersion);
            app.config_FiscalizaHM.Text = 'FISCALIZA <font style="color: red;">HOMOLOGAÇÃO</font> (versão destinada a testes)';
            app.config_FiscalizaHM.FontSize = 11;
            app.config_FiscalizaHM.Interpreter = 'html';
            app.config_FiscalizaHM.Position = [10 526 310 22];
            app.config_FiscalizaHM.Value = true;

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

            % Create FolderMapPanel
            app.FolderMapPanel = uipanel(app.Folders_Grid);
            app.FolderMapPanel.AutoResizeChildren = 'off';
            app.FolderMapPanel.Layout.Row = 3;
            app.FolderMapPanel.Layout.Column = 1;

            % Create FolderMapGrid
            app.FolderMapGrid = uigridlayout(app.FolderMapPanel);
            app.FolderMapGrid.ColumnWidth = {'1x', 20};
            app.FolderMapGrid.RowHeight = {17, 22, 17, 22, 17, 22, 17, 22, 17, 22, '1x'};
            app.FolderMapGrid.ColumnSpacing = 5;
            app.FolderMapGrid.RowSpacing = 5;
            app.FolderMapGrid.BackgroundColor = [1 1 1];

            % Create DataHubGETLabel
            app.DataHubGETLabel = uilabel(app.FolderMapGrid);
            app.DataHubGETLabel.VerticalAlignment = 'bottom';
            app.DataHubGETLabel.FontSize = 10;
            app.DataHubGETLabel.Layout.Row = 1;
            app.DataHubGETLabel.Layout.Column = 1;
            app.DataHubGETLabel.Text = 'DataHub - GET:';

            % Create DataHubGET
            app.DataHubGET = uieditfield(app.FolderMapGrid, 'text');
            app.DataHubGET.Editable = 'off';
            app.DataHubGET.FontSize = 11;
            app.DataHubGET.Layout.Row = 2;
            app.DataHubGET.Layout.Column = 1;

            % Create DataHubGETButton
            app.DataHubGETButton = uiimage(app.FolderMapGrid);
            app.DataHubGETButton.ImageClickedFcn = createCallbackFcn(app, @Folder_ButtonPushed, true);
            app.DataHubGETButton.Tag = 'DataHub_GET';
            app.DataHubGETButton.Layout.Row = 2;
            app.DataHubGETButton.Layout.Column = 2;
            app.DataHubGETButton.ImageSource = 'OpenFile_36x36.png';

            % Create DataHubPOSTLabel
            app.DataHubPOSTLabel = uilabel(app.FolderMapGrid);
            app.DataHubPOSTLabel.VerticalAlignment = 'bottom';
            app.DataHubPOSTLabel.FontSize = 10;
            app.DataHubPOSTLabel.Layout.Row = 3;
            app.DataHubPOSTLabel.Layout.Column = 1;
            app.DataHubPOSTLabel.Text = 'DataHub - POST:';

            % Create DataHubPOST
            app.DataHubPOST = uieditfield(app.FolderMapGrid, 'text');
            app.DataHubPOST.Editable = 'off';
            app.DataHubPOST.FontSize = 11;
            app.DataHubPOST.Layout.Row = 4;
            app.DataHubPOST.Layout.Column = 1;

            % Create DataHubPOSTButton
            app.DataHubPOSTButton = uiimage(app.FolderMapGrid);
            app.DataHubPOSTButton.ImageClickedFcn = createCallbackFcn(app, @Folder_ButtonPushed, true);
            app.DataHubPOSTButton.Tag = 'DataHub_POST';
            app.DataHubPOSTButton.Layout.Row = 4;
            app.DataHubPOSTButton.Layout.Column = 2;
            app.DataHubPOSTButton.ImageSource = 'OpenFile_36x36.png';

            % Create pythonPathLabel
            app.pythonPathLabel = uilabel(app.FolderMapGrid);
            app.pythonPathLabel.VerticalAlignment = 'bottom';
            app.pythonPathLabel.FontSize = 10;
            app.pythonPathLabel.Layout.Row = 5;
            app.pythonPathLabel.Layout.Column = 1;
            app.pythonPathLabel.Text = 'Pasta do ambiente virtual Python (lib fiscaliza):';

            % Create pythonPath
            app.pythonPath = uieditfield(app.FolderMapGrid, 'text');
            app.pythonPath.Editable = 'off';
            app.pythonPath.FontSize = 11;
            app.pythonPath.Layout.Row = 6;
            app.pythonPath.Layout.Column = 1;

            % Create pythonPathButton
            app.pythonPathButton = uiimage(app.FolderMapGrid);
            app.pythonPathButton.ImageClickedFcn = createCallbackFcn(app, @Folder_ButtonPushed, true);
            app.pythonPathButton.Tag = 'pythonPath';
            app.pythonPathButton.Layout.Row = 6;
            app.pythonPathButton.Layout.Column = 2;
            app.pythonPathButton.ImageSource = 'OpenFile_36x36.png';

            % Create userPathLabel
            app.userPathLabel = uilabel(app.FolderMapGrid);
            app.userPathLabel.VerticalAlignment = 'bottom';
            app.userPathLabel.FontSize = 10;
            app.userPathLabel.Layout.Row = 7;
            app.userPathLabel.Layout.Column = 1;
            app.userPathLabel.Text = 'Pasta do usuário:';

            % Create userPath
            app.userPath = uieditfield(app.FolderMapGrid, 'text');
            app.userPath.Editable = 'off';
            app.userPath.FontSize = 11;
            app.userPath.Layout.Row = 8;
            app.userPath.Layout.Column = 1;

            % Create userPathButton
            app.userPathButton = uiimage(app.FolderMapGrid);
            app.userPathButton.ImageClickedFcn = createCallbackFcn(app, @Folder_ButtonPushed, true);
            app.userPathButton.Tag = 'userPath';
            app.userPathButton.Layout.Row = 8;
            app.userPathButton.Layout.Column = 2;
            app.userPathButton.ImageSource = 'OpenFile_36x36.png';

            % Create tempPathLabel
            app.tempPathLabel = uilabel(app.FolderMapGrid);
            app.tempPathLabel.VerticalAlignment = 'bottom';
            app.tempPathLabel.FontSize = 10;
            app.tempPathLabel.Layout.Row = 9;
            app.tempPathLabel.Layout.Column = 1;
            app.tempPathLabel.Text = 'Pasta temporária:';

            % Create tempPath
            app.tempPath = uieditfield(app.FolderMapGrid, 'text');
            app.tempPath.Editable = 'off';
            app.tempPath.FontSize = 11;
            app.tempPath.Layout.Row = 10;
            app.tempPath.Layout.Column = 1;

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
