classdef winRFDataHub_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        axesToolbarGrid                matlab.ui.container.GridLayout
        axesTool_PDFButton             matlab.ui.control.Image
        axesTool_simulationButton      matlab.ui.control.Image
        axesTool_TableVisibility       matlab.ui.control.Image
        axesTool_RegionZoom            matlab.ui.control.Image
        axesTool_RestoreView           matlab.ui.control.Image
        plotPanel                      matlab.ui.container.Panel
        chReportHTML                   matlab.ui.control.HTML
        tableInfoNRows                 matlab.ui.control.Label
        UITable                        matlab.ui.control.Table
        ControlTabGrid                 matlab.ui.container.GridLayout
        menu_MainGrid                  matlab.ui.container.GridLayout
        menu_Button4Grid               matlab.ui.container.GridLayout
        menu_Button4Icon               matlab.ui.control.Image
        menu_Button4Label              matlab.ui.control.Label
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
        PlotPanel                      matlab.ui.container.Panel
        search_SelectedRowInfoPanel    matlab.ui.container.Panel
        search_SelectedRowInfoGrid     matlab.ui.container.GridLayout
        search_SelectedRowInfo         matlab.ui.control.HTML
        REGISTROSELECIONADOLabel       matlab.ui.control.Label
        Tab_2                          matlab.ui.container.Tab
        Tab2_Grid                      matlab.ui.container.GridLayout
        filter_refRXPanel              matlab.ui.container.Panel
        filter_refRXGrid               matlab.ui.container.GridLayout
        filter_refRXHeight             matlab.ui.control.NumericEditField
        filter_refRXHeightLabel        matlab.ui.control.Label
        filter_refRXLongitude          matlab.ui.control.NumericEditField
        filter_refRXLongitudeLabel     matlab.ui.control.Label
        filter_refRXLatitude           matlab.ui.control.NumericEditField
        filter_refRXLatitudeLabel      matlab.ui.control.Label
        filter_refRXEdit               matlab.ui.control.Image
        filter_refRXRefresh            matlab.ui.control.Image
        filter_refRXLabel              matlab.ui.control.Label
        filter_refRXIcon               matlab.ui.control.Image
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
        Tab_3                          matlab.ui.container.Tab
        link_Grid                      matlab.ui.container.GridLayout
        link_LinkInfoPanel             matlab.ui.container.Panel
        link_LinkInfoGrid              matlab.ui.container.GridLayout
        link_LinkInfo                  matlab.ui.control.HTML
        link_Table                     matlab.ui.control.Table
        link_AddStation                matlab.ui.control.Image
        link_TableLabel                matlab.ui.control.Label
        Tab_4                          matlab.ui.container.Tab
        Tab4_Grid                      matlab.ui.container.GridLayout
        misc_ElevationSourcePanel      matlab.ui.container.Panel
        misc_ElevationSourceGrid       matlab.ui.container.GridLayout
        misc_PointsPerLink             matlab.ui.control.DropDown
        misc_PointsPerLinkLabel        matlab.ui.control.Label
        misc_ElevationAPISource        matlab.ui.control.DropDown
        misc_ElevationAPISourceLabel   matlab.ui.control.Label
        ELEVAOLabel                    matlab.ui.control.Label
        config_xyAxesPanel             matlab.ui.container.Panel
        config_xyAxesGrid              matlab.ui.container.GridLayout
        config_chPowerFaceAlpha        matlab.ui.control.Spinner
        config_chPowerEdgeAlpha        matlab.ui.control.Spinner
        config_chPowerColor            matlab.ui.control.ColorPicker
        config_chPowerVisibility       matlab.ui.control.DropDown
        config_chPowerLabel            matlab.ui.control.Label
        config_chROIFaceAlpha          matlab.ui.control.Spinner
        config_chROIEdgeAlpha          matlab.ui.control.Spinner
        config_chROIColor              matlab.ui.control.ColorPicker
        config_chROIVisibility         matlab.ui.control.DropDown
        config_chROILabel              matlab.ui.control.Label
        config_PersistanceVisibility   matlab.ui.control.DropDown
        config_PersistanceLabel        matlab.ui.control.Label
        config_xyAxesLabel             matlab.ui.control.Label
        config_geoAxesPanel            matlab.ui.container.Panel
        config_geoAxesGrid             matlab.ui.container.GridLayout
        config_points_Size             matlab.ui.control.Slider
        config_points_Color            matlab.ui.control.ColorPicker
        config_points_LineStyle        matlab.ui.control.DropDown
        config_points_Label            matlab.ui.control.Label
        config_Car_Size                matlab.ui.control.Slider
        config_Car_Color               matlab.ui.control.ColorPicker
        config_Car_LineStyle           matlab.ui.control.DropDown
        config_Car_Label               matlab.ui.control.Label
        config_route_Size              matlab.ui.control.Slider
        config_route_InColor           matlab.ui.control.ColorPicker
        config_route_OutColor          matlab.ui.control.ColorPicker
        config_route_LineStyle         matlab.ui.control.DropDown
        config_route_Label             matlab.ui.control.Label
        config_geoAxesSubPanel         matlab.ui.container.Panel
        config_geoAxesSubGrid          matlab.ui.container.GridLayout
        config_Colormap                matlab.ui.control.DropDown
        config_ColormapLabel           matlab.ui.control.Label
        config_Basemap                 matlab.ui.control.DropDown
        config_BasemapLabel            matlab.ui.control.Label
        config_geoAxesSublabel         matlab.ui.control.Label
        config_Refresh                 matlab.ui.control.Image
        config_geoAxesLabel            matlab.ui.control.Label
        toolGrid                       matlab.ui.container.GridLayout
        filter_Summary                 matlab.ui.control.Image
        tool_ExportButton              matlab.ui.control.Image
        jsBackDoor                     matlab.ui.control.HTML
        tool_ControlPanelVisibility    matlab.ui.control.Image
        filter_ContextMenu             matlab.ui.container.ContextMenu
        filter_delButton               matlab.ui.container.Menu
        filter_delAllButton            matlab.ui.container.Menu
        points_ContextMenu             matlab.ui.container.ContextMenu
        points_referenceButton         matlab.ui.container.Menu
        points_editRowButton           matlab.ui.container.Menu
        points_delButton               matlab.ui.container.Menu
    end

    
    properties (Access = public)
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

        % O MATLAB não renderiza alguns dos componentes de abas (do TabGroup) 
        % não visíveis. E a customização de componentes, usando a lib ccTools, 
        % somente é possível após a sua renderização. Controla-se a aplicação 
        % da customizaçao por meio dessa propriedade jsBackDoorFlag.
        jsBackDoorFlag = {true, ...
                          true, ...
                          true, ...
                          true};

        % Janela de progresso já criada no DOM. Dessa forma, controla-se 
        % apenas a sua visibilidade - e tornando desnecessário criá-la a
        % cada chamada (usando uiprogressdlg, por exemplo).
        progressDialog

        % Propriedades do app.
        specData

        %-----------------------------------------------------------------%
        % ESPECIFICIDADES AUXAPP.WINDRIVETEST
        %-----------------------------------------------------------------%
        rfDataHub
        rfDataHubSummary
        rfDataHubLogical
        
        UIAxes1
        UIAxes2
        UIAxes3
        restoreView  = struct('ID', {}, 'xLim', {}, 'yLim', {}, 'cLim', {})

        elevationObj = RF.Elevation
        pointsTable  = table('Size',          [0, 6],                                                    ...
                             'VariableTypes', {'cell', 'double', 'double', 'cell', 'double', 'logical'}, ...
                             'VariableNames', {'Type', 'Latitude', 'Longitude', 'Location', 'AntennaHeight', 'Reference'})
        filterTable  = table('Size',          [0, 9],                                                                      ...
                             'VariableTypes', {'cell', 'int8', 'int8', 'cell', 'cell', 'int8', 'cell', 'logical', 'cell'}, ...
                             'VariableNames', {'Order', 'ID', 'RelatedID', 'Type', 'Operation', 'Column', 'Value', 'Enable', 'uuid'})
    end

    
    methods (Access = private)
        %-----------------------------------------------------------------%
        % INICIALIZAÇÃO
        %-----------------------------------------------------------------%
        function jsBackDoor_Initialization(app)
            app.jsBackDoor.HTMLSource           = ccTools.fcn.jsBackDoorHTMLSource();
            app.jsBackDoor.HTMLEventReceivedFcn = @(~, evt)jsBackDoor_Listener(app, evt);
        end

        %-----------------------------------------------------------------%
        function jsBackDoor_Listener(app, event)
            % switch event.HTMLEventName
            %     case 'app.filter_Tree'
            %         filter_delFilter(app, struct('Source', app.filter_delButton))
            %     case 'app.points_Tree'
            %         points_delButtonMenuSelected(app)
            % end
            % drawnow
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
                    if app.isDocked
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

            % Define tamanho mínimo do app (não aplicável à versão webapp).
            if ~strcmp(app.CallingApp.executionMode, 'webApp') && ~app.isDocked
                appUtil.winMinSize(app.UIFigure, class.Constants.windowMinSize)
            end

            app.progressDialog.Visible = 'visible';

            startup_AppProperties(app)
            startup_AxesCreation(app)
            startup_GUIComponents(app)

            filter_TableFiltering(app)

            app.progressDialog.Visible = 'hidden';
        end

        %-----------------------------------------------------------------%
        function startup_AppProperties(app)
            % refRX
            filter_getReferenceRX(app)

            % app.rfDataHub
            global RFDataHub
            
            app.rfDataHub = RFDataHub;
            
            % Contorna erro da função inROI, que retorna como se todos os
            % pontos estivessem internos ao ROI, quando as coordenadas
            % estão em float32. No float64 isso não acontece... aberto BUG
            % na Mathworks, que indicou estar ciente.
            app.rfDataHub.Latitude    = app.rfDataHub.Latitude;
            app.rfDataHub.Longitude   = app.rfDataHub.Longitude;

            app.rfDataHub.ID          = "#" + string((1:height(RFDataHub))');
            app.rfDataHub.Description = "[" + string(RFDataHub.Source) + "] " + string(RFDataHub.Status) + ", " + string(RFDataHub.StationClass) + ", " + string(RFDataHub.Name) + " (Fistel=" + string(RFDataHub.Fistel) + ", M=" + string(RFDataHub.MergeCount) + "), " + string(RFDataHub.Location) + "/" + string(RFDataHub.State);
            filter_calculateDistanceColumn(app)
                        
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
            hParent     = tiledlayout(app.plotPanel, 4, 4, "Padding", "none", "TileSpacing", "none");

            % Eixo geográfico: MAPA
            app.UIAxes1 = plot.axes.Creation(hParent, 'Geographic', {'Basemap', app.config_Basemap.Value, ...
                                                                     'UserData', struct('CLimMode', 'auto', 'Colormap', '')});
            app.UIAxes1.Layout.Tile = 1;
            app.UIAxes1.Layout.TileSpan = [4, 4];

            set(app.UIAxes1.LatitudeAxis,  'TickLabels', {}, 'Color', 'none')
            set(app.UIAxes1.LongitudeAxis, 'TickLabels', {}, 'Color', 'none')
            geolimits(app.UIAxes1, 'auto')
            plot.axes.Colormap(app.UIAxes1, app.config_Colormap.Value)

            % Eixo cartesiano: PERFIL DE RELEVO
            app.UIAxes2 = plot.axes.Creation(hParent, 'Cartesian', {'XGrid', 'off', 'XMinorGrid', 'off', 'XTick', [], 'XColor', 'none',  ...
                                                                    'YGrid', 'off', 'YMinorGrid', 'off', 'YTick', [], 'YColor', 'none', ...
                                                                    'Color', 'none', 'UserData', struct('TX', [], 'RX', [])});
            app.UIAxes2.Layout.Tile = 15;
            app.UIAxes2.Layout.TileSpan = [1 2];
            app.UIAxes2.XAxis.TickLabelFormat = '%.1f';

            % Eixo cartesiano: DIAGRAMA DE RADIAÇÃO DA ANTENA
            app.PlotPanel.AutoResizeChildren = 'off';
            app.UIAxes3 = polaraxes(app.PlotPanel, 'Units', 'normalized', 'Position', [.1,.1,.8,.8], 'ThetaZeroLocation', 'top', 'FontSize', 9, 'Color', 'none');
            hold(app.UIAxes3, 'on')

            % Axes interactions:
            plot.axes.Interactivity.DefaultCreation(app.UIAxes1, [dataTipInteraction, zoomInteraction, panInteraction])
            plot.axes.Interactivity.DefaultCreation(app.UIAxes2, [dataTipInteraction, regionZoomInteraction])
        end

        %-----------------------------------------------------------------%
        function startup_GUIComponents(app)
            % ...
        end
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        function filter_getReferenceRX(app)
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
        function filter_calculateDistanceColumn(app)
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
                    parentNode = uitreenode(app.filter_Tree, 'Text', sprintf('#%d: RFDataHub.("%s") %s %s', app.filterTable.ID(ii),                        ...
                                                                                                            app.filterTable.Type{ii},                      ...
                                                                                                            app.filterTable.Operation{ii},                 ...
                                                                                                            filter_Value(app, app.filterTable.Value{ii})), ...
                                                             'NodeData', ii, 'ContextMenu', app.filter_ContextMenu);
                    if app.filterTable.Enable(ii)
                        checkedNodes = [checkedNodes, parentNode];
                    end
    
                    idx2 = find(app.filterTable.RelatedID == ii)';                
                    for jj = idx2
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
                app.filter_Tree.CheckedNodes = checkedNodes;
                expand(app.filter_Tree, 'all')
            end

            app.filter_SecondaryReferenceFilter.Items = [{''}, cellstr("#" + string((idx1)))];
        end

        %-----------------------------------------------------------------%
        function filter_TableFiltering(app)
            app.progressDialog.Visible = 'visible';

            % Identifica registro inicialmente selecionado da tabela.
            if isempty(app.UITable.Selection)                
                if ~isempty(app.UIAxes2.UserData.TX)
                    initialSelectedRow = app.UIAxes2.UserData.TX;
                else
                    initialSelectedRow = [];
                end
            else
                initialSelectedRow  = app.UITable.Data.ID{app.UITable.Selection(1)};
            end

            % Filtragem, preenchendo a tabela o seu label (nº de linhas).
            app.rfDataHubLogical = fcn.TableFiltering(app.rfDataHub, app.filterTable);
            set(app.UITable, 'Selection', [], 'Data', app.rfDataHub(app.rfDataHubLogical,[30, 1, 6:7, 31, 4:5, 12, 13, 29, 32]))
            app.UITable.Data = sortrows(app.UITable.Data, 'Distance');
            app.tableInfoNRows.Text = "#" + string(height(app.UITable.Data));

            % Aplicando a seleção inicial da tabela, caso aplicável.
            selectedRow = 0;
            if ~isempty(initialSelectedRow)
                [~, selectedRow] = ismember(initialSelectedRow, app.UITable.Data.ID);
            end

            if ~selectedRow
                selectedRow = 1;
            end
            
            app.UITable.Selection = [selectedRow, 1];
            UITableSelectionChanged(app, struct('Source', app.UITable))

            % Aplicando estilo.
            filter_TableStyle(app, 'ProgrammaticallySelectedRow')
            filter_TableStyle(app, 'TerrainProfilePlot')

            % Plots.
            plot_General(app)
            % plot_SelectedRow(app)
            % plot_Nodes(app)
            % if app.tool_simulationAxesVisibility.Value
            %     plot_simulationLink(app)
            % end

            app.progressDialog.Visible = 'hidden';
        end

        %-----------------------------------------------------------------%
        function plot_createRFLinkPlot(app, idxPrjPeaks, idxThread, idxStation)
            try
                % OBJETOS TX e RX
                [txObj, rxObj] = RFLinkObjects(app, idxPrjPeaks, idxThread, idxStation);
    
                % ELEVAÇÃO DO LINK TX-RX
                [wayPoints3D, msgWarning] = Get(app.elevationObj, txObj, rxObj);
                if ~isempty(msgWarning)
                    appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                end
    
                % PLOT: RFLink
                plot.RFLink(app.UIAxes2, txObj, rxObj, wayPoints3D, 'dark')
                app.UIAxes2.PickableParts = "visible";
                app.restoreView(2) = struct('ID', 'app.UIAxes2', 'xLim', app.UIAxes2.XLim, 'yLim', app.UIAxes2.YLim, 'cLim', 'auto');

                if isempty(findobj(app.UIAxes2.Children, 'Tag', 'FirstObstruction'))
                    app.axesTool_Warning.Visible = 0;
                else
                    app.axesTool_Warning.Visible = 1;
                end
                
            catch
                cla(app.UIAxes2)
                app.UIAxes2.PickableParts = "none";
                msgWarning = text(app.UIAxes2, mean(app.UIAxes2.XLim), mean(app.UIAxes2.YLim), {'PERFIL DE TERRENO ENTRE RECEPTOR';  ...
                                                                                                'E PROVÁVEL EMISSOR É LIMITADO ÀS';  ...
                                                                                                'ESTAÇÕES INCLUÍDAS NO RFDATAHUB';   ...
                                                                                                '(EXCETO VISUALIZAÇÃO TEMPORÁRIA)'}, ...
                                               BackgroundColor=[.8,.8,.8], HorizontalAlignment="center", FontSize=10);
                msgWarning.Units = 'normalized';
                app.axesTool_Warning.Visible = 0;
            end
            app.axesTool_redrawPlot.Enable = 0;
        end

        %-----------------------------------------------------------------%
        function [txSite, rxSite] = RFLinkObjects(app, idxStation)
            % txSite e rxSite estão como struct, mas basta mudar para "txsite" e 
            % "rxsite" que eles poderão ser usados em predições, uma vez que os 
            % campos da estrutura são idênticos às propriedades dos objetos.

            txAntennaHeight = str2double(char(app.rfDataHub.AntennaHeight(idxStation)));
            if txAntennaHeight <= 0
                txAntennaHeight = 10;
            end

            % TX
            txSite = struct('Name',                 'TX',                                              ...
                            'TransmitterFrequency', double(app.rfDataHub.Latitude(idxStation)) * 1e+6, ...
                            'Latitude',             double(app.rfDataHub.Latitude(idxStation)),        ...
                            'Longitude',            double(app.rfDataHub.Longitude(idxStation)),       ...
                            'AntennaHeight',        txAntennaHeight);

            % RX
            rxSite = struct('Name',                 'RX',                            ...
                            'Latitude',             app.filter_refRXLatitude.Value,  ...
                            'Longitude',            app.filter_refRXLongitude.Value, ...
                            'AntennaHeight',        app.filter_refRXHeight.Value);
        end






        %-----------------------------------------------------------------%
        % AINDA NÃO REVISADO DAQUI PRA BAIXO... :(
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
        function points_NodeList(app)
            app.pointsTable(:,:) = [];

            for ii = 1:numel(app.CallingApp.specData)
                if app.CallingApp.specData(ii).GPS.Status
                    AntennaHeight = -1;
                    if isfield(app.CallingApp.specData(ii).MetaData.Antenna, 'Height')
                        AntennaHeight = str2double(extractBefore(app.CallingApp.specData(ii).MetaData.Antenna.Height, 'm'));
                    end

                    newPoint      = {'auto',                                    ...
                                     app.CallingApp.specData(ii).GPS.Latitude,  ...
                                     app.CallingApp.specData(ii).GPS.Longitude, ...
                                     app.CallingApp.specData(ii).GPS.Location,  ...
                                     AntennaHeight,                             ...
                                     false};
                    newPointFlag = true;

                    for jj = 1:height(app.pointsTable)
                        if isequal(newPoint(2:5), table2cell(app.pointsTable(jj,2:5)))
                            newPointFlag = false;
                            break
                        end
                    end

                    if newPointFlag
                        app.pointsTable(end+1,:) = newPoint;
                    end
                end
            end

            if isempty(app.pointsTable)
                % Caso não tenha um ponto de monitoração, insere-se a sede
                % da Anatel. Isso garante a visualização do mapa centralizada
                % em Brasília/DF.
                app.pointsTable(1,:) = {'manual', -15.805479, -47.882499, 'Brasília/DF', 30, true};
            else
                app.pointsTable.Reference(1) = true;
            end            

            points_TreeBuilding(app, 1)
        end

        %-----------------------------------------------------------------%
        function points_TreeBuilding(app, selectedID)
            if ~isempty(app.points_Tree.Children)
                delete(app.points_Tree.Children)
                drawnow nocallbacks
            end

            if ~isempty(app.pointsTable)
                for ii = 1:height(app.pointsTable)
                    antennaHeight = '';
                    if app.pointsTable.AntennaHeight(ii) > 0
                        antennaHeight = sprintf(', %dm', app.pointsTable.AntennaHeight(ii));
                    end

                    nodeTree = uitreenode(app.points_Tree, 'Text', sprintf('#%d: %s (%.6fº, %.6fº%s)', ii, app.pointsTable.Location{ii},  ...
                                                                                                           app.pointsTable.Latitude(ii),  ...
                                                                                                           app.pointsTable.Longitude(ii), ...
                                                                                                           antennaHeight),                ...
                                                           'NodeData', ii, 'ContextMenu', app.points_ContextMenu);
                    if app.pointsTable.Reference(ii)
                        nodeTree.Icon = 'Pin_18.png';
                    end
                end

                if ~ismember(selectedID, 1:height(app.pointsTable))
                    selectedID = 1;
                end
                app.points_Tree.SelectedNodes = app.points_Tree.Children(selectedID);

            else
                app.filter_refRXGrid.ColumnWidth{4} = 22;
                set(app.filter_refRXLatitude,      Value=-1, Editable=1)
                set(app.filter_refRXLongitude,     Value=-1, Editable=1)
                set(app.points_AntennaHeight, Value=-1, Editable=1)
            end

            points_TreeSelectionChanged(app)
        end

        %-----------------------------------------------------------------%
        function layout_FilterDefaultValues(app)
            app.filter_SecondaryNumValue1.Value       = -1;
            app.filter_SecondaryNumValue2.Value       = -1;
            app.filter_SecondaryTextFree.Value        = '';
            app.filter_SecondaryTextList.Items        = {};
            app.filter_SecondaryLogicalOperator.Items = {'E (&&)'};
        end

        function layout_CartesianAxesLayout(app)
            if app.tool_HistogramAxesVisibility.Value
                app.tool_simulationAxesVisibility.Value = 0;

                layout_CartesianAxesSwitch(app, 'Visible',   2, [1 2])
                layout_CartesianAxesSwitch(app, 'Visible',   3, [3 1])
                layout_CartesianAxesSwitch(app, 'Invisible', 4, -1)

            else
                app.tool_simulationAxesVisibility.Value = 1;

                layout_CartesianAxesSwitch(app, 'Invisible', 2, -1)
                layout_CartesianAxesSwitch(app, 'Invisible', 3, -1)
                layout_CartesianAxesSwitch(app, 'Visible',   4, [1 3])
            end
        end
        
        %-----------------------------------------------------------------%
        function layout_CartesianAxesSwitch(app, axesVisibility, axesID, axesTiledPosition)
            switch axesVisibility
                case 'Invisible'
                    eval(sprintf('set(app.UIAxes%d,          Visible=0)', axesID))
                    eval(sprintf('set(app.UIAxes%d.Children, Visible=0)', axesID))
                    eval(sprintf('set(app.UIAxes%d.Toolbar,  Visible=0)', axesID))

                case 'Visible'
                    eval(sprintf('set(app.UIAxes%d,          Visible=1)', axesID))
                    eval(sprintf('set(app.UIAxes%d.Children, Visible=1)', axesID))
                    eval(sprintf('set(app.UIAxes%d.Toolbar,  Visible=1)', axesID))
    
                    eval(sprintf('app.UIAxes%d.Layout.Tile = axesTiledPosition(1);', axesID))
                    eval(sprintf('app.UIAxes%d.Layout.TileSpan = [1 axesTiledPosition(2)];', axesID))
            end
        end

        %-----------------------------------------------------------------%
        function layout_simulationLink(app, idx)
            simulationFlag = false;

            app.axesTool_PDFButton.Enable = 0;
            if ~isempty(idx)
                if app.UITable.Data.URL(idx) ~= "-1"
                    app.axesTool_PDFButton.Enable = 1;
                end

                if ~isempty(app.pointsTable)
                    simulationFlag = true;
                end
            end

            if simulationFlag
                app.link_LinkInfo.HTMLSource = textFormatGUI.struct2PrettyPrintList(misc_simulationLinkSummary(app, idx), 'delete');
                app.axesTool_simulationButton.Enable    = 1;

            else
                app.link_LinkInfo.HTMLSource = ' ';
                app.axesTool_simulationButton.Enable    = 0;
            end
        end

        %-----------------------------------------------------------------%
        function linkSummary = misc_simulationLinkSummary(app, idx)
            [txObj, rxObj]  = misc_simulationObjects(app, idx);
            txObj.Frequency = sprintf('%.3f MHz', txObj.TransmitterFrequency/1e+6);

            linkSummary(1)  = struct('group', 'ESTAÇÃO TRANSMISSORA (TX)', 'value', txObj);
            linkSummary(2)  = struct('group', 'ESTAÇÃO RECEPTORA (RX)',    'value', rxObj);
        end

        %-----------------------------------------------------------------%
        function [txObj, rxObj] = misc_simulationObjects(app, idxStation)
            txIndex = str2double(extractAfter(app.UITable.Data.ID{idxStation}, '#'));
            rxIndex = find(app.pointsTable.Reference, 1);

            txObj = struct('TransmitterFrequency', app.rfDataHub.Frequency(txIndex) * 1e+6,                ...
                           'Latitude',             app.rfDataHub.Latitude(txIndex),                        ...
                           'Longitude',            app.rfDataHub.Longitude(txIndex),                       ...
                           'AntennaHeight',        str2double(char(app.rfDataHub.AntennaHeight(txIndex))), ...
                           'AntennaPattern',       char(app.rfDataHub.AntennaPattern(txIndex)),            ...
                           'Description',          app.UITable.Data.Description{idxStation},               ...
                           'Service',              app.rfDataHub.Service(txIndex),                         ...
                           'Station',              app.rfDataHub.Station(txIndex),                         ...
                           'ID',                   app.UITable.Data.ID{idxStation});

            rxObj = struct('Latitude',             app.pointsTable.Latitude(rxIndex),  ...
                           'Longitude',            app.pointsTable.Longitude(rxIndex), ...
                           'AntennaHeight',        app.pointsTable.AntennaHeight(rxIndex));
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

        %-----------------------------------------------------------------%
        function filter_TableStyle(app, Type)
            switch Type
                case {'SelectionRowChanged', 'ProgrammaticallySelectedRow'}
                    idx1 = find(app.UITable.StyleConfigurations.Target == "cell");
                    if ~isempty(idx1)
                        removeStyle(app.UITable, idx1)
                    end

                    if strcmp(Type, 'ProgrammaticallySelectedRow')
                        if ~isempty(app.UITable.Selection)
                            idx2 = app.UITable.Selection(1);
                            addStyle(app.UITable, uistyle("BackgroundColor", '#ddf0ff'), 'cell', [idx2,1])
                        end
                    end

                case 'HorizontalAlign'
                    addStyle(app.UITable, uistyle('HorizontalAlignment', 'right'), 'column', [8,10])

                case 'TerrainProfilePlot'
                    idx1 = find(app.UITable.StyleConfigurations.Target == "row");
                    if ~isempty(idx1)
                        removeStyle(app.UITable, idx1)
                    end

                    if ~isempty(app.UIAxes2.UserData.TX)
                        idx2 = app.UIAxes2.UserData.TX.ID;
                        if ~isempty(idx2)
                            idx3 = find(strcmp(app.UITable.Data.ID, idx2), 1);
                            if ~isempty(idx3)
                                addStyle(app.UITable, uistyle("BackgroundColor", '#c94756', 'FontColor', 'white'), 'row', idx3)
                            end
                        end
                    end
            end
        end


        %-----------------------------------------------------------------%
        function plot_General(app)
            hObjects = app.UIAxes1.Children;
            idx = contains(arrayfun(@(x) x.Tag, app.UIAxes1.Children, 'UniformOutput', false), 'ROI');
            delete(hObjects(~idx))

            rfDataHubFlag = height(app.UITable.Data);
            if rfDataHubFlag
                p1 = geoscatter(app.UIAxes1, app.UITable.Data.Latitude, app.UITable.Data.Longitude, MarkerEdgeColor='#009578', Tag='Station');
            end

            uistack(hObjects(idx))
            
            if rfDataHubFlag
                plot.datatip.Template(p1, 'winRFDataHub.Geographic', app.UITable.Data)
            end
        end


        %-----------------------------------------------------------------%
        function plot_Nodes(app)
            if ~isempty(app.pointsTable)
                idx1 = find(app.pointsTable.Reference, 1);                
                if height(app.pointsTable) > 1
                    idx2 = setdiff(1:height(app.pointsTable), idx1);
                    p1 = geoscatter(app.UIAxes1, app.pointsTable.Latitude(idx2), app.pointsTable.Longitude(idx2), 'Marker', '^', 'MarkerEdgeColor', '#c94756', 'Tag', 'OthersNodes');
                    plot.datatip.Template(p1, 'winRFDataHub.SelectedNode')
                end
                
                p2 = geoscatter(app.UIAxes1, app.pointsTable.Latitude(idx1), app.pointsTable.Longitude(idx1), 'Marker', '^', 'MarkerEdgeColor', '#c94756', 'MarkerFaceColor', '#c94756', 'Tag', 'SelectedNode');
                plot.datatip.Template(p2, 'winRFDataHub.SelectedNode')
            end
        end


        %-----------------------------------------------------------------%
        function plot_SelectedRow(app)
            hSelected = findobj(app.UIAxes1, Tag='SelectedRow');
            
            if ~isempty(app.UITable.Selection)
                idx = app.UITable.Selection(1);

                if isempty(hSelected)
                    hSelected = geoscatter(app.UIAxes1, app.UITable.Data.Latitude(idx), app.UITable.Data.Longitude(idx), MarkerEdgeColor='#c94756', ...
                                                                                                                         MarkerFaceColor='#c94756', ...
                                                                                                                         Tag='SelectedRow');
                else
                    set(hSelected, 'LatitudeData',  app.UITable.Data.Latitude(idx), ...
                                   'LongitudeData', app.UITable.Data.Longitude(idx))
                end
                plot.datatip.Template(hSelected, 'winRFDataHub.Geographic', app.UITable.Data(idx,:))
                layout_simulationLink(app, idx)
                
            else
                delete(hSelected)

                layout_simulationLink(app, [])
            end
        end


        %-----------------------------------------------------------------%
        function plot_simulationLink(app)
            % VALIDAÇÕES
            if isempty(app.UITable.Selection) || isempty(app.pointsTable)
                return
            end
            idx = app.UITable.Selection(1);

            d = appUtil.modalWindow(app.UIFigure, 'progressdlg', 'Em andamento...');
            
            % OBJETOS TX e RX
            [txObj, rxObj] = misc_simulationObjects(app, idx);       

            % ELEVAÇÃO DO LINK TX-RX
            nPoints = str2double(app.misc_PointsPerLink.Value);
            Server  = app.misc_ElevationAPISource.Value;

            [wayPoints3D, msgWarning] = Get(app.elevationObj, txObj, rxObj, nPoints, false, Server);
            if ~isempty(msgWarning)
                appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
            end

            % PLOT: MAPA
            delete(findobj(app.UIAxes1, 'Tag', 'RFLinkView', '-or', 'Tag', 'RFLink'))
            geoplot(app.UIAxes1, wayPoints3D(:,1), wayPoints3D(:,2), Color='#c94756', LineStyle='-.', PickableParts='none', Tag='RFLinkView');

            % PLOT: RFLink
            plot.RFLink(app.UIAxes2, txObj, rxObj, wayPoints3D)

            app.restoreView = {app.UIAxes2.XLim, app.UIAxes2.YLim};
            filter_TableStyle(app, 'TerrainProfilePlot')

            delete(d)
        end
    end


    methods (Access = public)
        %-----------------------------------------------------------------%
        function externalRequest(app, request)
            switch request.Type
                case 'TerrainProfilePlot'
                    try
                        % Aba 1: PONTO DE MONITORAÇÃO
                        % Avalia a distância do sensor registrada na tabela
                        % app.peaksTable (propriedade do app principal) e a
                        % distância dos pontos de monitoração registrados
                        % em app.pointsTable (os quais estão sujeitos à
                        % edição).
                        rxLat = request.rxLatitude;
                        rxLon = request.rxLongitude;

                        refIndex = find(app.pointsTable.Reference, 1);                        
                        minDist  = deg2km(distance(app.pointsTable.Latitude(refIndex), app.pointsTable.Longitude(refIndex), rxLat, rxLon))/1000;

                        if minDist > class.Constants.floatDiffTolerance
                            points_NodeList(app)
                            [~, minDistIndex] = min(distance(app.pointsTable.Latitude, app.pointsTable.Longitude, rxLat, rxLon));

                            refIndex = find(app.pointsTable.Reference, 1);
                            if refIndex ~= minDistIndex
                                app.pointsTable.Reference               = zeros(height(app.pointsTable), 1, 'logical');
                                app.pointsTable.Reference(minDistIndex) = true;
                                
                                points_TreeBuilding(app, minDistIndex)
                            end
                        end

                        % Aba 2: FILTRO
                        filter_delFilter(app, struct('Source', app.filter_delAllButton))
                        txStationNumber = request.txStationNumber;

                        app.filter_SecondaryType8.Value = true;
                        filter_typePanelSelectionChanged(app)
                        app.filter_SecondaryNumValue1.Value = double(txStationNumber);
                        filter_addFilter(app)

                        app.UITable.Selection = [1 1];
                        UITableSelectionChanged(app)

                        % AJUSTES FINAIS: ENLACE E LAYOUT
                        % A versão compilada está deixando de renderizar em
                        % tela algumas das personalizações abaixo... por
                        % isso inserido o drawnow.
                        drawnow nocallbacks
                        pause(.1)
                        misc_TerrainProfileRefreshImage(app)
                        
                        general_LeftPanelMenuSelectionChanged(app, struct('Source', app.menu_Button2Icon))
                        figure(app.UIFigure)
                    catch

                    end

                case 'StationsMap'

            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            
            app.CallingApp = mainapp;
            app.General    = mainapp.General;
            app.rootFolder = mainapp.rootFolder;
            app.specData   = mainapp.specData;

            app.GridLayout.ColumnWidth(7:8) = {0,0};
            jsBackDoor_Initialization(app)

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

        % Image clicked function: menu_Button1Icon, menu_Button2Icon, 
        % ...and 2 other components
        function general_LeftPanelMenuSelectionChanged(app, event)
            
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

        % Image clicked function: tool_ControlPanelVisibility
        function tool_LeftPanelVisibilityImageClicked(app, event)
            
            focus(app.jsBackDoor)

            if app.GridLayout.ColumnWidth{2}
                app.tool_ControlPanelVisibility.ImageSource = 'ArrowRight_32.png';
                app.GridLayout.ColumnWidth(2:3) = {0,0};
            else
                app.tool_ControlPanelVisibility.ImageSource = 'ArrowLeft_32.png';
                app.GridLayout.ColumnWidth(2:3) = {325,10};
            end

        end

        % Image clicked function: filter_refRXRefresh
        function filter_refRXRefreshClicked(app, event)
            
            refPoint = app.pointsTable(app.pointsTable.Reference,:);

            points_NodeList(app)

            if ~isequal(refPoint, app.pointsTable(app.pointsTable.Reference,:))
                filter_calculateDistanceColumn(app)
                filter_TableFiltering(app)
            end

        end

        % Selection changed function: UITable
        function UITableSelectionChanged(app, event)
            
            idxRow = event.Source.Selection(1);
            idxVirtual = str2double(extractAfter(event.Source.Data.ID(idxRow), '#'));
            if isequal(app.search_SelectedRowInfo.UserData, idxVirtual)
                return
            end

            dataStruct = struct('group', 'RFDataHub', 'value', table2struct(app.rfDataHub(idxVirtual,:)));
            app.search_SelectedRowInfo.HTMLSource = textFormatGUI.struct2PrettyPrintList(dataStruct, "print -1");
            app.search_SelectedRowInfo.UserData   = idxVirtual;

            delete(findobj(app.UIAxes3.Children, 'Tag', 'AntennaPattern'))
            if app.rfDataHub.AntennaPattern(idxVirtual) ~= "-1"
                [angle, gain] = class.RFDataHub.parsingAntennaPattern(app.rfDataHub.AntennaPattern(idxVirtual), 360);
                polarplot(app.UIAxes3, angle, gain, 'Tag', 'AntennaPattern')
            end


            % filter_TableStyle(app, 'SelectionRowChanged')
            % plot_SelectedRow(app)
            % drawnow
            
        end

        % Callback function
        function points_TreeSelectionChanged(app, event)
            
            if ~isempty(app.points_Tree.SelectedNodes)
                idx  = app.points_Tree.SelectedNodes.NodeData;
    
                app.filter_refRXLatitude.Value      = app.pointsTable.Latitude(idx);
                app.filter_refRXLongitude.Value     = app.pointsTable.Longitude(idx);
                app.points_AntennaHeight.Value = app.pointsTable.AntennaHeight(idx);
    
                if app.pointsTable.Reference(idx)
                    app.points_referenceButton.Enable = 0;
                else
                    app.points_referenceButton.Enable = 1;
                end
            end
            
        end

        % Menu selected function: points_delButton, points_editRowButton, 
        % ...and 1 other component
        function points_ContextMenuCallbacks(app, event)
            
            idx  = app.points_Tree.SelectedNodes.NodeData;

            if ~isempty(idx)
                editFlag = false;
                refIndex = find(app.pointsTable.Reference, 1);

                switch event.Source
                    case app.points_referenceButton
                        app.pointsTable.Reference      = zeros(height(app.pointsTable), 1, 'logical');
                        app.pointsTable.Reference(idx) = true;

                        editFlag = true;                        
    
                    case app.points_editRowButton
                        if app.filter_refRXGrid.ColumnWidth{4}
                            app.filter_refRXGrid.ColumnWidth{4} = 0;
        
                            app.filter_refRXLatitude.Editable      = 0;
                            app.filter_refRXLongitude.Editable     = 0;
                            app.points_AntennaHeight.Editable = 0;
                            points_TreeSelectionChanged(app)
                            return

                        else
                            app.filter_refRXGrid.ColumnWidth{4} = 22;
        
                            app.filter_refRXLatitude.Editable      = 1;
                            app.filter_refRXLongitude.Editable     = 1;
                            app.points_AntennaHeight.Editable = 1;
                            focus(app.filter_refRXLatitude)
                        end
    
                    case app.points_delButton                            
                        app.pointsTable(idx,:) = [];

                        if idx == refIndex
                            editFlag = true;
                            if ~isempty(app.pointsTable)
                                app.pointsTable.Reference(1) = true;
                            end
                        end
                end
                
                points_TreeBuilding(app, idx)
    
                if editFlag
                    filter_calculateDistanceColumn(app)
                    filter_TableFiltering(app)
                end
            end

        end

        % Value changed function: filter_refRXLatitude, 
        % ...and 1 other component
        function points_editButtonPushed(app, event)
            
            switch event.Source
                case app.filter_refRXLatitude
                    focus(app.filter_refRXLongitude)

                case app.filter_refRXLongitude
                    focus(app.points_AntennaHeight)

                case app.points_AntennaHeight
                    focus(app.points_editButton)

                case app.points_editButton
                    refIndex = find(app.pointsTable.Reference, 1);
                    editFlag = true;
                    
                    if isempty(app.pointsTable)
                        idx = 1;
                    else
                        idx  = app.points_Tree.SelectedNodes.NodeData;
                        if idx ~= refIndex
                            editFlag = false;
                        end
                    end

                    newLatitude  = app.filter_refRXLatitude.Value;
                    newLongitude = app.filter_refRXLongitude.Value;
                    newLocation  = fcn.gpsFindCity(struct('Latitude', newLatitude, 'Longitude', newLongitude));
                    newHeight    = app.points_AntennaHeight.Value;

                    app.pointsTable(idx,:) = {'manual',     ...
                                              newLatitude,  ...
                                              newLongitude, ...
                                              newLocation,  ...
                                              newHeight,    ...
                                              editFlag};

                    points_TreeBuilding(app, idx)
                    
                    if editFlag
                        filter_calculateDistanceColumn(app)
                        filter_TableFiltering(app)
                    end

                    % O painel de visualização/edição das coordenadas do ponto
                    % selecionado.
                    app.filter_refRXGrid.ColumnWidth{4} = 0;
                    set(app.filter_refRXLatitude,      Editable=0)
                    set(app.filter_refRXLongitude,     Editable=0)
                    set(app.points_AntennaHeight, Editable=0)
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
                    eval(sprintf('hROI = %s(app.UIAxes1, Color=[0.40,0.73,0.88], LineWidth=1, Deletable=0, FaceSelectable=0, %sTag="ROI", UserData=%s);', roiFcn, roiNameArgument, UUID))
                    plot.axes.Interactivity.DefaultEnable(app.UIAxes1)

                    if isempty(hROI.Position)
                        delete(hROI)
                        return
                    end
                    addlistener(hROI, 'MovingROI', @app.filter_ROICallbacks);
                    addlistener(hROI, 'ROIMoved',  @app.filter_ROICallbacks);
                    addlistener(hROI, 'ObjectBeingDestroyed', @(src, ~)plot.axes.Interactivity.DeleteListeners(src));
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
                        delete(findobj(app.UIAxes1.Children, Tag=sprintf('ROI_%s', app.filterTable.uuid{ii})))
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
            hTreeNodeDataList = arrayfun(@(x) x.NodeData, hTree);
            hCheckedNodeData  = arrayfun(@(x) x.NodeData, app.filter_Tree.CheckedNodes);

            disableIndexList  = setdiff(hTreeNodeDataList, hCheckedNodeData);
            enableIndexList   = setdiff((1:height(app.filterTable))', disableIndexList);

            app.filterTable.Enable(disableIndexList) = false;
            app.filterTable.Enable(enableIndexList)  = true;

            filter_TableFiltering(app)
            
        end

        % Image clicked function: axesTool_PDFButton
        function misc_PDFButtonButtonPushed(app, event)
            
            d = appUtil.modalWindow(app.UIFigure, 'progressdlg', 'Em andamento...');

            try
                idx = app.UITable.Selection(1);    
                fileName = fullfile(app.CallingApp.config_Folder_userPath.Value, sprintf('Relatório do Canal - Estação %d.pdf', app.UITable.Data.Station(idx)));

                if ~isfile(fileName)
                    websave(fileName, char(app.UITable.Data.URL(idx)), weboptions(Timeout=30));
                end
                app.chReportHTML.HTMLSource = fileName;
                app.chReportLabel.Text      = sprintf('Estação nº %d', app.UITable.Data.Station(idx));

            catch ME
                appUtil.modalWindow(app.UIFigure, 'warning', getReport(ME));
            end

            delete(d)

        end

        % Image clicked function: tool_ExportButton
        function misc_exportButtonPushed(app, event)
            
                defaultFilename = class.Constants.DefaultFileName(app.CallingApp.config_Folder_userPath.Value, 'RFDataHub', -1);

                [fileName, filePath, fileIndex] = uiputfile({'*.xlsx', 'Excel (*.xlsx)'}, '', defaultFilename);
                figure(app.UIFigure)
                
                if fileIndex
                    d = appUtil.modalWindow(app.UIFigure, 'progressdlg', 'Em andamento...');

                    try
                        tempRFDataHub = class.RFDataHub.ColumnNames(app.rfDataHub(app.rfDataHubLogical,1:29), 'eng2port');
                        writetable(tempRFDataHub, fullfile(filePath, fileName), 'WriteMode', 'overwritesheet')
                    catch ME
                        appUtil.modalWindow(app.UIFigure, 'warning', getReport(ME));
                    end

                    delete(d)
                end

        end

        % Callback function
        function misc_HistogramOrTerrainProfileButtonPushed(app, event)
            
            if event.PreviousValue
                event.Source.Value = true;
                return
            end

            switch event.Source
                case app.tool_HistogramAxesVisibility; app.tool_simulationAxesVisibility.Value = 0;
                otherwise;                             app.tool_HistogramAxesVisibility.Value  = 0;
            end

            layout_CartesianAxesLayout(app)
            drawnow
            
        end

        % Image clicked function: axesTool_simulationButton
        function misc_TerrainProfileRefreshImage(app, event)
            
            if ~app.tool_simulationAxesVisibility.Value
                app.tool_simulationAxesVisibility.Value = true;
                misc_HistogramOrTerrainProfileButtonPushed(app, struct('Source', app.tool_simulationAxesVisibility, 'PreviousValue', false))
            end

            plot_simulationLink(app)

        end

        % Callback function
        function tool_LOGButtonPushed(app, event)
            
            if ~isempty(app.UITable.Selection)
                global RFDataHubLog

                tableIndex = app.UITable.Selection(1);
                txIndex    = str2double(extractAfter(app.UITable.Data.ID{tableIndex}, '#'));                
                logIndex   = app.rfDataHub.Log(txIndex);

                [logInfo, msgError] = class.RFDataHub.queryLog(RFDataHubLog, logIndex);

                if isempty(logInfo) && isempty(msgError)
                    msg = 'Não evidenciada alteração do registro.';
                elseif isempty(msgError)
                    msg = jsonencode(logInfo, "PrettyPrint", true);
                else
                    msg = msgError;
                end
                appUtil.modalWindow(app.UIFigure, 'warning', msg);
            end

        end

        % Image clicked function: filter_Summary
        function filter_SummaryImageClicked(app, event)
            
                pause(1)

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app, Container)

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
            app.GridLayout.ColumnWidth = {5, 325, 10, 5, 116, '1x', 10, '1x', 5};
            app.GridLayout.RowHeight = {5, 22, '1x', 10, '0.4x', 5, 34};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.BackgroundColor = [1 1 1];

            % Create toolGrid
            app.toolGrid = uigridlayout(app.GridLayout);
            app.toolGrid.ColumnWidth = {22, '1x', 22, 22, 22};
            app.toolGrid.RowHeight = {4, 17, '1x'};
            app.toolGrid.ColumnSpacing = 5;
            app.toolGrid.RowSpacing = 0;
            app.toolGrid.Padding = [0 5 0 5];
            app.toolGrid.Layout.Row = 7;
            app.toolGrid.Layout.Column = [1 9];
            app.toolGrid.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create tool_ControlPanelVisibility
            app.tool_ControlPanelVisibility = uiimage(app.toolGrid);
            app.tool_ControlPanelVisibility.ImageClickedFcn = createCallbackFcn(app, @tool_LeftPanelVisibilityImageClicked, true);
            app.tool_ControlPanelVisibility.Layout.Row = 2;
            app.tool_ControlPanelVisibility.Layout.Column = 1;
            app.tool_ControlPanelVisibility.HorizontalAlignment = 'left';
            app.tool_ControlPanelVisibility.VerticalAlignment = 'bottom';
            app.tool_ControlPanelVisibility.ImageSource = 'ArrowLeft_32.png';

            % Create jsBackDoor
            app.jsBackDoor = uihtml(app.toolGrid);
            app.jsBackDoor.Layout.Row = 2;
            app.jsBackDoor.Layout.Column = 3;

            % Create tool_ExportButton
            app.tool_ExportButton = uiimage(app.toolGrid);
            app.tool_ExportButton.ScaleMethod = 'none';
            app.tool_ExportButton.ImageClickedFcn = createCallbackFcn(app, @misc_exportButtonPushed, true);
            app.tool_ExportButton.Layout.Row = 2;
            app.tool_ExportButton.Layout.Column = 4;
            app.tool_ExportButton.ImageSource = 'Export_16.png';

            % Create filter_Summary
            app.filter_Summary = uiimage(app.toolGrid);
            app.filter_Summary.ImageClickedFcn = createCallbackFcn(app, @filter_SummaryImageClicked, true);
            app.filter_Summary.Tooltip = {'Informações acerca do processo de análise dos dados'};
            app.filter_Summary.Layout.Row = 2;
            app.filter_Summary.Layout.Column = 5;
            app.filter_Summary.ImageSource = 'Info_32.png';

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
            app.Tab1_Grid.ColumnWidth = {'1x', 200, 13};
            app.Tab1_Grid.RowHeight = {22, '1x', 166, 13};
            app.Tab1_Grid.ColumnSpacing = 5;
            app.Tab1_Grid.RowSpacing = 5;
            app.Tab1_Grid.Padding = [0 0 0 0];
            app.Tab1_Grid.BackgroundColor = [1 1 1];

            % Create REGISTROSELECIONADOLabel
            app.REGISTROSELECIONADOLabel = uilabel(app.Tab1_Grid);
            app.REGISTROSELECIONADOLabel.VerticalAlignment = 'bottom';
            app.REGISTROSELECIONADOLabel.FontSize = 10;
            app.REGISTROSELECIONADOLabel.Layout.Row = 1;
            app.REGISTROSELECIONADOLabel.Layout.Column = 1;
            app.REGISTROSELECIONADOLabel.Text = 'REGISTRO SELECIONADO';

            % Create search_SelectedRowInfoPanel
            app.search_SelectedRowInfoPanel = uipanel(app.Tab1_Grid);
            app.search_SelectedRowInfoPanel.Layout.Row = [2 4];
            app.search_SelectedRowInfoPanel.Layout.Column = [1 3];

            % Create search_SelectedRowInfoGrid
            app.search_SelectedRowInfoGrid = uigridlayout(app.search_SelectedRowInfoPanel);
            app.search_SelectedRowInfoGrid.ColumnWidth = {'1x'};
            app.search_SelectedRowInfoGrid.RowHeight = {'1x'};
            app.search_SelectedRowInfoGrid.Padding = [0 0 0 0];
            app.search_SelectedRowInfoGrid.BackgroundColor = [1 1 1];

            % Create search_SelectedRowInfo
            app.search_SelectedRowInfo = uihtml(app.search_SelectedRowInfoGrid);
            app.search_SelectedRowInfo.HTMLSource = ' ';
            app.search_SelectedRowInfo.Layout.Row = 1;
            app.search_SelectedRowInfo.Layout.Column = 1;

            % Create PlotPanel
            app.PlotPanel = uipanel(app.Tab1_Grid);
            app.PlotPanel.BorderType = 'none';
            app.PlotPanel.Title = 'aa';
            app.PlotPanel.BackgroundColor = [0.3922 0.8314 0.0745];
            app.PlotPanel.Layout.Row = 3;
            app.PlotPanel.Layout.Column = 2;

            % Create Tab_2
            app.Tab_2 = uitab(app.ControlTabGroup);

            % Create Tab2_Grid
            app.Tab2_Grid = uigridlayout(app.Tab_2);
            app.Tab2_Grid.ColumnWidth = {22, '1x', 16, 16};
            app.Tab2_Grid.RowHeight = {22, 96, 134, 8, '1x', 1, 36, 59};
            app.Tab2_Grid.ColumnSpacing = 5;
            app.Tab2_Grid.RowSpacing = 5;
            app.Tab2_Grid.Padding = [0 0 0 0];
            app.Tab2_Grid.BackgroundColor = [1 1 1];

            % Create filter_SecondaryLabel
            app.filter_SecondaryLabel = uilabel(app.Tab2_Grid);
            app.filter_SecondaryLabel.VerticalAlignment = 'bottom';
            app.filter_SecondaryLabel.FontSize = 10;
            app.filter_SecondaryLabel.Layout.Row = 1;
            app.filter_SecondaryLabel.Layout.Column = [1 2];
            app.filter_SecondaryLabel.Text = 'PRIMÁRIA';

            % Create filter_SecondaryTypePanel
            app.filter_SecondaryTypePanel = uibuttongroup(app.Tab2_Grid);
            app.filter_SecondaryTypePanel.AutoResizeChildren = 'off';
            app.filter_SecondaryTypePanel.SelectionChangedFcn = createCallbackFcn(app, @filter_typePanelSelectionChanged, true);
            app.filter_SecondaryTypePanel.BackgroundColor = [1 1 1];
            app.filter_SecondaryTypePanel.Layout.Row = 2;
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
            app.filter_SecondaryValuePanel.Layout.Row = 3;
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
            app.filter_AddImage.Layout.Row = 4;
            app.filter_AddImage.Layout.Column = 4;
            app.filter_AddImage.ImageSource = 'addSymbol_32.png';

            % Create filter_Tree
            app.filter_Tree = uitree(app.Tab2_Grid, 'checkbox');
            app.filter_Tree.FontSize = 10;
            app.filter_Tree.Layout.Row = 5;
            app.filter_Tree.Layout.Column = [1 4];

            % Assign Checked Nodes
            app.filter_Tree.CheckedNodesChangedFcn = createCallbackFcn(app, @filter_TreeCheckedNodesChanged, true);

            % Create filter_refRXIcon
            app.filter_refRXIcon = uiimage(app.Tab2_Grid);
            app.filter_refRXIcon.Layout.Row = 7;
            app.filter_refRXIcon.Layout.Column = 1;
            app.filter_refRXIcon.ImageSource = 'Pin_32.png';

            % Create filter_refRXLabel
            app.filter_refRXLabel = uilabel(app.Tab2_Grid);
            app.filter_refRXLabel.VerticalAlignment = 'bottom';
            app.filter_refRXLabel.FontSize = 11;
            app.filter_refRXLabel.Layout.Row = 7;
            app.filter_refRXLabel.Layout.Column = 2;
            app.filter_refRXLabel.Interpreter = 'html';
            app.filter_refRXLabel.Text = {'<b>Estação de referência (RX)</b>'; '<font style="font-size: 9px; color: gray;">(relacionada à coluna calculada "Distância")</font>'};

            % Create filter_refRXRefresh
            app.filter_refRXRefresh = uiimage(app.Tab2_Grid);
            app.filter_refRXRefresh.ImageClickedFcn = createCallbackFcn(app, @filter_refRXRefreshClicked, true);
            app.filter_refRXRefresh.Tooltip = {'Atualiza estação de referência'};
            app.filter_refRXRefresh.Layout.Row = 7;
            app.filter_refRXRefresh.Layout.Column = 3;
            app.filter_refRXRefresh.VerticalAlignment = 'bottom';
            app.filter_refRXRefresh.ImageSource = 'Refresh_18.png';

            % Create filter_refRXEdit
            app.filter_refRXEdit = uiimage(app.Tab2_Grid);
            app.filter_refRXEdit.Layout.Row = 7;
            app.filter_refRXEdit.Layout.Column = 4;
            app.filter_refRXEdit.VerticalAlignment = 'bottom';
            app.filter_refRXEdit.ImageSource = 'Edit_32.png';

            % Create filter_refRXPanel
            app.filter_refRXPanel = uipanel(app.Tab2_Grid);
            app.filter_refRXPanel.Layout.Row = 8;
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
            app.filter_refRXLatitude.ValueChangedFcn = createCallbackFcn(app, @points_editButtonPushed, true);
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
            app.filter_refRXLongitude.ValueChangedFcn = createCallbackFcn(app, @points_editButtonPushed, true);
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
            app.filter_refRXHeight.Editable = 'off';
            app.filter_refRXHeight.FontSize = 11;
            app.filter_refRXHeight.Layout.Row = 2;
            app.filter_refRXHeight.Layout.Column = 3;

            % Create Tab_3
            app.Tab_3 = uitab(app.ControlTabGroup);

            % Create link_Grid
            app.link_Grid = uigridlayout(app.Tab_3);
            app.link_Grid.ColumnWidth = {'1x', 16};
            app.link_Grid.RowHeight = {9, 8, '1x', '1x'};
            app.link_Grid.RowSpacing = 5;
            app.link_Grid.Padding = [0 0 0 0];
            app.link_Grid.BackgroundColor = [1 1 1];

            % Create link_TableLabel
            app.link_TableLabel = uilabel(app.link_Grid);
            app.link_TableLabel.VerticalAlignment = 'bottom';
            app.link_TableLabel.FontSize = 10;
            app.link_TableLabel.Layout.Row = [1 2];
            app.link_TableLabel.Layout.Column = 1;
            app.link_TableLabel.Text = 'PONTOS DE INTERESSE';

            % Create link_AddStation
            app.link_AddStation = uiimage(app.link_Grid);
            app.link_AddStation.Layout.Row = 2;
            app.link_AddStation.Layout.Column = 2;
            app.link_AddStation.ImageSource = 'addSymbol_32.png';

            % Create link_Table
            app.link_Table = uitable(app.link_Grid);
            app.link_Table.ColumnName = {'ID'; 'TIPO'; 'LATITUDE'; 'LONGITUDE'; 'ALTURA'};
            app.link_Table.ColumnWidth = {'auto', 40, 70, 75, 60};
            app.link_Table.RowName = {};
            app.link_Table.ColumnEditable = [false true true true true];
            app.link_Table.Layout.Row = 3;
            app.link_Table.Layout.Column = [1 2];

            % Create link_LinkInfoPanel
            app.link_LinkInfoPanel = uipanel(app.link_Grid);
            app.link_LinkInfoPanel.AutoResizeChildren = 'off';
            app.link_LinkInfoPanel.Layout.Row = 4;
            app.link_LinkInfoPanel.Layout.Column = [1 2];

            % Create link_LinkInfoGrid
            app.link_LinkInfoGrid = uigridlayout(app.link_LinkInfoPanel);
            app.link_LinkInfoGrid.ColumnWidth = {'1x'};
            app.link_LinkInfoGrid.RowHeight = {'1x'};
            app.link_LinkInfoGrid.Padding = [0 0 0 0];
            app.link_LinkInfoGrid.BackgroundColor = [1 1 1];

            % Create link_LinkInfo
            app.link_LinkInfo = uihtml(app.link_LinkInfoGrid);
            app.link_LinkInfo.Layout.Row = 1;
            app.link_LinkInfo.Layout.Column = 1;

            % Create Tab_4
            app.Tab_4 = uitab(app.ControlTabGroup);
            app.Tab_4.AutoResizeChildren = 'off';

            % Create Tab4_Grid
            app.Tab4_Grid = uigridlayout(app.Tab_4);
            app.Tab4_Grid.ColumnWidth = {'1x', 16};
            app.Tab4_Grid.RowHeight = {27, 18, 184, 38, 100, 22, '1x'};
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
            app.config_geoAxesGrid.ColumnWidth = {60, 70, 36, 36, '1x'};
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
            app.config_geoAxesSubGrid.ColumnWidth = {'1x', 94};
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
            app.config_Colormap.FontSize = 11;
            app.config_Colormap.BackgroundColor = [1 1 1];
            app.config_Colormap.Layout.Row = 2;
            app.config_Colormap.Layout.Column = 2;
            app.config_Colormap.Value = 'winter';

            % Create config_route_Label
            app.config_route_Label = uilabel(app.config_geoAxesGrid);
            app.config_route_Label.FontSize = 10;
            app.config_route_Label.Layout.Row = 3;
            app.config_route_Label.Layout.Column = 1;
            app.config_route_Label.Text = 'Rota:';

            % Create config_route_LineStyle
            app.config_route_LineStyle = uidropdown(app.config_geoAxesGrid);
            app.config_route_LineStyle.Items = {'none', ':', '-'};
            app.config_route_LineStyle.FontSize = 11;
            app.config_route_LineStyle.BackgroundColor = [1 1 1];
            app.config_route_LineStyle.Layout.Row = 3;
            app.config_route_LineStyle.Layout.Column = 2;
            app.config_route_LineStyle.Value = 'none';

            % Create config_route_OutColor
            app.config_route_OutColor = uicolorpicker(app.config_geoAxesGrid);
            app.config_route_OutColor.Value = [0.502 0.502 0.502];
            app.config_route_OutColor.Layout.Row = 3;
            app.config_route_OutColor.Layout.Column = 3;
            app.config_route_OutColor.BackgroundColor = [1 1 1];

            % Create config_route_InColor
            app.config_route_InColor = uicolorpicker(app.config_geoAxesGrid);
            app.config_route_InColor.Value = [0.8706 0.5412 0.5412];
            app.config_route_InColor.Layout.Row = 3;
            app.config_route_InColor.Layout.Column = 4;
            app.config_route_InColor.BackgroundColor = [1 1 1];

            % Create config_route_Size
            app.config_route_Size = uislider(app.config_geoAxesGrid);
            app.config_route_Size.Limits = [1 9];
            app.config_route_Size.MajorTicks = [];
            app.config_route_Size.MinorTicks = [];
            app.config_route_Size.FontSize = 10;
            app.config_route_Size.Tooltip = {'Tamanho do marcador'};
            app.config_route_Size.Layout.Row = 3;
            app.config_route_Size.Layout.Column = 5;
            app.config_route_Size.Value = 1;

            % Create config_Car_Label
            app.config_Car_Label = uilabel(app.config_geoAxesGrid);
            app.config_Car_Label.FontSize = 10;
            app.config_Car_Label.Layout.Row = 4;
            app.config_Car_Label.Layout.Column = 1;
            app.config_Car_Label.Text = 'Veículo:';

            % Create config_Car_LineStyle
            app.config_Car_LineStyle = uidropdown(app.config_geoAxesGrid);
            app.config_Car_LineStyle.Items = {'none', 'o', 'square', '^'};
            app.config_Car_LineStyle.FontSize = 11;
            app.config_Car_LineStyle.BackgroundColor = [1 1 1];
            app.config_Car_LineStyle.Layout.Row = 4;
            app.config_Car_LineStyle.Layout.Column = 2;
            app.config_Car_LineStyle.Value = 'none';

            % Create config_Car_Color
            app.config_Car_Color = uicolorpicker(app.config_geoAxesGrid);
            app.config_Car_Color.Layout.Row = 4;
            app.config_Car_Color.Layout.Column = 3;
            app.config_Car_Color.BackgroundColor = [1 1 1];

            % Create config_Car_Size
            app.config_Car_Size = uislider(app.config_geoAxesGrid);
            app.config_Car_Size.Limits = [1 19];
            app.config_Car_Size.MajorTicks = [];
            app.config_Car_Size.MinorTicks = [];
            app.config_Car_Size.FontSize = 10;
            app.config_Car_Size.Tooltip = {'Tamanho do marcador'};
            app.config_Car_Size.Layout.Row = 4;
            app.config_Car_Size.Layout.Column = [4 5];
            app.config_Car_Size.Value = 10;

            % Create config_points_Label
            app.config_points_Label = uilabel(app.config_geoAxesGrid);
            app.config_points_Label.WordWrap = 'on';
            app.config_points_Label.FontSize = 10;
            app.config_points_Label.Layout.Row = 5;
            app.config_points_Label.Layout.Column = [1 2];
            app.config_points_Label.Text = {'Pontos de'; 'interesse:'};

            % Create config_points_LineStyle
            app.config_points_LineStyle = uidropdown(app.config_geoAxesGrid);
            app.config_points_LineStyle.Items = {'none', 'o', 'square', '^'};
            app.config_points_LineStyle.FontSize = 11;
            app.config_points_LineStyle.BackgroundColor = [1 1 1];
            app.config_points_LineStyle.Layout.Row = 5;
            app.config_points_LineStyle.Layout.Column = 2;
            app.config_points_LineStyle.Value = 'none';

            % Create config_points_Color
            app.config_points_Color = uicolorpicker(app.config_geoAxesGrid);
            app.config_points_Color.Value = [0 0 0];
            app.config_points_Color.Layout.Row = 5;
            app.config_points_Color.Layout.Column = 3;
            app.config_points_Color.BackgroundColor = [1 1 1];

            % Create config_points_Size
            app.config_points_Size = uislider(app.config_geoAxesGrid);
            app.config_points_Size.Limits = [6 12];
            app.config_points_Size.MajorTicks = [];
            app.config_points_Size.MinorTicks = [];
            app.config_points_Size.FontSize = 10;
            app.config_points_Size.Tooltip = {'Tamanho do marcador'};
            app.config_points_Size.Layout.Row = 5;
            app.config_points_Size.Layout.Column = [4 5];
            app.config_points_Size.Value = 9;

            % Create config_xyAxesLabel
            app.config_xyAxesLabel = uilabel(app.Tab4_Grid);
            app.config_xyAxesLabel.VerticalAlignment = 'bottom';
            app.config_xyAxesLabel.WordWrap = 'on';
            app.config_xyAxesLabel.FontSize = 10;
            app.config_xyAxesLabel.Layout.Row = 4;
            app.config_xyAxesLabel.Layout.Column = [1 2];
            app.config_xyAxesLabel.Interpreter = 'html';
            app.config_xyAxesLabel.Text = {'EIXOS CARTESIANOS'; '<p style="color: gray; font-size: 9px; text-align: justify; padding-right: 2px;">Os parâmetros relacionados aos eixos cartesianos não são customizáveis.</p>'};

            % Create config_xyAxesPanel
            app.config_xyAxesPanel = uipanel(app.Tab4_Grid);
            app.config_xyAxesPanel.AutoResizeChildren = 'off';
            app.config_xyAxesPanel.Layout.Row = 5;
            app.config_xyAxesPanel.Layout.Column = [1 2];

            % Create config_xyAxesGrid
            app.config_xyAxesGrid = uigridlayout(app.config_xyAxesPanel);
            app.config_xyAxesGrid.ColumnWidth = {60, 70, 36, '1x', '1x'};
            app.config_xyAxesGrid.RowHeight = {22, 22, 22};
            app.config_xyAxesGrid.RowSpacing = 5;
            app.config_xyAxesGrid.BackgroundColor = [1 1 1];

            % Create config_PersistanceLabel
            app.config_PersistanceLabel = uilabel(app.config_xyAxesGrid);
            app.config_PersistanceLabel.FontSize = 10;
            app.config_PersistanceLabel.Layout.Row = 1;
            app.config_PersistanceLabel.Layout.Column = [1 2];
            app.config_PersistanceLabel.Text = 'Persistência:';

            % Create config_PersistanceVisibility
            app.config_PersistanceVisibility = uidropdown(app.config_xyAxesGrid);
            app.config_PersistanceVisibility.Items = {'on', 'off'};
            app.config_PersistanceVisibility.Tooltip = {''};
            app.config_PersistanceVisibility.FontSize = 11;
            app.config_PersistanceVisibility.BackgroundColor = [1 1 1];
            app.config_PersistanceVisibility.Layout.Row = 1;
            app.config_PersistanceVisibility.Layout.Column = 2;
            app.config_PersistanceVisibility.Value = 'on';

            % Create config_chROILabel
            app.config_chROILabel = uilabel(app.config_xyAxesGrid);
            app.config_chROILabel.WordWrap = 'on';
            app.config_chROILabel.FontSize = 10;
            app.config_chROILabel.Layout.Row = 2;
            app.config_chROILabel.Layout.Column = 1;
            app.config_chROILabel.Text = 'Canal:';

            % Create config_chROIVisibility
            app.config_chROIVisibility = uidropdown(app.config_xyAxesGrid);
            app.config_chROIVisibility.Items = {'on', 'off'};
            app.config_chROIVisibility.Tooltip = {''};
            app.config_chROIVisibility.FontSize = 11;
            app.config_chROIVisibility.BackgroundColor = [1 1 1];
            app.config_chROIVisibility.Layout.Row = 2;
            app.config_chROIVisibility.Layout.Column = 2;
            app.config_chROIVisibility.Value = 'on';

            % Create config_chROIColor
            app.config_chROIColor = uicolorpicker(app.config_xyAxesGrid);
            app.config_chROIColor.Value = [0.7216 0.2706 1];
            app.config_chROIColor.Tooltip = {''};
            app.config_chROIColor.Layout.Row = 2;
            app.config_chROIColor.Layout.Column = 3;
            app.config_chROIColor.BackgroundColor = [1 1 1];

            % Create config_chROIEdgeAlpha
            app.config_chROIEdgeAlpha = uispinner(app.config_xyAxesGrid);
            app.config_chROIEdgeAlpha.Step = 0.1;
            app.config_chROIEdgeAlpha.Limits = [0 1];
            app.config_chROIEdgeAlpha.ValueDisplayFormat = '%.1f';
            app.config_chROIEdgeAlpha.FontSize = 11;
            app.config_chROIEdgeAlpha.Tooltip = {'Transparência da margem'};
            app.config_chROIEdgeAlpha.Layout.Row = 2;
            app.config_chROIEdgeAlpha.Layout.Column = 4;

            % Create config_chROIFaceAlpha
            app.config_chROIFaceAlpha = uispinner(app.config_xyAxesGrid);
            app.config_chROIFaceAlpha.Step = 0.1;
            app.config_chROIFaceAlpha.Limits = [0 1];
            app.config_chROIFaceAlpha.ValueDisplayFormat = '%.1f';
            app.config_chROIFaceAlpha.FontSize = 11;
            app.config_chROIFaceAlpha.Tooltip = {'Transparência da face'};
            app.config_chROIFaceAlpha.Layout.Row = 2;
            app.config_chROIFaceAlpha.Layout.Column = 5;
            app.config_chROIFaceAlpha.Value = 0.4;

            % Create config_chPowerLabel
            app.config_chPowerLabel = uilabel(app.config_xyAxesGrid);
            app.config_chPowerLabel.WordWrap = 'on';
            app.config_chPowerLabel.FontSize = 10;
            app.config_chPowerLabel.Layout.Row = 3;
            app.config_chPowerLabel.Layout.Column = [1 2];
            app.config_chPowerLabel.Text = {'Potência do'; 'canal:'};

            % Create config_chPowerVisibility
            app.config_chPowerVisibility = uidropdown(app.config_xyAxesGrid);
            app.config_chPowerVisibility.Items = {'on', 'off'};
            app.config_chPowerVisibility.Tooltip = {''};
            app.config_chPowerVisibility.FontSize = 11;
            app.config_chPowerVisibility.BackgroundColor = [1 1 1];
            app.config_chPowerVisibility.Layout.Row = 3;
            app.config_chPowerVisibility.Layout.Column = 2;
            app.config_chPowerVisibility.Value = 'on';

            % Create config_chPowerColor
            app.config_chPowerColor = uicolorpicker(app.config_xyAxesGrid);
            app.config_chPowerColor.Value = [0.5686 1 0];
            app.config_chPowerColor.Tooltip = {''};
            app.config_chPowerColor.Layout.Row = 3;
            app.config_chPowerColor.Layout.Column = 3;
            app.config_chPowerColor.BackgroundColor = [1 1 1];

            % Create config_chPowerEdgeAlpha
            app.config_chPowerEdgeAlpha = uispinner(app.config_xyAxesGrid);
            app.config_chPowerEdgeAlpha.Step = 0.1;
            app.config_chPowerEdgeAlpha.Limits = [0 1];
            app.config_chPowerEdgeAlpha.ValueDisplayFormat = '%.1f';
            app.config_chPowerEdgeAlpha.FontSize = 11;
            app.config_chPowerEdgeAlpha.Tooltip = {'Transparência da margem'};
            app.config_chPowerEdgeAlpha.Layout.Row = 3;
            app.config_chPowerEdgeAlpha.Layout.Column = 4;
            app.config_chPowerEdgeAlpha.Value = 1;

            % Create config_chPowerFaceAlpha
            app.config_chPowerFaceAlpha = uispinner(app.config_xyAxesGrid);
            app.config_chPowerFaceAlpha.Step = 0.1;
            app.config_chPowerFaceAlpha.Limits = [0 1];
            app.config_chPowerFaceAlpha.ValueDisplayFormat = '%.1f';
            app.config_chPowerFaceAlpha.FontSize = 11;
            app.config_chPowerFaceAlpha.Tooltip = {'Transparência da face'};
            app.config_chPowerFaceAlpha.Layout.Row = 3;
            app.config_chPowerFaceAlpha.Layout.Column = 5;
            app.config_chPowerFaceAlpha.Value = 0.4;

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

            % Create menu_MainGrid
            app.menu_MainGrid = uigridlayout(app.ControlTabGrid);
            app.menu_MainGrid.ColumnWidth = {'1x', 22, 22, 22};
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
            app.menu_Button1Icon.ImageClickedFcn = createCallbackFcn(app, @general_LeftPanelMenuSelectionChanged, true);
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
            app.menu_Button2Icon.ImageClickedFcn = createCallbackFcn(app, @general_LeftPanelMenuSelectionChanged, true);
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
            app.menu_Button3Label.Text = 'ENLACE';

            % Create menu_Button3Icon
            app.menu_Button3Icon = uiimage(app.menu_Button3Grid);
            app.menu_Button3Icon.ScaleMethod = 'none';
            app.menu_Button3Icon.ImageClickedFcn = createCallbackFcn(app, @general_LeftPanelMenuSelectionChanged, true);
            app.menu_Button3Icon.Tag = '3';
            app.menu_Button3Icon.Layout.Row = 1;
            app.menu_Button3Icon.Layout.Column = [1 2];
            app.menu_Button3Icon.HorizontalAlignment = 'left';
            app.menu_Button3Icon.ImageSource = 'Connect_18.png';

            % Create menu_Button4Grid
            app.menu_Button4Grid = uigridlayout(app.menu_MainGrid);
            app.menu_Button4Grid.ColumnWidth = {18, 0};
            app.menu_Button4Grid.RowHeight = {'1x'};
            app.menu_Button4Grid.ColumnSpacing = 3;
            app.menu_Button4Grid.Padding = [2 0 0 0];
            app.menu_Button4Grid.Layout.Row = 1;
            app.menu_Button4Grid.Layout.Column = 4;
            app.menu_Button4Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create menu_Button4Label
            app.menu_Button4Label = uilabel(app.menu_Button4Grid);
            app.menu_Button4Label.FontSize = 11;
            app.menu_Button4Label.Layout.Row = 1;
            app.menu_Button4Label.Layout.Column = 2;
            app.menu_Button4Label.Text = 'CONFIGURAÇÕES GERAIS';

            % Create menu_Button4Icon
            app.menu_Button4Icon = uiimage(app.menu_Button4Grid);
            app.menu_Button4Icon.ScaleMethod = 'none';
            app.menu_Button4Icon.ImageClickedFcn = createCallbackFcn(app, @general_LeftPanelMenuSelectionChanged, true);
            app.menu_Button4Icon.Tag = '4';
            app.menu_Button4Icon.Layout.Row = 1;
            app.menu_Button4Icon.Layout.Column = [1 2];
            app.menu_Button4Icon.HorizontalAlignment = 'left';
            app.menu_Button4Icon.ImageSource = 'Settings_18.png';

            % Create UITable
            app.UITable = uitable(app.GridLayout);
            app.UITable.ColumnName = {'ID'; 'FREQUÊNCIA|(MHz)'; 'LATITUDE'; 'LONGITUDE'; 'DESCRIÇÃO|(Entidade+Fistel+Multiplicidade+Localidade)'; 'SERVIÇO'; 'ESTAÇÃO'; 'CLASSE|EMISSÃO'; 'LARGURA|(kHz)'; 'URL'; 'DISTÂNCIA|(km)'};
            app.UITable.ColumnWidth = {50, 110, 75, 75, 'auto', 75, 75, 75, 75, 50, 90};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [false true false false false true true false true false true];
            app.UITable.SelectionChangedFcn = createCallbackFcn(app, @UITableSelectionChanged, true);
            app.UITable.Multiselect = 'off';
            app.UITable.ForegroundColor = [0.149 0.149 0.149];
            app.UITable.Layout.Row = 5;
            app.UITable.Layout.Column = [4 8];
            app.UITable.FontSize = 10;

            % Create tableInfoNRows
            app.tableInfoNRows = uilabel(app.GridLayout);
            app.tableInfoNRows.HorizontalAlignment = 'right';
            app.tableInfoNRows.VerticalAlignment = 'bottom';
            app.tableInfoNRows.FontSize = 10;
            app.tableInfoNRows.Visible = 'off';
            app.tableInfoNRows.Layout.Row = [3 4];
            app.tableInfoNRows.Layout.Column = 8;
            app.tableInfoNRows.Text = '# 0 ';

            % Create chReportHTML
            app.chReportHTML = uihtml(app.GridLayout);
            app.chReportHTML.HTMLSource = 'pdfLogo.html';
            app.chReportHTML.Layout.Row = [2 3];
            app.chReportHTML.Layout.Column = 8;

            % Create plotPanel
            app.plotPanel = uipanel(app.GridLayout);
            app.plotPanel.BorderType = 'none';
            app.plotPanel.BackgroundColor = [0.302 0.7451 0.9333];
            app.plotPanel.Layout.Row = [2 3];
            app.plotPanel.Layout.Column = [4 6];

            % Create axesToolbarGrid
            app.axesToolbarGrid = uigridlayout(app.GridLayout);
            app.axesToolbarGrid.ColumnWidth = {22, 22, 22, 22, 22};
            app.axesToolbarGrid.RowHeight = {'1x'};
            app.axesToolbarGrid.ColumnSpacing = 0;
            app.axesToolbarGrid.Padding = [2 2 2 7];
            app.axesToolbarGrid.Layout.Row = [1 2];
            app.axesToolbarGrid.Layout.Column = 5;
            app.axesToolbarGrid.BackgroundColor = [1 1 1];

            % Create axesTool_RestoreView
            app.axesTool_RestoreView = uiimage(app.axesToolbarGrid);
            app.axesTool_RestoreView.Tooltip = {'RestoreView'};
            app.axesTool_RestoreView.Layout.Row = 1;
            app.axesTool_RestoreView.Layout.Column = 1;
            app.axesTool_RestoreView.ImageSource = 'Home_18.png';

            % Create axesTool_RegionZoom
            app.axesTool_RegionZoom = uiimage(app.axesToolbarGrid);
            app.axesTool_RegionZoom.Tooltip = {'RegionZoom'};
            app.axesTool_RegionZoom.Layout.Row = 1;
            app.axesTool_RegionZoom.Layout.Column = 2;
            app.axesTool_RegionZoom.ImageSource = 'ZoomRegion_20.png';

            % Create axesTool_TableVisibility
            app.axesTool_TableVisibility = uiimage(app.axesToolbarGrid);
            app.axesTool_TableVisibility.ScaleMethod = 'none';
            app.axesTool_TableVisibility.Tooltip = {'Visibilidade da tabela'};
            app.axesTool_TableVisibility.Layout.Row = 1;
            app.axesTool_TableVisibility.Layout.Column = 3;
            app.axesTool_TableVisibility.ImageSource = 'View_16.png';

            % Create axesTool_simulationButton
            app.axesTool_simulationButton = uiimage(app.axesToolbarGrid);
            app.axesTool_simulationButton.ScaleMethod = 'none';
            app.axesTool_simulationButton.ImageClickedFcn = createCallbackFcn(app, @misc_TerrainProfileRefreshImage, true);
            app.axesTool_simulationButton.Tooltip = {'Perfil de terreno entre registro selecionado (TX) '; 'e estação de referência (RX)'};
            app.axesTool_simulationButton.Layout.Row = 1;
            app.axesTool_simulationButton.Layout.Column = 5;
            app.axesTool_simulationButton.ImageSource = 'Publish_HTML_16.png';

            % Create axesTool_PDFButton
            app.axesTool_PDFButton = uiimage(app.axesToolbarGrid);
            app.axesTool_PDFButton.ScaleMethod = 'none';
            app.axesTool_PDFButton.ImageClickedFcn = createCallbackFcn(app, @misc_PDFButtonButtonPushed, true);
            app.axesTool_PDFButton.Tooltip = {'Relatório do registro selecionado'; '(limitado à radiodifusão)'};
            app.axesTool_PDFButton.Layout.Row = 1;
            app.axesTool_PDFButton.Layout.Column = 4;
            app.axesTool_PDFButton.ImageSource = 'Publish_PDF_16.png';

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

            % Create points_ContextMenu
            app.points_ContextMenu = uicontextmenu(app.UIFigure);

            % Create points_referenceButton
            app.points_referenceButton = uimenu(app.points_ContextMenu);
            app.points_referenceButton.MenuSelectedFcn = createCallbackFcn(app, @points_ContextMenuCallbacks, true);
            app.points_referenceButton.Text = 'Referência';

            % Create points_editRowButton
            app.points_editRowButton = uimenu(app.points_ContextMenu);
            app.points_editRowButton.MenuSelectedFcn = createCallbackFcn(app, @points_ContextMenuCallbacks, true);
            app.points_editRowButton.Separator = 'on';
            app.points_editRowButton.Text = 'Editar';

            % Create points_delButton
            app.points_delButton = uimenu(app.points_ContextMenu);
            app.points_delButton.MenuSelectedFcn = createCallbackFcn(app, @points_ContextMenuCallbacks, true);
            app.points_delButton.Text = 'Excluir';

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
