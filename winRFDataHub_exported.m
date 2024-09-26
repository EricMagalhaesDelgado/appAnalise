classdef winRFDataHub_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        toolGrid                        matlab.ui.container.GridLayout
        tool_tableNRowsIcon             matlab.ui.control.Image
        tool_tableNRows                 matlab.ui.control.Label
        jsBackDoor                      matlab.ui.control.HTML
        tool_ExportButton               matlab.ui.control.Image
        tool_Separator                  matlab.ui.control.Image
        tool_simulationButton           matlab.ui.control.Image
        tool_PDFButton                  matlab.ui.control.Image
        tool_TableVisibility            matlab.ui.control.Image
        tool_ControlPanelVisibility     matlab.ui.control.Image
        UITable                         matlab.ui.control.Table
        chReportUndock                  matlab.ui.control.Image
        chReportHotDownload             matlab.ui.control.Image
        chReportDownloadTime            matlab.ui.control.Label
        chReportHTML                    matlab.ui.control.HTML
        axesToolbarGrid                 matlab.ui.container.GridLayout
        axesTool_RegionZoom             matlab.ui.control.Image
        axesTool_RestoreView            matlab.ui.control.Image
        plotPanel                       matlab.ui.container.Panel
        ControlTabGrid                  matlab.ui.container.GridLayout
        menu_MainGrid                   matlab.ui.container.GridLayout
        menu_Button3Grid                matlab.ui.container.GridLayout
        menu_Button3Icon                matlab.ui.control.Image
        menu_Button3Label               matlab.ui.control.Label
        menu_Button2Grid                matlab.ui.container.GridLayout
        menu_Button2Icon                matlab.ui.control.Image
        menu_Button2Label               matlab.ui.control.Label
        menu_Button1Grid                matlab.ui.container.GridLayout
        menu_Button1Icon                matlab.ui.control.Image
        menu_Button1Label               matlab.ui.control.Label
        menuUnderline                   matlab.ui.control.Image
        ControlTabGroup                 matlab.ui.container.TabGroup
        Tab_1                           matlab.ui.container.Tab
        Tab1_Grid                       matlab.ui.container.GridLayout
        filter_refRXEdit_2              matlab.ui.control.Image
        search_SelectedRowInfoPanel     matlab.ui.container.Panel
        search_SelectedRowInfoGrid      matlab.ui.container.GridLayout
        PlotPanel                       matlab.ui.container.Panel
        stationInfo                     matlab.ui.control.HTML
        filter_refTXPanel               matlab.ui.container.Panel
        filter_refTXGrid                matlab.ui.container.GridLayout
        filter_refTXHeight              matlab.ui.control.NumericEditField
        filter_refTXHeightLabel         matlab.ui.control.Label
        filter_refTXLongitude           matlab.ui.control.NumericEditField
        filter_refTXLongitudeLabel      matlab.ui.control.Label
        filter_refTXLatitude            matlab.ui.control.NumericEditField
        filter_refTXLatitudeLabel       matlab.ui.control.Label
        filter_refTXLabel               matlab.ui.control.Label
        filter_refTXIcon                matlab.ui.control.Image
        Tab_2                           matlab.ui.container.Tab
        Tab2_Grid                       matlab.ui.container.GridLayout
        filter_Tree                     matlab.ui.container.CheckBoxTree
        filter_AddImage                 matlab.ui.control.Image
        filter_SecondaryValuePanel      matlab.ui.container.ButtonGroup
        filter_SecondaryValueSubpanel   matlab.ui.container.Panel
        filter_SecondaryValueGrid       matlab.ui.container.GridLayout
        filter_SecondaryLogicalOperator  matlab.ui.control.DropDown
        filter_SecondaryLogicalOperatorLabel  matlab.ui.control.Label
        filter_SecondaryReferenceFilter  matlab.ui.control.DropDown
        filter_SecondaryReferenceFilterLabel  matlab.ui.control.Label
        filter_SecondaryTextList        matlab.ui.control.DropDown
        filter_SecondaryTextFree        matlab.ui.control.EditField
        filter_SecondaryNumValue2       matlab.ui.control.NumericEditField
        filter_SecondaryNumSeparator    matlab.ui.control.Label
        filter_SecondaryNumValue1       matlab.ui.control.NumericEditField
        filter_SecondaryOperation10     matlab.ui.control.ToggleButton
        filter_SecondaryOperation9      matlab.ui.control.ToggleButton
        filter_SecondaryOperation8      matlab.ui.control.ToggleButton
        filter_SecondaryOperation7      matlab.ui.control.ToggleButton
        filter_SecondaryOperation6      matlab.ui.control.ToggleButton
        filter_SecondaryOperation5      matlab.ui.control.ToggleButton
        filter_SecondaryOperation4      matlab.ui.control.ToggleButton
        filter_SecondaryOperation3      matlab.ui.control.ToggleButton
        filter_SecondaryOperation2      matlab.ui.control.ToggleButton
        filter_SecondaryOperation1      matlab.ui.control.ToggleButton
        filter_SecondaryTypePanel       matlab.ui.container.ButtonGroup
        filter_SecondaryType12          matlab.ui.control.RadioButton
        filter_SecondaryType11          matlab.ui.control.RadioButton
        filter_SecondaryType10          matlab.ui.control.RadioButton
        filter_SecondaryType9           matlab.ui.control.RadioButton
        filter_SecondaryType8           matlab.ui.control.RadioButton
        filter_SecondaryType7           matlab.ui.control.RadioButton
        filter_SecondaryType6           matlab.ui.control.RadioButton
        filter_SecondaryType5           matlab.ui.control.RadioButton
        filter_SecondaryType4           matlab.ui.control.RadioButton
        filter_SecondaryType3           matlab.ui.control.RadioButton
        filter_SecondaryType2           matlab.ui.control.RadioButton
        filter_SecondaryType1           matlab.ui.control.RadioButton
        filter_SecondaryLabel           matlab.ui.control.Label
        filter_refRXPanel               matlab.ui.container.Panel
        filter_refRXGrid                matlab.ui.container.GridLayout
        filter_refRXHeight              matlab.ui.control.NumericEditField
        filter_refRXHeightLabel         matlab.ui.control.Label
        filter_refRXLongitude           matlab.ui.control.NumericEditField
        filter_refRXLongitudeLabel      matlab.ui.control.Label
        filter_refRXLatitude            matlab.ui.control.NumericEditField
        filter_refRXLatitudeLabel       matlab.ui.control.Label
        filter_refRXEdit                matlab.ui.control.Image
        filter_refRXLabel               matlab.ui.control.Label
        filter_refRXIcon                matlab.ui.control.Image
        Tab_3                           matlab.ui.container.Tab
        Tab4_Grid                       matlab.ui.container.GridLayout
        config_FolderMapPanel           matlab.ui.container.Panel
        config_FolderMapGrid            matlab.ui.container.GridLayout
        config_Folder_userPathButton    matlab.ui.control.Image
        config_Folder_userPath          matlab.ui.control.DropDown
        config_Folder_userPathLabel     matlab.ui.control.Label
        config_Folder_DataHubGETButton  matlab.ui.control.Image
        config_Folder_DataHubGET        matlab.ui.control.EditField
        config_Folder_DataHubGETLabel   matlab.ui.control.Label
        misc_ElevationSourcePanel       matlab.ui.container.Panel
        misc_ElevationSourceGrid        matlab.ui.container.GridLayout
        misc_PointsPerLink              matlab.ui.control.DropDown
        misc_PointsPerLinkLabel         matlab.ui.control.Label
        misc_ElevationAPISource         matlab.ui.control.DropDown
        misc_ElevationAPISourceLabel    matlab.ui.control.Label
        ELEVAOLabel                     matlab.ui.control.Label
        config_xyAxesLabel              matlab.ui.control.Label
        config_geoAxesPanel             matlab.ui.container.Panel
        config_geoAxesGrid              matlab.ui.container.GridLayout
        config_Station_Size             matlab.ui.control.Slider
        config_Station_Color            matlab.ui.control.ColorPicker
        config_Station_DataTipVisibility  matlab.ui.control.DropDown
        config_Station_Label            matlab.ui.control.Label
        config_RX_Size                  matlab.ui.control.Slider
        config_RX_Color                 matlab.ui.control.ColorPicker
        config_RX_Visibility            matlab.ui.control.DropDown
        config_RX_Label                 matlab.ui.control.Label
        config_TX_Size                  matlab.ui.control.Slider
        config_TX_Color                 matlab.ui.control.ColorPicker
        config_TX_DataTipVisibility     matlab.ui.control.DropDown
        config_TX_Label                 matlab.ui.control.Label
        config_geoAxesSubPanel          matlab.ui.container.Panel
        config_geoAxesSubGrid           matlab.ui.container.GridLayout
        config_Colormap                 matlab.ui.control.DropDown
        config_ColormapLabel            matlab.ui.control.Label
        config_Basemap                  matlab.ui.control.DropDown
        config_BasemapLabel             matlab.ui.control.Label
        config_geoAxesSublabel          matlab.ui.control.Label
        config_Refresh                  matlab.ui.control.Image
        config_geoAxesLabel             matlab.ui.control.Label
        filter_ContextMenu              matlab.ui.container.ContextMenu
        filter_delButton                matlab.ui.container.Menu
        filter_delAllButton             matlab.ui.container.Menu
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
        
        UIAxes1
        UIAxes2
        UIAxes3
        restoreView  = struct('ID', {}, 'xLim', {}, 'yLim', {}, 'cLim', {})

        elevationObj = RF.Elevation
        ChannelReportObj

        filterTable  = table('Size',          [0, 9],                                                                      ...
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
                    ccTools.compCustomizationV2(app.jsBackDoor, app.PlotPanel,       'backgroundColor', 'transparent')

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
                    set(app.config_Folder_userPath, 'Items', userPaths, 'Value', userPaths{end})
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
            % refRX
            referenceRX_getWayPoint(app)

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
            referenceRX_CalculateDistance(app)
                        
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
            app.PlotPanel.AutoResizeChildren = 'off';
            app.UIAxes3 = polaraxes(app.PlotPanel, 'Units',             'normalized',    ...
                                                   'Position',          [.05,.05,.9,.9], ...
                                                   'ThetaZeroLocation', 'top',           ...
                                                   'FontSize',          9,               ...
                                                   'Color',             'none',          ...
                                                   'ThetaTick',         0,               ...
                                                   'ThetaDir',          'clockwise',     ...
                                                   'RTickLabel',        {});
            hold(app.UIAxes3, 'on')

            % Axes interactions:
            plot.axes.Interactivity.DefaultCreation(app.UIAxes1, [dataTipInteraction, zoomInteraction, panInteraction])
            plot.axes.Interactivity.DefaultCreation(app.UIAxes2, dataTipInteraction)
        end

        %-----------------------------------------------------------------%
        function startup_GUIComponents(app)
            app.filter_refRXEdit.UserData      = false;
            app.tool_TableVisibility.UserData  = true;
            app.tool_PDFButton.UserData        = false;
            app.tool_simulationButton.UserData = false;
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
        function referenceRX_getWayPoint(app)
            refRXFlag = false;
            for ii = 1:numel(app.specData)
                if app.specData(ii).GPS.Status
                    AntennaHeight = [];
                    if isfield(app.specData(ii).MetaData.Antenna, 'Height')
                        AntennaHeight = str2double(extractBefore(app.specData(ii).MetaData.Antenna.Height, 'm'));
                    end

                    if isempty(AntennaHeight) || isnan(AntennaHeight) || (AntennaHeight <= 0) || isinf(AntennaHeight)
                        AntennaHeight = app.General.RFDataHub.DefaultRX.Height;
                    end

                    app.filter_refRXLatitude.Value  = app.specData(ii).GPS.Latitude;
                    app.filter_refRXLongitude.Value = app.specData(ii).GPS.Longitude;
                    app.filter_refRXHeight.Value    = AntennaHeight;
                    
                    refRXFlag = true;
                    break
                end
            end

            if ~refRXFlag
                if ~isempty(app.General.RFDataHub.lastSearch)
                    app.filter_refRXLatitude.Value  = app.General.RFDataHub.lastSearch.RX.Latitude;
                    app.filter_refRXLongitude.Value = app.General.RFDataHub.lastSearch.RX.Longitude;
                    app.filter_refRXHeight.Value    = app.General.RFDataHub.lastSearch.RX.Height;
    
                else
                    app.filter_refRXLatitude.Value  = app.General.RFDataHub.DefaultRX.Latitude;
                    app.filter_refRXLongitude.Value = app.General.RFDataHub.DefaultRX.Longitude;
                    app.filter_refRXHeight.Value    = app.General.RFDataHub.DefaultRX.Height;
                end
            end
        end

        %-----------------------------------------------------------------%
        function referenceRX_CalculateDistance(app)
            app.rfDataHub.Distance = round(single(deg2km(distance(app.rfDataHub.Latitude,         ...
                                                                  app.rfDataHub.Longitude,        ...
                                                                  app.filter_refRXLatitude.Value, ...
                                                                  app.filter_refRXLongitude.Value))), 1);
        end

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

            if ~isempty(app.UITable.Data)
                geolimits(app.UIAxes1, 'auto')

                idxRFDataHubArray = app.UITable.UserData;
                latitudeArray     = app.rfDataHub.Latitude(idxRFDataHubArray);
                longitudeArray    = app.rfDataHub.Longitude(idxRFDataHubArray);

                hStations = geoscatter(app.UIAxes1, latitudeArray, longitudeArray, ...
                    'MarkerEdgeColor', app.config_Station_Color.Value,             ...
                    'SizeData',        app.config_Station_Size.Value,              ...
                    'Tag', 'Stations');
                plot.datatip.Template(hStations, 'winRFDataHub.Geographic', app.UITable.Data)
            end
        end

        %-----------------------------------------------------------------%
        function plot_RX(app)
            RX = struct('Latitude',  app.filter_refRXLatitude.Value, ...
                        'Longitude', app.filter_refRXLongitude.Value);

            geoscatter(app.UIAxes1, RX.Latitude, RX.Longitude,     ...
                'Marker',          '^',                            ...
                'MarkerEdgeColor', app.config_RX_Color.Value,      ...
                'MarkerFaceColor', app.config_RX_Color.Value,      ...
                'SizeData',        44*app.config_RX_Size.Value,    ...
                'PickableParts',   'none',                         ...
                'Visible',         app.config_RX_Visibility.Value, ...
                'Tag',             'RX');
        end

        %-----------------------------------------------------------------%
        function plot_TX(app, idxRFDataHub, idxSelectedRow)
            delete(findobj(app.UIAxes1.Children, 'Tag', 'TX'))

            if ~isempty(idxRFDataHub)
                TX = struct('Latitude',  app.rfDataHub.Latitude(idxRFDataHub), ...
                            'Longitude', app.rfDataHub.Longitude(idxRFDataHub));

                % DataTip
                hTXDataTip = findobj(app.UIAxes1.Children, 'Type', 'datatip', 'Tag', 'TX');
                if isempty(hTXDataTip)
                    hStations = findobj(app.UIAxes1.Children, 'Tag', 'Stations');
                    datatip(hStations,                                     ...
                        'DataIndex',       idxSelectedRow,                 ...
                        'PickableParts',   'none',                         ...
                        'Visible',         app.config_TX_DataTipVisibility.Value, ...
                        'Tag',             'TX');
                else
                    hTXDataTip.DataIndex = idxSelectedRow;
                end

                % Scatter
                hTXScatter = findobj(app.UIAxes1.Children, 'Type', 'scatter', 'Tag', 'TX');
                if isempty(hTXScatter)
                    geoscatter(app.UIAxes1, TX.Latitude, TX.Longitude,   ...
                        'LineWidth',       2,                            ...
                        'Marker',          'o',                          ...
                        'MarkerEdgeColor', app.config_TX_Color.Value,    ...
                        'MarkerFaceColor', app.config_TX_Color.Value,    ...
                        'SizeData',        20*app.config_TX_Size.Value , ...
                        'PickableParts',   'none',                       ...
                        'Tag',             'TX');
                else
                    set(hTXScatter, 'LatitudeData',  TX.Latitude, ...
                                    'LongitudeData', TX.Longitude)
                end
            end
        end

        %-----------------------------------------------------------------%
        function plot_createRFLinkPlot(app)
            delete(findobj(app.UIAxes1.Children, 'Tag', 'RFLink'))
            cla(app.UIAxes2)
            delete(findobj(app.UIAxes3.Children, 'Tag', 'Azimuth'))

            if app.tool_simulationButton.UserData && ~isempty(app.UITable.Selection)
                [idxRFDataHub, idxSelectedRow] = getRFDataHubIndex(app);

                app.progressDialog.Visible = 'visible';

                try
                    % OBJETOS TX e RX
                    [txObj, rxObj] = misc_RFLinkObjects(app, idxRFDataHub, idxSelectedRow);
        
                    % ELEVAÇÃO DO LINK TX-RX
                    [wayPoints3D, msgWarning] = Get(app.elevationObj, txObj, rxObj, str2double(app.misc_PointsPerLink.Value), false, app.misc_ElevationAPISource.Value);
                    if ~isempty(msgWarning)
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    end
        
                    % PLOT: RFLink Map
                    geoplot(app.UIAxes1, wayPoints3D(:,1), wayPoints3D(:,2), Color='#c94756', LineStyle='-.', PickableParts='none', Tag='RFLink');
                    
                    % PLOT: RFLink
                    plot.RFLink(app.UIAxes2, txObj, rxObj, wayPoints3D, 'light', true)
    
                    % PLOT: RFLink Azimuth
                    Azimuth = deg2rad(app.UIAxes2.UserData.Azimuth);
                    polarplot(app.UIAxes3, Azimuth,            app.UIAxes3.RLim(1), 'MarkerEdgeColor', '#c94756', 'MarkerFaceColor', '#c94756', 'Marker', 'o', 'Tag', 'Azimuth')
                    polarplot(app.UIAxes3, Azimuth,            app.UIAxes3.RLim(2), 'MarkerEdgeColor', '#c94756', 'MarkerFaceColor', '#c94756', 'Marker', '^', 'Tag', 'Azimuth')
                    polarplot(app.UIAxes3, [Azimuth, Azimuth], app.UIAxes3.RLim,    'Color', '#c94756', 'LineStyle', '-.', 'Tag', 'Azimuth')
                    
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
                app.search_SelectedRowInfoGrid.RowHeight{2} = 0;
            else
                app.search_SelectedRowInfoGrid.RowHeight{2} = 166;
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
        function [txSite, rxSite] = misc_RFLinkObjects(app, idxRFDataHub, idxSelectedRow)
            % txSite e rxSite estão como struct, mas basta mudar para "txsite" e 
            % "rxsite" que eles poderão ser usados em predições, uma vez que os 
            % campos da estrutura são idênticos às propriedades dos objetos.

            % TX
            txSite = struct('Name',                 'TX',                                                 ...
                            'TransmitterFrequency', double(app.rfDataHub.Frequency(idxRFDataHub)) * 1e+6, ...
                            'Latitude',             app.filter_refTXLatitude.Value,                       ...
                            'Longitude',            app.filter_refTXLongitude.Value,                      ...
                            'AntennaHeight',        app.filter_refTXHeight.Value, ...
                            'ID',                   app.UITable.Data.ID(idxSelectedRow));

            % RX
            rxSite = struct('Name',                 'RX',                            ...
                            'Latitude',             app.filter_refRXLatitude.Value,  ...
                            'Longitude',            app.filter_refRXLongitude.Value, ...
                            'AntennaHeight',        app.filter_refRXHeight.Value);
        end

        %-----------------------------------------------------------------%
        function layout_restartChannelReport(app)
            app.chReportHTML.HTMLSource     = 'Warning2.html';
            app.chReportDownloadTime.Text   = '';
            app.chReportHotDownload.Visible = 0;
            app.chReportUndock.Visible      = 0;
        end

        %-----------------------------------------------------------------%
        function layout_TableStyle(app, idxSelectedRow)
            removeStyle(app.UITable)
            if idxSelectedRow
                addStyle(app.UITable, uistyle('BackgroundColor', '#d8ebfa'), 'row', idxSelectedRow)
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

                case app.tool_simulationButton
                    app.tool_simulationButton.UserData = ~app.tool_simulationButton.UserData;
                    if app.tool_simulationButton.UserData
                        app.UIAxes1.Layout.TileSpan = [1,1];
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
            
                defaultFilename = class.Constants.DefaultFileName(app.config_Folder_userPath.Value, 'RFDataHub', -1);

                [fileName, filePath, fileIndex] = uiputfile({'*.xlsx', 'Excel (*.xlsx)'}, '', defaultFilename);
                figure(app.UIFigure)
                
                if fileIndex
                    d = appUtil.modalWindow(app.UIFigure, 'progressdlg', 'Em andamento...');

                    try
                        idxRFDataHubArray = app.UITable.UserData;
                        tempRFDataHub = class.RFDataHub.ColumnNames(app.rfDataHub(idxRFDataHubArray,1:29), 'eng2port');
                        writetable(tempRFDataHub, fullfile(filePath, fileName), 'WriteMode', 'overwritesheet')
                    catch ME
                        appUtil.modalWindow(app.UIFigure, 'warning', getReport(ME));
                    end

                    delete(d)
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
            layout_TableStyle(app, idxSelectedRow)
            cla(app.UIAxes3)

            app.stationInfo.UserData = idxRFDataHub;
            
            if isempty(idxRFDataHub)
                app.filter_refTXLatitude.Value  = -1;
                app.filter_refTXLongitude.Value = -1;
                app.filter_refTXHeight.Value    = 0;
                app.stationInfo.HTMLSource      = '';
                layout_restartChannelReport(app)
                delete(findobj(app.UIAxes1.Children, 'Tag', 'TX'))
                cla(app.UIAxes2)

            else
                % Estação transmissora - TX
                txAntennaHeight = str2double(char(app.rfDataHub.AntennaHeight(idxRFDataHub)));
                if txAntennaHeight <= 0
                    txAntennaHeight = 10;
                end

                app.filter_refTXLatitude.Value  = double(app.rfDataHub.Latitude(idxRFDataHub));
                app.filter_refTXLongitude.Value = double(app.rfDataHub.Longitude(idxRFDataHub));
                app.filter_refTXHeight.Value    = txAntennaHeight;

                % Painel HTML
                htmlContent = auxApp.rfdatahub.htmlCode_StationInfo(app.rfDataHub, idxRFDataHub, app.rfDataHubLOG);
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
                        polarplot(app.UIAxes3, angle, gain, 'Tag', 'AntennaPattern')
                    catch
                    end
                end

                % Plot "TX"
                plot_TX(app, idxRFDataHub, idxSelectedRow)

                % Plot "RFLink"
                plot_createRFLinkPlot(app)
            end
            
        end

        % Image clicked function: filter_refRXEdit
        function referenceRX_EditImageClicked(app, event)
            
            focus(app.filter_refRXLatitude)
            hEditFields = findobj(app.filter_refRXGrid.Children, '-not', 'Type', 'uilabel');

            app.filter_refRXEdit.UserData = ~app.filter_refRXEdit.UserData;
            if app.filter_refRXEdit.UserData
                app.filter_refRXEdit.ImageSource = 'Edit_32Filled.png';                
                set(hEditFields, 'Editable', true)
            else
                app.filter_refRXEdit.ImageSource = 'Edit_32.png';
                set(hEditFields, 'Editable', false)
            end            

        end

        % Value changed function: filter_refRXHeight, 
        % ...and 2 other components
        function referenceRX_FieldValueChanged(app, event)
            
            switch event.Source
                case app.filter_refRXLatitude
                    focus(app.filter_refRXLongitude)

                case app.filter_refRXLongitude
                    focus(app.filter_refRXHeight)

                case app.filter_refRXHeight
                    % ...
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
                      app.filter_SecondaryType9}                          % UF
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
                    set(findobj(app.UIAxes1.Children, 'Type', 'datatip', 'Tag', 'TX'), 'Visible', app.config_TX_DataTipVisibility.Value)

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
            app.Tab1_Grid.ColumnWidth = {22, '1x', 16, 16};
            app.Tab1_Grid.RowHeight = {36, 59, '1x'};
            app.Tab1_Grid.ColumnSpacing = 5;
            app.Tab1_Grid.RowSpacing = 5;
            app.Tab1_Grid.Padding = [0 0 0 0];
            app.Tab1_Grid.BackgroundColor = [1 1 1];

            % Create filter_refTXIcon
            app.filter_refTXIcon = uiimage(app.Tab1_Grid);
            app.filter_refTXIcon.Layout.Row = 1;
            app.filter_refTXIcon.Layout.Column = 1;
            app.filter_refTXIcon.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Pin_32.png');

            % Create filter_refTXLabel
            app.filter_refTXLabel = uilabel(app.Tab1_Grid);
            app.filter_refTXLabel.VerticalAlignment = 'bottom';
            app.filter_refTXLabel.FontSize = 11;
            app.filter_refTXLabel.Layout.Row = 1;
            app.filter_refTXLabel.Layout.Column = [2 3];
            app.filter_refTXLabel.Interpreter = 'html';
            app.filter_refTXLabel.Text = {'<b>Estação transmissora - TX</b>'; '<font style="font-size: 9px; color: gray;">(Registro selecionado em tabela)</font>'};

            % Create filter_refTXPanel
            app.filter_refTXPanel = uipanel(app.Tab1_Grid);
            app.filter_refTXPanel.Layout.Row = 2;
            app.filter_refTXPanel.Layout.Column = [1 4];

            % Create filter_refTXGrid
            app.filter_refTXGrid = uigridlayout(app.filter_refTXPanel);
            app.filter_refTXGrid.ColumnWidth = {'1x', '1x', '1x'};
            app.filter_refTXGrid.RowHeight = {17, 22};
            app.filter_refTXGrid.RowSpacing = 5;
            app.filter_refTXGrid.Padding = [10 10 10 5];
            app.filter_refTXGrid.BackgroundColor = [1 1 1];

            % Create filter_refTXLatitudeLabel
            app.filter_refTXLatitudeLabel = uilabel(app.filter_refTXGrid);
            app.filter_refTXLatitudeLabel.VerticalAlignment = 'bottom';
            app.filter_refTXLatitudeLabel.FontSize = 10;
            app.filter_refTXLatitudeLabel.Layout.Row = 1;
            app.filter_refTXLatitudeLabel.Layout.Column = 1;
            app.filter_refTXLatitudeLabel.Text = 'Latitude:';

            % Create filter_refTXLatitude
            app.filter_refTXLatitude = uieditfield(app.filter_refTXGrid, 'numeric');
            app.filter_refTXLatitude.ValueDisplayFormat = '%.6f';
            app.filter_refTXLatitude.Editable = 'off';
            app.filter_refTXLatitude.FontSize = 11;
            app.filter_refTXLatitude.Layout.Row = 2;
            app.filter_refTXLatitude.Layout.Column = 1;
            app.filter_refTXLatitude.Value = -1;

            % Create filter_refTXLongitudeLabel
            app.filter_refTXLongitudeLabel = uilabel(app.filter_refTXGrid);
            app.filter_refTXLongitudeLabel.VerticalAlignment = 'bottom';
            app.filter_refTXLongitudeLabel.FontSize = 10;
            app.filter_refTXLongitudeLabel.Layout.Row = 1;
            app.filter_refTXLongitudeLabel.Layout.Column = 2;
            app.filter_refTXLongitudeLabel.Text = 'Longitude:';

            % Create filter_refTXLongitude
            app.filter_refTXLongitude = uieditfield(app.filter_refTXGrid, 'numeric');
            app.filter_refTXLongitude.ValueDisplayFormat = '%.6f';
            app.filter_refTXLongitude.Editable = 'off';
            app.filter_refTXLongitude.FontSize = 11;
            app.filter_refTXLongitude.Layout.Row = 2;
            app.filter_refTXLongitude.Layout.Column = 2;
            app.filter_refTXLongitude.Value = -1;

            % Create filter_refTXHeightLabel
            app.filter_refTXHeightLabel = uilabel(app.filter_refTXGrid);
            app.filter_refTXHeightLabel.VerticalAlignment = 'bottom';
            app.filter_refTXHeightLabel.FontSize = 10;
            app.filter_refTXHeightLabel.Layout.Row = 1;
            app.filter_refTXHeightLabel.Layout.Column = 3;
            app.filter_refTXHeightLabel.Text = 'Altura (metros):';

            % Create filter_refTXHeight
            app.filter_refTXHeight = uieditfield(app.filter_refTXGrid, 'numeric');
            app.filter_refTXHeight.Limits = [0 Inf];
            app.filter_refTXHeight.RoundFractionalValues = 'on';
            app.filter_refTXHeight.ValueDisplayFormat = '%d';
            app.filter_refTXHeight.Editable = 'off';
            app.filter_refTXHeight.FontSize = 11;
            app.filter_refTXHeight.Layout.Row = 2;
            app.filter_refTXHeight.Layout.Column = 3;

            % Create search_SelectedRowInfoPanel
            app.search_SelectedRowInfoPanel = uipanel(app.Tab1_Grid);
            app.search_SelectedRowInfoPanel.Layout.Row = 3;
            app.search_SelectedRowInfoPanel.Layout.Column = [1 4];

            % Create search_SelectedRowInfoGrid
            app.search_SelectedRowInfoGrid = uigridlayout(app.search_SelectedRowInfoPanel);
            app.search_SelectedRowInfoGrid.ColumnWidth = {'1x', 140, 18};
            app.search_SelectedRowInfoGrid.RowHeight = {'1x', 140, 18};
            app.search_SelectedRowInfoGrid.RowSpacing = 0;
            app.search_SelectedRowInfoGrid.Padding = [0 0 0 0];
            app.search_SelectedRowInfoGrid.BackgroundColor = [1 1 1];

            % Create stationInfo
            app.stationInfo = uihtml(app.search_SelectedRowInfoGrid);
            app.stationInfo.HTMLSource = ' ';
            app.stationInfo.Layout.Row = [1 3];
            app.stationInfo.Layout.Column = [1 3];

            % Create PlotPanel
            app.PlotPanel = uipanel(app.search_SelectedRowInfoGrid);
            app.PlotPanel.BorderType = 'none';
            app.PlotPanel.BackgroundColor = [1 1 1];
            app.PlotPanel.Layout.Row = 2;
            app.PlotPanel.Layout.Column = 2;

            % Create filter_refRXEdit_2
            app.filter_refRXEdit_2 = uiimage(app.Tab1_Grid);
            app.filter_refRXEdit_2.Layout.Row = 1;
            app.filter_refRXEdit_2.Layout.Column = 4;
            app.filter_refRXEdit_2.VerticalAlignment = 'bottom';
            app.filter_refRXEdit_2.ImageSource = 'Edit_32.png';

            % Create Tab_2
            app.Tab_2 = uitab(app.ControlTabGroup);

            % Create Tab2_Grid
            app.Tab2_Grid = uigridlayout(app.Tab_2);
            app.Tab2_Grid.ColumnWidth = {22, '1x', 16, 16};
            app.Tab2_Grid.RowHeight = {36, 59, 22, 96, 134, 8, '1x'};
            app.Tab2_Grid.ColumnSpacing = 5;
            app.Tab2_Grid.RowSpacing = 5;
            app.Tab2_Grid.Padding = [0 0 0 0];
            app.Tab2_Grid.BackgroundColor = [1 1 1];

            % Create filter_refRXIcon
            app.filter_refRXIcon = uiimage(app.Tab2_Grid);
            app.filter_refRXIcon.Layout.Row = 1;
            app.filter_refRXIcon.Layout.Column = 1;
            app.filter_refRXIcon.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Pin_32Triangle.png');

            % Create filter_refRXLabel
            app.filter_refRXLabel = uilabel(app.Tab2_Grid);
            app.filter_refRXLabel.VerticalAlignment = 'bottom';
            app.filter_refRXLabel.FontSize = 11;
            app.filter_refRXLabel.Layout.Row = 1;
            app.filter_refRXLabel.Layout.Column = 2;
            app.filter_refRXLabel.Interpreter = 'html';
            app.filter_refRXLabel.Text = {'<b>Estação receptora - RX</b>'; '<font style="font-size: 9px; color: gray;">(Referência da coluna calculada "Distância" e do enlace)</font>'};

            % Create filter_refRXEdit
            app.filter_refRXEdit = uiimage(app.Tab2_Grid);
            app.filter_refRXEdit.ImageClickedFcn = createCallbackFcn(app, @referenceRX_EditImageClicked, true);
            app.filter_refRXEdit.Layout.Row = 1;
            app.filter_refRXEdit.Layout.Column = 4;
            app.filter_refRXEdit.VerticalAlignment = 'bottom';
            app.filter_refRXEdit.ImageSource = 'Edit_32.png';

            % Create filter_refRXPanel
            app.filter_refRXPanel = uipanel(app.Tab2_Grid);
            app.filter_refRXPanel.Layout.Row = 2;
            app.filter_refRXPanel.Layout.Column = [1 4];

            % Create filter_refRXGrid
            app.filter_refRXGrid = uigridlayout(app.filter_refRXPanel);
            app.filter_refRXGrid.ColumnWidth = {'1x', '1x', '1x'};
            app.filter_refRXGrid.RowHeight = {17, 22};
            app.filter_refRXGrid.RowSpacing = 5;
            app.filter_refRXGrid.Padding = [10 10 10 5];
            app.filter_refRXGrid.BackgroundColor = [1 1 1];

            % Create filter_refRXLatitudeLabel
            app.filter_refRXLatitudeLabel = uilabel(app.filter_refRXGrid);
            app.filter_refRXLatitudeLabel.VerticalAlignment = 'bottom';
            app.filter_refRXLatitudeLabel.FontSize = 10;
            app.filter_refRXLatitudeLabel.Layout.Row = 1;
            app.filter_refRXLatitudeLabel.Layout.Column = 1;
            app.filter_refRXLatitudeLabel.Text = 'Latitude:';

            % Create filter_refRXLatitude
            app.filter_refRXLatitude = uieditfield(app.filter_refRXGrid, 'numeric');
            app.filter_refRXLatitude.ValueDisplayFormat = '%.6f';
            app.filter_refRXLatitude.ValueChangedFcn = createCallbackFcn(app, @referenceRX_FieldValueChanged, true);
            app.filter_refRXLatitude.Editable = 'off';
            app.filter_refRXLatitude.FontSize = 11;
            app.filter_refRXLatitude.Layout.Row = 2;
            app.filter_refRXLatitude.Layout.Column = 1;
            app.filter_refRXLatitude.Value = -1;

            % Create filter_refRXLongitudeLabel
            app.filter_refRXLongitudeLabel = uilabel(app.filter_refRXGrid);
            app.filter_refRXLongitudeLabel.VerticalAlignment = 'bottom';
            app.filter_refRXLongitudeLabel.FontSize = 10;
            app.filter_refRXLongitudeLabel.Layout.Row = 1;
            app.filter_refRXLongitudeLabel.Layout.Column = 2;
            app.filter_refRXLongitudeLabel.Text = 'Longitude:';

            % Create filter_refRXLongitude
            app.filter_refRXLongitude = uieditfield(app.filter_refRXGrid, 'numeric');
            app.filter_refRXLongitude.ValueDisplayFormat = '%.6f';
            app.filter_refRXLongitude.ValueChangedFcn = createCallbackFcn(app, @referenceRX_FieldValueChanged, true);
            app.filter_refRXLongitude.Editable = 'off';
            app.filter_refRXLongitude.FontSize = 11;
            app.filter_refRXLongitude.Layout.Row = 2;
            app.filter_refRXLongitude.Layout.Column = 2;
            app.filter_refRXLongitude.Value = -1;

            % Create filter_refRXHeightLabel
            app.filter_refRXHeightLabel = uilabel(app.filter_refRXGrid);
            app.filter_refRXHeightLabel.VerticalAlignment = 'bottom';
            app.filter_refRXHeightLabel.FontSize = 10;
            app.filter_refRXHeightLabel.Layout.Row = 1;
            app.filter_refRXHeightLabel.Layout.Column = 3;
            app.filter_refRXHeightLabel.Text = 'Altura (metros):';

            % Create filter_refRXHeight
            app.filter_refRXHeight = uieditfield(app.filter_refRXGrid, 'numeric');
            app.filter_refRXHeight.Limits = [0 Inf];
            app.filter_refRXHeight.RoundFractionalValues = 'on';
            app.filter_refRXHeight.ValueDisplayFormat = '%d';
            app.filter_refRXHeight.ValueChangedFcn = createCallbackFcn(app, @referenceRX_FieldValueChanged, true);
            app.filter_refRXHeight.Editable = 'off';
            app.filter_refRXHeight.FontSize = 11;
            app.filter_refRXHeight.Layout.Row = 2;
            app.filter_refRXHeight.Layout.Column = 3;

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
            app.filter_SecondaryTypePanel.Layout.Column = [1 4];
            app.filter_SecondaryTypePanel.FontWeight = 'bold';
            app.filter_SecondaryTypePanel.FontSize = 10;

            % Create filter_SecondaryType1
            app.filter_SecondaryType1 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType1.Tag = '16';
            app.filter_SecondaryType1.Text = 'Fonte';
            app.filter_SecondaryType1.FontSize = 10;
            app.filter_SecondaryType1.Position = [10 69 48 22];
            app.filter_SecondaryType1.Value = true;

            % Create filter_SecondaryType2
            app.filter_SecondaryType2 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType2.Tag = '1';
            app.filter_SecondaryType2.Text = 'Frequência';
            app.filter_SecondaryType2.FontSize = 10;
            app.filter_SecondaryType2.Position = [10 48 83 22];

            % Create filter_SecondaryType3
            app.filter_SecondaryType3 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType3.Tag = '13';
            app.filter_SecondaryType3.Text = 'Largura banda';
            app.filter_SecondaryType3.FontSize = 10;
            app.filter_SecondaryType3.Position = [10 27 87 22];

            % Create filter_SecondaryType4
            app.filter_SecondaryType4 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType4.Tag = '12';
            app.filter_SecondaryType4.Text = 'Classe emissão';
            app.filter_SecondaryType4.FontSize = 10;
            app.filter_SecondaryType4.Position = [10 6 93 22];

            % Create filter_SecondaryType5
            app.filter_SecondaryType5 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType5.Tag = '2';
            app.filter_SecondaryType5.Text = 'Entidade';
            app.filter_SecondaryType5.FontSize = 10;
            app.filter_SecondaryType5.Position = [138 69 61 22];

            % Create filter_SecondaryType6
            app.filter_SecondaryType6 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType6.Tag = '3';
            app.filter_SecondaryType6.Text = 'Fistel';
            app.filter_SecondaryType6.FontSize = 10;
            app.filter_SecondaryType6.Position = [138 48 46 22];

            % Create filter_SecondaryType7
            app.filter_SecondaryType7 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType7.Tag = '4';
            app.filter_SecondaryType7.Text = 'Serviço';
            app.filter_SecondaryType7.FontSize = 10;
            app.filter_SecondaryType7.Position = [138 27 55 22];

            % Create filter_SecondaryType8
            app.filter_SecondaryType8 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType8.Tag = '5';
            app.filter_SecondaryType8.Text = 'Estação';
            app.filter_SecondaryType8.FontSize = 10;
            app.filter_SecondaryType8.Position = [138 6 58 22];

            % Create filter_SecondaryType9
            app.filter_SecondaryType9 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType9.Tag = '10';
            app.filter_SecondaryType9.Text = 'UF';
            app.filter_SecondaryType9.FontSize = 10;
            app.filter_SecondaryType9.Position = [231 69 35 22];

            % Create filter_SecondaryType10
            app.filter_SecondaryType10 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType10.Tag = '9';
            app.filter_SecondaryType10.Text = 'Município';
            app.filter_SecondaryType10.FontSize = 10;
            app.filter_SecondaryType10.Position = [231 48 65 22];

            % Create filter_SecondaryType11
            app.filter_SecondaryType11 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType11.Tag = '32';
            app.filter_SecondaryType11.Text = 'Distância';
            app.filter_SecondaryType11.FontSize = 10;
            app.filter_SecondaryType11.Position = [231 27 63 22];

            % Create filter_SecondaryType12
            app.filter_SecondaryType12 = uiradiobutton(app.filter_SecondaryTypePanel);
            app.filter_SecondaryType12.Tag = '-1';
            app.filter_SecondaryType12.Text = 'ROI';
            app.filter_SecondaryType12.FontSize = 10;
            app.filter_SecondaryType12.Position = [231 7 37 20];

            % Create filter_SecondaryValuePanel
            app.filter_SecondaryValuePanel = uibuttongroup(app.Tab2_Grid);
            app.filter_SecondaryValuePanel.AutoResizeChildren = 'off';
            app.filter_SecondaryValuePanel.SelectionChangedFcn = createCallbackFcn(app, @filter_SecondaryValuePanelSelectionChanged, true);
            app.filter_SecondaryValuePanel.BackgroundColor = [1 1 1];
            app.filter_SecondaryValuePanel.Layout.Row = 5;
            app.filter_SecondaryValuePanel.Layout.Column = [1 4];

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
            app.filter_SecondaryOperation2.Tag = 'numeric+textFree+textList2';
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
            app.filter_Tree.Layout.Column = [1 4];

            % Assign Checked Nodes
            app.filter_Tree.CheckedNodesChangedFcn = createCallbackFcn(app, @filter_TreeCheckedNodesChanged, true);

            % Create Tab_3
            app.Tab_3 = uitab(app.ControlTabGroup);
            app.Tab_3.AutoResizeChildren = 'off';

            % Create Tab4_Grid
            app.Tab4_Grid = uigridlayout(app.Tab_3);
            app.Tab4_Grid.ColumnWidth = {'1x', 16};
            app.Tab4_Grid.RowHeight = {27, 18, 184, 38, 116, 22, '1x'};
            app.Tab4_Grid.ColumnSpacing = 5;
            app.Tab4_Grid.RowSpacing = 5;
            app.Tab4_Grid.Padding = [0 0 0 0];
            app.Tab4_Grid.BackgroundColor = [1 1 1];

            % Create config_geoAxesLabel
            app.config_geoAxesLabel = uilabel(app.Tab4_Grid);
            app.config_geoAxesLabel.VerticalAlignment = 'bottom';
            app.config_geoAxesLabel.WordWrap = 'on';
            app.config_geoAxesLabel.FontSize = 10;
            app.config_geoAxesLabel.Layout.Row = [1 2];
            app.config_geoAxesLabel.Layout.Column = [1 2];
            app.config_geoAxesLabel.Interpreter = 'html';
            app.config_geoAxesLabel.Text = {'EIXO GEOGRÁFICO'; '<p style="color: gray; font-size: 9px; text-align: justify; padding-right: 2px;">Os parâmetros relacionados ao eixo geográfico, com exceção do VEÍCULO, são customizáveis por canal sob análise.</p>'};

            % Create config_Refresh
            app.config_Refresh = uiimage(app.Tab4_Grid);
            app.config_Refresh.Visible = 'off';
            app.config_Refresh.Tooltip = {'Volta à configuração inicial'};
            app.config_Refresh.Layout.Row = 2;
            app.config_Refresh.Layout.Column = 2;
            app.config_Refresh.VerticalAlignment = 'bottom';
            app.config_Refresh.ImageSource = 'Refresh_18.png';

            % Create config_geoAxesPanel
            app.config_geoAxesPanel = uipanel(app.Tab4_Grid);
            app.config_geoAxesPanel.Layout.Row = 3;
            app.config_geoAxesPanel.Layout.Column = [1 2];

            % Create config_geoAxesGrid
            app.config_geoAxesGrid = uigridlayout(app.config_geoAxesPanel);
            app.config_geoAxesGrid.ColumnWidth = {'1x', 50, 36, 36, 54};
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
            app.config_geoAxesSubPanel.Layout.Column = [1 5];

            % Create config_geoAxesSubGrid
            app.config_geoAxesSubGrid = uigridlayout(app.config_geoAxesSubPanel);
            app.config_geoAxesSubGrid.ColumnWidth = {'1x', 90};
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
            app.config_TX_Label.Text = {'Estação'; 'transmissora - TX:'};

            % Create config_TX_DataTipVisibility
            app.config_TX_DataTipVisibility = uidropdown(app.config_geoAxesGrid);
            app.config_TX_DataTipVisibility.Items = {'on', 'off'};
            app.config_TX_DataTipVisibility.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesOthersParametersChanged, true);
            app.config_TX_DataTipVisibility.FontSize = 11;
            app.config_TX_DataTipVisibility.BackgroundColor = [1 1 1];
            app.config_TX_DataTipVisibility.Layout.Row = 4;
            app.config_TX_DataTipVisibility.Layout.Column = 2;
            app.config_TX_DataTipVisibility.Value = 'off';

            % Create config_TX_Color
            app.config_TX_Color = uicolorpicker(app.config_geoAxesGrid);
            app.config_TX_Color.Value = [0.7882 0.2784 0.3373];
            app.config_TX_Color.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesColorParameterChanged, true);
            app.config_TX_Color.Enable = 'off';
            app.config_TX_Color.Layout.Row = 4;
            app.config_TX_Color.Layout.Column = 3;
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
            app.config_TX_Size.Layout.Column = [4 5];
            app.config_TX_Size.Value = 1;

            % Create config_RX_Label
            app.config_RX_Label = uilabel(app.config_geoAxesGrid);
            app.config_RX_Label.WordWrap = 'on';
            app.config_RX_Label.FontSize = 10;
            app.config_RX_Label.Layout.Row = 5;
            app.config_RX_Label.Layout.Column = [1 2];
            app.config_RX_Label.Text = {'Estação'; 'receptora - RX:'};

            % Create config_RX_Visibility
            app.config_RX_Visibility = uidropdown(app.config_geoAxesGrid);
            app.config_RX_Visibility.Items = {'on', 'off'};
            app.config_RX_Visibility.Enable = 'off';
            app.config_RX_Visibility.FontSize = 11;
            app.config_RX_Visibility.BackgroundColor = [1 1 1];
            app.config_RX_Visibility.Layout.Row = 5;
            app.config_RX_Visibility.Layout.Column = 2;
            app.config_RX_Visibility.Value = 'on';

            % Create config_RX_Color
            app.config_RX_Color = uicolorpicker(app.config_geoAxesGrid);
            app.config_RX_Color.Value = [0.7882 0.2784 0.3373];
            app.config_RX_Color.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesColorParameterChanged, true);
            app.config_RX_Color.Enable = 'off';
            app.config_RX_Color.Layout.Row = 5;
            app.config_RX_Color.Layout.Column = 3;
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
            app.config_RX_Size.Layout.Column = [4 5];
            app.config_RX_Size.Value = 1;

            % Create config_Station_Label
            app.config_Station_Label = uilabel(app.config_geoAxesGrid);
            app.config_Station_Label.WordWrap = 'on';
            app.config_Station_Label.FontSize = 10;
            app.config_Station_Label.Layout.Row = 3;
            app.config_Station_Label.Layout.Column = 1;
            app.config_Station_Label.Text = 'Estações RFDataHub:';

            % Create config_Station_DataTipVisibility
            app.config_Station_DataTipVisibility = uidropdown(app.config_geoAxesGrid);
            app.config_Station_DataTipVisibility.Items = {'on', 'off'};
            app.config_Station_DataTipVisibility.Enable = 'off';
            app.config_Station_DataTipVisibility.FontSize = 11;
            app.config_Station_DataTipVisibility.BackgroundColor = [1 1 1];
            app.config_Station_DataTipVisibility.Layout.Row = 3;
            app.config_Station_DataTipVisibility.Layout.Column = 2;
            app.config_Station_DataTipVisibility.Value = 'on';

            % Create config_Station_Color
            app.config_Station_Color = uicolorpicker(app.config_geoAxesGrid);
            app.config_Station_Color.Value = [0 1 1];
            app.config_Station_Color.ValueChangedFcn = createCallbackFcn(app, @config_geoAxesColorParameterChanged, true);
            app.config_Station_Color.Enable = 'off';
            app.config_Station_Color.Layout.Row = 3;
            app.config_Station_Color.Layout.Column = 3;
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
            app.config_Station_Size.Layout.Column = [4 5];
            app.config_Station_Size.Value = 1;

            % Create config_xyAxesLabel
            app.config_xyAxesLabel = uilabel(app.Tab4_Grid);
            app.config_xyAxesLabel.VerticalAlignment = 'bottom';
            app.config_xyAxesLabel.WordWrap = 'on';
            app.config_xyAxesLabel.FontSize = 10;
            app.config_xyAxesLabel.Layout.Row = 4;
            app.config_xyAxesLabel.Layout.Column = [1 2];
            app.config_xyAxesLabel.Interpreter = 'html';
            app.config_xyAxesLabel.Text = {'EIXOS CARTESIANOS'; '<p style="color: gray; font-size: 9px; text-align: justify; padding-right: 2px;">Os parâmetros relacionados aos eixos cartesianos não são customizáveis.</p>'};

            % Create ELEVAOLabel
            app.ELEVAOLabel = uilabel(app.Tab4_Grid);
            app.ELEVAOLabel.VerticalAlignment = 'bottom';
            app.ELEVAOLabel.FontSize = 10;
            app.ELEVAOLabel.Layout.Row = 6;
            app.ELEVAOLabel.Layout.Column = 1;
            app.ELEVAOLabel.Text = 'ELEVAÇÃO';

            % Create misc_ElevationSourcePanel
            app.misc_ElevationSourcePanel = uipanel(app.Tab4_Grid);
            app.misc_ElevationSourcePanel.AutoResizeChildren = 'off';
            app.misc_ElevationSourcePanel.Layout.Row = 7;
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

            % Create config_FolderMapPanel
            app.config_FolderMapPanel = uipanel(app.Tab4_Grid);
            app.config_FolderMapPanel.AutoResizeChildren = 'off';
            app.config_FolderMapPanel.Layout.Row = 5;
            app.config_FolderMapPanel.Layout.Column = [1 2];

            % Create config_FolderMapGrid
            app.config_FolderMapGrid = uigridlayout(app.config_FolderMapPanel);
            app.config_FolderMapGrid.ColumnWidth = {'1x', 20};
            app.config_FolderMapGrid.RowHeight = {17, 22, 17, 22};
            app.config_FolderMapGrid.ColumnSpacing = 5;
            app.config_FolderMapGrid.RowSpacing = 5;
            app.config_FolderMapGrid.BackgroundColor = [1 1 1];

            % Create config_Folder_DataHubGETLabel
            app.config_Folder_DataHubGETLabel = uilabel(app.config_FolderMapGrid);
            app.config_Folder_DataHubGETLabel.VerticalAlignment = 'bottom';
            app.config_Folder_DataHubGETLabel.FontSize = 11;
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
            app.config_Folder_DataHubGETButton.Tag = 'DataHub_GET';
            app.config_Folder_DataHubGETButton.Layout.Row = 2;
            app.config_Folder_DataHubGETButton.Layout.Column = 2;
            app.config_Folder_DataHubGETButton.ImageSource = fullfile(pathToMLAPP, 'Icons', 'OpenFile_36x36.png');

            % Create config_Folder_userPathLabel
            app.config_Folder_userPathLabel = uilabel(app.config_FolderMapGrid);
            app.config_Folder_userPathLabel.VerticalAlignment = 'bottom';
            app.config_Folder_userPathLabel.FontSize = 11;
            app.config_Folder_userPathLabel.Layout.Row = 3;
            app.config_Folder_userPathLabel.Layout.Column = 1;
            app.config_Folder_userPathLabel.Text = 'Pasta do usuário:';

            % Create config_Folder_userPath
            app.config_Folder_userPath = uidropdown(app.config_FolderMapGrid);
            app.config_Folder_userPath.Items = {''};
            app.config_Folder_userPath.FontSize = 11;
            app.config_Folder_userPath.BackgroundColor = [1 1 1];
            app.config_Folder_userPath.Layout.Row = 4;
            app.config_Folder_userPath.Layout.Column = 1;
            app.config_Folder_userPath.Value = '';

            % Create config_Folder_userPathButton
            app.config_Folder_userPathButton = uiimage(app.config_FolderMapGrid);
            app.config_Folder_userPathButton.Tag = 'userPath';
            app.config_Folder_userPathButton.Layout.Row = 4;
            app.config_Folder_userPathButton.Layout.Column = 2;
            app.config_Folder_userPathButton.ImageSource = fullfile(pathToMLAPP, 'Icons', 'OpenFile_36x36.png');

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

            % Create tool_PDFButton
            app.tool_PDFButton = uiimage(app.toolGrid);
            app.tool_PDFButton.ScaleMethod = 'none';
            app.tool_PDFButton.ImageClickedFcn = createCallbackFcn(app, @tool_InteractionImageClicked, true);
            app.tool_PDFButton.Tooltip = {'Documento relacionado ao registro selecionado'; '(limitado à radiodifusão)'};
            app.tool_PDFButton.Layout.Row = 2;
            app.tool_PDFButton.Layout.Column = 3;
            app.tool_PDFButton.VerticalAlignment = 'top';
            app.tool_PDFButton.ImageSource = 'Publish_PDF_16.png';

            % Create tool_simulationButton
            app.tool_simulationButton = uiimage(app.toolGrid);
            app.tool_simulationButton.ScaleMethod = 'none';
            app.tool_simulationButton.ImageClickedFcn = createCallbackFcn(app, @tool_InteractionImageClicked, true);
            app.tool_simulationButton.Tooltip = {'Perfil de terreno entre registro selecionado (TX) '; 'e estação de referência (RX)'};
            app.tool_simulationButton.Layout.Row = 2;
            app.tool_simulationButton.Layout.Column = 4;
            app.tool_simulationButton.VerticalAlignment = 'top';
            app.tool_simulationButton.ImageSource = 'Publish_HTML_16.png';

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
