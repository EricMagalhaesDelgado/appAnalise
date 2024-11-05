classdef dockAddFiles_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure      matlab.ui.Figure
        GridLayout    matlab.ui.container.GridLayout
        Document      matlab.ui.container.GridLayout
        btnOK         matlab.ui.control.Button
        btnImport     matlab.ui.control.Image
        UITable       matlab.ui.control.Table
        UITableLabel  matlab.ui.control.Label
        btnClose      matlab.ui.control.Image
        Title         matlab.ui.control.Label
        ContextMenu   matlab.ui.container.ContextMenu
        btnDelete     matlab.ui.container.Menu
    end

    
    properties (Access = private)
        %-----------------------------------------------------------------%
        Container
        isDocked = true

        CallingApp
        General
        specData
        editionType
        editionFlag = false
    end
    

    methods (Access = private)
        %-----------------------------------------------------------------%        
        function initialValues(app)
            app.UITable.Data = getTable(app);
        end

        %-----------------------------------------------------------------%
        function srcTable = getTable(app)
            switch app.editionType
                case 'ProjectData'
                    srcTable = app.CallingApp.projectData.externalFiles;
                case 'SpectralData'
                    srcTable = app.specData.UserData.reportExternalFiles;
            end
            srcTable.isFile  = isfile(srcTable.Filename);
        end

        %-----------------------------------------------------------------%
        function setTable(app)
            switch app.editionType
                case 'ProjectData'
                    app.CallingApp.projectData.externalFiles  = app.UITable.Data(:, 1:4);
                case 'SpectralData'
                    app.specData.UserData.reportExternalFiles = app.UITable.Data(:, 1:4);
            end
            
            app.btnOK.Enable = 1;
            app.editionFlag  = true;
        end

        %-----------------------------------------------------------------%
        function addExternalFile(app, fileFullName, fileTypeID)
            for ii = 1:numel(fileFullName)
                switch fileTypeID
                    case 1; fileType = 'Image';
                    case 2; fileType = 'Table';
                end
                app.UITable.Data(end+1, :) = {fileType, '-1', fileFullName{ii}, -1, true};
                setTable(app)
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp, editionType, varargin)
            
            arguments
                app
                mainapp
                editionType char {mustBeMember(editionType, {'ProjectData', 'SpectralData'})}
            end

            arguments (Repeating)
                varargin
            end

            app.CallingApp  = mainapp;
            app.General     = mainapp.General;

            app.editionType = editionType;
            switch editionType
                case 'ProjectData'
                    app.Title.Text = '<font style="padding-left: 5px;">PROJETO</font>';
                case 'SpectralData'
                    app.Title.Text = '<font style="padding-left: 5px;">FLUXO A PROCESSAR SELECIONADO</font>';
                    app.specData = varargin{1};
            end

            initialValues(app)
            
        end

        % Close request function: UIFigure
        function closeFcn(app, event)
            
            delete(app)
            
        end

        % Image clicked function: btnImport
        function btnImportPushed(app, event)
            
            [fileName, filePath, fileIndexID] = uigetfile({'*.jpg;*.jpeg;*.png',              'Imagem (*.jpg, *.jpeg, *.png)';                 ...
                                                           '*.xls;*.xlsx;*.csv;*.txt;*.json', 'Tabela (*.xls, *.xlsx, *.csv, *.txt, *.json)'}, ...
                                                           '', app.General.fileFolder.lastVisited, 'MultiSelect', 'on');
            figure(app.UIFigure)

            if isequal(fileName, 0)
                return
            elseif ~iscell(fileName)
                fileName = {fileName};
            end

            app.General.fileFolder.lastVisited = filePath;
            addExternalFile(app, fullfile(filePath, fileName), fileIndexID)

        end

        % Callback function: btnClose, btnOK
        function btnOKAndClosePushed(app, event)
            
            updateFlag = app.editionFlag;
            returnFlag = false;

            appBackDoor(app.CallingApp, app, 'REPORT:EXTERNALFILES', updateFlag, returnFlag, app.editionType)
            closeFcn(app)

        end

        % Menu selected function: btnDelete
        function btnDeletePushed(app, event)
            
            idxRow = app.UITable.Selection;
            if ~isempty(idxRow)
                app.UITable.Data(idxRow, :) = [];
                setTable(app)
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
            app.GridLayout.ColumnWidth = {'1x', 30};
            app.GridLayout.RowHeight = {30, '1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.BackgroundColor = [0.902 0.902 0.902];

            % Create Title
            app.Title = uilabel(app.GridLayout);
            app.Title.FontSize = 11;
            app.Title.FontWeight = 'bold';
            app.Title.Layout.Row = 1;
            app.Title.Layout.Column = 1;
            app.Title.Interpreter = 'html';
            app.Title.Text = '<font style="padding-left: 5px;">PROJETO</font>';

            % Create btnClose
            app.btnClose = uiimage(app.GridLayout);
            app.btnClose.ScaleMethod = 'none';
            app.btnClose.ImageClickedFcn = createCallbackFcn(app, @btnOKAndClosePushed, true);
            app.btnClose.Tag = 'Close';
            app.btnClose.Layout.Row = 1;
            app.btnClose.Layout.Column = 2;
            app.btnClose.ImageSource = 'Delete_12SVG.svg';

            % Create Document
            app.Document = uigridlayout(app.GridLayout);
            app.Document.ColumnWidth = {22, '1x', 90};
            app.Document.RowHeight = {22, '1x', 22};
            app.Document.ColumnSpacing = 5;
            app.Document.RowSpacing = 5;
            app.Document.Padding = [10 10 10 5];
            app.Document.Layout.Row = 2;
            app.Document.Layout.Column = [1 2];
            app.Document.BackgroundColor = [0.9804 0.9804 0.9804];

            % Create UITableLabel
            app.UITableLabel = uilabel(app.Document);
            app.UITableLabel.VerticalAlignment = 'bottom';
            app.UITableLabel.FontSize = 10;
            app.UITableLabel.Layout.Row = 1;
            app.UITableLabel.Layout.Column = [1 3];
            app.UITableLabel.Text = 'MAPEAMENTO DE ARQUIVOS EXTERNOS';

            % Create UITable
            app.UITable = uitable(app.Document);
            app.UITable.ColumnName = {'TIPO'; 'TAG'; 'ARQUIVO'; 'ID'; 'SITUAÇÃO'};
            app.UITable.ColumnWidth = {70, 100, 'auto', 70, 70};
            app.UITable.RowName = {};
            app.UITable.SelectionType = 'row';
            app.UITable.ColumnEditable = [false true false true false];
            app.UITable.Layout.Row = 2;
            app.UITable.Layout.Column = [1 3];
            app.UITable.FontSize = 11;

            % Create btnImport
            app.btnImport = uiimage(app.Document);
            app.btnImport.ScaleMethod = 'none';
            app.btnImport.ImageClickedFcn = createCallbackFcn(app, @btnImportPushed, true);
            app.btnImport.Layout.Row = 3;
            app.btnImport.Layout.Column = 1;
            app.btnImport.ImageSource = 'Import_16.png';

            % Create btnOK
            app.btnOK = uibutton(app.Document, 'push');
            app.btnOK.ButtonPushedFcn = createCallbackFcn(app, @btnOKAndClosePushed, true);
            app.btnOK.Tag = 'OK';
            app.btnOK.IconAlignment = 'right';
            app.btnOK.BackgroundColor = [0.9804 0.9804 0.9804];
            app.btnOK.Enable = 'off';
            app.btnOK.Layout.Row = 3;
            app.btnOK.Layout.Column = 3;
            app.btnOK.Text = 'OK';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.UIFigure);

            % Create btnDelete
            app.btnDelete = uimenu(app.ContextMenu);
            app.btnDelete.MenuSelectedFcn = createCallbackFcn(app, @btnDeletePushed, true);
            app.btnDelete.Text = 'Deletar';
            
            % Assign app.ContextMenu
            app.UITable.ContextMenu = app.ContextMenu;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dockAddFiles_exported(Container, varargin)

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
