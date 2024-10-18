classdef dockMisc_EditLocation_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        GridLayout             matlab.ui.container.GridLayout
        Document               matlab.ui.container.GridLayout
        btnOK                  matlab.ui.control.Button
        gpsRefresh             matlab.ui.control.Image
        gpsLocationPanel       matlab.ui.container.Panel
        gpsLocationGrid        matlab.ui.container.GridLayout
        gpsCity                matlab.ui.control.EditField
        gpsCityLabel           matlab.ui.control.Label
        gpsSearchCity          matlab.ui.control.Image
        gpsLongitude           matlab.ui.control.NumericEditField
        gpsLongitudeLabel      matlab.ui.control.Label
        gpsLatitude            matlab.ui.control.NumericEditField
        gpsLatitudeLabel       matlab.ui.control.Label
        gpsLocationPanelLabel  matlab.ui.control.Label
        btnClose               matlab.ui.control.Image
    end

    
    properties (Access = private)
        %-----------------------------------------------------------------%
        Container
        isDocked = true

        CallingApp
        specData
        initialGPS
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        function initialValues(app, idxThreads)
            idxThread = idxThreads(1);

            app.initialGPS = struct('idxThread', idxThreads,                                      ...
                                    'Status',    app.specData(idxThread).GPS.Status,              ...
                                    'Latitude',  round(app.specData(idxThread).GPS.Latitude,  6), ...
                                    'Longitude', round(app.specData(idxThread).GPS.Longitude, 6), ...
                                    'Location',  app.specData(idxThread).GPS.Location);

            app.gpsLatitude.Value  = app.initialGPS.Latitude;
            app.gpsLongitude.Value = app.initialGPS.Longitude;
            app.gpsCity.Value      = app.initialGPS.Location;
        end

        %-----------------------------------------------------------------%
        function editionFlag = checkEdition(app)
            if abs(app.gpsLatitude.Value  - app.initialGPS.Latitude)  > class.Constants.floatDiffTolerance || ...
               abs(app.gpsLongitude.Value - app.initialGPS.Longitude) > class.Constants.floatDiffTolerance || ...
               ~strcmp(app.gpsCity.Value, app.initialGPS.Location)

                editionFlag = true;
            else
                editionFlag = false;
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp, idxThreads)
            
            app.CallingApp = mainapp;
            app.specData   = mainapp.specData;

            initialValues(app, idxThreads)
            
        end

        % Close request function: UIFigure
        function closeFcn(app, event)
            
            delete(app)
            
        end

        % Callback function: gpsCity, gpsLatitude, gpsLongitude,
        % gpsRefresh, 
        % ...and 1 other component
        function gpsValueChanged(app, event)
            
            switch event.Source
                %---------------------------------------------------------%
                case app.gpsLatitude
                    focus(app.gpsLongitude)

                %---------------------------------------------------------%
                case app.gpsLongitude
                    focus(app.gpsSearchCity)

                %---------------------------------------------------------%
                case app.gpsSearchCity
                    gps = struct('Latitude',  app.gpsLatitude.Value, ...
                                 'Longitude', app.gpsLongitude.Value);
                    
                    app.CallingApp.progressDialog.Visible = 'visible';
                    [cityName, distValue_km, locInfo] = fcn.gpsFindCity(gps);
                    app.CallingApp.progressDialog.Visible = 'hidden';

                    if ~strcmp(cityName, app.gpsCity.Value)        
                        msgQuestion   = sprintf(['%s retornou o município "%s" como a localidade mais próxima das '  ...
                                                 'coordenadas geográficas (%.6fº, %.6fº), cuja sede está a %.1f km ' ...
                                                 'de distância.<br><br>Deseja atualizar essa informação?!'], locInfo.infoSource, cityName, gps.Latitude, gps.Longitude, distValue_km);
                        userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
    
                        if userSelection == "Sim"
                            app.gpsCity.Value = cityName;
                        end

                    else
                        msgWarning    = sprintf('%s retornou o município "%s", valor já inserido no campo "Município/UF"', locInfo.infoSource, cityName);
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    end

                %---------------------------------------------------------%
                case app.gpsCity
                    app.gpsCity.Value = strtrim(app.gpsCity.Value);
                    [cityName, Latitude, Longitude] = fcn.gpsFindCoordinates(app.gpsCity.Value);

                    if ~isempty(cityName)
                        msgQuestion   = 'Deseja atualizar, além da localidade, as informações de Latitude e Longitude?';
                        userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);

                        if userSelection == "Sim"
                            app.gpsCity.Value      = cityName;
                            app.gpsLatitude.Value  = Latitude;
                            app.gpsLongitude.Value = Longitude;
                        end
                        
                    else
                        app.gpsCity.Value = event.PreviousValue;
                        
                        msgWarning    = sprintf(['Não encontrada em base do IBGE o município <b>"%s"</b>. Favor corrigir ' ...
                                                 'eventual erro na grafia, inserindo os acentos, no formato Município/UF.'], app.gpsCity.Value);
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    end

                %---------------------------------------------------------%
                case app.gpsRefresh
                    idxThreads = app.initialGPS.idxThread;
                    if app.initialGPS.Status == -1
                        fcn.gpsProperty(app.specData, idxThreads)
                    end
                    initialValues(app, idxThreads)
                    appBackDoor(app.CallingApp, app, 'ButtonPushed', 'Refresh')
            end

            if checkEdition(app)
                app.btnOK.Enable = 1;
            else
                app.btnOK.Enable = 0;
            end
            
        end

        % Callback function: btnClose, btnOK
        function ButtonPushed(app, event)
            
            pushedButtonTag = event.Source.Tag;

            if pushedButtonTag == "OK"
                if checkEdition(app)
                    idxThreads = app.initialGPS.idxThread;

                    for ii = idxThreads                        
                        if app.initialGPS.Status ~= -1
                            app.specData(ii).GPS.Status = -1;
                        end
    
                        app.specData(ii).GPS.Latitude   = app.gpsLatitude.Value;
                        app.specData(ii).GPS.Longitude  = app.gpsLongitude.Value;
                        app.specData(ii).GPS.Location   = app.gpsCity.Value;
                        app.specData(ii).GPS.Edited     = true;
                    end
                end
            end

            appBackDoor(app.CallingApp, app, 'ButtonPushed', pushedButtonTag)
            closeFcn(app)

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
                app.UIFigure.Position = [100 100 360 210];
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
            app.GridLayout.ColumnWidth = {'1x', 30};
            app.GridLayout.RowHeight = {30, '1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.BackgroundColor = [0.902 0.902 0.902];

            % Create btnClose
            app.btnClose = uiimage(app.GridLayout);
            app.btnClose.ScaleMethod = 'none';
            app.btnClose.ImageClickedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.btnClose.Tag = 'Close';
            app.btnClose.Layout.Row = 1;
            app.btnClose.Layout.Column = 2;
            app.btnClose.ImageSource = 'Delete_12SVG.svg';

            % Create Document
            app.Document = uigridlayout(app.GridLayout);
            app.Document.ColumnWidth = {16, '1x', 69, 16};
            app.Document.RowHeight = {22, 110, 22};
            app.Document.ColumnSpacing = 5;
            app.Document.RowSpacing = 5;
            app.Document.Padding = [10 10 10 5];
            app.Document.Layout.Row = 2;
            app.Document.Layout.Column = [1 2];
            app.Document.BackgroundColor = [0.9804 0.9804 0.9804];

            % Create gpsLocationPanelLabel
            app.gpsLocationPanelLabel = uilabel(app.Document);
            app.gpsLocationPanelLabel.VerticalAlignment = 'bottom';
            app.gpsLocationPanelLabel.FontSize = 10;
            app.gpsLocationPanelLabel.Layout.Row = 1;
            app.gpsLocationPanelLabel.Layout.Column = [1 2];
            app.gpsLocationPanelLabel.Text = 'LOCAL DA MONITORAÇÃO';

            % Create gpsLocationPanel
            app.gpsLocationPanel = uipanel(app.Document);
            app.gpsLocationPanel.AutoResizeChildren = 'off';
            app.gpsLocationPanel.Layout.Row = 2;
            app.gpsLocationPanel.Layout.Column = [1 4];

            % Create gpsLocationGrid
            app.gpsLocationGrid = uigridlayout(app.gpsLocationPanel);
            app.gpsLocationGrid.ColumnWidth = {'1x', '1x', 18};
            app.gpsLocationGrid.RowHeight = {17, 22, 17, 22};
            app.gpsLocationGrid.RowSpacing = 5;
            app.gpsLocationGrid.Padding = [10 10 10 5];
            app.gpsLocationGrid.BackgroundColor = [0.9804 0.9804 0.9804];

            % Create gpsLatitudeLabel
            app.gpsLatitudeLabel = uilabel(app.gpsLocationGrid);
            app.gpsLatitudeLabel.VerticalAlignment = 'bottom';
            app.gpsLatitudeLabel.FontSize = 10;
            app.gpsLatitudeLabel.Layout.Row = 1;
            app.gpsLatitudeLabel.Layout.Column = 1;
            app.gpsLatitudeLabel.Text = 'Latitude:';

            % Create gpsLatitude
            app.gpsLatitude = uieditfield(app.gpsLocationGrid, 'numeric');
            app.gpsLatitude.Limits = [-90 90];
            app.gpsLatitude.ValueDisplayFormat = '%.6f';
            app.gpsLatitude.ValueChangedFcn = createCallbackFcn(app, @gpsValueChanged, true);
            app.gpsLatitude.FontSize = 11;
            app.gpsLatitude.Layout.Row = 2;
            app.gpsLatitude.Layout.Column = 1;
            app.gpsLatitude.Value = -1;

            % Create gpsLongitudeLabel
            app.gpsLongitudeLabel = uilabel(app.gpsLocationGrid);
            app.gpsLongitudeLabel.VerticalAlignment = 'bottom';
            app.gpsLongitudeLabel.FontSize = 10;
            app.gpsLongitudeLabel.Layout.Row = 1;
            app.gpsLongitudeLabel.Layout.Column = 2;
            app.gpsLongitudeLabel.Text = 'Longitude:';

            % Create gpsLongitude
            app.gpsLongitude = uieditfield(app.gpsLocationGrid, 'numeric');
            app.gpsLongitude.Limits = [-180 180];
            app.gpsLongitude.ValueDisplayFormat = '%.6f';
            app.gpsLongitude.ValueChangedFcn = createCallbackFcn(app, @gpsValueChanged, true);
            app.gpsLongitude.FontSize = 11;
            app.gpsLongitude.Layout.Row = 2;
            app.gpsLongitude.Layout.Column = 2;
            app.gpsLongitude.Value = -1;

            % Create gpsSearchCity
            app.gpsSearchCity = uiimage(app.gpsLocationGrid);
            app.gpsSearchCity.ImageClickedFcn = createCallbackFcn(app, @gpsValueChanged, true);
            app.gpsSearchCity.Tooltip = {'Consulta município'};
            app.gpsSearchCity.Layout.Row = 2;
            app.gpsSearchCity.Layout.Column = 3;
            app.gpsSearchCity.ImageSource = 'Globo_32.png';

            % Create gpsCityLabel
            app.gpsCityLabel = uilabel(app.gpsLocationGrid);
            app.gpsCityLabel.VerticalAlignment = 'bottom';
            app.gpsCityLabel.FontSize = 10;
            app.gpsCityLabel.Layout.Row = 3;
            app.gpsCityLabel.Layout.Column = 1;
            app.gpsCityLabel.Text = 'Município/UF:';

            % Create gpsCity
            app.gpsCity = uieditfield(app.gpsLocationGrid, 'text');
            app.gpsCity.ValueChangedFcn = createCallbackFcn(app, @gpsValueChanged, true);
            app.gpsCity.FontSize = 11;
            app.gpsCity.Layout.Row = 4;
            app.gpsCity.Layout.Column = [1 3];

            % Create gpsRefresh
            app.gpsRefresh = uiimage(app.Document);
            app.gpsRefresh.ImageClickedFcn = createCallbackFcn(app, @gpsValueChanged, true);
            app.gpsRefresh.Tooltip = {'Retorna às configurações iniciais'};
            app.gpsRefresh.Layout.Row = 3;
            app.gpsRefresh.Layout.Column = 1;
            app.gpsRefresh.ImageSource = 'Refresh_18.png';

            % Create btnOK
            app.btnOK = uibutton(app.Document, 'push');
            app.btnOK.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.btnOK.Tag = 'OK';
            app.btnOK.IconAlignment = 'right';
            app.btnOK.BackgroundColor = [0.9804 0.9804 0.9804];
            app.btnOK.Enable = 'off';
            app.btnOK.Layout.Row = 3;
            app.btnOK.Layout.Column = [3 4];
            app.btnOK.Text = 'OK';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dockMisc_EditLocation_exported(Container, varargin)

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
