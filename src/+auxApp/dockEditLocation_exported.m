classdef dockEditLocation_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        GridLayout            matlab.ui.container.GridLayout
        Document              matlab.ui.container.GridLayout
        btnOK                 matlab.ui.control.Button
        rxLocationRefresh     matlab.ui.control.Image
        rxLocationPanel       matlab.ui.container.Panel
        rxLocationGrid        matlab.ui.container.GridLayout
        rxCity                matlab.ui.control.EditField
        rxCityLabel           matlab.ui.control.Label
        rxSearchCity          matlab.ui.control.Image
        rxHeight              matlab.ui.control.NumericEditField
        rxHeightLabel         matlab.ui.control.Label
        rxLongitude           matlab.ui.control.NumericEditField
        rxLongitudeLabel      matlab.ui.control.Label
        rxLatitude            matlab.ui.control.NumericEditField
        rxLatitudeLabel       matlab.ui.control.Label
        rxLocationPanelLabel  matlab.ui.control.Label
        btnClose              matlab.ui.control.Image
    end

    
    properties (Access = private)
        %-----------------------------------------------------------------%
        Container
        isDocked = true

        CallingApp
        specData
        referenceData
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        function initialValues(app, idxThreads)
            idxThread = idxThreads(1);

            app.referenceData = struct('idxThread', idxThreads,                                      ...
                                       'Status',    app.specData(idxThread).GPS.Status,              ...
                                       'Latitude',  round(app.specData(idxThread).GPS.Latitude,  6), ...
                                       'Longitude', round(app.specData(idxThread).GPS.Longitude, 6), ...
                                       'Height',    AntennaHeight(app.specData, idxThread, -1),      ...
                                       'Location',  app.specData(idxThread).GPS.Location);

            app.rxLatitude.Value  = app.referenceData.Latitude;
            app.rxLongitude.Value = app.referenceData.Longitude;
            app.rxHeight.Value    = app.referenceData.Height;
            app.rxCity.Value      = app.referenceData.Location;
        end

        %-----------------------------------------------------------------%
        function [editionFlag, gpsEditionFlag, heightEditionFlag] = checkEdition(app)
            gpsEditionFlag    = false;
            heightEditionFlag = false;

            if abs(app.rxLatitude.Value  - app.referenceData.Latitude)  > class.Constants.floatDiffTolerance || ...
               abs(app.rxLongitude.Value - app.referenceData.Longitude) > class.Constants.floatDiffTolerance || ...
               ~strcmp(app.rxCity.Value, app.referenceData.Location)
                gpsEditionFlag = true;
            end

            if (app.rxHeight.Value > 0) && (abs(app.rxHeight.Value - app.referenceData.Height) > class.Constants.floatDiffTolerance)
                heightEditionFlag = true;
            end

            editionFlag = gpsEditionFlag || heightEditionFlag;
        end

        %-----------------------------------------------------------------%
        function [PreviousEditionFlag, gpsPreviousEditionFlag, heightPreviousEditionFlag] = checkPreviousEdition(app, idxThreads)
            gpsPreviousEditionFlag    = false;
            heightPreviousEditionFlag = false;

            if app.referenceData.Status == -1
                gpsPreviousEditionFlag = true;
            end

            if any(arrayfun(@(x) ~isempty(x.UserData.AntennaHeight), app.specData(idxThreads)))
                heightPreviousEditionFlag = true;
            end

            PreviousEditionFlag = gpsPreviousEditionFlag || heightPreviousEditionFlag;
        end

        %-----------------------------------------------------------------%
        function CallingMainApp(app, updateFlag, returnFlag)
            appBackDoor(app.CallingApp, app, 'MISCELLANEOUS', updateFlag, returnFlag)
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

        % Callback function: rxCity, rxHeight, rxLatitude, 
        % ...and 3 other components
        function rxLocationValueChanged(app, event)
            
            switch event.Source
                %---------------------------------------------------------%
                case app.rxLatitude
                    focus(app.rxLongitude)

                %---------------------------------------------------------%
                case app.rxLongitude
                    focus(app.rxHeight)

                case app.rxHeight
                    focus(app.rxSearchCity)

                %---------------------------------------------------------%
                case app.rxSearchCity
                    refPoint = struct('Latitude',  app.rxLatitude.Value, ...
                                      'Longitude', app.rxLongitude.Value);
                    
                    app.CallingApp.progressDialog.Visible = 'visible';
                    [cityName, cityDistance, cityInfo] = gpsLib.findNearestCity(refPoint);
                    app.CallingApp.progressDialog.Visible = 'hidden';

                    if ~strcmp(cityName, app.rxCity.Value)        
                        msgQuestion   = sprintf(['%s retornou o município "%s" como a localidade mais próxima das '  ...
                                                 'coordenadas geográficas (%.6fº, %.6fº), cuja sede está a %.1f km ' ...
                                                 'de distância.<br><br>Deseja atualizar essa informação?!'], cityInfo.source, cityName, refPoint.Latitude, refPoint.Longitude, cityDistance);
                        userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
    
                        if userSelection == "Sim"
                            app.rxCity.Value = cityName;
                        end

                    else
                        msgWarning    = sprintf('%s retornou o município "%s", valor já inserido no campo "Município/UF"', cityInfo.source, cityName);
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    end

                %---------------------------------------------------------%
                case app.rxCity
                    app.rxCity.Value = strtrim(app.rxCity.Value);
                    [cityName, Latitude, Longitude] = gpsLib.findCityCoordinates(app.rxCity.Value);

                    if ~isempty(cityName)
                        app.rxCity.Value = cityName;

                        msgQuestion   = 'Deseja atualizar, além da localidade, as informações de Latitude e Longitude?';
                        userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);

                        if userSelection == "Sim"                            
                            app.rxLatitude.Value  = Latitude;
                            app.rxLongitude.Value = Longitude;
                        end                        
                        
                    else
                        app.rxCity.Value = event.PreviousValue;
                        
                        msgWarning    = sprintf(['Não encontrada em base do IBGE o município <b>"%s"</b>. Favor corrigir ' ...
                                                 'eventual erro na grafia, inserindo os acentos, no formato Município/UF.'], app.rxCity.Value);
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    end

                %---------------------------------------------------------%
                case app.rxLocationRefresh
                    idxThreads = app.referenceData.idxThread;
                    [PreviousEditionFlag, gpsPreviousEditionFlag, heightPreviousEditionFlag] = checkPreviousEdition(app, idxThreads);

                    if PreviousEditionFlag
                        if gpsPreviousEditionFlag
                            update(app.specData, 'GPS', 'Refresh', idxThreads)
                        end

                        if heightPreviousEditionFlag
                            update(app.specData, 'UserData:AntennaHeight', 'Refresh', idxThreads)
                        end
    
                        initialValues(app, idxThreads)
                        CallingMainApp(app, true, true)
                    end
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
            switch pushedButtonTag
                case 'OK'
                    [editionFlag, gpsEditionFlag, heightEditionFlag] = checkEdition(app);

                    if editionFlag
                        idxThreads = app.referenceData.idxThread;

                        % Latitude, Longitude e City
                        if gpsEditionFlag
                            newGPS = struct('Status', -1, 'Matrix', [app.rxLatitude.Value, app.rxLongitude.Value]);
                            newGPS = rmfield(gpsLib.summary(newGPS), 'Matrix');
                            newGPS.Location = app.rxCity.Value;
                            newGPS.Edited = true;

                            update(app.specData, 'GPS', 'ManualEdition', idxThreads, newGPS)
                        end

                        % AntennaHeight
                        if heightEditionFlag
                            newAntennaHeight = app.rxHeight.Value;
                            update(app.specData, 'UserData:AntennaHeight', 'ManualEdition', idxThreads, newAntennaHeight)
                        end
                    end

                    updateFlag = true;

                case 'Close'
                    updateFlag = false;
            end

            CallingMainApp(app, updateFlag, false)
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

            % Create rxLocationPanelLabel
            app.rxLocationPanelLabel = uilabel(app.Document);
            app.rxLocationPanelLabel.VerticalAlignment = 'bottom';
            app.rxLocationPanelLabel.FontSize = 10;
            app.rxLocationPanelLabel.Layout.Row = 1;
            app.rxLocationPanelLabel.Layout.Column = [1 2];
            app.rxLocationPanelLabel.Text = 'LOCAL DA MONITORAÇÃO';

            % Create rxLocationPanel
            app.rxLocationPanel = uipanel(app.Document);
            app.rxLocationPanel.AutoResizeChildren = 'off';
            app.rxLocationPanel.Layout.Row = 2;
            app.rxLocationPanel.Layout.Column = [1 4];

            % Create rxLocationGrid
            app.rxLocationGrid = uigridlayout(app.rxLocationPanel);
            app.rxLocationGrid.ColumnWidth = {'1x', '1x', '1x', 18};
            app.rxLocationGrid.RowHeight = {17, 22, 17, 22};
            app.rxLocationGrid.RowSpacing = 5;
            app.rxLocationGrid.Padding = [10 10 10 5];
            app.rxLocationGrid.BackgroundColor = [0.9804 0.9804 0.9804];

            % Create rxLatitudeLabel
            app.rxLatitudeLabel = uilabel(app.rxLocationGrid);
            app.rxLatitudeLabel.VerticalAlignment = 'bottom';
            app.rxLatitudeLabel.FontSize = 11;
            app.rxLatitudeLabel.Layout.Row = 1;
            app.rxLatitudeLabel.Layout.Column = 1;
            app.rxLatitudeLabel.Text = 'Latitude:';

            % Create rxLatitude
            app.rxLatitude = uieditfield(app.rxLocationGrid, 'numeric');
            app.rxLatitude.Limits = [-90 90];
            app.rxLatitude.ValueDisplayFormat = '%.6f';
            app.rxLatitude.ValueChangedFcn = createCallbackFcn(app, @rxLocationValueChanged, true);
            app.rxLatitude.FontSize = 11;
            app.rxLatitude.Layout.Row = 2;
            app.rxLatitude.Layout.Column = 1;
            app.rxLatitude.Value = -1;

            % Create rxLongitudeLabel
            app.rxLongitudeLabel = uilabel(app.rxLocationGrid);
            app.rxLongitudeLabel.VerticalAlignment = 'bottom';
            app.rxLongitudeLabel.FontSize = 11;
            app.rxLongitudeLabel.Layout.Row = 1;
            app.rxLongitudeLabel.Layout.Column = 2;
            app.rxLongitudeLabel.Text = 'Longitude:';

            % Create rxLongitude
            app.rxLongitude = uieditfield(app.rxLocationGrid, 'numeric');
            app.rxLongitude.Limits = [-180 180];
            app.rxLongitude.ValueDisplayFormat = '%.6f';
            app.rxLongitude.ValueChangedFcn = createCallbackFcn(app, @rxLocationValueChanged, true);
            app.rxLongitude.FontSize = 11;
            app.rxLongitude.Layout.Row = 2;
            app.rxLongitude.Layout.Column = 2;
            app.rxLongitude.Value = -1;

            % Create rxHeightLabel
            app.rxHeightLabel = uilabel(app.rxLocationGrid);
            app.rxHeightLabel.VerticalAlignment = 'bottom';
            app.rxHeightLabel.FontSize = 11;
            app.rxHeightLabel.Layout.Row = 1;
            app.rxHeightLabel.Layout.Column = 3;
            app.rxHeightLabel.Text = 'Altura (m):';

            % Create rxHeight
            app.rxHeight = uieditfield(app.rxLocationGrid, 'numeric');
            app.rxHeight.Limits = [-1 1000];
            app.rxHeight.ValueDisplayFormat = '%.1f';
            app.rxHeight.ValueChangedFcn = createCallbackFcn(app, @rxLocationValueChanged, true);
            app.rxHeight.FontSize = 11;
            app.rxHeight.Layout.Row = 2;
            app.rxHeight.Layout.Column = 3;
            app.rxHeight.Value = -1;

            % Create rxSearchCity
            app.rxSearchCity = uiimage(app.rxLocationGrid);
            app.rxSearchCity.ImageClickedFcn = createCallbackFcn(app, @rxLocationValueChanged, true);
            app.rxSearchCity.Tooltip = {'Consulta município'};
            app.rxSearchCity.Layout.Row = 2;
            app.rxSearchCity.Layout.Column = 4;
            app.rxSearchCity.ImageSource = 'Globo_32.png';

            % Create rxCityLabel
            app.rxCityLabel = uilabel(app.rxLocationGrid);
            app.rxCityLabel.VerticalAlignment = 'bottom';
            app.rxCityLabel.FontSize = 11;
            app.rxCityLabel.Layout.Row = 3;
            app.rxCityLabel.Layout.Column = 1;
            app.rxCityLabel.Text = 'Município/UF:';

            % Create rxCity
            app.rxCity = uieditfield(app.rxLocationGrid, 'text');
            app.rxCity.ValueChangedFcn = createCallbackFcn(app, @rxLocationValueChanged, true);
            app.rxCity.FontSize = 11;
            app.rxCity.Layout.Row = 4;
            app.rxCity.Layout.Column = [1 4];

            % Create rxLocationRefresh
            app.rxLocationRefresh = uiimage(app.Document);
            app.rxLocationRefresh.ImageClickedFcn = createCallbackFcn(app, @rxLocationValueChanged, true);
            app.rxLocationRefresh.Tooltip = {'Retorna às configurações iniciais'};
            app.rxLocationRefresh.Layout.Row = 3;
            app.rxLocationRefresh.Layout.Column = 1;
            app.rxLocationRefresh.ImageSource = 'Refresh_18.png';

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
        function app = dockEditLocation_exported(Container, varargin)

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
