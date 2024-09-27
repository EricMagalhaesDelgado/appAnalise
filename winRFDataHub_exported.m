classdef winRFDataHub_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        toolGrid                       matlab.ui.container.GridLayout
        tool_tableNRowsIcon            matlab.ui.control.Image
        tool_tableNRows                matlab.ui.control.Label
        jsBackDoor                     matlab.ui.control.HTML
        tool_ExportButton              matlab.ui.control.Image
        tool_Separator                 matlab.ui.control.Image
        tool_PDFButton                 matlab.ui.control.Image
        tool_RFLinkButton              matlab.ui.control.Image
        tool_TableVisibility           matlab.ui.control.Image
        tool_ControlPanelVisibility    matlab.ui.control.Image
        UITable                        matlab.ui.control.Table
        chReportUndock                 matlab.ui.control.Image
        chReportHotDownload            matlab.ui.control.Image
        chReportDownloadTime           matlab.ui.control.Label
        chReportHTML                   matlab.ui.control.HTML
        axesToolbarGrid                matlab.ui.container.GridLayout
        axesTool_RegionZoom            matlab.ui.control.Image
        axesTool_RestoreView           matlab.ui.control.Image
        plotPanel                      matlab.ui.container.Panel
        ControlTabGrid                 matlab.ui.container.GridLayout
        menu_MainGrid                  matlab.ui.container.GridLayout
        menu_Button3Grid               matlab.ui.container.GridLayout
        menu_Button3Icon               matlab.ui.control.Image
        menu_Button3Label              matlab.ui.control.Label
        menu_Button2Grid               matlab.ui.container.GridLayout
        menu_Button2Icon               matlab.ui.control.Image
        menu_Button2Label              matlab.ui.control.Label
        menu_Button1Grid               matlab.ui.container.GridLayout
        menu_Button1Icon               matlab.ui.control.Image
        menu_Button1Label              matlab.ui.control.Label
        menuUnderline                  matlab.ui.control.Image
        ControlTabGroup                matlab.ui.container.TabGroup
        Tab_1                          matlab.ui.container.Tab
        Tab1_Grid                      matlab.ui.container.GridLayout
        stationInfoPanel               matlab.ui.container.Panel
        stationInfoGrid                matlab.ui.container.GridLayout
        AntennaPatternPanelPlot        matlab.ui.container.Panel
        stationInfo                    matlab.ui.control.HTML
        referenceTX_Panel              matlab.ui.container.Panel
        referenceTX_Grid               matlab.ui.container.GridLayout
        referenceTX_Height             matlab.ui.control.NumericEditField
        referenceTX_HeightLabel        matlab.ui.control.Label
        referenceTX_Longitude          matlab.ui.control.NumericEditField
        referenceTX_LongitudeLabel     matlab.ui.control.Label
        referenceTX_Latitude           matlab.ui.control.NumericEditField
        referenceTX_LatitudeLabel      matlab.ui.control.Label
        referenceTX_EditionCancel      matlab.ui.control.Image
        referenceTX_EditionConfirm     matlab.ui.control.Image
        referenceTX_EditionMode        matlab.ui.control.Image
        referenceTX_Refresh            matlab.ui.control.Image
        referenceTX_Label              matlab.ui.control.Label
        referenceTX_Icon               matlab.ui.control.Image
        Tab_2                          matlab.ui.container.Tab
        Tab2_Grid                      matlab.ui.container.GridLayout
        filter_Tree                    matlab.ui.container.CheckBoxTree
        filter_AddImage                matlab.ui.control.Image
        filter_SecondaryValuePanel     matlab.ui.container.ButtonGroup
        filter_SecondaryValueSubpanel  matlab.ui.container.Panel
        filter_SecondaryValueGrid      matlab.ui.container.GridLayout
        filter_SecondaryLogicalOperator  matlab.ui.control.DropDown
        filter_SecondaryLogicalOperatorLabel  matlab.ui.control.Label
        filter_SecondaryReferenceFilter  matlab.ui.control.DropDown
        filter_SecondaryReferenceFilterLabel  matlab.ui.control.Label
        filter_SecondaryTextList       matlab.ui.control.DropDown
        filter_SecondaryTextFree       matlab.ui.control.EditField
        filter_SecondaryNumValue2      matlab.ui.control.NumericEditField
        filter_SecondaryNumSeparator   matlab.ui.control.Label
        filter_SecondaryNumValue1      matlab.ui.control.NumericEditField
        filter_SecondaryOperation10    matlab.ui.control.ToggleButton
        filter_SecondaryOperation9     matlab.ui.control.ToggleButton
        filter_SecondaryOperation8     matlab.ui.control.ToggleButton
        filter_SecondaryOperation7     matlab.ui.control.ToggleButton
        filter_SecondaryOperation6     matlab.ui.control.ToggleButton
        filter_SecondaryOperation5     matlab.ui.control.ToggleButton
        filter_SecondaryOperation4     matlab.ui.control.ToggleButton
        filter_SecondaryOperation3     matlab.ui.control.ToggleButton
        filter_SecondaryOperation2     matlab.ui.control.ToggleButton
        filter_SecondaryOperation1     matlab.ui.control.ToggleButton
        filter_SecondaryTypePanel      matlab.ui.container.ButtonGroup
        filter_SecondaryType13         matlab.ui.control.RadioButton
        filter_SecondaryType12         matlab.ui.control.RadioButton
        filter_SecondaryType11         matlab.ui.control.RadioButton
        filter_SecondaryType10         matlab.ui.control.RadioButton
        filter_SecondaryType9          matlab.ui.control.RadioButton
        filter_SecondaryType8          matlab.ui.control.RadioButton
        filter_SecondaryType7          matlab.ui.control.RadioButton
        filter_SecondaryType6          matlab.ui.control.RadioButton
        filter_SecondaryType5          matlab.ui.control.RadioButton
        filter_SecondaryType4          matlab.ui.control.RadioButton
        filter_SecondaryType3          matlab.ui.control.RadioButton
        filter_SecondaryType2          matlab.ui.control.RadioButton
        filter_SecondaryType1          matlab.ui.control.RadioButton
        filter_SecondaryLabel          matlab.ui.control.Label
        referenceRX_Panel              matlab.ui.container.Panel
        referenceRX_Grid               matlab.ui.container.GridLayout
        referenceRX_Height             matlab.ui.control.NumericEditField
        referenceRX_HeightLabel        matlab.ui.control.Label
        referenceRX_Longitude          matlab.ui.control.NumericEditField
        referenceRX_LongitudeLabel     matlab.ui.control.Label
        referenceRX_Latitude           matlab.ui.control.NumericEditField
        referenceRX_LatitudeLabel      matlab.ui.control.Label
        referenceRX_EditionCancel      matlab.ui.control.Image
        referenceRX_EditionConfirm     matlab.ui.control.Image
        referenceRX_EditionMode        matlab.ui.control.Image
        referenceRX_Refresh            matlab.ui.control.Image
        referenceRX_Label              matlab.ui.control.Label
        referenceRX_Icon               matlab.ui.control.Image
        Tab_3                          matlab.ui.container.Tab
        Tab3_Grid                      matlab.ui.container.GridLayout
        misc_ElevationSourcePanel      matlab.ui.container.Panel
        misc_ElevationSourceGrid       matlab.ui.container.GridLayout
        misc_PointsPerLink             matlab.ui.control.DropDown
        misc_PointsPerLinkLabel        matlab.ui.control.Label
        misc_ElevationAPISource        matlab.ui.control.DropDown
        misc_ElevationAPISourceLabel   matlab.ui.control.Label
        ELEVAOLabel                    matlab.ui.control.Label
        config_geoAxesPanel            matlab.ui.container.Panel
        config_geoAxesGrid             matlab.ui.container.GridLayout
        config_TX_DataTipVisibility    matlab.ui.control.DropDown
        config_Station_Size            matlab.ui.control.Slider
        config_Station_Color           matlab.ui.control.ColorPicker
        config_Station_Label           matlab.ui.control.Label
        config_RX_Size                 matlab.ui.control.Slider
        config_RX_Color                matlab.ui.control.ColorPicker
        config_RX_Label                matlab.ui.control.Label
        config_TX_Size                 matlab.ui.control.Slider
        config_TX_Color                matlab.ui.control.ColorPicker
        config_TX_Label                matlab.ui.control.Label
        config_geoAxesSubPanel         matlab.ui.container.Panel
        config_geoAxesSubGrid          matlab.ui.container.GridLayout
        config_Colormap                matlab.ui.control.DropDown
        config_ColormapLabel           matlab.ui.control.Label
        config_Basemap                 matlab.ui.control.DropDown
        config_BasemapLabel            matlab.ui.control.Label
        config_geoAxesSublabel         matlab.ui.control.Label
        config_Refresh                 matlab.ui.control.Image
        config_geoAxesLabel            matlab.ui.control.Label
        filter_ContextMenu             matlab.ui.container.ContextMenu
        filter_delButton               matlab.ui.container.Menu
        filter_delAllButton            matlab.ui.container.Menu
    end

    
    properties (Access = public)
        %-----------------------------------------------------------------%
        Container
        isDocked = false

        CallingApp
        General
        rootFolder

        % Essa propriedade registra o tipo de execução da aplicação, podendo
        % ser: 'built-in', 'desktopApp' ou 'webApp'.
        executionMode
        
        % Essa propriedade registra se o RFDataHub está em modo "standalone"
        % (true) ou como módulo do appAnalise (false).
        standaloneFlag

        % A função do timer é executada uma única vez após a renderização
        % da figura, lendo arquivos de configuração, iniciando modo de operação
        % paralelo etc. A ideia é deixar o MATLAB focar apenas na criação dos 
        % componentes essenciais da GUI (especificados em "createComponents"), 
        % mostrando a GUI para o usuário o mais rápido possível.
        timerObj

        % O MATLAB não renderiza alguns dos componentes de abas (do TabGroup) 
        % não visíveis. E a customização de componentes, usando a lib ccTools, 
        % somente é possível após a sua renderização. Controla-se a aplicação 
        % da customizaçao por meio dessa propriedade jsBackDoorFlag.
        jsBackDoorFlag = {true, ...
                          true, ...
                          true};

        % Janela de progresso já criada no DOM. Dessa forma, controla-se 
        % apenas a sua visibilidade - e tornando desnecessário criá-la a
        % cada chamada (usando uiprogressdlg, por exemplo).
        progressDialog

        % Propriedades do app.
        specData = class.specData.empty

        %-----------------------------------------------------------------%
        % ESPECIFICIDADES AUXAPP.WINDRIVETEST
        %-----------------------------------------------------------------%
        rfDataHub
        rfDataHubLOG
        rfDataHubSummary
        rfDataHubAnnotation = table(string.empty, int32([]), struct('Latitude', {}, 'Longitude', {}, 'AntennaHeight', {}), 'VariableNames', {'ID', 'Station', 'TXSite'})
        
        UIAxes1
        UIAxes2
        UIAxes3
        restoreView    = struct('ID', {}, 'xLim', {}, 'yLim', {}, 'cLim', {})

        elevationObj   = RF.Elevation
        ChannelReportObj

        filterTable    = table('Size',          [0, 9],                                                                      ...
                               'VariableTypes', {'cell', 'int8', 'int8', 'cell', 'cell', 'int8', 'cell', 'logical', 'cell'}, ...
                               'VariableNames', {'Order', 'ID', 'RelatedID', 'Type', 'Operation', 'Column', 'Value', 'Enable', 'uuid'})
    end

    
    methods (Access = private)
        %-----------------------------------------------------------------%
        % INICIALIZAÇÃO
        %-----------------------------------------------------------------%
        function jsBackDoor_Initialization(app)
            app.jsBackDoor.HTMLSource = ccTools.fcn.jsBackDoorHTMLSource();
        end

        %-------------------------------------------------------------------------%
        function jsBackDoor_Customizations(app, tabIndex)
            % O menu gráfico controla, programaticamente, qual das abas de
            % app.ControlTabGroup estará visível. 

            % Lembrando que o MATLAB renderiza em tela apenas as abas visíveis.
            % Por isso as customizações de abas e suas subabas somente é possível 
            % após a renderização da aba.

            switch tabIndex
                case 0 % STARTUP
                    if app.isDocked && ~isempty(app.CallingApp) && isprop(app.CallingApp, 'progressDialog')
                        app.progressDialog = app.CallingApp.progressDialog;
                    else
                        app.progressDialog = ccTools.ProgressDialog(app.jsBackDoor);
                    end

                    sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mw-theme-light',                                                   ...
                                                                                           'classAttributes', ['--mw-backgroundColor-dataWidget-selected: rgb(180 222 255 / 45%); ' ...
                                                                                                               '--mw-backgroundColor-selected: rgb(180 222 255 / 45%); '            ...
                                                                                                               '--mw-backgroundColor-selectedFocus: rgb(180 222 255 / 45%);']));
        
                    sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mw-default-header-cell', ...
                                                                                           'classAttributes',  'font-size: 10px; white-space: pre-wrap; margin-bottom: 5px;'));

                    % uialert, uiprogressdialog, uiconfirm
                    % sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mwDialog', ...
                    %                                                                        'classAttributes',  'background-color: white;'));
                    % 
                    % sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mwDialog .mwDialogTitleBar', ...
                    %                                                                        'classAttributes',  'background-color: #f0f0f0;'));
                    % 
                    % sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mwDialog .mwDialogTitleBar .mwCloseNode', ...
                    %                                                                        'classAttributes',  'background-color: #f0f0f0;'));
                    
                    ccTools.compCustomizationV2(app.jsBackDoor, app.ControlTabGroup, 'transparentHeader', 'transparent')
                    ccTools.compCustomizationV2(app.jsBackDoor, app.axesToolbarGrid, 'borderBottomLeftRadius', '5px', 'borderBottomRightRadius', '5px')
                    ccTools.compCustomizationV2(app.jsBackDoor, app.AntennaPatternPanelPlot,       'backgroundColor', 'transparent')

                otherwise
                    if any(app.jsBackDoorFlag{tabIndex})
                        app.jsBackDoorFlag{tabIndex} = false;

                        switch tabIndex
                            case 1 % RFDATAHUB
                                % ...            
                            case 2 % FILTRAGEM
                                % ...
                            case 3 % CONFIGURAÇÕES GERAIS
                                % ...
                        end
                    end
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
            jsBackDoor_Customizations(app, 0)
            jsBackDoor_Customizations(app, 1)

            app.progressDialog.Visible = 'visible';

            if app.standaloneFlag
                % PATH SEARCH
                appName        = class.Constants.appName;
                MFilePath      = fileparts(mfilename('fullpath'));
                app.rootFolder = appUtil.RootFolder(appName, MFilePath);
                app.executionMode = appUtil.ExecutionMode(app.UIFigure);

                % "GeneralSettings.json"
                startup_Files2Read(app)

                % userPath
                if ~strcmp(app.executionMode, 'webApp')
                    userPaths = appUtil.UserPaths(app.General.fileFolder.userPath);
                    app.General.fileFolder.userPath = userPaths{end};
                end
            end

            switch app.executionMode
                case 'webApp'
                    % Webapp não suporta uigetdir, então o mapeamento das pastas
                    % POST/GET deve ser feito em arquivo externo de configuração...
                    app.config_Folder_userPathButton.Enable = 0;

                otherwise
                    % Define tamanho mínimo do app (não aplicável à versão webapp).
                    if ~app.isDocked
                        appUtil.winMinSize(app.UIFigure, class.Constants.windowMinSize)
                    end
            end

            startup_AppProperties(app)
            startup_AxesCreation(app)
            startup_GUIComponents(app)

            filter_TableFiltering(app)

            app.progressDialog.Visible = 'hidden';
        end

        %-----------------------------------------------------------------%
        function startup_Files2Read(app)
            % "GeneralSettings.json"
            [app.General, msgWarning] = appUtil.generalSettingsLoad(class.Constants.appName, app.rootFolder);
            if ~isempty(msgWarning)
                appUtil.modalWindow(app.UIFigure, 'error', msgWarning);
            end
        
            app.General.AppVersion = fcn.startup_Versions("Startup", app.rootFolder);
        end

        %-----------------------------------------------------------------%
        function startup_AppProperties(app)
            % refRX: armazena o valor inicial da estação receptora de referência
            %        para fins de análise da edição.
            rxSite = referenceRX_InitialValue(app);
            app.referenceRX_Refresh.UserData.InitialValue = rxSite;
            referenceRX_UpdatePanel(app, rxSite)

            % app.rfDataHub
            global RFDataHub
            global RFDataHubLog
            
            app.rfDataHub = RFDataHub;
            app.rfDataHubLOG = RFDataHubLog;
            
            % Contorna erro da função inROI, que retorna como se todos os
            % pontos estivessem internos ao ROI, quando as coordenadas
            % estão em float32. No float64 isso não acontece... aberto BUG
            % na Mathworks, que indicou estar ciente.
            app.rfDataHub.Latitude    = double(app.rfDataHub.Latitude);
            app.rfDataHub.Longitude   = double(app.rfDataHub.Longitude);

            app.rfDataHub.ID          = "#" + string((1:height(RFDataHub))');
            app.rfDataHub.Description = "[" + string(RFDataHub.Source) + "] " + string(RFDataHub.Status) + ", " + string(RFDataHub.StationClass) + ", " + string(RFDataHub.Name) + ", " + string(RFDataHub.Location) + "/" + string(RFDataHub.State) + " (M=" + string(RFDataHub.MergeCount) + ")";
            referenceRX_CalculateDistance(app, rxSite)
                        
            % app.rfDataHubSummary
            app.rfDataHubSummary = summary(RFDataHub);

            % A coluna "Source" possui agrupamentos da fonte dos dados,
            % decorrente da mesclagem de estações.
            tempSourceList = cellfun(@(x) strsplit(x, ' | '), app.rfDataHubSummary.Source.Categories, 'UniformOutput', false);
            app.rfDataHubSummary.Source.RawCategories = unique(horzcat(tempSourceList{:}))';

            % A coluna "Location" não está sendo corretamente ordenada por
            % conta dos caracteres especiais.
            tempLocationList = textAnalysis.preProcessedData(app.rfDataHubSummary.Location.Categories);
            [app.rfDataHubSummary.Location.CacheCategories, idxSort] = sort(tempLocationList);
            app.rfDataHubSummary.Location.Categories = app.rfDataHubSummary.Location.Categories(idxSort);

            % lastPrimarySearch
            filter_getReferenceSearch(app)
        end

        %-----------------------------------------------------------------%
        function startup_AxesCreation(app)
            hParent     = tiledlayout(app.plotPanel, 2, 2, "Padding", "none", "TileSpacing", "none");

            % Eixo geográfico: MAPA
            app.UIAxes1 = plot.axes.Creation(hParent, 'Geographic', {'Basemap', app.config_Basemap.Value, ...
                                                                     'UserData', struct('CLimMode', 'auto', 'Colormap', '')});
            app.UIAxes1.Layout.Tile = 1;
            app.UIAxes1.Layout.TileSpan = [2, 2];

            set(app.UIAxes1.LatitudeAxis,  'TickLabels', {}, 'Color', 'none')
            set(app.UIAxes1.LongitudeAxis, 'TickLabels', {}, 'Color', 'none')
            geolimits(app.UIAxes1, 'auto')
            plot.axes.Colormap(app.UIAxes1, app.config_Colormap.Value)

            % Eixo cartesiano: PERFIL DE RELEVO
            app.UIAxes2 = plot.axes.Creation(hParent, 'Cartesian', {'XGrid', 'off', 'XMinorGrid', 'off', 'XTick', [], 'XColor', [.8,.8,.8], 'XLimitMethod', 'padded', ...
                                                                    'YGrid', 'off', 'YMinorGrid', 'off', 'YTick', [], 'YColor', 'none',                               ...
                                                                    'Color', 'none', 'Clipping', 'off', 'LineWidth', 2, 'Layer', 'top', 'Visible', 'off'});
            app.UIAxes2.Layout.Tile = 3;
            app.UIAxes2.Layout.TileSpan = [1 2];
            app.UIAxes2.XAxis.TickLabelFormat = '%.1f';

            % Eixo cartesiano: DIAGRAMA DE RADIAÇÃO DA ANTENA
            app.AntennaPatternPanelPlot.AutoResizeChildren = 'off';
            app.UIAxes3 = polaraxes(app.AntennaPatternPanelPlot, 'Units',             'normalized',    ...
                                                   'Position',          [.05,.05,.9,.9], ...
                                                   'ThetaZeroLocation', 'top',           ...
                                                   'Toolbar',           [],              ...
                                                   'FontSize',          8,               ...
                                                   'Color',             'none',          ...
                                                   'ThetaTick',         0,               ...
                                                   'ThetaDir',          'clockwise',     ...
                                                   'RTickLabel',        {});
            hold(app.UIAxes3, 'on')

            % Legenda
            legend(app.UIAxes1, 'Location', 'southwest', 'Color', [.94,.94,.94], 'EdgeColor', [.9,.9,.9], 'NumColumns', 4, 'LineWidth', .5, 'FontSize', 7.5)

            % Axes interactions:
            plot.axes.Interactivity.DefaultCreation(app.UIAxes1, [dataTipInteraction, zoomInteraction, panInteraction])
            plot.axes.Interactivity.DefaultCreation(app.UIAxes2, dataTipInteraction)
        end

        %-----------------------------------------------------------------%
        function startup_GUIComponents(app)
            % Controles de funcionalidades:
            app.referenceTX_EditionMode.UserData = false;
            app.referenceRX_EditionMode.UserData = false;
            app.tool_TableVisibility.UserData    = true;
            app.tool_RFLinkButton.UserData       = false;
            app.tool_PDFButton.UserData          = false;            

            % Elevação:
            app.misc_ElevationAPISource.Value    = app.General.Elevation.Server;
            app.misc_PointsPerLink.Value         = num2str(app.General.Elevation.Points);
        end
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        function [idxRFDataHub, idxSelectedRow] = getRFDataHubIndex(app)
            if isempty(app.UITable.Selection)
                idxRFDataHub   = [];
                idxSelectedRow = 0;
                
            else
                idxSelectedRow = app.UITable.Selection(1);
                idxVirtual     = app.UITable.Data.ID(idxSelectedRow);    
                idxRFDataHub   = str2double(extractAfter(idxVirtual, '#'));
            end
        end

        %-----------------------------------------------------------------%
        function varargout = RFLinkObjects(app, siteType, varargin)
            arguments
                app 
                siteType char {mustBeMember(siteType, {'TX', 'RX', 'TX-RX'})} = 'TX-RX'
            end

            arguments (Repeating)
                varargin
            end
            % txSite e rxSite estão como struct, mas basta mudar para "txsite" e 
            % "rxsite" que eles poderão ser usados em predições, uma vez que os 
            % campos da estrutura são idênticos às propriedades dos objetos.

            varargout = {};

            if contains(siteType, 'TX')
                idxRFDataHub = varargin{1};

                % TX
                txSite = struct('Name',                 'TX',                                                 ...
                                'TransmitterFrequency', double(app.rfDataHub.Frequency(idxRFDataHub)) * 1e+6, ...
                                'Latitude',             app.referenceTX_Latitude.Value,                       ...
                                'Longitude',            app.referenceTX_Longitude.Value,                      ...
                                'AntennaHeight',        app.referenceTX_Height.Value,                         ...
                                'ID',                   app.rfDataHub.ID(idxRFDataHub),                       ...
                                'Station',              app.rfDataHub.Station(idxRFDataHub));
                varargout{end+1} = txSite;
            end

            if contains(siteType, 'RX')
                % RX
                rxSite = struct('Name',                 'RX',                            ...
                                'Latitude',             app.referenceRX_Latitude.Value,  ...
                                'Longitude',            app.referenceRX_Longitude.Value, ...
                                'AntennaHeight',        app.referenceRX_Height.Value);
                varargout{end+1} = rxSite;
            end
        end


        %-----------------------------------------------------------------%
        % TAB: 1
        % PAINEL: ESTAÇÃO TRANSMISSORA - TX
        %-----------------------------------------------------------------%
        function referenceTX_UpdatePanel(app, idxRFDataHub)
            idxAnnotation = referenceTX_AddOrDelTXSiteTempList(app, 'Search', app.rfDataHub.ID(idxRFDataHub));

            % A ideia aqui é destacar as informações que foram editadas...
            txLatitudeFontColor   = [0,0,0];
            txLongitudeFontColor  = [0,0,0];
            txHeightFontColor     = [0,0,0];

            txLatitudeBackground  = [1,1,1];
            txLongitudeBackground = [1,1,1];
            txHeightBackground    = [1,1,1];

            if idxAnnotation
                app.referenceTX_Refresh.Visible = 1;
                % Latitude
                if app.rfDataHubAnnotation.TXSite(idxAnnotation).Latitude.Status
                    txLatitude  = app.rfDataHubAnnotation.TXSite(idxAnnotation).Latitude.EditedValue;
                    txLatitudeFontColor   = [1,1,1];
                    txLatitudeBackground  = [1,0,0];
                else
                    txLatitude  = app.rfDataHubAnnotation.TXSite(idxAnnotation).Latitude.RawValue;
                end

                % Longitude
                if app.rfDataHubAnnotation.TXSite(idxAnnotation).Longitude.Status
                    txLongitude = app.rfDataHubAnnotation.TXSite(idxAnnotation).Longitude.EditedValue;
                    txLongitudeFontColor  = [1,1,1];
                    txLongitudeBackground = [1,0,0];
                else
                    txLongitude = app.rfDataHubAnnotation.TXSite(idxAnnotation).Longitude.RawValue;
                end

                % Height
                if app.rfDataHubAnnotation.TXSite(idxAnnotation).AntennaHeight.Status
                    txHeight    = app.rfDataHubAnnotation.TXSite(idxAnnotation).AntennaHeight.EditedValue;
                    txHeightFontColor     = [1,1,1];
                    txHeightBackground    = [1,0,0];
                else
                    txHeight    = app.rfDataHubAnnotation.TXSite(idxAnnotation).AntennaHeight.RawValue;
                end

            else
                app.referenceTX_Refresh.Visible = 0;

                [txLatitude,  ...
                 txLongitude, ...
                 txHeight]  = referenceTX_getRawData(app);
            end

            set(app.referenceTX_Latitude,  'Value', txLatitude,  'FontColor', txLatitudeFontColor,  'BackgroundColor', txLatitudeBackground)
            set(app.referenceTX_Longitude, 'Value', txLongitude, 'FontColor', txLongitudeFontColor, 'BackgroundColor', txLongitudeBackground)
            set(app.referenceTX_Height,    'Value', txHeight,    'FontColor', txHeightFontColor,    'BackgroundColor', txHeightBackground)
        end

        %-----------------------------------------------------------------%
        function referenceTX_EditionPanelLayout(app, editionStatus)
            arguments
                app 
                editionStatus char {mustBeMember(editionStatus, {'on', 'off'})}
            end

            idxRFDataHub = getRFDataHubIndex(app);
            hEditFields = findobj(app.referenceTX_Grid.Children, '-not', 'Type', 'uilabel');            

            switch editionStatus
                case 'on'
                    set(app.referenceTX_EditionMode, 'ImageSource', 'Edit_32Filled.png', 'UserData', true)
                    set(hEditFields, 'Editable', true)
                    
                    app.Tab1_Grid.ColumnWidth(5:6) = {16,16};
                    app.referenceTX_EditionConfirm.Enable = 1;
                    app.referenceTX_EditionCancel.Enable  = 1;

                case 'off'
                    referenceTX_UpdatePanel(app, idxRFDataHub)

                    set(app.referenceTX_EditionMode, 'ImageSource', 'Edit_32.png', 'UserData', false)
                    set(hEditFields, 'Editable', false)

                    app.Tab1_Grid.ColumnWidth(5:6) = {0,0};
                    app.referenceTX_EditionConfirm.Enable = 0;
                    app.referenceTX_EditionCancel.Enable  = 0;
            end
        end

        %-----------------------------------------------------------------%
        function varargout = referenceTX_AddOrDelTXSiteTempList(app, operationType, varargin)
            arguments
                app 
                operationType char {mustBeMember(operationType, {'Search', 'Add', 'Del'})}
            end

            arguments (Repeating)
                varargin
            end

            switch operationType
                case 'Search'
                    ID = varargin{1};
                    [~, idxAnnotation] = ismember(ID, app.rfDataHubAnnotation.ID);
                    varargout = {idxAnnotation};

                case 'Add'
                    [txObj, ID, Station, idxAnnotation] = referenceTX_checkTXSiteTempList(app);

                    [txLatitude,  ...
                     txLongitude, ...
                     txHeight]  = referenceTX_getRawData(app);

                    % Confirma que ocorreu alteração em algum dos parâmetros 
                    % do registro.
                    txSiteDiff = struct('Latitude',      struct('Status', false, 'RawValue', txLatitude,  'EditedValue', []), ...
                                        'Longitude',     struct('Status', false, 'RawValue', txLongitude, 'EditedValue', []), ...
                                        'AntennaHeight', struct('Status', false, 'RawValue', txHeight,    'EditedValue', []));
                    txSiteDiffFlag = false;

                    % Cria estrutura que possibilita identificar quais dos
                    % parâmetros foram editados manualmente...
                    % Latitude
                    if ~isequal(txObj.Latitude, txLatitude)
                        txSiteDiffFlag = true;

                        txSiteDiff.Latitude.Status = true;
                        txSiteDiff.Latitude.EditedValue = txObj.Latitude;
                    end

                    % Longitude
                    if ~isequal(txObj.Longitude, txLongitude)
                        txSiteDiffFlag = true;

                        txSiteDiff.Longitude.Status = true;
                        txSiteDiff.Longitude.EditedValue = txObj.Longitude;
                    end

                    % Height
                    if ~isequal(txObj.AntennaHeight, txHeight)
                        txSiteDiffFlag = true;

                        txSiteDiff.AntennaHeight.Status = true;
                        txSiteDiff.AntennaHeight.EditedValue = txObj.AntennaHeight;
                    end

                    if txSiteDiffFlag
                        % Evidenciada alteração no registro. Cria-se nova linha
                        % ou edita-se a existente.
                        if idxAnnotation
                            if isequal(app.rfDataHubAnnotation.TXSite(idxAnnotation), txSiteDiff)
                                return
                            end
                        else
                            idxAnnotation = height(app.rfDataHubAnnotation) + 1;
                        end

                        app.rfDataHubAnnotation(idxAnnotation, :) = {ID, Station, txSiteDiff};
                        layout_AddNewTableStyle(app, 'EditedRows')
                        
                        % Força a atualização do painel HTML e dos plots...
                        app.stationInfo.UserData = [];
                        UITableSelectionChanged(app)
                    else
                        % Não evidenciada alteração no registro. Apaga-se linha,
                        % caso existente. O usuário, aqui, desfez alteração
                        % manualmente (sem pressionar no Refresh).
                        if idxAnnotation
                            app.rfDataHubAnnotation(idxAnnotation, :) = [];
                            layout_AddNewTableStyle(app, 'EditedRows')

                            app.stationInfo.UserData = [];
                            UITableSelectionChanged(app)
                        end
                    end

                case 'Del'
                    [~, ~, ~, idxAnnotation] = referenceTX_checkTXSiteTempList(app);
                    if idxAnnotation
                        app.rfDataHubAnnotation(idxAnnotation, :) = [];
                        layout_AddNewTableStyle(app, 'EditedRows')

                        app.stationInfo.UserData = [];
                        UITableSelectionChanged(app)
                    end
            end
        end

        %-----------------------------------------------------------------%
        function [txObj, ID, Station, idxAnnotation] = referenceTX_checkTXSiteTempList(app)
            idxRFDataHub = getRFDataHubIndex(app);

            % Objeto.
            txObj   = RFLinkObjects(app, 'TX', idxRFDataHub);
            ID      = txObj.ID;
            Station = txObj.Station;

            % Consulta se esse objeto está na lista temporária de estações
            % editadas do RFDataHub.
            [~, idxAnnotation] = ismember(ID, app.rfDataHubAnnotation.ID);
        end

        %-----------------------------------------------------------------%
        function [txLatitude, txLongitude, txHeight] = referenceTX_getRawData(app)
            idxRFDataHub = getRFDataHubIndex(app);

            txLatitude   = round(double(app.rfDataHub.Latitude(idxRFDataHub)),  6);
            txLongitude  = round(double(app.rfDataHub.Longitude(idxRFDataHub)), 6);
            txHeight     = round(str2double(char(app.rfDataHub.AntennaHeight(idxRFDataHub))), 1);
            if txHeight < 0
                txHeight = app.General.RFDataHub.DefaultTX.Height;
            end
        end


        %-----------------------------------------------------------------%
        % TAB: 2
        % PAINEL: ESTAÇÃO RECEPTORA - RX
        %-----------------------------------------------------------------%
        function  rxSite = referenceRX_InitialValue(app)
            refRXFlag = false;
            for ii = 1:numel(app.specData)
                if app.specData(ii).GPS.Status
                    rxLatitude  = app.specData(ii).GPS.Latitude;
                    rxLongitude = app.specData(ii).GPS.Longitude;

                    % Salvo engano, o campo de altura só existe nos arquivos 
                    % gerados pelo appColeta, no formato "10m", por exemplo.
                    rxHeight = [];
                    if isfield(app.specData(ii).MetaData.Antenna, 'Height')
                        rxHeight = str2double(extractBefore(app.specData(ii).MetaData.Antenna.Height, 'm'));
                    end

                    if isempty(rxHeight) || isnan(rxHeight) || (rxHeight <= 0) || isinf(rxHeight)
                        rxHeight = app.General.RFDataHub.DefaultRX.Height;
                    end
                    
                    refRXFlag = true;
                    break
                end
            end

            if ~refRXFlag
                if ~isempty(app.General.RFDataHub.lastSearch)
                    rxLatitude  = app.General.RFDataHub.lastSearch.RX.Latitude;
                    rxLongitude = app.General.RFDataHub.lastSearch.RX.Longitude;
                    rxHeight    = app.General.RFDataHub.lastSearch.RX.Height;    
                else
                    rxLatitude  = app.General.RFDataHub.DefaultRX.Latitude;
                    rxLongitude = app.General.RFDataHub.DefaultRX.Longitude;
                    rxHeight    = app.General.RFDataHub.DefaultRX.Height;
                end
            end

            rxSite = struct('Name',          'RX',        ...
                            'Latitude',      rxLatitude,  ...
                            'Longitude',     rxLongitude, ...
                            'AntennaHeight', rxHeight);
        end

        %-----------------------------------------------------------------%
        function referenceRX_UpdatePanel(app, rxSite)
            app.referenceRX_Latitude.Value  = rxSite.Latitude;
            app.referenceRX_Longitude.Value = rxSite.Longitude;
            app.referenceRX_Height.Value    = rxSite.AntennaHeight;
        end

        %-----------------------------------------------------------------%
        function referenceRX_CalculateDistance(app, rxSite)
            app.rfDataHub.Distance = round(single(deg2km(distance(app.rfDataHub.Latitude,  ...
                                                                  app.rfDataHub.Longitude, ...
                                                                  rxSite.Latitude,         ...
                                                                  rxSite.Longitude))), 1);
            app.referenceRX_Refresh.UserData.DistanceColumnSource = rxSite;
        end

        %-----------------------------------------------------------------%
        function referenceRX_EditOrRefreshReferenceRX(app, operationType)
            arguments
                app 
                operationType char {mustBeMember(operationType, {'Refresh', 'Edit'})}
            end

            refInitialValue         = app.referenceRX_Refresh.UserData.InitialValue;
            refDistanceColumnSource = app.referenceRX_Refresh.UserData.DistanceColumnSource;

            switch operationType
                case 'Refresh'
                    rxSite = refInitialValue;
                    referenceRX_UpdatePanel(app, rxSite)
                case 'Edit'
                    rxSite = RFLinkObjects(app, 'RX');
            end

            if ~isequal(rxSite, refInitialValue)
                app.referenceRX_Refresh.Visible = 1;
            else
                app.referenceRX_Refresh.Visible = 0;
            end

            % Recalcula a coluna "Distance" caso a alteração tenha 
            % ocorrido em "Latitude" ou "Longitude".            
            if ~isequal(rmfield(refDistanceColumnSource, 'AntennaHeight'), rmfield(rxSite, 'AntennaHeight'))
                referenceRX_RefreshTableAndPlots(app, rxSite)
            elseif ~isequal(refDistanceColumnSource.AntennaHeight, rxSite.AntennaHeight)
                app.referenceRX_Refresh.UserData.DistanceColumnSource.AntennaHeight = rxSite.AntennaHeight;
                app.stationInfo.UserData = [];
                UITableSelectionChanged(app)
            end
        end

        %-----------------------------------------------------------------%
        function referenceRX_EditionPanelLayout(app, editionStatus)
            arguments
                app 
                editionStatus char {mustBeMember(editionStatus, {'on', 'off'})}
            end

            hEditFields = findobj(app.referenceRX_Grid.Children, '-not', 'Type', 'uilabel');

            switch editionStatus
                case 'on' 
                    set(app.referenceRX_EditionMode, 'ImageSource', 'Edit_32Filled.png', 'UserData', true)
                    set(hEditFields, 'Editable', true)
                    
                    app.Tab2_Grid.ColumnWidth(5:6) = {16,16};
                    app.referenceRX_EditionConfirm.Enable = 1;
                    app.referenceRX_EditionCancel.Enable  = 1;

                case 'off'
                    set(app.referenceRX_EditionMode, 'ImageSource', 'Edit_32.png', 'UserData', false)
                    set(hEditFields, 'Editable', false)

                    app.Tab2_Grid.ColumnWidth(5:6) = {0,0};
                    app.referenceRX_EditionConfirm.Enable = 0;
                    app.referenceRX_EditionCancel.Enable  = 0;
            end
        end

        %-----------------------------------------------------------------%
        function referenceRX_RefreshTableAndPlots(app, rxSite)
            referenceRX_CalculateDistance(app, rxSite)
            filter_TableFiltering(app)
        end


        %-----------------------------------------------------------------%
        % FILTRAGEM
        %-----------------------------------------------------------------%
        function filter_getReferenceSearch(app)
            if ~isempty(app.General.RFDataHub.lastSearch)
                filterType      = app.General.RFDataHub.lastSearch.Filter.ColumnLabel;
                filterValue     = app.General.RFDataHub.lastSearch.Filter.Value;
                filterOperation = app.General.RFDataHub.lastSearch.Filter.Operation;

            else
                filterType      = app.General.RFDataHub.DefaultFilter.ColumnLabel;
                filterValue     = app.General.RFDataHub.DefaultFilter.Value;
                filterOperation = app.General.RFDataHub.DefaultFilter.Operation;
            end

            hFilterNames        = findobj(app.filter_SecondaryTypePanel.Children,  'Type', 'uiradiobutton');
            hFilterOperations   = findobj(app.filter_SecondaryValuePanel.Children, 'Type', 'uitogglebutton');
            hFilterValues       = [app.filter_SecondaryNumValue1, ...
                                   app.filter_SecondaryNumValue2, ...
                                   app.filter_SecondaryTextFree,  ...
                                   app.filter_SecondaryTextList];

            listOfFilterNames   = {hFilterNames.Text};
            listOfOperations    = {hFilterOperations.Text};

            [~, idxFilter]      = ismember(filterType,      listOfFilterNames);
            [~, idxOperation]   = ismember(filterOperation, listOfOperations);

            if ~isempty(idxFilter) && ~isempty(idxOperation)
                hFilterNames(idxFilter).Value   = true;
                filter_typePanelSelectionChanged(app)

                hFilterOperations(idxOperation).Value = true;
                filter_SecondaryValuePanelSelectionChanged(app)

                hFilterValues   = hFilterValues(arrayfun(@(x) x.Visible, hFilterValues));
                for ii = 1:numel(hFilterValues)
                    hFilterValues(ii).Value = filterValue(ii);
                end
            end

            columnName       = filter_FilterType2ColumnNames(app, filterType);
            [~, columnIndex] = ismember(columnName, app.rfDataHub.Properties.VariableNames);

            newFilter = {'Node', 1, -3, filterType, filterOperation, columnIndex, filterValue, true, char(matlab.lang.internal.uuid())};

            filter_AddNewFilter(app, newFilter)
            filter_TreeBuilding(app)
        end

        %-----------------------------------------------------------------%
        function filter_AddNewFilter(app, newFilter)
            app.filterTable(end+1,[1:6,8:9]) = newFilter([1:6,8:9]);
            app.filterTable.Value{end} = newFilter{7};
        end

        %-----------------------------------------------------------------%
        function columnName = filter_FilterType2ColumnNames(app, filterType)
            filterTypes = ["Fonte", "Frequência", "Largura banda", "Classe emissão", "Entidade", "Fistel", "Serviço", "Estação", "UF",    "Município", "Distância"];
            columnNames = ["Source", "Frequency", "BW",            "EmissionClass",  "Name",     "Fistel", "Service", "Station", "State", "Location",  "Distance"];
            d = dictionary(filterTypes, columnNames);

            columnName = d(filterType);            
        end

        %-----------------------------------------------------------------%
        function filter_TreeBuilding(app)
            if ~isempty(app.filter_Tree.Children)
                delete(app.filter_Tree.Children)
            end

            idx1 = find(strcmp(app.filterTable.Order, 'Node'))';
            if ~isempty(idx1)
                checkedNodes = {};
                for ii = idx1
                    idx2 = find(app.filterTable.RelatedID == ii)';
                    if isempty(idx2)
                        parentNode = uitreenode(app.filter_Tree, 'Text', sprintf('#%d: RFDataHub.("%s") %s %s', app.filterTable.ID(ii),                        ...
                                                                                                                app.filterTable.Type{ii},                      ...
                                                                                                                app.filterTable.Operation{ii},                 ...
                                                                                                                filter_Value(app, app.filterTable.Value{ii})), ...
                                                                 'NodeData', ii, 'ContextMenu', app.filter_ContextMenu);
                        if app.filterTable.Enable(ii)
                            checkedNodes = [checkedNodes, parentNode];
                        end

                    else
                        parentNode = uitreenode(app.filter_Tree, 'Text', '*.*', ...
                                                                 'NodeData', [ii, idx2], 'ContextMenu', app.filter_ContextMenu);
                        for jj = [ii, idx2]
                            childNode = uitreenode(parentNode, 'Text', sprintf('#%d: RFDataHub.("%s") %s %s', app.filterTable.ID(jj),                        ...
                                                                                                              app.filterTable.Type{jj},                      ...
                                                                                                              app.filterTable.Operation{jj},                 ...
                                                                                                              filter_Value(app, app.filterTable.Value{jj})), ...
                                                               'NodeData', jj, 'ContextMenu', app.filter_ContextMenu);
        
                            if app.filterTable.Enable(jj)
                                checkedNodes = [checkedNodes, childNode];
                            end
                        end
                    end
                end
                app.filter_Tree.CheckedNodes = checkedNodes;
                expand(app.filter_Tree, 'all')
            end

            app.filter_SecondaryReferenceFilter.Items = [{''}, cellstr("#" + string((idx1)))];
        end

        %-----------------------------------------------------------------%
        function filter_TableFiltering(app)
            app.progressDialog.Visible = 'visible';

            % Identifica registro inicialmente selecionado da tabela.
            initialSelectedRowID = '';
            if ~isempty(app.UITable.Selection)
                initialSelectedRowID = app.UITable.Data.ID{app.UITable.Selection(1)};
            end

            % Filtragem, preenchendo a tabela e o seu label (nº de linhas).
            idxRFDataHubArray = find(fcn.TableFiltering(app.rfDataHub, app.filterTable));
            columnGUINames    = {'ID', 'Frequency', 'Description', 'Service', 'Station', 'BW', 'Distance'};

            set(app.UITable, 'Selection', [], 'Data', app.rfDataHub(idxRFDataHubArray, columnGUINames))
            [app.UITable.Data, idxSort] = sortrows(app.UITable.Data, 'Distance');
            app.UITable.UserData = idxRFDataHubArray(idxSort);

            NN = numel(idxRFDataHubArray);
            MM = height(app.rfDataHub);
            app.tool_tableNRows.Text = sprintf('%d de %d registros\n%.1f %%', NN, MM, (NN/MM)*100);

            % Aplicando a seleção inicial da tabela, caso aplicável.
            idxSelectedRow = 0;
            if ~isempty(app.UITable.Data)
                if ~isempty(initialSelectedRowID)
                    [~, idxSelectedRow] = ismember(initialSelectedRowID, app.UITable.Data.ID);
                end

                if ~idxSelectedRow
                    idxSelectedRow = 1;
                end

                app.UITable.Selection = [idxSelectedRow, 1];
                scroll(app.UITable, 'Row', idxSelectedRow)
            end

            layout_AddNewTableStyle(app, 'EditedRows')
            
            % Plots.
            plot_Stations(app)
            plot_RX(app)
            UITableSelectionChanged(app, struct('Source', app.UITable))
            
            plot.axes.StackingOrder.execute(app.UIAxes1, 'appAnalise:RFDATAHUB')
            app.restoreView(1) = struct('ID', 'app.UIAxes1', 'xLim', app.UIAxes1.LatitudeLimits, 'yLim', app.UIAxes1.LongitudeLimits, 'cLim', 'auto');

            app.progressDialog.Visible = 'hidden';
        end


        %-----------------------------------------------------------------%
        % PLOT
        %-----------------------------------------------------------------%
        function plot_Stations(app)
            delete(findobj(app.UIAxes1.Children, '-not', {'Tag', 'FilterROI', '-or', 'Tag', 'TX'}))
            app.stationInfo.UserData = [];

            if ~isempty(app.UITable.Data)
                geolimits(app.UIAxes1, 'auto')

                idxRFDataHubArray = app.UITable.UserData;
                latitudeArray     = app.rfDataHub.Latitude(idxRFDataHubArray);
                longitudeArray    = app.rfDataHub.Longitude(idxRFDataHubArray);

                hStations = geoscatter(app.UIAxes1, latitudeArray, longitudeArray, ...
                    'MarkerEdgeColor', app.config_Station_Color.Value,             ...
                    'SizeData',        app.config_Station_Size.Value,              ...
                    'DisplayName',     'RFDataHub',                                ...
                    'Tag',             'Stations');
                plot.datatip.Template(hStations, 'winRFDataHub.Geographic', app.UITable.Data)
            end
        end

        %-----------------------------------------------------------------%
        function plot_RX(app)
            RX = struct('Latitude',  app.referenceRX_Latitude.Value, ...
                        'Longitude', app.referenceRX_Longitude.Value);

            hRX = geoscatter(app.UIAxes1, RX.Latitude, RX.Longitude, ...
                'Marker',          '^',                              ...
                'MarkerEdgeColor', app.config_RX_Color.Value,        ...
                'MarkerFaceColor', app.config_RX_Color.Value,        ...
                'SizeData',        44*app.config_RX_Size.Value,      ...
                'DisplayName',     'RX',                             ...
                'Tag',             'RX');
            plot.datatip.Template(hRX, 'Coordinates')
        end

        %-----------------------------------------------------------------%
        function plot_TX(app, idxRFDataHub, idxSelectedRow)
            delete(findobj(app.UIAxes1.Children, 'Tag', 'TX'))

            if ~isempty(idxRFDataHub)
                txObj = RFLinkObjects(app, 'TX', idxRFDataHub);

                % Scatter
                hTXScatter = findobj(app.UIAxes1.Children, 'Type', 'scatter', 'Tag', 'TX');
                if isempty(hTXScatter)
                    hTX = geoscatter(app.UIAxes1, txObj.Latitude, txObj.Longitude, ...
                        'LineWidth',       2,                                      ...
                        'Marker',          'o',                                    ...
                        'MarkerEdgeColor', app.config_TX_Color.Value,              ...
                        'MarkerFaceColor', app.config_TX_Color.Value,              ...
                        'SizeData',        20*app.config_TX_Size.Value ,           ...
                        'PickableParts',   'none',                                 ...
                        'DisplayName',     'TX',                                   ...
                        'Tag',             'TX');
                    plot.datatip.Template(hTX, 'Coordinates')
                else
                    set(hTXScatter, 'LatitudeData',  txObj.Latitude, ...
                                    'LongitudeData', txObj.Longitude)
                end

                % DataTip
                if strcmp(app.config_TX_DataTipVisibility.Value, 'on')
                    hTXDataTip = findobj(app.UIAxes1.Children, 'Type', 'datatip', 'Tag', 'TX');
                    if isempty(hTXDataTip)
                        hStations = findobj(app.UIAxes1.Children, 'Tag', 'Stations');
                        datatip(hStations,                   ...
                            'DataIndex',     idxSelectedRow, ...
                            'PickableParts', 'none',         ...
                            'Tag',           'TX');
                    else
                        hTXDataTip.DataIndex = idxSelectedRow;
                    end
                end
            end
        end

        %-----------------------------------------------------------------%
        function plot_createRFLinkPlot(app)
            delete(findobj(app.UIAxes1.Children, 'Tag', 'RFLink'))
            cla(app.UIAxes2)
            delete(findobj(app.UIAxes3.Children, 'Tag', 'Azimuth'))

            if app.tool_RFLinkButton.UserData && ~isempty(app.UITable.Selection)
                idxRFDataHub = getRFDataHubIndex(app);

                app.progressDialog.Visible = 'visible';

                try
                    % OBJETOS TX e RX
                    [txObj, rxObj] = RFLinkObjects(app, 'TX-RX', idxRFDataHub);
        
                    % ELEVAÇÃO DO LINK TX-RX
                    [wayPoints3D, msgWarning] = Get(app.elevationObj, txObj, rxObj, str2double(app.misc_PointsPerLink.Value), false, app.misc_ElevationAPISource.Value);
                    if ~isempty(msgWarning)
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    end
        
                    % PLOT: RFLink Map
                    geoplot(app.UIAxes1, wayPoints3D(:,1), wayPoints3D(:,2), Color='#c94756', LineStyle='-.', PickableParts='none', DisplayName='Enlace', Tag='RFLink');
                    
                    % PLOT: RFLink
                    plot.RFLink(app.UIAxes2, txObj, rxObj, wayPoints3D, 'light', true, true)
    
                    % PLOT: RFLink Azimuth
                    Azimuth = deg2rad(app.UIAxes2.UserData.Azimuth);
                    polarplot(app.UIAxes3, Azimuth,            app.UIAxes3.RLim(1), 'MarkerEdgeColor', '#c94756', 'MarkerFaceColor', '#c94756', 'Marker', 'o', 'PickableParts', 'none', 'Tag', 'Azimuth');
                    polarplot(app.UIAxes3, Azimuth,            app.UIAxes3.RLim(2), 'MarkerEdgeColor', '#c94756', 'MarkerFaceColor', '#c94756', 'Marker', '^', 'PickableParts', 'none', 'Tag', 'Azimuth');
                    polarplot(app.UIAxes3, [Azimuth, Azimuth], app.UIAxes3.RLim,              'Color', '#c94756', 'LineStyle', '-.',                           'PickableParts', 'none', 'Tag', 'Azimuth');
                    
                catch
                end

                app.progressDialog.Visible = 'hidden';
            end

            plot_PolarAxesVisibility(app)
        end

        %-----------------------------------------------------------------%
        function plot_PolarAxesVisibility(app)
            % Visibilidade do eixo polar, com diagrama de radiação da
            % antena e azimute do enlace, caso aplicáveis.
            if isempty(app.UIAxes3.Children)
                app.stationInfoGrid.RowHeight{2} = 0;
            else
                app.stationInfoGrid.RowHeight{2} = 166;
            end
        end

        %-----------------------------------------------------------------%
        function misc_getChannelReport(app, operationType)
            arguments
                app
                operationType char {mustBeMember(operationType, {'OnlyCache', 'Cache+RealTime', 'RealTime'})}
            end

            if app.tool_PDFButton.UserData && ~isempty(app.UITable.Selection)
                idxRFDataHub = getRFDataHubIndex(app);

                URL = char(app.rfDataHub.URL(idxRFDataHub));
                if strcmp(URL, '-1')
                    layout_restartChannelReport(app)
                    return
                end

                % Caso a URL seja válida, cria-se objeto ChannelReport, caso
                % não existente.            
                if isempty(app.ChannelReportObj)
                    app.ChannelReportObj = RF.ChannelReport;
                end
    
                % A operação poderá ser demorada caso seja do tipo "Cache+RealTime" 
                % ou "RealTime". 
                if ismember(operationType, {'Cache+RealTime', 'RealTime'})
                    app.progressDialog.Visible = 'visible';
                end
    
                [idxCache, msgError] = Get(app.ChannelReportObj, URL, operationType);
                if ~isempty(idxCache)    
                    app.chReportHTML.HTMLSource     = app.ChannelReportObj.cacheMapping.File{idxCache};
                    app.chReportDownloadTime.Text   = sprintf(' DOWNLOAD EM %s', app.ChannelReportObj.cacheMapping.Timestamp{idxCache});
                    app.chReportHotDownload.Visible = 1;
                    app.chReportUndock.Visible      = 1;
    
                else
                    layout_restartChannelReport(app)
    
                    if ismember(operationType, {'Cache+RealTime', 'RealTime'}) && ~isempty(msgError)
                        appUtil.modalWindow(app.UIFigure, 'error', msgError);
                    end
                end
    
                if strcmp(app.progressDialog.Visible, 'visible')
                    app.progressDialog.Visible = 'hidden';
                end

            else
                layout_restartChannelReport(app)
            end
        end

        %-----------------------------------------------------------------%
        function layout_restartChannelReport(app)
            app.chReportHTML.HTMLSource     = 'Warning2.html';
            app.chReportDownloadTime.Text   = '';
            app.chReportHotDownload.Visible = 0;
            app.chReportUndock.Visible      = 0;
        end

        %-----------------------------------------------------------------%
        function layout_AddNewTableStyle(app, operationType, varargin)
            arguments
                app
                operationType char {mustBeMember(operationType, {'EditedRows', 'RowSelectionChanged'})}
            end

            arguments (Repeating)
                varargin
            end

            switch operationType
                case 'EditedRows'
                    styleType = "cell";
                    layout_RemoveOldTableStyle(app, styleType)

                    idxRows = find(contains(app.UITable.Data.ID, app.rfDataHubAnnotation.ID));
                    if ~isempty(idxRows)
                        listOfCells = [idxRows, 2*ones(numel(idxRows), 1)];
                        addStyle(app.UITable, uistyle('Icon', 'Edit_32.png',  'IconAlignment', 'leftmargin'), styleType, listOfCells)
                    end

                case 'RowSelectionChanged'
                    styleType = "row";
                    layout_RemoveOldTableStyle(app, styleType)

                    idxSelectedRow = varargin{1};
                    if idxSelectedRow
                        addStyle(app.UITable, uistyle('BackgroundColor', '#d8ebfa'), styleType, idxSelectedRow)
                    end
            end
        end

        %-----------------------------------------------------------------%
        function layout_RemoveOldTableStyle(app, styleType)
            idxStyle = find(app.UITable.StyleConfigurations.Target == styleType);
            if ~isempty(idxStyle)
                removeStyle(app.UITable, idxStyle)
            end
        end

        %-----------------------------------------------------------------%
        function layout_FilterOperationPanel(app, filterType, filterDefault)            
            layout_FilterDefaultValues(app)
            filter_SecondaryReferenceFilterValueChanged(app)

            hComp = findobj(app.filter_SecondaryValuePanel, 'Type', 'uitogglebutton');
            hCompTagFlag = contains(arrayfun(@(x) x.Tag, hComp, 'UniformOutput', false), filterType);

            set(hComp(hCompTagFlag),  Enable=1)
            set(hComp(~hCompTagFlag), Enable=0)

            selectedButton = app.filter_SecondaryValuePanel.SelectedObject;
            if ~selectedButton.Enable
                switch filterType
                    case {'textList1', 'ROI'}
                        app.filter_SecondaryOperation3.Value = 1; % CONTÉM

                    case 'textList3'
                        app.filter_SecondaryOperation2.Value = 1; % DIFERENTE

                    otherwise
                        app.filter_SecondaryOperation1.Value = 1; % IGUAL
                end
            end

            switch filterType
                case 'numeric'
                    app.filter_SecondaryNumValue1.Visible    = 1;
                    app.filter_SecondaryNumSeparator.Visible = 1;
                    app.filter_SecondaryNumValue2.Visible    = 1;
                    app.filter_SecondaryTextFree.Visible     = 0;
                    app.filter_SecondaryTextList.Visible     = 0;

                case 'textFree'
                    app.filter_SecondaryNumValue1.Visible    = 0;
                    app.filter_SecondaryNumSeparator.Visible = 0;
                    app.filter_SecondaryNumValue2.Visible    = 0;
                    app.filter_SecondaryTextFree.Visible     = 1;
                    app.filter_SecondaryTextList.Visible     = 0;

                case {'textList1', 'textList2', 'ROI'}
                    app.filter_SecondaryNumValue1.Visible    = 0;
                    app.filter_SecondaryNumSeparator.Visible = 0;
                    app.filter_SecondaryNumValue2.Visible    = 0;
                    app.filter_SecondaryTextFree.Visible     = 0;
                    app.filter_SecondaryTextList.Visible     = 1;
                    app.filter_SecondaryTextList.Items       = filterDefault;

                case 'textList3'
                    app.filter_SecondaryNumValue1.Visible    = 0;
                    app.filter_SecondaryNumSeparator.Visible = 0;
                    app.filter_SecondaryNumValue2.Visible    = 0;
                    app.filter_SecondaryTextFree.Visible     = 0;
                    app.filter_SecondaryTextList.Visible     = 1;
                    app.filter_SecondaryTextList.Items       = filterDefault;
            end
        end

        %-----------------------------------------------------------------%
        function layout_FilterDefaultValues(app)
            app.filter_SecondaryNumValue1.Value       = -1;
            app.filter_SecondaryNumValue2.Value       = -1;
            app.filter_SecondaryTextFree.Value        = '';
            app.filter_SecondaryTextList.Items        = {};
            app.filter_SecondaryLogicalOperator.Items = {'E (&&)'};
        end

        %-----------------------------------------------------------------%
        function filterValue = filter_Value(app, filterValue)
            if isnumeric(filterValue)
                if isscalar(filterValue)
                    filterValue = string(filterValue);
                else
                    filterValue = "[" + strjoin(string(filterValue), ', ') + "]";
                end
            elseif ischar(filterValue)
                filterValue = sprintf('"%s"', upper(filterValue));
            else
                filterValue = '⌂';
            end
        end

        %-----------------------------------------------------------------%
        function filter_ROICallbacks(app, src, event)
            switch(event.EventName)
                case 'MovingROI'
                    plot.axes.Interactivity.DefaultDisable(app.UIAxes1)
                    
                case 'ROIMoved'
                    plot.axes.Interactivity.DefaultEnable(app.UIAxes1)
                    
                    filter_TableFiltering(app)
                    if isvalid(event.Source)
                        uistack(event.Source, 'top')
                    end
            end            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            
            try
                % Inicialmente, verifica se foi passado mainapp como argumento 
                % de entrada. 
                % • Caso sim, trata-se de app executado como módulo do appAnalise.
                % • Caso não, trata-se de app executado em modo standalone.
                if nargin == 1
                    app.standaloneFlag = true;
    
                    appUtil.disablingWarningMessages()
                    set(app.UIFigure, 'Name', 'RFDataHub', 'Icon', 'mosaic_18Gray.png')
                else
                    app.standaloneFlag = false;
    
                    app.CallingApp    = mainapp;
                    app.General       = mainapp.General;
                    app.rootFolder    = mainapp.rootFolder;
                    app.executionMode = mainapp.executionMode;
                    app.specData      = mainapp.specData;
                end
    
                app.GridLayout.ColumnWidth(7:10) = {0,0,0,0};
                jsBackDoor_Initialization(app)
    
                % Em sendo executado como módulo do appAnalise, o app pode
                % estar em modo DOCK ou UNDOCK, o que é definido em configuração
                % no próprio appAnalise.
                if app.isDocked
                    drawnow
                    startup_Controller(app)
                else
                    appUtil.winPosition(app.UIFigure)
                    startup_timerCreation(app)
                end

            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', getReport(ME), 'CloseFcn', @(~,~)closeFcn(app));
            end

        end

        % Close request function: UIFigure
        function closeFcn(app, event)

            if ~isempty(app.CallingApp) && ismethod(app.CallingApp, 'appBackDoor')
                appBackDoor(app.CallingApp, app, 'closeFcn')
            end
            delete(app)
            
        end

        % Image clicked function: menu_Button1Icon, menu_Button2Icon, 
        % ...and 1 other component
        function general_ControlPanelSelectionChanged(app, event)
            
            idx = str2double(event.Source.Tag);
            NN  = numel(app.menu_MainGrid.ColumnWidth);

            for ii = 1:NN
                switch ii
                    case idx
                        eval(sprintf('app.menu_Button%dGrid.ColumnWidth{2} = "1x";', ii))
                    otherwise
                        eval(sprintf('app.menu_Button%dGrid.ColumnWidth{2} = 0;',    ii))
                end
            end

            columnWidth      = repmat({22}, 1, NN);
            columnWidth(idx) = {'1x'};

            app.menu_MainGrid.ColumnWidth   = columnWidth;
            app.menuUnderline.Layout.Column = idx;
            app.ControlTabGroup.SelectedTab = app.ControlTabGroup.Children(idx);

            jsBackDoor_Customizations(app, idx)
            focus(app.jsBackDoor)
            
        end

        % Image clicked function: tool_ControlPanelVisibility, 
        % ...and 3 other components
        function tool_InteractionImageClicked(app, event)
            
            focus(app.jsBackDoor)
            
            switch event.Source
                case app.tool_ControlPanelVisibility
                    if app.GridLayout.ColumnWidth{2}
                        app.tool_ControlPanelVisibility.ImageSource = 'ArrowRight_32.png';
                        app.GridLayout.ColumnWidth(2:3) = {0,0};
                    else
                        app.tool_ControlPanelVisibility.ImageSource = 'ArrowLeft_32.png';
                        app.GridLayout.ColumnWidth(2:3) = {325,10};
                    end

                case app.tool_TableVisibility
                    app.tool_TableVisibility.UserData = ~app.tool_TableVisibility.UserData;
                    if app.tool_TableVisibility.UserData
                        app.UITable.Visible = 1;
                        app.GridLayout.RowHeight(4:5) = {10,'.4x'};
                    else
                        app.UITable.Visible = 0;
                        app.GridLayout.RowHeight(4:5) = {0,0};
                    end

                case app.tool_PDFButton
                    app.tool_PDFButton.UserData = ~app.tool_PDFButton.UserData;
                    if app.tool_PDFButton.UserData
                        app.GridLayout.ColumnWidth(7:10) = {10,'1x',22,22};
                    else
                        app.GridLayout.ColumnWidth(7:10) = {0,0,0,0};
                    end
                    misc_getChannelReport(app, 'Cache+RealTime')

                case app.tool_RFLinkButton
                    app.tool_RFLinkButton.UserData = ~app.tool_RFLinkButton.UserData;
                    if app.tool_RFLinkButton.UserData
                        app.UIAxes1.Layout.TileSpan = [1,2];
                        set(findobj(app.UIAxes2), 'Visible', 1)
                    else
                        app.UIAxes1.Layout.TileSpan = [2,2];
                        set(findobj(app.UIAxes2), 'Visible', 0)
                    end
                    plot_createRFLinkPlot(app)
            end

        end

        % Image clicked function: tool_ExportButton
        function tool_exportButtonPushed(app, event)
            
                defaultFilename = class.Constants.DefaultFileName(app.General.fileFolder.userPath, 'RFDataHub', -1);

                [fileName, filePath, fileIndex] = uiputfile({'*.xlsx', 'Excel (*.xlsx)'}, '', defaultFilename);
                figure(app.UIFigure)
                
                if fileIndex
                    app.progressDialog.Visible = 'visible';

                    try
                        idxRFDataHubArray = app.UITable.UserData;
                        tempRFDataHub = class.RFDataHub.ColumnNames(app.rfDataHub(idxRFDataHubArray,1:29), 'eng2port');
                        writetable(tempRFDataHub, fullfile(filePath, fileName), 'WriteMode', 'overwritesheet')
                    catch ME
                        appUtil.modalWindow(app.UIFigure, 'warning', getReport(ME));
                    end

                    app.progressDialog.Visible = 'hidden';
                end

        end

        % Image clicked function: axesTool_RegionZoom, axesTool_RestoreView
        function axesTool_InteractionImageClicked(app, event)
            
            switch event.Source
                case app.axesTool_RestoreView
                    geolimits(app.UIAxes1, app.restoreView(1).xLim, app.restoreView(1).yLim)

                case app.axesTool_RegionZoom
                    plot.axes.Interactivity.GeographicRegionZoomInteraction(app.UIAxes1, app.axesTool_RegionZoom)
            end

        end

        % Image clicked function: chReportHotDownload, chReportUndock
        function tool_chReportPanelImageClicked(app, event)
            
            if strcmp(app.chReportHTML.HTMLSource, 'Warning2.html')
                return
            end

            switch event.Source
                case app.chReportHotDownload
                    misc_getChannelReport(app, 'RealTime')

                case app.chReportUndock
                    ccTools.fcn.OperationSystem('openFile', app.chReportHTML.HTMLSource)
                    tool_InteractionImageClicked(app, struct('Source', app.tool_PDFButton))
            end

        end

        % Selection changed function: UITable
        function UITableSelectionChanged(app, event)
            
            [idxRFDataHub, idxSelectedRow] = getRFDataHubIndex(app);
            
            if isequal(app.stationInfo.UserData, idxRFDataHub)
                return
            end

            % Reinicializa componentes da GUI.
            layout_AddNewTableStyle(app, 'RowSelectionChanged', idxSelectedRow)
            cla(app.UIAxes3)

            app.stationInfo.UserData = idxRFDataHub;
            
            if isempty(idxRFDataHub)
                app.referenceTX_Refresh.Visible     = 0;
                app.referenceTX_EditionMode.Visible = 0;
                app.referenceTX_Latitude.Value      = -1;
                app.referenceTX_Longitude.Value     = -1;
                app.referenceTX_Height.Value        = 0;

                app.stationInfo.HTMLSource      = '';
                layout_restartChannelReport(app)
                delete(findobj(app.UIAxes1.Children, 'Tag', 'TX'))
                cla(app.UIAxes2)

            else
                % Estação transmissora - TX
                referenceTX_UpdatePanel(app, idxRFDataHub)
                if app.referenceTX_EditionMode.UserData
                    referenceTX_EditionModeImageClicked(app, struct('Source', app.referenceTX_EditionMode))
                end

                % Painel HTML
                htmlContent = auxApp.rfdatahub.htmlCode_StationInfo(app.rfDataHub, idxRFDataHub, app.rfDataHubLOG, app.General);
                app.stationInfo.HTMLSource = htmlContent;

                % Painel PDF
                if app.rfDataHub.Source(idxRFDataHub) == "MOSAICO-SRD"
                    misc_getChannelReport(app, 'Cache+RealTime')
                else
                    layout_restartChannelReport(app)
                end
                    
                % Plot "AntennaPattern"
                % O bloco try/catch protege possível erro no parser da informação
                % do Mosaico. Como exposto em class.RFDataHub.parsingAntennaPattern
                % foram identificados quatro formas de armazenar a informação.
                if app.rfDataHub.AntennaPattern(idxRFDataHub) ~= "-1"
                    try
                        [angle, gain] = class.RFDataHub.parsingAntennaPattern(app.rfDataHub.AntennaPattern(idxRFDataHub), 360);
                        hAntennaPattern = polarplot(app.UIAxes3, angle, gain, 'Tag', 'AntennaPattern');
                        plot.datatip.Template(hAntennaPattern, "AntennaPattern")
                    catch
                    end
                end

                % Plot "TX"
                plot_TX(app, idxRFDataHub, idxSelectedRow)

                % Plot "RFLink"
                plot_createRFLinkPlot(app)
            end
            
        end

        % Image clicked function: referenceTX_EditionCancel, 
        % ...and 3 other components
        function referenceTX_EditionModeImageClicked(app, event)
            
            switch event.Source
                case app.referenceTX_Refresh
                    referenceTX_AddOrDelTXSiteTempList(app, 'Del')
                    referenceTX_EditionPanelLayout(app, 'off')

                case app.referenceTX_EditionMode
                    app.referenceTX_EditionMode.UserData = ~app.referenceTX_EditionMode.UserData;
                    if app.referenceTX_EditionMode.UserData
                        referenceTX_EditionPanelLayout(app, 'on')
                        referenceTX_FieldValueChanged(app, struct('Source', app.referenceTX_EditionMode))
                    else
                        referenceTX_EditionPanelLayout(app, 'off')
                    end

                case app.referenceTX_EditionConfirm
                    referenceTX_AddOrDelTXSiteTempList(app, 'Add')
                    referenceTX_EditionPanelLayout(app, 'off')

                case app.referenceTX_EditionCancel
                    referenceTX_EditionPanelLayout(app, 'off')
            end

        end

        % Value changed function: referenceTX_Latitude, 
        % ...and 1 other component
        function referenceTX_FieldValueChanged(app, event)
            
            switch event.Source
                case app.referenceTX_EditionMode
                    focus(app.referenceTX_Latitude)
                case app.referenceTX_Latitude
                    focus(app.referenceTX_Longitude)
                case app.referenceTX_Longitude
                    focus(app.referenceTX_Height)
            end

        end

        % Image clicked function: referenceRX_EditionCancel, 
        % ...and 3 other components
        function referenceRX_EditionModeImageClicked(app, event)
            
            switch event.Source
                case app.referenceRX_Refresh
                    referenceRX_EditOrRefreshReferenceRX(app, 'Refresh')
                    referenceRX_EditionPanelLayout(app, 'off')

                case app.referenceRX_EditionMode
                    app.referenceRX_EditionMode.UserData = ~app.referenceRX_EditionMode.UserData;
                    if app.referenceRX_EditionMode.UserData
                        referenceRX_EditionPanelLayout(app, 'on')
                        referenceRX_FieldValueChanged(app, struct('Source', app.referenceRX_EditionMode))
                    else
                        referenceRX_EditionPanelLayout(app, 'off')
                    end

                case app.referenceRX_EditionConfirm
                    referenceRX_EditOrRefreshReferenceRX(app, 'Edit')
                    referenceRX_EditionPanelLayout(app, 'off')

                case app.referenceRX_EditionCancel
                    rxSite = app.referenceRX_Refresh.UserData.DistanceColumnSource;
                    referenceRX_UpdatePanel(app, rxSite)

                    referenceRX_EditionPanelLayout(app, 'off')
            end        

        end

        % Value changed function: referenceRX_Latitude, 
        % ...and 1 other component
        function referenceRX_FieldValueChanged(app, event)
            
            switch event.Source
                case app.referenceRX_EditionMode
                    focus(app.referenceRX_Latitude)
                case app.referenceRX_Latitude
                    focus(app.referenceRX_Longitude)
                case app.referenceRX_Longitude
                    focus(app.referenceRX_Height)
            end

        end

        % Selection changed function: filter_SecondaryTypePanel
        function filter_typePanelSelectionChanged(app, event)
                        
            selectedButton = app.filter_SecondaryTypePanel.SelectedObject;
            switch selectedButton
                case app.filter_SecondaryType1                            % BASE DE DADOS
                    filterType    = 'textList1';
                    filterDefault = app.rfDataHubSummary.Source.RawCategories;

                case {app.filter_SecondaryType2, ...                      % FREQUÊNCIA
                      app.filter_SecondaryType3, ...                      % LARGURA BANDA
                      app.filter_SecondaryType6, ...                      % FISTEL
                      app.filter_SecondaryType7, ...                      % SERVIÇO
                      app.filter_SecondaryType8, ...                      % ESTAÇÃO
                      app.filter_SecondaryType11}                         % DISTÂNCIA
                    filterType    = 'numeric';
                    filterDefault = {};

                case {app.filter_SecondaryType4, ...                      % CLASSE EMISSÃO (DESIGNAÇÃO)
                      app.filter_SecondaryType5, ...                      % ENTIDADE
                      app.filter_SecondaryType10}                         % MUNICÍPIO
                    filterType    = 'textFree';
                    filterDefault = {};

                case app.filter_SecondaryType9                            % UF
                    filterType    = 'textList2';
                    filterDefault = app.rfDataHubSummary.State.Categories;

                case app.filter_SecondaryType12                           % ROI
                    filterType    = 'ROI';
                    filterDefault = {'ROI:Círculo', 'ROI:Retângulo', 'ROI:Polígono'};

                case app.filter_SecondaryType13                           % Padrão de antena
                    filterType    = 'textList3';
                    filterDefault = {'-1'};
            end

            layout_FilterOperationPanel(app, filterType, filterDefault)
            filter_SecondaryValuePanelSelectionChanged(app)
            
        end

        % Selection changed function: filter_SecondaryValuePanel
        function filter_SecondaryValuePanelSelectionChanged(app, event)
            
            selectedButton = app.filter_SecondaryValuePanel.SelectedObject;
            switch selectedButton
                case {app.filter_SecondaryOperation9, app.filter_SecondaryOperation10}
                    app.filter_SecondaryNumSeparator.Visible = 1;
                    app.filter_SecondaryNumValue2.Visible    = 1;
                    
                otherwise
                    app.filter_SecondaryNumSeparator.Visible = 0;
                    app.filter_SecondaryNumValue2.Visible    = 0;
            end
            
        end

        % Value changed function: filter_SecondaryReferenceFilter
        function filter_SecondaryReferenceFilterValueChanged(app, event)
            
            value = app.filter_SecondaryReferenceFilter.Value;
            if isempty(value)
                app.filter_SecondaryLogicalOperator.Items = {'E (&&)'};
            else
                app.filter_SecondaryLogicalOperator.Items = {'OU (||)'};
            end
            
        end

        % Image clicked function: filter_AddImage
        function filter_addFilter(app, event)
            
            selectedFilterType      = app.filter_SecondaryTypePanel.SelectedObject;
            selectedFilterOperation = app.filter_SecondaryValuePanel.SelectedObject;

            if isempty(app.filter_SecondaryReferenceFilter.Value)
                Order     = 'Node';
                RelatedID = -1;
            else
                Order     = 'Child';
                RelatedID = str2double(app.filter_SecondaryReferenceFilter.Value(2:end));
            end
            UUID = char(matlab.lang.internal.uuid());

            switch selectedFilterType
                case {app.filter_SecondaryType1, ...                      % BASE DE DADOS
                      app.filter_SecondaryType9, ...                      % UF
                      app.filter_SecondaryType13}                         % PADRÃO DA ANTENA
                    Value = app.filter_SecondaryTextList.Value;

                case {app.filter_SecondaryType2, ...                      % FREQUÊNCIA
                      app.filter_SecondaryType3, ...                      % LARGURA BANDA
                      app.filter_SecondaryType6, ...                      % FISTEL
                      app.filter_SecondaryType7, ...                      % SERVIÇO
                      app.filter_SecondaryType8, ...                      % ESTAÇÃO
                      app.filter_SecondaryType11}                         % DISTÂNCIA

                    if ismember(selectedFilterOperation.Text, {'<>', '><'})
                        Value = [app.filter_SecondaryNumValue1.Value, ...
                                 app.filter_SecondaryNumValue2.Value];
                    else
                        Value = app.filter_SecondaryNumValue1.Value;
                    end

                case {app.filter_SecondaryType4, ...                      % CLASSE EMISSÃO (DESIGNAÇÃO)
                      app.filter_SecondaryType5, ...                      % ENTIDADE
                      app.filter_SecondaryType10}                         % MUNICÍPIO
                    Value = app.filter_SecondaryTextFree.Value;

                case app.filter_SecondaryType12                           % ROI
                    hROI = [];

                    plot.axes.Interactivity.DefaultDisable(app.UIAxes1)
                    pause(.1)

                    switch app.filter_SecondaryTextList.Value
                        case 'ROI:Círculo';   roiFcn = 'drawcircle';    roiNameArgument = '';
                        case 'ROI:Retângulo'; roiFcn = 'drawrectangle'; roiNameArgument = 'Rotatable=true, ';
                        case 'ROI:Polígono';  roiFcn = 'drawpolygon';   roiNameArgument = '';
                    end
                    eval(sprintf('hROI = %s(app.UIAxes1, Color=[0.40,0.73,0.88], LineWidth=1, Deletable=0, FaceSelectable=0, %sTag="FilterROI", UserData="%s");', roiFcn, roiNameArgument, UUID))
                    plot.axes.Interactivity.DefaultEnable(app.UIAxes1)

                    if isempty(hROI.Position)
                        delete(hROI)
                        return
                    end
                    addlistener(hROI, 'MovingROI', @app.filter_ROICallbacks);
                    addlistener(hROI, 'ROIMoved',  @app.filter_ROICallbacks);
                    addlistener(hROI, 'ObjectBeingDestroyed', @(src, ~)plot.axes.Interactivity.DeleteROIListeners(src));
                    Value = {hROI};                    
            end

            newFilter     = {Order, height(app.filterTable)+1, RelatedID,           ...
                             selectedFilterType.Text, selectedFilterOperation.Text, ...
                             str2double(selectedFilterType.Tag), Value, true, UUID};
            newFilterFlag = true;

            for ii = 1:height(app.filterTable)
                if isequal(app.filterTable{ii,[4,5,7]}, newFilter([4,5,7]))
                    newFilterFlag = false;
                    break
                end
            end

            if ~newFilterFlag
                msg = 'Filtro já incluído!';
                appUtil.modalWindow(app.UIFigure, 'warning', msg);
                if exist('hROI', 'var')
                    delete(hROI)
                end
                
                return
            end

            filter_AddNewFilter(app, newFilter)
            filter_TreeBuilding(app)
            filter_TableFiltering(app)

        end

        % Menu selected function: filter_delAllButton, filter_delButton
        function filter_delFilter(app, event)
            
            if isempty(app.filterTable)
                return
            end

            switch event.Source
                case app.filter_delButton
                    if isempty(app.filter_Tree.SelectedNodes)
                        return
                    end
                    idx1 = arrayfun(@(x) x.NodeData, app.filter_Tree.SelectedNodes);
                    
                    % Identifica se algum dos fluxos selecionado é um nó de
                    % filtros, inserindo na lista os seus filhos.
                    idx1 = [idx1, find(ismember(app.filterTable.RelatedID, idx1))'];

                case app.filter_delAllButton
                    idx1 = 1:height(app.filterTable);
            end 
    
            if ~isempty(idx1)
                % Apaga os ROI's, caso existentes.
                idx2 = find(strcmp(app.filterTable.Type, 'ROI'))';
                for ii = idx2
                    if ismember(ii, idx1)
                        UUID = app.filterTable.uuid{ii};
                        delete(findobj(app.UIAxes1.Children, 'UserData', UUID))
                    end
                end                

                % E depois atualiza a tabela de filtros, a tabela renderizada
                % no app e, por fim, o plot.
                app.filterTable(idx1,:) = [];

                filter_TreeBuilding(app)
                filter_TableFiltering(app)
            end

        end

        % Callback function: filter_Tree
        function filter_TreeCheckedNodesChanged(app, event)
            
            hTree             = findobj(app.filter_Tree, '-not', 'Type', 'uicheckboxtree');
            
            hTreeNode         = arrayfun(@(x) x.NodeData, hTree, 'UniformOutput', false);
            hTreeNodeDataList = unique(horzcat(hTreeNode{:}));

            hCheckedNode      = arrayfun(@(x) x.NodeData, app.filter_Tree.CheckedNodes, 'UniformOutput', false);
            hCheckedNodeData  = unique(horzcat(hCheckedNode{:}));

            disableIndexList  = setdiff(hTreeNodeDataList, hCheckedNodeData);
            enableIndexList   = setdiff((1:height(app.filterTable))', disableIndexList);

            app.filterTable.Enable(disableIndexList) = false;
            app.filterTable.Enable(enableIndexList)  = true;

            filter_TableFiltering(app)
            
        end

        % Callback function: config_RX_Color, config_Station_Color, 
        % ...and 1 other component
        function config_geoAxesColorParameterChanged(app, event)
            
            selectedColor = event.Source.Value;

            switch event.Source
                case app.config_Station_Color
                    set(findobj(app.UIAxes1.Children, 'Tag', 'Stations'), 'MarkerFaceColor', selectedColor, 'MarkerEdgeColor', selectedColor)

                case app.config_TX_Color
                    set(findobj(app.UIAxes1.Children, 'Type', 'scatter', 'Tag', 'TX'), 'MarkerFaceColor', selectedColor, 'MarkerEdgeColor', selectedColor)

                case app.config_RX_Color
                    set(findobj(app.UIAxes1.Children, 'Tag', 'RX'),  'MarkerFaceColor', selectedColor, 'MarkerEdgeColor', selectedColor)
            end

        end

        % Callback function: config_Basemap, config_Colormap, 
        % ...and 4 other components
        function config_geoAxesOthersParametersChanged(app, event)
            
            switch event.Source
                case app.config_Basemap
                    if ~strcmp(app.UIAxes1.Basemap, event.Value)
                        switch event.Value
                            case 'none'
                                set(app.UIAxes1, 'Basemap', event.Value, 'Box', 'on', 'AxisColor', [.8,.8,.8])
                                app.GridLayout.ColumnWidth{4} = 0;
                                ccTools.compCustomizationV2(app.jsBackDoor, app.axesToolbarGrid, 'backgroundColor', 'transparent')

                            otherwise
                                set(app.UIAxes1, 'Basemap', event.Value, 'Box', 'off', 'AxisColor', 'white')
                                app.GridLayout.ColumnWidth{4} = 5;
                                ccTools.compCustomizationV2(app.jsBackDoor, app.axesToolbarGrid, 'backgroundColor', '#ffffff')
                        end

                        initialStationColor = app.config_Station_Color.Value;
                        switch event.Value
                            case {'streets-dark', 'satellite'}
                                if isequal(initialStationColor, [0.7882 0.2784 0.3412])
                                    StationDarkColor = [0,1,1];
                                    app.config_Station_Color.Value = StationDarkColor;
                                    set(findobj(app.UIAxes1.Children, 'Tag', 'Stations'), 'MarkerEdgeColor', StationDarkColor)
                                end                                

                            otherwise
                                if isequal(initialStationColor, [0,1,1])
                                    StationLightColor = [0.7882 0.2784 0.3412];
                                    app.config_Station_Color.Value = StationLightColor;
                                    set(findobj(app.UIAxes1.Children, 'Tag', 'Stations'), 'MarkerEdgeColor', StationLightColor)
                                end
                        end
                    end

                case app.config_Colormap
                    if strcmp(app.UIAxes1.UserData.Colormap, event.Value)
                        return
                    end

                    plot.axes.Colormap(app.UIAxes1, event.Value)

                case app.config_TX_DataTipVisibility
                    switch app.config_TX_DataTipVisibility.Value
                        case 'on'
                            [idxRFDataHub, idxSelectedRow] = getRFDataHubIndex(app);
                            plot_TX(app, idxRFDataHub, idxSelectedRow)
                            plot.axes.StackingOrder.execute(app.UIAxes1, 'appAnalise:RFDATAHUB')
                            
                        case 'off'
                            hDataTip = findobj(app.UIAxes1.Children, 'Type', 'datatip', 'Tag', 'TX');
                            delete(hDataTip)
                    end

                case app.config_Station_Size
                    set(findobj(app.UIAxes1.Children, 'Type', 'scatter', 'Tag', 'Stations'), 'SizeData', event.Value)

                case app.config_TX_Size
                    set(findobj(app.UIAxes1.Children, 'Type', 'scatter', 'Tag', 'TX'),       'SizeData', 20*event.Value)

                case app.config_RX_Size
                    set(findobj(app.UIAxes1.Children,                    'Tag', 'RX'),       'SizeData', 44*event.Value)
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
            app.GridLayout.ColumnWidth = {5, 325, 10, 5, 50, '1x', 10, '1x', 22, 22, 5};
            app.GridLayout.RowHeight = {5, 22, '1x', 10, '0.4x', 5, 34};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.BackgroundColor = [1 1 1];

            % Create ControlTabGrid
            app.ControlTabGrid = uigridlayout(app.GridLayout);
            app.ControlTabGrid.ColumnWidth = {'1x'};
            app.ControlTabGrid.RowHeight = {2, 24, '1x'};
            app.ControlTabGrid.ColumnSpacing = 5;
            app.ControlTabGrid.RowSpacing = 0;
            app.ControlTabGrid.Padding = [0 0 0 0];
            app.ControlTabGrid.Layout.Row = [2 5];
            app.ControlTabGrid.Layout.Column = 2;
            app.ControlTabGrid.BackgroundColor = [1 1 1];

            % Create ControlTabGroup
            app.ControlTabGroup = uitabgroup(app.ControlTabGrid);
            app.ControlTabGroup.AutoResizeChildren = 'off';
            app.ControlTabGroup.Layout.Row = [2 3];
            app.ControlTabGroup.Layout.Column = 1;

            % Create Tab_1
            app.Tab_1 = uitab(app.ControlTabGroup);

            % Create Tab1_Grid
            app.Tab1_Grid = uigridlayout(app.Tab_1);
            app.Tab1_Grid.ColumnWidth = {22, '1x', 16, 16, 0, 0};
            app.Tab1_Grid.RowHeight = {36, 59, '1x'};
            app.Tab1_Grid.ColumnSpacing = 5;
            app.Tab1_Grid.RowSpacing = 5;
            app.Tab1_Grid.Padding = [0 0 0 0];
            app.Tab1_Grid.BackgroundColor = [1 1 1];

            % Create referenceTX_Icon
            app.referenceTX_Icon = uiimage(app.Tab1_Grid);
            app.referenceTX_Icon.Layout.Row = 1;
            app.referenceTX_Icon.Layout.Column = 1;
            app.referenceTX_Icon.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Pin_32.png');

            % Create referenceTX_Label
            app.referenceTX_Label = uilabel(app.Tab1_Grid);
            app.referenceTX_Label.VerticalAlignment = 'bottom';
            app.referenceTX_Label.FontSize = 11;
            app.referenceTX_Label.Layout.Row = 1;
            app.referenceTX_Label.Layout.Column = 2;
            app.referenceTX_Label.Interpreter = 'html';
            app.referenceTX_Label.Text = {'<b>Estação transmissora - TX</b>'; '<font style="font-size: 9px; color: gray;">(Registro selecionado em tabela)</font>'};

            % Create referenceTX_Refresh
            app.referenceTX_Refresh = uiimage(app.Tab1_Grid);
            app.referenceTX_Refresh.ImageClickedFcn = createCallbackFcn(app, @referenceTX_EditionModeImageClicked, true);
            app.referenceTX_Refresh.Visible = 'off';
            app.referenceTX_Refresh.Tooltip = {'Retorna aos valores constantes em base'};
            app.referenceTX_Refresh.Layout.Row = 1;
            app.referenceTX_Refresh.Layout.Column = 3;
            app.referenceTX_Refresh.VerticalAlignment = 'bottom';
            app.referenceTX_Refresh.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Refresh_18.png');

            % Create referenceTX_EditionMode
            app.referenceTX_EditionMode = uiimage(app.Tab1_Grid);
            app.referenceTX_EditionMode.ImageClickedFcn = createCallbackFcn(app, @referenceTX_EditionModeImageClicked, true);
            app.referenceTX_EditionMode.Tooltip = {'Habilita painel de edição'};
            app.referenceTX_EditionMode.Layout.Row = 1;
            app.referenceTX_EditionMode.Layout.Column = 4;
            app.referenceTX_EditionMode.VerticalAlignment = 'bottom';
            app.referenceTX_EditionMode.ImageSource = 'Edit_32.png';

            % Create referenceTX_EditionConfirm
            app.referenceTX_EditionConfirm = uiimage(app.Tab1_Grid);
            app.referenceTX_EditionConfirm.ImageClickedFcn = createCallbackFcn(app, @referenceTX_EditionModeImageClicked, true);
            app.referenceTX_EditionConfirm.Enable = 'off';
            app.referenceTX_EditionConfirm.Tooltip = {'Confirma edição'};
            app.referenceTX_EditionConfirm.Layout.Row = 1;
            app.referenceTX_EditionConfirm.Layout.Column = 5;
            app.referenceTX_EditionConfirm.VerticalAlignment = 'bottom';
            app.referenceTX_EditionConfirm.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Ok_32Green.png');

            % Create referenceTX_EditionCancel
            app.referenceTX_EditionCancel = uiimage(app.Tab1_Grid);
            app.referenceTX_EditionCancel.ImageClickedFcn = createCallbackFcn(app, @referenceTX_EditionModeImageClicked, true);
            app.referenceTX_EditionCancel.Enable = 'off';
            app.referenceTX_EditionCancel.Tooltip = {'Cancela edição'};
            app.referenceTX_EditionCancel.Layout.Row = 1;
            app.referenceTX_EditionCancel.Layout.Column = 6;
            app.referenceTX_EditionCancel.VerticalAlignment = 'bottom';
            app.referenceTX_EditionCancel.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Delete_32Red.png');

            % Create referenceTX_Panel
            app.referenceTX_Panel = uipanel(app.Tab1_Grid);
            app.referenceTX_Panel.Layout.Row = 2;
            app.referenceTX_Panel.Layout.Column = [1 6];

            % Create referenceTX_Grid
            app.referenceTX_Grid = uigridlayout(app.referenceTX_Panel);
            app.referenceTX_Grid.ColumnWidth = {'1x', '1x', '1x'};
            app.referenceTX_Grid.RowHeight = {17, 22};
            app.referenceTX_Grid.RowSpacing = 5;
            app.referenceTX_Grid.Padding = [10 10 10 5];
            app.referenceTX_Grid.BackgroundColor = [1 1 1];

            % Create referenceTX_LatitudeLabel
            app.referenceTX_LatitudeLabel = uilabel(app.referenceTX_Grid);
            app.referenceTX_LatitudeLabel.VerticalAlignment = 'bottom';
            app.referenceTX_LatitudeLabel.FontSize = 10;
            app.referenceTX_LatitudeLabel.Layout.Row = 1;
            app.referenceTX_LatitudeLabel.Layout.Column = 1;
            app.referenceTX_LatitudeLabel.Text = 'Latitude:';

            % Create referenceTX_Latitude
            app.referenceTX_Latitude = uieditfield(app.referenceTX_Grid, 'numeric');
            app.referenceTX_Latitude.ValueDisplayFormat = '%.6f';
            app.referenceTX_Latitude.ValueChangedFcn = createCallbackFcn(app, @referenceTX_FieldValueChanged, true);
            app.referenceTX_Latitude.Editable = 'off';
            app.referenceTX_Latitude.FontSize = 11;
            app.referenceTX_Latitude.Layout.Row = 2;
            app.referenceTX_Latitude.Layout.Column = 1;
            app.referenceTX_Latitude.Value = -1;

            % Create referenceTX_LongitudeLabel
            app.referenceTX_LongitudeLabel = uilabel(app.referenceTX_Grid);
            app.referenceTX_LongitudeLabel.VerticalAlignment = 'bottom';
            app.referenceTX_LongitudeLabel.FontSize = 10;
            app.referenceTX_LongitudeLabel.Layout.Row = 1;
            app.referenceTX_LongitudeLabel.Layout.Column = 2;
            app.referenceTX_LongitudeLabel.Text = 'Longitude:';

            % Create referenceTX_Longitude
            app.referenceTX_Longitude = uieditfield(app.referenceTX_Grid, 'numeric');
            app.referenceTX_Longitude.ValueDisplayFormat = '%.6f';
            app.referenceTX_Longitude.ValueChangedFcn = createCallbackFcn(app, @referenceTX_FieldValueChanged, true);
            app.referenceTX_Longitude.Editable = 'off';
            app.referenceTX_Longitude.FontSize = 11;
            app.referenceTX_Longitude.Layout.Row = 2;
            app.referenceTX_Longitude.Layout.Column = 2;
            app.referenceTX_Longitude.Value = -1;

            % Create referenceTX_HeightLabel
            app.referenceTX_HeightLabel = uilabel(app.referenceTX_Grid);
            app.referenceTX_HeightLabel.VerticalAlignment = 'bottom';
            app.referenceTX_HeightLabel.FontSize = 10;
            app.referenceTX_HeightLabel.Layout.Row = 1;
            app.referenceTX_HeightLabel.Layout.Column = 3;
            app.referenceTX_HeightLabel.Text = 'Altura (m):';

            % Create referenceTX_Height
            app.referenceTX_Height = uieditfield(app.referenceTX_Grid, 'numeric');
            app.referenceTX_Height.Limits = [0 Inf];
            app.referenceTX_Height.ValueDisplayFormat = '%.1f';
            app.referenceTX_Height.Editable = 'off';
            app.referenceTX_Height.FontSize = 11;
            app.referenceTX_Height.Layout.Row = 2;
            app.referenceTX_Height.Layout.Column = 3;

            % Create stationInfoPanel
            app.stationInfoPanel = uipanel(app.Tab1_Grid);
            app.stationInfoPanel.Layout.Row = 3;
            app.stationInfoPanel.Layout.Column = [1 6];

            % Create stationInfoGrid
            app.stationInfoGrid = uigridlayout(app.stationInfoPanel);
            app.stationInfoGrid.ColumnWidth = {'1x', 140, 18};
            app.stationInfoGrid.RowHeight = {'1x', 140, 18};
            app.stationInfoGrid.RowSpacing = 0;
            app.stationInfoGrid.Padding = [0 0 0 0];
            app.stationInfoGrid.BackgroundColor = [1 1 1];

            % Create stationInfo
            app.stationInfo = uihtml(app.stationInfoGrid);
            app.stationInfo.HTMLSource = ' ';
            app.stationInfo.Layout.Row = [1 3];
            app.stationInfo.Layout.Column = [1 3];

            % Create AntennaPatternPanelPlot
            app.AntennaPatternPanelPlot = uipanel(app.stationInfoGrid);
            app.AntennaPatternPanelPlot.BorderType = 'none';
            app.AntennaPatternPanelPlot.BackgroundColor = [1 1 1];
            app.AntennaPatternPanelPlot.Layout.Row = 2;
            app.AntennaPatternPanelPlot.Layout.Column = 2;

            % Create Tab_2
            app.Tab_2 = uitab(app.ControlTabGroup);

            % Create Tab2_Grid
            app.Tab2_Grid = uigridlayout(app.Tab_2);
            app.Tab2_Grid.ColumnWidth = {22, '1x', 16, 16, 0, 0};
            app.Tab2_Grid.RowHeight = {36, 59, 22, 116, 134, 8, '1x'};
            app.Tab2_Grid.ColumnSpacing = 5;
            app.Tab2_Grid.RowSpacing = 5;
            app.Tab2_Grid.Padding = [0 0 0 0];
            app.Tab2_Grid.BackgroundColor = [1 1 1];

            % Create referenceRX_Icon
            app.referenceRX_Icon = uiimage(app.Tab2_Grid);
            app.referenceRX_Icon.Layout.Row = 1;
            app.referenceRX_Icon.Layout.Column = 1;
            app.referenceRX_Icon.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Pin_32Triangle.png');

            % Create referenceRX_Label
            app.referenceRX_Label = uilabel(app.Tab2_Grid);
            app.referenceRX_Label.VerticalAlignment = 'bottom';
            app.referenceRX_Label.FontSize = 11;
            app.referenceRX_Label.Layout.Row = 1;
            app.referenceRX_Label.Layout.Column = [2 3];
            app.referenceRX_Label.Interpreter = 'html';
            app.referenceRX_Label.Text = {'<b>Estação receptora - RX</b>'; '<font style="font-size: 9px; color: gray;">(Referência coluna calculada "Distância" e enlace)</font>'};

            % Create referenceRX_Refresh
            app.referenceRX_Refresh = uiimage(app.Tab2_Grid);
            app.referenceRX_Refresh.ImageClickedFcn = createCallbackFcn(app, @referenceRX_EditionModeImageClicked, true);
            app.referenceRX_Refresh.Visible = 'off';
            app.referenceRX_Refresh.Tooltip = {'Retorna aos valores iniciais'};
            app.referenceRX_Refresh.Layout.Row = 1;
            app.referenceRX_Refresh.Layout.Column = 3;
            app.referenceRX_Refresh.VerticalAlignment = 'bottom';
            app.referenceRX_Refresh.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Refresh_18.png');

            % Create referenceRX_EditionMode
            app.referenceRX_EditionMode = uiimage(app.Tab2_Grid);
            app.referenceRX_EditionMode.ImageClickedFcn = createCallbackFcn(app, @referenceRX_EditionModeImageClicked, true);
            app.referenceRX_EditionMode.Tooltip = {'Habilita painel de edição'};
            app.referenceRX_EditionMode.Layout.Row = 1;
            app.referenceRX_EditionMode.Layout.Column = 4;
            app.referenceRX_EditionMode.VerticalAlignment = 'bottom';
            app.referenceRX_EditionMode.ImageSource = 'Edit_32.png';

            % Create referenceRX_EditionConfirm
            app.referenceRX_EditionConfirm = uiimage(app.Tab2_Grid);
            app.referenceRX_EditionConfirm.ImageClickedFcn = createCallbackFcn(app, @referenceRX_EditionModeImageClicked, true);
            app.referenceRX_EditionConfirm.Enable = 'off';
            app.referenceRX_EditionConfirm.Tooltip = {'Confirma edição'};
            app.referenceRX_EditionConfirm.Layout.Row = 1;
            app.referenceRX_EditionConfirm.Layout.Column = 5;
            app.referenceRX_EditionConfirm.VerticalAlignment = 'bottom';
            app.referenceRX_EditionConfirm.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Ok_32Green.png');

            % Create referenceRX_EditionCancel
            app.referenceRX_EditionCancel = uiimage(app.Tab2_Grid);
            app.referenceRX_EditionCancel.ImageClickedFcn = createCallbackFcn(app, @referenceRX_EditionModeImageClicked, true);
            app.referenceRX_EditionCancel.Enable = 'off';
            app.referenceRX_EditionCancel.Tooltip = {'Cancela edição'};
            app.referenceRX_EditionCancel.Layout.Row = 1;
            app.referenceRX_EditionCancel.Layout.Column = 6;
            app.referenceRX_EditionCancel.VerticalAlignment = 'bottom';
            app.referenceRX_EditionCancel.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Delete_32Red.png');

            % Create referenceRX_Panel
            app.referenceRX_Panel = uipanel(app.Tab2_Grid);
            app.referenceRX_Panel.Layout.Row = 2;
            app.referenceRX_Panel.Layout.Column = [1 6];

            % Create referenceRX_Grid
            app.referenceRX_Grid = uigridlayout(app.referenceRX_Panel);
            app.referenceRX_Grid.ColumnWidth = {'1x', '1x', '1x'};
            app.referenceRX_Grid.RowHeight = {17, 22};
            app.referenceRX_Grid.RowSpacing = 5;
            app.referenceRX_Grid.Padding = [10 10 10 5];
            app.referenceRX_Grid.BackgroundColor = [1 1 1];

            % Create referenceRX_LatitudeLabel
            app.referenceRX_LatitudeLabel = uilabel(app.referenceRX_Grid);
            app.referenceRX_LatitudeLabel.VerticalAlignment = 'bottom';
            app.referenceRX_LatitudeLabel.FontSize = 10;
            app.referenceRX_LatitudeLabel.Layout.Row = 1;
            app.referenceRX_LatitudeLabel.Layout.Column = 1;
            app.referenceRX_LatitudeLabel.Text = 'Latitude:';

            % Create referenceRX_Latitude
            app.referenceRX_Latitude = uieditfield(app.referenceRX_Grid, 'numeric');
            app.referenceRX_Latitude.ValueDisplayFormat = '%.6f';
            app.referenceRX_Latitude.ValueChangedFcn = createCallbackFcn(app, @referenceRX_FieldValueChanged, true);
            app.referenceRX_Latitude.Editable = 'off';
            app.referenceRX_Latitude.FontSize = 11;
            app.referenceRX_Latitude.Layout.Row = 2;
            app.referenceRX_Latitude.Layout.Column = 1;
            app.referenceRX_Latitude.Value = -1;

            % Create referenceRX_LongitudeLabel
            app.referenceRX_LongitudeLabel = uilabel(app.referenceRX_Grid);
            app.referenceRX_LongitudeLabel.VerticalAlignment = 'bottom';
            app.referenceRX_LongitudeLabel.FontSize = 10;
            app.referenceRX_LongitudeLabel.Layout.Row = 1;
            app.referenceRX_LongitudeLabel.Layout.Column = 2;
            app.referenceRX_LongitudeLabel.Text = 'Longitude:';

            % Create referenceRX_Longitude
            app.referenceRX_Longitude = uieditfield(app.referenceRX_Grid, 'numeric');
            app.referenceRX_Longitude.ValueDisplayFormat = '%.6f';
            app.referenceRX_Longitude.ValueChangedFcn = createCallbackFcn(app, @referenceRX_FieldValueChanged, true);
            app.referenceRX_Longitude.Editable = 'off';
            app.referenceRX_Longitude.FontSize = 11;
            app.referenceRX_Longitude.Layout.Row = 2;
            app.referenceRX_Longitude.Layout.Column = 2;
            app.referenceRX_Longitude.Value = -1;

            % Create referenceRX_HeightLabel
            app.referenceRX_HeightLabel = uilabel(app.referenceRX_Grid);
            app.referenceRX_HeightLabel.VerticalAlignment = 'bottom';
            app.referenceRX_HeightLabel.FontSize = 10;
            app.referenceRX_HeightLabel.Layout.Row = 1;
            app.referenceRX_HeightLabel.Layout.Column = 3;
            app.referenceRX_HeightLabel.Text = 'Altura (metros):';

            % Create referenceRX_Height
            app.referenceRX_Height = uieditfield(app.referenceRX_Grid, 'numeric');
            app.referenceRX_Height.Limits = [0 Inf];
            app.referenceRX_Height.RoundFractionalValues = 'on';
            app.referenceRX_Height.ValueDisplayFormat = '%d';
            app.referenceRX_Height.Editable = 'off';
            app.referenceRX_Height.FontSize = 11;
            app.referenceRX_Height.Layout.Row = 2;
            app.referenceRX_Height.Layout.Column = 3;

            % Create filter_SecondaryLabel
            app.filter_SecondaryLabel = uilabel(app.Tab2_Grid);
            app.filter_SecondaryLabel.VerticalAlignment = 'bottom';
            app.filter_SecondaryLabel.FontSize = 10;
            app.filter_SecondaryLabel.Layout.Row = 3;
            app.filter_SecondaryLabel.Layout.Column = [1 2];
            app.filter_SecondaryLabel.Text = 'FILTRO';

            % Create filter_SecondaryTypePanel
            app.filter_SecondaryTypePanel = uibuttongroup(app.Tab2_Grid);
            app.filter_SecondaryTypePanel.AutoResizeChildren = 'off';
            app.filter_SecondaryTypePanel.SelectionChangedFcn = createCallbackFcn(app, @filter_typePanelSelectionChanged, true);
            app.filter_SecondaryTypePanel.BackgroundColor = [1 1 1];
            app.filter_SecondaryTypePanel.Layout.Row = 4;
            app.filter_SecondaryTypePanel.Layout.Column = [1 6];
            app.filter_SecondaryTypePanel.FontWeight = 'bold';
            app.filter_SecondaryTypePanel.FontSize = 10;

            % Create filter_SecondaryType1
            app.filter_SecondaryType1 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType1.Tag = '16';
            app.filter_SecondaryType1.Text = 'Fonte';
            app.filter_SecondaryType1.FontSize = 10;
            app.filter_SecondaryType1.Position = [10 89 48 22];
            app.filter_SecondaryType1.Value = true;

            % Create filter_SecondaryType2
            app.filter_SecondaryType2 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType2.Tag = '1';
            app.filter_SecondaryType2.Text = 'Frequência';
            app.filter_SecondaryType2.FontSize = 10;
            app.filter_SecondaryType2.Position = [10 68 83 22];

            % Create filter_SecondaryType3
            app.filter_SecondaryType3 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType3.Tag = '13';
            app.filter_SecondaryType3.Text = 'Largura banda';
            app.filter_SecondaryType3.FontSize = 10;
            app.filter_SecondaryType3.Position = [10 47 87 22];

            % Create filter_SecondaryType4
            app.filter_SecondaryType4 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType4.Tag = '12';
            app.filter_SecondaryType4.Text = 'Classe emissão';
            app.filter_SecondaryType4.FontSize = 10;
            app.filter_SecondaryType4.Position = [10 26 93 22];

            % Create filter_SecondaryType5
            app.filter_SecondaryType5 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType5.Tag = '2';
            app.filter_SecondaryType5.Text = 'Entidade';
            app.filter_SecondaryType5.FontSize = 10;
            app.filter_SecondaryType5.Position = [138 89 61 22];

            % Create filter_SecondaryType6
            app.filter_SecondaryType6 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType6.Tag = '3';
            app.filter_SecondaryType6.Text = 'Fistel';
            app.filter_SecondaryType6.FontSize = 10;
            app.filter_SecondaryType6.Position = [138 68 46 22];

            % Create filter_SecondaryType7
            app.filter_SecondaryType7 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType7.Tag = '4';
            app.filter_SecondaryType7.Text = 'Serviço';
            app.filter_SecondaryType7.FontSize = 10;
            app.filter_SecondaryType7.Position = [138 47 55 22];

            % Create filter_SecondaryType8
            app.filter_SecondaryType8 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType8.Tag = '5';
            app.filter_SecondaryType8.Text = 'Estação';
            app.filter_SecondaryType8.FontSize = 10;
            app.filter_SecondaryType8.Position = [138 26 58 22];

            % Create filter_SecondaryType9
            app.filter_SecondaryType9 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType9.Tag = '10';
            app.filter_SecondaryType9.Text = 'UF';
            app.filter_SecondaryType9.FontSize = 10;
            app.filter_SecondaryType9.Position = [231 89 35 22];

            % Create filter_SecondaryType10
            app.filter_SecondaryType10 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType10.Tag = '9';
            app.filter_SecondaryType10.Text = 'Município';
            app.filter_SecondaryType10.FontSize = 10;
            app.filter_SecondaryType10.Position = [231 68 65 22];

            % Create filter_SecondaryType11
            app.filter_SecondaryType11 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType11.Tag = '32';
            app.filter_SecondaryType11.Text = 'Distância';
            app.filter_SecondaryType11.FontSize = 10;
            app.filter_SecondaryType11.Position = [231 47 63 22];

            % Create filter_SecondaryType12
            app.filter_SecondaryType12 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType12.Tag = '-1';
            app.filter_SecondaryType12.Text = 'ROI';
            app.filter_SecondaryType12.FontSize = 10;
            app.filter_SecondaryType12.Position = [231 27 37 20];

            % Create filter_SecondaryType13
            app.filter_SecondaryType13 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType13.Tag = '27';
            app.filter_SecondaryType13.Text = 'Padrão de antena';
            app.filter_SecondaryType13.FontSize = 10;
            app.filter_SecondaryType13.Position = [10 5 102 22];

            % Create filter_SecondaryValuePanel
            app.filter_SecondaryValuePanel = uibuttongroup(app.Tab2_Grid);
            app.filter_SecondaryValuePanel.AutoResizeChildren = 'off';
            app.filter_SecondaryValuePanel.SelectionChangedFcn = createCallbackFcn(app, @filter_SecondaryValuePanelSelectionChanged, true);
            app.filter_SecondaryValuePanel.BackgroundColor = [1 1 1];
            app.filter_SecondaryValuePanel.Layout.Row = 5;
            app.filter_SecondaryValuePanel.Layout.Column = [1 6];

            % Create filter_SecondaryOperation1
            app.filter_SecondaryOperation1 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation1.Tag = 'numeric+textFree+textList2';
            app.filter_SecondaryOperation1.Tooltip = {'Igual'};
            app.filter_SecondaryOperation1.Text = '=';
            app.filter_SecondaryOperation1.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation1.Position = [10 101 24 22];
            app.filter_SecondaryOperation1.Value = true;

            % Create filter_SecondaryOperation2
            app.filter_SecondaryOperation2 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation2.Tag = 'numeric+textFree+textList2+textList3';
            app.filter_SecondaryOperation2.Tooltip = {'Diferente'};
            app.filter_SecondaryOperation2.Text = '≠';
            app.filter_SecondaryOperation2.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation2.Position = [42 101 24 22];

            % Create filter_SecondaryOperation3
            app.filter_SecondaryOperation3 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation3.Tag = 'ROI+textFree+textList1';
            app.filter_SecondaryOperation3.Tooltip = {'Contém'};
            app.filter_SecondaryOperation3.Text = '⊃';
            app.filter_SecondaryOperation3.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation3.Position = [73 101 24 22];

            % Create filter_SecondaryOperation4
            app.filter_SecondaryOperation4 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation4.Tag = 'textFree+textList1';
            app.filter_SecondaryOperation4.Tooltip = {'Não contém'};
            app.filter_SecondaryOperation4.Text = '⊅';
            app.filter_SecondaryOperation4.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation4.Position = [105 101 24 22];

            % Create filter_SecondaryOperation5
            app.filter_SecondaryOperation5 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation5.Tag = 'numeric';
            app.filter_SecondaryOperation5.Tooltip = {'Menor'};
            app.filter_SecondaryOperation5.Text = '<';
            app.filter_SecondaryOperation5.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation5.FontName = 'Consolas';
            app.filter_SecondaryOperation5.Position = [137 101 24 22];

            % Create filter_SecondaryOperation6
            app.filter_SecondaryOperation6 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation6.Tag = 'numeric';
            app.filter_SecondaryOperation6.Tooltip = {'Menor ou igual'};
            app.filter_SecondaryOperation6.Text = '≤';
            app.filter_SecondaryOperation6.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation6.Position = [168 101 24 22];

            % Create filter_SecondaryOperation7
            app.filter_SecondaryOperation7 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation7.Tag = 'numeric';
            app.filter_SecondaryOperation7.Tooltip = {'Maior'};
            app.filter_SecondaryOperation7.Text = '>';
            app.filter_SecondaryOperation7.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation7.Position = [198 101 24 22];

            % Create filter_SecondaryOperation8
            app.filter_SecondaryOperation8 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation8.Tag = 'numeric';
            app.filter_SecondaryOperation8.Tooltip = {'Maior ou igual'};
            app.filter_SecondaryOperation8.Text = '≥';
            app.filter_SecondaryOperation8.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation8.Position = [229 101 24 22];

            % Create filter_SecondaryOperation9
            app.filter_SecondaryOperation9 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation9.Tag = 'numeric';
            app.filter_SecondaryOperation9.Tooltip = {'Dentro do intervalo'};
            app.filter_SecondaryOperation9.Text = '><';
            app.filter_SecondaryOperation9.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation9.Position = [259 101 24 22];

            % Create filter_SecondaryOperation10
            app.filter_SecondaryOperation10 = uitogglebutton(app.filter_SecondaryValuePanel);
            app.filter_SecondaryOperation10.Tag = 'numeric';
            app.filter_SecondaryOperation10.Tooltip = {'Fora do intervalo'};
            app.filter_SecondaryOperation10.Text = '<>';
            app.filter_SecondaryOperation10.BackgroundColor = [1 1 1];
            app.filter_SecondaryOperation10.Position = [289 101 24 22];

            % Create filter_SecondaryValueSubpanel
            app.filter_SecondaryValueSubpanel = uipanel(app.filter_SecondaryValuePanel);
            app.filter_SecondaryValueSubpanel.AutoResizeChildren = 'off';
            app.filter_SecondaryValueSubpanel.BorderType = 'none';
            app.filter_SecondaryValueSubpanel.Position = [10 11 302 79];

            % Create filter_SecondaryValueGrid
            app.filter_SecondaryValueGrid = uigridlayout(app.filter_SecondaryValueSubpanel);
            app.filter_SecondaryValueGrid.ColumnWidth = {'1x', 10, '1x'};
            app.filter_SecondaryValueGrid.RowHeight = {22, 25, 22};
            app.filter_SecondaryValueGrid.ColumnSpacing = 5;
            app.filter_SecondaryValueGrid.RowSpacing = 5;
            app.filter_SecondaryValueGrid.Padding = [0 0 0 0];
            app.filter_SecondaryValueGrid.BackgroundColor = [1 1 1];

            % Create filter_SecondaryNumValue1
            app.filter_SecondaryNumValue1 = uieditfield(app.filter_SecondaryValueGrid, 'numeric');
            app.filter_SecondaryNumValue1.Limits = [-1 Inf];
            app.filter_SecondaryNumValue1.ValueDisplayFormat = '%10.10g';
            app.filter_SecondaryNumValue1.FontSize = 11;
            app.filter_SecondaryNumValue1.FontColor = [0.149 0.149 0.149];
            app.filter_SecondaryNumValue1.Visible = 'off';
            app.filter_SecondaryNumValue1.Layout.Row = 1;
            app.filter_SecondaryNumValue1.Layout.Column = 1;
            app.filter_SecondaryNumValue1.Value = -1;

            % Create filter_SecondaryNumSeparator
            app.filter_SecondaryNumSeparator = uilabel(app.filter_SecondaryValueGrid);
            app.filter_SecondaryNumSeparator.HorizontalAlignment = 'center';
            app.filter_SecondaryNumSeparator.FontSize = 11;
            app.filter_SecondaryNumSeparator.Visible = 'off';
            app.filter_SecondaryNumSeparator.Layout.Row = 1;
            app.filter_SecondaryNumSeparator.Layout.Column = 2;
            app.filter_SecondaryNumSeparator.Text = '-';

            % Create filter_SecondaryNumValue2
            app.filter_SecondaryNumValue2 = uieditfield(app.filter_SecondaryValueGrid, 'numeric');
            app.filter_SecondaryNumValue2.Limits = [-1 Inf];
            app.filter_SecondaryNumValue2.FontSize = 11;
            app.filter_SecondaryNumValue2.FontColor = [0.149 0.149 0.149];
            app.filter_SecondaryNumValue2.Visible = 'off';
            app.filter_SecondaryNumValue2.Layout.Row = 1;
            app.filter_SecondaryNumValue2.Layout.Column = 3;
            app.filter_SecondaryNumValue2.Value = -1;

            % Create filter_SecondaryTextFree
            app.filter_SecondaryTextFree = uieditfield(app.filter_SecondaryValueGrid, 'text');
            app.filter_SecondaryTextFree.FontSize = 11;
            app.filter_SecondaryTextFree.FontColor = [0.149 0.149 0.149];
            app.filter_SecondaryTextFree.Visible = 'off';
            app.filter_SecondaryTextFree.Layout.Row = 1;
            app.filter_SecondaryTextFree.Layout.Column = [1 3];

            % Create filter_SecondaryTextList
            app.filter_SecondaryTextList = uidropdown(app.filter_SecondaryValueGrid);
            app.filter_SecondaryTextList.Items = {};
            app.filter_SecondaryTextList.FontSize = 11;
            app.filter_SecondaryTextList.BackgroundColor = [1 1 1];
            app.filter_SecondaryTextList.Layout.Row = 1;
            app.filter_SecondaryTextList.Layout.Column = [1 3];
            app.filter_SecondaryTextList.Value = {};

            % Create filter_SecondaryReferenceFilterLabel
            app.filter_SecondaryReferenceFilterLabel = uilabel(app.filter_SecondaryValueGrid);
            app.filter_SecondaryReferenceFilterLabel.VerticalAlignment = 'bottom';
            app.filter_SecondaryReferenceFilterLabel.FontSize = 10;
            app.filter_SecondaryReferenceFilterLabel.Layout.Row = 2;
            app.filter_SecondaryReferenceFilterLabel.Layout.Column = 1;
            app.filter_SecondaryReferenceFilterLabel.Text = {'Filtro de '; 'referência (ID):'};

            % Create filter_SecondaryReferenceFilter
            app.filter_SecondaryReferenceFilter = uidropdown(app.filter_SecondaryValueGrid);
            app.filter_SecondaryReferenceFilter.Items = {};
            app.filter_SecondaryReferenceFilter.ValueChangedFcn = createCallbackFcn(app, @filter_SecondaryReferenceFilterValueChanged, true);
            app.filter_SecondaryReferenceFilter.FontSize = 11;
            app.filter_SecondaryReferenceFilter.BackgroundColor = [1 1 1];
            app.filter_SecondaryReferenceFilter.Layout.Row = 3;
            app.filter_SecondaryReferenceFilter.Layout.Column = 1;
            app.filter_SecondaryReferenceFilter.Value = {};

            % Create filter_SecondaryLogicalOperatorLabel
            app.filter_SecondaryLogicalOperatorLabel = uilabel(app.filter_SecondaryValueGrid);
            app.filter_SecondaryLogicalOperatorLabel.VerticalAlignment = 'bottom';
            app.filter_SecondaryLogicalOperatorLabel.FontSize = 10;
            app.filter_SecondaryLogicalOperatorLabel.Layout.Row = 2;
            app.filter_SecondaryLogicalOperatorLabel.Layout.Column = 3;
            app.filter_SecondaryLogicalOperatorLabel.Text = {'Operador '; 'lógico:'};

            % Create filter_SecondaryLogicalOperator
            app.filter_SecondaryLogicalOperator = uidropdown(app.filter_SecondaryValueGrid);
            app.filter_SecondaryLogicalOperator.Items = {'E (&&)'};
            app.filter_SecondaryLogicalOperator.FontSize = 11;
            app.filter_SecondaryLogicalOperator.BackgroundColor = [1 1 1];
            app.filter_SecondaryLogicalOperator.Layout.Row = 3;
            app.filter_SecondaryLogicalOperator.Layout.Column = 3;
            app.filter_SecondaryLogicalOperator.Value = 'E (&&)';

            % Create filter_AddImage
            app.filter_AddImage = uiimage(app.Tab2_Grid);
            app.filter_AddImage.ImageClickedFcn = createCallbackFcn(app, @filter_addFilter, true);
            app.filter_AddImage.Tooltip = {'Adicionar filtro'};
            app.filter_AddImage.Layout.Row = 6;
            app.filter_AddImage.Layout.Column = 4;
            app.filter_AddImage.ImageSource = 'addSymbol_32.png';

            % Create filter_Tree
            app.filter_Tree = uitree(app.Tab2_Grid, 'checkbox');
            app.filter_Tree.FontSize = 10;
            app.filter_Tree.Layout.Row = 7;
            app.filter_Tree.Layout.Column = [1 6];

            % Assign Checked Nodes
            app.filter_Tree.CheckedNodesChangedFcn = createCallbackFcn(app, @filter_TreeCheckedNodesChanged, true);

            % Create Tab_3
            app.Tab_3 = uitab(app.ControlTabGroup);
            app.Tab_3.AutoResizeChildren = 'off';

            % Create Tab3_Grid
            app.Tab3_Grid = uigridlayout(app.Tab_3);
            app.Tab3_Grid.ColumnWidth = {'1x', 16};
            app.Tab3_Grid.RowHeight = {22, 186, 22, '1x'};
            app.Tab3_Grid.ColumnSpacing = 5;
            app.Tab3_Grid.RowSpacing = 5;
            app.Tab3_Grid.Padding = [0 0 0 0];
            app.Tab3_Grid.BackgroundColor = [1 1 1];

            % Create config_geoAxesLabel
            app.config_geoAxesLabel = uilabel(app.Tab3_Grid);
            app.config_geoAxesLabel.VerticalAlignment = 'bottom';
            app.config_geoAxesLabel.WordWrap = 'on';
            app.config_geoAxesLabel.FontSize = 10;
            app.config_geoAxesLabel.Layout.Row = 1;
            app.config_geoAxesLabel.Layout.Column = [1 2];
            app.config_geoAxesLabel.Text = 'EIXO GEOGRÁFICO';

            % Create config_Refresh
            app.config_Refresh = uiimage(app.Tab3_Grid);
            app.config_Refresh.Visible = 'off';
            app.config_Refresh.Tooltip = {'Volta à configuração inicial'};
            app.config_Refresh.Layout.Row = 1;
            app.config_Refresh.Layout.Column = 2;
            app.config_Refresh.VerticalAlignment = 'bottom';
            app.config_Refresh.ImageSource = 'Refresh_18.png';

            % Create config_geoAxesPanel
            app.config_geoAxesPanel = uipanel(app.Tab3_Grid);
            app.config_geoAxesPanel.Layout.Row = 2;
            app.config_geoAxesPanel.Layout.Column = [1 2];

            % Create config_geoAxesGrid
            app.config_geoAxesGrid = uigridlayout(app.config_geoAxesPanel);
            app.config_geoAxesGrid.ColumnWidth = {120, 36, '1x', 50};
            app.config_geoAxesGrid.RowHeight = {17, 64, 22, 22, 22};
            app.config_geoAxesGrid.RowSpacing = 5;
            app.config_geoAxesGrid.Padding = [10 10 10 5];
            app.config_geoAxesGrid.BackgroundColor = [1 1 1];

            % Create config_geoAxesSublabel
            app.config_geoAxesSublabel = uilabel(app.config_geoAxesGrid);
            app.config_geoAxesSublabel.VerticalAlignment = 'bottom';
            app.config_geoAxesSublabel.FontSize = 10;
            app.config_geoAxesSublabel.Layout.Row = 1;
            app.config_geoAxesSublabel.Layout.Column = 1;
            app.config_geoAxesSublabel.Text = 'Mapa:';

            % Create config_geoAxesSubPanel
            app.config_geoAxesSubPanel = uipanel(app.config_geoAxesGrid);
            app.config_geoAxesSubPanel.Layout.Row = 2;
            app.config_geoAxesSubPanel.Layout.Column = [1 4];

            % Create config_geoAxesSubGrid
            app.config_geoAxesSubGrid = uigridlayout(app.config_geoAxesSubPanel);
            app.config_geoAxesSubGrid.ColumnWidth = {'1x', 114};
            app.config_geoAxesSubGrid.RowHeight = {17, 22};
            app.config_geoAxesSubGrid.RowSpacing = 5;
            app.config_geoAxesSubGrid.Padding = [10 10 10 5];
            app.config_geoAxesSubGrid.BackgroundColor = [1 1 1];

            % Create config_BasemapLabel
            app.config_BasemapLabel = uilabel(app.config_geoAxesSubGrid);
            app.config_BasemapLabel.VerticalAlignment = 'bottom';
            app.config_BasemapLabel.FontSize = 10;
            app.config_BasemapLabel.Layout.Row = 1;
            app.config_BasemapLabel.Layout.Column = 1;
            app.config_BasemapLabel.Text = 'Basemap:';

            % Create config_Basemap
            app.config_Basemap = uidropdown(app.config_geoAxesSubGrid);
            app.config_Basemap.Items = {'none', 'darkwater', 'streets-light', 'streets-dark', 'satellite', 'topographic', 'grayterrain'};
            app.config_Basemap.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesOthersParametersChanged, true);
            app.config_Basemap.FontSize = 11;
            app.config_Basemap.BackgroundColor = [1 1 1];
            app.config_Basemap.Layout.Row = 2;
            app.config_Basemap.Layout.Column = 1;
            app.config_Basemap.Value = 'satellite';

            % Create config_ColormapLabel
            app.config_ColormapLabel = uilabel(app.config_geoAxesSubGrid);
            app.config_ColormapLabel.VerticalAlignment = 'bottom';
            app.config_ColormapLabel.FontSize = 10;
            app.config_ColormapLabel.Layout.Row = 1;
            app.config_ColormapLabel.Layout.Column = 2;
            app.config_ColormapLabel.Text = 'Mapa de cor:';

            % Create config_Colormap
            app.config_Colormap = uidropdown(app.config_geoAxesSubGrid);
            app.config_Colormap.Items = {'winter', 'parula', 'turbo', 'gray', 'hot', 'jet', 'summer'};
            app.config_Colormap.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesOthersParametersChanged, true);
            app.config_Colormap.FontSize = 11;
            app.config_Colormap.BackgroundColor = [1 1 1];
            app.config_Colormap.Layout.Row = 2;
            app.config_Colormap.Layout.Column = 2;
            app.config_Colormap.Value = 'winter';

            % Create config_TX_Label
            app.config_TX_Label = uilabel(app.config_geoAxesGrid);
            app.config_TX_Label.WordWrap = 'on';
            app.config_TX_Label.FontSize = 10;
            app.config_TX_Label.Layout.Row = 4;
            app.config_TX_Label.Layout.Column = [1 2];
            app.config_TX_Label.Text = 'Estação transmissora - TX:';

            % Create config_TX_Color
            app.config_TX_Color = uicolorpicker(app.config_geoAxesGrid);
            app.config_TX_Color.Value = [0.7882 0.2784 0.3412];
            app.config_TX_Color.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesColorParameterChanged, true);
            app.config_TX_Color.Layout.Row = 4;
            app.config_TX_Color.Layout.Column = 2;
            app.config_TX_Color.BackgroundColor = [1 1 1];

            % Create config_TX_Size
            app.config_TX_Size = uislider(app.config_geoAxesGrid);
            app.config_TX_Size.Limits = [1 3];
            app.config_TX_Size.MajorTicks = [];
            app.config_TX_Size.ValueChangingFcn = createCallbackFcn(app, @config_geoAxesOthersParametersChanged, true);
            app.config_TX_Size.MinorTicks = [];
            app.config_TX_Size.FontSize = 10;
            app.config_TX_Size.Tooltip = {'Tamanho do marcador'};
            app.config_TX_Size.Layout.Row = 4;
            app.config_TX_Size.Layout.Column = 3;
            app.config_TX_Size.Value = 1;

            % Create config_RX_Label
            app.config_RX_Label = uilabel(app.config_geoAxesGrid);
            app.config_RX_Label.WordWrap = 'on';
            app.config_RX_Label.FontSize = 10;
            app.config_RX_Label.Layout.Row = 5;
            app.config_RX_Label.Layout.Column = [1 2];
            app.config_RX_Label.Text = 'Estação receptora - RX:';

            % Create config_RX_Color
            app.config_RX_Color = uicolorpicker(app.config_geoAxesGrid);
            app.config_RX_Color.Value = [0.7882 0.2784 0.3373];
            app.config_RX_Color.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesColorParameterChanged, true);
            app.config_RX_Color.Layout.Row = 5;
            app.config_RX_Color.Layout.Column = 2;
            app.config_RX_Color.BackgroundColor = [1 1 1];

            % Create config_RX_Size
            app.config_RX_Size = uislider(app.config_geoAxesGrid);
            app.config_RX_Size.Limits = [1 3];
            app.config_RX_Size.MajorTicks = [];
            app.config_RX_Size.ValueChangingFcn = createCallbackFcn(app, @config_geoAxesOthersParametersChanged, true);
            app.config_RX_Size.MinorTicks = [];
            app.config_RX_Size.FontSize = 10;
            app.config_RX_Size.Tooltip = {'Tamanho do marcador'};
            app.config_RX_Size.Layout.Row = 5;
            app.config_RX_Size.Layout.Column = [3 4];
            app.config_RX_Size.Value = 1;

            % Create config_Station_Label
            app.config_Station_Label = uilabel(app.config_geoAxesGrid);
            app.config_Station_Label.WordWrap = 'on';
            app.config_Station_Label.FontSize = 10;
            app.config_Station_Label.Layout.Row = 3;
            app.config_Station_Label.Layout.Column = [1 2];
            app.config_Station_Label.Text = 'Estações RFDataHub:';

            % Create config_Station_Color
            app.config_Station_Color = uicolorpicker(app.config_geoAxesGrid);
            app.config_Station_Color.Value = [0 1 1];
            app.config_Station_Color.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesColorParameterChanged, true);
            app.config_Station_Color.Layout.Row = 3;
            app.config_Station_Color.Layout.Column = 2;
            app.config_Station_Color.BackgroundColor = [1 1 1];

            % Create config_Station_Size
            app.config_Station_Size = uislider(app.config_geoAxesGrid);
            app.config_Station_Size.Limits = [1 36];
            app.config_Station_Size.MajorTicks = [];
            app.config_Station_Size.ValueChangingFcn = createCallbackFcn(app, @config_geoAxesOthersParametersChanged, true);
            app.config_Station_Size.MinorTicks = [];
            app.config_Station_Size.FontSize = 10;
            app.config_Station_Size.Tooltip = {'Tamanho do marcador'};
            app.config_Station_Size.Layout.Row = 3;
            app.config_Station_Size.Layout.Column = [3 4];
            app.config_Station_Size.Value = 1;

            % Create config_TX_DataTipVisibility
            app.config_TX_DataTipVisibility = uidropdown(app.config_geoAxesGrid);
            app.config_TX_DataTipVisibility.Items = {'on', 'off'};
            app.config_TX_DataTipVisibility.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesOthersParametersChanged, true);
            app.config_TX_DataTipVisibility.Tooltip = {'Datatip'};
            app.config_TX_DataTipVisibility.FontSize = 11;
            app.config_TX_DataTipVisibility.BackgroundColor = [1 1 1];
            app.config_TX_DataTipVisibility.Layout.Row = 4;
            app.config_TX_DataTipVisibility.Layout.Column = 4;
            app.config_TX_DataTipVisibility.Value = 'off';

            % Create ELEVAOLabel
            app.ELEVAOLabel = uilabel(app.Tab3_Grid);
            app.ELEVAOLabel.VerticalAlignment = 'bottom';
            app.ELEVAOLabel.FontSize = 10;
            app.ELEVAOLabel.Layout.Row = 3;
            app.ELEVAOLabel.Layout.Column = 1;
            app.ELEVAOLabel.Text = 'ELEVAÇÃO';

            % Create misc_ElevationSourcePanel
            app.misc_ElevationSourcePanel = uipanel(app.Tab3_Grid);
            app.misc_ElevationSourcePanel.AutoResizeChildren = 'off';
            app.misc_ElevationSourcePanel.Layout.Row = 4;
            app.misc_ElevationSourcePanel.Layout.Column = [1 2];

            % Create misc_ElevationSourceGrid
            app.misc_ElevationSourceGrid = uigridlayout(app.misc_ElevationSourcePanel);
            app.misc_ElevationSourceGrid.ColumnWidth = {'1x', '1x', 105};
            app.misc_ElevationSourceGrid.RowHeight = {17, 22};
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
            app.misc_ElevationAPISource.FontSize = 11;
            app.misc_ElevationAPISource.BackgroundColor = [1 1 1];
            app.misc_ElevationAPISource.Layout.Row = 2;
            app.misc_ElevationAPISource.Layout.Column = [1 2];
            app.misc_ElevationAPISource.Value = 'Open-Elevation';

            % Create misc_PointsPerLinkLabel
            app.misc_PointsPerLinkLabel = uilabel(app.misc_ElevationSourceGrid);
            app.misc_PointsPerLinkLabel.VerticalAlignment = 'bottom';
            app.misc_PointsPerLinkLabel.FontSize = 10;
            app.misc_PointsPerLinkLabel.Layout.Row = 1;
            app.misc_PointsPerLinkLabel.Layout.Column = 3;
            app.misc_PointsPerLinkLabel.Text = 'Pontos enlace:';

            % Create misc_PointsPerLink
            app.misc_PointsPerLink = uidropdown(app.misc_ElevationSourceGrid);
            app.misc_PointsPerLink.Items = {'64', '128', '256', '512', '1024'};
            app.misc_PointsPerLink.FontSize = 11;
            app.misc_PointsPerLink.BackgroundColor = [1 1 1];
            app.misc_PointsPerLink.Layout.Row = 2;
            app.misc_PointsPerLink.Layout.Column = 3;
            app.misc_PointsPerLink.Value = '256';

            % Create menu_MainGrid
            app.menu_MainGrid = uigridlayout(app.ControlTabGrid);
            app.menu_MainGrid.ColumnWidth = {'1x', 22, 22};
            app.menu_MainGrid.RowHeight = {'1x', 3};
            app.menu_MainGrid.ColumnSpacing = 1;
            app.menu_MainGrid.RowSpacing = 0;
            app.menu_MainGrid.Padding = [0 0 0 0];
            app.menu_MainGrid.Layout.Row = [1 2];
            app.menu_MainGrid.Layout.Column = 1;
            app.menu_MainGrid.BackgroundColor = [1 1 1];

            % Create menuUnderline
            app.menuUnderline = uiimage(app.menu_MainGrid);
            app.menuUnderline.ScaleMethod = 'scaleup';
            app.menuUnderline.Layout.Row = 2;
            app.menuUnderline.Layout.Column = 1;
            app.menuUnderline.ImageSource = 'LineH.png';

            % Create menu_Button1Grid
            app.menu_Button1Grid = uigridlayout(app.menu_MainGrid);
            app.menu_Button1Grid.ColumnWidth = {18, '1x'};
            app.menu_Button1Grid.RowHeight = {'1x'};
            app.menu_Button1Grid.ColumnSpacing = 3;
            app.menu_Button1Grid.Padding = [2 0 0 0];
            app.menu_Button1Grid.Layout.Row = 1;
            app.menu_Button1Grid.Layout.Column = 1;
            app.menu_Button1Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create menu_Button1Label
            app.menu_Button1Label = uilabel(app.menu_Button1Grid);
            app.menu_Button1Label.FontSize = 11;
            app.menu_Button1Label.Layout.Row = 1;
            app.menu_Button1Label.Layout.Column = 2;
            app.menu_Button1Label.Text = 'RFDATAHUB';

            % Create menu_Button1Icon
            app.menu_Button1Icon = uiimage(app.menu_Button1Grid);
            app.menu_Button1Icon.ScaleMethod = 'none';
            app.menu_Button1Icon.ImageClickedFcn = createCallbackFcn(app, @general_ControlPanelSelectionChanged, true);
            app.menu_Button1Icon.Tag = '1';
            app.menu_Button1Icon.Layout.Row = 1;
            app.menu_Button1Icon.Layout.Column = [1 2];
            app.menu_Button1Icon.HorizontalAlignment = 'left';
            app.menu_Button1Icon.ImageSource = 'mosaic_18Gray.png';

            % Create menu_Button2Grid
            app.menu_Button2Grid = uigridlayout(app.menu_MainGrid);
            app.menu_Button2Grid.ColumnWidth = {18, 0};
            app.menu_Button2Grid.RowHeight = {'1x'};
            app.menu_Button2Grid.ColumnSpacing = 3;
            app.menu_Button2Grid.Padding = [2 0 0 0];
            app.menu_Button2Grid.Layout.Row = 1;
            app.menu_Button2Grid.Layout.Column = 2;
            app.menu_Button2Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create menu_Button2Label
            app.menu_Button2Label = uilabel(app.menu_Button2Grid);
            app.menu_Button2Label.FontSize = 11;
            app.menu_Button2Label.Layout.Row = 1;
            app.menu_Button2Label.Layout.Column = 2;
            app.menu_Button2Label.Text = 'FILTRAGEM';

            % Create menu_Button2Icon
            app.menu_Button2Icon = uiimage(app.menu_Button2Grid);
            app.menu_Button2Icon.ScaleMethod = 'none';
            app.menu_Button2Icon.ImageClickedFcn = createCallbackFcn(app, @general_ControlPanelSelectionChanged, true);
            app.menu_Button2Icon.Tag = '2';
            app.menu_Button2Icon.Layout.Row = 1;
            app.menu_Button2Icon.Layout.Column = [1 2];
            app.menu_Button2Icon.HorizontalAlignment = 'left';
            app.menu_Button2Icon.ImageSource = 'Filter_18.png';

            % Create menu_Button3Grid
            app.menu_Button3Grid = uigridlayout(app.menu_MainGrid);
            app.menu_Button3Grid.ColumnWidth = {18, 0};
            app.menu_Button3Grid.RowHeight = {'1x'};
            app.menu_Button3Grid.ColumnSpacing = 3;
            app.menu_Button3Grid.Padding = [2 0 0 0];
            app.menu_Button3Grid.Layout.Row = 1;
            app.menu_Button3Grid.Layout.Column = 3;
            app.menu_Button3Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create menu_Button3Label
            app.menu_Button3Label = uilabel(app.menu_Button3Grid);
            app.menu_Button3Label.FontSize = 11;
            app.menu_Button3Label.Layout.Row = 1;
            app.menu_Button3Label.Layout.Column = 2;
            app.menu_Button3Label.Text = 'CONFIGURAÇÕES GERAIS';

            % Create menu_Button3Icon
            app.menu_Button3Icon = uiimage(app.menu_Button3Grid);
            app.menu_Button3Icon.ScaleMethod = 'none';
            app.menu_Button3Icon.ImageClickedFcn = createCallbackFcn(app, @general_ControlPanelSelectionChanged, true);
            app.menu_Button3Icon.Tag = '3';
            app.menu_Button3Icon.Layout.Row = 1;
            app.menu_Button3Icon.Layout.Column = [1 2];
            app.menu_Button3Icon.HorizontalAlignment = 'left';
            app.menu_Button3Icon.ImageSource = 'Settings_18.png';

            % Create plotPanel
            app.plotPanel = uipanel(app.GridLayout);
            app.plotPanel.BorderType = 'none';
            app.plotPanel.BackgroundColor = [1 1 1];
            app.plotPanel.Layout.Row = [2 3];
            app.plotPanel.Layout.Column = [4 6];

            % Create axesToolbarGrid
            app.axesToolbarGrid = uigridlayout(app.GridLayout);
            app.axesToolbarGrid.ColumnWidth = {22, 22};
            app.axesToolbarGrid.RowHeight = {'1x'};
            app.axesToolbarGrid.ColumnSpacing = 0;
            app.axesToolbarGrid.Padding = [2 2 2 7];
            app.axesToolbarGrid.Layout.Row = [1 2];
            app.axesToolbarGrid.Layout.Column = 5;
            app.axesToolbarGrid.BackgroundColor = [1 1 1];

            % Create axesTool_RestoreView
            app.axesTool_RestoreView = uiimage(app.axesToolbarGrid);
            app.axesTool_RestoreView.ImageClickedFcn = createCallbackFcn(app, @axesTool_InteractionImageClicked, true);
            app.axesTool_RestoreView.Tooltip = {'RestoreView'};
            app.axesTool_RestoreView.Layout.Row = 1;
            app.axesTool_RestoreView.Layout.Column = 1;
            app.axesTool_RestoreView.ImageSource = 'Home_18.png';

            % Create axesTool_RegionZoom
            app.axesTool_RegionZoom = uiimage(app.axesToolbarGrid);
            app.axesTool_RegionZoom.ImageClickedFcn = createCallbackFcn(app, @axesTool_InteractionImageClicked, true);
            app.axesTool_RegionZoom.Tooltip = {'RegionZoom'};
            app.axesTool_RegionZoom.Layout.Row = 1;
            app.axesTool_RegionZoom.Layout.Column = 2;
            app.axesTool_RegionZoom.ImageSource = 'ZoomRegion_20.png';

            % Create chReportHTML
            app.chReportHTML = uihtml(app.GridLayout);
            app.chReportHTML.HTMLSource = 'Warning2.html';
            app.chReportHTML.Layout.Row = 3;
            app.chReportHTML.Layout.Column = [8 10];

            % Create chReportDownloadTime
            app.chReportDownloadTime = uilabel(app.GridLayout);
            app.chReportDownloadTime.BackgroundColor = [0.1961 0.2118 0.2235];
            app.chReportDownloadTime.FontSize = 10;
            app.chReportDownloadTime.FontColor = [0.902 0.902 0.902];
            app.chReportDownloadTime.Layout.Row = 2;
            app.chReportDownloadTime.Layout.Column = [8 10];
            app.chReportDownloadTime.Text = '';

            % Create chReportHotDownload
            app.chReportHotDownload = uiimage(app.GridLayout);
            app.chReportHotDownload.ScaleMethod = 'none';
            app.chReportHotDownload.ImageClickedFcn = createCallbackFcn(app, @tool_chReportPanelImageClicked, true);
            app.chReportHotDownload.Visible = 'off';
            app.chReportHotDownload.Tooltip = {'Baixa versão atual do documento'};
            app.chReportHotDownload.Layout.Row = 2;
            app.chReportHotDownload.Layout.Column = 9;
            app.chReportHotDownload.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Import_16.png');

            % Create chReportUndock
            app.chReportUndock = uiimage(app.GridLayout);
            app.chReportUndock.ScaleMethod = 'none';
            app.chReportUndock.ImageClickedFcn = createCallbackFcn(app, @tool_chReportPanelImageClicked, true);
            app.chReportUndock.Visible = 'off';
            app.chReportUndock.Tooltip = {'Abre documento em leitor externo'};
            app.chReportUndock.Layout.Row = 2;
            app.chReportUndock.Layout.Column = 10;
            app.chReportUndock.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Undock_18Gray.png');

            % Create UITable
            app.UITable = uitable(app.GridLayout);
            app.UITable.ColumnName = {'ID'; 'FREQUÊNCIA|(MHz)'; 'DESCRIÇÃO|(Entidade+Fistel+Multiplicidade+Localidade)'; 'SERVIÇO'; 'ESTAÇÃO'; 'LARGURA|(kHz)'; 'DISTÂNCIA|(km)'};
            app.UITable.ColumnWidth = {60, 110, 'auto', 75, 75, 75, 90};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [false true false true true true true];
            app.UITable.SelectionChangedFcn = createCallbackFcn(app, @UITableSelectionChanged, true);
            app.UITable.Multiselect = 'off';
            app.UITable.ForegroundColor = [0.149 0.149 0.149];
            app.UITable.Layout.Row = 5;
            app.UITable.Layout.Column = [4 10];
            app.UITable.FontSize = 10;

            % Create toolGrid
            app.toolGrid = uigridlayout(app.GridLayout);
            app.toolGrid.ColumnWidth = {22, 22, 22, 22, 5, 22, 22, '1x', 18};
            app.toolGrid.RowHeight = {4, 17, '1x'};
            app.toolGrid.ColumnSpacing = 5;
            app.toolGrid.RowSpacing = 0;
            app.toolGrid.Padding = [0 5 5 5];
            app.toolGrid.Layout.Row = 7;
            app.toolGrid.Layout.Column = [1 11];
            app.toolGrid.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create tool_ControlPanelVisibility
            app.tool_ControlPanelVisibility = uiimage(app.toolGrid);
            app.tool_ControlPanelVisibility.ImageClickedFcn = createCallbackFcn(app, @tool_InteractionImageClicked, true);
            app.tool_ControlPanelVisibility.Layout.Row = 2;
            app.tool_ControlPanelVisibility.Layout.Column = 1;
            app.tool_ControlPanelVisibility.ImageSource = 'ArrowLeft_32.png';

            % Create tool_TableVisibility
            app.tool_TableVisibility = uiimage(app.toolGrid);
            app.tool_TableVisibility.ScaleMethod = 'none';
            app.tool_TableVisibility.ImageClickedFcn = createCallbackFcn(app, @tool_InteractionImageClicked, true);
            app.tool_TableVisibility.Tooltip = {'Visibilidade da tabela'};
            app.tool_TableVisibility.Layout.Row = 2;
            app.tool_TableVisibility.Layout.Column = 2;
            app.tool_TableVisibility.ImageSource = 'View_16.png';

            % Create tool_RFLinkButton
            app.tool_RFLinkButton = uiimage(app.toolGrid);
            app.tool_RFLinkButton.ScaleMethod = 'none';
            app.tool_RFLinkButton.ImageClickedFcn = createCallbackFcn(app, @tool_InteractionImageClicked, true);
            app.tool_RFLinkButton.Tooltip = {'Perfil de terreno entre registro selecionado (TX) '; 'e estação de referência (RX)'};
            app.tool_RFLinkButton.Layout.Row = 2;
            app.tool_RFLinkButton.Layout.Column = 3;
            app.tool_RFLinkButton.VerticalAlignment = 'top';
            app.tool_RFLinkButton.ImageSource = 'Publish_HTML_16.png';

            % Create tool_PDFButton
            app.tool_PDFButton = uiimage(app.toolGrid);
            app.tool_PDFButton.ScaleMethod = 'none';
            app.tool_PDFButton.ImageClickedFcn = createCallbackFcn(app, @tool_InteractionImageClicked, true);
            app.tool_PDFButton.Tooltip = {'Documento relacionado ao registro selecionado'; '(limitado à radiodifusão)'};
            app.tool_PDFButton.Layout.Row = 2;
            app.tool_PDFButton.Layout.Column = 4;
            app.tool_PDFButton.VerticalAlignment = 'top';
            app.tool_PDFButton.ImageSource = 'Publish_PDF_16.png';

            % Create tool_Separator
            app.tool_Separator = uiimage(app.toolGrid);
            app.tool_Separator.Enable = 'off';
            app.tool_Separator.Layout.Row = [1 3];
            app.tool_Separator.Layout.Column = 5;
            app.tool_Separator.VerticalAlignment = 'bottom';
            app.tool_Separator.ImageSource = fullfile(pathToMLAPP, 'Icons', 'LineV.png');

            % Create tool_ExportButton
            app.tool_ExportButton = uiimage(app.toolGrid);
            app.tool_ExportButton.ScaleMethod = 'none';
            app.tool_ExportButton.ImageClickedFcn = createCallbackFcn(app, @tool_exportButtonPushed, true);
            app.tool_ExportButton.Layout.Row = 2;
            app.tool_ExportButton.Layout.Column = 6;
            app.tool_ExportButton.ImageSource = 'Export_16.png';

            % Create jsBackDoor
            app.jsBackDoor = uihtml(app.toolGrid);
            app.jsBackDoor.Layout.Row = 2;
            app.jsBackDoor.Layout.Column = 7;

            % Create tool_tableNRows
            app.tool_tableNRows = uilabel(app.toolGrid);
            app.tool_tableNRows.HorizontalAlignment = 'right';
            app.tool_tableNRows.FontSize = 10;
            app.tool_tableNRows.FontColor = [0.6 0.6 0.6];
            app.tool_tableNRows.Layout.Row = [1 3];
            app.tool_tableNRows.Layout.Column = 8;
            app.tool_tableNRows.Text = '';

            % Create tool_tableNRowsIcon
            app.tool_tableNRowsIcon = uiimage(app.toolGrid);
            app.tool_tableNRowsIcon.ScaleMethod = 'none';
            app.tool_tableNRowsIcon.Enable = 'off';
            app.tool_tableNRowsIcon.Layout.Row = 2;
            app.tool_tableNRowsIcon.Layout.Column = 9;
            app.tool_tableNRowsIcon.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Filter_18.png');

            % Create filter_ContextMenu
            app.filter_ContextMenu = uicontextmenu(app.UIFigure);

            % Create filter_delButton
            app.filter_delButton = uimenu(app.filter_ContextMenu);
            app.filter_delButton.MenuSelectedFcn = createCallbackFcn(app, @filter_delFilter, true);
            app.filter_delButton.Text = 'Excluir';

            % Create filter_delAllButton
            app.filter_delAllButton = uimenu(app.filter_ContextMenu);
            app.filter_delAllButton.MenuSelectedFcn = createCallbackFcn(app, @filter_delFilter, true);
            app.filter_delAllButton.Text = 'Excluir todos';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = winRFDataHub_exported(Container, varargin)

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
