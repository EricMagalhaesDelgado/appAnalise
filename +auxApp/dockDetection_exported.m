classdef dockDetection_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        GridLayout               matlab.ui.container.GridLayout
        fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel  matlab.ui.control.Label
        Document                 matlab.ui.container.GridLayout
        Algorithm                matlab.ui.control.DropDown
        AlgorithmLabel           matlab.ui.control.Label
        btnOK                    matlab.ui.control.Button
        ParametersPanel          matlab.ui.container.Panel
        ParametersGrid           matlab.ui.container.GridLayout
        MeanPanel                matlab.ui.container.Panel
        MeanGrid                 matlab.ui.container.GridLayout
        Prominence1              matlab.ui.control.Spinner
        Prominence1Label         matlab.ui.control.Label
        MaxHoldPanel             matlab.ui.container.Panel
        MaxHoldGrid              matlab.ui.container.GridLayout
        maxOCC                   matlab.ui.control.Spinner
        play_FindPeaks_OCCLabel  matlab.ui.control.Label
        meanOCC                  matlab.ui.control.Spinner
        Prominence2              matlab.ui.control.Spinner
        Prominence2Label         matlab.ui.control.Label
        BW                       matlab.ui.control.Spinner
        BWLabel                  matlab.ui.control.Label
        Distance                 matlab.ui.control.Spinner
        DistanceLabel            matlab.ui.control.Label
        FindPeaksClass           matlab.ui.control.DropDown
        FindPeaksClassLabel      matlab.ui.control.Label
        Prominence               matlab.ui.control.Spinner
        ProminenceLabel          matlab.ui.control.Label
        THR                      matlab.ui.control.Spinner
        THRLabel                 matlab.ui.control.Label
        NPeaks                   matlab.ui.control.Spinner
        NPeaksLabel              matlab.ui.control.Label
        Trace                    matlab.ui.control.DropDown
        TraceLabel               matlab.ui.control.Label
        btnClose                 matlab.ui.control.Image
    end

    
    properties (Access = private)
        %-----------------------------------------------------------------%
        Container
        isDocked = true

        CallingApp
        specData
        channelObj
    end
    
    
    methods (Access = private)
        %-----------------------------------------------------------------%
        function initivalValues(app)
            idxThread = app.CallingApp.play_PlotPanel.UserData.NodeData;
            
            app.Algorithm.Value  = app.specData(idxThread).UserData.reportDetection.Algorithm;
            Layout(app)

            switch app.Algorithm.Value
                case 'FindPeaks'
                    app.Trace.Value          = app.specData(idxThread).UserData.reportDetection.Parameters.Fcn;
                    app.NPeaks.Value         = app.specData(idxThread).UserData.reportDetection.Parameters.NPeaks;
                    app.THR.Value            = app.specData(idxThread).UserData.reportDetection.Parameters.THR;
                    app.Prominence.Value     = app.specData(idxThread).UserData.reportDetection.Parameters.Prominence;
                    app.Distance.Value       = app.specData(idxThread).UserData.reportDetection.Parameters.Distance;
                    app.BW.Value             = app.specData(idxThread).UserData.reportDetection.Parameters.BW;

                case 'FindPeaks+OCC'
                    set(app.FindPeaksClass, 'Items', [{''}; app.channelObj.FindPeaks.Name], 'Value', '')
                    app.Distance.Value       = app.specData(idxThread).UserData.reportDetection.Parameters.Distance;
                    app.BW.Value             = app.specData(idxThread).UserData.reportDetection.Parameters.BW;
                    app.Prominence1.Value    = app.specData(idxThread).UserData.reportDetection.Parameters.Prominence1;
                    app.Prominence2.Value    = app.specData(idxThread).UserData.reportDetection.Parameters.Prominence2;
                    app.meanOCC.Value        = app.specData(idxThread).UserData.reportDetection.Parameters.meanOCC;
                    app.maxOCC.Value         = app.specData(idxThread).UserData.reportDetection.Parameters.maxOCC;
            end
        end

        %-----------------------------------------------------------------%
        function Layout(app)
            switch app.Algorithm.Value
                case 'FindPeaks'
                    app.ParametersGrid.RowHeight([1 2 5]) = {25,22,0};
                    
                    app.ProminenceLabel.Visible     = 1;
                    app.Prominence.Visible          = 1;
                    app.FindPeaksClassLabel.Visible = 0;
                    app.FindPeaksClass.Visible      = 0;

                case 'FindPeaks+OCC'
                    app.ParametersGrid.RowHeight([1 2 5]) = {0,0,87};

                    app.ProminenceLabel.Visible     = 0;
                    app.Prominence.Visible          = 0;
                    app.FindPeaksClassLabel.Visible = 1;
                    app.FindPeaksClass.Visible      = 1;
            end
        end

        %-----------------------------------------------------------------%
        function editionFlag = checkEdition(app)
            editionFlag = false;

            idxThread = app.CallingApp.play_PlotPanel.UserData.NodeData;
            if ~isequal(app.Algorithm.Value, app.specData(idxThread).UserData.reportDetection.Algorithm)
                editionFlag = true;

            else
                switch app.Algorithm.Value
                    case 'FindPeaks'
                        if ~isequal(app.Trace.Value,       app.specData(idxThread).UserData.reportDetection.Parameters.Fcn)        || ...
                           ~isequal(app.NPeaks.Value,      app.specData(idxThread).UserData.reportDetection.Parameters.NPeaks)     || ...
                           ~isequal(app.THR.Value,         app.specData(idxThread).UserData.reportDetection.Parameters.THR)        || ...
                           ~isequal(app.Prominence.Value,  app.specData(idxThread).UserData.reportDetection.Parameters.Prominence) || ...
                           ~isequal(app.Distance.Value,    app.specData(idxThread).UserData.reportDetection.Parameters.Distance)   || ...
                           ~isequal(app.BW.Value,          app.specData(idxThread).UserData.reportDetection.Parameters.BW)
                            
                            editionFlag = true;
                        end

                    case 'FindPeaks+OCC'
                        if ~isequal(app.Distance.Value,    app.specData(idxThread).UserData.reportDetection.Parameters.Distance)    || ...
                           ~isequal(app.BW.Value,          app.specData(idxThread).UserData.reportDetection.Parameters.BW)          || ...
                           ~isequal(app.Prominence1.Value, app.specData(idxThread).UserData.reportDetection.Parameters.Prominence1) || ...
                           ~isequal(app.Prominence2.Value, app.specData(idxThread).UserData.reportDetection.Parameters.Prominence2) || ...
                           ~isequal(app.meanOCC.Value,     app.specData(idxThread).UserData.reportDetection.Parameters.meanOCC)     || ...
                           ~isequal(app.maxOCC.Value,      app.specData(idxThread).UserData.reportDetection.Parameters.maxOCC)
                            
                            editionFlag = true;
                        end
                end
            end
        end

        %-----------------------------------------------------------------%
        function CallingMainApp(app, updateFlag, returnFlag, idxThread)
            appBackDoor(app.CallingApp, app, 'REPORT', updateFlag, returnFlag, idxThread)
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            
            app.CallingApp = mainapp;
            app.specData   = mainapp.specData;
            app.channelObj = mainapp.channelObj;

            initivalValues(app)
            
        end

        % Close request function: UIFigure
        function closeFcn(app, event)
            
            delete(app)
            
        end

        % Value changed function: Algorithm
        function AlgorithmValueChanged(app, event)
            
            Layout(app)
            ParameterValueChanged(app)

        end

        % Value changed function: FindPeaksClass
        function FindPeaksClassValueChanged(app, event)
            
            if ~isempty(app.FindPeaksClass.Value)
                [~, idxFindPeaks] = ismember(app.FindPeaksClass.Value, app.channelObj.FindPeaks.Name);

                if idxFindPeaks    
                    app.Distance.Value    = 1000 * app.channelObj.FindPeaks.Distance(idxFindPeaks);
                    app.BW.Value          = 1000 * app.channelObj.FindPeaks.BW(idxFindPeaks);
                    app.Prominence1.Value = app.channelObj.FindPeaks.Prominence1(idxFindPeaks);
                    app.Prominence2.Value = app.channelObj.FindPeaks.Prominence2(idxFindPeaks);
                    app.meanOCC.Value     = app.channelObj.FindPeaks.meanOCC(idxFindPeaks);
                    app.maxOCC.Value      = app.channelObj.FindPeaks.maxOCC(idxFindPeaks);
    
                    ParameterValueChanged(app)
                end
            end

        end

        % Value changed function: maxOCC, meanOCC
        function occValueChanged(app, event)
            
            switch event.Source
                case app.meanOCC
                    if app.meanOCC.Value > app.maxOCC.Value
                        app.maxOCC.Value = app.meanOCC.Value;
                    end
                case app.maxOCC
                    if app.maxOCC.Value < app.meanOCC.Value
                        app.meanOCC.Value = app.maxOCC.Value;
                    end
            end
            ParameterValueChanged(app)

        end

        % Value changed function: BW, Distance, NPeaks, Prominence, 
        % ...and 4 other components
        function ParameterValueChanged(app, event)
            
            if checkEdition(app)
                app.btnOK.Enable = 1;
            else
                app.btnOK.Enable = 0;
            end

        end

        % Callback function: btnClose, btnOK
        function ButtonPushed(app, event)
            
            idxThread = app.CallingApp.play_PlotPanel.UserData.NodeData;
            
            pushedButtonTag = event.Source.Tag;
            switch pushedButtonTag
                case 'OK'
                    app.specData(idxThread).UserData.reportDetection.Algorithm = app.Algorithm.Value;
                    switch app.Algorithm.Value
                        case 'FindPeaks'
                            app.specData(idxThread).UserData.reportDetection.Parameters = struct('Fcn',        app.Trace.Value,        ...
                                                                                                 'NPeaks',     app.NPeaks.Value,       ...
                                                                                                 'THR',        app.THR.Value,          ...
                                                                                                 'Prominence', app.Prominence.Value,   ...
                                                                                                 'Distance',   app.Distance.Value,     ...
                                                                                                 'BW',         app.BW.Value);
                        case 'FindPeaks+OCC'
                            app.specData(idxThread).UserData.reportDetection.Parameters = struct('Distance',    app.Distance.Value,    ...
                                                                                                 'BW',          app.BW.Value,          ...
                                                                                                 'Prominence1', app.Prominence1.Value, ...
                                                                                                 'Prominence2', app.Prominence2.Value, ...
                                                                                                 'meanOCC',     app.meanOCC.Value,     ...
                                                                                                 'maxOCC',      app.maxOCC.Value);
                    end

                    updateFlag = true;

                case 'Close'
                    updateFlag = false;
            end

            CallingMainApp(app, updateFlag, false, idxThread)
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
                app.UIFigure.Position = [100 100 412 282];
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
            app.Document.ColumnWidth = {92, 200, 63, 22};
            app.Document.RowHeight = {17, 22, 161, 22};
            app.Document.ColumnSpacing = 5;
            app.Document.RowSpacing = 5;
            app.Document.Padding = [10 10 10 5];
            app.Document.Layout.Row = 2;
            app.Document.Layout.Column = [1 2];
            app.Document.BackgroundColor = [0.9804 0.9804 0.9804];

            % Create ParametersPanel
            app.ParametersPanel = uipanel(app.Document);
            app.ParametersPanel.Layout.Row = 3;
            app.ParametersPanel.Layout.Column = [1 4];

            % Create ParametersGrid
            app.ParametersGrid = uigridlayout(app.ParametersPanel);
            app.ParametersGrid.ColumnWidth = {130, 110, 110};
            app.ParametersGrid.RowHeight = {0, 0, 25, 22, 87};
            app.ParametersGrid.RowSpacing = 5;
            app.ParametersGrid.Padding = [10 10 10 5];
            app.ParametersGrid.BackgroundColor = [0.9804 0.9804 0.9804];

            % Create TraceLabel
            app.TraceLabel = uilabel(app.ParametersGrid);
            app.TraceLabel.VerticalAlignment = 'bottom';
            app.TraceLabel.FontSize = 10;
            app.TraceLabel.Layout.Row = 1;
            app.TraceLabel.Layout.Column = 1;
            app.TraceLabel.Text = {'Tipo de '; 'traço:'};

            % Create Trace
            app.Trace = uidropdown(app.ParametersGrid);
            app.Trace.Items = {'MinHold', 'Média', 'MaxHold'};
            app.Trace.ValueChangedFcn = createCallbackFcn(app, @ParameterValueChanged, true);
            app.Trace.FontSize = 10;
            app.Trace.BackgroundColor = [1 1 1];
            app.Trace.Layout.Row = 2;
            app.Trace.Layout.Column = 1;
            app.Trace.Value = 'Média';

            % Create NPeaksLabel
            app.NPeaksLabel = uilabel(app.ParametersGrid);
            app.NPeaksLabel.VerticalAlignment = 'bottom';
            app.NPeaksLabel.FontSize = 10;
            app.NPeaksLabel.Layout.Row = 1;
            app.NPeaksLabel.Layout.Column = 2;
            app.NPeaksLabel.Text = {'Número de '; 'picos:'};

            % Create NPeaks
            app.NPeaks = uispinner(app.ParametersGrid);
            app.NPeaks.Limits = [1 100];
            app.NPeaks.RoundFractionalValues = 'on';
            app.NPeaks.ValueDisplayFormat = '%.0f';
            app.NPeaks.ValueChangedFcn = createCallbackFcn(app, @ParameterValueChanged, true);
            app.NPeaks.FontSize = 10;
            app.NPeaks.Layout.Row = 2;
            app.NPeaks.Layout.Column = 2;
            app.NPeaks.Value = 10;

            % Create THRLabel
            app.THRLabel = uilabel(app.ParametersGrid);
            app.THRLabel.VerticalAlignment = 'bottom';
            app.THRLabel.FontSize = 10;
            app.THRLabel.Layout.Row = 1;
            app.THRLabel.Layout.Column = 3;
            app.THRLabel.Text = {'Threshold'; '(dB):'};

            % Create THR
            app.THR = uispinner(app.ParametersGrid);
            app.THR.Step = 10;
            app.THR.RoundFractionalValues = 'on';
            app.THR.ValueDisplayFormat = '%.0f';
            app.THR.ValueChangedFcn = createCallbackFcn(app, @ParameterValueChanged, true);
            app.THR.FontSize = 10;
            app.THR.Layout.Row = 2;
            app.THR.Layout.Column = 3;
            app.THR.Value = -Inf;

            % Create ProminenceLabel
            app.ProminenceLabel = uilabel(app.ParametersGrid);
            app.ProminenceLabel.VerticalAlignment = 'bottom';
            app.ProminenceLabel.WordWrap = 'on';
            app.ProminenceLabel.FontSize = 10;
            app.ProminenceLabel.Visible = 'off';
            app.ProminenceLabel.Layout.Row = 3;
            app.ProminenceLabel.Layout.Column = 1;
            app.ProminenceLabel.Text = {'Proeminência '; '(dB):'};

            % Create Prominence
            app.Prominence = uispinner(app.ParametersGrid);
            app.Prominence.Step = 10;
            app.Prominence.Limits = [1 Inf];
            app.Prominence.RoundFractionalValues = 'on';
            app.Prominence.ValueDisplayFormat = '%.0f';
            app.Prominence.ValueChangedFcn = createCallbackFcn(app, @ParameterValueChanged, true);
            app.Prominence.FontSize = 10;
            app.Prominence.Visible = 'off';
            app.Prominence.Layout.Row = 4;
            app.Prominence.Layout.Column = 1;
            app.Prominence.Value = 30;

            % Create FindPeaksClassLabel
            app.FindPeaksClassLabel = uilabel(app.ParametersGrid);
            app.FindPeaksClassLabel.VerticalAlignment = 'bottom';
            app.FindPeaksClassLabel.FontSize = 10;
            app.FindPeaksClassLabel.Layout.Row = 3;
            app.FindPeaksClassLabel.Layout.Column = 1;
            app.FindPeaksClassLabel.Text = {'Classe de '; 'emissão:'};

            % Create FindPeaksClass
            app.FindPeaksClass = uidropdown(app.ParametersGrid);
            app.FindPeaksClass.Items = {};
            app.FindPeaksClass.ValueChangedFcn = createCallbackFcn(app, @FindPeaksClassValueChanged, true);
            app.FindPeaksClass.FontSize = 10;
            app.FindPeaksClass.BackgroundColor = [1 1 1];
            app.FindPeaksClass.Layout.Row = 4;
            app.FindPeaksClass.Layout.Column = 1;
            app.FindPeaksClass.Value = {};

            % Create DistanceLabel
            app.DistanceLabel = uilabel(app.ParametersGrid);
            app.DistanceLabel.VerticalAlignment = 'bottom';
            app.DistanceLabel.WordWrap = 'on';
            app.DistanceLabel.FontSize = 10;
            app.DistanceLabel.Layout.Row = 3;
            app.DistanceLabel.Layout.Column = 2;
            app.DistanceLabel.Text = {'Distância entre'; 'picos (kHz):'};

            % Create Distance
            app.Distance = uispinner(app.ParametersGrid);
            app.Distance.Step = 25;
            app.Distance.Limits = [0 Inf];
            app.Distance.RoundFractionalValues = 'on';
            app.Distance.ValueDisplayFormat = '%.0f';
            app.Distance.ValueChangedFcn = createCallbackFcn(app, @ParameterValueChanged, true);
            app.Distance.FontSize = 10;
            app.Distance.Layout.Row = 4;
            app.Distance.Layout.Column = 2;
            app.Distance.Value = 25;

            % Create BWLabel
            app.BWLabel = uilabel(app.ParametersGrid);
            app.BWLabel.VerticalAlignment = 'bottom';
            app.BWLabel.WordWrap = 'on';
            app.BWLabel.FontSize = 10;
            app.BWLabel.Layout.Row = 3;
            app.BWLabel.Layout.Column = 3;
            app.BWLabel.Text = {'Largura ocupada '; '(kHz):'};

            % Create BW
            app.BW = uispinner(app.ParametersGrid);
            app.BW.Step = 10;
            app.BW.Limits = [0 Inf];
            app.BW.RoundFractionalValues = 'on';
            app.BW.ValueDisplayFormat = '%.0f';
            app.BW.ValueChangedFcn = createCallbackFcn(app, @ParameterValueChanged, true);
            app.BW.FontSize = 10;
            app.BW.Layout.Row = 4;
            app.BW.Layout.Column = 3;
            app.BW.Value = 10;

            % Create MaxHoldPanel
            app.MaxHoldPanel = uipanel(app.ParametersGrid);
            app.MaxHoldPanel.Title = 'MAXHOLD';
            app.MaxHoldPanel.Layout.Row = 5;
            app.MaxHoldPanel.Layout.Column = [2 3];
            app.MaxHoldPanel.FontSize = 10;

            % Create MaxHoldGrid
            app.MaxHoldGrid = uigridlayout(app.MaxHoldPanel);
            app.MaxHoldGrid.ColumnWidth = {60, 10, 68, 5, 67};
            app.MaxHoldGrid.RowHeight = {27, 22};
            app.MaxHoldGrid.ColumnSpacing = 0;
            app.MaxHoldGrid.RowSpacing = 5;
            app.MaxHoldGrid.Padding = [10 10 8 5];
            app.MaxHoldGrid.BackgroundColor = [0.9804 0.9804 0.9804];

            % Create Prominence2Label
            app.Prominence2Label = uilabel(app.MaxHoldGrid);
            app.Prominence2Label.VerticalAlignment = 'bottom';
            app.Prominence2Label.WordWrap = 'on';
            app.Prominence2Label.FontSize = 10;
            app.Prominence2Label.Layout.Row = 1;
            app.Prominence2Label.Layout.Column = [1 5];
            app.Prominence2Label.Text = {'Proeminência'; '(dB):'};

            % Create Prominence2
            app.Prominence2 = uispinner(app.MaxHoldGrid);
            app.Prominence2.Step = 10;
            app.Prominence2.Limits = [1 Inf];
            app.Prominence2.RoundFractionalValues = 'on';
            app.Prominence2.ValueDisplayFormat = '%.0f';
            app.Prominence2.ValueChangedFcn = createCallbackFcn(app, @ParameterValueChanged, true);
            app.Prominence2.FontSize = 10;
            app.Prominence2.Layout.Row = 2;
            app.Prominence2.Layout.Column = 1;
            app.Prominence2.Value = 30;

            % Create meanOCC
            app.meanOCC = uispinner(app.MaxHoldGrid);
            app.meanOCC.Step = 10;
            app.meanOCC.Limits = [0 100];
            app.meanOCC.RoundFractionalValues = 'on';
            app.meanOCC.ValueDisplayFormat = '%.0f';
            app.meanOCC.ValueChangedFcn = createCallbackFcn(app, @occValueChanged, true);
            app.meanOCC.FontSize = 10;
            app.meanOCC.Layout.Row = 2;
            app.meanOCC.Layout.Column = 3;
            app.meanOCC.Value = 1;

            % Create play_FindPeaks_OCCLabel
            app.play_FindPeaks_OCCLabel = uilabel(app.MaxHoldGrid);
            app.play_FindPeaks_OCCLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_OCCLabel.FontSize = 10;
            app.play_FindPeaks_OCCLabel.Layout.Row = 1;
            app.play_FindPeaks_OCCLabel.Layout.Column = [3 5];
            app.play_FindPeaks_OCCLabel.Interpreter = 'html';
            app.play_FindPeaks_OCCLabel.Text = {'Ocupação (%):'; '<p style="line-height:10px; font-size:9px; color:gray;">(Mínima | Máxima)</p>'};

            % Create maxOCC
            app.maxOCC = uispinner(app.MaxHoldGrid);
            app.maxOCC.Step = 10;
            app.maxOCC.Limits = [0 100];
            app.maxOCC.RoundFractionalValues = 'on';
            app.maxOCC.ValueDisplayFormat = '%.0f';
            app.maxOCC.ValueChangedFcn = createCallbackFcn(app, @occValueChanged, true);
            app.maxOCC.FontSize = 10;
            app.maxOCC.Layout.Row = 2;
            app.maxOCC.Layout.Column = 5;
            app.maxOCC.Value = 10;

            % Create MeanPanel
            app.MeanPanel = uipanel(app.ParametersGrid);
            app.MeanPanel.Title = 'MÉDIA';
            app.MeanPanel.Layout.Row = 5;
            app.MeanPanel.Layout.Column = 1;
            app.MeanPanel.FontSize = 10;

            % Create MeanGrid
            app.MeanGrid = uigridlayout(app.MeanPanel);
            app.MeanGrid.ColumnWidth = {108};
            app.MeanGrid.RowHeight = {27, 22};
            app.MeanGrid.RowSpacing = 5;
            app.MeanGrid.Padding = [10 10 10 5];
            app.MeanGrid.BackgroundColor = [0.9804 0.9804 0.9804];

            % Create Prominence1Label
            app.Prominence1Label = uilabel(app.MeanGrid);
            app.Prominence1Label.VerticalAlignment = 'bottom';
            app.Prominence1Label.WordWrap = 'on';
            app.Prominence1Label.FontSize = 10;
            app.Prominence1Label.Layout.Row = 1;
            app.Prominence1Label.Layout.Column = 1;
            app.Prominence1Label.Text = {'Proeminência'; '(dB):'};

            % Create Prominence1
            app.Prominence1 = uispinner(app.MeanGrid);
            app.Prominence1.Step = 10;
            app.Prominence1.Limits = [1 Inf];
            app.Prominence1.RoundFractionalValues = 'on';
            app.Prominence1.ValueDisplayFormat = '%.0f';
            app.Prominence1.ValueChangedFcn = createCallbackFcn(app, @ParameterValueChanged, true);
            app.Prominence1.FontSize = 10;
            app.Prominence1.Layout.Row = 2;
            app.Prominence1.Layout.Column = 1;
            app.Prominence1.Value = 10;

            % Create btnOK
            app.btnOK = uibutton(app.Document, 'push');
            app.btnOK.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.btnOK.Tag = 'OK';
            app.btnOK.IconAlignment = 'right';
            app.btnOK.BackgroundColor = [0.9804 0.9804 0.9804];
            app.btnOK.Enable = 'off';
            app.btnOK.Layout.Row = 4;
            app.btnOK.Layout.Column = [3 4];
            app.btnOK.Text = 'OK';

            % Create AlgorithmLabel
            app.AlgorithmLabel = uilabel(app.Document);
            app.AlgorithmLabel.VerticalAlignment = 'bottom';
            app.AlgorithmLabel.FontSize = 10;
            app.AlgorithmLabel.Layout.Row = 1;
            app.AlgorithmLabel.Layout.Column = 1;
            app.AlgorithmLabel.Text = 'Algoritmo:';

            % Create Algorithm
            app.Algorithm = uidropdown(app.Document);
            app.Algorithm.Items = {'FindPeaks', 'FindPeaks+OCC'};
            app.Algorithm.ValueChangedFcn = createCallbackFcn(app, @AlgorithmValueChanged, true);
            app.Algorithm.FontSize = 10;
            app.Algorithm.BackgroundColor = [1 1 1];
            app.Algorithm.Layout.Row = 2;
            app.Algorithm.Layout.Column = [1 4];
            app.Algorithm.Value = 'FindPeaks';

            % Create fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel
            app.fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel = uilabel(app.GridLayout);
            app.fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel.FontSize = 11;
            app.fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel.FontWeight = 'bold';
            app.fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel.Layout.Row = 1;
            app.fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel.Layout.Column = 1;
            app.fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel.Interpreter = 'html';
            app.fontstylepaddingleft5pxDETECONOASSISTIDAfontLabel.Text = '<font style="padding-left: 5px;">DETECÇÃO NÃO ASSISTIDA</font>';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = dockDetection_exported(Container, varargin)

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
