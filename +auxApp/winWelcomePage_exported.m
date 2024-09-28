classdef winWelcomePage_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        GridLayout         matlab.ui.container.GridLayout
        btnClose           matlab.ui.control.Image
        releaseNotesPanel  matlab.ui.container.Panel
        releaseNotesGrid   matlab.ui.container.GridLayout
        releaseNotes       matlab.ui.control.HTML
        SimulationMode     matlab.ui.control.CheckBox
        btnConfigLabel     matlab.ui.control.Label
        btnConfig          matlab.ui.control.Image
        btnRFDataHubLabel  matlab.ui.control.Label
        btnRFDataHub       matlab.ui.control.Image
        btnOpenLabel       matlab.ui.control.Label
        btnOpen            matlab.ui.control.Image
        appTitle           matlab.ui.control.Label
    end

    
    properties (Access = private)
        Container
        isDocked = true
        CallingApp
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            
            app.CallingApp = mainapp;
            app.appTitle.Text = sprintf(['<p style="margin-right: 10px;"><font style="font-size: 18px; ' ...
                                         'color: #262626;"><b>appAnalise</b></font><br>%s (v. %s)</p>'], class.Constants.appRelease, class.Constants.appVersion);
            app.releaseNotes.HTMLSource = auxApp.welcomepage.htmlCode_ReleaseNotes;

        end

        % Close request function: UIFigure
        function closeFcn(app, event)
            
            delete(app)
            
        end

        % Image clicked function: btnClose, btnConfig, btnOpen, 
        % ...and 1 other component
        function ButtonPushed(app, event)
            
            pushedButtonTag = event.Source.Tag;
            simulationFlag  = app.SimulationMode.Value;
            appBackDoor(app.CallingApp, app, 'ButtonPushed', pushedButtonTag, simulationFlag)

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
                app.UIFigure.Position = [100 100 880 480];
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
            app.GridLayout.ColumnWidth = {5, 22, 38, '1x', 40, 240, 22, 5};
            app.GridLayout.RowHeight = {32, 44, 44, 44, 44, 140, '1x', 17, 22, 5};
            app.GridLayout.ColumnSpacing = 5;
            app.GridLayout.RowSpacing = 5;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.BackgroundColor = [1 1 1];

            % Create appTitle
            app.appTitle = uilabel(app.GridLayout);
            app.appTitle.VerticalAlignment = 'top';
            app.appTitle.FontSize = 9;
            app.appTitle.Layout.Row = 2;
            app.appTitle.Layout.Column = [3 4];
            app.appTitle.Interpreter = 'html';
            app.appTitle.Text = '<p style="margin-right: 10px;"><font style="font-size: 18px; color: #262626;"><b>appAnalise</b></font><br>R2024b (v. 1.80)</p>';

            % Create btnOpen
            app.btnOpen = uiimage(app.GridLayout);
            app.btnOpen.ScaleMethod = 'none';
            app.btnOpen.ImageClickedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.btnOpen.Tag = 'Open';
            app.btnOpen.Layout.Row = 3;
            app.btnOpen.Layout.Column = [3 4];
            app.btnOpen.HorizontalAlignment = 'left';
            app.btnOpen.ImageSource = 'Import_24.png';

            % Create btnOpenLabel
            app.btnOpenLabel = uilabel(app.GridLayout);
            app.btnOpenLabel.Layout.Row = 3;
            app.btnOpenLabel.Layout.Column = 4;
            app.btnOpenLabel.Interpreter = 'html';
            app.btnOpenLabel.Text = {'Arquivos'; '<p style="color: gray; font-size: 10px;">appColeta, Logger, CellWireless e Argus</p>'};

            % Create btnRFDataHub
            app.btnRFDataHub = uiimage(app.GridLayout);
            app.btnRFDataHub.ScaleMethod = 'none';
            app.btnRFDataHub.ImageClickedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.btnRFDataHub.Tag = 'RFDataHub';
            app.btnRFDataHub.Layout.Row = 4;
            app.btnRFDataHub.Layout.Column = [3 4];
            app.btnRFDataHub.HorizontalAlignment = 'left';
            app.btnRFDataHub.ImageSource = 'mosaic_32.png';

            % Create btnRFDataHubLabel
            app.btnRFDataHubLabel = uilabel(app.GridLayout);
            app.btnRFDataHubLabel.WordWrap = 'on';
            app.btnRFDataHubLabel.Layout.Row = 4;
            app.btnRFDataHubLabel.Layout.Column = 4;
            app.btnRFDataHubLabel.Interpreter = 'html';
            app.btnRFDataHubLabel.Text = {'RFDataHub'; '<p style="color: gray; font-size: 10px;">MOSAICO, STEL, SRD, ICAO, AISWEB, GEOAIS e REDEMET</p>'};

            % Create btnConfig
            app.btnConfig = uiimage(app.GridLayout);
            app.btnConfig.ScaleMethod = 'none';
            app.btnConfig.ImageClickedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.btnConfig.Tag = 'Config';
            app.btnConfig.Layout.Row = 5;
            app.btnConfig.Layout.Column = [3 4];
            app.btnConfig.HorizontalAlignment = 'left';
            app.btnConfig.ImageSource = 'Settings_32.png';

            % Create btnConfigLabel
            app.btnConfigLabel = uilabel(app.GridLayout);
            app.btnConfigLabel.Layout.Row = 5;
            app.btnConfigLabel.Layout.Column = 4;
            app.btnConfigLabel.Text = 'Configurações gerais';

            % Create SimulationMode
            app.SimulationMode = uicheckbox(app.GridLayout);
            app.SimulationMode.Text = 'Abre o app em modo de simulação.';
            app.SimulationMode.FontSize = 11;
            app.SimulationMode.FontColor = [0.149 0.149 0.149];
            app.SimulationMode.Layout.Row = [9 10];
            app.SimulationMode.Layout.Column = [2 4];

            % Create releaseNotesPanel
            app.releaseNotesPanel = uipanel(app.GridLayout);
            app.releaseNotesPanel.AutoResizeChildren = 'off';
            app.releaseNotesPanel.Layout.Row = [2 9];
            app.releaseNotesPanel.Layout.Column = [6 7];

            % Create releaseNotesGrid
            app.releaseNotesGrid = uigridlayout(app.releaseNotesPanel);
            app.releaseNotesGrid.ColumnWidth = {'1x'};
            app.releaseNotesGrid.RowHeight = {'1x'};
            app.releaseNotesGrid.Padding = [0 0 0 0];
            app.releaseNotesGrid.BackgroundColor = [1 1 1];

            % Create releaseNotes
            app.releaseNotes = uihtml(app.releaseNotesGrid);
            app.releaseNotes.Layout.Row = 1;
            app.releaseNotes.Layout.Column = 1;

            % Create btnClose
            app.btnClose = uiimage(app.GridLayout);
            app.btnClose.ScaleMethod = 'none';
            app.btnClose.ImageClickedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.btnClose.Tag = 'Close';
            app.btnClose.Layout.Row = 1;
            app.btnClose.Layout.Column = [7 8];
            app.btnClose.ImageSource = 'Delete_12SVG.svg';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = winWelcomePage_exported(Container, varargin)

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
