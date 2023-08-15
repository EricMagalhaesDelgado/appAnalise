classdef winAnatelDB < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        mainGrid             matlab.ui.container.GridLayout
        mainPanel            matlab.ui.container.Panel
        Grid1                matlab.ui.container.GridLayout
        ccTable              ccTools.Table
        Panel2               matlab.ui.container.Panel
        Panel1               matlab.ui.container.Panel
        Grid2                matlab.ui.container.GridLayout
        Pan                  matlab.ui.control.StateButton
        Zoom                 matlab.ui.control.StateButton
        Separator_4          matlab.ui.control.Image
        TableVisibility      matlab.ui.control.Image
        Export_save          matlab.ui.control.Image
        Separator_3          matlab.ui.control.Image
        Spinner              matlab.ui.control.Spinner
        ReleaseDate          matlab.ui.control.Label
        LocationRefresh      matlab.ui.control.Image
        Location             matlab.ui.control.DropDown
        LocationLabel        matlab.ui.control.Label
        Separator            matlab.ui.control.Image
        HistogramVisibility  matlab.ui.control.Image
    end

    
    properties (Access = private)        
        CallingApp
        RootFolder

        UIAxes1
        UIAxes2
        UIAxes3

        Layout = 3

        Parameters = struct('Family', {}, 'Type', {}, 'Value', {});
        nodeTable        
    end
    
    methods (Access = private)

        function startup_AxesCreation(app)
            % Geographic axes
            t1 = tiledlayout(app.Panel1, 1, 1, "Padding", "tight");

            app.UIAxes1 = geoaxes(t1, 'FontSize', 6, 'Units', 'pixels', 'Basemap', 'darkwater');
            app.UIAxes1.Layout.Tile = 1;
            addToolbarMapButton(axtoolbar(app.UIAxes1, "default"), "basemap", BasemapNames=["darkwater", "satellite", "streets-light", "streets-dark", "topographic", "streets", "colorterrain", "grayterrain"])
            app.UIAxes1.LatitudeLabel.String  = '';
            app.UIAxes1.LongitudeLabel.String = '';
            hold(app.UIAxes1, 'on')
            try
                geobasemap(app.UIAxes1, 'streets-light')
            catch
            end

            % Regular axes
            t2 = tiledlayout(app.Panel2, 1, 2, "Padding", "tight", "TileSpacing", "tight");

            app.UIAxes2 = uiaxes(t2);
            app.UIAxes2.Layout.Tile = 1;
            xlabel(app.UIAxes2, 'Frequência (MHz)')
            ylabel(app.UIAxes2, 'Registros')
            app.UIAxes2.YScale = 'log';
            app.UIAxes2.YMinorTick = 'on';
            app.UIAxes2.Color = [0.9804 0.9804 0.9804];
            app.UIAxes2.FontSize = 8;

            app.UIAxes3 = uiaxes(t2);
            app.UIAxes3.Layout.Tile = 2;
            xlabel(app.UIAxes3, 'Serviço')
            ylabel(app.UIAxes3, '')
            app.UIAxes3.YScale = 'log';
            app.UIAxes3.YMinorTick = 'on';
            app.UIAxes3.Color = [0.9804 0.9804 0.9804];
            app.UIAxes3.FontSize = 8;

            app.UIAxes1.Interactions = [panInteraction, zoomInteraction, dataTipInteraction];
            app.UIAxes2.Interactions = dataTipInteraction;
            app.UIAxes3.Interactions = [regionZoomInteraction, zoomInteraction, dataTipInteraction];

            axtoolbar(app.UIAxes2, {'restoreview'});
            axtoolbar(app.UIAxes3, {'restoreview'});
            
            enableDefaultInteractivity(app.UIAxes1)
            enableDefaultInteractivity(app.UIAxes2)
            enableDefaultInteractivity(app.UIAxes3)
            drawnow
        end


        function startup_NodeList(app)
            specData  = app.CallingApp.specData;
            app.nodeTable = table('Size', [0, 3],                                ...
                                  'VariableTypes', {'double', 'double', 'cell'}, ...
                                  'VariableNames', {'lat', 'long', 'location'});

            app.Location.Items = {};
            for ii = 1:numel(specData)
                if specData(ii).gps.Status
                    msg = sprintf('%.6f, %.6f (%s)', specData(ii).gps.Latitude,  ...
                                                     specData(ii).gps.Longitude, ...
                                                     specData(ii).gps.Location);

                    if isempty(app.Location.Items) | ~contains(app.Location.Items, msg)
                        app.Location.Items{end+1} = msg;
                        app.nodeTable(end+1,:) = {specData(ii).gps.Latitude, specData(ii).gps.Longitude, specData(ii).gps.Location};
                    end
                end
            end

            if isempty(app.Location.Items)
                app.Location.Enable = 0;
            else
                app.Location.Enable = 1;
            end
        end


        function startup_AnatelDB(app)
            global AnatelDB
            global AnatelDB_info

            app.ReleaseDate.Text = sprintf('anateldb\n%s', extractBefore(AnatelDB_info.ReleaseDate, ' '));

            tempTable          = AnatelDB;
            tempTable.Distance = -1*ones(height(AnatelDB), 1);

            if ~isempty(app.Location.Value)
                Node     = regexp(app.Location.Value, '(?<lat>[-]{0,1}\d+[.]{1}\d{6}), (?<lon>[-]{0,1}\d+[.]{1}\d{6})', 'names');
                Node.lat = str2double(Node.lat);
                Node.lon = str2double(Node.lon);

                tempTable.Distance = double(round(geo_lldistkm_v2(Node, tempTable(:, 3:4)), 1));
            end

            app.ccTable.Data = tempTable;
            drawnow

            plot_General(app)
            plot_SelectedRow(app)
            plot_Nodes(app)
            drawnow
        end
        
        
        function plot_General(app)
            hTable = app.ccTable.Data(app.ccTable.FilteredIndex,:);

            % app.UIAxes1: Geographic plot
            cla(app.UIAxes1)
            hold(app.UIAxes1, "on")

            p1 = geoscatter(app.UIAxes1, hTable.Latitude, hTable.Longitude, "MarkerEdgeColor", "#009578");
            geolimits(app.UIAxes1, 'auto')

            hold(app.UIAxes1, "off")

            % app.UIAxes2 & app.UIAxes3
            p2 = histogram(app.UIAxes2, hTable.Frequency);
            p3 = histogram(app.UIAxes3, categorical(hTable.Service));
            
            tic; t = toc;
            while t < 3
                try
                    app.UIAxes2.Children.EdgeColor = 'none';
                    app.UIAxes2.Children.FaceColor = "#009578";

                    app.UIAxes3.Children.EdgeColor = 'none';
                    app.UIAxes3.Children.FaceColor = "#009578";

                    break
                catch
                    t = toc;
                end
            end

            % DataTip
            if height(hTable)
                plot_DataTipTemplate(app, 'Geographic', p1, hTable)
                plot_DataTipTemplate(app, 'Histogram1', p2, [])
                plot_DataTipTemplate(app, 'Histogram2', p3, [])
            end
        end


        function plot_SelectedRow(app)
            hSelected = findobj(app.UIAxes1, 'Tag', 'SelectedRow');
            
            idx = app.ccTable.Selection;
            if idx
                hold(app.UIAxes1, 'on')

                if isempty(hSelected)
                    hSelected = geoscatter(app.UIAxes1, app.ccTable.Data{idx,3}, app.ccTable.Data{idx,4}, 'MarkerEdgeColor', '#A2142F', ...
                                                                                                          'MarkerFaceColor', '#A2142F', ...
                                                                                                          'Tag', 'SelectedRow');
                else
                    set(hSelected, 'LatitudeData',  app.ccTable.Data{idx,3}, ...
                                   'LongitudeData', app.ccTable.Data{idx,4})
                end
                plot_DataTipTemplate(app, 'Geographic', hSelected, app.ccTable.Data(idx,:))

                hold(app.UIAxes1, 'off')
            else
                delete(hSelected)
            end
        end


        function plot_Nodes(app)
            if ~isempty(app.nodeTable)
                hold(app.UIAxes1, 'on')

                if height(app.nodeTable) > 1
                    p1 = geoscatter(app.UIAxes1, app.nodeTable.lat, app.nodeTable.long, 'Marker', '^', 'MarkerEdgeColor', '#A2142F', 'Tag', 'OthersNodes');
                    plot_DataTipTemplate(app, 'SelectedNode', p1, [])
                end

                idx = find(strcmp(app.Location.Items, app.Location.Value), 1);
                p2 = geoscatter(app.UIAxes1, app.nodeTable.lat(idx), app.nodeTable.long(idx), 'Marker', '^', 'MarkerEdgeColor', '#A2142F', 'MarkerFaceColor', '#A2142F', 'Tag', 'SelectedNode');
                plot_DataTipTemplate(app, 'SelectedNode', p2, [])

                hold(app.UIAxes1, 'off')
            end
        end


        function plot_DataTipTemplate(app, pType, pHandle, hTable)
            set(pHandle.DataTipTemplate, FontName='Calibri', FontSize=10)

            switch pType
                case 'Geographic'
                    pHandle.DataTipTemplate.DataTipRows(1) = dataTipTextRow('', hTable.Frequency, '%.3f MHz');
                    pHandle.DataTipTemplate.DataTipRows(2) = dataTipTextRow('', hTable.Distance,  '%.0f km');

                    ROWS = height(hTable);
                    if ROWS == 1
                        pHandle.DataTipTemplate.DataTipRows(3) = dataTipTextRow('ID:', {hTable{:,1}});               
                        pHandle.DataTipTemplate.DataTipRows(4) = dataTipTextRow('',    {hTable{:,5}});

                    elseif ROWS > 1
                        pHandle.DataTipTemplate.DataTipRows(3) = dataTipTextRow('ID:', hTable{:,1});
                        pHandle.DataTipTemplate.DataTipRows(4) = dataTipTextRow('',    hTable{:,5});
                    end

                    pHandle.DataTipTemplate.DataTipRows = pHandle.DataTipTemplate.DataTipRows([3,1,4,2]);

                case 'SelectedNode'
                    pHandle.DataTipTemplate.DataTipRows(1).Label = 'Lat:';
                    pHandle.DataTipTemplate.DataTipRows(2).Label = 'Lon:';

                case 'Histogram1'
                    pHandle.DataTipTemplate.DataTipRows = flip(pHandle.DataTipTemplate.DataTipRows);
                    
                    pHandle.DataTipTemplate.DataTipRows(1).Label = 'Banda (MHz):';
                    pHandle.DataTipTemplate.DataTipRows(2).Label = 'Registros:';

                case 'Histogram2'
                    pHandle.DataTipTemplate.DataTipRows = flip(pHandle.DataTipTemplate.DataTipRows);

                    pHandle.DataTipTemplate.DataTipRows(1).Label = 'Serviço:';
                    pHandle.DataTipTemplate.DataTipRows(2).Label = 'Registros:';
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            
            app.Grid1.RowHeight(3) = {0};
            
            app.CallingApp = mainapp;
            app.RootFolder = app.CallingApp.RootFolder;
            winPosition(app)
            
            startup_AxesCreation(app)
            startup_NodeList(app)
            startup_AnatelDB(app)

        end

        % Close request function: UIFigure
        function closeFcn(app, event)
            
            app.CallingApp.auxWin8 = [];
            delete(app)
            
        end

        % Value changed function: Location
        function LocationValueChanged(app, event)
            
            d = uiprogressdlg(app.UIFigure, "Message", '<font style="font-size:12;">Em andamento...</font>', "Interpreter", "html", "Indeterminate", "on");
            
            startup_AnatelDB(app)

            delete(d)

        end

        % Image clicked function: LocationRefresh
        function LocationRefreshClicked(app, event)
            
            d = uiprogressdlg(app.UIFigure, "Message", '<font style="font-size:12;">Em andamento...</font>', "Interpreter", "html", "Indeterminate", "on");

            InitialValue = app.Location.Value;
            startup_NodeList(app)

            if ~isempty(InitialValue)
                idx = find(strcmp(app.Location.Items, InitialValue), 1);
                if ~isempty(idx)
                    app.Location.Value = InitialValue;
                    LocationValueChanged(app)
                else
                    LocationValueChanged(app)
                end

            else
                if ~isempty(app.Location.Value)
                    LocationValueChanged(app)
                end
            end

            delete(d)
            
        end

        % Image clicked function: HistogramVisibility, TableVisibility
        function LayoutPlotChanged(app, event)

            switch event.Source
                case app.HistogramVisibility
                    if app.Grid1.RowHeight{3}
                        app.HistogramVisibility.ImageSource = 'DriveTest_Scatter_OFF.png';
                        app.Zoom.Enable = 0;
                        app.Pan.Enable  = 0;
                    else
                        app.HistogramVisibility.ImageSource = 'DriveTest_Scatter_ON.png';
                        app.Zoom.Enable = 1;
                        app.Pan.Enable  = 1;
                    end

                case app.TableVisibility
                    if app.Grid1.RowHeight{4}
                        app.TableVisibility.ImageSource = 'DriveTest_Route_OFF.png';
                    else
                        app.TableVisibility.ImageSource = 'DriveTest_Route_ON.png';
                    end
            end

            app.Layout = [];
            if contains(app.HistogramVisibility.ImageSource, 'DriveTest_Scatter_ON.png')
                app.Layout = [app.Layout, 2];
            end
            if contains(app.TableVisibility.ImageSource, 'DriveTest_Route_ON.png')
                app.Layout = [app.Layout, 3];
            end

            LayoutRatioChanged(app)
            
        end

        % Value changed function: Spinner
        function LayoutRatioChanged(app, event)
            
            value = app.Spinner.Value;

            RowHeight = {'1x',0,0};
            if value >= 0
                RowHeight(app.Layout) = {sprintf('%.1fx', 1-value)};
            else
                if ~isempty(app.Layout)
                    RowHeight(1)          = {sprintf('%.1fx', 1+value)};
                    RowHeight(app.Layout) = {'1x'};
                end
            end
            app.Grid1.RowHeight(2:4) = RowHeight;

        end

        % Callback function: ccTable
        function ccTableSelectionChanged(app, event)

            plot_SelectedRow(app)
            drawnow
            
        end

        % Callback function: ccTable
        function ccTableDataFiltered(app, event)
            
            plot_General(app)
            plot_SelectedRow(app)
            plot_Nodes(app)
            drawnow

        end

        % Image clicked function: Export_save
        function Export_saveImageClicked(app, event)

            Selection = uiconfirm(app.UIFigure, '<font style="font-size:12;">O processo de salvar a base de dados do anateldb poderá demorar alguns minutos. Deseja continuar?</font>', ...
                                                'appAnalise', 'Interpreter', 'html', 'Options', {'OK', 'Cancelar'}, 'DefaultOption', 2, 'CancelOption', 2);
            if strcmp(Selection, 'Cancelar')
                return
            end
                
            global AnatelDB_info

            d = uiprogressdlg(app.UIFigure, "Message", '<font style="font-size:12;">Em andamento...</font>', ...
                                            "Interpreter", "html", "Indeterminate", "on", "Cancelable", "on", "CancelText", "Cancelar", "Title", "appAnalise");

            userPath = app.CallingApp.menu_userPath.Value;
            basename = sprintf('anateldb_%s.xlsx', datestr(now, 'yyyymmdd_THHMMSS'));
            try
                if ~isempty(app.Location.Value)
                    locName = app.Location.Value;
                else
                    locName = '(none)';
                end

                metaFile = sprintf(['Filename: "%s"\n\n',                   ...
                                    'AnatelDB: %s\n'                        ...
                                    'ColumnRawNames: {%s}\n'                ...
                                    'ColumnName: {%s}\n'                    ...
                                    'ColumnPrecision: {%s}\n'               ...
                                    'RawDataSize: %d rows x %d columns\n\n' ...
                                    'ReferenceLocation: %s\n'               ...
                                    'FilterSentence: %s\n'                  ...
                                    'FilteredDataSize: %d rows'], basename,                                   ...
                                                                  jsonencode(AnatelDB_info),                  ...
                                                                  strjoin(app.ccTable.Data.Properties.VariableNames, ', '), ...
                                                                  strjoin(app.ccTable.ColumnName, ', '),      ...
                                                                  strjoin(app.ccTable.ColumnPrecision, ', '), ...
                                                                  height(app.ccTable.Data),                   ...
                                                                  width(app.ccTable.Data),                    ...
                                                                  locName,                                    ...
                                                                  struct(app.ccTable).Filters.Text,           ...
                                                                  height(app.ccTable.FilteredIndex));

                writetable(app.ccTable.Data(app.ccTable.FilteredIndex,:), fullfile(userPath, basename), 'WriteMode', 'overwritesheet')
                writecell({metaFile}, fullfile(userPath, replace(basename, '.xlsx', '.cfg')), "FileType", "text", "QuoteStrings", false, "WriteMode", "overwrite")
                pause(.100)
    
                msg = sprintf('Foram salvos os seguintes arquivos na pasta de trabalho:\n- %s\n- %s', basename, replace(basename, '.xlsx', '.cfg'));
                MessageBox(app, 'info', msg)

            catch ME
                fprintf('%s\n', jsonencode(ME))
                MessageBox(app, 'error', getReport(ME))
            end
            delete(d)
        end

        % Value changed function: Pan, Zoom
        function InteractionButtonPushed(app, event)

            switch event.Source
                case app.Zoom
                    if app.Zoom.Value
                        app.Pan.Value = 0;

                        app.UIAxes2.Interactions(1) = regionZoomInteraction;
                        app.UIAxes3.Interactions(1) = regionZoomInteraction;
                    else
                        app.Zoom.Value = 1;
                    end

                case app.Pan
                    if app.Pan.Value
                        app.Zoom.Value = 0;

                        app.UIAxes2.Interactions(1) = panInteraction;
                        app.UIAxes3.Interactions(1) = panInteraction;
                    else
                        app.Pan.Value = 1;
                    end
            end
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1244 660];
            app.UIFigure.Name = 'appAnalise';
            app.UIFigure.Icon = 'LR_icon.png';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @closeFcn, true);

            % Create mainGrid
            app.mainGrid = uigridlayout(app.UIFigure);
            app.mainGrid.ColumnWidth = {'1x'};
            app.mainGrid.RowHeight = {'1x'};
            app.mainGrid.ColumnSpacing = 0;
            app.mainGrid.RowSpacing = 0;
            app.mainGrid.Padding = [0 0 0 0];
            app.mainGrid.BackgroundColor = [1 1 1];

            % Create mainPanel
            app.mainPanel = uipanel(app.mainGrid);
            app.mainPanel.AutoResizeChildren = 'off';
            app.mainPanel.BackgroundColor = [1 1 1];
            app.mainPanel.Layout.Row = 1;
            app.mainPanel.Layout.Column = 1;

            % Create Grid1
            app.Grid1 = uigridlayout(app.mainPanel);
            app.Grid1.ColumnWidth = {'1x'};
            app.Grid1.RowHeight = {24, '1x', 0, '0.5x'};
            app.Grid1.ColumnSpacing = 5;
            app.Grid1.RowSpacing = 5;
            app.Grid1.Padding = [5 5 5 5];
            app.Grid1.BackgroundColor = [1 1 1];

            % Create Grid2
            app.Grid2 = uigridlayout(app.Grid1);
            app.Grid2.ColumnWidth = {24, 24, 53, 5, 24, 24, 5, 20, 5, 60, 300, 12, '1x', 110};
            app.Grid2.RowHeight = {'1x'};
            app.Grid2.ColumnSpacing = 5;
            app.Grid2.RowSpacing = 0;
            app.Grid2.Padding = [0 0 0 0];
            app.Grid2.Layout.Row = 1;
            app.Grid2.Layout.Column = 1;
            app.Grid2.BackgroundColor = [1 1 1];

            % Create HistogramVisibility
            app.HistogramVisibility = uiimage(app.Grid2);
            app.HistogramVisibility.ImageClickedFcn = createCallbackFcn(app, @LayoutPlotChanged, true);
            app.HistogramVisibility.Layout.Row = 1;
            app.HistogramVisibility.Layout.Column = 2;
            app.HistogramVisibility.ImageSource = 'DriveTest_Scatter_OFF.png';

            % Create Separator
            app.Separator = uiimage(app.Grid2);
            app.Separator.Enable = 'off';
            app.Separator.Layout.Row = 1;
            app.Separator.Layout.Column = 7;
            app.Separator.ImageSource = 'LT_LineV.png';

            % Create LocationLabel
            app.LocationLabel = uilabel(app.Grid2);
            app.LocationLabel.WordWrap = 'on';
            app.LocationLabel.FontSize = 10;
            app.LocationLabel.Layout.Row = 1;
            app.LocationLabel.Layout.Column = 10;
            app.LocationLabel.Text = 'Local monitoração:';

            % Create Location
            app.Location = uidropdown(app.Grid2);
            app.Location.Items = {};
            app.Location.ValueChangedFcn = createCallbackFcn(app, @LocationValueChanged, true);
            app.Location.Enable = 'off';
            app.Location.FontSize = 10;
            app.Location.BackgroundColor = [1 1 1];
            app.Location.Layout.Row = 1;
            app.Location.Layout.Column = 11;
            app.Location.Value = {};

            % Create LocationRefresh
            app.LocationRefresh = uiimage(app.Grid2);
            app.LocationRefresh.ImageClickedFcn = createCallbackFcn(app, @LocationRefreshClicked, true);
            app.LocationRefresh.Layout.Row = 1;
            app.LocationRefresh.Layout.Column = 12;
            app.LocationRefresh.ImageSource = 'LT_refresh.png';

            % Create ReleaseDate
            app.ReleaseDate = uilabel(app.Grid2);
            app.ReleaseDate.HorizontalAlignment = 'right';
            app.ReleaseDate.WordWrap = 'on';
            app.ReleaseDate.FontSize = 10;
            app.ReleaseDate.FontWeight = 'bold';
            app.ReleaseDate.Layout.Row = 1;
            app.ReleaseDate.Layout.Column = 14;
            app.ReleaseDate.Text = {'anateldb'; ' '};

            % Create Spinner
            app.Spinner = uispinner(app.Grid2);
            app.Spinner.Step = 0.1;
            app.Spinner.Limits = [-1 1];
            app.Spinner.ValueDisplayFormat = '%.1f';
            app.Spinner.ValueChangedFcn = createCallbackFcn(app, @LayoutRatioChanged, true);
            app.Spinner.FontSize = 10;
            app.Spinner.Layout.Row = 1;
            app.Spinner.Layout.Column = 3;
            app.Spinner.Value = 0.5;

            % Create Separator_3
            app.Separator_3 = uiimage(app.Grid2);
            app.Separator_3.Enable = 'off';
            app.Separator_3.Layout.Row = 1;
            app.Separator_3.Layout.Column = 9;
            app.Separator_3.ImageSource = 'LT_LineV.png';

            % Create Export_save
            app.Export_save = uiimage(app.Grid2);
            app.Export_save.ImageClickedFcn = createCallbackFcn(app, @Export_saveImageClicked, true);
            app.Export_save.Tooltip = {'Exportar planilha'};
            app.Export_save.Layout.Row = 1;
            app.Export_save.Layout.Column = 8;
            app.Export_save.ImageSource = 'LT_save.png';

            % Create TableVisibility
            app.TableVisibility = uiimage(app.Grid2);
            app.TableVisibility.ImageClickedFcn = createCallbackFcn(app, @LayoutPlotChanged, true);
            app.TableVisibility.Layout.Row = 1;
            app.TableVisibility.Layout.Column = 1;
            app.TableVisibility.ImageSource = 'DriveTest_Route_ON.png';

            % Create Separator_4
            app.Separator_4 = uiimage(app.Grid2);
            app.Separator_4.Enable = 'off';
            app.Separator_4.Layout.Row = 1;
            app.Separator_4.Layout.Column = 4;
            app.Separator_4.ImageSource = 'LT_LineV.png';

            % Create Zoom
            app.Zoom = uibutton(app.Grid2, 'state');
            app.Zoom.ValueChangedFcn = createCallbackFcn(app, @InteractionButtonPushed, true);
            app.Zoom.Enable = 'off';
            app.Zoom.Icon = 'LT_zoomInteraction.png';
            app.Zoom.IconAlignment = 'center';
            app.Zoom.Text = '';
            app.Zoom.BackgroundColor = [1 1 1];
            app.Zoom.Layout.Row = 1;
            app.Zoom.Layout.Column = 5;
            app.Zoom.Value = true;

            % Create Pan
            app.Pan = uibutton(app.Grid2, 'state');
            app.Pan.ValueChangedFcn = createCallbackFcn(app, @InteractionButtonPushed, true);
            app.Pan.Enable = 'off';
            app.Pan.Icon = 'LT_panInteraction.png';
            app.Pan.Text = '';
            app.Pan.BackgroundColor = [1 1 1];
            app.Pan.Layout.Row = 1;
            app.Pan.Layout.Column = 6;

            % Create Panel1
            app.Panel1 = uipanel(app.Grid1);
            app.Panel1.AutoResizeChildren = 'off';
            app.Panel1.BorderType = 'none';
            app.Panel1.BackgroundColor = [1 1 1];
            app.Panel1.Layout.Row = 2;
            app.Panel1.Layout.Column = 1;

            % Create Panel2
            app.Panel2 = uipanel(app.Grid1);
            app.Panel2.AutoResizeChildren = 'off';
            app.Panel2.BorderType = 'none';
            app.Panel2.BackgroundColor = [1 1 1];
            app.Panel2.Layout.Row = 3;
            app.Panel2.Layout.Column = 1;

            % Create ccTable
            app.ccTable = ccTools.Table(app.Grid1);
            app.ccTable.ColumnName = {'ID', 'Frequência|(MHz)', 'Latitude', 'Longitude', 'Descrição', 'Serviço', 'Estação', 'Classe', 'BW|(kHz)', 'Distância|(km)'};
            app.ccTable.ColumnEditable = [0 0 0 0 0 0 0 0 0 0];
            app.ccTable.ColumnWidth = {'40px', '70px', '70px', '70px', 'auto', '70px', '70px', '70px', '70px', '70px'};
            app.ccTable.ColumnAlign = {'center', 'right', 'right', 'right', 'left', 'center', 'right', 'center', 'right', 'right'};
            app.ccTable.ColumnPrecision = {'%s', '%.3f', '%.6f', '%.6f', '%s', '%d', '%d', '%s', '%.3f', '%.1f'};
            app.ccTable.hFontSize = 10;
            app.ccTable.bHoverColor = '#e2f0d9';
            app.ccTable.bSelectedColor = '#e2f0d9';
            app.ccTable.SelectionChangedFcn = createCallbackFcn(app, @ccTableSelectionChanged, true);
            app.ccTable.DataFilteredFcn = createCallbackFcn(app, @ccTableDataFiltered, true);
            app.ccTable.Layout.Row = 4;
            app.ccTable.Layout.Column = 1;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = winAnatelDB(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
