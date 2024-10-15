classdef winAppAnalise_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        popupContainerGrid              matlab.ui.container.GridLayout
        SplashScreen                    matlab.ui.control.Image
        popupContainer                  matlab.ui.container.Panel
        menu_Grid                       matlab.ui.container.GridLayout
        AppInfo                         matlab.ui.control.Image
        FigurePosition                  matlab.ui.control.Image
        jsBackDoor                      matlab.ui.control.HTML
        menu_Button8                    matlab.ui.control.StateButton
        menu_Button7                    matlab.ui.control.StateButton
        menu_Button6                    matlab.ui.control.StateButton
        menu_Button5                    matlab.ui.control.StateButton
        menu_Separator2                 matlab.ui.control.Image
        menu_Button4                    matlab.ui.control.StateButton
        menu_Button3                    matlab.ui.control.StateButton
        menu_Button2                    matlab.ui.control.StateButton
        menu_Separator1                 matlab.ui.control.Image
        menu_Button1                    matlab.ui.control.StateButton
        TabGroup                        matlab.ui.container.TabGroup
        Tab1_File                       matlab.ui.container.Tab
        file_Grid                       matlab.ui.container.GridLayout
        file_panelGrid                  matlab.ui.container.GridLayout
        file_FilteringTree              matlab.ui.container.Tree
        file_FilteringAdd               matlab.ui.control.Image
        file_FilteringType3_Description  matlab.ui.control.EditField
        file_FilteringType2_ID          matlab.ui.control.DropDown
        file_FilteringType1_Frequency   matlab.ui.control.DropDown
        file_FilteringTypePanel         matlab.ui.container.ButtonGroup
        file_FilteringType3             matlab.ui.control.RadioButton
        file_FilteringType2             matlab.ui.control.RadioButton
        file_FilteringType1             matlab.ui.control.RadioButton
        file_FilteringLabel             matlab.ui.control.Label
        file_MetadataPanel              matlab.ui.container.Panel
        file_MetadataGrid               matlab.ui.container.GridLayout
        file_Metadata                   matlab.ui.control.HTML
        file_MetadataLabel              matlab.ui.control.Label
        file_docGrid                    matlab.ui.container.GridLayout
        file_Tree                       matlab.ui.container.Tree
        file_TreeLabel                  matlab.ui.control.Label
        file_TitleGrid                  matlab.ui.container.GridLayout
        file_Title                      matlab.ui.control.Label
        file_TitleIcon                  matlab.ui.control.Image
        file_toolGrid                   matlab.ui.container.GridLayout
        file_SpecReadButton             matlab.ui.control.Button
        file_OpenFileButton             matlab.ui.control.Image
        file_OpenInitialPopup           matlab.ui.control.Image
        Tab2_Playback                   matlab.ui.container.Tab
        play_Grid                       matlab.ui.container.GridLayout
        play_toolGrid                   matlab.ui.container.GridLayout
        tool_LayoutRight                matlab.ui.control.Image
        tool_FiscalizaUpdate            matlab.ui.control.Image
        tool_FiscalizaAutoFill          matlab.ui.control.Image
        tool_ReportGenerator            matlab.ui.control.Image
        tool_ReportAnalysis             matlab.ui.control.Image
        tool_ExceptionList              matlab.ui.control.Image
        tool_DriveTest                  matlab.ui.control.Image
        tool_RFDataHub                  matlab.ui.control.Image
        tool_TimestampLabel             matlab.ui.control.Label
        tool_TimestampSlider            matlab.ui.control.Slider
        tool_LoopControl                matlab.ui.control.Image
        tool_Play                       matlab.ui.control.Image
        tool_LayoutLeft                 matlab.ui.control.Image
        play_ControlsGrid               matlab.ui.container.GridLayout
        play_ControlsTab1Grid           matlab.ui.container.GridLayout
        play_ControlsTab1Image          matlab.ui.control.Image
        play_ControlsTab1Label          matlab.ui.control.Label
        misc_ControlsTab1Info           matlab.ui.container.GridLayout
        misc_Panel1                     matlab.ui.container.Panel
        misc_Grid1                      matlab.ui.container.GridLayout
        misc_DeleteAllLabel             matlab.ui.control.Label
        misc_DeleteAll                  matlab.ui.control.Button
        misc_AddCurveLabel              matlab.ui.control.Label
        misc_AddCurve                   matlab.ui.control.Button
        misc_EditLocalLabel             matlab.ui.control.Label
        misc_EditLocal                  matlab.ui.control.Button
        misc_FilterLabel                matlab.ui.control.Label
        misc_Filter                     matlab.ui.control.Button
        misc_ImportLabel                matlab.ui.control.Label
        misc_Import                     matlab.ui.control.Button
        misc_ExportLabel                matlab.ui.control.Label
        misc_Export                     matlab.ui.control.Button
        misc_Serarator                  matlab.ui.control.Image
        misc_DelLabel                   matlab.ui.control.Label
        misc_Del                        matlab.ui.control.Button
        misc_MergeLabel                 matlab.ui.control.Label
        misc_Merge                      matlab.ui.control.Button
        misc_DuplicateLabel             matlab.ui.control.Label
        misc_Duplicate                  matlab.ui.control.Button
        misc_SaveLabel                  matlab.ui.control.Label
        misc_Save                       matlab.ui.control.Button
        misc_Label1                     matlab.ui.control.Label
        misc_ControlsTab1Grid           matlab.ui.container.GridLayout
        misc_ControlsTab1Image          matlab.ui.control.Image
        misc_ControlsTab1Label          matlab.ui.control.Label
        report_ControlsTab2Info         matlab.ui.container.GridLayout
        report_FiscalizaPanel           matlab.ui.container.Panel
        report_FiscalizaGrid            matlab.ui.container.GridLayout
        report_FiscalizaIcon            matlab.ui.control.Image
        report_FiscalizaRefresh         matlab.ui.control.Image
        report_Fiscaliza_PanelLabel     matlab.ui.control.Label
        report_ControlsTab2Grid         matlab.ui.container.GridLayout
        report_ControlsTab2Image        matlab.ui.control.Image
        report_ControlsTab2Label        matlab.ui.control.Label
        report_ControlsTab1Info         matlab.ui.container.GridLayout
        report_Tree                     matlab.ui.container.CheckBoxTree
        report_TreeAddImage             matlab.ui.control.Image
        report_DocumentPanel            matlab.ui.container.Panel
        GridLayout4                     matlab.ui.container.GridLayout
        report_IssueLabel               matlab.ui.control.Label
        report_Issue                    matlab.ui.control.NumericEditField
        report_ExternalFiles            matlab.ui.control.Table
        report_ExternalFilesLabel       matlab.ui.control.Label
        report_AddProjectAttachment     matlab.ui.control.Image
        report_Version                  matlab.ui.control.DropDown
        report_VersionLabel             matlab.ui.control.Label
        report_ModelName                matlab.ui.control.DropDown
        report_ModelNameLabel           matlab.ui.control.Label
        report_DocumentPanelLabel       matlab.ui.control.Label
        report_ProjectSave              matlab.ui.control.Image
        report_ProjectOpen              matlab.ui.control.Image
        report_ProjectNew               matlab.ui.control.Image
        report_ProjectName              matlab.ui.control.TextArea
        report_ProjectNameLabel         matlab.ui.control.Label
        report_ThreadAlgorithmsLabel    matlab.ui.control.Label
        report_ControlsTab1Grid         matlab.ui.container.GridLayout
        report_ControlsTab1Image        matlab.ui.control.Image
        report_ProjectWarnIcon          matlab.ui.control.Image
        report_ControlsTab1Label        matlab.ui.control.Label
        play_ControlsTab3Info           matlab.ui.container.GridLayout
        play_FindPeaks_ExternalFilePanel  matlab.ui.container.Panel
        play_FindPeaks_ExternalFileGrid  matlab.ui.container.GridLayout
        play_FindPeaks_FileTemplate     matlab.ui.control.Hyperlink
        play_FindPeaks_ExternalFile     matlab.ui.control.DropDown
        play_FindPeaks_ExternalFileLabel  matlab.ui.control.Label
        play_FindPeaks_Description      matlab.ui.control.TextArea
        play_FindPeaks_DescriptionLabel  matlab.ui.control.Label
        play_FindPeaks_PeakBW           matlab.ui.control.NumericEditField
        play_FindPeaks_PeakBWLabel      matlab.ui.control.Label
        play_FindPeaks_PeakCF           matlab.ui.control.NumericEditField
        play_FindPeaks_PeakCFLabel      matlab.ui.control.Label
        play_FindPeaks_Tree             matlab.ui.container.Tree
        play_FindPeaks_add              matlab.ui.control.Image
        play_FindPeaks_ParametersPanel  matlab.ui.container.Panel
        play_FindPeaks_ParametersGrid   matlab.ui.container.GridLayout
        play_FindPeaks_Class            matlab.ui.control.DropDown
        play_FindPeaks_ClassLabel       matlab.ui.control.Label
        play_FindPeaks_MaxHoldPanel     matlab.ui.container.Panel
        play_FindPeaks_MaxHoldGrid      matlab.ui.container.GridLayout
        play_FindPeaks_maxOCC           matlab.ui.control.Spinner
        play_FindPeaks_meanOCC          matlab.ui.control.Spinner
        play_FindPeaks_OCCLabel         matlab.ui.control.Label
        play_FindPeaks_Prominence2      matlab.ui.control.Spinner
        play_FindPeaks_Prominence2Label  matlab.ui.control.Label
        play_FindPeaks_MeanPanel        matlab.ui.container.Panel
        play_FindPeaks_MeanGrid         matlab.ui.container.GridLayout
        play_FindPeaks_Prominence1      matlab.ui.control.Spinner
        play_FindPeaks_Prominence1Label  matlab.ui.control.Label
        play_FindPeaks_BW               matlab.ui.control.Spinner
        play_FindPeaks_BWLabel          matlab.ui.control.Label
        play_FindPeaks_distance         matlab.ui.control.Spinner
        play_FindPeaks_distanceLabel    matlab.ui.control.Label
        play_FindPeaks_prominence       matlab.ui.control.Spinner
        play_FindPeaks_prominenceLabel  matlab.ui.control.Label
        play_FindPeaks_THR              matlab.ui.control.Spinner
        play_FindPeaks_THRLabel         matlab.ui.control.Label
        play_FindPeaks_Numbers          matlab.ui.control.Spinner
        play_FindPeaks_NumbersLabel     matlab.ui.control.Label
        play_FindPeaks_Trace            matlab.ui.control.DropDown
        play_FindPeaks_TraceLabel       matlab.ui.control.Label
        play_FindPeaks_Algorithm        matlab.ui.control.DropDown
        play_FindPeaks_AlgorithmLabel   matlab.ui.control.Label
        play_FindPeaks_RadioGroup       matlab.ui.container.ButtonGroup
        play_FindPeaks_File             matlab.ui.control.RadioButton
        play_FindPeaks_DataTips         matlab.ui.control.RadioButton
        play_FindPeaks_ROI              matlab.ui.control.RadioButton
        play_FindPeaks_auto             matlab.ui.control.RadioButton
        play_FindPeaks_Label            matlab.ui.control.Label
        play_ControlsTab3Grid           matlab.ui.container.GridLayout
        play_ControlsTab3Image          matlab.ui.control.Image
        play_ControlsTab3Label          matlab.ui.control.Label
        play_ControlsTab2Info           matlab.ui.container.GridLayout
        play_Channel_ShowPlot           matlab.ui.control.Image
        play_BandLimits_Tree            matlab.ui.container.Tree
        play_BandLimits_add             matlab.ui.control.Image
        play_BandLimits_Panel           matlab.ui.container.Panel
        play_BandLimits_Grid            matlab.ui.container.GridLayout
        play_BandLimits_xLim2           matlab.ui.control.NumericEditField
        play_BandLimits_xLabel          matlab.ui.control.Label
        play_BandLimits_xLim1           matlab.ui.control.NumericEditField
        play_BandLimits_Status          matlab.ui.control.CheckBox
        play_Channel_Tree               matlab.ui.container.Tree
        play_Channel_add                matlab.ui.control.Image
        play_Channel_ExternalFilePanel  matlab.ui.container.Panel
        play_Channel_ExternalFileGrid   matlab.ui.container.GridLayout
        play_Channel_FileTemplate       matlab.ui.control.Hyperlink
        play_Channel_ExternalFile       matlab.ui.control.DropDown
        play_Channel_ExternalFileLabel  matlab.ui.control.Label
        play_Channel_Panel              matlab.ui.container.Panel
        play_Channel_Grid               matlab.ui.container.GridLayout
        play_Channel_Sample             matlab.ui.control.Label
        play_Channel_BW                 matlab.ui.control.NumericEditField
        play_Channel_BWLabel            matlab.ui.control.Label
        play_Channel_StepWidth          matlab.ui.control.NumericEditField
        play_Channel_StepWidthLabel     matlab.ui.control.Label
        play_Channel_Class              matlab.ui.control.DropDown
        play_Channel_ClassLabel         matlab.ui.control.Label
        play_Channel_LastChannel        matlab.ui.control.NumericEditField
        play_Channel_LastChannelLabel   matlab.ui.control.Label
        play_Channel_FirstChannel       matlab.ui.control.NumericEditField
        play_Channel_FirstChannelLabel  matlab.ui.control.Label
        play_Channel_nChannels          matlab.ui.control.NumericEditField
        play_Channel_nChannelsLabel     matlab.ui.control.Label
        play_Channel_Name               matlab.ui.control.EditField
        play_Channel_List               matlab.ui.control.DropDown
        play_Channel_ListUpdate         matlab.ui.control.Image
        play_Channel_ListLabel          matlab.ui.control.Label
        play_Channel_RadioGroup         matlab.ui.container.ButtonGroup
        play_Channel_File               matlab.ui.control.RadioButton
        play_Channel_Single             matlab.ui.control.RadioButton
        play_Channel_Multiples          matlab.ui.control.RadioButton
        play_Channel_ReferenceList      matlab.ui.control.RadioButton
        play_Channel_Label              matlab.ui.control.Label
        play_ControlsTab2Grid           matlab.ui.container.GridLayout
        play_ControlsTab2Image          matlab.ui.control.Image
        play_Channel_ShowPlotWarn       matlab.ui.control.Image
        play_ControlsTab2Label          matlab.ui.control.Label
        play_ControlsTab1Info           matlab.ui.container.GridLayout
        play_Customization              matlab.ui.control.CheckBox
        play_Waterfall_Panel            matlab.ui.container.Panel
        play_WaterFallGrid              matlab.ui.container.GridLayout
        play_Waterfall_cLim_Grid2       matlab.ui.container.GridLayout
        play_Waterfall_cLim2            matlab.ui.control.Spinner
        play_Waterfall_cLim_Separation  matlab.ui.control.Label
        play_Waterfall_cLim1            matlab.ui.control.Spinner
        play_Waterfall_cLim_Mode        matlab.ui.control.Image
        play_Waterfall_cLim_Label       matlab.ui.control.Label
        play_Waterfall_MeshStyle        matlab.ui.control.DropDown
        play_Waterfall_MeshStyleLabel   matlab.ui.control.Label
        play_Waterfall_Colormap         matlab.ui.control.DropDown
        play_Waterfall_ColormapLabel    matlab.ui.control.Label
        play_Waterfall_Colorbar         matlab.ui.control.DropDown
        play_Waterfall_ColorbarLabel    matlab.ui.control.Label
        play_Waterfall_Timeline         matlab.ui.control.DropDown
        play_Waterfall_TimelineLabel    matlab.ui.control.Label
        play_Waterfall_Decimation       matlab.ui.control.DropDown
        play_Waterfall_DecimationValue  matlab.ui.control.Label
        play_Waterfall_DecimationLabel  matlab.ui.control.Label
        play_Waterfall_Fcn              matlab.ui.control.DropDown
        play_Waterfall_FcnLabel         matlab.ui.control.Label
        play_OCC_Panel                  matlab.ui.container.Panel
        play_OCCGrid                    matlab.ui.container.GridLayout
        play_OCC_noisePanel             matlab.ui.container.Panel
        play_OCC_noiseGrid              matlab.ui.container.GridLayout
        play_OCC_noiseUsefulSamples     matlab.ui.control.Spinner
        play_OCC_noiseUsefulSamplesLabel  matlab.ui.control.Label
        play_OCC_noiseTrashSamples      matlab.ui.control.Spinner
        play_OCC_noiseTrashSamplesLabel  matlab.ui.control.Label
        play_OCC_noiseFcn               matlab.ui.control.DropDown
        play_OCC_noiseFcnLabel          matlab.ui.control.Label
        play_OCC_noiseLabel             matlab.ui.control.Label
        play_OCC_ceilFactor             matlab.ui.control.DropDown
        play_OCC_ceilFactorLabel        matlab.ui.control.Label
        play_OCC_Offset                 matlab.ui.control.Spinner
        play_OCC_OffsetLabel            matlab.ui.control.Label
        play_OCC_THRCaptured            matlab.ui.control.DropDown
        play_OCC_THR                    matlab.ui.control.Spinner
        play_OCC_THRLabel               matlab.ui.control.Label
        play_OCC_Orientation            matlab.ui.control.DropDown
        play_OCC_OrientationLabel       matlab.ui.control.Label
        play_OCC_IntegrationTimeCaptured  matlab.ui.control.NumericEditField
        play_OCC_IntegrationTime        matlab.ui.control.DropDown
        play_OCC_IntegrationTimeLabel   matlab.ui.control.Label
        play_OCC_Method                 matlab.ui.control.DropDown
        play_OCC_MethodLabel            matlab.ui.control.Label
        play_Persistance_Panel          matlab.ui.container.Panel
        play_PersistanceGrid            matlab.ui.container.GridLayout
        play_Persistance_cLim_Grid2     matlab.ui.container.GridLayout
        play_Persistance_cLim_Separation  matlab.ui.control.Label
        play_Persistance_cLim2          matlab.ui.control.Spinner
        play_Persistance_cLim1          matlab.ui.control.Spinner
        play_Persistance_cLim_Mode      matlab.ui.control.Image
        play_Persistance_cLim_Label     matlab.ui.control.Label
        play_Persistance_Transparency   matlab.ui.control.Spinner
        play_Persistance_TransparencyLabel  matlab.ui.control.Label
        play_Persistance_Colormap       matlab.ui.control.DropDown
        play_Persistance_ColormapLabel  matlab.ui.control.Label
        play_Persistance_WindowSize     matlab.ui.control.DropDown
        play_Persistance_WindowSizeLabel  matlab.ui.control.Label
        play_Persistance_Interpolation  matlab.ui.control.DropDown
        play_Persistance_InterpolationLabel  matlab.ui.control.Label
        play_ControlsPanel              matlab.ui.container.ButtonGroup
        play_RadioButton_Waterfall      matlab.ui.control.RadioButton
        play_RadioButton_Occupancy      matlab.ui.control.RadioButton
        play_RadioButton_Persistance    matlab.ui.control.RadioButton
        play_ControlPanelLabel          matlab.ui.control.Label
        play_GeneralPanel               matlab.ui.container.Panel
        play_OthersGrid                 matlab.ui.container.GridLayout
        play_LimitsPanel                matlab.ui.container.Panel
        play_LimitsGrid                 matlab.ui.container.GridLayout
        play_Limits_yLim2               matlab.ui.control.Spinner
        play_Limits_yLimLabel           matlab.ui.control.Label
        play_Limits_yLim1               matlab.ui.control.Spinner
        play_Limits_xLim2               matlab.ui.control.Spinner
        play_Limits_xLimLabel           matlab.ui.control.Label
        play_Limits_xLim1               matlab.ui.control.Spinner
        play_LimitsRefresh              matlab.ui.control.Image
        play_LimitsPanelLabel           matlab.ui.control.Label
        play_TraceIntegration           matlab.ui.control.DropDown
        play_TraceIntegrationLabel      matlab.ui.control.Label
        play_MinPlotTime                matlab.ui.control.Spinner
        play_MinPlotTimeLabel           matlab.ui.control.Label
        play_LineVisibility             matlab.ui.control.DropDown
        play_LineVisibilityLabel        matlab.ui.control.Label
        play_LayoutRatio                matlab.ui.control.DropDown
        play_LayoutRatioLabel           matlab.ui.control.Label
        play_GeneralPanelLabel          matlab.ui.control.Label
        play_axesToolbar                matlab.ui.container.GridLayout
        axesTool_RestoreView            matlab.ui.control.Image
        axesTool_Pan                    matlab.ui.control.Image
        axesTool_DataTip                matlab.ui.control.Image
        axesTool_Waterfall              matlab.ui.control.Image
        axesTool_Occupancy              matlab.ui.control.Image
        axesTool_Persistance            matlab.ui.control.Image
        axesTool_MaxHold                matlab.ui.control.Image
        axesTool_Average                matlab.ui.control.Image
        axesTool_MinHold                matlab.ui.control.Image
        play_PlotPanel                  matlab.ui.container.Panel
        play_TreeGrid                   matlab.ui.container.GridLayout
        report_EditDetection            matlab.ui.control.Hyperlink
        report_EditClassification       matlab.ui.control.Hyperlink
        report_DetectionManualMode      matlab.ui.control.CheckBox
        report_ThreadAlgorithmsPanel    matlab.ui.container.Panel
        report_ThreadAlgorithmsGrid     matlab.ui.container.GridLayout
        report_ThreadAlgorithms         matlab.ui.control.HTML
        report_TreeLabel                matlab.ui.control.Label
        play_MetadataPanel              matlab.ui.container.Panel
        play_MetadataGrid               matlab.ui.container.GridLayout
        play_Metadata                   matlab.ui.control.HTML
        play_MetadataLabel              matlab.ui.control.Label
        play_Tree                       matlab.ui.container.Tree
        play_TreeSort                   matlab.ui.control.Image
        play_TreePanelVisibility        matlab.ui.control.Image
        play_TreeLabel                  matlab.ui.control.Label
        play_TreeTitleGrid              matlab.ui.container.GridLayout
        play_TreeTitle                  matlab.ui.control.Label
        play_TreeTitleImage             matlab.ui.control.Image
        Tab3_DriveTest                  matlab.ui.container.Tab
        drivetest_Grid                  matlab.ui.container.GridLayout
        drivetest_Close                 matlab.ui.control.Image
        drivetest_Undock                matlab.ui.control.Image
        drivetest_Container             matlab.ui.container.Panel
        Tab4_SignalAnalysis             matlab.ui.container.Tab
        signalanalysis_Grid             matlab.ui.container.GridLayout
        signalanalysis_Close            matlab.ui.control.Image
        signalanalysis_Undock           matlab.ui.control.Image
        signalanalysis_Container        matlab.ui.container.Panel
        Tab5_RFDataHub                  matlab.ui.container.Tab
        rfdatahub_Grid                  matlab.ui.container.GridLayout
        rfdatahub_Close                 matlab.ui.control.Image
        rfdatahub_Undock                matlab.ui.control.Image
        rfdatahub_Container             matlab.ui.container.Panel
        Tab6_Config                     matlab.ui.container.Tab
        config_Grid                     matlab.ui.container.GridLayout
        config_Close                    matlab.ui.control.Image
        config_Undock                   matlab.ui.control.Image
        config_Container                matlab.ui.container.Panel
        file_ContextMenu_Tree1          matlab.ui.container.ContextMenu
        file_ContextMenu_delTree1Node   matlab.ui.container.Menu
        file_ContextMenu_Tree2          matlab.ui.container.ContextMenu
        file_ContextMenu_delTree2Node   matlab.ui.container.Menu
        play_FindPeaks_ContextMenu      matlab.ui.container.ContextMenu
        play_FindPeaks_ContextMenu_edit  matlab.ui.container.Menu
        play_FindPeaks_ContextMenu_analog  matlab.ui.container.Menu
        play_FindPeaks_ContextMenu_digital  matlab.ui.container.Menu
        play_FindPeaks_ContextMenu_del  matlab.ui.container.Menu
        play_Channel_ContextMenu        matlab.ui.container.ContextMenu
        play_Channel_ContextMenu_del    matlab.ui.container.Menu
        play_Channel_ContextMenu_addBandLimit  matlab.ui.container.Menu
        play_Channel_ContextMenu_addEmission  matlab.ui.container.Menu
        report_ContextMenu              matlab.ui.container.ContextMenu
        report_ContextMenu_del          matlab.ui.container.Menu
        report_ContextMenu_ExternalFiles  matlab.ui.container.Menu
        play_BandLimits_ContextMenu     matlab.ui.container.ContextMenu
        play_BandLimits_ContextMenu_del  matlab.ui.container.Menu
    end

    
    properties (Access = public)
        %-----------------------------------------------------------------%
        % PROPRIEDADES COMUNS A TODOS OS APPS
        %-----------------------------------------------------------------%
        General 
        rootFolder

        % Essa propriedade registra o tipo de execução da aplicação, podendo
        % ser: 'built-in', 'desktopApp' ou 'webApp'.
        executionMode        

        % A função do timer é executada uma única vez após a renderização
        % da figura, lendo arquivos de configuração, iniciando modo de operação
        % paralelo etc. A ideia é deixar o MATLAB focar apenas na criação dos 
        % componentes essenciais da GUI (especificados em "createComponents"), 
        % mostrando a GUI para o usuário o mais rápido possível.
        timerObj_startup

        % O MATLAB não renderiza alguns dos componentes de abas (do TabGroup) 
        % não visíveis. E a customização de componentes, usando a lib ccTools, 
        % somente é possível após a sua renderização. Controla-se a aplicação 
        % da customizaçao por meio dessa propriedade jsBackDoorFlag.
        jsBackDoorFlag = {true, ...
                          true, ...
                          true, ...
                          true, ...
                          true, ...
                          true};

        % Janela de progresso já criada no DOM. Dessa forma, controla-se 
        % apenas a sua visibilidade - e tornando desnecessário criá-la a
        % cada chamada (usando uiprogressdlg, por exemplo).
        progressDialog

        % Objeto que possibilita integração com o FISCALIZA, consumindo lib
        % escrita em Python (fiscaliza).
        fiscalizaObj

        %-----------------------------------------------------------------%
        % PROPRIEDADES ESPECÍFICAS
        %-----------------------------------------------------------------%
        metaData    = class.metaData.empty
        specData    = class.specData.empty
        projectData

        bandObj
        channelObj

        restoreView = struct('ID', {}, 'xLim', {}, 'yLim', {}, 'cLim', {})
        plotFlag    = 0
        plotLayout  = 1
        idxTime     = 1

        UIAxes1
        UIAxes2
        UIAxes3

        hClearWrite                                                         % ClearWrite (main trace)
        hMinHold
        hAverage
        hMaxHold
        hPersistanceObj                                                     % Persistance Object    
        hSelectedEmission                                                   % Selected marker roi
        hEmissionMarkers                                                    % Markers labels        
        hTHR                                                                % OCC roi/line
        hTHRLabel                                                           % OCC roi/line label ("THR")            
        hWaterfall
        hWaterfallTime                                                      % Waterfall timestamp

        hDriveTest                                                          % auxApp.winDriveTest.mlapp      | auxApp.winDriveTest_exported.m
        hSignalAnalysis                                                     % auxApp.winSignalAnalysis.mlapp | auxApp.winSignalAnalysis_exported.m
        hRFDataHub                                                          % winRFDataHub.mlapp             | winRFDataHub_exported.m
        hConfig                                                             % auxApp.dockConfig.mlapp        | auxApp.dockConfig_exported.m
    end
    
    
    methods (Access = private)
        %-----------------------------------------------------------------%
        % JSBACKDOOR
        %-----------------------------------------------------------------%
        function jsBackDoor_Initialization(app)
            app.jsBackDoor.HTMLSource           = ccTools.fcn.jsBackDoorHTMLSource();
            app.jsBackDoor.HTMLEventReceivedFcn = @(~, evt)jsBackDoor_Listener(app, evt);
        end

        %-----------------------------------------------------------------%
        function jsBackDoor_Listener(app, event)
            switch event.HTMLEventName
                case 'app.file_Tree'
                    file_ContextMenu_delTree1NodeSelected(app)
                case 'app.file_FilteringTree'
                    file_ContextMenu_delTree2NodeSelected(app)
                case 'app.play_Channel_Tree'
                    play_Channel_ContextMenu_delChannelSelected(app)
                case 'app.play_BandLimits_Tree'
                    play_BandLimits_ContextMenu_delSelected(app)
                case 'app.play_FindPeaks_Tree'
                    play_FindPeaks_delEmission(app)
                case 'app.report_Tree'
                    report_ContextMenu_delSelected(app)
                case 'credentialDialog'
                    fiscalizaLibConnection.report_Connect(app, event.HTMLEventData, 'OpenConnection')
                case 'BackgroundColorTurnedInvisible'
                    switch event.HTMLEventData
                        case 'SplashScreen'
                            if isvalid(app.SplashScreen)
                                delete(app.SplashScreen)
                            end
                        otherwise
                            % ...
                    end
            end
            drawnow
        end

        %-----------------------------------------------------------------%
        function jsBackDoor_Customizations(app, tabIndex)
            % O menu gráfico controla, programaticamente, qual das abas de
            % app.TabGroup estará visível. 

            % Lembrando que o MATLAB renderiza em tela apenas as abas visíveis.
            % Por isso as customizações de abas e suas subabas somente é possível 
            % após a renderização da aba.
            switch tabIndex
                case 0 % STARTUP
                    app.progressDialog = ccTools.ProgressDialog(app.jsBackDoor);

                    sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        'body',                           ...
                                                                                           'classAttributes', ['--tabButton-border-color: #fff;' ...
                                                                                                               '--tabContainer-border-color: #fff;']));

                    sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mw-theme-light',                                                   ...
                                                                                           'classAttributes', ['--mw-backgroundColor-dataWidget-selected: rgb(180 222 255 / 45%); ' ...
                                                                                                               '--mw-backgroundColor-selected: rgb(180 222 255 / 45%); '            ...
                                                                                                               '--mw-backgroundColor-selectedFocus: rgb(180 222 255 / 45%);'        ...
                                                                                                               '--mw-backgroundColor-tab: #fff;']));

                    sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mw-default-header-cell', ...
                                                                                           'classAttributes',  'font-size: 10px; white-space: pre-wrap; margin-bottom: 5px;'));

                    % MATLAB R2024a Update 6 apresentou um BUG, não armazenando
                    % alterações na propriedade "BorderColor" dos painéis quando
                    % realizadas no ambiente do AppDesigner.
                    app.drivetest_Container.BorderColor      = [.94,.94,.94];
                    app.signalanalysis_Container.BorderColor = [.94,.94,.94];
                    app.rfdatahub_Container.BorderColor      = [.94,.94,.94];

                otherwise
                    if any(app.jsBackDoorFlag{tabIndex})
                        app.jsBackDoorFlag{tabIndex} = false;

                        switch tabIndex
                            case 1 % FILE            
                                app.file_Tree.UserData          = struct(app.file_Tree).Controller.ViewModel.Id;
                                app.file_FilteringTree.UserData = struct(app.file_FilteringTree).Controller.ViewModel.Id;
                                sendEventToHTMLSource(app.jsBackDoor, 'addKeyDownListener', struct('componentName', 'app.file_Tree',          'componentDataTag', app.file_Tree.UserData,          'keyEvents', "Delete"))
                                sendEventToHTMLSource(app.jsBackDoor, 'addKeyDownListener', struct('componentName', 'app.file_FilteringTree', 'componentDataTag', app.file_FilteringTree.UserData, 'keyEvents', "Delete"))
            
                            case 2 % PLAYBACK+REPORT+MISC
                                ccTools.compCustomizationV2(app.jsBackDoor, app.play_axesToolbar, 'borderBottomLeftRadius', '5px', 'borderBottomRightRadius', '5px')
        
                                app.play_Channel_Tree.UserData    = struct(app.play_Channel_Tree).Controller.ViewModel.Id;
                                app.play_BandLimits_Tree.UserData = struct(app.play_BandLimits_Tree).Controller.ViewModel.Id;
                                app.play_FindPeaks_Tree.UserData  = struct(app.play_FindPeaks_Tree).Controller.ViewModel.Id;
                                app.report_Tree.UserData          = struct(app.report_Tree).Controller.ViewModel.Id;
                                sendEventToHTMLSource(app.jsBackDoor, 'addKeyDownListener', struct('componentName', 'app.play_Channel_Tree',    'componentDataTag', app.play_Channel_Tree.UserData,    'keyEvents', "Delete"))
                                sendEventToHTMLSource(app.jsBackDoor, 'addKeyDownListener', struct('componentName', 'app.play_BandLimits_Tree', 'componentDataTag', app.play_BandLimits_Tree.UserData, 'keyEvents', "Delete"))
                                sendEventToHTMLSource(app.jsBackDoor, 'addKeyDownListener', struct('componentName', 'app.play_FindPeaks_Tree',  'componentDataTag', app.play_FindPeaks_Tree.UserData,  'keyEvents', "Delete"))
                                sendEventToHTMLSource(app.jsBackDoor, 'addKeyDownListener', struct('componentName', 'app.report_Tree',          'componentDataTag', app.report_Tree.UserData,          'keyEvents', "Delete"))

                            otherwise
                                % ...
                        end
                    end
            end
        end
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        % INICIALIZAÇÃO DO APP
        %-----------------------------------------------------------------%
        function startup_timerCreation(app)
            app.timerObj_startup = timer("ExecutionMode", "fixedSpacing", ...
                                         "StartDelay",    1.5,            ...
                                         "Period",        .1,             ...
                                         "TimerFcn",      @(~,~)app.startup_timerFcn);
            start(app.timerObj_startup)
        end

        %-----------------------------------------------------------------%
        function startup_timerFcn(app)
            if ccTools.fcn.UIFigureRenderStatus(app.UIFigure)
                stop(app.timerObj_startup)
                drawnow

                app.executionMode = appUtil.ExecutionMode(app.UIFigure);
                switch app.executionMode
                    case 'webApp'
                        % ...
                    otherwise
                        % Configura o tamanho mínimo da janela.
                        app.FigurePosition.Visible = 1;
                        appUtil.winMinSize(app.UIFigure, class.Constants.windowMinSize)
                end

                appName           = class.Constants.appName;
                MFilePath         = fileparts(mfilename('fullpath'));
                app.rootFolder    = appUtil.RootFolder(appName, MFilePath);
                
                % WELCOMEPAGE
                % 1/7: Insere estilo ao container do auxApp.dockWelcomePage.
                sendEventToHTMLSource(app.jsBackDoor, "panelDialog", struct('componentDataTag', struct(app.popupContainer).Controller.ViewModel.Id)) 
                
                % 2/7: Adiciona transparência ao Grid do Container, que confere 
                %      o efeito de janela modal à auxApp.dockWelcomePage.
                ccTools.compCustomizationV2(app.jsBackDoor, app.popupContainerGrid, 'backgroundColor', 'rgba(255,255,255,0.65')
                
                % 3/7: Inicia auxApp.dockWelcomePage.
                menu_LayoutPopupApp(app, 'WelcomePage')
                
                % Customiza as aspectos estéticos de alguns dos componentes da GUI 
                % (diretamente em JS).
                jsBackDoor_Customizations(app, 0)
                jsBackDoor_Customizations(app, 1)

                % Leitura do arquivo "GeneralSettings.json".
                startup_ConfigFileRead(app)
                startup_AppProperties(app)
                startup_GUIComponents(app)

                switch app.executionMode
                    case 'webApp'
                        % Força a exclusão do SplashScreen do MATLAB WebDesigner.
                        sendEventToHTMLSource(app.jsBackDoor, "delProgressDialog");
    
                        % Webapp também não suporta outras janelas, de forma que os 
                        % módulos auxiliares devem ser abertos na própria janela
                        % do appAnalise.
                        app.drivetest_Undock.Visible      = 0;
                        app.signalanalysis_Undock.Visible = 0;
                        app.rfdatahub_Undock.Visible      = 0;
                        app.config_Undock.Visible         = 0;

                        app.General.operationMode.Debug   = false;
                        app.General.operationMode.Dock    = true;

                        % A pasta do usuário não é configurável, mas obtida por 
                        % meio de chamada a uiputfile. Para criação de arquivos 
                        % temporários, cria-se uma pasta da sessão.
                        tempDir = tempname;
                        mkdir(tempDir)
                        app.General.fileFolder.userPath   = tempDir;
    
                    otherwise    
                        % Resgata a pasta de trabalho do usuário (configurável).
                        userPaths = appUtil.UserPaths(app.General.fileFolder.userPath);
                        app.General.fileFolder.userPath = userPaths{end};

                        switch app.executionMode
                            case 'desktopStandaloneApp'
                                app.General.operationMode.Debug = false;
                            case 'MATLABEnvironment'
                                app.General.operationMode.Debug = true;
                        end
                end
                
                % WELCOMEPAGE (continuação)
                % 4/7: Diminui a opacidade do SplashScreen. Esse processo dura
                %      cerca de 1250 ms. São 50 iterações em que em cada uma 
                %      delas a opacidade da imagem diminuir em 0.02. Entre cada 
                %      iteração, 25 ms. E executa drawnow, forçando a renderização 
                %      em tela dos componentes.
                sendEventToHTMLSource(app.jsBackDoor, 'turningBackgroundColorInvisible', struct('componentName', 'SplashScreen', 'componentDataTag', struct(app.SplashScreen).Controller.ViewModel.Id));
                drawnow

                % 5/7: Torna visível o container do auxApp.popupContainer, forçando
                %      a exclusão do SplashScreen.
                app.TabGroup.Visible = 1;
                app.popupContainer.Visible = 1;                
                if isvalid(app.SplashScreen)
                    pause(1)
                    delete(app.SplashScreen)
                end
            end
        end

        %-----------------------------------------------------------------%
        function startup_ConfigFileRead(app)
            % "GeneralSettings.json"
            [app.General, msgWarning] = appUtil.generalSettingsLoad(class.Constants.appName, app.rootFolder);
            if ~isempty(msgWarning)
                appUtil.modalWindow(app.UIFigure, 'error', msgWarning);
            end

            if ~strcmp(app.General.Plot.Waterfall.Decimation, 'auto')
                app.General.Plot.Waterfall.Decimation = 'auto';
            end
        
            if isempty(app.General.Merge.Distance)
                app.General.Merge.Distance = Inf;
            end
        
            if isempty(app.General.Integration.Trace)
                app.General.Integration.Trace = Inf;
            end
        
            app.General.AppVersion = fcn.envVersion(app.rootFolder, 'full');
            app.General.Models     = struct2table(jsondecode(fileread(fullfile(app.rootFolder, 'Template', 'html_General.cfg'))));
            app.General.Report     = '';
        end

        %-----------------------------------------------------------------%
        function startup_AppProperties(app)
            app.projectData = projectLib(app);
            app.bandObj     = class.Band('appAnalise:PLAYBACK', app);
            app.channelObj  = class.ChannelLib(class.Constants.appName, app.rootFolder);
        end

        %-----------------------------------------------------------------%
        function startup_GUIComponents(app)
            % Salva na propriedade "UserData" as opções de ícone e o índice 
            % da aba, simplificando os ajustes decorrentes de uma alteração...
            app.menu_Button1.UserData                = struct('iconOptions', {{'OpenFile_32White.png',         'OpenFile_32Yellow.png'}},         'tabGroup', 1);
            app.menu_Button2.UserData                = struct('iconOptions', {{'Playback_32White.png',         'Playback_32Yellow.png'}},         'tabGroup', 2);
            app.menu_Button3.UserData                = struct('iconOptions', {{'Report_32White.png',           'Report_32Yellow.png'}},           'tabGroup', 2);
            app.menu_Button4.UserData                = struct('iconOptions', {{'Misc_32White.png',             'Misc_32Yellow.png'}},             'tabGroup', 2);
            app.menu_Button5.UserData                = struct('iconOptions', {{'DriveTestDensity_32White.png', 'DriveTestDensity_32Yellow.png'}}, 'tabGroup', 3);
            app.menu_Button6.UserData                = struct('iconOptions', {{'exceptionList_32White.png',    'exceptionList_32Yellow.png'}},    'tabGroup', 4);
            app.menu_Button7.UserData                = struct('iconOptions', {{'mosaic_32White.png',           'mosaic_32Yellow.png'}},           'tabGroup', 5);
            app.menu_Button8.UserData                = struct('iconOptions', {{'Settings_36White.png',         'Settings_36Yellow.png'}},         'tabGroup', 6);
                        
            app.play_TreeSort.UserData               = 'Receiver+Frequency';
            app.file_Tree.UserData                   = struct('previousSelectedFileIndex', []);
            app.play_TreePanelVisibility.UserData    = struct('Mode', 'PLAYBACK', 'Visible', true);
            app.play_Channel_ShowPlot.UserData       = false;
            
            app.axesTool_Pan.UserData                = false;
            app.axesTool_DataTip.UserData            = false;
            app.axesTool_MinHold.UserData            = struct('Value', false, 'ImageSource', {{'MinHold_32Filled.png', 'MinHold_32.png'}});
            app.axesTool_Average.UserData            = struct('Value', false, 'ImageSource', {{'Average_32Filled.png', 'Average_32.png'}});
            app.axesTool_MaxHold.UserData            = struct('Value', false, 'ImageSource', {{'MaxHold_32Filled.png', 'MaxHold_32.png'}});
            app.axesTool_Persistance.UserData        = struct('Value', false);
            app.axesTool_Occupancy.UserData          = struct('Value', false);
            app.axesTool_Waterfall.UserData          = struct('Value', false);

            app.play_PlotPanel.UserData              = [];

            % Painel "PLAYBACK > ASPECTOS GERAIS"
            if ismember(num2str(app.General.Integration.Trace), app.play_TraceIntegration.Items)
                app.play_TraceIntegration.Value      = num2str(app.General.Integration.Trace);
            else
                app.General.Integration.Trace        = Inf;
            end

            % Painel "PLAYBACK > ASPECTOS GERAIS > PERSISTÊNCIA"
            app.play_Persistance_Interpolation.Value = app.General.Plot.Persistance.Interpolation;
            app.play_Persistance_WindowSize.Value    = app.General.Plot.Persistance.WindowSize;
            app.play_Persistance_Colormap.Value      = app.General.Plot.Persistance.Colormap;
            app.play_Persistance_cLim1.Value         = app.General.Plot.Persistance.LevelLimits(1);
            app.play_Persistance_cLim2.Value         = app.General.Plot.Persistance.LevelLimits(2);
            play_ControlsPanelSelectionChanged(app)

            % Painel "PLAYBACK > ASPECTOS GERAIS > WATERFALL"
            app.play_Waterfall_Fcn.Value             = app.General.Plot.Waterfall.Fcn;
            app.play_Waterfall_Colorbar.Value        = app.General.Plot.Waterfall.Colorbar;
            app.play_Waterfall_Decimation.Value      = app.General.Plot.Waterfall.Decimation;
            app.play_Waterfall_MeshStyle.Value       = app.General.Plot.Waterfall.MeshStyle;
            app.play_Waterfall_Timeline.Value        = app.General.Plot.WaterfallTime.Visible;
            app.play_Waterfall_Colormap.Value        = app.General.Plot.Waterfall.Colormap;
            app.play_Waterfall_cLim1.Value           = app.General.Plot.Waterfall.LevelLimits(1);
            app.play_Waterfall_cLim2.Value           = app.General.Plot.Waterfall.LevelLimits(2);

            % Painel "PLAYBACK > CANAIS"
            channelList = {};
            for ii = 1:numel(app.channelObj.Channel)
                channelList{end+1} = sprintf('%d: %.3f - %.3f MHz (%s)', ii, app.channelObj.Channel(ii).Band(1), ...
                                                                             app.channelObj.Channel(ii).Band(2),     ...
                                                                             app.channelObj.Channel(ii).Name);
            end
            app.play_Channel_List.Items = channelList;
            play_Channel_RadioGroupSelectionChanged(app)
            
            % Painel "PLAYBACK > EMISSÕES"
            app.play_FindPeaks_Class.Items = app.channelObj.FindPeaks.Name;
            play_FindPeaks_ClassValueChanged(app)

            play_FindPeaks_RadioGroupSelectionChanged(app)
            play_FindPeaks_AlgorithmValueChanged(app)

            % Painel "REPORT >> PROJECT"
            app.report_ThreadAlgorithms.HTMLSource   = fullfile(app.rootFolder, 'Icons', 'Warning.html');
            app.report_ModelName.Items               = [{''}; app.General.Models.Name];

            % Painel "CONFIG >> PYTHON"
            pythonPath = app.General.fileFolder.pythonPath;
            if isfile(pythonPath)
                pyenv('Version', pythonPath);
            end

            % Painel "REPORT >> FISCALIZA"
            switch app.General.fiscaliza.systemVersion
                case 'PROD'
                    app.report_ControlsTab2Label.Text   = 'API FISCALIZA';        
                case 'HOM'
                    app.report_ControlsTab2Label.Text   = 'API FISCALIZA HOMOLOGAÇÃO';
            end
        end

        %-----------------------------------------------------------------%
        function startup_Axes(app)
            % Axes creation:
            hParent     = tiledlayout(app.play_PlotPanel, 4, 1, "Padding", "compact", "TileSpacing", "compact");
            app.UIAxes1 = plot.axes.Creation(hParent, 'Cartesian', {'UserData', struct('CLimMode', 'auto', 'Colormap', '')});
            app.UIAxes1.Layout.Tile = 1;
            app.UIAxes1.Layout.TileSpan = [2 1];
            
            app.UIAxes2 = plot.axes.Creation(hParent, 'Cartesian', {'YScale', 'log'});
            app.UIAxes2.Layout.Tile = 3;
            
            app.UIAxes3 = plot.axes.Creation(hParent, 'Cartesian', {'Layer', 'top', 'Box', 'on', 'XGrid', 'off', 'XMinorGrid', 'off', 'YGrid', 'off', 'YMinorGrid', 'off', 'UserData', struct('CLimMode', 'auto', 'Colormap', '')});
            app.UIAxes3.Layout.Tile = 4;            

            % Axes colormap:
            plot.axes.Colormap(app.UIAxes1, app.play_Persistance_Colormap.Value)
            plot.axes.Colormap(app.UIAxes3, app.play_Waterfall_Colormap.Value)

            % Axes colorbar:
            play_Waterfall_ColorbarValueChanged(app)

            % Axes fixed labels:
            ylabel(app.UIAxes1, 'Nível (dB)')
            ysecondarylabel(app.UIAxes1, Visible='on')

            ylabel(app.UIAxes2, 'Ocupação (%)')
            xlabel(app.UIAxes3, 'Frequência (MHz)')
            ylabel(app.UIAxes3, 'Instante')
            plot.axes.Layout.XLabel([app.UIAxes1, app.UIAxes2, app.UIAxes3], app.axesTool_Occupancy.UserData.Value, app.axesTool_Waterfall.UserData.Value)
            plot.axes.Layout.RatioAspect([app.UIAxes1, app.UIAxes2, app.UIAxes3], app.axesTool_Occupancy.UserData.Value, app.axesTool_Waterfall.UserData.Value, app.play_LayoutRatio)

            % Axes listeners:
            linkaxes([app.UIAxes1, app.UIAxes2, app.UIAxes3], 'x')
            addlistener(app.UIAxes1, 'XLim', 'PostSet', @app.plot_AxesLimitsChanged);
            addlistener(app.UIAxes1, 'YLim', 'PostSet', @app.plot_AxesLimitsChanged);

            % Axes interactions:
            plot.axes.Interactivity.DefaultCreation([app.UIAxes1, app.UIAxes2, app.UIAxes3], [dataTipInteraction, regionZoomInteraction])

            try
                eval(sprintf('opengl %s', app.General.openGL))
            catch
            end
        end
    end


    methods
        %-----------------------------------------------------------------%
        % CUSTOMIZAÇÃO DECORRENTE DA TROCA DO MODO DE OPERAÇÃO
        %-----------------------------------------------------------------%
        function menu_LayoutControl(app, tabIndex)
            switch tabIndex
                case 1 % FILE
                    % ...

                case 2 % PLAYBACK, REPORT, MISC
                    if app.menu_Button2.Value
                        set(app.play_Tree, 'SelectedNodes', app.play_PlotPanel.UserData, 'Multiselect', 'off')

                        app.play_TreePanelVisibility.Visible       = 1;
                        app.play_TreePanelVisibility.UserData.Mode = 'PLAYBACK';

                        app.play_ControlsGrid.RowHeight   = {22,'1x',22,0,22,0,0,0,0,0,0,0};
                        set(findobj(app.play_toolGrid, 'Tag', 'PLAYBACK'),  Visible=1)
                        set(findobj(app.play_toolGrid, 'Tag', 'REPORT'),    Visible=0)
                        set(findobj(app.play_toolGrid, 'Tag', 'FISCALIZA'), Visible=0)

                    elseif app.menu_Button3.Value
                        app.play_Tree.Multiselect = "on";
                        
                        app.play_TreePanelVisibility.Visible       = 0;
                        app.play_TreePanelVisibility.UserData.Mode = 'REPORT';

                        app.play_ControlsGrid.RowHeight = {0,0,0,0,0,0,22,'1x',22,0,0,0};
                        set(findobj(app.play_toolGrid, 'Tag', 'PLAYBACK'),  Visible=0)
                        set(findobj(app.play_toolGrid, 'Tag', 'REPORT'),    Visible=1)
                        set(findobj(app.play_toolGrid, 'Tag', 'FISCALIZA'), Visible=1, Enable=0)

                    elseif app.menu_Button4.Value
                        app.play_Tree.Multiselect = "on";
                        
                        switch app.play_TreePanelVisibility.UserData.Mode
                            case 'PLAYBACK'
                                app.play_TreePanelVisibility.Visible = 1;
                            case 'REPORT'
                                app.play_TreePanelVisibility.Visible = 0;
                        end
                        
                        app.play_ControlsGrid.RowHeight   = {0,0,0,0,0,0,0,0,0,0,22,'1x'};
                        set(findobj(app.play_toolGrid, 'Tag', 'PLAYBACK'),  Visible=0)
                        set(findobj(app.play_toolGrid, 'Tag', 'REPORT'),    Visible=0)
                        set(findobj(app.play_toolGrid, 'Tag', 'FISCALIZA'), Visible=0)
                    end

                    play_TreeSecundaryPanelVisibility(app)
                    play_TreeSelectionChanged(app, struct('Source', 'menu_LayoutControl'))

                otherwise % DRIVETEST, SIGNALANALYSIS, RFDATAHUB, CONFIG
                    % ...
            end
        end

        %-----------------------------------------------------------------%
        function menu_LayoutAuxiliarApp(app, auxiliarApp, operationType, varargin)
            arguments
                app
                auxiliarApp   char {mustBeMember(auxiliarApp,   {'DRIVETEST', 'SIGNALANALYSIS', 'RFDATAHUB', 'CONFIG'})}
                operationType char {mustBeMember(operationType, {'Open', 'Close', 'Undocking'})}
            end

            arguments (Repeating)
                varargin
            end

            switch auxiliarApp
                case 'DRIVETEST'
                    propertyName         = 'hDriveTest';                    
                    dockMenuButton       = app.menu_Button5;
                    dockMenuButtonEnable = true;
                    dockRefMenuButton    = app.menu_Button2; % PLAYBACK
                    dockContainer        = app.drivetest_Container;
                    
                    FileHandle_MFILE     = @auxApp.winDriveTest_exported;
                    FileHandle_MLAPP     = @auxApp.winDriveTest;

                case 'SIGNALANALYSIS'
                    propertyName         = 'hSignalAnalysis';
                    dockMenuButton       = app.menu_Button6;
                    dockMenuButtonEnable = true;
                    dockRefMenuButton    = app.menu_Button3; % REPORT
                    dockContainer        = app.signalanalysis_Container;
                    
                    FileHandle_MFILE     = @auxApp.winSignalAnalysis_exported;
                    FileHandle_MLAPP     = @auxApp.winSignalAnalysis;

                case 'RFDATAHUB'
                    propertyName         = 'hRFDataHub';
                    dockMenuButton       = app.menu_Button7;
                    dockMenuButtonEnable = false;
                    dockRefMenuButton    = app.menu_Button2; % PLAYBACK
                    dockContainer        = app.rfdatahub_Container;
                    
                    FileHandle_MFILE     = @winRFDataHub_exported;
                    FileHandle_MLAPP     = @winRFDataHub;

                case 'CONFIG'
                    propertyName         = 'hConfig';
                    dockMenuButton       = app.menu_Button8;
                    dockMenuButtonEnable = false;
                    dockRefMenuButton    = app.menu_Button2; % PLAYBACK
                    dockContainer        = app.config_Container;
                    
                    FileHandle_MFILE     = @auxApp.winConfig_exported;
                    FileHandle_MLAPP     = @auxApp.winConfig;
            end

            switch operationType
                case 'Open'
                    if isempty(app.(propertyName)) || ~isvalid(app.(propertyName))
                        app.progressDialog.Visible = 'visible';

                        if isempty(varargin)
                            varargin = {app};
                        end

                        if app.General.operationMode.Dock
                            app.(propertyName) = FileHandle_MFILE(dockContainer, varargin{:});

                            set(dockMenuButton, 'Enable', 1, 'Value', 1)
                            menu_mainButtonPushed(app, struct('Source', dockMenuButton, 'PreviousValue', 0))
                        else
                            dockMenuButton.Value = 0;

                            if app.General.operationMode.Debug
                                app.(propertyName) = FileHandle_MLAPP(varargin{:});
                            else
                                app.(propertyName) = FileHandle_MFILE([], varargin{:});
                            end                            
                        end

                        app.progressDialog.Visible = 'hidden';
    
                    else
                        if app.(propertyName).isDocked
                            dockMenuButton.Value = 1;
                            menu_mainButtonPushed(app, struct('Source', dockMenuButton, 'PreviousValue', 0))
                        else
                            figure(app.(propertyName).UIFigure)
                        end
                    end

                otherwise % 'Close'
                    if dockMenuButtonEnable
                        dockMenuButton.Enable = 0;
                    end

                    if dockMenuButton.Value
                        if ~dockRefMenuButton.Enable
                            dockRefMenuButton = app.menu_Button1;
                        end

                        dockRefMenuButton.Value = 1;
                        menu_mainButtonPushed(app, struct('Source', dockRefMenuButton, 'PreviousValue', 0))
                    end

                    delete(app.(propertyName))
                    app.(propertyName) = [];
            end
        end

        %-----------------------------------------------------------------%
        function inputArguments = menu_LayoutUndockingAuxiliarApp(app, auxiliarApp)
            arguments
                app
                auxiliarApp   char {mustBeMember(auxiliarApp,   {'DRIVETEST', 'SIGNALANALYSIS', 'RFDATAHUB', 'CONFIG'})}
            end

            switch auxiliarApp
                case 'DRIVETEST'
                    compatibilityMode = app.hDriveTest.compatibilityMode;
                    [idxThread, idxEmission] = specDataIndex(app.hDriveTest, 'EmissionShowed');
                    inputArguments = {app, compatibilityMode, idxThread, idxEmission};

                case 'SIGNALANALYSIS'
                    idxPrjPeaks = app.hSignalAnalysis.UITable.Selection;
                    inputArguments = {app, idxPrjPeaks};

                case 'RFDATAHUB'
                    filterTable = app.hRFDataHub.filterTable;
                    inputArguments = {app, filterTable};

                otherwise
                    inputArguments = {app};
            end
        end

        %-----------------------------------------------------------------%
        function menu_LayoutPopupApp(app, auxiliarApp)
            % Inicialmente ajusta as dimensões do container.
            switch auxiliarApp
                case 'WelcomePage'
                    screenWidth  = 880;
                    screenHeight = 480;

                case 'Detection'
                    screenWidth  = 412;
                    screenHeight = 282;

                case 'Classification'
                    screenWidth  = 534;
                    screenHeight = 248;
            end

            app.popupContainerGrid.ColumnWidth{2} = screenWidth;
            app.popupContainerGrid.RowHeight{3}   = screenHeight-180;

            % Executa o app auxiliar, mas antes tenta configurar transparência
            % do BackgroundColor do Grid (caso não tenha sido aplicada anteriormente).
            ccTools.compCustomizationV2(app.jsBackDoor, app.popupContainerGrid, 'backgroundColor', 'rgba(255,255,255,0.65')

            switch auxiliarApp
                case 'WelcomePage'
                    auxApp.dockWelcomePage_exported(app.popupContainer, app)

                case 'Detection'
                    auxApp.dockDetection_exported(app.popupContainer, app)

                case 'Classification'
                    auxApp.dockClassification_exported(app.popupContainer, app)
            end

            % Torna visível o container.
            app.popupContainerGrid.Visible = 1;
        end


        %-----------------------------------------------------------------%
        % APAGA COISAS...
        %-----------------------------------------------------------------%
        function DeleteAll(app)
            DeleteProject(app, 'appAnalise:MISC:RestartAnalysis')
            DeleteAuxiliarApps(app)

            file_DataReaderError(app)
            file_specReadButtonVisibility(app)
        end

        %-----------------------------------------------------------------%
        function DeleteProject(app, operationType)
            % Reinicia abas FISCALIZAÇÃO e API FISCALIZA.
            Restart(app.projectData)
            app.report_ProjectName.Value = '';
            app.report_Issue.Value       = -1;       
            app.report_ProjectWarnIcon.Visible = 0;

            fiscalizaLibConnection.report_ResetGUI(app)

            switch operationType
                case 'appAnalise:MISC:RestartAnalysis'
                    % ...

                case 'appAnalise:REPORT:NewProject'
                    % Ajusta specData, além de reiniciar variáveis.
                    idx = find(arrayfun(@(x) x.UserData.reportFlag, app.specData));
                    for ii = idx
                        app.specData(ii).UserData.reportFlag = false;
                    end
        
                    % Apaga a árvore de fluxos a processar, além de retirar o ícone
                    % do relatório na árvore principal de fluxos.
                    report_TreeBuilding(app)

                    % Fecha o app auxiliar SIGNALANALYSIS porque ele demanda 
                    % ao menos um fluxo espectral a processar, o que não existe
                    % neste momento.
                    if ~isempty(app.hSignalAnalysis)
                        menu_LayoutAuxiliarApp(app, 'SIGNALANALYSIS', 'Close')
                    end
            end
        end

        %-----------------------------------------------------------------%
        function DeleteAuxiliarApps(app)
            if ~isempty(app.hDriveTest)
                menu_LayoutAuxiliarApp(app, 'DRIVETEST', 'Close')
            end

            if ~isempty(app.hSignalAnalysis)
                menu_LayoutAuxiliarApp(app, 'SIGNALANALYSIS', 'Close')
            end

            if ~isempty(app.hRFDataHub)
                menu_LayoutAuxiliarApp(app, 'RFDATAHUB', 'Close')
            end
        end
        

        %-----------------------------------------------------------------%
        % ## Modo "ARQUIVO(S)" ##
        %-----------------------------------------------------------------%
        function file_OpenSelectedFiles(app, filePath, fileName)
            d = appUtil.modalWindow(app.UIFigure, 'progressdlg', 'Em andamento a leitura de metadados do(s) arquivo(s) selecionado(s).');            
            
            repeteadFiles = {};
            for ii = 1:numel(fileName)
                d.Message = sprintf('Em andamento a leitura de metadados do arquivo:\n•&thinsp;%s\n\n%d de %d', fileName{ii}, ii, numel(fileName));
                
                fileFullPath  = fullfile(filePath, fileName{ii});
                [~,~,fileExt] = fileparts(fileFullPath);

                relatedFiles  = RelatedFiles(app.metaData);

                switch lower(fileExt)
                    case {'.bin', '.dbm', '.sm1809', '.csv'}
                        if ~any(contains(relatedFiles, fileName(ii), 'IgnoreCase', true))
                            idx = numel(app.metaData)+1;
                            
                            app.metaData(idx).File = fileFullPath;
                            app.metaData(idx).Type = 'Spectral data';
                        else
                            repeteadFiles(end+1) = fileName(ii);
                            continue
                        end
                        
                    case '.mat'
                        lastwarn('')
                        load(fileFullPath, '-mat', 'prj_Type', 'prj_RelatedFiles')
                        [~, warnID] = lastwarn;
                        
                        % Um projeto .MAT pode conter informações geradas por mais
                        % de um arquivo .BIN, por exemplo. Por essa razão, certifica-se
                        % que nenhum dos arquivos relacionados ao projeto já foram 
                        % lidos anteriormente.
                        if strcmp(warnID, 'MATLAB:load:variableNotFound')
                            msgWarning = sprintf('O arquivo indicado a seguir não foi gerado pelo appAnalise ou appColeta.\n•&thinsp;%s', fileName{ii});
                            appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);                                                        
                            continue
                            
                        elseif any(strcmpi(fileFullPath, {app.metaData.File}))
                            msgWarning = sprintf('O arquivo indicado a seguir já tinha sido lido.\n•&thinsp;%s', fileName{ii});
                            appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);                            
                            continue
                            
                        elseif any(contains(relatedFiles, prj_RelatedFiles, 'IgnoreCase', true))
                            msgWarning = sprintf(['O arquivo indicado a seguir não será lido por já ter sido lido ao menos um arquivo relacionado ao ' ...
                                           'projeto appAnalise.\n•&thinsp;%s\n\nArquivo(s) relacionado(s) ao projeto appAnalise já lido(s):\n%s'],   ...
                                           fileName{ii}, strjoin(cellfun(@(x) sprintf('•&thinsp;%s', x), relatedFiles(contains(relatedFiles, prj_RelatedFiles, 'IgnoreCase', true)), 'UniformOutput', false), '\n'));
                            appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);                            
                            continue

                        elseif ~isempty(app.metaData) && strcmp(prj_Type, 'Project data') && ismember('Project data', {app.metaData.Type})
                            msgWarning = sprintf('O arquivo indicado a seguir não será lido porque já foram lidos os metadados de outro projeto appAnalise.\n•&thinsp;%s', fileName{ii});
                            appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);                            
                            continue
                            
                        else
                            idx = numel(app.metaData)+1;
                            
                            app.metaData(idx).File = fileFullPath;
                            app.metaData(idx).Type = prj_Type;
                        end
                end
                
                try
                    % Chama método público da classe "class.metaData".
                    InitialFileReading(app.metaData(idx))

                catch ME
                    appUtil.modalWindow(app.UIFigure, 'error', ME.message);

                    % Se ocorre um erro no processo de leitura, e esse erro
                    % não for um dos mapeados, o objeto app.metaData será reiniciado.
                    switch ME.identifier
                        case {'metaData:Read:NotImplementedReader', 'metaData:Read:UnexpectedFileFormat', 'metaData:Read:EmptySpectralData'}
                            delete(app.metaData(idx))
                            app.metaData(idx) = [];

                        otherwise
                            delete(app.metaData)
                            app.metaData = class.metaData.empty;

                            fclose all;
                            break
                    end
                end
            end
            
            if ~isempty(repeteadFiles)
                msgWarning = sprintf('Os metadados do(s) arquivo(s) indicado(s) a seguir já tinham sido lidos.\n%s', strjoin(strcat("•&thinsp;", repeteadFiles), '\n'));
                appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
            end

            file_TreeBuilding(app)
        end

        %-----------------------------------------------------------------%
        function file_TreeBuilding(app)
            if ~isempty(app.file_Tree.Children)
                delete(app.file_Tree.Children)
                app.file_Tree.UserData.previousSelectedFileIndex = [];
            end

            if ~isempty(app.metaData)
                file_FilterOptions(app)
                file_FilterCheck(app)

                filteredNodes = [];

                for ii = 1:numel(app.metaData)
                    [~, fileName, fileExt] = fileparts(app.metaData(ii).File);
                    
                    fileNode = uitreenode(app.file_Tree, 'Text',        [fileName fileExt],                         ...
                                                         'NodeData',    struct('level', 1, 'idx1', ii, 'idx2', []), ...
                                                         'ContextMenu', app.file_ContextMenu_Tree1);

                    receiverRawList = {app.metaData(ii).Data.Receiver};
                    [receiverList, ~, receiverIndex] = unique(receiverRawList);

                    if isscalar(receiverList) && isscalar(app.metaData(ii).Data)
                        fileNode.NodeData.idx2 = 1;
                    end
                    
                    for jj = 1:numel(receiverList)
                        idx = find(receiverIndex == jj)';

                        receiverNode = uitreenode(fileNode, 'Text',        fcn.treeReceiverName(receiverList{jj}, 'file_TreeBuilding'), ...
                                                            'NodeData',    struct('level', 2, 'idx1', ii, 'idx2', idx),                 ...
                                                            'Icon',        fcn.treeNodeIcon('Receiver', receiverList{jj}),              ...
                                                            'ContextMenu', app.file_ContextMenu_Tree1);                        
                        for kk = idx
                            if ismember(app.metaData(ii).Data(kk).MetaData.DataType, class.Constants.specDataTypes)
                                nodeTextNote = '';
                                nodeIcon     = fcn.treeNodeIcon('DataType', 'SpectralData');

                            elseif ismember(app.metaData(ii).Data(kk).MetaData.DataType, class.Constants.occDataTypes)
                                nodeTextNote = ' (Ocupação)';
                                nodeIcon     = fcn.treeNodeIcon('DataType', 'Occupancy');

                            else
                                error('winAppAnalise:UnexpectedDataType', 'Unexpeted data type %d', app.metaData(ii).Data(kk).MetaData.DataType)
                            end

                            dataNode = uitreenode(receiverNode, 'Text',        sprintf('ID %d: %.3f - %.3f MHz%s', app.metaData(ii).Data(kk).RelatedFiles.ID(1),                       ...
                                                                                                                   app.metaData(ii).Data(kk).MetaData.FreqStart .* 1e-6,               ...
                                                                                                                   app.metaData(ii).Data(kk).MetaData.FreqStop .* 1e-6, nodeTextNote), ...
                                                                'NodeData',    struct('level', 3, 'idx1', ii, 'idx2', kk),                                                             ...
                                                                'Icon',        nodeIcon,                                                                                               ...
                                                                'ContextMenu', app.file_ContextMenu_Tree1);
                            if ~app.metaData(ii).Data(kk).Enable
                                dataNode.Icon = '';
                                filteredNodes = [filteredNodes, dataNode];
                            end
                        end
                    end
                end

                if ~isempty(filteredNodes)
                    addStyle(app.file_Tree, uistyle('FontColor', [.65,.65,.65]), 'node', filteredNodes)
                end

                app.file_Tree.SelectedNodes = app.file_Tree.Children(1);
                file_TreeSelectionChanged(app)

            else
                app.file_Metadata.HTMLSource              = ' ';
                app.file_FilteringType1_Frequency.Items   = {};
                app.file_FilteringType2_ID.Items          = {};
                app.file_FilteringType3_Description.Value = '';
                
            end
            file_specReadButtonVisibility(app)
        end

        %-----------------------------------------------------------------%
        function file_FilterOptions(app)
            bandList = table('Size', [0,3], ...
                             'VariableTypes', {'double', 'double', 'string'}, ...
                             'VariableNames', {'FreqStart', 'FreqStop', 'Band'});
            IDList   = [];
            for ii = 1:numel(app.metaData)
                for jj = 1:numel(app.metaData(ii).Data)

                    FreqStart = app.metaData(ii).Data(jj).MetaData.FreqStart;
                    FreqStop  = app.metaData(ii).Data(jj).MetaData.FreqStop;

                    bandList(end+1,:) = {FreqStart, FreqStop, sprintf('%.3f - %.3f MHz', FreqStart/1e+6, FreqStop/1e+6)};
                    IDList(end+1,1)   = app.metaData(ii).Data(jj).RelatedFiles.ID(1);
                end
            end
            bandList = sortrows(bandList, {'FreqStart', 'FreqStop'});

            app.file_FilteringType1_Frequency.Items = unique(bandList.Band, "rows", "stable");
            app.file_FilteringType2_ID.Items        = unique(string(sort(IDList)), "rows", "stable");
        end

        %-----------------------------------------------------------------%
        function file_FilterCheck(app)
            hFilter = allchild(app.file_FilteringTree);

            if isempty(hFilter)
                for ii = 1:numel(app.metaData)
                    for jj = 1:numel(app.metaData(ii).Data)
                        app.metaData(ii).Data(jj).Enable = true;
                    end
                end

            else
                filterTextList = strjoin({hFilter.Text}, '\n');                
                filterParser   = struct2table(regexp(filterTextList, '(?<Type>(FREQUÊNCIA|ID|DESCRIÇÃO))[:] (?<Sentence>.*)', 'names', 'dotexceptnewline'));
                if ~iscell(filterParser.Sentence)
                    filterParser.Sentence = {filterParser.Sentence};
                end

                filterSentence_Frequency   = filterParser.Sentence(filterParser.Type == "FREQUÊNCIA");
                filterSentence_ID          = str2double(filterParser.Sentence(filterParser.Type == "ID"));
                filterSentence_Description = filterParser.Sentence(filterParser.Type == "DESCRIÇÃO");

                for ii = 1:numel(app.metaData)
                    for jj = 1:numel(app.metaData(ii).Data)
                        app.metaData(ii).Data(jj).Enable = false;

                        % FREQUÊNCIA
                        if ~isempty(filterSentence_Frequency)
                            dataSentence = sprintf('%.3f - %.3f MHz', app.metaData(ii).Data(jj).MetaData.FreqStart .* 1e-6, ...
                                                                      app.metaData(ii).Data(jj).MetaData.FreqStop  .* 1e-6);
                            if ismember(dataSentence, filterSentence_Frequency)
                                app.metaData(ii).Data(jj).Enable = true;
                                continue
                            end
                        end

                        % ID
                        if ~isempty(filterSentence_ID)
                            dataSentence = app.metaData(ii).Data(jj).RelatedFiles.ID(1);

                            if ismember(dataSentence, filterSentence_ID)
                                app.metaData(ii).Data(jj).Enable = true;
                                continue
                            end
                        end

                        % DESCRIÇÃO
                        if ~isempty(filterSentence_Description)
                            dataSentence = app.metaData(ii).Data(jj).RelatedFiles.Description{1};

                            if any(cellfun(@(x) contains(dataSentence, x, "IgnoreCase", true), replace(filterSentence_Description, '"', '')))
                                app.metaData(ii).Data(jj).Enable = true;
                                continue
                            end
                        end
                    end
                end
            end
        end

        %-----------------------------------------------------------------%
        function file_DataReaderError(app)
            if ~isempty(app.specData)
                delete(app.specData)
                app.specData = class.specData.empty;
            end

            set(findobj(app.menu_Grid, 'Type', 'uistatebutton'), 'Enable', 0)
            set(app.menu_Button1, 'Enable', 1, 'Value', 1)
            app.menu_Button7.Enable = 1;

            menu_mainButtonPushed(app, struct('Source', app.menu_Button1, 'PreviousValue', false)) 
        end

        %-----------------------------------------------------------------%
        function file_specReadButtonVisibility(app)
            if ~isempty(app.metaData)
                app.file_SpecReadButton.Visible = 1;
            else
                app.file_SpecReadButton.Visible = 0;
            end
        end


        %-----------------------------------------------------------------%
        % PLAYBACK >> ÁRVORE PRINCIPAL
        %-----------------------------------------------------------------%
        function play_TreeBuilding(app)
            if ~isempty(app.play_Tree.Children)
                delete(app.play_Tree.Children)
            end
            app.play_Metadata.HTMLSource = ' ';

            receiverRawList = {app.specData.Receiver};
            [receiverList, ~, receiverIndex] = unique(receiverRawList);

            for ii = 1:numel(receiverList)
                idx1 = find(receiverIndex == ii)';

                receiverNode = uitreenode(app.play_Tree, 'Text',     fcn.treeReceiverName(receiverList{ii}, 'play_TreeBuilding'), ...
                                                         'NodeData', idx1,                                                        ...
                                                         'Icon',     fcn.treeNodeIcon('Receiver', receiverList{ii}));
                                
                for jj = idx1
                    specNodeText = misc_nodeTreeText(app, jj);
                    if ismember(app.specData(jj).MetaData.DataType, class.Constants.occDataTypes)
                        specNodeText = [specNodeText ' (Ocupação)'];
                    end

                    specNode = uitreenode(receiverNode, 'Text', specNodeText, ...
                                                        'NodeData', jj);

                    % TEMPO DE OBSERVAÇÃO
                    uitreenode(specNode, 'Text', sprintf('%s - %s', datestr(app.specData(jj).Data{1}(1),   'dd/mm/yyyy HH:MM:SS'), ...
                                                                    datestr(app.specData(jj).Data{1}(end), 'dd/mm/yyyy HH:MM:SS')), ...
                                         'NodeData', jj);
                        
                    % GPS
                    if ~app.specData(jj).GPS.Status
                        uitreenode(specNode, 'Text',     'GPS', ...
                                             'NodeData', jj,    ...
                                             'Icon',     'Warn_18.png');
                    else
                        gpsNode = uitreenode(specNode, 'Text', sprintf('%.6f, %.6f (%s)', app.specData(jj).GPS.Latitude,  ...
                                                                                          app.specData(jj).GPS.Longitude, ...
                                                                                          app.specData(jj).GPS.Location), ...
                                                       'NodeData', jj);
                        if app.specData(jj).GPS.Status == -1
                            gpsNode.Icon = 'modeManual_32.png';
                        end
                    end

                    % OCC
                    if ismember(app.specData(jj).MetaData.DataType, class.Constants.specDataTypes)
                        if ~isempty(app.specData(jj).UserData.occMethod.RelatedIndex)
                            occNode = uitreenode(specNode, 'Text', 'Fluxo(s) de ocupação', ...
                                                           'NodeData', jj);
                            
                            idx2 = app.specData(jj).UserData.occMethod.RelatedIndex;
                            for kk = idx2
                                occChildThreadNode = uitreenode(occNode, 'Text', sprintf('Threshold: %d %s (ID %d)', app.specData(kk).MetaData.Threshold,  ...
                                                                                                                     app.specData(kk).MetaData.LevelUnit,  ...
                                                                                                                     app.specData(kk).RelatedFiles.ID(1)), ...
                                                                         'NodeData', jj);

                                if app.specData(jj).UserData.occMethod.SelectedIndex == kk
                                    occChildThreadNode.Icon = 'modeSelected_32.png';
                                end                     
                            end

                            occChildPlaybackNode = uitreenode(occNode, 'Text', 'Ocupação a ser aferida', 'NodeData', jj);
                            if isempty(app.specData(jj).UserData.occMethod.SelectedIndex)
                                occChildPlaybackNode.Icon = 'modeSelected_32.png';
                            end
                        end
                    end
                end
            end
            play_TreeNodeStyle(app)

            for ii = 1:numel(app.play_Tree.Children)
                expand(app.play_Tree.Children(ii));
            end
        end

        %-----------------------------------------------------------------%
        function play_TreeNodeStyle(app)
            % specIndex..: índices dos fluxos de dados de espectro.
            % occIndex...: índices dos fluxos de dados de ocupação.
            % reportIndex: subconjunto de specIndex, representando os índices dos 
            %              fluxos de dados que serão analisados no modo "RELATÓRIO".
        
            removeStyle(app.play_Tree)
        
            hTree1 = allchild(app.play_Tree);
            hTree2 = [];
            for ii = 1:numel(hTree1)
                hTree2 = [hTree2; allchild(hTree1(ii))];
            end
            refTreeIndex = [hTree2.NodeData];
        
            specIndex    = find(arrayfun(@(x) ismember(x.MetaData.DataType, class.Constants.specDataTypes), app.specData));
            reportIndex  = find(arrayfun(@(x) x.UserData.reportFlag, app.specData));
            occIndex     = setdiff(1:numel(app.specData), specIndex);

            [~, specTreeIndex]   = ismember(setdiff(specIndex, reportIndex), refTreeIndex);
            [~, reportTreeIndex] = ismember(reportIndex, refTreeIndex);
            [~, occTreeIndex]    = ismember(occIndex, refTreeIndex);

        
            set(hTree2(specTreeIndex),   Icon=fcn.treeNodeIcon('DataType', 'SpectralData'))
            set(hTree2(reportTreeIndex), Icon='Report_32.png')
            set(hTree2(occTreeIndex),    Icon=fcn.treeNodeIcon('DataType', 'Occupancy'))
        end

        %-----------------------------------------------------------------%
        function play_TreeRebuilding(app, SelectedNodesTextList, hComp)
            arguments
                app
                SelectedNodesTextList
                hComp = []
            end

            % Evidencia células que tiveram os seus valores editados...
            if ~isempty(hComp)
                set(hComp, BackgroundColor='#bfbfbf')
                drawnow
            end
        
            % Desenha novamente a árvore, deixando selecionados os mesmos fluxos espectrais
            % que estavam selecionados quando da edição das suas informações de GPS.
            play_TreeBuilding(app)
            drawnow

            hTreeNodes     = findobj(app.play_Tree, '-not', 'Type', 'uitree');
            hTreeNodeText  = arrayfun(@(x) x.Text, hTreeNodes, "UniformOutput", false);
            hTreeNodeIndex = [];
            for ii = 1:numel(SelectedNodesTextList)
                hTreeNodeIndex = [hTreeNodeIndex, find(strcmp(hTreeNodeText, SelectedNodesTextList{ii}), 1)];
            end
            
            if isempty(hTreeNodeIndex)
                app.play_Tree.SelectedNodes = app.play_Tree.Children(1).Children(1);
            else
                app.play_Tree.SelectedNodes = hTreeNodes(hTreeNodeIndex);
            end
            report_TreeBuilding(app)
        
            % Retira evidência às supracitadas células.
            if ~isempty(hComp)
                set(hComp, BackgroundColor='white')
            end
        end

        %-----------------------------------------------------------------%
        function play_TreeSecundaryPanelVisibility(app)
            switch app.play_TreePanelVisibility.UserData.Mode
                case 'PLAYBACK'
                    if app.play_TreePanelVisibility.UserData.Visible
                        app.play_TreeGrid.RowHeight(4:10)  = {22,'1x',42,0,0,0,0};
                    else
                        app.play_TreeGrid.RowHeight(4:10) = {0,0,0,0,0,0,0};
                    end

                case 'REPORT'
                    app.play_TreeGrid.RowHeight(4:10)  = {0,0,0,22,'1x',15,22};
            end
        end

        %-----------------------------------------------------------------%
        function play_TreeCollapseStyle(app)
            collapse(app.play_Tree, 'all')
            for ii = 1:numel(app.play_Tree.Children)
                expand(app.play_Tree.Children(ii))
            end

            hUnderFocus = [];
            generation = misc_findGenerationOfTreeNode(app, app.play_Tree.SelectedNodes(1));
            
            for ii = 1:numel(app.play_Tree.SelectedNodes)
                hComponent = app.play_Tree.SelectedNodes(ii);
                if isempty(hUnderFocus)
                    hUnderFocus = hComponent;
                end

                switch generation
                    case 2
                        hComponent = hComponent.Parent;
                    case 3
                        hComponent = hComponent.Parent.Parent;
                end
                
                expand(hComponent, 'all')
            end

            scroll(app.play_Tree, hUnderFocus)         
        end


        %-----------------------------------------------------------------%
        % PLAYBACK >> ASPECTOS GERAIS >> OCUPAÇÃO
        %-----------------------------------------------------------------%
        function occInfo = play_OCCInfo(app)
            occInfo = struct('Method',                  app.play_OCC_Method.Value,                      ...
                             'IntegrationTime',         str2double(app.play_OCC_IntegrationTime.Value), ...
                             'IntegrationTimeCaptured', app.play_OCC_IntegrationTimeCaptured.Value,     ...
                             'THR',                     app.play_OCC_THR.Value,                         ...
                             'THRCaptured',             str2double(app.play_OCC_THRCaptured.Value),     ...
                             'Offset',                  app.play_OCC_Offset.Value,                      ...
                             'ceilFactor',              app.play_OCC_ceilFactor.Value,                  ...
                             'noiseFcn',                app.play_OCC_noiseFcn.Value,                    ...
                             'noiseTrashSamples',       app.play_OCC_noiseTrashSamples.Value/100,       ...
                             'noiseUsefulSamples',      app.play_OCC_noiseUsefulSamples.Value/100);

            switch occInfo.Method
                case 'Linear fixo (COLETA)'; occInfo = rmfield(occInfo, {'IntegrationTime',         'THR',         'Offset', 'ceilFactor', 'noiseFcn', 'noiseTrashSamples', 'noiseUsefulSamples'});
                case 'Linear fixo';          occInfo = rmfield(occInfo, {'IntegrationTimeCaptured', 'THRCaptured', 'Offset', 'ceilFactor', 'noiseFcn', 'noiseTrashSamples', 'noiseUsefulSamples'});
                case 'Linear adaptativo';    occInfo = rmfield(occInfo, {'IntegrationTimeCaptured', 'THR', 'THRCaptured', 'ceilFactor'});
                case 'Envoltória do ruído';  occInfo = rmfield(occInfo, {'IntegrationTimeCaptured', 'THR', 'THRCaptured'});
            end
        end

        %-----------------------------------------------------------------%
        function occIndex = play_OCCIndex(app, idx, srcFcn)
            switch srcFcn
                case 'PLAYBACK/REPORT'
                    if isempty(app.specData(idx).UserData.reportOCC)
                        occInfo = play_OCCInfo(app);
                    else
                        occInfo = app.specData(idx).UserData.reportOCC;
                    end
                    play_OCCLayoutStartup(app, idx)

                case 'PLAYBACK'
                    occInfo = play_OCCInfo(app);

                case 'REPORT'
                    occInfo = app.specData(idx).UserData.reportOCC;
            end
            
            occIndex = find(cellfun(@(x) isequal(x, occInfo), {app.specData(idx).UserData.occCache.Info}));
            
            if isempty(occIndex)
                occIndex = numel(app.specData(idx).UserData.occCache)+1;
                occTHR   = class.OCC.Threshold(app.specData(idx), occInfo);

                switch occInfo.Method
                    case 'Linear fixo (COLETA)'
                        occData = app.specData(app.specData(idx).UserData.occMethod.SelectedIndex).Data;

                    otherwise
                        app.specData(idx).UserData.occMethod.SelectedIndex = [];
                        occData = class.OCC.Analysis(app.specData(idx), occInfo, occTHR);
                end

                app.specData(idx).UserData.occCache(occIndex) = struct('Info',  occInfo, ...
                                                                       'THR',   occTHR,  ...
                                                                       'Data', {occData});
            end

            app.specData(idx).UserData.occMethod.CacheIndex   = occIndex;
        end

        %-----------------------------------------------------------------%
        function selectedTreeNode = play_OCCSelectedTreeNode(app, idx)
            selectedTreeNode = [];
            for ii = 1:numel(app.play_Tree.Children)
                for jj = 1:numel(app.play_Tree.Children(ii).Children)
                    if app.play_Tree.Children(ii).Children(jj).NodeData == idx
                        selectedTreeNode = app.play_Tree.Children(ii).Children(jj);
                        break
                    end
                end
            end
        end

        %-----------------------------------------------------------------%
        function play_OCCSelectedTreeNodeIconUpdate(app, idx1)

            selectedTreeNode = play_OCCSelectedTreeNode(app, idx1);

            switch app.play_OCC_Method.Value
                case 'Linear fixo (COLETA)'
                    idx2 = find(strcmp(app.play_OCC_THRCaptured.Items, app.play_OCC_THRCaptured.Value), 1);
                    if isempty(app.specData(idx1).UserData.occMethod.SelectedIndex) || ...
                            (app.specData(idx1).UserData.occMethod.SelectedIndex ~= app.specData(idx1).UserData.occMethod.RelatedIndex(idx2))
                        app.specData(idx1).UserData.occMethod.SelectedIndex = app.specData(idx1).UserData.occMethod.RelatedIndex(idx2);
                    end                    

                otherwise
                    if ~isempty(app.specData(idx1).UserData.occMethod.RelatedIndex)
                        app.specData(idx1).UserData.occMethod.SelectedIndex = [];
                        idx2 = numel(selectedTreeNode.Children(end).Children);
                    end
            end
   
            if exist('idx2', 'var')
                set(selectedTreeNode.Children(end).Children, Icon='')
                selectedTreeNode.Children(end).Children(idx2).Icon = 'modeSelected_32.png';
            end
        end

        %-----------------------------------------------------------------%
        function play_OCCNewPlot(app)
            if ~isempty(app.play_PlotPanel.UserData) && isvalid(app.play_PlotPanel.UserData)
                idx = app.play_PlotPanel.UserData.NodeData;
    
                % Layout
                play_OCCSelectedTreeNodeIconUpdate(app, idx)
                if strcmp(app.play_OCC_Method.Value, 'Linear fixo (COLETA)')
                    idxOCC = app.specData(idx).UserData.occMethod.SelectedIndex;
    
                    app.play_OCC_THRCaptured.Value = num2str(app.specData(idxOCC).MetaData.Threshold);
                    app.play_OCC_IntegrationTimeCaptured.Value = mean(app.specData(idxOCC).RelatedFiles.RevisitTime)/60;
                end
                play_OCCLayoutVisibility(app, app.bandObj.LevelUnit)
                
                % Ao trocar qualquer um dos parâmetros relacionados aos métodos
                % de ocupação embarcados no appAnalise, afere-se, novamente, a
                % ocupação por bin. Isso, contudo, somente ocorre se estiver
                % habilitado o botão de ocupação, deixando visível o resultado
                % no app.axes2.
    
                % Ao inserir um fluxo de espectro para compor o relatório, será
                % definido um método de aferição de ocupação, caso ainda não
                % feita nenhuma simulação. Neste caso, a alteração dos parâmetros 
                % também irão refletir no algoritmo que será aplicado para fins
                % de geração do relatório.
    
                if app.axesTool_Occupancy.UserData.Value
                    % Aferição da ocupação (armazenada no campo "occCache" da 
                    % propriedade "UserData" de app.specData).
                    occIndex = play_OCCIndex(app, idx, 'PLAYBACK');
    
                    % Avalia se o fluxo que está sendo alterado foi incluído no
                    % modo relatório e este é exatamente o fluxo selecionado.
                    if app.specData(idx).UserData.reportFlag
                        app.specData(idx).UserData.reportOCC = app.specData(idx).UserData.occCache(occIndex).Info;
    
                        idxOCC = [];
                        if ~isempty(app.play_Tree.SelectedNodes)
                            idxOCC = unique([app.play_Tree.SelectedNodes.NodeData]);
                        end
        
                        report_Algorithms(app, idxOCC)
                    end
        
                    % Plot                    
                    plot.old_OCC(app, idx, 'Creation', occIndex)
                end
            end
        end

        %-----------------------------------------------------------------%
        function play_OCCLayoutStartup(app, idx)        
            % Ajuste dos itens de app.play_OCC_Method, o qual depende da existência
            % de fluxos de ocupação relacionados aos fluxos de espectro. Lembrando
            % que atualmente os fluxos de ocupação são aqueles gerados pelo Logger.
            if isempty(app.specData(idx).UserData.occMethod.RelatedIndex)
                app.play_OCC_Method.Items      = {'Linear fixo', 'Linear adaptativo', 'Envoltória do ruído'};
                app.play_OCC_THRCaptured.Items = {};        
            else
                app.play_OCC_Method.Items      = {'Linear fixo (COLETA)', 'Linear fixo', 'Linear adaptativo', 'Envoltória do ruído'};
                app.play_OCC_THRCaptured.Items = arrayfun(@(x) num2str(x.MetaData.Threshold), app.specData(app.specData(idx).UserData.occMethod.RelatedIndex), 'UniformOutput', false);
            end        
            
            % Caso não esteja habilitado o botão de ocupação, então o painel de
            % ocupação é desabilitado. Se o fluxo de espectro possui habilitado a 
            % customização do playback, então os campos de todos os principais painéis 
            % (Persistência, Ocupação e Waterfall) serão atualizados em 
            % "layoutFcn.customPlayback".
            % Caso essa funcionalidade não tenha sido habilitada, é necessária
            % atualizadar os valores do painel de Ocupação.
            if app.axesTool_Occupancy.Enable
                play_OCCLayoutUpdate(app, idx)
                play_OCCLayoutVisibility(app, app.specData(idx).MetaData.LevelUnit)        
            else
                hComponents = findobj(app.play_OCCGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigrid', '-or', 'Type', 'uipanel'});
                set(hComponents, Enable=0)
            end
        end
        
        %-----------------------------------------------------------------%
        function play_OCCLayoutUpdate(app, idx)        
            if isempty(app.specData(idx).UserData.occMethod.CacheIndex)
                SelectedIndex = app.specData(idx).UserData.occMethod.SelectedIndex;
                
                if ~isempty(SelectedIndex)
                    app.play_OCC_Method.Value                  = 'Linear fixo (COLETA)';
                    app.play_OCC_IntegrationTimeCaptured.Value = mean(app.specData(SelectedIndex).RelatedFiles.RevisitTime)/60;
                    app.play_OCC_THRCaptured.Value             = num2str(app.specData(SelectedIndex).MetaData.Threshold);
                end        
            else
                occIndex = app.specData(idx).UserData.occMethod.CacheIndex;
                occInfo  = app.specData(idx).UserData.occCache(occIndex).Info;
            
                app.play_OCC_Method.Value = occInfo.Method;
            
                switch occInfo.Method
                    case 'Linear fixo (COLETA)'
                        app.play_OCC_IntegrationTimeCaptured.Value = occInfo.IntegrationTimeCaptured;
                        app.play_OCC_THRCaptured.Value             = num2str(occInfo.THRCaptured);
            
                    case 'Linear fixo'
                        app.play_OCC_IntegrationTime.Value         = num2str(occInfo.IntegrationTime);
                        app.play_OCC_THR.Value                     = occInfo.THR;
            
                    otherwise % 'Linear adaptativo' | 'Envoltória do ruído'            
                        app.play_OCC_IntegrationTime.Value         = num2str(occInfo.IntegrationTime);
                        app.play_OCC_Offset.Value                  = occInfo.Offset;
                        app.play_OCC_noiseFcn.Value                = occInfo.noiseFcn;
                        app.play_OCC_noiseTrashSamples.Value       = 100 * occInfo.noiseTrashSamples;
                        app.play_OCC_noiseUsefulSamples.Value      = 100 * occInfo.noiseUsefulSamples;
            
                        if strcmp(occInfo.Method, 'Envoltória do ruído')
                            app.play_OCC_ceilFactor.Value          = occInfo.ceilFactor;
                        end
                end
            end
        end

        %-----------------------------------------------------------------%
        function play_OCCLayoutVisibility(app, LevelUnit)
            hComponents = findobj(app.play_OCCGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigrid', '-or', 'Type', 'uipanel'});
            set(hComponents, Enable=1)
        
            switch app.play_OCC_Method.Value
                case 'Linear fixo (COLETA)'
                    set(app.play_OCC_IntegrationTime,         Visible=0, Enable=0)
                    set(app.play_OCC_IntegrationTimeCaptured, Visible=1)
        
                    set(app.play_OCC_THRLabel,        Visible=1)
                    set(app.play_OCC_THR,             Visible=0)
                    set(app.play_OCC_THRCaptured,     Visible=1)
        
                    set(app.play_OCC_OffsetLabel,     Visible=0)
                    set(app.play_OCC_Offset,          Visible=0, Enable=0)
                    
                    set(app.play_OCC_ceilFactorLabel, Visible=0)
                    set(app.play_OCC_ceilFactor,      Visible=0, Enable=0)
        
                    set(app.play_OCC_noiseLabel,      Visible=0)
                    set(app.play_OCC_noisePanel,      Visible=0)
                    set(findobj(app.play_OCC_noiseGrid.Children, '-not', 'Type', 'uilabel'), Enable=0)
        
                    play_OCCLayoutVisibilityUpdate(app, LevelUnit)
        
                case 'Linear fixo'
                    set(app.play_OCC_IntegrationTime,         Visible=1)
                    set(app.play_OCC_IntegrationTimeCaptured, Visible=0, Enable=0)
        
                    set(app.play_OCC_THRLabel,        Visible=1)
                    set(app.play_OCC_THR,             Visible=1)
                    set(app.play_OCC_THRCaptured,     Visible=0)
        
                    set(app.play_OCC_OffsetLabel,     Visible=0)
                    set(app.play_OCC_Offset,          Visible=0, Enable=0)
                    
                    set(app.play_OCC_ceilFactorLabel, Visible=0)
                    set(app.play_OCC_ceilFactor,      Visible=0, Enable=0)
        
                    set(app.play_OCC_noiseLabel,      Visible=0)
                    set(app.play_OCC_noisePanel,      Visible=0)
                    set(findobj(app.play_OCC_noiseGrid.Children, '-not', 'Type', 'uilabel'), Enable=0)
        
                    play_OCCLayoutVisibilityUpdate(app, LevelUnit)
        
                otherwise % {'Linear adaptativo', 'Envoltória do ruído adaptativo'}
                    set(app.play_OCC_IntegrationTime,         Visible=1)
                    set(app.play_OCC_IntegrationTimeCaptured, Visible=0, Enable=0)
        
                    set(app.play_OCC_THRLabel,    Visible=0)
                    set(app.play_OCC_THR,         Visible=0, Enable=0)
                    set(app.play_OCC_THRCaptured, Visible=0, Enable=0)
                    
                    set(app.play_OCC_OffsetLabel, Visible=1)
                    set(app.play_OCC_Offset,      Visible=1)
        
                    set(app.play_OCC_noiseLabel,  Visible=1)
                    set(app.play_OCC_noisePanel,  Visible=1)
        
                    switch app.play_OCC_Method.Value
                        case'Linear adaptativo'
                            set(app.play_OCC_ceilFactorLabel, Visible=0)
                            set(app.play_OCC_ceilFactor,      Visible=0, Enable=0)
        
                        case 'Envoltória do ruído'
                            set(app.play_OCC_ceilFactorLabel, Visible=1)
                            set(app.play_OCC_ceilFactor,      Visible=1)
                    end
            end
        end        
        
        %-------------------------------------------------------------------------%
        function play_OCCLayoutVisibilityUpdate(app, LevelUnit)        
            app.play_OCC_THRLabel.Text = sprintf('Valor (%s):', LevelUnit);
        
            switch LevelUnit
                case 'dBm'
                    if app.play_OCC_THR.Value > 0                            
                        app.play_OCC_THR.Value = -80;
                    end        
                case 'dBµV'
                    if app.play_OCC_THR.Value < 0
                        app.play_OCC_THR.Value = 27;
                    end
                case 'dBµV/m'
                    if app.play_OCC_THR.Value < 0
                        app.play_OCC_THR.Value = 40;
                    end
            end
        end


        %-----------------------------------------------------------------%
        % % PLAYBACK >> CANAIS
        %-----------------------------------------------------------------%
        function play_Channel_TreeBuilding(app, idx, srcFcn)
            if ~isempty(app.play_Channel_Tree.Children)
                delete(app.play_Channel_Tree.Children)                
            end

            % Canais incluídos automaticamente, os quais constam em "ChannelLib.json".
            channelLibIndex = app.specData(idx).UserData.channelLibIndex;
            if ~isempty(channelLibIndex)
                for ii = channelLibIndex'
                    uitreenode(app.play_Channel_Tree, 'Text', sprintf('%.3f - %.3f MHz (%s)',             ...
                                                                      app.channelObj.Channel(ii).Band(1), ...
                                                                      app.channelObj.Channel(ii).Band(2), ...
                                                                      app.channelObj.Channel(ii).Name),   ...
                                                      'NodeData', struct('src', 'channelLib', 'idx', ii), ...
                                                      'ContextMenu', app.play_Channel_ContextMenu);
                end
            end

            % Canais incluídos manualmente pelo usuário.
            channelManual = app.specData(idx).UserData.channelManual;
            if ~isempty(channelManual)
                manualNodes   = [];
                for kk = 1:numel(channelManual)
                    if channelManual(kk).FirstChannel == channelManual(kk).LastChannel
                        treeText = sprintf('%.3f MHz (%s)', channelManual(kk).FirstChannel, channelManual(kk).Name);
                    else
                        treeText = sprintf('%.3f - %.3f MHz (%s)', channelManual(kk).FirstChannel, channelManual(kk).LastChannel, channelManual(kk).Name);
                    end
    
                    manualNodes = [manualNodes, uitreenode(app.play_Channel_Tree, 'Text', treeText,                               ...
                                                                                  'NodeData', struct('src', 'manual', 'idx', kk), ...
                                                                                  'ContextMenu', app.play_Channel_ContextMenu)];
                end            
                addStyle(app.play_Channel_Tree, uistyle('FontColor', '#c94756'), 'node', manualNodes)
            end

            % Seleciona o primeiro fluxo e chama TreeSelectionChanged, caso
            % aplicável.
            if ~isempty(app.play_Channel_Tree.Children)
                app.play_Channel_Tree.SelectedNodes = app.play_Channel_Tree.Children(1);
            end
            play_Channel_TreeSelectionChanged(app, struct('Source', srcFcn))
        end

        %-----------------------------------------------------------------%
        function play_ChannelListSample(app, FreqList)
            nFreqList = numel(FreqList);

            if nFreqList == 0
                app.play_Channel_Sample.Text = '';
            elseif nFreqList <= 4
                app.play_Channel_Sample.Text = strjoin(string(FreqList) + " MHz", ', ');
            else
                app.play_Channel_Sample.Text = strjoin(string(FreqList(1:2)) + " MHz", ', ') + " ... " + strjoin(string(FreqList(end-1:end)) + " MHz", ', ');
            end
        end

        %-----------------------------------------------------------------%
        function play_BandLimits_updateEmissions(app, idx, newIndex, updatePlotFlag)
            % Analisa se as emissões incluídas/editadas pertencem às subfaixas 
            % sob análise. 
            %
            % Trigger:
            % (a) Inclusão automática de emissões. 
            %     Callback "play_FindPeaks_addEmission(app, event)"
            % (b) Edição manual da frequência central da emissão selecionada.
            %     Callback "play_FindPeaks_editEmission(app, event)"
            % (c) Ajuste do ROI, diretamente no eixo.
            %     Função auxiliar à "plot.draw2D.ClearWrite_old" ("mkrLineROI")
            % (d) Inclusão automática de emissões na geração do relatório.
            %     Função externa report.ReportGenerator_Peaks(...)
            arguments
                app
                idx
                newIndex
                updatePlotFlag = true
            end

            fcn.Detection_BandLimits(app.specData(idx))

            if updatePlotFlag
                selectedEmission = find(app.specData(idx).UserData.Emissions.Index == newIndex(1), 1);
                if isempty(selectedEmission)
                    if ~isempty(app.specData(idx).UserData.Emissions)
                        selectedEmission = 1;
                    else
                        delete(app.hSelectedEmission)
                        app.hSelectedEmission = [];
                    end
                end
                plot.draw2D.ClearWrite_old(app, idx, 'PeakValueChanged', selectedEmission)
            end
        end

        %-----------------------------------------------------------------%
        function play_BandLimits_Layout(app, idx)

            if app.play_BandLimits_Status.Value
                app.specData(idx).UserData.bandLimitsStatus = true;
                
                set(app.play_BandLimits_Grid.Children, Enable=1)
                app.play_BandLimits_add.Enable  = 1;
                app.play_BandLimits_Tree.Enable = 1;

            else
                app.specData(idx).UserData.bandLimitsStatus = false;

                set(findobj(app.play_BandLimits_Grid, 'Type', 'uinumericeditfield'), Enable=0)
                app.play_BandLimits_add.Enable  = 0;
                app.play_BandLimits_Tree.Enable = 0;
            end
        end

        %-----------------------------------------------------------------%
        function play_BandLimits_TreeBuilding(app, idx)
            
            if ~isempty(app.play_BandLimits_Tree.Children)
                delete(app.play_BandLimits_Tree.Children)
            end

            bandLimitsTable = app.specData(idx).UserData.bandLimitsTable;
            for ii = 1:height(bandLimitsTable)
                uitreenode(app.play_BandLimits_Tree, 'Text', sprintf('%.3f - %.3f MHz', bandLimitsTable.FreqStart(ii), bandLimitsTable.FreqStop(ii)), ...
                                                     'NodeData', ii, 'ContextMenu', app.play_BandLimits_ContextMenu);
            end
        end


        %-----------------------------------------------------------------%
        % PLAYBACK >> EMISSÕES
        %-----------------------------------------------------------------%
        function play_EmissionList(app, idx, selectedEmission)
            if ~isempty(app.play_FindPeaks_Tree.Children)
                delete(app.play_FindPeaks_Tree.Children)
            end

            if ~isempty(app.specData(idx).UserData.Emissions)
                emissionTable = app.specData(idx).UserData.Emissions;

                for ii = 1:height(emissionTable)
                    if emissionTable.isTruncated(ii)
                        Icon = 'signalTruncated_32.png';
                    else
                        Icon = 'signalUntruncated_32.png';
                    end

                    if isempty(emissionTable.UserData(ii).DriveTest)
                        DriveTestFlag = '';
                    else
                        DriveTestFlag = ' (DT)';
                    end

                    uitreenode(app.play_FindPeaks_Tree, 'Text', sprintf('%d: %.3f MHz ⌂ %.1f kHz%s', ii, emissionTable.Frequency(ii), emissionTable.BW(ii), DriveTestFlag), ...
                                                        'NodeData', ii, 'Icon', Icon, 'ContextMenu', app.play_FindPeaks_ContextMenu);
                end

                app.play_FindPeaks_Tree.SelectedNodes = app.play_FindPeaks_Tree.Children(selectedEmission);
            end
            play_FindPeaks_TreeSelectionChanged(app)
        end

        %-----------------------------------------------------------------%
        function play_AddEmission2List(app, idxThread, newEmissionIndex, newEmissionFrequency, newEmissionBW, newEmissionMethod)
            idx = app.play_PlotPanel.UserData.NodeData;

            NN = numel(newEmissionIndex);
            emissionUserData = repmat(class.userData.emissionUserDataTemplate(), NN, 1);
            
            app.specData(idxThread).UserData.Emissions(end+1:end+NN,1:6) = table(newEmissionIndex,     ...
                                                                                 newEmissionFrequency, ...
                                                                                 newEmissionBW,        ...
                                                                                 true(NN, 1),          ...
                                                                                 newEmissionMethod,    ...
                                                                                 emissionUserData);

            play_BandLimits_updateEmissions(app, idxThread, newEmissionIndex, idx==idxThread)
            play_UpdatePeaksTable(app, idxThread, 'playback.AddEditOrDeleteEmission')
        end

        %-----------------------------------------------------------------%
        function play_UpdatePeaksTable(app, idxThreads, operationType)
            idxReport = find(arrayfun(@(x) x.UserData.reportFlag, app.specData));

            if isempty(idxReport)
                if ~isempty(app.hSignalAnalysis)
                    menu_LayoutAuxiliarApp(app, 'SIGNALANALYSIS', 'Close')
                end
            else
                if any(ismember(idxThreads, idxReport))
                    report.Controller(app, operationType)
    
                    if ~isempty(app.hSignalAnalysis) && isvalid(app.hSignalAnalysis)
                        idxPrjPeaks = app.hSignalAnalysis.UITable.Selection;
                        renderProjectDataOnScreen(app.hSignalAnalysis, idxPrjPeaks)
                    end
                end
            end

            if ~isempty(app.hDriveTest) && isvalid(app.hDriveTest)
                EmissionListUpdated(app.hDriveTest)
            end
        end

        
        %-----------------------------------------------------------------%
        % ## LAYOUT ##
        %-----------------------------------------------------------------%
        function play_Layout_PersistancePanel(app)
            % Lista de componentes passíveis de mudança no seus status, a
            % depender do plot Persistance.
            hComponents = [app.play_Persistance_cLim1, ...
                           app.play_Persistance_cLim2, ...
                           app.play_Persistance_cLim_Mode];

            if ~isempty(app.hPersistanceObj)
                set(hComponents, 'Enable', 1)

                if ~strcmp(app.play_Persistance_WindowSize.Value, 'full')
                    app.play_Persistance_cLim_Mode.Enable = 0;
                    set(app.play_Persistance_cLim_Grid2.Children, 'Enable', 0)
                end

                app.restoreView(1).cLim = app.UIAxes1.CLim;
                app.play_Persistance_cLim1.Value = app.UIAxes1.CLim(1);
                app.play_Persistance_cLim2.Value = app.UIAxes1.CLim(2);

            else
                set(hComponents, 'Enable', 0)
            end
        end

        %-----------------------------------------------------------------%
        function play_Layout_WaterfallPanel(app)
            % Lista de componentes passíveis de mudança no seus status, a
            % depender do plot Waterfall.
            hComponents = [app.play_Waterfall_Decimation, ...
                           app.play_Waterfall_MeshStyle,  ...
                           app.play_Waterfall_Colorbar,   ...
                           app.play_Waterfall_cLim1,      ...                           
                           app.play_Waterfall_cLim2,      ...
                           app.play_Waterfall_cLim_Mode];

            if app.axesTool_Waterfall.UserData.Value
                switch app.play_Waterfall_Fcn.Value
                    case 'image'
                        set(hComponents(3:end), 'Enable', 1)
                        app.play_Waterfall_Decimation.Value = 'auto';

                    case 'mesh'
                        set(hComponents, 'Enable', 1)
                end    

                app.restoreView(3).yLim = app.UIAxes3.YLim;
                app.restoreView(3).cLim = app.UIAxes3.CLim;

                app.play_Waterfall_cLim1.Value = double(app.UIAxes3.CLim(1));
                app.play_Waterfall_cLim2.Value = double(app.UIAxes3.CLim(2));

            else
                set(hComponents, 'Enable', 0)
            end
        end


        %-----------------------------------------------------------------%
        % ## PLOT ##
        %-----------------------------------------------------------------%
        function prePlot_restartProperties(app, axesLimits)
            cla([app.UIAxes1, app.UIAxes2, app.UIAxes3])

            app.UIAxes1.UserData.CLimMode = 'auto';
            app.UIAxes3.UserData.CLimMode = 'auto';

            app.restoreView(1) = struct('ID', 'app.UIAxes1', 'xLim', axesLimits.xLim, 'yLim', axesLimits.yLevelLim, 'cLim', 'auto');
            app.restoreView(2) = struct('ID', 'app.UIAxes2', 'xLim', axesLimits.xLim, 'yLim', [0, 100],             'cLim', 'auto');
            app.restoreView(3) = struct('ID', 'app.UIAxes3', 'xLim', axesLimits.xLim, 'yLim', axesLimits.yTimeLim,  'cLim', axesLimits.cLim);
        
            app.hClearWrite       = [];
            app.hMinHold          = [];
            app.hAverage          = [];
            app.hMaxHold          = [];
            app.hPersistanceObj   = [];
            app.hSelectedEmission = [];
            app.hEmissionMarkers  = [];
            app.hTHR              = [];
            app.hTHRLabel         = [];
            app.hWaterfall        = [];
            app.hWaterfallTime    = [];

            app.idxTime = 1;
            app.tool_TimestampSlider.Value = 0;
        end

        %-----------------------------------------------------------------%
        function prePlot_checkNSweepsAndDataType(app, idx)
            if app.bandObj.nSweeps > 2                
                app.axesTool_Persistance.Enable = 1;
                app.axesTool_Waterfall.Enable   = 1;

                if ~ismember(app.specData(idx).MetaData.DataType, class.Constants.occDataTypes)
                    app.axesTool_Occupancy.Enable = 1;
                else
                    app.axesTool_Occupancy.Enable = 0;
                    app.axesTool_Occupancy.UserData.Value = false;
                    
                    plot.old_OCC(app, idx, 'Delete', [])                    % !! PONTO DE REVISÃO !!
                end
            else                
                app.axesTool_Persistance.Enable = 0;
                app.axesTool_Persistance.UserData.Value = false;

                app.axesTool_Waterfall.Enable   = 0;
                app.axesTool_Waterfall.UserData.Value = false;

                app.axesTool_Occupancy.Enable   = 0;
                app.axesTool_Occupancy.UserData.Value = false;

                plot.old_OCC(app, idx, 'Delete', [])                        % !! PONTO DE REVISÃO !!           
            end
        end

        %-----------------------------------------------------------------%
        function treeNode = prePlot_findSelectedNodeRoot(app, idx)
            hTreeNodes     = findobj(app.play_Tree, '-not', 'Type', 'uitree');
            hTreeNodeData  = arrayfun(@(x) x.NodeData, hTreeNodes, "UniformOutput", false);
            hTreeNodeIndex = find(cellfun(@(x) isequal(idx, x), hTreeNodeData))';
        
            for ii = hTreeNodeIndex
                generation = misc_findGenerationOfTreeNode(app, hTreeNodes(ii));
                if generation == 1
                    treeNode = hTreeNodes(ii);
                    break
                end
            end
        end

        %-----------------------------------------------------------------%
        function prePlot_HTMLPanels(app, idxThread)
            app.play_Metadata.HTMLSource  = fcn.htmlCode_ThreadInfo(app.specData, idxThread);

            ysecondarylabel(app.UIAxes1, {app.specData(idxThread).Receiver; sprintf('%.3f - %.3f MHz', app.bandObj.FreqStart, app.bandObj.FreqStop)})            
            app.tool_TimestampLabel.Text  = sprintf('1 de %d\n%s', app.bandObj.nSweeps, app.specData(idxThread).Data{1}(1));
        end

        %-----------------------------------------------------------------%
        function prePlot_customPlayback(app, idx)
            % Em relação à customização do PLAYBACK,
            % (a) Até a v. 1.67, o appAnalise possibilitava a customização de onze parâmetros
            %     do PLAYBACK. Desde a v. 1.80, o app aumentou esse número para vinte
            %     (praticamente todos!). Além disso, os nomes dos parâmetros foram compactados, 
            %     o que demandou ajuste no leitor .MAT, mantendo a compatibilidade com os .MAT
            %     gerado em versões anteriores do app.
            
            % (b) A atualização do componente app.play_LayoutRatio deve ser posterior
            %     à atualização dos componentes app.play_Occupancy e app.play_Waterfall.
            
            % (c) A atualização dos limites dos eixos x e y é realizada automaticamente,
            %     seguindo os limites do eixos app.axes1.
            %     addlistener(app.axes1, 'XLim', 'PostSet', @app.plot_xLimitsUpdate);
            %     addlistener(app.axes1, 'YLim', 'PostSet', @app.plot_yLimitsUpdate);

            switch app.specData(idx).UserData.customPlayback.Type
                case 'auto'
                    app.play_Customization.Value = 0;

                case 'manual'
                    app.play_Customization.Value = 1;

                    app.axesTool_MinHold.UserData.Value      = app.specData(idx).UserData.customPlayback.Parameters.Controls.MinHold;
                    app.axesTool_Average.UserData.Value      = app.specData(idx).UserData.customPlayback.Parameters.Controls.Average;
                    app.axesTool_MaxHold.UserData.Value      = app.specData(idx).UserData.customPlayback.Parameters.Controls.MaxHold;
                    app.axesTool_Persistance.UserData.Value  = app.specData(idx).UserData.customPlayback.Parameters.Controls.Persistance;
                    app.axesTool_Occupancy.UserData.Value    = app.specData(idx).UserData.customPlayback.Parameters.Controls.Occupancy;
                    app.axesTool_Waterfall.UserData.Value    = app.specData(idx).UserData.customPlayback.Parameters.Controls.Waterfall;
        
                    app.play_LayoutRatio.Items   = {app.specData(idx).UserData.customPlayback.Parameters.Controls.LayoutRatio};
                    plot.axes.Layout.RatioAspect([app.UIAxes1, app.UIAxes2, app.UIAxes3], app.axesTool_Occupancy.UserData.Value, app.axesTool_Waterfall.UserData.Value, app.play_LayoutRatio)
                    
                    app.play_Persistance_Interpolation.Value = app.specData(idx).UserData.customPlayback.Parameters.Persistance.Interpolation;
                    app.play_Persistance_WindowSize.Value    = app.specData(idx).UserData.customPlayback.Parameters.Persistance.WindowSize;
                    app.play_Persistance_Transparency.Value  = app.specData(idx).UserData.customPlayback.Parameters.Persistance.Transparency;
                    app.play_Persistance_Colormap.Value      = app.specData(idx).UserData.customPlayback.Parameters.Persistance.Colormap;
        
                    if app.play_Persistance_WindowSize.Value == "full"
                        app.play_Persistance_cLim1.Value = app.specData(idx).UserData.customPlayback.Parameters.Persistance.LevelLimits(1);
                        app.play_Persistance_cLim2.Value = app.specData(idx).UserData.customPlayback.Parameters.Persistance.LevelLimits(2);
                    end

                    % A visibilidade e posição da Colobar não é tratada como 
                    % customização do playback... e por isso o componente
                    % específico não é atualizado com a informação presente
                    % em app.specData.
                    app.play_Waterfall_Fcn.Value         = app.specData(idx).UserData.customPlayback.Parameters.Waterfall.Fcn;
                    app.play_Waterfall_Decimation.Value  = app.specData(idx).UserData.customPlayback.Parameters.Waterfall.Decimation;
                    app.play_Waterfall_MeshStyle.Value   = app.specData(idx).UserData.customPlayback.Parameters.Waterfall.MeshStyle;            
                    app.play_Waterfall_Colormap.Value    = app.specData(idx).UserData.customPlayback.Parameters.Waterfall.Colormap;
                    app.play_Waterfall_cLim1.Value       = app.specData(idx).UserData.customPlayback.Parameters.Waterfall.LevelLimits(1);
                    app.play_Waterfall_cLim2.Value       = app.specData(idx).UserData.customPlayback.Parameters.Waterfall.LevelLimits(2);        
                    app.play_Waterfall_Timeline.Value    = app.specData(idx).UserData.customPlayback.Parameters.WaterfallTime.Visible;
            end
        end

        %-----------------------------------------------------------------%
        function prePlot_updatingGeneralSettings(app)
            app.General.Plot.Persistance = struct('Interpolation', app.play_Persistance_Interpolation.Value, ...
                                                  'WindowSize',    app.play_Persistance_WindowSize.Value,    ...
                                                  'Transparency',  app.play_Persistance_Transparency.Value,  ...
                                                  'Colormap',      app.play_Persistance_Colormap.Value,      ...
                                                  'LevelLimits',  [app.play_Persistance_cLim1.Value, app.play_Persistance_cLim2.Value]);


            app.General.Plot.Waterfall   = struct('Fcn',           app.play_Waterfall_Fcn.Value,        ...
                                                  'Decimation',    app.play_Waterfall_Decimation.Value, ...
                                                  'MeshStyle',     app.play_Waterfall_MeshStyle.Value,  ...
                                                  'Colormap',      app.play_Waterfall_Colormap.Value,   ...
                                                  'Colorbar',      app.play_Waterfall_Colorbar.Value,   ...
                                                  'LevelLimits',  [app.play_Waterfall_cLim1.Value, app.play_Waterfall_cLim2.Value]);

            app.General.Plot.WaterfallTime.Visible = app.play_Waterfall_Timeline.Value;

            if app.axesTool_Persistance.UserData.Value && strcmp(app.UIAxes1.UserData.CLimMode, 'auto')
                app.General.Plot.Persistance.LevelLimits = [0, 0];
            end

            if app.axesTool_Waterfall.UserData.Value && strcmp(app.UIAxes3.UserData.CLimMode, 'auto')
                app.General.Plot.Waterfall.LevelLimits = [0, 0];
            end
        end

        %-----------------------------------------------------------------%
        function prePlot_updatingCustomProperties(app, idx)
            if app.play_Customization.Value
                % Aqui são atualizados todos os controles do customPlayback, 
                % exceto os DataTips, os quais são atualizados apenas quando
                % é selecionado outro fluxo espectral.

                app.specData(idx).UserData.customPlayback.Type = 'manual';
                app.specData(idx).UserData.customPlayback.Parameters.Controls      = struct('MinHold',          app.axesTool_MinHold.UserData.Value,     ...
                                                                                            'Average',          app.axesTool_Average.UserData.Value,     ...
                                                                                            'MaxHold',          app.axesTool_MaxHold.UserData.Value,     ...
                                                                                            'Persistance',      app.axesTool_Persistance.UserData.Value, ...
                                                                                            'Occupancy',        app.axesTool_Occupancy.UserData.Value,   ...
                                                                                            'Waterfall',        app.axesTool_Waterfall.UserData.Value,   ...
                                                                                            'LayoutRatio',      app.play_LayoutRatio.Value,              ...
                                                                                            'FrequencyLimits', [app.play_Limits_xLim1.Value, app.play_Limits_xLim2.Value],  ...
                                                                                            'LevelLimits',     [app.play_Limits_yLim1.Value, app.play_Limits_yLim2.Value]);
                app.specData(idx).UserData.customPlayback.Parameters.Persistance   = struct('Interpolation',    app.play_Persistance_Interpolation.Value, ...
                                                                                            'WindowSize',       app.play_Persistance_WindowSize.Value, ...
                                                                                            'Transparency',     app.play_Persistance_Transparency.Value, ...
                                                                                            'Colormap',         app.play_Persistance_Colormap.Value, ...
                                                                                            'LevelLimits',     [app.play_Persistance_cLim1.Value, app.play_Persistance_cLim2.Value]);
                app.specData(idx).UserData.customPlayback.Parameters.Waterfall     = struct('Fcn',              app.play_Waterfall_Fcn.Value, ...
                                                                                            'Decimation',       app.play_Waterfall_Decimation.Value, ...
                                                                                            'MeshStyle',        app.play_Waterfall_MeshStyle.Value, ...
                                                                                            'Colormap',         app.play_Waterfall_Colormap.Value, ...
                                                                                            'LevelLimits',     [app.play_Waterfall_cLim1.Value, app.play_Waterfall_cLim2.Value]);
                app.specData(idx).UserData.customPlayback.Parameters.WaterfallTime = struct('Visible',          app.play_Waterfall_Timeline.Value, ...
                                                                                            'ZData',           [1000, 1000]);
            else
                app.specData(idx).UserData.customPlayback = struct('Type', 'auto', 'Parameters', []);
            end
        end

        %-----------------------------------------------------------------%
        function prePlot_updatingRestoreView(app, idx)
            axesLimits = Limits(app.bandObj, idx);

            app.restoreView(1).xLim = axesLimits.xLim;
            app.restoreView(2).xLim = axesLimits.xLim;
            app.restoreView(3).xLim = axesLimits.xLim;

            app.restoreView(1).yLim = axesLimits.yLevelLim;
            app.restoreView(2).yLim = axesLimits.yLevelLim;
            app.restoreView(3).yLim = axesLimits.yLevelLim;

            app.restoreView(3).cLim = axesLimits.cLim;
        end

        %-----------------------------------------------------------------%
        function plot_startupFcn(app, idx)        
            % !! ESSENCIAL !!
            % O handle do elemento selecionado na árvore de fluxos, para o 
            % qual será plotado os gráficos, fica armazenado na propriedade 
            % "UserData", do componente app.play_PlotPanel.
            app.play_PlotPanel.UserData = prePlot_findSelectedNodeRoot(app, idx);

            % O objeto app.bandObj armazena propriedades de app.specData(idx) 
            % que simplifica o processo do plot, em especial na passagem de 
            % argumentos para as funções plot.draw2D e plot.draw3D.
            axesLimits = update(app.bandObj, idx);

            prePlot_restartProperties(app, axesLimits)
            prePlot_checkNSweepsAndDataType(app, idx)

            % Painel "PLAYBACK > HTMLPANEL"
            prePlot_HTMLPanels(app, idx)

            % Painel "PLAYBACK > PLAYBACK"
            % Ajuste dos paineis de controle "Persistance", "Occupancy" e
            % "Waterfall" (inserindo valores do customPlayback, caso existentes).
            prePlot_customPlayback(app, idx)
            prePlot_updatingGeneralSettings(app)
            play_OCCLayoutStartup(app, idx)                                 % !! PONTO DE REVISÃO !!

            % Painel "PLAYBACK > CANAIS >> INCLUSÃO DE CANAIS"
            play_Channel_TreeBuilding(app, idx, 'plot_startupFcn')

            % Painel "PLAYBACK > CANAIS >> SUBFAIXAS"
            FreqStart = app.bandObj.FreqStart;
            FreqStop  = app.bandObj.FreqStop;

            app.play_BandLimits_Status.Value = app.specData(idx).UserData.bandLimitsStatus;
        
            app.play_BandLimits_xLim1.Limits = [-Inf, Inf];
            app.play_BandLimits_xLim2.Limits = [-Inf, Inf];
            set(app.play_BandLimits_xLim1, 'Value', FreqStart, 'Limits', [FreqStart, FreqStop])
            set(app.play_BandLimits_xLim2, 'Value', FreqStop,  'Limits', [FreqStart, FreqStop])
        
            play_BandLimits_Layout(app, idx)
            play_BandLimits_TreeBuilding(app, idx)

            % Painel "PLAYBACK >> EMISSÕES"
            play_EmissionList(app, idx, 1)
        end

        %-----------------------------------------------------------------%
        function plot_Draw(app, idx)
            % No processo de inicialização do PLOT, que ocorre toda vez que é
            % alterado o fluxo espectral selecionado, na árvore principal do
            % appAnalise, os eixos são limpos e os handles dos principais
            % componentes do plot são apagados. app.hClearWrite vazio significa 
            % que deverá ser desenhado um novo PLOT. Por outro lado, caso não 
            % seja vazio, então o PLOT deverá ser atualizado.
        
            if isempty(app.hClearWrite)
                % Essa configuração aqui dispara o trigger de alteração de
                % 'XLim' e 'YLim', executando o callback
                % @(src,evt)plot_AxesLimitsChanged(app,src,evt)
                set(app.UIAxes1, 'XLim', app.restoreView(1).xLim, 'YLim', app.restoreView(1).yLim)
                ylabel(app.UIAxes1, sprintf('Nível (%s)', app.bandObj.LevelUnit))
        
                % (a) ClearWrite, MinHold, Average, e MaxHold
                for plotTag = ["ClearWrite", "MinHold", "Average", "MaxHold"]
                    if ismember(plotTag, {'MinHold', 'Average', 'MaxHold'}) && ~eval(sprintf('app.axesTool_%s.UserData.Value', plotTag))
                        continue
                    end
        
                    eval(sprintf('app.h%s = plot.draw2D.OrdinaryLine(app.UIAxes1, app.bandObj, idx, "%s");', plotTag, plotTag))
                    plot.datatip.Template(eval(sprintf('app.h%s', plotTag)), "Frequency+Level", app.bandObj.LevelUnit)
                end
                
                % (b) Persistance
                if app.axesTool_Persistance.UserData.Value
                    plot_Draw_Persistance(app, 'Creation', idx)
                end

                % Emissões
                plot.draw2D.ClearWrite_old(app, idx, 'InitialPlot', 1)

                % BandLimits & Channels
                plot.draw2D.horizontalSetOfLines(app.UIAxes1, app.bandObj, idx, 'BandLimits')
                plot_Draw_Channels(app, idx)
        
                % Occupancy
                if app.axesTool_Occupancy.UserData.Value
                    occIndex = play_OCCIndex(app, idx, 'PLAYBACK');
                    plot.old_OCC(app, idx, 'Creation', occIndex)
                end
        
                % Waterfall
                if app.axesTool_Waterfall.UserData.Value
                    plot_Draw_Waterfall(app, idx)
                end
        
                % customPlayback >> DataTips
                if ~isempty(app.specData(idx).UserData.customPlayback.Parameters)
                    dtConfig = app.specData(idx).UserData.customPlayback.Parameters.Datatip;
                    dtParent = [app.UIAxes1, app.UIAxes2, app.UIAxes3];
                    plot.datatip.Create('customPlayback', dtConfig, dtParent)
                end
        
            else
                % ClearWrite, MinHold, Average, e MaxHold
                for plotTag = ["ClearWrite", "MinHold", "Average", "MaxHold"]
                    if ismember(plotTag, {'MinHold', 'Average', 'MaxHold'})
                        if ~eval(sprintf('app.axesTool_%s.UserData.Value', plotTag)) || isinf(app.General.Integration.Trace)
                            continue
                        end
                    end
        
                    eval(sprintf('plot.draw2D.OrdinaryLineUpdate(app.h%s, app.bandObj, idx, plotTag);', plotTag))
                end
        
                for ii = 1:numel(app.hEmissionMarkers)
                    app.hEmissionMarkers(ii).Position(2) = app.hClearWrite.YData(app.hClearWrite.MarkerIndices(ii));
                end
        
                % Persistance
                plot_Draw_Persistance(app, 'Update', idx)

                % WaterfallTime
                if app.axesTool_Waterfall.UserData.Value && ~isempty(app.hWaterfallTime) && strcmp(app.play_Waterfall_Timeline.Value, 'on')
                    plot.draw2D.OrdinaryLineUpdate(app.hWaterfallTime, app.bandObj, idx, 'WaterfallTime');
                end
            end
            drawnow
        end

        %-----------------------------------------------------------------%
        function plot_Draw_Persistance(app, operationType, idx)
            switch operationType
                case 'Creation'
                    if strcmp(app.play_Persistance_WindowSize.Value, 'full')
                        nPersistancePoints    = app.bandObj.DataPoints * app.bandObj.nSweeps;
                        nMaxPersistancePoints = class.Constants.nMaxPersistancePoints;

                        if nPersistancePoints > nMaxPersistancePoints
                            msgQuestion   = sprintf(['A persistência do fluxo espectral selecionado demanda o cálculo do histograma bidimensional com mais de %.0f milhões de pontos, '  ...
                                                     'superior ao limite recomendado (cerca de %.0f milhões pontos).\n\nDeseja alterar a janela da persistência para computar apenas '   ...
                                                     'as últimos 512 varreduras?! Em caso negativo, o plot poderá demorar mais de 10 segundos para ser finalizado.'],                    ...
                                                     nPersistancePoints/1e+6, nMaxPersistancePoints/1e+6);
                            userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                            if userSelection == "Sim"
                                app.play_Persistance_WindowSize.Value = '512';
                                play_Persistance_Callbacks(app, struct('Source', app.play_Persistance_WindowSize))

                                if app.idxTime < 512
                                    app.idxTime = 512;
                                    app.tool_TimestampSlider.Value = 100 * app.idxTime/app.bandObj.nSweeps;
                                    tool_TimestampSliderValueChanging(app, struct('Value', app.tool_TimestampSlider.Value))
                                end
                                return
                            end
                        end
                    end

                    app.hPersistanceObj = plot.draw3D.Persistance('Creation', app.hPersistanceObj, app.UIAxes1, app.bandObj, idx);
                    play_Layout_PersistancePanel(app)

                case 'Update'
                    if app.axesTool_Persistance.UserData.Value && ~strcmp(app.play_Persistance_WindowSize.Value, 'full')
                        app.hPersistanceObj = plot.draw3D.Persistance('Update', app.hPersistanceObj, app.UIAxes1, app.bandObj, idx);
                        play_Layout_PersistancePanel(app)
                    end

                case 'Delete'
                    app.hPersistanceObj = plot.draw3D.Persistance('Delete', app.hPersistanceObj);
            end
        end

        %-----------------------------------------------------------------%
        function plot_Draw_Waterfall(app, idx)
            prePlot_updatingGeneralSettings(app)
            prePlot_updatingCustomProperties(app, idx)

            [app.hWaterfall, app.play_Waterfall_DecimationValue.Text] = plot.draw3D.Waterfall('Creation', app.UIAxes3, app.bandObj, idx);
            plot.axes.Layout.YLabel(app.hWaterfall, app.axesTool_Waterfall.UserData.Value)
            play_Layout_WaterfallPanel(app)

            % DataCursorMode
            % O DataCursorMode é, de forma geral, uma interação ruim p/ eixos
            % cartesianos por bloquear as outras (Pan, regionZoom etc). Por
            % essa razão, restringir o DataCursorMode apenas ao eixo específico
            % em que está sendo plotado a imagem (que não suporta a interação 
            % padrão de DataTip).
            switch app.play_Waterfall_Fcn.Value
                case 'image'
                    app.axesTool_DataTip.Enable = 1;
                case 'mesh'
                    app.axesTool_DataTip.Enable = 0;
                    if app.axesTool_DataTip.UserData
                        play_AxesToolbarCallbacks(app, struct('Source', app.axesTool_DataTip))
                    end
            end

            % Timeline
            if strcmp(app.play_Waterfall_Timeline.Value, 'on')
                app.hWaterfallTime = plot.draw2D.OrdinaryLine(app.UIAxes3, app.bandObj, idx, 'WaterfallTime');
            end
        end

        %-----------------------------------------------------------------%
        function plot_Draw_Channels(app, idx)
            if ~isempty(app.play_Channel_Tree.SelectedNodes) && app.play_Channel_ShowPlot.UserData
                srcChannel = app.play_Channel_Tree.SelectedNodes.NodeData.src;
                idxChannel = app.play_Channel_Tree.SelectedNodes.NodeData.idx;

                switch srcChannel
                    case 'channelLib'
                        srcRawTable = app.channelObj.Channel(idxChannel);
                    case 'manual'
                        srcRawTable = app.specData(idx).UserData.channelManual(idxChannel);
                end
                
                if ~isempty(srcRawTable)
                    channelBW = srcRawTable.ChannelBW; % MHz
                    if channelBW <= 0
                        app.play_Channel_ShowPlotWarn.Visible = 1;
                        return
                    else
                        app.play_Channel_ShowPlotWarn.Visible = 0;
                    end
    
                    if ~isempty(srcRawTable.FreqList)
                        FreqList = srcRawTable.FreqList;
                    else
                        FreqList = (srcRawTable.FirstChannel:srcRawTable.StepWidth:srcRawTable.LastChannel)';
                    end

                    srcTable = table(FreqList-channelBW/2, FreqList+channelBW/2, 'VariableNames', {'FreqStart', 'FreqStop'});    
                    plot.draw2D.horizontalSetOfLines(app.UIAxes1, app.bandObj, idx, 'Channels', srcTable)
                else
                    delete(findobj(app.UIAxes1, 'Tag', 'Channels'))
                end
            else
                delete(findobj(app.UIAxes1, 'Tag', 'Channels'))
            end
        end

        %-----------------------------------------------------------------%
        function plot_AxesLimitsChanged(app, src, evt)
            switch src.Name
                case 'XLim'
                    app.play_Limits_xLim1.Value = round(evt.AffectedObject.XLim(1), 3);
                    app.play_Limits_xLim2.Value = round(evt.AffectedObject.XLim(2), 3);

                case 'YLim'
                    app.play_Limits_yLim1.Value = round(double(evt.AffectedObject.YLim(1)), 1);
                    app.play_Limits_yLim2.Value = round(double(evt.AffectedObject.YLim(2)), 1);
            end
        end


        %-----------------------------------------------------------------%
        function [idx, nSweeps] = plot_updateIndex(app)
            % Os valores do índice e do número de varredura se referem ao
            % novo fluxo espectral selecionado, e não àquele que estava
            % sendo apresentado.
            idx = app.play_Tree.SelectedNodes.NodeData;
            nSweeps = numel(app.specData(idx).Data{1});
            
            plot_startupFcn(app, idx)
            plot_Draw(app, idx)

            app.plotFlag = 1;
        end     
        
        %-----------------------------------------------------------------%
        function plot_deleteLines(app, Tag)
            eval(sprintf('delete(app.h%s)', Tag));
            eval(sprintf('app.h%s = [];', Tag));
        end

        %-----------------------------------------------------------------%
        function plot_mainLoop(app, idx, nSweeps)
            app.tool_Play.ImageSource = 'stop_32.png';                

            while app.idxTime <= nSweeps
                % A variável app.plotFlag pode assumir os valores -1 | 0 | 1.
                % - -1: alteração de fluxo espectral
                % -  0: finalização do plot
                % -  1: atualização do plot
                switch app.plotFlag
                    case -1; [idx, nSweeps] = plot_updateIndex(app);
                    case  0; break
                end
                sweepTic = tic;
                
                plot_Draw(app, idx)
                app.tool_TimestampLabel.Text   = sprintf('%d de %d\n%s', app.idxTime, nSweeps, app.specData(idx).Data{1}(app.idxTime));
                app.tool_TimestampSlider.Value = 100 * app.idxTime/nSweeps;
                
                pause(max(app.play_MinPlotTime.Value/1000-toc(sweepTic), .001))
                
                % Reload Flag
                if app.idxTime == nSweeps
                    if app.tool_LoopControl.Tag == "loop"
                        app.idxTime = 1;
                    else
                        break
                    end
                else
                    app.idxTime = app.idxTime+1;
                end                
            end

            app.tool_Play.ImageSource = 'play_32.png';
        end


        %-----------------------------------------------------------------%
        % ## Modo "RELATÓRIO" ##
        %-----------------------------------------------------------------%
        function report_TreeBuilding(app)            
            if ~isempty(app.report_Tree.Children)
                delete(app.report_Tree.Children);
            end            
            
            % Atualizando a árvore principal de fluxos de dados, destacando
            % os fluxos incluídos para análise (no modo RELATÓRIO).
            play_TreeNodeStyle(app)

            % E, posteriormente, ajusta os elementos do painel do modo
            % RELATÓRIO.
            idxThreads = find(arrayfun(@(x) x.UserData.reportFlag, app.specData));
            if isempty(idxThreads)
                app.projectData.peaksTable(:,:) = [];
                app.tool_ReportAnalysis.Enable  = 0;
                app.tool_ReportGenerator.Enable = 0;
            else
                app.tool_ReportAnalysis.Enable  = 1;
                report_ModelNameValueChanged(app)                
                
                [receiverList, ~, ic] = unique({app.specData(idxThreads).Receiver});                
                for ii = 1:numel(receiverList)
                    idx2 = find(ic == ii)';
                    Category = uitreenode(app.report_Tree, 'Text', receiverList{ii},                               ...
                                                           'NodeData', idxThreads(idx2),                                 ...
                                                           'Icon', fcn.treeNodeIcon('Receiver', receiverList{ii}), ...
                                                           'ContextMenu', app.report_ContextMenu);
                    
                    for jj = idx2
                        idx3 = idxThreads(jj);
                        Node = uitreenode(Category, 'Text', misc_nodeTreeText(app, idx3), ...
                                                    'NodeData', idx3,                     ...
                                                    'ContextMenu', app.report_ContextMenu);

                        if ~isempty(app.specData(idx3).UserData.reportExternalFiles)
                            Node.Icon = 'attach_32.png';
                        end
                    end
                end
                expand(app.report_Tree, 'all')
            end

            play_TreeSelectionChanged(app, struct('Source', 'report_TreeBuilding'))
            play_UpdatePeaksTable(app, idxThreads, 'report.AddOrDeleteThread')
        end

        %-----------------------------------------------------------------%
        function report_Algorithms(app, idx)
            if isscalar(idx) && app.specData(idx).UserData.reportFlag
                app.report_ThreadAlgorithms.HTMLSource = fcn.htmlCode_ReportAlgorithms(app.specData(idx));
                set(app.report_DetectionManualMode, Value=app.specData(idx).UserData.reportDetection.ManualMode, Enable=1)
                app.report_EditClassification.Enable = 1;
                if app.specData(idx).UserData.reportDetection.ManualMode
                    app.report_EditDetection.Enable  = 0;
                else
                    app.report_EditDetection.Enable  = 1;
                end                

            else
                app.report_ThreadAlgorithms.HTMLSource = fullfile(app.rootFolder, 'Icons', 'Warning.html');
                app.report_EditDetection.Enable        = 0;
                app.report_EditClassification.Enable   = 0;
                set(app.report_DetectionManualMode, Value=0, Enable=0)
            end            
        end

        %-----------------------------------------------------------------%
        function report_LayoutPlaybackOnly(app)

            if app.report_DetectionManualMode.Value
                set(findall(groot, 'Parent', app.report_DetectionGrid, 'Tag', 'Detection'), 'Enable', 0)
            else
                set(findall(groot, 'Parent', app.report_DetectionGrid, 'Tag', 'Detection'), 'Enable', 1)
            end
        end

        %-----------------------------------------------------------------%
        function report_ProjectDataGUI(app)
            app.report_ProjectName.Value  = app.projectData.file;
            app.report_Issue.Value        = app.projectData.issue;
            app.report_ModelName.Value    = app.projectData.documentModel;
            app.report_ExternalFiles.Data = app.projectData.externalFiles;
        end

        %-----------------------------------------------------------------%
        function status = report_checkValidIssueID(app)
            status = (app.report_Issue.Value > 0) && (app.report_Issue.Value < inf);
        end


        %-----------------------------------------------------------------%
        % MISCELÂNEAS
        %-----------------------------------------------------------------%
        function nodeText = misc_nodeTreeText(app, idx)
            ThreadID  = app.specData(idx).RelatedFiles.ID(1);
            FreqStart = app.specData(idx).MetaData.FreqStart / 1e+6;
            FreqStop  = app.specData(idx).MetaData.FreqStop  / 1e+6;

            switch app.play_TreeSort.UserData
                case 'Receiver+ID'
                    nodeText = sprintf('ID %d: %.3f - %.3f MHz', ThreadID, FreqStart, FreqStop);
                case 'Receiver+Frequency'
                    nodeText = sprintf('%.3f - %.3f MHz (ID %d)', FreqStart, FreqStop, ThreadID);
            end
        end

        %-----------------------------------------------------------------%
        function misc_updateLastVisitedFolder(app, filePath)
            % <ToDo> EMD - 14/08/2024 - Eliminar a criação de campos em app.General, 
            % de forma que a estrutura seja fixa e orientada apenas aquilo que consta 
            % no arquivo "GeneralSettings.json". Aqui precisarei migrar a informação 
            % para o objeto app.projectObj.</ToDo>
            app.General.fileFolder.lastVisited = filePath;
            appUtil.generalSettingsSave(class.Constants.appName, app.rootFolder, app.General, app.executionMode, {'AppVersion', 'Models', 'Report'})
        end

        %-----------------------------------------------------------------%
        function generation = misc_findGenerationOfTreeNode(app, treeNode)
            referenceNode = treeNode;
            generation    = 0;
            while true
                if referenceNode.Parent ~= app.play_Tree
                    referenceNode = referenceNode.Parent;
                    generation = generation+1;
                else
                    break
                end
            end
        end

        %-----------------------------------------------------------------%
        function userSelection = misc_checkIfAuxiliarAppIsOpen(app, operationType)
            userSelection = 'Sim';

            if ~isempty(app.hSignalAnalysis) || ~isempty(app.hDriveTest)
                msgQuestion   = sprintf(['A operação "%s" demanda que os módulos auxiliares "SignalAnalysis" e "DriveTest" sejam fechados, '        ...
                                         'caso abertos, pois as informações espectrais consumidas por esses módulos poderão ficar desatualizadas. ' ...
                                         'Deseja continuar?'], operationType);
                userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                if userSelection == "Sim"
                    if ~isempty(app.hDriveTest)
                        menu_LayoutAuxiliarApp(app, 'DRIVETEST', 'Close')
                    end
        
                    if ~isempty(app.hSignalAnalysis)
                        menu_LayoutAuxiliarApp(app, 'SIGNALANALYSIS', 'Close')
                    end
                end
            end
        end

        %-----------------------------------------------------------------%
        function SelectedNodesTextList = misc_SelectedNodesText(app)
            SelectedNodesTextList = {};
            for ii = 1:numel(app.play_Tree.SelectedNodes)
                generation = misc_findGenerationOfTreeNode(app, app.play_Tree.SelectedNodes(ii));

                switch generation
                    case 0
                        NN = numel(app.play_Tree.SelectedNodes(ii).Children);
                        SelectedNodesTextList(end+1:end+NN) = {app.play_Tree.SelectedNodes(ii).Text};
                    case 1
                        SelectedNodesTextList{end+1} = app.play_Tree.SelectedNodes(ii).Text;
                    case 2
                        SelectedNodesTextList{end+1} = app.play_Tree.SelectedNodes(ii).Parent.Text;
                    case 3
                        SelectedNodesTextList{end+1} = app.play_Tree.SelectedNodes(ii).Parent.Parent.Text;
                end

            end
            SelectedNodesTextList = unique(SelectedNodesTextList);
        end

        %-----------------------------------------------------------------%
        function misc_SaveSpectralData(app, idx)
            nameFormatMap = {'*.mat',    'appAnalise (*.mat)'; ...
                             '*.bin',    'Logger (*.bin)';     ...
                             '*.sm1809', 'SM1809 (*.sm1809)'};
            defaultName   = class.Constants.DefaultFileName(app.General.fileFolder.userPath, 'SpectralData', -1); 
            [fileFullPath, ~, fileExt] = appUtil.modalWindow(app.UIFigure, 'uiputfile', '', nameFormatMap, defaultName);
            if isempty(fileFullPath)
                return
            end

            % As mensagens de erro apresentadas a seguir já explicitam as
            % limitações dos formatos "CRFS Bin" e "SM1809". O formato  "MAT",
            % por outro lado, não possui limitação.
            switch fileExt
                case '.mat'
                    % ...
                case '.bin'
                    receiverList = unique({app.specData(idx).Receiver});
                    if (numel(receiverList) > 1) || ~contains(receiverList, 'RFeye', 'IgnoreCase', true)
                        msgWarning = 'O formato de arquivo CRFS Bin não possibilita o armazenamento de dados gerados por mais de um sensor, ou por um sensor que não seja um RFeye.';
                    end
                case '.sm1809'
                    receiverList = unique({app.specData(idx).Receiver});
                    if (numel(receiverList) > 1)
                        msgWarning = 'O formato de arquivo SM1809 não possibilita o armazenamento de dados gerados por mais de um sensor.';
                    elseif any(ismember(arrayfun(@(x) x.MetaData.DataType, app.specData(idx)), class.Constants.occDataTypes))
                        msgWarning = 'O formato de arquivo SM1809 não possibilita o armazenamento de fluxos de ocupação.';
                    end
            end

            if exist('msgWarning', 'var')
                appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                return
            end

            app.progressDialog.Visible = 'visible';

            switch fileExt
                case '.mat'
                    fileWriter.MAT(    fileFullPath, 'SpectralData', app.specData(idx));
                case '.bin'
                    fileWriter.CRFSBin(fileFullPath, app.specData(idx));
                case '.sm1809'
                    fileWriter.SM1809( fileFullPath, app.specData(idx));
            end

            app.progressDialog.Visible = 'hidden';
        end

        %-----------------------------------------------------------------%
        function misc_ExportUserData(app, idx)
            nameFormatMap = {'*.mat', 'appAnalise (*.mat)'};
            defaultName   = class.Constants.DefaultFileName(app.General.fileFolder.userPath, 'UserData', -1); 
            fileFullPath  = appUtil.modalWindow(app.UIFigure, 'uiputfile', '', nameFormatMap, defaultName);
            if isempty(fileFullPath)
                return
            end
            
            prjInfo  = struct('exceptionList', app.projectData.exceptionList);
            fileWriter.MAT(fileFullPath, 'UserData', app.specData(idx), prjInfo);
        end

        %-----------------------------------------------------------------%
        function misc_ImportUserData(app)
            [fileFullPath, fileFolder] = appUtil.modalWindow(app.UIFigure, 'uigetfile', '', {'*.mat', 'appAnalise (*.mat)'}, app.General.fileFolder.lastVisited);
            if isempty(fileFullPath)
                return
            end
            misc_updateLastVisitedFolder(app, fileFolder)
            
            fileReader.MAT_UserData(app, fileFullPath)
        end


        %-----------------------------------------------------------------%
        % AUXILIAR FUNCTIONS TO OTHERS APPS OR EXTERNAL FUNCTIONS
        %-----------------------------------------------------------------%
        function appBackDoor(app, callingApp, operationType, varargin)
            try
                switch class(callingApp)
                    case 'auxApp.dockWelcomePage_exported'
                        pushedButtonTag = varargin{1};
                        simulationFlag  = varargin{2};

                        % WELCOMEPAGE (continuação)
                        % 6/7: Executa callback, a depender da escolha do usuário.
                        app.General.operationMode.Simulation = simulationFlag;
                        if simulationFlag
                            app.General.fiscaliza.systemVersion = 'HOM';
                        end

                        switch pushedButtonTag
                            case 'Open'
                                file_ButtonPushed_OpenFile(app)
                            case 'RFDataHub'
                                menu_OpenRFDataHubModule(app, struct('Source', app.menu_Button7, 'PreviousValue', false))
                        end

                        % 7/7: Finaliza o processo de inicialização.
                        app.popupContainerGrid.Visible = 0;

                    case {'auxApp.winSignalAnalysis', 'auxApp.winSignalAnalysis_exported'}
                        switch operationType
                            case 'closeFcn'
                                menu_LayoutAuxiliarApp(app, 'SIGNALANALYSIS', 'Close')    
                            case {'DeleteButtonPushed', 'PeakValueChanged'}
                                idxThread = varargin{1};
                                idxEmission = varargin{2};
            
                                if isequal(idxThread, app.play_PlotPanel.UserData.NodeData)
                                    plot.draw2D.ClearWrite_old(app, idxThread, operationType, idxEmission)
                                end                            
                                play_UpdatePeaksTable(app, idxThread, 'signalAnalysis.EditOrDeleteEmission')    
                            otherwise
                                error('UnexpectedCall')
                        end

                    case {'auxApp.winDriveTest', 'auxApp.winDriveTest_exported'}
                        switch operationType
                            case 'closeFcn'
                                menu_LayoutAuxiliarApp(app, 'DRIVETEST', 'Close')
                            otherwise
                                error('UnexpectedCall')
                        end

                    case {'auxApp.winConfig', 'auxApp.winConfig_exported'}
                        switch operationType
                            case 'closeFcn'
                                menu_LayoutAuxiliarApp(app, 'CONFIG', 'Close')
                            case 'FiscalizaModeChanged'
                                % Reinicia o objeto, caso necessário...
                                if ~isempty(app.fiscalizaObj)
                                    delete(app.fiscalizaObj)
                                    app.fiscalizaObj = [];

                                    if app.menu_Button3.Value
                                        play_TabGroupVisibility(app, struct('Source', app.report_ControlsTab1Image))
                                        
                                        app.tool_FiscalizaAutoFill.Enable = 0;
                                        app.tool_FiscalizaUpdate.Enable   = 0;
                                    end
                                end
                            otherwise
                                error('UnexpectedCall')
                        end

                    case {'winRFDataHub', 'winRFDataHub_exported'}
                        switch operationType
                            case 'closeFcn'
                                menu_LayoutAuxiliarApp(app, 'RFDATAHUB', 'Close')
                            otherwise
                                error('UnexpectedCall')
                        end

                    % case 'auxApp.dockAddFiles_exported'
                    %     if strcmp(varargin{1}, 'Fluxo de dados')
                    %         report_TreeBuilding(app)
                    %         app.report_Tree.SelectedNodes = app.report_Tree.Children(1).Children(1);
                    %     end
                    % 
                    case {'auxApp.dockClassification_exported', 'auxApp.dockDetection_exported'}
                        pushedButtonTag = varargin{1};

                        switch pushedButtonTag
                            case 'OK'
                                idxThread = varargin{2};
                                report_Algorithms(app, idxThread)
                                report_SaveWarn(app)
                            case 'Close'
                                % ...
                        end
                        
                        app.popupContainerGrid.Visible = 0;
    
                    otherwise
                        error('UnexpectedCall')
                end

            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', ME.message);            
            end

            % Caso um app auxiliar esteja em modo DOCK, o progressDialog do
            % app auxiliar coincide com o do appAnalise. Força-se, portanto, 
            % a condição abaixo para evitar possível bloqueio da tela.
            app.progressDialog.Visible = 'hidden';
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

            try
                % WARNING MESSAGES
                appUtil.disablingWarningMessages()

                % <GUI>
                app.UIFigure.Position(4) = 660;
                app.popupContainerGrid.Layout.Row = [1,2];
                app.GridLayout.RowHeight = {44, '1x'};
                app.play_TreeGrid.RowHeight(4:10) = {0,0,0,0,0,0,0};
                % </GUI>

                appUtil.winPosition(app.UIFigure)
                jsBackDoor_Initialization(app)
                startup_timerCreation(app)

            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', getReport(ME), 'CloseFcn', @(~,~)closeFcn(app));
            end
            
        end

        % Close request function: UIFigure
        function closeFcn(app, event)

            % RUNNING PROJECT CHECK
            projectName = char(app.report_ProjectName.Value);
            if ~isempty(projectName) && app.report_ProjectWarnIcon.Visible
                msgQuestion   = sprintf(['O projeto aberto - registrado no arquivo <b>"%s"</b> - foi alterado.\n\n' ...
                                         'Deseja descartar essas alterações? Caso não, favor salvá-las no modo RELATÓRIO.'], projectName);
                userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                if userSelection == "Não"
                    return
                end
            end

            % DELETE TEMP FILES
            switch app.executionMode
                case 'webApp'
                    rmdir(app.General.fileFolder.userPath, 's');
                otherwise
                    delete(fullfile(app.General.fileFolder.userPath, '~Report*.html'))
                    delete(fullfile(app.General.fileFolder.userPath, '~Image*.*'))
            end

            % DELETE AUXILIAR APPS
            delete(app.hDriveTest)
            delete(app.hSignalAnalysis)
            delete(app.hRFDataHub)

            % TIMER
            h = timerfindall;
            if ~isempty(h)
                stop(h); delete(h); clear h
            end

            % MATLAB RUNTIME
            % Ao fechar um webapp, o MATLAB WebServer demora uns 10 segundos para
            % fechar o Runtime que suportava a sessão do webapp. Dessa forma, a 
            % liberação do recurso, que ocorre com a inicialização de uma nova 
            % sessão do Runtime, fica comprometida.
            appUtil.killingMATLABRuntime(app.executionMode)

            delete(app)
            
        end

        % Value changed function: menu_Button1, menu_Button2, 
        % ...and 4 other components
        function menu_mainButtonPushed(app, event)

            clickedButton = event.Source;

            if event.PreviousValue
                clickedButton.Value = true;
                return
            end
            
            nonClickedButtons = findobj(app.menu_Grid, 'Type', 'uistatebutton', '-not', 'Tag', clickedButton.Tag);
            arrayfun(@(x) set(x, 'Value', 0, 'Icon', x.UserData.iconOptions{1}), nonClickedButtons)
            set(clickedButton, 'Icon', clickedButton.UserData.iconOptions{2})
            
            tabIndex = clickedButton.UserData.tabGroup;
            app.TabGroup.SelectedTab = app.TabGroup.Children(tabIndex);
            drawnow

            % A customização somente pode tem efeito se os componentes
            % já tiverem sido renderizados no HTML. Por essa razão, inclui-se 
            % um drawnow após a mudança da aba.
            jsBackDoor_Customizations(app, tabIndex)
            menu_LayoutControl(app, tabIndex)
            
        end

        % Image clicked function: config_Close, config_Undock, 
        % ...and 6 other components
        function menu_DockButtonPushed(app, event)
            
            auxiliarApp = event.Source.Tag;

            switch event.Source
                case {app.drivetest_Undock, app.signalanalysis_Undock, app.rfdatahub_Undock, app.config_Undock}
                    initialDockState = app.General.operationMode.Dock;
                    app.General.operationMode.Dock = false;

                    inputArguments   = menu_LayoutUndockingAuxiliarApp(app, auxiliarApp);
                    menu_LayoutAuxiliarApp(app, auxiliarApp, 'Close')
                    menu_LayoutAuxiliarApp(app, auxiliarApp, 'Open', inputArguments{:})

                    app.General.operationMode.Dock = initialDockState;

                case {app.drivetest_Close,  app.signalanalysis_Close,  app.rfdatahub_Close, app.config_Close}
                    menu_LayoutAuxiliarApp(app, auxiliarApp, 'Close')
            end

        end

        % Value changed function: menu_Button7
        function menu_OpenRFDataHubModule(app, event)

            clickedButton = event.Source;

            if ~isempty(app.hRFDataHub) && isvalid(app.hRFDataHub) && ~app.hRFDataHub.isDocked
                clickedButton.Value = false;
                figure(app.hRFDataHub.UIFigure)
                return
            elseif event.PreviousValue
                clickedButton.Value = true;
                return
            end            

            if isempty(app.hRFDataHub) || ~isvalid(app.hRFDataHub)
                msgQuestion   = ['O RFDataHub é uma ETL de dados de estações de telecomunicações composta por '       ...
                                 'registros extraídos de bases de dados do MOSAICO, STEL, SRD, ICAO, AISWEB, GEOAIS ' ...
                                 'e REDEMET.<br><br>Deseja abrir o módulo de consulta ao RFDataHub?'];
                userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                if userSelection == "Não"
                    clickedButton.Value = 0;
                    return
                end
            end

            menu_LayoutAuxiliarApp(app, 'RFDATAHUB', 'Open')

        end

        % Image clicked function: AppInfo, FigurePosition
        function menu_ToolbarImageCliced(app, event)

            focus(app.jsBackDoor)

            switch event.Source
                case app.FigurePosition
                    app.UIFigure.Position(3:4) = class.Constants.windowSize;
                    appUtil.winPosition(app.UIFigure)

                case app.AppInfo
                    if isempty(app.AppInfo.Tag)
                        app.progressDialog.Visible = 'visible';
                        app.AppInfo.Tag = fcn.htmlCode_appInfo(app.General, app.rootFolder, app.executionMode);
                        app.progressDialog.Visible = 'hidden';
                    end

                    msgInfo = app.AppInfo.Tag;
                    appUtil.modalWindow(app.UIFigure, 'info', msgInfo);
            end

        end

        % Image clicked function: file_OpenInitialPopup
        function file_ButtonPushed_OpenPopup(app, event)
            
            menu_LayoutPopupApp(app, 'WelcomePage')

        end

        % Image clicked function: file_OpenFileButton
        function file_ButtonPushed_OpenFile(app, event)
            
            focus(app.file_Tree)

            if app.General.operationMode.Simulation
                app.General.operationMode.Simulation = false;
                filePath = fullfile(app.rootFolder, 'Simulation');

                listOfFiles = dir(filePath);
                fileName = {listOfFiles.name};
                fileName = fileName(endsWith(lower(fileName), '.mat'));

            else
                [fileName, filePath] = uigetfile({'*.bin;*.dbm;*.mat', 'Binários (*.bin,*.dbm,*.mat)'; ...
                                                  '*.csv;*.sm1809',    'Textuais (*.csv,*.sm1809)'},   ...
                                                  '', app.General.fileFolder.lastVisited, 'MultiSelect', 'on');
                figure(app.UIFigure)
    
                if isequal(fileName, 0)
                    return
                elseif ~iscell(fileName)
                    fileName = {fileName};
                end
                misc_updateLastVisitedFolder(app, filePath)
            end

            file_OpenSelectedFiles(app, filePath, fileName)

        end

        % Button pushed function: file_SpecReadButton
        function file_ButtonPushed_SpecRead(app, event)
                        
            % <ReviewNote> EMD - 22/08/2024</ReviewNote>
            % Verificar se há ao menos um fluxo a ser lido...
            flag = false;
            for ii = 1:numel(app.metaData)
                for jj = 1:numel(app.metaData(ii).Data)
                    if app.metaData(ii).Data(jj).Enable
                        flag = true;
                        break
                    end
                end
            end

            if ~flag
                appUtil.modalWindow(app.UIFigure, 'warning', 'Não há fluxo de informação a ser lido...');
                return
            end

            % Verifica se os módulos auxiliares abaixo descritos estão abertos.
            % - auxiliarWin1: winSignalAnalysis
            % - auxiliarWin2: winDriveTest
            if strcmp(misc_checkIfAuxiliarAppIsOpen(app, 'RELER INFORMAÇÃO ESPECTRAL'), 'Não')
                return
            end

            % Limpa eventuais informações de um projeto antigo, no modo REPORT. 
            % Essas informações serão preenchidas, caso esteja sendo lido um arquivo 
            % MAT (de projeto) no método "read" da classe "class.specData".
            app.report_ProjectName.Value = '';

            % Reinicia a variável, caso não vazia...
            if ~isempty(app.specData)
                delete(app.specData)
                app.specData = class.specData.empty;
            end
           
            builtinDialog = [];
            try
                [app.specData, builtinDialog] = read(app.specData, app.metaData, app);

                if isempty(app.UIAxes1)
                    startup_Axes(app)
                end

                % Constroi a árvore de fluxos espectrais, deixando selecionado
                % o primeiro dos fluxos. E constroi a árvore de fluxos espectrais
                % que eventualmente foram incluídos em um projeto.
                play_TreeBuilding(app)
                app.play_Tree.SelectedNodes = app.play_Tree.Children(1).Children(1);
                report_TreeBuilding(app)
    
                % Habilita botões do menu principal - PLAYBACK, REPORT e MISC -
                % abrindo programaticamente o modo PLAYBACK.
                set(app.menu_Button2, 'Enable', 1, 'Value', 1)
                app.menu_Button3.Enable = 1;
                app.menu_Button4.Enable = 1;
                menu_mainButtonPushed(app, struct('Source', app.menu_Button2, 'PreviousValue', false))
    
                % Desabilita botão, inviabilizando leitura do mesmo conjunto de
                % dados.
                app.file_SpecReadButton.Visible = 0;

            catch ME
                appUtil.modalWindow(app.UIFigure, 'warning', getReport(ME));
                file_DataReaderError(app)
            end

            delete(builtinDialog)

        end

        % Selection changed function: file_Tree
        function file_TreeSelectionChanged(app, event)
            
            if ~isempty(app.metaData)
                % Caso seja selecionado apenas um nó, apresenta-se os
                % metadados relacionados, além de habilitar os botões do 
                % toolbar.
                if isscalar(app.file_Tree.SelectedNodes)
                    idxFile   = app.file_Tree.SelectedNodes.NodeData.idx1;
                    idxThread = app.file_Tree.SelectedNodes.NodeData.idx2;

                    if ~isequal(app.file_Tree.UserData.previousSelectedFileIndex, idxFile)
                        app.file_Tree.UserData.previousSelectedFileIndex = idxFile;

                        collapse(app.file_Tree)                        
                        expand(app.file_Tree.Children(idxFile), 'all')
                        scroll(app.file_Tree, app.file_Tree.SelectedNodes)
                    end

                    app.file_Metadata.HTMLSource = fcn.htmlCode_ThreadInfo(app.metaData, idxFile, idxThread);
                else
                    app.file_Metadata.HTMLSource = ' ';
                end

            else
                % Desabilita o painel de metadados...
                app.file_Metadata.HTMLSource   = ' ';
            end
            
        end

        % Selection changed function: file_FilteringTypePanel
        function file_FilteringTypeChanged(app, event)

            switch app.file_FilteringTypePanel.SelectedObject
                case app.file_FilteringType1; app.file_panelGrid.RowHeight(6:8) = {22,0,0};
                case app.file_FilteringType2; app.file_panelGrid.RowHeight(6:8) = {0,22,0};
                case app.file_FilteringType3; app.file_panelGrid.RowHeight(6:8) = {0,0,22};
            end

        end

        % Image clicked function: file_FilteringAdd
        function file_FilteringAddClicked(app, event)
            
            focus(app.file_FilteringTree)

            switch app.file_FilteringTypePanel.SelectedObject
                case app.file_FilteringType1                                % Faixa de frequência
                    if isempty(app.file_FilteringType1_Frequency.Value)
                        return
                    end
                    newFilterText = sprintf('FREQUÊNCIA: %s', app.file_FilteringType1_Frequency.Value);
                    
                case app.file_FilteringType2                                % ID
                    if isempty(app.file_FilteringType2_ID.Value)
                        return
                    end
                    newFilterText = sprintf('ID: %s', app.file_FilteringType2_ID.Value);
                    
                case app.file_FilteringType3                                % Descrição
                    app.file_FilteringType3_Description.Value = upper(strtrim(app.file_FilteringType3_Description.Value));
                    
                    if isempty(app.file_FilteringType3_Description.Value)
                        return
                    else
                        newFilterText = sprintf('DESCRIÇÃO: "%s"', app.file_FilteringType3_Description.Value);
                    end
            end

            hComponents = allchild(app.file_FilteringTree);
            if ~isempty(hComponents) && ismember(newFilterText, {hComponents.Text})
                return
            end

            uitreenode(app.file_FilteringTree, 'Text',        newFilterText, ...
                                               'ContextMenu', app.file_ContextMenu_Tree2);
            file_TreeBuilding(app)

        end

        % Menu selected function: file_ContextMenu_delTree1Node
        function file_ContextMenu_delTree1NodeSelected(app, event)
            % <ReviewNote>EMD - 14/08/2024</ReviewNote>
            idxTable = table('Size', [0, 3],                                ...
                             'VariableTypes', {'double', 'double', 'cell'}, ...
                             'VariableNames', {'level', 'idx1', 'idx2'});

            for ii = 1:numel(app.file_Tree.SelectedNodes)
                idx = find(idxTable.idx1 == app.file_Tree.SelectedNodes(ii).NodeData.idx1, 1);
                if isempty(idx)
                    idxTable(end+1,:)   = {app.file_Tree.SelectedNodes(ii).NodeData.level, app.file_Tree.SelectedNodes(ii).NodeData.idx1, {app.file_Tree.SelectedNodes(ii).NodeData.idx2}};
                else
                    idxTable(idx,[1,3]) = {min([idxTable{idx,1}, app.file_Tree.SelectedNodes(ii).NodeData.level]), {unique([cell2mat(idxTable{idx,3}), app.file_Tree.SelectedNodes(ii).NodeData.idx2])}};
                end
            end

            idxTable = sortrows(idxTable, 'idx1');
            for kk = height(idxTable):-1:1
                idx1 = idxTable.idx1(kk);
                idx2 = idxTable.idx2{kk};

                switch idxTable.level(kk)
                    case 1
                        delete(app.metaData(idx1))
                        app.metaData(idx1) = [];

                    otherwise
                        if isequal(idxTable.idx2{kk}, 1:numel(app.metaData(idx1).Data))
                            delete(app.metaData(idx1))
                            app.metaData(idx1) = [];
                        else
                            delete(app.metaData(idx1).Data(idx2))
                            app.metaData(idx1).Data(idx2)    = [];
                            app.metaData(idx1).Samples(idx2) = [];
                            app.metaData(idx1).Memory        = EstimatedMemory(app.metaData, idx1);
                        end
                end
            end
            
            file_TreeBuilding(app)

        end

        % Menu selected function: file_ContextMenu_delTree2Node
        function file_ContextMenu_delTree2NodeSelected(app, event)
            
            if ~isempty(app.file_FilteringTree.SelectedNodes)
                delete(app.file_FilteringTree.SelectedNodes)
                file_TreeBuilding(app)
            end

        end

        % Image clicked function: play_ControlsTab1Image, 
        % ...and 4 other components
        function play_TabGroupVisibility(app, event)

            switch event.Source
                case app.play_ControlsTab1Image
                    app.play_ControlsGrid.RowHeight(2:2:12) = {'1x',0,0,0,0,0};
                
                case app.play_ControlsTab2Image
                    app.play_ControlsGrid.RowHeight(2:2:12) = {0,'1x',0,0,0,0};
                
                case app.play_ControlsTab3Image
                    app.play_ControlsGrid.RowHeight(2:2:12) = {0,0,'1x',0,0,0};
                
                case app.report_ControlsTab1Image
                    app.play_ControlsGrid.RowHeight(2:2:12) = {0,0,0,'1x',0,0};
                    set(findobj(app.play_toolGrid, 'Tag', 'FISCALIZA'), Enable=0)
                
                case app.report_ControlsTab2Image
                    app.play_ControlsGrid.RowHeight(2:2:12) = {0,0,0,0,'1x',0};
                    fiscalizaLibConnection.report_ToolbarStatus(app)
                
                case app.report_ControlsTab2Image
                    app.play_ControlsGrid.RowHeight(2:2:12) = {0,0,0,0,0,'1x'};
                    fiscalizaLibConnection.report_StaticButtonPushed(app, event)
            end

        end

        % Image clicked function: play_TreePanelVisibility, play_TreeSort, 
        % ...and 2 other components
        function play_PanelsVisibility(app, event)
            
            switch event.Source
                %---------------------------------------------------------%
                case app.play_TreePanelVisibility
                    app.play_TreePanelVisibility.UserData.Visible = ~app.play_TreePanelVisibility.UserData.Visible;
                    play_TreeSecundaryPanelVisibility(app)

                %---------------------------------------------------------%
                case app.play_TreeSort
                    if app.plotFlag
                        msgWarning = 'Necessário interromper o playback antes de reordernar os fluxos espectrais...';
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                        return
                    end

                    presentValue   = strcmp({'Receiver+ID', 'Receiver+Frequency'}, app.play_TreeSort.UserData);
                    possibleValue  = char(setdiff({'Receiver+ID', 'Receiver+Frequency'}, app.play_TreeSort.UserData));
                    tempDictionary = dictionary([true false], ["(ATUAL)", ""]);

                    msgQuestion    = sprintf(['Os fluxos espectrais podem ser ordenadas das formas:\n' ...
                                              '&thinsp;&thinsp;(a) Receiver+ID %s\n'                   ...
                                              '&thinsp;&thinsp;(b) Receiver+Frequency %s\n\n'          ...
                                              'Confirma a troca, ordenando os fluxos por "<b>%s</b>"?!?'], tempDictionary(presentValue(1)), tempDictionary(presentValue(2)), possibleValue);
                    userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                    if userSelection == "Não"
                        return
                    end
                    app.play_TreeSort.UserData = possibleValue;
                    app.specData = sort(app.specData, possibleValue);

                    play_TreeBuilding(app)
                    app.play_Tree.SelectedNodes = app.play_Tree.Children(1).Children(1);
                    report_TreeBuilding(app)

                %---------------------------------------------------------%
                case app.tool_LayoutLeft
                    if app.play_Grid.ColumnWidth{1}
                        app.play_Grid.ColumnWidth(1:2) = {0, 5};
                        app.tool_LayoutLeft.ImageSource = 'ArrowRight_32.png';
                    else
                        app.play_Grid.ColumnWidth(1:2) = {325, 10};
                        app.tool_LayoutLeft.ImageSource = 'ArrowLeft_32.png';
                    end

                case app.tool_LayoutRight
                    if app.play_Grid.ColumnWidth{end}
                        app.play_Grid.ColumnWidth(end-1:end) = {5, 0};
                        app.tool_LayoutRight.ImageSource = 'ArrowLeft_32.png';
                    else
                        app.play_Grid.ColumnWidth(end-1:end) = {10, 325};
                        app.tool_LayoutRight.ImageSource = 'ArrowRight_32.png';
                    end
            end

            if app.play_Tree.Enable
                focus(app.play_Tree)
            else
                focus(app.jsBackDoor)
            end

        end

        % Selection changed function: play_Tree
        function play_TreeSelectionChanged(app, event)
            
            idx = [];
            if ~isempty(app.play_Tree.SelectedNodes)
                idx = unique([app.play_Tree.SelectedNodes.NodeData]);
            end

            if isscalar(idx) || isempty(app.play_PlotPanel.UserData) || ~isvalid(app.play_PlotPanel.UserData)
                idx = idx(1);
                
                % Garante que apenas ficará selecionado um único nó da árvore.
                % Posteriormente, ajusta visualização da árvore, expandindo
                % os nós relacionados ao nó selecionado.
                if isempty(app.play_PlotPanel.UserData) || ~isvalid(app.play_PlotPanel.UserData) || ~isequal(app.play_PlotPanel.UserData.NodeData, idx)
                    play_TreeCollapseStyle(app)
                end                

                % Em relação ao FLUXO ANTERIORMENTE SELECIONADO, atualiza-se
                % o controle de customização do playback, caso habilitado.
                if ~isempty(app.play_PlotPanel.UserData) && isvalid(app.play_PlotPanel.UserData) && ~isequal(app.play_PlotPanel.UserData.NodeData, idx)
                    play_CustomizationValueChanged(app)
                end

                % Ao plotar dados relacionados a um fluxo de espectro, salva-se
                % o handle do nó selecionado da árvore na propriedade "UserData"
                % do painel app.play_PlotPanel. A propriedade "NodeData" deste 
                % nó armazena o índice do app.specData. Se for alterada a seleção 
                % da árvore, e isso resultar na escolha de um único fluxo de 
                % espectro, atualiza-se o plot.
                if app.plotFlag
                    if ~isequal(app.play_PlotPanel.UserData.NodeData, idx)
                        app.plotFlag = -1;
                    end
                else
                    if isempty(app.play_PlotPanel.UserData) || ~isvalid(app.play_PlotPanel.UserData) || ~isequal(app.play_PlotPanel.UserData.NodeData, idx)
                        plot_startupFcn(app, idx)
                        plot_Draw(app, idx)
                    end
                end
            end

            % Aspectos relacionados aos outros modos - REPORT (app.menu_Button3) e EDIT (app.menu_Button4).
            if app.menu_Button3.Value
                app.report_Tree.SelectedNodes = [];
                
                if exist('event', 'var') && (isequal(event.Source, app.play_Tree) || ismember(event.Source, {'menu_LayoutControl', 'report_TreeBuilding'}))
                    report_Algorithms(app, app.play_PlotPanel.UserData.NodeData)
                end

            elseif app.menu_Button4.Value

            end
            drawnow
            
        end

        % Image clicked function: axesTool_Average, axesTool_DataTip, 
        % ...and 7 other components
        function play_AxesToolbarCallbacks(app, event)
            
            idx = app.play_PlotPanel.UserData.NodeData;

            switch event.Source
                case app.axesTool_RestoreView
                    plot.axes.Interactivity.CustomRestoreViewFcn(app.UIAxes1, [app.UIAxes2, app.UIAxes3], app)

                case app.axesTool_Pan
                    app.axesTool_Pan.UserData = ~app.axesTool_Pan.UserData;
                    if app.axesTool_Pan.UserData
                        app.axesTool_Pan.ImageSource = 'Pan_32Filled.png';
                        if app.axesTool_DataTip.UserData
                            play_AxesToolbarCallbacks(app, struct('Source', app.axesTool_DataTip))
                        end
                    else
                        app.axesTool_Pan.ImageSource = 'Pan_32.png';
                    end

                    plot.axes.Interactivity.CustomPanFcn(struct('Value', app.axesTool_Pan.UserData), app.UIAxes1, [app.UIAxes2, app.UIAxes3]);

                case app.axesTool_DataTip
                    app.axesTool_DataTip.UserData = ~app.axesTool_DataTip.UserData;
                    if app.axesTool_DataTip.UserData
                        app.axesTool_DataTip.ImageSource = 'DataTip_22Filled.png';
                    else
                        app.axesTool_DataTip.ImageSource = 'DataTip_22.png';
                    end

                    plot.axes.Interactivity.DataCursorMode(app.UIAxes3, app.axesTool_DataTip.UserData)

                case {app.axesTool_MinHold, app.axesTool_Average, app.axesTool_MaxHold}
                    event.Source.UserData.Value = ~event.Source.UserData.Value;
                    if event.Source.UserData.Value
                        event.Source.ImageSource = event.Source.UserData.ImageSource{1};

                        hObject = plot.draw2D.OrdinaryLine(app.UIAxes1, app.bandObj, idx, event.Source.Tag);
                        plot.datatip.Template(hObject, 'Frequency+Level', app.bandObj.LevelUnit)
                        plot.axes.StackingOrder.execute(app.UIAxes1, app.bandObj.Context)
            
                        eval(sprintf('app.h%s = hObject;', event.Source.Tag));

                    else
                        event.Source.ImageSource = event.Source.UserData.ImageSource{2};
                        plot_deleteLines(app, event.Source.Tag)
                    end

                case app.axesTool_Persistance
                    app.axesTool_Persistance.UserData.Value = ~app.axesTool_Persistance.UserData.Value;
                    if app.axesTool_Persistance.UserData.Value
                        app.play_RadioButton_Persistance.Value = 1;
                        play_ControlsPanelSelectionChanged(app)

                        prePlot_updatingGeneralSettings(app)
                        prePlot_updatingCustomProperties(app, idx)
                        plot_Draw_Persistance(app, 'Creation', idx)
                    else
                        plot_Draw_Persistance(app, 'Delete', -1)
                    end

                case app.axesTool_Occupancy
                    app.axesTool_Occupancy.UserData.Value = ~app.axesTool_Occupancy.UserData.Value;
                    if app.axesTool_Occupancy.UserData.Value
                        app.play_RadioButton_Occupancy.Value = 1;
                        play_ControlsPanelSelectionChanged(app)

                        occIndex = play_OCCIndex(app, idx, 'PLAYBACK/REPORT');
                        plot.old_OCC(app, idx, 'Creation', occIndex)
                    else
                        plot.old_OCC(app, idx, 'Delete', -1)
                    end
                    play_OCCLayoutVisibility(app, app.bandObj.LevelUnit)

                    plot.axes.Layout.XLabel([app.UIAxes1, app.UIAxes2, app.UIAxes3], app.axesTool_Occupancy.UserData.Value, app.axesTool_Waterfall.UserData.Value)
                    plot.axes.Layout.RatioAspect([app.UIAxes1, app.UIAxes2, app.UIAxes3], app.axesTool_Occupancy.UserData.Value, app.axesTool_Waterfall.UserData.Value, app.play_LayoutRatio)

                case app.axesTool_Waterfall
                    app.axesTool_Waterfall.UserData.Value = ~app.axesTool_Waterfall.UserData.Value;
                    if app.axesTool_Waterfall.UserData.Value
                        if isempty(app.hWaterfall)
                            plot_Draw_Waterfall(app, idx)
                        else
                            play_Layout_WaterfallPanel(app)
                        end

                        app.play_RadioButton_Waterfall.Value = 1;
                        play_ControlsPanelSelectionChanged(app)
                    else
                        play_Layout_WaterfallPanel(app)
                    end                    

                    plot.axes.Layout.XLabel([app.UIAxes1, app.UIAxes2, app.UIAxes3], app.axesTool_Occupancy.UserData.Value, app.axesTool_Waterfall.UserData.Value)
                    plot.axes.Layout.RatioAspect([app.UIAxes1, app.UIAxes2, app.UIAxes3], app.axesTool_Occupancy.UserData.Value, app.axesTool_Waterfall.UserData.Value, app.play_LayoutRatio)
            end
            drawnow

        end

        % Image clicked function: tool_LoopControl, tool_Play
        function play_PlaybackToolbarButtonCallback(app, event)
            
            switch event.Source
                case app.tool_Play
                    idx = [];
                    if ~isempty(app.play_PlotPanel.UserData) && isvalid(app.play_PlotPanel.UserData)
                        idx = app.play_PlotPanel.UserData.NodeData;
                    end
        
                    if ~isempty(idx) && ~app.plotFlag
                        if ~isempty(app.hDriveTest) && isvalid(app.hDriveTest) && app.hDriveTest.plotFlag
                            app.hDriveTest.plotFlag = 0;
                            app.hDriveTest.tool_Play.ImageSource = 'play_32.png';
                            drawnow
                        end

                        app.plotFlag = 1;
                        plot_mainLoop(app, idx, numel(app.specData(idx).Data{1}))        
                    else
                        app.plotFlag = 0;
                    end

                %---------------------------------------------------------%
                case app.tool_LoopControl
                    switch app.tool_LoopControl.Tag
                        case 'loop';   set(app.tool_LoopControl, Tag='direct', ImageSource='playbackStraight_32Blue.png')
                        case 'direct'; set(app.tool_LoopControl, Tag='loop',   ImageSource='playbackLoop_32Blue.png')
                    end
            end

        end

        % Value changing function: tool_TimestampSlider
        function tool_TimestampSliderValueChanging(app, event)
            
            idx = app.play_PlotPanel.UserData.NodeData;
            nSweeps = app.bandObj.nSweeps;
            
            app.idxTime = round(event.Value/100 * nSweeps);
            if app.idxTime < 1
                app.idxTime = 1;
            elseif app.idxTime > nSweeps
                app.idxTime = nSweeps;
            end

            if ~app.plotFlag
                app.hClearWrite.YData = app.specData(idx).Data{2}(:, app.idxTime)';
    
                for ii = 1:numel(app.hEmissionMarkers)
                    app.hEmissionMarkers(ii).Position(2) = app.hClearWrite.YData(app.hClearWrite.MarkerIndices(ii));
                end
                
                plot_Draw_Persistance(app, 'Update', idx)

                if app.axesTool_Waterfall.UserData.Value && ~isempty(app.hWaterfallTime) && strcmp(app.play_Waterfall_Timeline.Value, 'on')
                    plot.draw2D.OrdinaryLineUpdate(app.hWaterfallTime, app.bandObj, idx, 'WaterfallTime');
                end

                app.tool_TimestampLabel.Text = sprintf('%d de %d\n%s', app.idxTime, nSweeps, app.specData(idx).Data{1}(app.idxTime));
            end
            
        end

        % Value changed function: play_LayoutRatio
        function play_ControlButtonPushed(app, event)

            plot.axes.Layout.Visibility([app.UIAxes1, app.UIAxes2, app.UIAxes3], app.play_LayoutRatio.Value, app.bandObj.Context)

        end

        % Value changed function: play_LineVisibility
        function play_LineVisibilityValueChanged(app, event)
            
            app.General.Plot.ClearWrite.Visible = app.play_LineVisibility.Value;

            try
                set(app.hClearWrite,      'Visible', app.play_LineVisibility.Value)
                set(app.hEmissionMarkers, 'Visible', app.play_LineVisibility.Value)
            catch
            end

        end

        % Value changed function: play_TraceIntegration
        function play_TraceIntegrationValueChanged(app, event)

            app.General.Integration.Trace = str2double(event.Value);

            if isinf(app.General.Integration.Trace) || strcmp(event.PreviousValue, 'Inf')
                if ~isempty(app.hMinHold)
                    plot_deleteLines(app, 'MinHold')
                    play_AxesToolbarCallbacks(app, struct('Source', app.axesTool_MinHold))
                end
    
                if ~isempty(app.hAverage)
                    plot_deleteLines(app, 'Average')
                    play_AxesToolbarCallbacks(app, struct('Source', app.axesTool_Average))
                end
    
                if ~isempty(app.hMaxHold)
                    plot_deleteLines(app, 'MaxHold')
                    play_AxesToolbarCallbacks(app, struct('Source', app.axesTool_MaxHold))
                end
            end

        end

        % Value changed function: play_Limits_xLim1, play_Limits_xLim2
        function play_xLimitsValueChanged(app, event)
            
            FreqRange = app.play_Limits_xLim2.Value - app.play_Limits_xLim1.Value;
            if FreqRange > 0
                app.UIAxes1.XLim = [app.play_Limits_xLim1.Value, app.play_Limits_xLim2.Value];
            else
                switch event.Source.Tag
                    case 'FreqStart'; app.play_Limits_xLim1.Value = event.PreviousValue;
                    case 'FreqStop';  app.play_Limits_xLim2.Value = event.PreviousValue;
                end
            end

        end

        % Value changed function: play_Limits_yLim1, play_Limits_yLim2
        function play_yLimitsValueChanged(app, event)

            LevelRange = app.play_Limits_yLim2.Value - app.play_Limits_yLim1.Value;
            if LevelRange > 0
                app.UIAxes1.YLim = [app.play_Limits_yLim1.Value, app.play_Limits_yLim2.Value];
            else
                switch event.Source.Tag
                    case 'MinLevel'; app.play_Limits_yLim1.Value = event.PreviousValue;
                    case 'MaxLevel'; app.play_Limits_yLim2.Value = event.PreviousValue;
                end
            end

        end

        % Selection changed function: play_ControlsPanel
        function play_ControlsPanelSelectionChanged(app, event)
            
            switch app.play_ControlsPanel.SelectedObject
                case app.play_RadioButton_Persistance; app.play_ControlsTab1Info.RowHeight(5:7) = {'1x',0,0};
                case app.play_RadioButton_Occupancy;   app.play_ControlsTab1Info.RowHeight(5:7) = {0,'1x',0};
                case app.play_RadioButton_Waterfall;   app.play_ControlsTab1Info.RowHeight(5:7) = {0,0,'1x'};
            end
            
        end

        % Value changed function: play_Customization
        function play_CustomizationValueChanged(app, event)
            
            if ~isempty(app.play_PlotPanel.UserData) && isvalid(app.play_PlotPanel.UserData)
                idx = app.play_PlotPanel.UserData.NodeData;
                prePlot_updatingCustomProperties(app, idx)

                if app.play_Customization.Value
                    [ParentTag, DataIndex] = plot.datatip.Search(app.UIFigure);
                    app.specData(idx).UserData.customPlayback.Parameters.Datatip = struct('ParentTag', ParentTag, 'DataIndex', DataIndex);    
                end            
            end            
            
        end

        % Callback function: play_Persistance_Colormap, 
        % ...and 4 other components
        function play_Persistance_Callbacks(app, event)
            
            % Os callbacks aqui descritos são aplicáveis apenas se estiver
            % habilitado o plot Persistance.
            if ~app.axesTool_Persistance.UserData.Value
                return
            end

            switch event.Source
                case app.play_Persistance_Interpolation
                    app.hPersistanceObj.handle.Interpolation = app.play_Persistance_Interpolation.Value;

                case app.play_Persistance_WindowSize
                    idx = app.play_PlotPanel.UserData.NodeData;

                    plot_Draw_Persistance(app, 'Delete', -1)

                    prePlot_updatingGeneralSettings(app)
                    prePlot_updatingCustomProperties(app, idx)
                    plot_Draw_Persistance(app, 'Creation', idx)

                case app.play_Persistance_Transparency
                    app.hPersistanceObj.handle.CData(isnan(app.hPersistanceObj.handle.CData)) = 0; 
                    app.hPersistanceObj.handle.AlphaData = double(logical(app.hPersistanceObj.handle.CData)) * app.play_Persistance_Transparency.Value;

                case app.play_Persistance_Colormap
                    plot.axes.Colormap(app.UIAxes1, app.play_Persistance_Colormap.Value)

                case app.play_Persistance_cLim_Mode
                    app.UIAxes1.CLimMode = 'auto';
                    app.play_Persistance_cLim1.Value = app.UIAxes1.CLim(1);
                    app.play_Persistance_cLim2.Value = app.UIAxes1.CLim(2);

                    app.UIAxes1.UserData.CLimMode = 'auto';
            end                
            drawnow
            
        end

        % Value changed function: play_Persistance_cLim1, 
        % ...and 1 other component
        function play_Persistance_cLimValueChanged(app, event)

            cLim = [app.play_Persistance_cLim1.Value, app.play_Persistance_cLim2.Value];
            if issorted(cLim, 'strictascend')
                app.UIAxes1.CLim = cLim;
                app.UIAxes1.UserData.CLimMode = 'manual';
            else
                switch event.Source
                    case app.play_Persistance_cLim1; app.play_Persistance_cLim1.Value = event.PreviousValue;
                    case app.play_Persistance_cLim2; app.play_Persistance_cLim2.Value = event.PreviousValue;
                end
            end

        end

        % Callback function: play_Waterfall_Colormap, 
        % ...and 5 other components
        function play_Waterfall_Callbacks(app, event)
            
            % Os callbacks aqui descritos são aplicáveis apenas se estiver
            % habilitado o plot Waterfall.
            if ~app.axesTool_Waterfall.UserData.Value
                return
            end

            app.progressDialog.Visible = 'visible';

            idx = app.play_PlotPanel.UserData.NodeData;
            switch event.Source
                %---------------------------------------------------------%
                case {app.play_Waterfall_Fcn, app.play_Waterfall_Decimation}
                    prePlot_updatingGeneralSettings(app)
                    prePlot_updatingCustomProperties(app, idx)

                    [~, ~, XData, YData] = plot.datatip.Search(app.UIAxes3);
                    app.hWaterfall = plot.draw3D.Waterfall('Delete', app.hWaterfall);
                    plot_Draw_Waterfall(app, idx)

                    if ~isempty(XData)
                        if event.Source == app.play_Waterfall_Fcn
                            for ii = 1:numel(YData)
                                switch event.Value
                                    case 'image'
                                        YData{ii} = Timestamp2idxTime(app.bandObj, idx, YData{ii});
                                    case 'mesh'
                                        YData{ii} = idxTime2Timestamp(app.bandObj, idx, YData{ii});
                                end
                            end
                        end

                        dtConfig = struct('XData', XData, 'YData', YData);
                        dtParent = app.hWaterfall;
                        plot.datatip.Create('redrawWaterfall', dtConfig, dtParent)                        
                    end

                %---------------------------------------------------------%
                case app.play_Waterfall_MeshStyle
                    app.hWaterfall.MeshStyle = app.play_Waterfall_MeshStyle.Value;

                %---------------------------------------------------------%
                case app.play_Waterfall_Timeline
                    switch app.play_Waterfall_Timeline.Value
                        case 'on'
                            prePlot_updatingGeneralSettings(app)
                            prePlot_updatingCustomProperties(app, idx)

                            app.hWaterfallTime = plot.draw2D.OrdinaryLine(app.UIAxes3, app.bandObj, idx, 'WaterfallTime');
                            plot.axes.StackingOrder.execute(app.UIAxes3, app.bandObj.Context)

                        case 'off'
                            if ~isempty(app.hWaterfallTime)
                                delete(app.hWaterfallTime) 
                                app.hWaterfallTime = [];
                            end
                    end

                %---------------------------------------------------------%
                case app.play_Waterfall_Colormap
                    plot.axes.Colormap(app.UIAxes3, app.play_Waterfall_Colormap.Value)

                %---------------------------------------------------------%
                case app.play_Waterfall_cLim_Mode
                    % Para que o eixo volte às configurações automáticas de
                    % CLim, e considerando como foi construída a classe Band, 
                    % em especial o seu método Limits, apaga-se temporariamente 
                    % a informação de customização... 
                    app.specData(idx).UserData.customPlayback = struct('Type', 'auto', 'Parameters', []);
                    
                    prePlot_updatingRestoreView(app, idx)
                    app.UIAxes3.CLim = app.restoreView(3).cLim;
                    app.UIAxes3.UserData.CLimMode = 'auto';

                    play_Layout_WaterfallPanel(app)

                    % E após os ajustes do eixo e do painel de Waterfall, 
                    % recria-se a informação de customização, caso aplicável.
                    prePlot_updatingGeneralSettings(app)
                    prePlot_updatingCustomProperties(app, idx)
            end

            app.progressDialog.Visible = 'hidden';

        end

        % Value changed function: play_Waterfall_Colorbar
        function play_Waterfall_ColorbarValueChanged(app, event)
            
            plot.axes.Colorbar(app.UIAxes3, app.play_Waterfall_Colorbar.Value)
            
        end

        % Value changed function: play_Waterfall_cLim1, 
        % ...and 1 other component
        function play_Waterfall_cLimValueChanged(app, event)

            cLim = [app.play_Waterfall_cLim1.Value, app.play_Waterfall_cLim2.Value];
            if issorted(cLim, 'strictascend')
                app.UIAxes3.CLim = cLim;
                app.UIAxes3.UserData.CLimMode = 'manual';
                
            else
                switch event.Source
                    case app.play_Waterfall_cLim1; app.play_Waterfall_cLim1.Value = event.PreviousValue;
                    case app.play_Waterfall_cLim2; app.play_Waterfall_cLim2.Value = event.PreviousValue;
                end
            end
            
        end

        % Value changed function: play_OCC_IntegrationTime, 
        % ...and 8 other components
        function play_Occupancy_Callbacks(app, event)
            
            play_OCCNewPlot(app)
            
        end

        % Selection changed function: play_Channel_RadioGroup
        function play_Channel_RadioGroupSelectionChanged(app, event)
            
            switch app.play_Channel_RadioGroup.SelectedObject
                case app.play_Channel_File
                    app.play_ControlsTab2Info.RowHeight(3:4) = {0, 80};

                otherwise
                    app.play_ControlsTab2Info.RowHeight(3:4) = {210, 0};

                    switch app.play_Channel_RadioGroup.SelectedObject
                        case app.play_Channel_ReferenceList
                            app.play_Channel_ListUpdate.Visible  = 1;
                            app.play_Channel_Grid.RowHeight(2:3) = {22,0};
                            
                            set(findobj(app.play_Channel_Grid, 'Type', 'uinumericeditfield'), 'Enable', 1, 'Editable', 0)
                            play_Channel_AutomaticChannelListValueChanged(app)
        
                        case app.play_Channel_Multiples
                            app.play_Channel_ListUpdate.Visible  = 0;
                            app.play_Channel_Grid.RowHeight(2:3) = {0,22};
                            
                            set(findobj(app.play_Channel_Grid, 'Type', 'uinumericeditfield'), 'Enable', 1, 'Editable', 1)
                            app.play_Channel_nChannels.Editable  = 0;
                            app.play_Channel_Class.Items         = app.channelObj.FindPeaks.Name;
        
                        case app.play_Channel_Single
                            app.play_Channel_ListUpdate.Visible  = 0;
                            app.play_Channel_Grid.RowHeight(2:3) = {0,22};                            
                            
                            set(app.play_Channel_nChannels,                 'Editable', 0, 'Value',  1)
                            set(app.play_Channel_FirstChannel, 'Enable', 1, 'Editable', 1)
                            set(app.play_Channel_BW,           'Enable', 1, 'Editable', 1)
                            set(app.play_Channel_LastChannel,  'Enable', 0, 'Editable', 0)
                            set(app.play_Channel_StepWidth,    'Enable', 0, 'Editable', 0, 'Value', -1)                            
                            app.play_Channel_Class.Items         = app.channelObj.FindPeaks.Name;
                            play_Channel_FirstChannelValueChanged(app)
                    end
            end
            
        end

        % Image clicked function: play_Channel_ListUpdate
        function play_Channel_AutomaticChannelListUpdate(app, event)
            
            idx = app.play_PlotPanel.UserData.NodeData;
            app.specData(idx).UserData.channelLibIndex = FindRelatedBands(app.channelObj, app.specData(idx));
            play_Channel_TreeBuilding(app, idx, 'play_Channel_ListUpdateImageClicked')

        end

        % Value changed function: play_Channel_List
        function play_Channel_AutomaticChannelListValueChanged(app, event)

            idxChannel   = str2double(extractBefore(app.play_Channel_List.Value, ': '));

            FirstChannel = app.channelObj.Channel(idxChannel).FirstChannel;
            LastChannel  = app.channelObj.Channel(idxChannel).LastChannel;
            StepWidth    = app.channelObj.Channel(idxChannel).StepWidth;

            app.play_Channel_FirstChannel.Value = FirstChannel;
            app.play_Channel_LastChannel.Value  = LastChannel;
            app.play_Channel_StepWidth.Value    = max(-1, StepWidth * 1000);
            app.play_Channel_BW.Value           = max(-1, app.channelObj.Channel(idxChannel).ChannelBW * 1000);
            app.play_Channel_Class.Items        = {app.channelObj.Channel(idxChannel).FindPeaksName};

            if ~isempty(app.channelObj.Channel(idxChannel).FreqList)
                FreqList = app.channelObj.Channel(idxChannel).FreqList;
            else
                FreqList = FirstChannel:StepWidth:LastChannel;
            end
            app.play_Channel_nChannels.Value    = numel(FreqList);
            play_ChannelListSample(app, FreqList)
            
        end

        % Value changed function: play_Channel_FirstChannel, 
        % ...and 2 other components
        function play_Channel_FirstChannelValueChanged(app, event)
            
            FreqList = [];

            switch app.play_Channel_RadioGroup.SelectedObject
                case app.play_Channel_Multiples
                    if (app.play_Channel_LastChannel.Value >= app.play_Channel_FirstChannel.Value) && (app.play_Channel_StepWidth.Value > 0)
                        FreqList = app.play_Channel_FirstChannel.Value:app.play_Channel_StepWidth.Value/1000:app.play_Channel_LastChannel.Value;                        
                        app.play_Channel_nChannels.Value = numel(FreqList);
                    else
                        app.play_Channel_nChannels.Value = -1;
                    end

                case app.play_Channel_Single
                    app.play_Channel_LastChannel.Value = app.play_Channel_FirstChannel.Value;
                    FreqList = app.play_Channel_FirstChannel.Value;
            end

            play_ChannelListSample(app, FreqList)
            
        end

        % Selection changed function: play_Channel_Tree
        function play_Channel_TreeSelectionChanged(app, event)

            if ~isempty(app.play_Channel_Tree.SelectedNodes)
                idx = app.play_PlotPanel.UserData.NodeData;

                srcChannel = app.play_Channel_Tree.SelectedNodes.NodeData.src;
                idxChannel = app.play_Channel_Tree.SelectedNodes.NodeData.idx;

                switch srcChannel
                    case 'channelLib'
                        app.play_Channel_ReferenceList.Value = 1;
                        play_Channel_RadioGroupSelectionChanged(app)
    
                        app.play_Channel_List.Value = app.play_Channel_List.Items{idxChannel};
                        play_Channel_AutomaticChannelListValueChanged(app)

                    case 'manual'
                        FirstChannel = app.specData(idx).UserData.channelManual(idxChannel).FirstChannel;
                        LastChannel  = app.specData(idx).UserData.channelManual(idxChannel).LastChannel;
                        StepWidth    = app.specData(idx).UserData.channelManual(idxChannel).StepWidth;
                        FreqList     = app.specData(idx).UserData.channelManual(idxChannel).FreqList;

                        if (StepWidth > 0) || ~isempty(FreqList)
                            app.play_Channel_Multiples.Value = 1;
                            if isempty(FreqList)
                                FreqList = FirstChannel:StepWidth:LastChannel;
                            end
                        else
                            app.play_Channel_Single.Value    = 1;
                            FreqList = FirstChannel;
                        end
                        play_Channel_RadioGroupSelectionChanged(app)
    
                        app.play_Channel_Name.Value          = app.specData(idx).UserData.channelManual(idxChannel).Name;
                        app.play_Channel_FirstChannel.Value  = FirstChannel;
                        app.play_Channel_LastChannel.Value   = LastChannel;
                        app.play_Channel_StepWidth.Value     = max(-1, StepWidth * 1000);
                        app.play_Channel_BW.Value            = max(-1, app.specData(idx).UserData.channelManual(idxChannel).ChannelBW * 1000);
                        set(app.play_Channel_Class, 'Items', app.channelObj.FindPeaks.Name, 'Value', app.specData(idx).UserData.channelManual(idxChannel).FindPeaksName)
            
                        app.play_Channel_nChannels.Value     = numel(FreqList);
                        play_ChannelListSample(app, FreqList)
                end

                plot_Draw_Channels(app, idx)
            end
            
        end

        % Image clicked function: play_Channel_add
        function play_Channel_addChannel(app, event)
            
            focus(app.play_Channel_Tree)

            try
                idx = app.play_PlotPanel.UserData.NodeData;
                idxThreads = idx;

                switch app.play_Channel_RadioGroup.SelectedObject
                    %-----------------------------------------------------%
                    case app.play_Channel_ReferenceList
                        chIndex = str2double(extractBefore(app.play_Channel_List.Value, ': '));

                        channel2Add   = app.channelObj.Channel(chIndex);
                        typeOfChannel = 'channelLib';

                    %-----------------------------------------------------%
                    case {app.play_Channel_Multiples, app.play_Channel_Single}
                        channelName = strtrim(app.play_Channel_Name.Value);
                        refNames    = {app.specData(idx).UserData.channelManual.Name};

                        if isempty(channelName)
                            error('winAppAnalise:play_Channel_addChannel', 'O nome de um registro de canalização não pode ser vazio.')
                        elseif ismember(channelName, refNames)
                            msgQuestion   = sprintf(['Já existe uma canalização inserida manualmente com o nome "%s". ' ...
                                                     'Deseja editar as informações desse registro?'], channelName);
                            userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                            
                            if strcmp(userSelection, 'Não')
                                return
                            end
                        end

                        FirstChannel  = app.play_Channel_FirstChannel.Value;
                        LastChannel   = app.play_Channel_LastChannel.Value;
                        channelBW     = max(0, app.play_Channel_BW.Value/1000); 
                        StepWidth     = app.play_Channel_StepWidth.Value/1000;
                        if StepWidth < 0
                            StepWidth = -1;
                        end

                        channel2Add   = struct('Name',          channelName,                                         ...
                                               'Band',          [FirstChannel-channelBW/2; LastChannel+channelBW/2], ...
                                               'FirstChannel',  FirstChannel,                                        ...
                                               'LastChannel',   LastChannel,                                         ...
                                               'StepWidth',     StepWidth,                                           ...
                                               'ChannelBW',     channelBW,                                           ...
                                               'FreqList',      [],                                                  ...
                                               'Reference',     'Inclusão manual',                                   ...
                                               'FindPeaksName', app.play_Channel_Class.Value);
                        typeOfChannel = 'manual';
    
                    %-----------------------------------------------------%
                    case app.play_Channel_File
                        [fileFullPath, fileFolder] = appUtil.modalWindow(app.UIFigure, 'uigetfile', '', {'*.json', 'appAnalise (*.json)'}, app.General.fileFolder.lastVisited);
                        if isempty(fileFullPath)
                            return
                        end
                        misc_updateLastVisitedFolder(app, fileFolder)
    
                        channel2Add   = readFileWithChannel2Add(app.channelObj, fileFullPath);

                        msgQuestion   = sprintf(['Foram extraídos os registros %s, os quais serão incluídos na lista de canais manuais do ' ...
                                                 'fluxo espectral selecionado, caso se sobreponham à faixa de frequência, substituindo '    ...
                                                 'eventuais canalizações inseridas manualmente que tenham um dos supracitados nomes.\n\n'   ...
                                                 'Deseja analisar a inclusão desses registros para os outros fluxos?'], textFormatGUI.cellstr2ListWithQuotes({channel2Add.Name}));
                        userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                        
                        if strcmp(userSelection, 'Sim')
                            idxThreads = 1:numel(app.specData);
                        end
                        typeOfChannel = 'manual';
                end

                % Valida o novo registro, incluindo-o depois, caso não retorne 
                % erro na validação.
                for ii = 1:numel(channel2Add)
                    channelCell2Add = struct2cell(channel2Add(ii));
                    checkIfNewChannelIsValid(app.channelObj, channelCell2Add{:})                    
                end
                addChannel(app.channelObj, typeOfChannel, app.specData, idxThreads, channel2Add)

                % Por fim, reescreve a árvore...
                play_Channel_TreeBuilding(app, idx, 'play_Channel_addChannel')

            catch ME
                appUtil.modalWindow(app.UIFigure, 'error', ME.message);
            end

        end

        % Menu selected function: play_Channel_ContextMenu_del
        function play_Channel_ContextMenu_delChannelSelected(app, event)
            
            % Operação realizada a partir do menu de contexto, apagando a
            % canalização selecionada.

            if ~isempty(app.play_Channel_Tree.SelectedNodes)
                idx = app.play_PlotPanel.UserData.NodeData;

                srcChannel = app.play_Channel_Tree.SelectedNodes.NodeData.src;
                idxChannel = app.play_Channel_Tree.SelectedNodes.NodeData.idx;

                switch srcChannel
                    case 'channelLib'
                        app.specData(idx).UserData.channelLibIndex = setdiff(app.specData(idx).UserData.channelLibIndex, idxChannel);
                    case 'manual'
                        app.specData(idx).UserData.channelManual(idxChannel) = [];
                end
                
                play_Channel_TreeBuilding(app, idx, 'play_Channel_ContextMenu_delChannel')
            end

        end

        % Menu selected function: play_Channel_ContextMenu_addBandLimit
        function play_Channel_ContextMenu_addBandLimitSelected(app, event)
            
            % Operação realizada a partir do menu de contexto, inserindo os
            % limites da canalização selecionada como limite de detecção de 
            % emissões.

            if ~isempty(app.play_Channel_Tree.SelectedNodes)
                idx = app.play_PlotPanel.UserData.NodeData;

                srcChannel = app.play_Channel_Tree.SelectedNodes.NodeData.src;
                idxChannel = app.play_Channel_Tree.SelectedNodes.NodeData.idx;

                switch srcChannel
                    case 'channelLib'
                        xLim1 = app.channelObj.Channel(idxChannel).Band(1);
                        xLim2 = app.channelObj.Channel(idxChannel).Band(2);
                    case 'manual'
                        xLim1 = app.specData(idx).UserData.channelManual(idxChannel).Band(1);
                        xLim2 = app.specData(idx).UserData.channelManual(idxChannel).Band(2);
                end

                xLim1 = max(xLim1, app.play_BandLimits_xLim1.Limits(1));
                xLim2 = min(xLim2, app.play_BandLimits_xLim1.Limits(2));

                app.play_BandLimits_xLim1.Value = xLim1;
                app.play_BandLimits_xLim2.Value = xLim2;

                if ~app.play_BandLimits_Status.Value
                    app.play_BandLimits_Status.Value = 1;
                    play_BandLimits_StatusValueChanged(app)
                end
                play_BandLimits_addImageClicked(app)
            end

        end

        % Menu selected function: play_Channel_ContextMenu_addEmission
        function play_Channel_ContextMenu_addEmissionSelected(app, event)
            
            % Operação realizada a partir do menu de contexto, inserindo os
            % canais da canalização selecionada como emissões.

            if ~isempty(app.play_Channel_Tree.SelectedNodes)
                idxThread  = app.play_PlotPanel.UserData.NodeData;

                srcChannel = app.play_Channel_Tree.SelectedNodes.NodeData.src;
                idxChannel = app.play_Channel_Tree.SelectedNodes.NodeData.idx;

                switch srcChannel
                    case 'channelLib'
                        specChannel = app.channelObj.Channel(idxChannel);
                    case 'manual'
                        specChannel = app.specData(idxThread).UserData.channelManual(idxChannel);
                end

                newFreq  = specChannel.FreqList;
                if isempty(newFreq)
                    newFreq = (specChannel.FirstChannel:specChannel.StepWidth:specChannel.LastChannel)';
                end
                [newIndex, invalidIndex] = freq2idx(app.bandObj, newFreq .* 1e+6, 'OnlyCheck');

                newFreq(invalidIndex)  = [];
                newIndex(invalidIndex) = [];
                
                if ~isempty(newIndex)
                    newBW = specChannel.ChannelBW;
                    if newBW < 0
                        newBW = 0;
                    end
                    newBW = newBW * 1000; % Em kHz
        
                    NN = numel(newIndex);
                    play_AddEmission2List(app, idxThread, newIndex, newFreq, repmat(newBW, NN, 1), repmat({jsonencode(struct('Algorithm', 'Manual'))}, NN, 1))

                else
                    msgWarning = ['Não identificado canal cuja frequência central esteja contida ' ...
                                  'na faixa de frequência do fluxo espectral sob análise.'];
                    appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                end
            end

        end

        % Selection changed function: play_FindPeaks_RadioGroup
        function play_FindPeaks_RadioGroupSelectionChanged(app, event)
            
            switch app.play_FindPeaks_RadioGroup.SelectedObject
                case app.play_FindPeaks_auto
                    play_FindPeaks_AlgorithmValueChanged(app)

                case app.play_FindPeaks_File
                    app.play_ControlsTab3Info.RowHeight(3:4) = {0,80};

                otherwise % ROI | DataTips
                    app.play_ControlsTab3Info.RowHeight(3:4) = {0,0};
            end
            
        end

        % Value changed function: play_FindPeaks_Algorithm
        function play_FindPeaks_AlgorithmValueChanged(app, event)
            
            switch app.play_FindPeaks_Algorithm.Value
                case 'FindPeaks'
                    app.play_ControlsTab3Info.RowHeight(3:4) = {174,0};
                    app.play_FindPeaks_ParametersGrid.RowHeight([3 4 7]) = {25,22,0};
                    
                    app.play_FindPeaks_prominenceLabel.Visible = 1;
                    app.play_FindPeaks_prominence.Visible      = 1;

                    app.play_FindPeaks_ClassLabel.Visible = 0;
                    app.play_FindPeaks_Class.Visible      = 0;

                case 'FindPeaks+OCC'
                    app.play_ControlsTab3Info.RowHeight(3:4) = {210,0};
                    app.play_FindPeaks_ParametersGrid.RowHeight([3 4 7]) = {0,0,88};

                    app.play_FindPeaks_prominenceLabel.Visible = 0;
                    app.play_FindPeaks_prominence.Visible      = 0;

                    app.play_FindPeaks_ClassLabel.Visible = 1;
                    app.play_FindPeaks_Class.Visible      = 1;
            end

        end

        % Selection changed function: play_FindPeaks_Tree
        function play_FindPeaks_TreeSelectionChanged(app, event)
            
            if isscalar(app.play_FindPeaks_Tree.SelectedNodes)
                idxThread   = app.play_PlotPanel.UserData.NodeData;
                idxEmission = app.play_FindPeaks_Tree.SelectedNodes.NodeData;

                set(app.play_FindPeaks_PeakCF, 'Value', round(app.specData(idxThread).UserData.Emissions.Frequency(idxEmission), 3), 'Enable', 1)
                set(app.play_FindPeaks_PeakBW, 'Value', round(app.specData(idxThread).UserData.Emissions.BW(idxEmission), 3),        'Enable', 1)

                userDescription = app.specData(idxThread).UserData.Emissions.UserData(idxEmission).Description;
                set(app.play_FindPeaks_Description, 'Value', userDescription, 'Enable', 1)

                if strcmp(app.play_FindPeaks_Tree.SelectedNodes.Icon, 'signalTruncated_32.png')
                    app.play_FindPeaks_ContextMenu_digital.Enable = 0;
                    app.play_FindPeaks_ContextMenu_analog.Enable  = 1;
                else
                    app.play_FindPeaks_ContextMenu_digital.Enable = 1;
                    app.play_FindPeaks_ContextMenu_analog.Enable  = 0;
                end
                app.tool_RFDataHub.Enable = 1;
                app.tool_DriveTest.Enable = 1;

                if exist('event', 'var')
                    plot.draw2D.ClearWrite_old(app, idxThread, 'TreeSelectionChanged', [])
                end

            else
                set(app.play_FindPeaks_PeakCF,      'Value', -1, 'Enable', 0)
                set(app.play_FindPeaks_PeakBW,      'Value', -1, 'Enable', 0)
                set(app.play_FindPeaks_Description, 'Value', '', 'Enable', 0)

                set(app.play_FindPeaks_ContextMenu_edit.Children, 'Enable', 1)
                app.tool_RFDataHub.Enable = 0;
                app.tool_DriveTest.Enable = 0;
            end
            
        end

        % Image clicked function: play_FindPeaks_add
        function play_FindPeaks_addEmission(app, event)
            
            focus(app.play_FindPeaks_Tree)

            idx = app.play_PlotPanel.UserData.NodeData;
            newIndex = [];

            switch app.play_FindPeaks_RadioGroup.SelectedObject
                %---------------------------------------------------------%
                case app.play_FindPeaks_File
                    switch app.play_FindPeaks_ExternalFile.Value
                        case 'Generic (csv, txt, json, xls, xlsx)'
                            fileFormats = {'*.csv;*.txt;*.json;*.xls;*.xlsx', '(*.csv,*.txt,*.json,*.xls,*.xlsx)'};
                        case 'Romes (csv)'
                            fileFormats = {'*.csv', '(*.csv)'};
                    end

                    [fileFullPath, fileFolder, fileExt] = appUtil.modalWindow(app.UIFigure, 'uigetfile', '', fileFormats, app.General.fileFolder.lastVisited);
                    if isempty(fileFullPath)
                        return
                    end
                    misc_updateLastVisitedFolder(app, fileFolder)

                    try
                        switch fileExt
                            case '.json'
                                rawTable = struct2table(jsondecode(fileread(fileFullPath)), 'AsArray', true);
                            otherwise
                                switch app.play_FindPeaks_ExternalFile.Value
                                    case 'Generic (csv, txt, json, xls, xlsx)'
                                        rawTable = readtable(fileFullPath);
                                    case 'Romes (csv)'
                                        rawTable = fileReader.RomesCSV(fileFullPath);
                                end
                        end
                        rawTable.Properties.VariableNames = {'Frequency', 'BW', 'Description'};

                        if ~isempty(rawTable)
                            msgQuestion   = sprintf(['Foram extraídos registros de emissões centralizadas em %s.\n\nEssas emissões serão incluídas na lista ' ...
                                                     'de emissões do fluxo espectral selecionado, caso se sobreponham à faixa de frequência.\n\nDeseja '      ...
                                                     'analisar a inclusão desses registros para os outros fluxos?'],                                          ...
                                                     strjoin(string(sort(rawTable.Frequency))+" MHz", ', '));
                            userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                            if strcmp(userSelection, 'Sim')
                                idxThreads  = 1:numel(app.specData);
                                tempBandObj = class.Band('appAnalise:PLAYBACK', app);
                            else
                                idxThreads  = idx;
                                tempBandObj = app.bandObj;
                            end
                            
                            for ii = idxThreads
                                update(tempBandObj, ii);
                                tempBandTable = rawTable;

                                [newIndex, invalidIndex] = freq2idx(tempBandObj, tempBandTable.Frequency .* 1e+6, 'OnlyCheck');
                                if all(invalidIndex)
                                    continue
                                end

                                tempBandTable(invalidIndex,:) = [];
                                newIndex(invalidIndex)        = [];

                                newFreq  = tempBandTable.Frequency;         % Em MHz
                                newBW    = tempBandTable.BW;                % Em kHz
                                
                                Method   = {};
                                for jj = 1:height(tempBandTable)
                                    Method{jj,1} = jsonencode(struct('Algorithm', 'ExternalFile', 'Description', tempBandTable.Description{jj}));
                                end

                                NN = numel(newIndex);
                                if NN
                                    play_AddEmission2List(app, ii, newIndex, newFreq, newBW, Method)
                                end
                            end
                        end

                    catch ME
                        appUtil.modalWindow(app.UIFigure, 'warning', ME.message);
                        return
                    end

                otherwise
                    switch app.play_FindPeaks_RadioGroup.SelectedObject
                        %-------------------------------------------------%
                        case app.play_FindPeaks_auto
                            switch app.play_FindPeaks_Algorithm.Value
                                case 'FindPeaks'
                                    Attributes = struct('Algorithm',  app.play_FindPeaks_Algorithm.Value,  ...
                                                        'Fcn',        app.play_FindPeaks_Trace.Value,      ...
                                                        'NPeaks',     app.play_FindPeaks_Numbers.Value,    ...
                                                        'THR',        app.play_FindPeaks_THR.Value,        ...
                                                        'Prominence', app.play_FindPeaks_prominence.Value, ...
                                                        'Distance',   app.play_FindPeaks_distance.Value,   ...
                                                        'BW',         app.play_FindPeaks_BW.Value);
        
                                    [newIndex, newFreq, newBW, Method] = fcn.Detection_FindPeaks(app.specData, idx, Attributes);
        
                                case 'FindPeaks+OCC'
                                    Attributes = struct('Algorithm',   app.play_FindPeaks_Algorithm.Value,   ...
                                                        'Distance',    app.play_FindPeaks_distance.Value,    ...
                                                        'BW',          app.play_FindPeaks_BW.Value,          ...
                                                        'Prominence1', app.play_FindPeaks_Prominence1.Value, ...
                                                        'Prominence2', app.play_FindPeaks_Prominence2.Value, ...
                                                        'meanOCC',     app.play_FindPeaks_meanOCC.Value,     ...
                                                        'maxOCC',      app.play_FindPeaks_maxOCC.Value);
                                    
                                    [newIndex, newFreq, newBW, Method] = fcn.Detection_FindPeaksPlusOCC(app, app.specData, idx, Attributes);
                            end    
                            newBW  = newBW * 1000;

                        %-------------------------------------------------%
                        case app.play_FindPeaks_ROI
                            % Incluir uma emissõe por ROI demanda eliminar
                            % interações do plot.
                            app.play_FindPeaks_add.Enable = 0;
                            if app.axesTool_DataTip.UserData
                                play_AxesToolbarCallbacks(app, struct('Source', app.axesTool_DataTip))
                            end
                            plot.axes.Interactivity.DefaultDisable([app.UIAxes1, app.UIAxes2, app.UIAxes3])
                            drawnow
                            
                            mkrTemp  = drawrectangle(app.UIAxes1, Color=[0.40,0.73,0.88], LineWidth=1, Tag='mkrTemp');
                            app.play_FindPeaks_add.Enable = 1;
        
                            plot.axes.Interactivity.DefaultEnable([app.UIAxes1, app.UIAxes2, app.UIAxes3])
            
                            newFreq  = mkrTemp.Position(1) + mkrTemp.Position(3)/2; % Em MHz
                            newBW    = mkrTemp.Position(3) * 1000;                  % Em kHz
                            newIndex = freq2idx(app.bandObj, newFreq .* 1e+6);
                            Method   = jsonencode(struct('Algorithm', 'Manual'));
        
                            % Se for desenhada uma ROI fora dos limites do eixo,
                            % a função freq2idx retornará ela nas extremidades do 
                            % eixo. Nesse caso, exclui-se a ROI.                            
                            if ismember(newIndex, [1, app.specData(idx).MetaData.DataPoints])                    
                               delete(mkrTemp)
                               return
                            end
        
                        %-------------------------------------------------%
                        case app.play_FindPeaks_DataTips
                            hDataTips = findobj('Type', 'DataTip');
                            if isempty(hDataTips)
                                return
                            end
            
                            newFreq = [];
                            ii = 0;
                            while ii < numel(hDataTips)
                                ii = ii+1;
                                if isequal(hDataTips(ii).Parent.Parent.Parent.Parent, app.play_PlotPanel)
                                    newFreq(end+1,1) = double(round(hDataTips(ii).X, 3));   % Em MHz
                                end
                            end
                            newBW    = zeros(numel(newFreq), 1);
                            newIndex = freq2idx(app.bandObj, newFreq .* 1e+6);
                            Method   = repmat({jsonencode(struct('Algorithm', 'Manual'))}, numel(newFreq), 1);
                    end
                
                    if ischar(Method)
                        Method = {Method};
                    end
    
                    NN = numel(newIndex);
                    if NN
                        play_AddEmission2List(app, idx, newIndex, newFreq, newBW, Method)
                    else
                        if exist('mkrTemp', 'var')
                            delete(mkrTemp)
                        end
                    end
            end
            
            if isempty(newIndex)
                appUtil.modalWindow(app.UIFigure, 'warning', 'Não identificado pico que atenda as condições estabelecidas.');
            end
            
        end

        % Menu selected function: play_FindPeaks_ContextMenu_del
        function play_FindPeaks_delEmission(app, event)
            
            if ~isempty(app.play_FindPeaks_Tree.SelectedNodes)
                idx = app.play_PlotPanel.UserData.NodeData;
                idxEmission = [app.play_FindPeaks_Tree.SelectedNodes.NodeData];
                app.specData(idx).UserData.Emissions(idxEmission,:) = [];
                
                plot.draw2D.ClearWrite_old(app, idx, 'DeleteButtonPushed', 1)
                play_UpdatePeaksTable(app, idx, 'playback.AddEditOrDeleteEmission')
            end
            
        end

        % Value changed function: play_FindPeaks_Description, 
        % ...and 2 other components
        function play_FindPeaks_editEmission(app, event)
            
            idx = app.play_PlotPanel.UserData.NodeData;
            idxEmission = app.play_FindPeaks_Tree.SelectedNodes(1).NodeData;

            % Ao alterar as características de frequência e BW de uma emissão, 
            % a emissão alterada é considerada como uma NOVA emissão. Logo,
            % as informações eventualmente geradas no módulo de Drive-Test
            % são perdidas.

            emissionInfo = jsondecode(app.specData(idx).UserData.Emissions.Detection{idxEmission});

            switch event.Source
                case app.play_FindPeaks_PeakCF
                    if (app.play_FindPeaks_PeakCF.Value*1e+6 < app.specData(idx).MetaData.FreqStart) || ...
                       (app.play_FindPeaks_PeakCF.Value*1e+6 > app.specData(idx).MetaData.FreqStop)
                    
                       app.play_FindPeaks_PeakCF.Value = round(app.specData(idx).UserData.Emissions.Frequency(idxEmission), 3);
                       return
                    end
                    
                    newIndex = freq2idx(app.bandObj, app.play_FindPeaks_PeakCF.Value*1e+6);
                    app.play_FindPeaks_PeakCF.Value = app.bandObj.xArray(newIndex);

                    emissionInfo.Algorithm = 'Manual';                    
                    app.specData(idx).UserData.Emissions(idxEmission,[1,2,5]) = {newIndex, app.play_FindPeaks_PeakCF.Value, jsonencode(emissionInfo, 'ConvertInfAndNaN', false)};
                    app.specData(idx).UserData.Emissions.UserData(idxEmission).DriveTest = [];
                    play_BandLimits_updateEmissions(app, idx, newIndex)

                case app.play_FindPeaks_PeakBW
                    emissionInfo.Algorithm = 'Manual';
                    app.specData(idx).UserData.Emissions(idxEmission,[3,5]) = {app.play_FindPeaks_PeakBW.Value, jsonencode(emissionInfo, 'ConvertInfAndNaN', false)};
                    app.specData(idx).UserData.Emissions.UserData(idxEmission).DriveTest = [];
                    plot.draw2D.ClearWrite_old(app, idx, 'PeakValueChanged', idxEmission)

                case app.play_FindPeaks_Description
                    userDescription = strtrim(app.play_FindPeaks_Description.Value);
                    userDescription(cellfun(@(x) isempty(x), userDescription)) = [];
                    if isempty(userDescription)
                        userDescription = '';
                    end
                    app.play_FindPeaks_Description.Value = userDescription;
                    
                    emissionInfo.Description = userDescription;
                    app.specData(idx).UserData.Emissions.Detection{idxEmission} = jsonencode(emissionInfo, 'ConvertInfAndNaN', false);
                    app.specData(idx).UserData.Emissions.UserData(idxEmission).Description = userDescription;
            end

            play_UpdatePeaksTable(app, idx, 'playback.AddEditOrDeleteEmission')
            
        end

        % Menu selected function: play_FindPeaks_ContextMenu_analog, 
        % ...and 1 other component
        function play_FindPeaks_TruncatedEmission(app, event)

            idx = app.play_PlotPanel.UserData.NodeData;

            for ii = 1:numel(app.play_FindPeaks_Tree.SelectedNodes)
                idxEmission = app.play_FindPeaks_Tree.SelectedNodes(ii).NodeData;
    
                switch event.Source.Text
                    case 'Truncar frequência'
                        app.specData(idx).UserData.Emissions.isTruncated(idxEmission) = 1;
                        app.play_FindPeaks_Tree.SelectedNodes(ii).Icon = 'signalTruncated_32.png';
    
                    case 'Não truncar'
                        app.specData(idx).UserData.Emissions.isTruncated(idxEmission) = 0;
                        app.play_FindPeaks_Tree.SelectedNodes(ii).Icon = 'signalUntruncated_32.png';
                end
            end            
            play_FindPeaks_TreeSelectionChanged(app)            
            play_UpdatePeaksTable(app, idx, 'playback.AddEditOrDeleteEmission')
            
        end

        % Value changed function: play_FindPeaks_maxOCC, 
        % ...and 1 other component
        function play_FindPeaks_OCCValueChanged(app, event)

            switch event.Source
                case app.play_FindPeaks_meanOCC
                    if app.play_FindPeaks_meanOCC.Value > app.play_FindPeaks_maxOCC.Value
                        app.play_FindPeaks_maxOCC.Value = app.play_FindPeaks_meanOCC.Value;
                    end

                case app.play_FindPeaks_maxOCC
                    if app.play_FindPeaks_maxOCC.Value < app.play_FindPeaks_meanOCC.Value
                        app.play_FindPeaks_meanOCC.Value = app.play_FindPeaks_maxOCC.Value;
                    end
            end

        end

        % Value changed function: play_FindPeaks_Class
        function play_FindPeaks_ClassValueChanged(app, event)
            
            idx = find(strcmp(app.channelObj.FindPeaks.Name, app.play_FindPeaks_Class.Value), 1);

            app.play_FindPeaks_distance.Value    = 1000 * app.channelObj.FindPeaks.Distance(idx);
            app.play_FindPeaks_BW.Value          = 1000 * app.channelObj.FindPeaks.BW(idx);
            app.play_FindPeaks_Prominence1.Value = app.channelObj.FindPeaks.Prominence1(idx);
            app.play_FindPeaks_Prominence2.Value = app.channelObj.FindPeaks.Prominence2(idx);
            app.play_FindPeaks_meanOCC.Value     = app.channelObj.FindPeaks.meanOCC(idx);
            app.play_FindPeaks_maxOCC.Value      = app.channelObj.FindPeaks.maxOCC(idx);
                        
        end

        % Value changed function: play_BandLimits_Status
        function play_BandLimits_StatusValueChanged(app, event)
            
            idx = app.play_PlotPanel.UserData.NodeData;
            play_BandLimits_Layout(app, idx)

            if app.play_BandLimits_Status.Value                      && ...
                ~isempty(app.specData(idx).UserData.bandLimitsTable) && ...
                ~isempty(app.specData(idx).UserData.Emissions)

                msgQuestion   = 'Confirma a reanálise das emissões, eventualmente eliminando aquelas que não estão em uma das subfaixas sob análise?';
                userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                if userSelection == "Não"
                    app.play_BandLimits_Status.Value = 0;
                    play_BandLimits_Layout(app, idx)
                    return
                end

                % Identificar o índice da emissão selecionada, para o qual
                % foi desenhado um ROI no app.axes1.
                idxEmission = app.play_FindPeaks_Tree.SelectedNodes(1).NodeData;
                newIndex = app.specData(idx).UserData.Emissions.Index(idxEmission);

                play_BandLimits_updateEmissions(app, idx, newIndex)
                play_UpdatePeaksTable(app, idx, 'playback.AddEditOrDeleteEmission')
            end

            plot.draw2D.horizontalSetOfLines(app.UIAxes1, app.bandObj, idx, 'BandLimits')
            
        end

        % Image clicked function: play_BandLimits_add
        function play_BandLimits_addImageClicked(app, event)
            
            focus(app.play_BandLimits_Tree)

            idx = app.play_PlotPanel.UserData.NodeData;
            bandLimitsTable = app.specData(idx).UserData.bandLimitsTable;

            % Validações:
            if app.play_BandLimits_xLim2.Value <= app.play_BandLimits_xLim1.Value                    
                appUtil.modalWindow(app.UIFigure, 'warning', 'Subfaixa inválida.');
                return

            elseif any((bandLimitsTable.FreqStart <= app.play_BandLimits_xLim1.Value) & (bandLimitsTable.FreqStop >= app.play_BandLimits_xLim2.Value))
                appUtil.modalWindow(app.UIFigure, 'warning', 'Subfaixa já contemplada.');
                return
            end

            % Compara subfaixa a analisar inserida com os registros já existentes.
            xLim1 = app.play_BandLimits_xLim1.Value;
            xLim2 = app.play_BandLimits_xLim2.Value;

            % Passo 1 de 2
            Flag = true;
            for ii = 1:height(bandLimitsTable)
                if (xLim1 <= bandLimitsTable.FreqStart(ii)) && (xLim2 >= bandLimitsTable.FreqStop(ii))
                    bandLimitsTable(ii,:) = {xLim1, xLim2};
                    Flag = false;
                    continue
                
                elseif (xLim1 <= bandLimitsTable.FreqStart(ii)) && (xLim2 > bandLimitsTable.FreqStart(ii)) && (xLim2 < bandLimitsTable.FreqStop(ii))
                    bandLimitsTable(ii,1) = {xLim1};
                    Flag = false;
                    continue

                elseif (xLim1 > bandLimitsTable.FreqStart(ii)) && (xLim1 < bandLimitsTable.FreqStop(ii)) && (xLim2 >= bandLimitsTable.FreqStop(ii))
                    bandLimitsTable(ii,2) = {xLim2};
                    Flag = false;
                    continue
                end
            end

            if Flag
                bandLimitsTable(end+1,:) = {xLim1, xLim2};
            end
            bandLimitsTable = sortrows(bandLimitsTable, 'FreqStart');

            % Passo 2 de 2
            for ii = height(bandLimitsTable):-1:2
                if bandLimitsTable.FreqStart(ii) <= bandLimitsTable.FreqStop(ii-1)
                    bandLimitsTable(ii-1,2) = {bandLimitsTable.FreqStop(ii)};
                    bandLimitsTable(ii,:)   = [];
                end
            end

            if isempty(app.specData(idx).UserData.bandLimitsTable) && ...
              ~isempty(app.specData(idx).UserData.Emissions)

                msgQuestion   = 'Confirma a reanálise das emissões, eventualmente eliminando aquelas que não estão em uma das subfaixas sob análise?';
                userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                if userSelection == "Não"
                    return
                end

                % Identificar o índice da emissão selecionada, para o qual
                % foi desenhado um ROI no app.axes1.
                idxEmission = app.play_FindPeaks_Tree.SelectedNodes(1).NodeData;
                newIndex = app.specData(idx).UserData.Emissions.Index(idxEmission);

                app.specData(idx).UserData.bandLimitsTable = bandLimitsTable;
                play_BandLimits_updateEmissions(app, idx, newIndex)
                play_UpdatePeaksTable(app, idx, 'playback.AddEditOrDeleteEmission')

            else
                app.specData(idx).UserData.bandLimitsTable = bandLimitsTable;
            end

            play_BandLimits_TreeBuilding(app, idx)
            plot.draw2D.horizontalSetOfLines(app.UIAxes1, app.bandObj, idx, 'BandLimits')

        end

        % Menu selected function: play_BandLimits_ContextMenu_del
        function play_BandLimits_ContextMenu_delSelected(app, event)
            
            if ~isempty(app.play_BandLimits_Tree.SelectedNodes)
                idx = app.play_PlotPanel.UserData.NodeData;
                idxBandLimits = [app.play_BandLimits_Tree.SelectedNodes.NodeData];
                
                if ~isempty(app.specData(idx).UserData.Emissions) && height(app.specData(idx).UserData.bandLimitsTable) > 1
                    msgQuestion   = 'Confirma a reanálise das emissões, eventualmente eliminando aquelas que não estão em uma das subfaixas sob análise?';
                    userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                    if userSelection == "Não"
                        return
                    end
                end
    
                app.specData(idx).UserData.bandLimitsTable(idxBandLimits,:) = [];
                if exist('userSelection', 'var')
                    play_BandLimits_updateEmissions(app, idx, app.specData(idx).UserData.Emissions.Index)
                    play_UpdatePeaksTable(app, idx,'playback.AddEditOrDeleteEmission')
                end
    
                play_BandLimits_TreeBuilding(app, idx)
                plot.draw2D.horizontalSetOfLines(app.UIAxes1, app.bandObj, idx, 'BandLimits')
            end

        end

        % Image clicked function: tool_RFDataHub
        function play_RFDataHubButtonPushed(app, event)
            
            global RFDataHub

            idxThread = app.play_PlotPanel.UserData.NodeData;
            idxEmission = app.play_FindPeaks_Tree.SelectedNodes(1).NodeData;

            % Inicialmente, trunca-se a frequência da emissão selecionada, 
            % caso aplicável.            
            if app.specData(idxThread).UserData.Emissions.isTruncated(idxEmission)
                Truncated = TruncatedFrequency(app.channelObj, app.specData(idxThread), idxEmission);
            else
                Truncated = app.specData(idxThread).UserData.Emissions.Frequency(idxEmission);
            end            

            % Identifica na base de dados offline (anateldb) aqueles registros 
            % que possuem a mesma frequência (tolerância: 1e-5).
            idxRFDataHub = find(abs(RFDataHub.Frequency - Truncated) <= class.Constants.floatDiffTolerance);
            if ~isempty(idxRFDataHub)
                auxDistance      = deg2km(distance(app.specData(idxThread).GPS.Latitude, app.specData(idxThread).GPS.Longitude, RFDataHub.Latitude(idxRFDataHub), RFDataHub.Longitude(idxRFDataHub)));
                [Distance, idx4] = min(auxDistance);
                Description      = class.RFDataHub.Description(RFDataHub, idxRFDataHub(idx4));

                if app.specData(idxThread).UserData.Emissions.isTruncated(idxEmission)
                    msg = sprintf(['A frequência central da emissão (%.3f MHz) foi truncada em <b>%.5f MHz</b>.\n\n'                            ...
                                   'Foram identificados <b>%d registros</b> de estações cujas frequências centrais coincidem com %.3f MHz.\n\n' ...
                                   'A estação mais próxima do local de monitoração está a <b>%.1f km</b>, tendo como descrição "<b>%s</b>"'],   ...
                                   app.specData(idxThread).UserData.Emissions.Frequency(idxEmission), Truncated, numel(idxRFDataHub), Truncated, Distance, Description);
                else
                    msg = sprintf(['A frequência central da emissão (%.3f MHz) não foi truncada.\n\n'                                           ...
                                   'Foram identificados <b>%d registros</b> de estações cujas frequências centrais coincidem com %.3f MHz.\n\n' ...
                                   'A estação mais próxima do local de monitoração está a <b>%.1f km</b>, tendo como descrição "<b>%s</b>"'],   ...
                                   app.specData(idxThread).UserData.Emissions.Frequency(idxEmission), numel(idxRFDataHub), Truncated, Distance, Description);
                end

            else
                if app.specData(idxThread).UserData.Emissions.isTruncated(idxEmission)
                    msg = sprintf(['A frequência central da emissão (%.3f MHz) foi truncada em <b>%.5f MHz</b>.\n\n'           ...
                                   'Não foi identificado registro de estação cuja frequência central coincide com %.5f MHz.'], ...
                                   app.specData(idxThread).UserData.Emissions.Frequency(idxEmission), Truncated, Truncated);
                else
                    msg = sprintf(['A frequência central da emissão (%.3f MHz) não foi truncada.\n\n'                          ...
                                   'Não foi identificado registro de estação cuja frequência central coincide com %.5f MHz.'], ...
                                   app.specData(idxThread).UserData.Emissions.Frequency(idxEmission), Truncated);
                end
            end

            appUtil.modalWindow(app.UIFigure, 'warning', msg);

        end

        % Image clicked function: tool_DriveTest
        function play_DriveTestButtonPushed(app, event)
            
            if isempty(app.hDriveTest) || ~isvalid(app.hDriveTest)
                idxThread = app.play_PlotPanel.UserData.NodeData;

                if ~app.specData(idxThread).GPS.Status
                    msgError = ['Monitoração não registrou coordenadas geográficas válidas. Neste caso, para abrir o módulo ' ...
                                '"DRIVE-TEST" em modo de compatibilidade, deve-se editar manualmente as coordenadas '         ...
                                'geográficas do local da monitoração.'];
                    appUtil.modalWindow(app.UIFigure, 'error', msgError);
                    return
                end
    
                msgWarning = {};
                if ~ismember(app.specData(idxThread).MetaData.DataType, [1, 2])
                    msgWarning{end+1} = 'Monitoração não conduzida pelo appColeta.';
                end

                if app.specData(idxThread).GPS.Count ~= numel(app.specData(idxThread).Data{1})
                    msgWarning{end+1} = 'Número de coordenadas geográficas registradas diferente do número de varreduras.';
                end

                if ~ismember(app.specData(idxThread).MetaData.LevelUnit, {'dBm', 'dBµV'})
                    msgWarning{end+1} = 'Monitoração não apresenta uma das unidades esperadas ("dBm" ou "dBµV") para que a potência do canal seja expressa em "dBm".';
                end

                compatibilityMode = false;
                if ~isempty(msgWarning)
                    msgQuestion   = sprintf(['O módulo "DRIVE-TEST" foi construído para possibilitar a visualização em '      ...
                                             'mapa de dados obtidos em monitorações móveis conduzidas pelo appColeta.\n\nA '  ...
                                             'emissão selecionada, contudo, está relacionada ao(s) seguinte(s) aspecto(s):\n' ...
                                             '%s\n\nDeseja continuar, abrindo o módulo em modo de compatibilidade?'], textFormatGUI.cellstr2Bullets(msgWarning));
                    userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
                    if strcmp(userSelection, 'Não')
                        return
                    end

                    compatibilityMode = true;
                end

                idxEmission = app.play_FindPeaks_Tree.SelectedNodes.NodeData;
                menu_LayoutAuxiliarApp(app, 'DRIVETEST', 'Open', app, compatibilityMode, idxThread, idxEmission)
                
            else
                menu_LayoutAuxiliarApp(app, 'DRIVETEST', 'Open')
            end

        end

        % Image clicked function: play_LimitsRefresh
        function play_LimitsRefreshImageClicked(app, event)
            
            idx = app.play_PlotPanel.UserData.NodeData;

            % Para que o eixo volte às configurações automáticas de
            % XLim e YLim, e considerando como foi construída a classe Band, 
            % em especial o seu método Limits, apaga-se temporariamente 
            % a informação de customização... 
            app.specData(idx).UserData.customPlayback = struct('Type', 'auto', 'Parameters', []);

            prePlot_updatingRestoreView(app, idx)
            set(app.UIAxes1, 'XLim', app.restoreView(1).xLim, 'YLim', app.restoreView(1).yLim)

            % E após os ajustes do eixo e do painel de spinners (que é atualizado
            % automaticamente), recria-se a informação de customização, caso aplicável.
            prePlot_updatingGeneralSettings(app)
            prePlot_updatingCustomProperties(app, idx)

        end

        % Callback function: play_Channel_FileTemplate, 
        % ...and 1 other component
        function play_DownloadFileTemplate(app, event)
            
            switch event.Source
                case app.play_Channel_FileTemplate
                    msgQuestion   = ['O arquivo genérico que possibilita a inclusão de canais é composto por uma estrutura com nove campos:<br>'            ...
                                     '<font style="font-size: 11px;">•&thinsp;Campo 1: Identificador;<br>'                                                  ...
                                     '•&thinsp;Campo 2: Faixa de frequência, em kHZ;<br>'                                                                   ...
                                     '•&thinsp;Campos 3-4: Frequências centrais de canais - o primeiro e o último, respectivamente -, em MHz;<br>'          ...
                                     '•&thinsp;Campo 5: Distância entre frequências centrais de canais adjacentes, em MHz;<br>'                             ...
                                     '•&thinsp;Campo 6: Largura dos canais, em MHz;<br>'                                                                    ...
                                     '•&thinsp;Campo 7: Lista de frequências centrais dos canais, caso não sejam regularmente espaçados;<br>'               ...
                                     '•&thinsp;Campo 8: Referência textual sobre a canalização;<br>'                                                        ...
                                     '•&thinsp;Campo 9: Natureza das emissões, podendo ser "Aircraft", "Cellular", "FM", "TV" ou "Unknown".</font><br><br>' ...
                                     'Deseja fazer download do arquivo modelo?'];
                    templateName  = 'appAnaliseTemplate - addChannelList.json';
                    templateExt   = '.json';

                case app.play_FindPeaks_FileTemplate
                    msgQuestion   = ['O arquivo genérico que possibilita a inclusão de emissões é composto por uma tabela com três colunas:<br>' ...
                                     '<font style="font-size: 11px;">•&thinsp;Coluna 1: Frequência, em MHZ;<br>'                                 ...
                                     '•&thinsp;Coluna 2: Largura ocupada, em kHZ; e<br>'                                                         ...
                                     '•&thinsp;Coluna 3: Descrição textual da emissão.</font><br><br>'                                           ...
                                     'Deseja fazer download dos arquivos modelos?'];
                    templateName  = 'appAnaliseTemplate - addEmission.zip';
                    templateExt   = '.zip';
            end

            userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
            if userSelection == "Sim"
                nameFormatMap = {['*' templateExt], sprintf('appAnalise (*%s)', templateExt)};
                defaultName   = fullfile(app.General.fileFolder.userPath, templateName); 
                fileFullPath  = appUtil.modalWindow(app.UIFigure, 'uiputfile', '', nameFormatMap, defaultName);

                if isempty(fileFullPath)
                    return
                end

                try
                    templateFullFile = fullfile(app.rootFolder, 'Template', templateName);
                    copyfile(templateFullFile, fileFullPath, 'f')
                catch ME
                    appUtil.modalWindow(app.UIFigure, 'error', ME.message);
                end
            end

        end

        % Image clicked function: play_Channel_ShowPlot
        function play_Channel_ShowPlotImageClicked(app, event)
            
            app.play_Channel_ShowPlot.UserData = ~app.play_Channel_ShowPlot.UserData;
            
            if app.play_Channel_ShowPlot.UserData
                app.play_Channel_ShowPlot.ImageSource = 'Eye_32.png';
            else
                app.play_Channel_ShowPlot.ImageSource = 'EyeNegative_32.png';
                app.play_Channel_ShowPlotWarn.Visible = 0;                
            end

            idx = app.play_PlotPanel.UserData.NodeData;
            plot_Draw_Channels(app, idx)

        end

        % Callback function
        function report_SaveProjectButtonPushed(app, event)
            
            if isempty(app.report_Tree.Children)
                msg = 'A criação/edição de um projeto somente é possível quando há ao menos um fluxo espectral a processar.';
                appUtil.modalWindow(app.UIFigure, 'warning', msg);
                return
            end
            
            if isempty(app.report_ProjectName.Value{1})
                defaultName = class.Constants.DefaultFileName(app.General.fileFolder.userPath, 'ProjectData', app.report_Issue.Value);
            else
                defaultName = app.report_ProjectName.Value{1};
            end

            nameFormatMap = {'*.mat', 'appAnalise (*.mat)'};
            fileFullPath  = appUtil.modalWindow(app.UIFigure, 'uiputfile', '', nameFormatMap, defaultName);
            if isempty(fileFullPath)
                return
            end
            
            app.progressDialog.Visible = 'visible';

            reportTemplateIndex = find(strcmp(app.report_ModelName.Items, app.report_ModelName.Value), 1);
            [idx, reportInfo] = report.GeneralInfo(app, 'Report', reportTemplateIndex);
            prjInfo = struct('reportInfo',    rmfield(reportInfo, 'Filename'), ...
                             'peaksTable',    app.projectData.peaksTable,                  ...
                             'exceptionList', app.projectData.exceptionList);
            
            fileWriter.MAT(fileFullPath, 'ProjectData', app.specData(idx), prjInfo)
            
            app.report_ProjectName.Value = fileName;
            app.report_ProjectWarnIcon.Visible   = 0;

            app.progressDialog.Visible = 'hidden';

        end

        % Callback function: report_AddProjectAttachment, 
        % ...and 1 other component
        function report_ExternalFilesMenuSelected(app, event)
            
            focus(app.report_ExternalFiles)

            if isempty(app.report_Tree.Children)
                msg = 'O relacionamento de arquivos externos ao projeto somente é possível se existir ao menos um fluxo espectral a processar.';
                appUtil.modalWindow(app.UIFigure, 'warning', msg);
                return
            end

            switch event.Source
                case app.report_AddProjectAttachment
                    Type = 'Project';

                case app.report_ContextMenu_ExternalFiles
                    if isscalar(app.report_Tree.SelectedNodes.NodeData)
                        Type = 'specData';
                    else
                        msg = 'Os arquivos externos ao fluxo espectral - uma imagem e uma tabela - devem ser incluídos individualmente. Portanto, deve-se selecionar apenas um único fluxo espectral.';
                        appUtil.modalWindow(app.UIFigure, 'warning', msg);
                        return
                    end
            end

            auxApp.dockAddFiles_exported(app, Type)

        end

        % Value changed function: report_Issue
        function report_SaveWarn(app, event)

            app.report_ProjectWarnIcon.Visible = 1;
            
        end

        % Image clicked function: report_TreeAddImage
        function report_TreeAddImagePushed(app, event)
            
            focus(app.report_Tree)

            if ~isempty(app.play_Tree.SelectedNodes)
                idxThreads = unique([app.play_Tree.SelectedNodes.NodeData]);
    
                msg = '';
                if any(ismember(arrayfun(@(x) x.MetaData.DataType, app.specData(idxThreads)), class.Constants.occDataTypes))
                    msg = 'É possível a inclusão apenas de fluxos de espectro. Os fluxos de ocupação automaticamente serão inclusos na edição do relatório, desde que selecionado nos equivalentes fluxos de espectro.';
                elseif any(~arrayfun(@(x) x.GPS.Status, app.specData(idxThreads)))
                    msg = 'Necessária a edição de informações de coordenadas geográficas de fluxo(s) de dados.';                    
                elseif any(arrayfun(@(x) numel(x.Data{1}), app.specData(idxThreads)) == 1)
                    msg = 'É possível a inclusão de fluxo(s) de dados que possua(m) ao menos duas amostras.';
                end

                if ~isempty(msg)
                    appUtil.modalWindow(app.UIFigure, 'warning', msg);
                    return
                end

                if any(~ismember(idxThreads, find(arrayfun(@(x) x.UserData.reportFlag, app.specData))))
                    app.progressDialog.Visible = 'visible';

                    class.userData.reportProperties_DefaultValues(app.specData, idxThreads, app)
                    report_TreeBuilding(app)
                    report_SaveWarn(app)

                    app.progressDialog.Visible = 'hidden';
                end
            end

        end

        % Menu selected function: report_ContextMenu_del
        function report_ContextMenu_delSelected(app, event)
            
            if ~isempty(app.report_Tree.SelectedNodes)
                idx = app.report_Tree.SelectedNodes.NodeData;

                for ii = idx
                    app.specData(ii).UserData.reportFlag           = false;
                    app.specData(ii).UserData.reportOCC            = [];
                    app.specData(ii).UserData.reportDetection      = [];
                    app.specData(ii).UserData.reportClassification = [];
                end

                report_TreeBuilding(app)
                report_SaveWarn(app)
            end

        end

        % Value changed function: report_DetectionManualMode
        function report_DetectionManualModeValueChanged(app, event)
            
            idx = app.play_PlotPanel.UserData.NodeData;
            app.specData(idx).UserData.reportDetection.ManualMode = double(app.report_DetectionManualMode.Value);

            report_Algorithms(app, idx)

        end

        % Image clicked function: tool_ReportAnalysis, tool_ReportGenerator
        function report_playButtonPushed(app, event)
            
            switch event.Source
                case app.tool_ReportAnalysis;  Mode = 'Preview';
                case app.tool_ReportGenerator; Mode = 'Report';
            end
            
            % VALIDAÇÕES:
            if ~sum(arrayfun(@(x) x.UserData.reportFlag, app.specData))
                msgWarning = 'Necessário incluir ao menos um fluxo espectral na lista de fluxos a processar.';
                appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                return

            elseif app.plotFlag
                msgWarning = 'Necessário interromper o playback antes de inicializar análise para geração do relatório.';
                appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                return

            elseif strcmp(Mode, 'Report') && strcmp(app.report_Version.Value, 'Definitiva')
                if ~report_checkValidIssueID(app)
                    msgWarning = sprintf('O número da inspeção "%.0f" é inválido.', app.report_Issue.Value);
                    appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    return
                end

                msgQuestion   = sprintf('Confirma que se trata de monitoração relacionada à Inspeção nº %.0f?', app.report_Issue.Value);
                userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                if userSelection == "Não"
                    return
                end
                
            elseif strcmp(Mode, 'Preview')
                if isempty(app.report_Tree.CheckedNodes)
                    msgWarning = 'Necessário selecionar ao menos um dos fluxos espectrais a processar.';
                    appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    return
                end
            end

            report.Controller(app, Mode)
            if ~isempty(app.hSignalAnalysis) && isvalid(app.hSignalAnalysis)
                idxPrjPeaks = app.hSignalAnalysis.UITable.Selection;
                renderProjectDataOnScreen(app.hSignalAnalysis, idxPrjPeaks)
            end

            % LAYOUT:
            % Esse modo "REPORT" pode detectar, automaticamente, novas
            % emissões. Essa informação é salva na própria app.specData.
            % Necesário, portanto, atualizar screen.
            app.play_Tree.SelectedNodes = app.play_PlotPanel.UserData;
            app.play_PlotPanel.UserData = [];
            play_TreeSelectionChanged(app)

        end

        % Image clicked function: tool_ExceptionList
        function report_OpenSignalAnalysis(app, event)
            
            if ~isempty(app.projectData.peaksTable)
                menu_LayoutAuxiliarApp(app, 'SIGNALANALYSIS', 'Open', app, 1)
            else
                msg = 'Funcionalidade acessível apenas quando detectada ao menos uma emissão nos fluxos espectrais a processar.';
                appUtil.modalWindow(app.UIFigure, 'warning', msg);
            end

        end

        % Callback function
        function report_AlgorithmButtonPushed(app, event)
            
            switch event.Source
                case app.report_occButton
                    msg = 'A alteração do método de aferição da ocupação por <i>bin</i> do fluxo espectral deve ser feita diretamente no modo PLAYBACK.';
                    appUtil.modalWindow(app.UIFigure, 'warning', msg);

                case app.report_DetectionButton
                    auxApp.dockDetection_exported(app);

                case app.report_ClassificationButton
                    auxApp.dockClassification_exported(app);
            end

        end

        % Image clicked function: report_FiscalizaRefresh, 
        % ...and 2 other components
        function report_FiscalizaStaticButtonPushed(app, event)
            
            fiscalizaLibConnection.report_StaticButtonPushed(app, event)

        end

        % Image clicked function: report_ProjectNew, report_ProjectOpen, 
        % ...and 1 other component
        function report_ProjectToolbarImageClicked(app, event)
            
            switch event.Source
                case app.report_ProjectNew
                    if isempty(app.report_Tree.Children)
                        appUtil.modalWindow(app.UIFigure, 'warning', 'Operação aplicável apenas quando a lista de fluxos espectrais a processar não está vazia.');
                        return
                    end

                    msgQuestion   = 'Deseja excluir a lista de fluxos espectrais a processar, iniciando um novo projeto?';
                    userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                    if userSelection == "Não"
                        return
                    end
                    
                    DeleteProject(app, 'appAnalise:REPORT:NewProject')

                %---------------------------------------------------------%
                case app.report_ProjectOpen
                    % if ~isempty(app.listOfProducts)
                    %     msgQuestion   = 'Ao abrir um projeto, a lista de produtos sob análise será sobrescrita. Confirma a operação?';
                    %     userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                    %     if userSelection == "Não"
                    %         return
                    %     end
                    % end

                    % !! PENDENTE !! GERAR DOIS ARQUIVOS. UM MAT SPECTRAL
                    % DATA. E OUTRO PROJECT DATA, DA NOVA VERSÃO, QUE SÓ
                    % TEM OS DADOS ANALISADOS, E UM PONTEIRO COM A LISTA DE
                    % ARQUIVOS BRUTOS. ELES PODEM POSSUIR O MESMO NOME, MAS
                    % COM UMA EXTENSÃO DIFERENTE. .MAT E .PRJ (POR
                    % EXEMPLO).
                    
                    % !! CHECA SE OS ARQUIVOS BINÁRIOS COINCIDEM COM O QUE É
                    % NECESSÁRIO NO PROJETO !!

                    % [fileName, filePath] = uigetfile({'*.mat', 'SCH (*.mat)'}, '', app.General.fileFolder.lastVisited);
                    % figure(app.UIFigure)
                    % 
                    % if fileName
                    %     fileFullPath = fullfile(filePath, fileName);
                    % 
                    %     try
                    %         [~, ~, variables, ~]         = readFile.MAT(fileFullPath);
                    %         app.listOfProducts           = variables.listOfProducts;
                    % 
                    %         % Atualizando os componentes da GUI...
                    %         app.report_ProjectName.Value = fileFullPath;
                    %         app.report_Issue.Value       = variables.projectIssue;
                    %         app.report_Entity.Value      = variables.entityName;
                    %         app.report_EntityID.Value    = variables.entityID;
                    %         app.report_EntityType.Value  = variables.entityType;
                    % 
                    %         report_UpdatingTable(app)
                    %         report_TableSelectionChanged(app)
                    % 
                    %         report_ListOfHomProductsUpdating(app)
                    %         app.report_ProjectWarnIcon.Visible = 0;
                    % 
                    %         app.General.fileFolder.lastVisited = filePath;
                    %         appUtil.generalSettingsSave(class.Constants.appName, app.rootFolder, app.General, app.executionMode)
                    % 
                    %     catch ME
                    %         appUtil.modalWindow(app.UIFigure, 'error', ME.message);
                    %     end
                    % end

                %---------------------------------------------------------%
                case app.report_ProjectSave
                    if isempty(app.report_Tree.Children)
                        appUtil.modalWindow(app.UIFigure, 'warning', 'Operação aplicável apenas quando a lista de fluxos espectrais a processar não está vazia.');
                        return
                    end

                    if ~isempty(app.report_ProjectName.Value{1})
                        defaultName = app.report_ProjectName.Value{1};
                    else
                        defaultName = class.Constants.DefaultFileName(app.General.fileFolder.userPath, 'ProjectData', app.report_Issue.Value);
                    end

                    nameFormatMap = {'*.mat', 'appAnalise (*.mat)'};
                    fileFullPath  = appUtil.modalWindow(app.UIFigure, 'uiputfile', '', nameFormatMap, defaultName);
                    if isempty(fileFullPath)
                        return
                    end

                    app.progressDialog.Visible = 'visible';

                    variables = struct('listOfProducts', app.listOfProducts,           ...
                                       'projectName',    fullfile(filePath, fileName), ...
                                       'projectIssue',   app.report_Issue.Value,       ...
                                       'entityName',     app.report_Entity.Value,      ...
                                       'entityID',       app.report_EntityID.Value,    ...
                                       'entityType',     app.report_EntityType.Value);
                    userData  = [];

                    msgError  = writeFile.MAT(fullfile(filePath, fileName), 'ProjectData', 'SCH', variables, userData);
                    if ~isempty(msgError)
                        appUtil.modalWindow(app.UIFigure, 'error', msgError);
                        return
                    end

                % !! PENDENTE !! GERAR DOIS ARQUIVOS. UM MAT SPECTRAL
                % DATA. E OUTRO PROJECT DATA, DA NOVA VERSÃO, QUE SÓ
                % TEM OS DADOS ANALISADOS, E UM PONTEIRO COM A LISTA DE
                % ARQUIVOS BRUTOS. ELES PODEM POSSUIR O MESMO NOME, MAS
                % COM UMA EXTENSÃO DIFERENTE. .MAT E .PRJ (POR
                % EXEMPLO).

                    reportTemplateIndex = find(strcmp(app.report_ModelName.Items, app.report_ModelName.Value), 1);
                    [idx, reportInfo]   = report.GeneralInfo(app, 'Report', reportTemplateIndex);
                    prjInfo = struct('projectName',   fullfile(filePath, fileName),    ...
                                     'projectIssue',  app.report_Issue.Value,          ...
                                     'entityType',    app.report_EntityType.Value,     ...
                                     'entityID',      app.report_EntityID.Value,       ...
                                     'entityName',    app.report_Entity.Value,         ...
                                     'docModel',      app.report_ModelName.Value,      ...
                                     'reportInfo',    rmfield(reportInfo, 'Filename'), ...
                                     'projData',      app.projData,                    ...
                                     'peaksTable',    app.projectData.peaksTable,                  ...
                                     'exceptionList', app.projectData.exceptionList);
                    
                    fileName = fullfile(filePath, fileName);
                    fileWriter.MAT([fileName '.prj'], 'ProjectData', prjInfo)
                    fileWriter.MAT([fileName '.mat'], 'ProjectData', app.specData(idx))

                    app.report_ProjectName.Value = fullfile(filePath, fileName);
                    app.report_ProjectWarnIcon.Visible = 0;

                    app.progressDialog.Visible = 'hidden';
            end

        end

        % Callback function: report_EditClassification,
        % report_EditDetection
        function report_ThreadAlgorithmsRefreshImageClicked(app, event)
            
            switch event.Source
                case app.report_EditDetection
                    menu_LayoutPopupApp(app, 'Detection')
                case app.report_EditClassification
                    menu_LayoutPopupApp(app, 'Classification')
            end

        end

        % Value changed function: report_ModelName
        function report_ModelNameValueChanged(app, event)
            
            if ~isempty(app.report_ModelName.Value)
                app.tool_ReportGenerator.Enable = 1;
            else
                app.tool_ReportGenerator.Enable = 0;
            end

        end

        % Button pushed function: misc_DeleteAll
        function misc_DeleteAllButtonPushed(app, event)

            msgQuestion   = ['Confirma a exclusão dos fluxos espectrais e das informações auxiliares ' ...
                             'a cada um dos fluxos, dentre elas a lista de exceções?'];
            userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 2, 2);
            if userSelection == "Não"
                return
            end

            DeleteAll(app)

        end

        % Button pushed function: misc_Del, misc_Duplicate, misc_Export, 
        % ...and 3 other components
        function misc_OperationsCallbacks(app, event)
            
            if app.plotFlag
                play_PlaybackToolbarButtonCallback(app, struct('Source', app.tool_Play))
            end

            idxThreads = unique([app.play_Tree.SelectedNodes.NodeData]);
            try
                switch event.Source
                    %-----------------------------------------------------%
                    case app.misc_Save
                        misc_SaveSpectralData(app, idxThreads)

                    %-----------------------------------------------------%
                    case app.misc_Duplicate
                        for ii = 1:numel(idxThreads)
                            app.specData(end+1) = copy(app.specData(idxThreads(ii)), {});
                        end
                        
                        sortType     = char(setdiff({'Receiver+ID', 'Receiver+Frequency'}, app.play_TreeSort.UserData));
                        app.specData = sort(app.specData, sortType);                    
                    
                    %-----------------------------------------------------%
                    case app.misc_Merge
                        if strcmp(misc_checkIfAuxiliarAppIsOpen(app, 'MESCLAR FLUXOS'), 'Não')
                            return
                        end
                        
                        app.specData = merge(app.specData, idxThreads, app.UIFigure);

                        % Reinicia os valores de ocupação...
                        idxThreads = idxThreads(1);
                        if ~isempty(app.specData(idxThreads).UserData.occCache)
                            app.specData(idxThreads).UserData.occCache  = struct('Info', {}, 'THR', {}, 'Data', {});
                            app.specData(idxThreads).UserData.occMethod.CacheIndex = [];

                            if ~isempty(app.specData(idxThreads).UserData.reportOCC)
                                app.specData(idxThreads).UserData.reportOCC = [];
                                class.userData.reportProperties_DefaultValues(app, idxThreads)
                            end
                        end
    
                    %-----------------------------------------------------%
                    case app.misc_Del
                        if strcmp(misc_checkIfAuxiliarAppIsOpen(app, 'DELETAR FLUXO'), 'Não')
                            return
                        end

                        delete(app.specData(idxThreads))
                        app.specData(idxThreads) = [];

                        if isempty(app.specData)
                            DeleteAll(app)
                            return
                        end
    
                    %-----------------------------------------------------%
                    case app.misc_Export
                        misc_ExportUserData(app, idxThreads)
    
                    %-----------------------------------------------------%
                    case app.misc_Import
                        misc_ImportUserData(app)
                end

                SelectedNodesTextList = misc_SelectedNodesText(app);
                play_TreeRebuilding(app, SelectedNodesTextList)

            catch ME
                appUtil.modalWindow(app.UIFigure, 'warning', ME.message);
            end

        end

        % Value changed function: menu_Button8
        function menu_Button8ValueChanged(app, event)
            
            clickedButton = event.Source;

            if ~isempty(app.hConfig) && isvalid(app.hConfig) && ~app.hConfig.isDocked
                clickedButton.Value = false;
                figure(app.hConfig.UIFigure)
                return
            elseif event.PreviousValue
                clickedButton.Value = true;
                return
            end

            menu_LayoutAuxiliarApp(app, 'CONFIG', 'Open')

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Color = [0.9412 0.9412 0.9412];
            app.UIFigure.Position = [100 100 1244 4000];
            app.UIFigure.Name = 'appAnalise R2024b';
            app.UIFigure.Icon = fullfile(pathToMLAPP, 'Icons', 'icon_48.png');
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @closeFcn, true);
            app.UIFigure.HandleVisibility = 'on';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {44, '1x', 44};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Tooltip = {''};
            app.GridLayout.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = [1 2];
            app.TabGroup.Layout.Column = 1;

            % Create Tab1_File
            app.Tab1_File = uitab(app.TabGroup);
            app.Tab1_File.Title = 'FILE';

            % Create file_Grid
            app.file_Grid = uigridlayout(app.Tab1_File);
            app.file_Grid.ColumnWidth = {'1x', 325};
            app.file_Grid.RowHeight = {'1x', 34};
            app.file_Grid.RowSpacing = 5;
            app.file_Grid.Padding = [0 0 0 24];
            app.file_Grid.BackgroundColor = [1 1 1];

            % Create file_toolGrid
            app.file_toolGrid = uigridlayout(app.file_Grid);
            app.file_toolGrid.ColumnWidth = {22, 22, 110, '1x', 110};
            app.file_toolGrid.RowHeight = {'1x', 17, '1x'};
            app.file_toolGrid.ColumnSpacing = 5;
            app.file_toolGrid.RowSpacing = 0;
            app.file_toolGrid.Padding = [5 6 5 6];
            app.file_toolGrid.Layout.Row = 2;
            app.file_toolGrid.Layout.Column = [1 2];

            % Create file_OpenInitialPopup
            app.file_OpenInitialPopup = uiimage(app.file_toolGrid);
            app.file_OpenInitialPopup.ImageClickedFcn = createCallbackFcn(app, @file_ButtonPushed_OpenPopup, true);
            app.file_OpenInitialPopup.Tooltip = {'Abre popup de inicialização'};
            app.file_OpenInitialPopup.Layout.Row = 2;
            app.file_OpenInitialPopup.Layout.Column = 1;
            app.file_OpenInitialPopup.ImageSource = fullfile(pathToMLAPP, 'Icons', 'PowerOn_32.png');

            % Create file_OpenFileButton
            app.file_OpenFileButton = uiimage(app.file_toolGrid);
            app.file_OpenFileButton.ImageClickedFcn = createCallbackFcn(app, @file_ButtonPushed_OpenFile, true);
            app.file_OpenFileButton.Tooltip = {'Seleciona arquivos'};
            app.file_OpenFileButton.Layout.Row = 2;
            app.file_OpenFileButton.Layout.Column = 2;
            app.file_OpenFileButton.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Import_24.png');

            % Create file_SpecReadButton
            app.file_SpecReadButton = uibutton(app.file_toolGrid, 'push');
            app.file_SpecReadButton.ButtonPushedFcn = createCallbackFcn(app, @file_ButtonPushed_SpecRead, true);
            app.file_SpecReadButton.Icon = fullfile(pathToMLAPP, 'Icons', 'Run_24.png');
            app.file_SpecReadButton.IconAlignment = 'right';
            app.file_SpecReadButton.HorizontalAlignment = 'right';
            app.file_SpecReadButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.file_SpecReadButton.FontSize = 11;
            app.file_SpecReadButton.Visible = 'off';
            app.file_SpecReadButton.Layout.Row = [1 3];
            app.file_SpecReadButton.Layout.Column = 5;
            app.file_SpecReadButton.Text = 'Inicia análise';

            % Create file_docGrid
            app.file_docGrid = uigridlayout(app.file_Grid);
            app.file_docGrid.ColumnWidth = {320, '1x'};
            app.file_docGrid.RowHeight = {22, 22, '1x'};
            app.file_docGrid.ColumnSpacing = 5;
            app.file_docGrid.RowSpacing = 5;
            app.file_docGrid.Padding = [5 0 0 0];
            app.file_docGrid.Layout.Row = 1;
            app.file_docGrid.Layout.Column = 1;
            app.file_docGrid.BackgroundColor = [1 1 1];

            % Create file_TitleGrid
            app.file_TitleGrid = uigridlayout(app.file_docGrid);
            app.file_TitleGrid.ColumnWidth = {18, '1x'};
            app.file_TitleGrid.RowHeight = {'1x'};
            app.file_TitleGrid.ColumnSpacing = 5;
            app.file_TitleGrid.RowSpacing = 5;
            app.file_TitleGrid.Padding = [2 2 2 2];
            app.file_TitleGrid.Tag = 'COLORLOCKED';
            app.file_TitleGrid.Layout.Row = 1;
            app.file_TitleGrid.Layout.Column = 1;
            app.file_TitleGrid.BackgroundColor = [0.749 0.749 0.749];

            % Create file_TitleIcon
            app.file_TitleIcon = uiimage(app.file_TitleGrid);
            app.file_TitleIcon.Layout.Row = 1;
            app.file_TitleIcon.Layout.Column = 1;
            app.file_TitleIcon.HorizontalAlignment = 'left';
            app.file_TitleIcon.ImageSource = fullfile(pathToMLAPP, 'Icons', 'addFiles_32.png');

            % Create file_Title
            app.file_Title = uilabel(app.file_TitleGrid);
            app.file_Title.FontSize = 11;
            app.file_Title.Layout.Row = 1;
            app.file_Title.Layout.Column = 2;
            app.file_Title.Text = 'ARQUIVOS';

            % Create file_TreeLabel
            app.file_TreeLabel = uilabel(app.file_docGrid);
            app.file_TreeLabel.VerticalAlignment = 'bottom';
            app.file_TreeLabel.FontSize = 10;
            app.file_TreeLabel.Layout.Row = 2;
            app.file_TreeLabel.Layout.Column = 1;
            app.file_TreeLabel.Text = 'LISTA DE ARQUIVOS';

            % Create file_Tree
            app.file_Tree = uitree(app.file_docGrid);
            app.file_Tree.Multiselect = 'on';
            app.file_Tree.SelectionChangedFcn = createCallbackFcn(app, @file_TreeSelectionChanged, true);
            app.file_Tree.FontSize = 10;
            app.file_Tree.Layout.Row = 3;
            app.file_Tree.Layout.Column = [1 2];

            % Create file_panelGrid
            app.file_panelGrid = uigridlayout(app.file_Grid);
            app.file_panelGrid.ColumnWidth = {'1x', 16};
            app.file_panelGrid.RowHeight = {22, 22, '1x', 22, 32, 22, 0, 0, 8, 68};
            app.file_panelGrid.ColumnSpacing = 5;
            app.file_panelGrid.RowSpacing = 5;
            app.file_panelGrid.Padding = [0 0 5 0];
            app.file_panelGrid.Layout.Row = 1;
            app.file_panelGrid.Layout.Column = 2;
            app.file_panelGrid.BackgroundColor = [1 1 1];

            % Create file_MetadataLabel
            app.file_MetadataLabel = uilabel(app.file_panelGrid);
            app.file_MetadataLabel.VerticalAlignment = 'bottom';
            app.file_MetadataLabel.FontSize = 10;
            app.file_MetadataLabel.Layout.Row = 2;
            app.file_MetadataLabel.Layout.Column = 1;
            app.file_MetadataLabel.Text = 'METADADOS';

            % Create file_MetadataPanel
            app.file_MetadataPanel = uipanel(app.file_panelGrid);
            app.file_MetadataPanel.Layout.Row = 3;
            app.file_MetadataPanel.Layout.Column = [1 2];

            % Create file_MetadataGrid
            app.file_MetadataGrid = uigridlayout(app.file_MetadataPanel);
            app.file_MetadataGrid.ColumnWidth = {'1x'};
            app.file_MetadataGrid.RowHeight = {'1x'};
            app.file_MetadataGrid.Padding = [0 0 0 0];
            app.file_MetadataGrid.BackgroundColor = [1 1 1];

            % Create file_Metadata
            app.file_Metadata = uihtml(app.file_MetadataGrid);
            app.file_Metadata.HTMLSource = ' ';
            app.file_Metadata.Layout.Row = 1;
            app.file_Metadata.Layout.Column = 1;

            % Create file_FilteringLabel
            app.file_FilteringLabel = uilabel(app.file_panelGrid);
            app.file_FilteringLabel.VerticalAlignment = 'bottom';
            app.file_FilteringLabel.FontSize = 10;
            app.file_FilteringLabel.FontColor = [0.149 0.149 0.149];
            app.file_FilteringLabel.Layout.Row = 4;
            app.file_FilteringLabel.Layout.Column = 1;
            app.file_FilteringLabel.Text = 'FILTROS';

            % Create file_FilteringTypePanel
            app.file_FilteringTypePanel = uibuttongroup(app.file_panelGrid);
            app.file_FilteringTypePanel.SelectionChangedFcn = createCallbackFcn(app, @file_FilteringTypeChanged, true);
            app.file_FilteringTypePanel.BackgroundColor = [1 1 1];
            app.file_FilteringTypePanel.Layout.Row = 5;
            app.file_FilteringTypePanel.Layout.Column = [1 2];
            app.file_FilteringTypePanel.FontWeight = 'bold';
            app.file_FilteringTypePanel.FontSize = 10;

            % Create file_FilteringType1
            app.file_FilteringType1 = uiradiobutton(app.file_FilteringTypePanel);
            app.file_FilteringType1.Text = 'Faixa de Frequência';
            app.file_FilteringType1.FontSize = 10;
            app.file_FilteringType1.Position = [12 4 136 22];
            app.file_FilteringType1.Value = true;

            % Create file_FilteringType2
            app.file_FilteringType2 = uiradiobutton(app.file_FilteringTypePanel);
            app.file_FilteringType2.Text = 'ID';
            app.file_FilteringType2.FontSize = 10;
            app.file_FilteringType2.Position = [164 5 52 22];

            % Create file_FilteringType3
            app.file_FilteringType3 = uiradiobutton(app.file_FilteringTypePanel);
            app.file_FilteringType3.Text = 'Descrição';
            app.file_FilteringType3.FontSize = 10;
            app.file_FilteringType3.Position = [238 5 82 22];

            % Create file_FilteringType1_Frequency
            app.file_FilteringType1_Frequency = uidropdown(app.file_panelGrid);
            app.file_FilteringType1_Frequency.Items = {};
            app.file_FilteringType1_Frequency.FontSize = 11;
            app.file_FilteringType1_Frequency.BackgroundColor = [1 1 1];
            app.file_FilteringType1_Frequency.Layout.Row = 6;
            app.file_FilteringType1_Frequency.Layout.Column = [1 2];
            app.file_FilteringType1_Frequency.Value = {};

            % Create file_FilteringType2_ID
            app.file_FilteringType2_ID = uidropdown(app.file_panelGrid);
            app.file_FilteringType2_ID.Items = {};
            app.file_FilteringType2_ID.FontSize = 11;
            app.file_FilteringType2_ID.BackgroundColor = [1 1 1];
            app.file_FilteringType2_ID.Layout.Row = 7;
            app.file_FilteringType2_ID.Layout.Column = [1 2];
            app.file_FilteringType2_ID.Value = {};

            % Create file_FilteringType3_Description
            app.file_FilteringType3_Description = uieditfield(app.file_panelGrid, 'text');
            app.file_FilteringType3_Description.FontSize = 11;
            app.file_FilteringType3_Description.Layout.Row = 8;
            app.file_FilteringType3_Description.Layout.Column = [1 2];

            % Create file_FilteringAdd
            app.file_FilteringAdd = uiimage(app.file_panelGrid);
            app.file_FilteringAdd.ScaleMethod = 'scaledown';
            app.file_FilteringAdd.ImageClickedFcn = createCallbackFcn(app, @file_FilteringAddClicked, true);
            app.file_FilteringAdd.Layout.Row = 9;
            app.file_FilteringAdd.Layout.Column = 2;
            app.file_FilteringAdd.VerticalAlignment = 'bottom';
            app.file_FilteringAdd.ImageSource = fullfile(pathToMLAPP, 'Icons', 'addSymbol_32.png');

            % Create file_FilteringTree
            app.file_FilteringTree = uitree(app.file_panelGrid);
            app.file_FilteringTree.Multiselect = 'on';
            app.file_FilteringTree.FontSize = 10;
            app.file_FilteringTree.Layout.Row = 10;
            app.file_FilteringTree.Layout.Column = [1 2];

            % Create Tab2_Playback
            app.Tab2_Playback = uitab(app.TabGroup);
            app.Tab2_Playback.AutoResizeChildren = 'off';
            app.Tab2_Playback.Title = 'PLAYBACK+REPORT+MISC';

            % Create play_Grid
            app.play_Grid = uigridlayout(app.Tab2_Playback);
            app.play_Grid.ColumnWidth = {325, 10, '1x', 198, 5, 10, 325};
            app.play_Grid.RowHeight = {22, '1x', 34};
            app.play_Grid.ColumnSpacing = 0;
            app.play_Grid.RowSpacing = 5;
            app.play_Grid.Padding = [0 0 0 24];
            app.play_Grid.BackgroundColor = [1 1 1];

            % Create play_TreeGrid
            app.play_TreeGrid = uigridlayout(app.play_Grid);
            app.play_TreeGrid.ColumnWidth = {64, '1x', 54, 16, 16};
            app.play_TreeGrid.RowHeight = {22, 22, '1x', 22, '1x', 42, 22, '1x', 15, 22};
            app.play_TreeGrid.ColumnSpacing = 5;
            app.play_TreeGrid.RowSpacing = 5;
            app.play_TreeGrid.Padding = [5 0 0 0];
            app.play_TreeGrid.Layout.Row = [1 2];
            app.play_TreeGrid.Layout.Column = 1;
            app.play_TreeGrid.BackgroundColor = [1 1 1];

            % Create play_TreeTitleGrid
            app.play_TreeTitleGrid = uigridlayout(app.play_TreeGrid);
            app.play_TreeTitleGrid.ColumnWidth = {18, '1x'};
            app.play_TreeTitleGrid.RowHeight = {'1x'};
            app.play_TreeTitleGrid.ColumnSpacing = 5;
            app.play_TreeTitleGrid.RowSpacing = 5;
            app.play_TreeTitleGrid.Padding = [2 2 2 2];
            app.play_TreeTitleGrid.Tag = 'COLORLOCKED';
            app.play_TreeTitleGrid.Layout.Row = 1;
            app.play_TreeTitleGrid.Layout.Column = [1 5];
            app.play_TreeTitleGrid.BackgroundColor = [0.749 0.749 0.749];

            % Create play_TreeTitleImage
            app.play_TreeTitleImage = uiimage(app.play_TreeTitleGrid);
            app.play_TreeTitleImage.Layout.Row = 1;
            app.play_TreeTitleImage.Layout.Column = 1;
            app.play_TreeTitleImage.HorizontalAlignment = 'left';
            app.play_TreeTitleImage.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Classification_32.png');

            % Create play_TreeTitle
            app.play_TreeTitle = uilabel(app.play_TreeTitleGrid);
            app.play_TreeTitle.FontSize = 11;
            app.play_TreeTitle.Layout.Row = 1;
            app.play_TreeTitle.Layout.Column = 2;
            app.play_TreeTitle.Text = 'DADOS';

            % Create play_TreeLabel
            app.play_TreeLabel = uilabel(app.play_TreeGrid);
            app.play_TreeLabel.VerticalAlignment = 'bottom';
            app.play_TreeLabel.FontSize = 10;
            app.play_TreeLabel.Layout.Row = 2;
            app.play_TreeLabel.Layout.Column = [1 2];
            app.play_TreeLabel.Text = 'FLUXOS ESPECTRAIS';

            % Create play_TreePanelVisibility
            app.play_TreePanelVisibility = uiimage(app.play_TreeGrid);
            app.play_TreePanelVisibility.ImageClickedFcn = createCallbackFcn(app, @play_PanelsVisibility, true);
            app.play_TreePanelVisibility.Tooltip = {'Mostra metadados'};
            app.play_TreePanelVisibility.Layout.Row = 2;
            app.play_TreePanelVisibility.Layout.Column = 4;
            app.play_TreePanelVisibility.VerticalAlignment = 'bottom';
            app.play_TreePanelVisibility.ImageSource = fullfile(pathToMLAPP, 'Icons', 'layout3_32px.png');

            % Create play_TreeSort
            app.play_TreeSort = uiimage(app.play_TreeGrid);
            app.play_TreeSort.ImageClickedFcn = createCallbackFcn(app, @play_PanelsVisibility, true);
            app.play_TreeSort.Tooltip = {'Reordena fluxos'};
            app.play_TreeSort.Layout.Row = 2;
            app.play_TreeSort.Layout.Column = 5;
            app.play_TreeSort.VerticalAlignment = 'bottom';
            app.play_TreeSort.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Sort_32.png');

            % Create play_Tree
            app.play_Tree = uitree(app.play_TreeGrid);
            app.play_Tree.Multiselect = 'on';
            app.play_Tree.SelectionChangedFcn = createCallbackFcn(app, @play_TreeSelectionChanged, true);
            app.play_Tree.FontSize = 10;
            app.play_Tree.Layout.Row = 3;
            app.play_Tree.Layout.Column = [1 5];

            % Create play_MetadataLabel
            app.play_MetadataLabel = uilabel(app.play_TreeGrid);
            app.play_MetadataLabel.VerticalAlignment = 'bottom';
            app.play_MetadataLabel.FontSize = 10;
            app.play_MetadataLabel.Layout.Row = 4;
            app.play_MetadataLabel.Layout.Column = [1 2];
            app.play_MetadataLabel.Text = 'METADADOS';

            % Create play_MetadataPanel
            app.play_MetadataPanel = uipanel(app.play_TreeGrid);
            app.play_MetadataPanel.AutoResizeChildren = 'off';
            app.play_MetadataPanel.Layout.Row = [5 6];
            app.play_MetadataPanel.Layout.Column = [1 5];

            % Create play_MetadataGrid
            app.play_MetadataGrid = uigridlayout(app.play_MetadataPanel);
            app.play_MetadataGrid.ColumnWidth = {'1x'};
            app.play_MetadataGrid.RowHeight = {'1x'};
            app.play_MetadataGrid.Padding = [0 0 0 0];
            app.play_MetadataGrid.BackgroundColor = [1 1 1];

            % Create play_Metadata
            app.play_Metadata = uihtml(app.play_MetadataGrid);
            app.play_Metadata.HTMLSource = ' ';
            app.play_Metadata.Layout.Row = 1;
            app.play_Metadata.Layout.Column = 1;

            % Create report_TreeLabel
            app.report_TreeLabel = uilabel(app.play_TreeGrid);
            app.report_TreeLabel.VerticalAlignment = 'bottom';
            app.report_TreeLabel.FontSize = 10;
            app.report_TreeLabel.Layout.Row = 7;
            app.report_TreeLabel.Layout.Column = [1 2];
            app.report_TreeLabel.Text = 'ALGORITMOS';

            % Create report_ThreadAlgorithmsPanel
            app.report_ThreadAlgorithmsPanel = uipanel(app.play_TreeGrid);
            app.report_ThreadAlgorithmsPanel.Layout.Row = 8;
            app.report_ThreadAlgorithmsPanel.Layout.Column = [1 5];

            % Create report_ThreadAlgorithmsGrid
            app.report_ThreadAlgorithmsGrid = uigridlayout(app.report_ThreadAlgorithmsPanel);
            app.report_ThreadAlgorithmsGrid.ColumnWidth = {'1x'};
            app.report_ThreadAlgorithmsGrid.RowHeight = {'1x'};
            app.report_ThreadAlgorithmsGrid.Padding = [0 0 0 0];
            app.report_ThreadAlgorithmsGrid.BackgroundColor = [1 1 1];

            % Create report_ThreadAlgorithms
            app.report_ThreadAlgorithms = uihtml(app.report_ThreadAlgorithmsGrid);
            app.report_ThreadAlgorithms.Layout.Row = 1;
            app.report_ThreadAlgorithms.Layout.Column = 1;

            % Create report_DetectionManualMode
            app.report_DetectionManualMode = uicheckbox(app.play_TreeGrid);
            app.report_DetectionManualMode.ValueChangedFcn = createCallbackFcn(app, @report_DetectionManualModeValueChanged, true);
            app.report_DetectionManualMode.Enable = 'off';
            app.report_DetectionManualMode.Text = 'Restringir detecção de emissões ao PLAYBACK.';
            app.report_DetectionManualMode.WordWrap = 'on';
            app.report_DetectionManualMode.FontSize = 11;
            app.report_DetectionManualMode.Layout.Row = 10;
            app.report_DetectionManualMode.Layout.Column = [1 5];

            % Create report_EditClassification
            app.report_EditClassification = uihyperlink(app.play_TreeGrid);
            app.report_EditClassification.HyperlinkClickedFcn = createCallbackFcn(app, @report_ThreadAlgorithmsRefreshImageClicked, true);
            app.report_EditClassification.VisitedColor = [0 0.4 0.8];
            app.report_EditClassification.HorizontalAlignment = 'right';
            app.report_EditClassification.VerticalAlignment = 'top';
            app.report_EditClassification.FontSize = 10;
            app.report_EditClassification.FontColor = [0 0.4 0.8];
            app.report_EditClassification.Enable = 'off';
            app.report_EditClassification.Layout.Row = 9;
            app.report_EditClassification.Layout.Column = [3 5];
            app.report_EditClassification.Text = 'CLASSIFICAÇÃO';

            % Create report_EditDetection
            app.report_EditDetection = uihyperlink(app.play_TreeGrid);
            app.report_EditDetection.HyperlinkClickedFcn = createCallbackFcn(app, @report_ThreadAlgorithmsRefreshImageClicked, true);
            app.report_EditDetection.VisitedColor = [0 0.4 0.8];
            app.report_EditDetection.VerticalAlignment = 'top';
            app.report_EditDetection.FontSize = 10;
            app.report_EditDetection.FontColor = [0 0.4 0.8];
            app.report_EditDetection.Enable = 'off';
            app.report_EditDetection.Layout.Row = 9;
            app.report_EditDetection.Layout.Column = 1;
            app.report_EditDetection.Text = 'DETECÇÃO';

            % Create play_PlotPanel
            app.play_PlotPanel = uipanel(app.play_Grid);
            app.play_PlotPanel.AutoResizeChildren = 'off';
            app.play_PlotPanel.BorderType = 'none';
            app.play_PlotPanel.BackgroundColor = [0 0 0];
            app.play_PlotPanel.Layout.Row = [1 2];
            app.play_PlotPanel.Layout.Column = [3 5];

            % Create play_axesToolbar
            app.play_axesToolbar = uigridlayout(app.play_Grid);
            app.play_axesToolbar.ColumnWidth = {'1x', 22, 22, 22, 22, 22, 22, 22, 22, 22, '1x'};
            app.play_axesToolbar.RowHeight = {'1x'};
            app.play_axesToolbar.ColumnSpacing = 0;
            app.play_axesToolbar.RowSpacing = 0;
            app.play_axesToolbar.Padding = [0 2 0 2];
            app.play_axesToolbar.Layout.Row = 1;
            app.play_axesToolbar.Layout.Column = 4;
            app.play_axesToolbar.BackgroundColor = [1 1 1];

            % Create axesTool_MinHold
            app.axesTool_MinHold = uiimage(app.play_axesToolbar);
            app.axesTool_MinHold.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_MinHold.Tag = 'MinHold';
            app.axesTool_MinHold.Tooltip = {'MinHold'};
            app.axesTool_MinHold.Layout.Row = 1;
            app.axesTool_MinHold.Layout.Column = 5;
            app.axesTool_MinHold.ImageSource = fullfile(pathToMLAPP, 'Icons', 'MinHold_32.png');

            % Create axesTool_Average
            app.axesTool_Average = uiimage(app.play_axesToolbar);
            app.axesTool_Average.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_Average.Tag = 'Average';
            app.axesTool_Average.Tooltip = {'Média'};
            app.axesTool_Average.Layout.Row = 1;
            app.axesTool_Average.Layout.Column = 6;
            app.axesTool_Average.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Average_32.png');

            % Create axesTool_MaxHold
            app.axesTool_MaxHold = uiimage(app.play_axesToolbar);
            app.axesTool_MaxHold.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_MaxHold.Tag = 'MaxHold';
            app.axesTool_MaxHold.Tooltip = {'MaxHold'};
            app.axesTool_MaxHold.Layout.Row = 1;
            app.axesTool_MaxHold.Layout.Column = 7;
            app.axesTool_MaxHold.ImageSource = fullfile(pathToMLAPP, 'Icons', 'MaxHold_32.png');

            % Create axesTool_Persistance
            app.axesTool_Persistance = uiimage(app.play_axesToolbar);
            app.axesTool_Persistance.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_Persistance.Tag = 'Persistance';
            app.axesTool_Persistance.Tooltip = {'Persistência'};
            app.axesTool_Persistance.Layout.Row = 1;
            app.axesTool_Persistance.Layout.Column = 8;
            app.axesTool_Persistance.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Persistance_36.png');

            % Create axesTool_Occupancy
            app.axesTool_Occupancy = uiimage(app.play_axesToolbar);
            app.axesTool_Occupancy.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_Occupancy.Tag = 'Ocuppancy';
            app.axesTool_Occupancy.Tooltip = {'Ocupação'};
            app.axesTool_Occupancy.Layout.Row = 1;
            app.axesTool_Occupancy.Layout.Column = 9;
            app.axesTool_Occupancy.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Occupancy_32Gray.png');

            % Create axesTool_Waterfall
            app.axesTool_Waterfall = uiimage(app.play_axesToolbar);
            app.axesTool_Waterfall.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_Waterfall.Tag = 'Waterfall';
            app.axesTool_Waterfall.Tooltip = {'Waterfall'};
            app.axesTool_Waterfall.Layout.Row = 1;
            app.axesTool_Waterfall.Layout.Column = 10;
            app.axesTool_Waterfall.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Waterfall_24.png');

            % Create axesTool_DataTip
            app.axesTool_DataTip = uiimage(app.play_axesToolbar);
            app.axesTool_DataTip.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_DataTip.Enable = 'off';
            app.axesTool_DataTip.Tooltip = {'DataCursorMode'; '(restrito à Waterfall:Image)'};
            app.axesTool_DataTip.Layout.Row = 1;
            app.axesTool_DataTip.Layout.Column = 4;
            app.axesTool_DataTip.ImageSource = fullfile(pathToMLAPP, 'Icons', 'DataTip_22.png');

            % Create axesTool_Pan
            app.axesTool_Pan = uiimage(app.play_axesToolbar);
            app.axesTool_Pan.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_Pan.Tooltip = {'Pan'};
            app.axesTool_Pan.Layout.Row = 1;
            app.axesTool_Pan.Layout.Column = 3;
            app.axesTool_Pan.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Pan_32.png');

            % Create axesTool_RestoreView
            app.axesTool_RestoreView = uiimage(app.play_axesToolbar);
            app.axesTool_RestoreView.ImageClickedFcn = createCallbackFcn(app, @play_AxesToolbarCallbacks, true);
            app.axesTool_RestoreView.Tooltip = {'RestoreView'};
            app.axesTool_RestoreView.Layout.Row = 1;
            app.axesTool_RestoreView.Layout.Column = 2;
            app.axesTool_RestoreView.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Home_18.png');

            % Create play_ControlsGrid
            app.play_ControlsGrid = uigridlayout(app.play_Grid);
            app.play_ControlsGrid.ColumnWidth = {'1x'};
            app.play_ControlsGrid.RowHeight = {22, 880, 22, 600, 22, 600, 22, 500, 22, 80, 22, '1x'};
            app.play_ControlsGrid.ColumnSpacing = 5;
            app.play_ControlsGrid.RowSpacing = 5;
            app.play_ControlsGrid.Padding = [0 0 5 0];
            app.play_ControlsGrid.Layout.Row = [1 2];
            app.play_ControlsGrid.Layout.Column = 7;
            app.play_ControlsGrid.BackgroundColor = [1 1 1];

            % Create play_ControlsTab1Info
            app.play_ControlsTab1Info = uigridlayout(app.play_ControlsGrid);
            app.play_ControlsTab1Info.ColumnWidth = {'1x'};
            app.play_ControlsTab1Info.RowHeight = {22, 174, 22, 32, 112, '1x', 200, 26};
            app.play_ControlsTab1Info.ColumnSpacing = 5;
            app.play_ControlsTab1Info.RowSpacing = 5;
            app.play_ControlsTab1Info.Padding = [0 0 0 0];
            app.play_ControlsTab1Info.Layout.Row = 2;
            app.play_ControlsTab1Info.Layout.Column = 1;
            app.play_ControlsTab1Info.BackgroundColor = [1 1 1];

            % Create play_GeneralPanelLabel
            app.play_GeneralPanelLabel = uilabel(app.play_ControlsTab1Info);
            app.play_GeneralPanelLabel.VerticalAlignment = 'bottom';
            app.play_GeneralPanelLabel.FontSize = 10;
            app.play_GeneralPanelLabel.Layout.Row = 1;
            app.play_GeneralPanelLabel.Layout.Column = 1;
            app.play_GeneralPanelLabel.Text = 'ASPECTOS GERAIS';

            % Create play_GeneralPanel
            app.play_GeneralPanel = uipanel(app.play_ControlsTab1Info);
            app.play_GeneralPanel.AutoResizeChildren = 'off';
            app.play_GeneralPanel.BackgroundColor = [1 1 1];
            app.play_GeneralPanel.Layout.Row = 2;
            app.play_GeneralPanel.Layout.Column = 1;

            % Create play_OthersGrid
            app.play_OthersGrid = uigridlayout(app.play_GeneralPanel);
            app.play_OthersGrid.ColumnWidth = {'1x', '1x', '1x', 46, 16};
            app.play_OthersGrid.RowHeight = {26, 22, 17, '1x'};
            app.play_OthersGrid.RowSpacing = 5;
            app.play_OthersGrid.BackgroundColor = [1 1 1];

            % Create play_LayoutRatioLabel
            app.play_LayoutRatioLabel = uilabel(app.play_OthersGrid);
            app.play_LayoutRatioLabel.VerticalAlignment = 'bottom';
            app.play_LayoutRatioLabel.WordWrap = 'on';
            app.play_LayoutRatioLabel.FontSize = 10;
            app.play_LayoutRatioLabel.Layout.Row = 1;
            app.play_LayoutRatioLabel.Layout.Column = [1 2];
            app.play_LayoutRatioLabel.Text = {'Razão aspecto'; 'dos eixos:'};

            % Create play_LayoutRatio
            app.play_LayoutRatio = uidropdown(app.play_OthersGrid);
            app.play_LayoutRatio.Items = {'1:0:0'};
            app.play_LayoutRatio.ValueChangedFcn = createCallbackFcn(app, @play_ControlButtonPushed, true);
            app.play_LayoutRatio.FontSize = 11;
            app.play_LayoutRatio.BackgroundColor = [1 1 1];
            app.play_LayoutRatio.Layout.Row = 2;
            app.play_LayoutRatio.Layout.Column = 1;
            app.play_LayoutRatio.Value = '1:0:0';

            % Create play_LineVisibilityLabel
            app.play_LineVisibilityLabel = uilabel(app.play_OthersGrid);
            app.play_LineVisibilityLabel.VerticalAlignment = 'bottom';
            app.play_LineVisibilityLabel.WordWrap = 'on';
            app.play_LineVisibilityLabel.FontSize = 10;
            app.play_LineVisibilityLabel.Layout.Row = 1;
            app.play_LineVisibilityLabel.Layout.Column = 2;
            app.play_LineVisibilityLabel.Text = 'Visibilidade ClearWrite:';

            % Create play_LineVisibility
            app.play_LineVisibility = uidropdown(app.play_OthersGrid);
            app.play_LineVisibility.Items = {'on', 'off'};
            app.play_LineVisibility.ValueChangedFcn = createCallbackFcn(app, @play_LineVisibilityValueChanged, true);
            app.play_LineVisibility.FontSize = 11;
            app.play_LineVisibility.BackgroundColor = [1 1 1];
            app.play_LineVisibility.Layout.Row = 2;
            app.play_LineVisibility.Layout.Column = 2;
            app.play_LineVisibility.Value = 'on';

            % Create play_MinPlotTimeLabel
            app.play_MinPlotTimeLabel = uilabel(app.play_OthersGrid);
            app.play_MinPlotTimeLabel.VerticalAlignment = 'bottom';
            app.play_MinPlotTimeLabel.WordWrap = 'on';
            app.play_MinPlotTimeLabel.FontSize = 10;
            app.play_MinPlotTimeLabel.Layout.Row = 1;
            app.play_MinPlotTimeLabel.Layout.Column = [3 4];
            app.play_MinPlotTimeLabel.Text = {'Tempo mínimo'; 'escrita (ms):'};

            % Create play_MinPlotTime
            app.play_MinPlotTime = uispinner(app.play_OthersGrid);
            app.play_MinPlotTime.Step = 25;
            app.play_MinPlotTime.Limits = [50 1000];
            app.play_MinPlotTime.RoundFractionalValues = 'on';
            app.play_MinPlotTime.ValueDisplayFormat = '%.0f';
            app.play_MinPlotTime.FontSize = 11;
            app.play_MinPlotTime.Layout.Row = 2;
            app.play_MinPlotTime.Layout.Column = 3;
            app.play_MinPlotTime.Value = 50;

            % Create play_TraceIntegrationLabel
            app.play_TraceIntegrationLabel = uilabel(app.play_OthersGrid);
            app.play_TraceIntegrationLabel.VerticalAlignment = 'bottom';
            app.play_TraceIntegrationLabel.WordWrap = 'on';
            app.play_TraceIntegrationLabel.FontSize = 10;
            app.play_TraceIntegrationLabel.Layout.Row = 1;
            app.play_TraceIntegrationLabel.Layout.Column = [4 5];
            app.play_TraceIntegrationLabel.Text = 'Fator integração:';

            % Create play_TraceIntegration
            app.play_TraceIntegration = uidropdown(app.play_OthersGrid);
            app.play_TraceIntegration.Items = {'3', '10', '100', 'Inf'};
            app.play_TraceIntegration.ValueChangedFcn = createCallbackFcn(app, @play_TraceIntegrationValueChanged, true);
            app.play_TraceIntegration.FontSize = 11;
            app.play_TraceIntegration.BackgroundColor = [1 1 1];
            app.play_TraceIntegration.Layout.Row = 2;
            app.play_TraceIntegration.Layout.Column = [4 5];
            app.play_TraceIntegration.Value = 'Inf';

            % Create play_LimitsPanelLabel
            app.play_LimitsPanelLabel = uilabel(app.play_OthersGrid);
            app.play_LimitsPanelLabel.VerticalAlignment = 'bottom';
            app.play_LimitsPanelLabel.FontSize = 10;
            app.play_LimitsPanelLabel.Layout.Row = 3;
            app.play_LimitsPanelLabel.Layout.Column = 1;
            app.play_LimitsPanelLabel.Text = 'Limites';

            % Create play_LimitsRefresh
            app.play_LimitsRefresh = uiimage(app.play_OthersGrid);
            app.play_LimitsRefresh.ImageClickedFcn = createCallbackFcn(app, @play_LimitsRefreshImageClicked, true);
            app.play_LimitsRefresh.Tooltip = {'Retorna à configuração padrão'};
            app.play_LimitsRefresh.Layout.Row = 3;
            app.play_LimitsRefresh.Layout.Column = 5;
            app.play_LimitsRefresh.HorizontalAlignment = 'right';
            app.play_LimitsRefresh.VerticalAlignment = 'bottom';
            app.play_LimitsRefresh.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Refresh_18.png');

            % Create play_LimitsPanel
            app.play_LimitsPanel = uipanel(app.play_OthersGrid);
            app.play_LimitsPanel.AutoResizeChildren = 'off';
            app.play_LimitsPanel.Layout.Row = 4;
            app.play_LimitsPanel.Layout.Column = [1 5];

            % Create play_LimitsGrid
            app.play_LimitsGrid = uigridlayout(app.play_LimitsPanel);
            app.play_LimitsGrid.ColumnWidth = {'1x', 70, '1x'};
            app.play_LimitsGrid.RowHeight = {22, 22};
            app.play_LimitsGrid.RowSpacing = 5;
            app.play_LimitsGrid.BackgroundColor = [1 1 1];

            % Create play_Limits_xLim1
            app.play_Limits_xLim1 = uispinner(app.play_LimitsGrid);
            app.play_Limits_xLim1.ValueDisplayFormat = '%.3f';
            app.play_Limits_xLim1.ValueChangedFcn = createCallbackFcn(app, @play_xLimitsValueChanged, true);
            app.play_Limits_xLim1.Tag = 'FreqStart';
            app.play_Limits_xLim1.FontSize = 11;
            app.play_Limits_xLim1.Tooltip = {''};
            app.play_Limits_xLim1.Layout.Row = 1;
            app.play_Limits_xLim1.Layout.Column = 1;

            % Create play_Limits_xLimLabel
            app.play_Limits_xLimLabel = uilabel(app.play_LimitsGrid);
            app.play_Limits_xLimLabel.HorizontalAlignment = 'center';
            app.play_Limits_xLimLabel.FontSize = 10;
            app.play_Limits_xLimLabel.Layout.Row = 1;
            app.play_Limits_xLimLabel.Layout.Column = 2;
            app.play_Limits_xLimLabel.Text = 'Frequência';

            % Create play_Limits_xLim2
            app.play_Limits_xLim2 = uispinner(app.play_LimitsGrid);
            app.play_Limits_xLim2.ValueDisplayFormat = '%.3f';
            app.play_Limits_xLim2.ValueChangedFcn = createCallbackFcn(app, @play_xLimitsValueChanged, true);
            app.play_Limits_xLim2.Tag = 'FreqStop';
            app.play_Limits_xLim2.FontSize = 11;
            app.play_Limits_xLim2.Tooltip = {''};
            app.play_Limits_xLim2.Layout.Row = 1;
            app.play_Limits_xLim2.Layout.Column = 3;

            % Create play_Limits_yLim1
            app.play_Limits_yLim1 = uispinner(app.play_LimitsGrid);
            app.play_Limits_yLim1.Step = 5;
            app.play_Limits_yLim1.ValueDisplayFormat = '%.1f';
            app.play_Limits_yLim1.ValueChangedFcn = createCallbackFcn(app, @play_yLimitsValueChanged, true);
            app.play_Limits_yLim1.Tag = 'MinLevel';
            app.play_Limits_yLim1.FontSize = 11;
            app.play_Limits_yLim1.Tooltip = {''};
            app.play_Limits_yLim1.Layout.Row = 2;
            app.play_Limits_yLim1.Layout.Column = 1;

            % Create play_Limits_yLimLabel
            app.play_Limits_yLimLabel = uilabel(app.play_LimitsGrid);
            app.play_Limits_yLimLabel.HorizontalAlignment = 'center';
            app.play_Limits_yLimLabel.FontSize = 10;
            app.play_Limits_yLimLabel.Layout.Row = 2;
            app.play_Limits_yLimLabel.Layout.Column = 2;
            app.play_Limits_yLimLabel.Text = 'Nível';

            % Create play_Limits_yLim2
            app.play_Limits_yLim2 = uispinner(app.play_LimitsGrid);
            app.play_Limits_yLim2.Step = 5;
            app.play_Limits_yLim2.ValueDisplayFormat = '%.1f';
            app.play_Limits_yLim2.ValueChangedFcn = createCallbackFcn(app, @play_yLimitsValueChanged, true);
            app.play_Limits_yLim2.Tag = 'MaxLevel';
            app.play_Limits_yLim2.FontSize = 11;
            app.play_Limits_yLim2.Tooltip = {''};
            app.play_Limits_yLim2.Layout.Row = 2;
            app.play_Limits_yLim2.Layout.Column = 3;

            % Create play_ControlPanelLabel
            app.play_ControlPanelLabel = uilabel(app.play_ControlsTab1Info);
            app.play_ControlPanelLabel.VerticalAlignment = 'bottom';
            app.play_ControlPanelLabel.FontSize = 10;
            app.play_ControlPanelLabel.Layout.Row = 3;
            app.play_ControlPanelLabel.Layout.Column = 1;
            app.play_ControlPanelLabel.Text = 'CONTROLES';

            % Create play_ControlsPanel
            app.play_ControlsPanel = uibuttongroup(app.play_ControlsTab1Info);
            app.play_ControlsPanel.AutoResizeChildren = 'off';
            app.play_ControlsPanel.SelectionChangedFcn = createCallbackFcn(app, @play_ControlsPanelSelectionChanged, true);
            app.play_ControlsPanel.BackgroundColor = [1 1 1];
            app.play_ControlsPanel.Layout.Row = 4;
            app.play_ControlsPanel.Layout.Column = 1;
            app.play_ControlsPanel.FontWeight = 'bold';
            app.play_ControlsPanel.FontSize = 10;

            % Create play_RadioButton_Persistance
            app.play_RadioButton_Persistance = uiradiobutton(app.play_ControlsPanel);
            app.play_RadioButton_Persistance.Text = 'Persistência';
            app.play_RadioButton_Persistance.FontSize = 10;
            app.play_RadioButton_Persistance.Position = [11 5 76 22];
            app.play_RadioButton_Persistance.Value = true;

            % Create play_RadioButton_Occupancy
            app.play_RadioButton_Occupancy = uiradiobutton(app.play_ControlsPanel);
            app.play_RadioButton_Occupancy.Text = 'Ocupação';
            app.play_RadioButton_Occupancy.FontSize = 10;
            app.play_RadioButton_Occupancy.Position = [114 5 68 22];

            % Create play_RadioButton_Waterfall
            app.play_RadioButton_Waterfall = uiradiobutton(app.play_ControlsPanel);
            app.play_RadioButton_Waterfall.Text = 'Waterfall';
            app.play_RadioButton_Waterfall.FontSize = 10;
            app.play_RadioButton_Waterfall.Position = [216 5 83 22];

            % Create play_Persistance_Panel
            app.play_Persistance_Panel = uipanel(app.play_ControlsTab1Info);
            app.play_Persistance_Panel.AutoResizeChildren = 'off';
            app.play_Persistance_Panel.BackgroundColor = [0.9804 0.9804 0.9804];
            app.play_Persistance_Panel.Layout.Row = 5;
            app.play_Persistance_Panel.Layout.Column = 1;

            % Create play_PersistanceGrid
            app.play_PersistanceGrid = uigridlayout(app.play_Persistance_Panel);
            app.play_PersistanceGrid.ColumnWidth = {'1x', '1x', 67, 16};
            app.play_PersistanceGrid.RowHeight = {17, 22, 17, 22};
            app.play_PersistanceGrid.RowSpacing = 5;
            app.play_PersistanceGrid.Padding = [10 10 10 5];
            app.play_PersistanceGrid.BackgroundColor = [1 1 1];

            % Create play_Persistance_InterpolationLabel
            app.play_Persistance_InterpolationLabel = uilabel(app.play_PersistanceGrid);
            app.play_Persistance_InterpolationLabel.VerticalAlignment = 'bottom';
            app.play_Persistance_InterpolationLabel.FontSize = 10;
            app.play_Persistance_InterpolationLabel.Layout.Row = 1;
            app.play_Persistance_InterpolationLabel.Layout.Column = 1;
            app.play_Persistance_InterpolationLabel.Text = 'Interpolação:';

            % Create play_Persistance_Interpolation
            app.play_Persistance_Interpolation = uidropdown(app.play_PersistanceGrid);
            app.play_Persistance_Interpolation.Items = {'nearest', 'bilinear'};
            app.play_Persistance_Interpolation.ValueChangedFcn = createCallbackFcn(app, @play_Persistance_Callbacks, true);
            app.play_Persistance_Interpolation.FontSize = 11;
            app.play_Persistance_Interpolation.BackgroundColor = [1 1 1];
            app.play_Persistance_Interpolation.Layout.Row = 2;
            app.play_Persistance_Interpolation.Layout.Column = 1;
            app.play_Persistance_Interpolation.Value = 'nearest';

            % Create play_Persistance_WindowSizeLabel
            app.play_Persistance_WindowSizeLabel = uilabel(app.play_PersistanceGrid);
            app.play_Persistance_WindowSizeLabel.VerticalAlignment = 'bottom';
            app.play_Persistance_WindowSizeLabel.FontSize = 10;
            app.play_Persistance_WindowSizeLabel.Layout.Row = 1;
            app.play_Persistance_WindowSizeLabel.Layout.Column = 2;
            app.play_Persistance_WindowSizeLabel.Text = 'Janela:';

            % Create play_Persistance_WindowSize
            app.play_Persistance_WindowSize = uidropdown(app.play_PersistanceGrid);
            app.play_Persistance_WindowSize.Items = {'128', '256', '512', 'full'};
            app.play_Persistance_WindowSize.ValueChangedFcn = createCallbackFcn(app, @play_Persistance_Callbacks, true);
            app.play_Persistance_WindowSize.FontSize = 11;
            app.play_Persistance_WindowSize.BackgroundColor = [1 1 1];
            app.play_Persistance_WindowSize.Layout.Row = 2;
            app.play_Persistance_WindowSize.Layout.Column = 2;
            app.play_Persistance_WindowSize.Value = 'full';

            % Create play_Persistance_ColormapLabel
            app.play_Persistance_ColormapLabel = uilabel(app.play_PersistanceGrid);
            app.play_Persistance_ColormapLabel.VerticalAlignment = 'bottom';
            app.play_Persistance_ColormapLabel.FontSize = 10;
            app.play_Persistance_ColormapLabel.Layout.Row = 1;
            app.play_Persistance_ColormapLabel.Layout.Column = [3 4];
            app.play_Persistance_ColormapLabel.Text = 'Mapa de cor:';

            % Create play_Persistance_Colormap
            app.play_Persistance_Colormap = uidropdown(app.play_PersistanceGrid);
            app.play_Persistance_Colormap.Items = {'winter', 'parula', 'turbo'};
            app.play_Persistance_Colormap.ValueChangedFcn = createCallbackFcn(app, @play_Persistance_Callbacks, true);
            app.play_Persistance_Colormap.FontSize = 11;
            app.play_Persistance_Colormap.BackgroundColor = [1 1 1];
            app.play_Persistance_Colormap.Layout.Row = 2;
            app.play_Persistance_Colormap.Layout.Column = [3 4];
            app.play_Persistance_Colormap.Value = 'winter';

            % Create play_Persistance_TransparencyLabel
            app.play_Persistance_TransparencyLabel = uilabel(app.play_PersistanceGrid);
            app.play_Persistance_TransparencyLabel.VerticalAlignment = 'bottom';
            app.play_Persistance_TransparencyLabel.WordWrap = 'on';
            app.play_Persistance_TransparencyLabel.FontSize = 10;
            app.play_Persistance_TransparencyLabel.Layout.Row = 3;
            app.play_Persistance_TransparencyLabel.Layout.Column = 1;
            app.play_Persistance_TransparencyLabel.Text = 'Transparência:';

            % Create play_Persistance_Transparency
            app.play_Persistance_Transparency = uispinner(app.play_PersistanceGrid);
            app.play_Persistance_Transparency.Step = 0.05;
            app.play_Persistance_Transparency.Limits = [0.2 1];
            app.play_Persistance_Transparency.ValueDisplayFormat = '%.2f';
            app.play_Persistance_Transparency.ValueChangedFcn = createCallbackFcn(app, @play_Persistance_Callbacks, true);
            app.play_Persistance_Transparency.FontSize = 11;
            app.play_Persistance_Transparency.Layout.Row = 4;
            app.play_Persistance_Transparency.Layout.Column = 1;
            app.play_Persistance_Transparency.Value = 1;

            % Create play_Persistance_cLim_Label
            app.play_Persistance_cLim_Label = uilabel(app.play_PersistanceGrid);
            app.play_Persistance_cLim_Label.VerticalAlignment = 'bottom';
            app.play_Persistance_cLim_Label.FontSize = 10;
            app.play_Persistance_cLim_Label.Layout.Row = 3;
            app.play_Persistance_cLim_Label.Layout.Column = 2;
            app.play_Persistance_cLim_Label.Text = 'Limites (%):';

            % Create play_Persistance_cLim_Mode
            app.play_Persistance_cLim_Mode = uiimage(app.play_PersistanceGrid);
            app.play_Persistance_cLim_Mode.ImageClickedFcn = createCallbackFcn(app, @play_Persistance_Callbacks, true);
            app.play_Persistance_cLim_Mode.Enable = 'off';
            app.play_Persistance_cLim_Mode.Tooltip = {'Retorna à configuração padrão'};
            app.play_Persistance_cLim_Mode.Layout.Row = 3;
            app.play_Persistance_cLim_Mode.Layout.Column = 4;
            app.play_Persistance_cLim_Mode.HorizontalAlignment = 'right';
            app.play_Persistance_cLim_Mode.VerticalAlignment = 'bottom';
            app.play_Persistance_cLim_Mode.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Refresh_18.png');

            % Create play_Persistance_cLim_Grid2
            app.play_Persistance_cLim_Grid2 = uigridlayout(app.play_PersistanceGrid);
            app.play_Persistance_cLim_Grid2.ColumnWidth = {'1x', 10, '1x'};
            app.play_Persistance_cLim_Grid2.RowHeight = {'1x'};
            app.play_Persistance_cLim_Grid2.ColumnSpacing = 0;
            app.play_Persistance_cLim_Grid2.RowSpacing = 5;
            app.play_Persistance_cLim_Grid2.Padding = [0 0 0 0];
            app.play_Persistance_cLim_Grid2.Layout.Row = 4;
            app.play_Persistance_cLim_Grid2.Layout.Column = [2 4];
            app.play_Persistance_cLim_Grid2.BackgroundColor = [1 1 1];

            % Create play_Persistance_cLim1
            app.play_Persistance_cLim1 = uispinner(app.play_Persistance_cLim_Grid2);
            app.play_Persistance_cLim1.Step = 0.1;
            app.play_Persistance_cLim1.Limits = [0 Inf];
            app.play_Persistance_cLim1.ValueDisplayFormat = '%.3f';
            app.play_Persistance_cLim1.ValueChangedFcn = createCallbackFcn(app, @play_Persistance_cLimValueChanged, true);
            app.play_Persistance_cLim1.FontSize = 11;
            app.play_Persistance_cLim1.Enable = 'off';
            app.play_Persistance_cLim1.Tooltip = {''};
            app.play_Persistance_cLim1.Layout.Row = 1;
            app.play_Persistance_cLim1.Layout.Column = 1;

            % Create play_Persistance_cLim2
            app.play_Persistance_cLim2 = uispinner(app.play_Persistance_cLim_Grid2);
            app.play_Persistance_cLim2.Limits = [0 Inf];
            app.play_Persistance_cLim2.ValueDisplayFormat = '%.3f';
            app.play_Persistance_cLim2.ValueChangedFcn = createCallbackFcn(app, @play_Persistance_cLimValueChanged, true);
            app.play_Persistance_cLim2.FontSize = 11;
            app.play_Persistance_cLim2.Enable = 'off';
            app.play_Persistance_cLim2.Tooltip = {''};
            app.play_Persistance_cLim2.Layout.Row = 1;
            app.play_Persistance_cLim2.Layout.Column = 3;
            app.play_Persistance_cLim2.Value = 1;

            % Create play_Persistance_cLim_Separation
            app.play_Persistance_cLim_Separation = uilabel(app.play_Persistance_cLim_Grid2);
            app.play_Persistance_cLim_Separation.HorizontalAlignment = 'center';
            app.play_Persistance_cLim_Separation.FontSize = 10;
            app.play_Persistance_cLim_Separation.Enable = 'off';
            app.play_Persistance_cLim_Separation.Layout.Row = 1;
            app.play_Persistance_cLim_Separation.Layout.Column = 2;
            app.play_Persistance_cLim_Separation.Text = '-';

            % Create play_OCC_Panel
            app.play_OCC_Panel = uipanel(app.play_ControlsTab1Info);
            app.play_OCC_Panel.AutoResizeChildren = 'off';
            app.play_OCC_Panel.BackgroundColor = [1 1 1];
            app.play_OCC_Panel.Layout.Row = 6;
            app.play_OCC_Panel.Layout.Column = 1;

            % Create play_OCCGrid
            app.play_OCCGrid = uigridlayout(app.play_OCC_Panel);
            app.play_OCCGrid.ColumnWidth = {'1x', '1x', '1x'};
            app.play_OCCGrid.RowHeight = {17, 22, 17, 22, 17, '1x'};
            app.play_OCCGrid.RowSpacing = 5;
            app.play_OCCGrid.Padding = [10 10 10 5];
            app.play_OCCGrid.BackgroundColor = [1 1 1];

            % Create play_OCC_MethodLabel
            app.play_OCC_MethodLabel = uilabel(app.play_OCCGrid);
            app.play_OCC_MethodLabel.VerticalAlignment = 'bottom';
            app.play_OCC_MethodLabel.FontSize = 10;
            app.play_OCC_MethodLabel.Layout.Row = 1;
            app.play_OCC_MethodLabel.Layout.Column = [1 2];
            app.play_OCC_MethodLabel.Text = 'Tipo de threshold:';

            % Create play_OCC_Method
            app.play_OCC_Method = uidropdown(app.play_OCCGrid);
            app.play_OCC_Method.Items = {'Linear fixo (COLETA)', 'Linear fixo', 'Linear adaptativo', 'Envoltória do ruído'};
            app.play_OCC_Method.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_Method.FontSize = 11;
            app.play_OCC_Method.BackgroundColor = [1 1 1];
            app.play_OCC_Method.Layout.Row = 2;
            app.play_OCC_Method.Layout.Column = [1 2];
            app.play_OCC_Method.Value = 'Linear fixo (COLETA)';

            % Create play_OCC_IntegrationTimeLabel
            app.play_OCC_IntegrationTimeLabel = uilabel(app.play_OCCGrid);
            app.play_OCC_IntegrationTimeLabel.VerticalAlignment = 'bottom';
            app.play_OCC_IntegrationTimeLabel.WordWrap = 'on';
            app.play_OCC_IntegrationTimeLabel.FontSize = 10;
            app.play_OCC_IntegrationTimeLabel.Layout.Row = 1;
            app.play_OCC_IntegrationTimeLabel.Layout.Column = 3;
            app.play_OCC_IntegrationTimeLabel.Text = 'Integração (min):';

            % Create play_OCC_IntegrationTime
            app.play_OCC_IntegrationTime = uidropdown(app.play_OCCGrid);
            app.play_OCC_IntegrationTime.Items = {'1', '5', '15', '30', '60'};
            app.play_OCC_IntegrationTime.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_IntegrationTime.Tag = 'Factor';
            app.play_OCC_IntegrationTime.FontSize = 11;
            app.play_OCC_IntegrationTime.BackgroundColor = [1 1 1];
            app.play_OCC_IntegrationTime.Layout.Row = 2;
            app.play_OCC_IntegrationTime.Layout.Column = 3;
            app.play_OCC_IntegrationTime.Value = '15';

            % Create play_OCC_IntegrationTimeCaptured
            app.play_OCC_IntegrationTimeCaptured = uieditfield(app.play_OCCGrid, 'numeric');
            app.play_OCC_IntegrationTimeCaptured.Limits = [0 Inf];
            app.play_OCC_IntegrationTimeCaptured.ValueDisplayFormat = '%.0f';
            app.play_OCC_IntegrationTimeCaptured.Editable = 'off';
            app.play_OCC_IntegrationTimeCaptured.HorizontalAlignment = 'left';
            app.play_OCC_IntegrationTimeCaptured.FontSize = 11;
            app.play_OCC_IntegrationTimeCaptured.Visible = 'off';
            app.play_OCC_IntegrationTimeCaptured.Layout.Row = 2;
            app.play_OCC_IntegrationTimeCaptured.Layout.Column = 3;

            % Create play_OCC_OrientationLabel
            app.play_OCC_OrientationLabel = uilabel(app.play_OCCGrid);
            app.play_OCC_OrientationLabel.VerticalAlignment = 'bottom';
            app.play_OCC_OrientationLabel.FontSize = 10;
            app.play_OCC_OrientationLabel.Layout.Row = 3;
            app.play_OCC_OrientationLabel.Layout.Column = 1;
            app.play_OCC_OrientationLabel.Text = 'Orientação:';

            % Create play_OCC_Orientation
            app.play_OCC_Orientation = uidropdown(app.play_OCCGrid);
            app.play_OCC_Orientation.Items = {'bin'};
            app.play_OCC_Orientation.FontSize = 11;
            app.play_OCC_Orientation.BackgroundColor = [1 1 1];
            app.play_OCC_Orientation.Layout.Row = 4;
            app.play_OCC_Orientation.Layout.Column = 1;
            app.play_OCC_Orientation.Value = 'bin';

            % Create play_OCC_THRLabel
            app.play_OCC_THRLabel = uilabel(app.play_OCCGrid);
            app.play_OCC_THRLabel.Tag = 'THR';
            app.play_OCC_THRLabel.VerticalAlignment = 'bottom';
            app.play_OCC_THRLabel.WordWrap = 'on';
            app.play_OCC_THRLabel.FontSize = 10;
            app.play_OCC_THRLabel.Layout.Row = 3;
            app.play_OCC_THRLabel.Layout.Column = 2;
            app.play_OCC_THRLabel.Text = 'Valor (dBm):';

            % Create play_OCC_THR
            app.play_OCC_THR = uispinner(app.play_OCCGrid);
            app.play_OCC_THR.RoundFractionalValues = 'on';
            app.play_OCC_THR.ValueDisplayFormat = '%d';
            app.play_OCC_THR.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_THR.Tag = 'THR';
            app.play_OCC_THR.FontSize = 11;
            app.play_OCC_THR.Layout.Row = 4;
            app.play_OCC_THR.Layout.Column = 2;
            app.play_OCC_THR.Value = -80;

            % Create play_OCC_THRCaptured
            app.play_OCC_THRCaptured = uidropdown(app.play_OCCGrid);
            app.play_OCC_THRCaptured.Items = {};
            app.play_OCC_THRCaptured.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_THRCaptured.Tag = 'Factor';
            app.play_OCC_THRCaptured.Visible = 'off';
            app.play_OCC_THRCaptured.FontSize = 11;
            app.play_OCC_THRCaptured.BackgroundColor = [1 1 1];
            app.play_OCC_THRCaptured.Layout.Row = 4;
            app.play_OCC_THRCaptured.Layout.Column = 2;
            app.play_OCC_THRCaptured.Value = {};

            % Create play_OCC_OffsetLabel
            app.play_OCC_OffsetLabel = uilabel(app.play_OCCGrid);
            app.play_OCC_OffsetLabel.Tag = 'Offset';
            app.play_OCC_OffsetLabel.VerticalAlignment = 'bottom';
            app.play_OCC_OffsetLabel.WordWrap = 'on';
            app.play_OCC_OffsetLabel.FontSize = 10;
            app.play_OCC_OffsetLabel.Visible = 'off';
            app.play_OCC_OffsetLabel.Layout.Row = 3;
            app.play_OCC_OffsetLabel.Layout.Column = 2;
            app.play_OCC_OffsetLabel.Text = 'OffSet (dB):';

            % Create play_OCC_Offset
            app.play_OCC_Offset = uispinner(app.play_OCCGrid);
            app.play_OCC_Offset.Limits = [3 30];
            app.play_OCC_Offset.RoundFractionalValues = 'on';
            app.play_OCC_Offset.ValueDisplayFormat = '%d';
            app.play_OCC_Offset.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_Offset.Tag = 'Offset';
            app.play_OCC_Offset.FontSize = 11;
            app.play_OCC_Offset.Visible = 'off';
            app.play_OCC_Offset.Layout.Row = 4;
            app.play_OCC_Offset.Layout.Column = 2;
            app.play_OCC_Offset.Value = 12;

            % Create play_OCC_ceilFactorLabel
            app.play_OCC_ceilFactorLabel = uilabel(app.play_OCCGrid);
            app.play_OCC_ceilFactorLabel.Tag = 'Factor';
            app.play_OCC_ceilFactorLabel.VerticalAlignment = 'bottom';
            app.play_OCC_ceilFactorLabel.FontSize = 10;
            app.play_OCC_ceilFactorLabel.Visible = 'off';
            app.play_OCC_ceilFactorLabel.Layout.Row = 3;
            app.play_OCC_ceilFactorLabel.Layout.Column = 3;
            app.play_OCC_ceilFactorLabel.Text = 'Ceifamento:';

            % Create play_OCC_ceilFactor
            app.play_OCC_ceilFactor = uidropdown(app.play_OCCGrid);
            app.play_OCC_ceilFactor.Items = {'1𝜎', '2𝜎', '3𝜎'};
            app.play_OCC_ceilFactor.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_ceilFactor.Tag = 'Factor';
            app.play_OCC_ceilFactor.Visible = 'off';
            app.play_OCC_ceilFactor.FontSize = 11;
            app.play_OCC_ceilFactor.BackgroundColor = [1 1 1];
            app.play_OCC_ceilFactor.Layout.Row = 4;
            app.play_OCC_ceilFactor.Layout.Column = 3;
            app.play_OCC_ceilFactor.Value = '2𝜎';

            % Create play_OCC_noiseLabel
            app.play_OCC_noiseLabel = uilabel(app.play_OCCGrid);
            app.play_OCC_noiseLabel.VerticalAlignment = 'bottom';
            app.play_OCC_noiseLabel.FontSize = 10;
            app.play_OCC_noiseLabel.Visible = 'off';
            app.play_OCC_noiseLabel.Layout.Row = 5;
            app.play_OCC_noiseLabel.Layout.Column = [1 3];
            app.play_OCC_noiseLabel.Text = 'Parâmetros relacionados à estimativa do piso de ruído:';

            % Create play_OCC_noisePanel
            app.play_OCC_noisePanel = uipanel(app.play_OCCGrid);
            app.play_OCC_noisePanel.AutoResizeChildren = 'off';
            app.play_OCC_noisePanel.Visible = 'off';
            app.play_OCC_noisePanel.Layout.Row = 6;
            app.play_OCC_noisePanel.Layout.Column = [1 3];

            % Create play_OCC_noiseGrid
            app.play_OCC_noiseGrid = uigridlayout(app.play_OCC_noisePanel);
            app.play_OCC_noiseGrid.ColumnWidth = {'1x', '1x', '1x'};
            app.play_OCC_noiseGrid.RowHeight = {17, 22};
            app.play_OCC_noiseGrid.RowSpacing = 4;
            app.play_OCC_noiseGrid.Padding = [10 10 10 5];
            app.play_OCC_noiseGrid.BackgroundColor = [1 1 1];

            % Create play_OCC_noiseFcnLabel
            app.play_OCC_noiseFcnLabel = uilabel(app.play_OCC_noiseGrid);
            app.play_OCC_noiseFcnLabel.VerticalAlignment = 'bottom';
            app.play_OCC_noiseFcnLabel.FontSize = 10;
            app.play_OCC_noiseFcnLabel.Layout.Row = 1;
            app.play_OCC_noiseFcnLabel.Layout.Column = [1 2];
            app.play_OCC_noiseFcnLabel.Text = 'Função estatística:';

            % Create play_OCC_noiseFcn
            app.play_OCC_noiseFcn = uidropdown(app.play_OCC_noiseGrid);
            app.play_OCC_noiseFcn.Items = {'mean', 'median'};
            app.play_OCC_noiseFcn.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_noiseFcn.FontSize = 11;
            app.play_OCC_noiseFcn.BackgroundColor = [1 1 1];
            app.play_OCC_noiseFcn.Layout.Row = 2;
            app.play_OCC_noiseFcn.Layout.Column = 1;
            app.play_OCC_noiseFcn.Value = 'mean';

            % Create play_OCC_noiseTrashSamplesLabel
            app.play_OCC_noiseTrashSamplesLabel = uilabel(app.play_OCC_noiseGrid);
            app.play_OCC_noiseTrashSamplesLabel.VerticalAlignment = 'bottom';
            app.play_OCC_noiseTrashSamplesLabel.WordWrap = 'on';
            app.play_OCC_noiseTrashSamplesLabel.FontSize = 10;
            app.play_OCC_noiseTrashSamplesLabel.Layout.Row = 1;
            app.play_OCC_noiseTrashSamplesLabel.Layout.Column = [2 3];
            app.play_OCC_noiseTrashSamplesLabel.Text = 'Descartadas (%):';

            % Create play_OCC_noiseTrashSamples
            app.play_OCC_noiseTrashSamples = uispinner(app.play_OCC_noiseGrid);
            app.play_OCC_noiseTrashSamples.Limits = [0 10];
            app.play_OCC_noiseTrashSamples.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_noiseTrashSamples.FontSize = 11;
            app.play_OCC_noiseTrashSamples.Layout.Row = 2;
            app.play_OCC_noiseTrashSamples.Layout.Column = 2;

            % Create play_OCC_noiseUsefulSamplesLabel
            app.play_OCC_noiseUsefulSamplesLabel = uilabel(app.play_OCC_noiseGrid);
            app.play_OCC_noiseUsefulSamplesLabel.VerticalAlignment = 'bottom';
            app.play_OCC_noiseUsefulSamplesLabel.WordWrap = 'on';
            app.play_OCC_noiseUsefulSamplesLabel.FontSize = 10;
            app.play_OCC_noiseUsefulSamplesLabel.Layout.Row = 1;
            app.play_OCC_noiseUsefulSamplesLabel.Layout.Column = 3;
            app.play_OCC_noiseUsefulSamplesLabel.Text = 'Úteis (%):';

            % Create play_OCC_noiseUsefulSamples
            app.play_OCC_noiseUsefulSamples = uispinner(app.play_OCC_noiseGrid);
            app.play_OCC_noiseUsefulSamples.Limits = [10 90];
            app.play_OCC_noiseUsefulSamples.ValueChangedFcn = createCallbackFcn(app, @play_Occupancy_Callbacks, true);
            app.play_OCC_noiseUsefulSamples.FontSize = 11;
            app.play_OCC_noiseUsefulSamples.Layout.Row = 2;
            app.play_OCC_noiseUsefulSamples.Layout.Column = 3;
            app.play_OCC_noiseUsefulSamples.Value = 20;

            % Create play_Waterfall_Panel
            app.play_Waterfall_Panel = uipanel(app.play_ControlsTab1Info);
            app.play_Waterfall_Panel.AutoResizeChildren = 'off';
            app.play_Waterfall_Panel.Layout.Row = 7;
            app.play_Waterfall_Panel.Layout.Column = 1;

            % Create play_WaterFallGrid
            app.play_WaterFallGrid = uigridlayout(app.play_Waterfall_Panel);
            app.play_WaterFallGrid.ColumnWidth = {'1x', '1x', 67, 16};
            app.play_WaterFallGrid.RowHeight = {17, 22, 17, 22, 17, 22};
            app.play_WaterFallGrid.RowSpacing = 5;
            app.play_WaterFallGrid.Padding = [10 10 10 5];
            app.play_WaterFallGrid.BackgroundColor = [1 1 1];

            % Create play_Waterfall_FcnLabel
            app.play_Waterfall_FcnLabel = uilabel(app.play_WaterFallGrid);
            app.play_Waterfall_FcnLabel.VerticalAlignment = 'bottom';
            app.play_Waterfall_FcnLabel.WordWrap = 'on';
            app.play_Waterfall_FcnLabel.FontSize = 10;
            app.play_Waterfall_FcnLabel.Layout.Row = 1;
            app.play_Waterfall_FcnLabel.Layout.Column = 1;
            app.play_Waterfall_FcnLabel.Text = 'Função:';

            % Create play_Waterfall_Fcn
            app.play_Waterfall_Fcn = uidropdown(app.play_WaterFallGrid);
            app.play_Waterfall_Fcn.Items = {'image', 'mesh'};
            app.play_Waterfall_Fcn.ValueChangedFcn = createCallbackFcn(app, @play_Waterfall_Callbacks, true);
            app.play_Waterfall_Fcn.FontSize = 11;
            app.play_Waterfall_Fcn.BackgroundColor = [1 1 1];
            app.play_Waterfall_Fcn.Layout.Row = 2;
            app.play_Waterfall_Fcn.Layout.Column = 1;
            app.play_Waterfall_Fcn.Value = 'image';

            % Create play_Waterfall_DecimationLabel
            app.play_Waterfall_DecimationLabel = uilabel(app.play_WaterFallGrid);
            app.play_Waterfall_DecimationLabel.VerticalAlignment = 'bottom';
            app.play_Waterfall_DecimationLabel.FontSize = 10;
            app.play_Waterfall_DecimationLabel.Layout.Row = 1;
            app.play_Waterfall_DecimationLabel.Layout.Column = 2;
            app.play_Waterfall_DecimationLabel.Text = 'Decimação:';

            % Create play_Waterfall_DecimationValue
            app.play_Waterfall_DecimationValue = uilabel(app.play_WaterFallGrid);
            app.play_Waterfall_DecimationValue.HorizontalAlignment = 'right';
            app.play_Waterfall_DecimationValue.VerticalAlignment = 'bottom';
            app.play_Waterfall_DecimationValue.FontSize = 10;
            app.play_Waterfall_DecimationValue.FontColor = [0.8 0.8 0.8];
            app.play_Waterfall_DecimationValue.Layout.Row = 1;
            app.play_Waterfall_DecimationValue.Layout.Column = 2;
            app.play_Waterfall_DecimationValue.Text = 'auto';

            % Create play_Waterfall_Decimation
            app.play_Waterfall_Decimation = uidropdown(app.play_WaterFallGrid);
            app.play_Waterfall_Decimation.Items = {'auto', '1', '2', '4', '8', '16', '32', '64', '128', '256'};
            app.play_Waterfall_Decimation.ValueChangedFcn = createCallbackFcn(app, @play_Waterfall_Callbacks, true);
            app.play_Waterfall_Decimation.Enable = 'off';
            app.play_Waterfall_Decimation.FontSize = 11;
            app.play_Waterfall_Decimation.BackgroundColor = [1 1 1];
            app.play_Waterfall_Decimation.Layout.Row = 2;
            app.play_Waterfall_Decimation.Layout.Column = 2;
            app.play_Waterfall_Decimation.Value = 'auto';

            % Create play_Waterfall_TimelineLabel
            app.play_Waterfall_TimelineLabel = uilabel(app.play_WaterFallGrid);
            app.play_Waterfall_TimelineLabel.VerticalAlignment = 'bottom';
            app.play_Waterfall_TimelineLabel.WordWrap = 'on';
            app.play_Waterfall_TimelineLabel.FontSize = 10;
            app.play_Waterfall_TimelineLabel.Layout.Row = 1;
            app.play_Waterfall_TimelineLabel.Layout.Column = [3 4];
            app.play_Waterfall_TimelineLabel.Text = 'Timeline:';

            % Create play_Waterfall_Timeline
            app.play_Waterfall_Timeline = uidropdown(app.play_WaterFallGrid);
            app.play_Waterfall_Timeline.Items = {'on', 'off'};
            app.play_Waterfall_Timeline.ValueChangedFcn = createCallbackFcn(app, @play_Waterfall_Callbacks, true);
            app.play_Waterfall_Timeline.FontSize = 11;
            app.play_Waterfall_Timeline.BackgroundColor = [1 1 1];
            app.play_Waterfall_Timeline.Layout.Row = 2;
            app.play_Waterfall_Timeline.Layout.Column = [3 4];
            app.play_Waterfall_Timeline.Value = 'on';

            % Create play_Waterfall_ColorbarLabel
            app.play_Waterfall_ColorbarLabel = uilabel(app.play_WaterFallGrid);
            app.play_Waterfall_ColorbarLabel.VerticalAlignment = 'bottom';
            app.play_Waterfall_ColorbarLabel.FontSize = 10;
            app.play_Waterfall_ColorbarLabel.Layout.Row = 3;
            app.play_Waterfall_ColorbarLabel.Layout.Column = 1;
            app.play_Waterfall_ColorbarLabel.Text = 'Legenda de cor:';

            % Create play_Waterfall_Colorbar
            app.play_Waterfall_Colorbar = uidropdown(app.play_WaterFallGrid);
            app.play_Waterfall_Colorbar.Items = {'off', 'west', 'east', 'eastoutside'};
            app.play_Waterfall_Colorbar.ValueChangedFcn = createCallbackFcn(app, @play_Waterfall_ColorbarValueChanged, true);
            app.play_Waterfall_Colorbar.Enable = 'off';
            app.play_Waterfall_Colorbar.FontSize = 11;
            app.play_Waterfall_Colorbar.BackgroundColor = [1 1 1];
            app.play_Waterfall_Colorbar.Layout.Row = 4;
            app.play_Waterfall_Colorbar.Layout.Column = [1 2];
            app.play_Waterfall_Colorbar.Value = 'off';

            % Create play_Waterfall_ColormapLabel
            app.play_Waterfall_ColormapLabel = uilabel(app.play_WaterFallGrid);
            app.play_Waterfall_ColormapLabel.VerticalAlignment = 'bottom';
            app.play_Waterfall_ColormapLabel.FontSize = 10;
            app.play_Waterfall_ColormapLabel.Layout.Row = 3;
            app.play_Waterfall_ColormapLabel.Layout.Column = [3 4];
            app.play_Waterfall_ColormapLabel.Text = 'Mapa de cor:';

            % Create play_Waterfall_Colormap
            app.play_Waterfall_Colormap = uidropdown(app.play_WaterFallGrid);
            app.play_Waterfall_Colormap.Items = {'winter', 'parula', 'turbo', 'gray', 'hot', 'jet', 'summer'};
            app.play_Waterfall_Colormap.ValueChangedFcn = createCallbackFcn(app, @play_Waterfall_Callbacks, true);
            app.play_Waterfall_Colormap.FontSize = 11;
            app.play_Waterfall_Colormap.BackgroundColor = [1 1 1];
            app.play_Waterfall_Colormap.Layout.Row = 4;
            app.play_Waterfall_Colormap.Layout.Column = [3 4];
            app.play_Waterfall_Colormap.Value = 'winter';

            % Create play_Waterfall_MeshStyleLabel
            app.play_Waterfall_MeshStyleLabel = uilabel(app.play_WaterFallGrid);
            app.play_Waterfall_MeshStyleLabel.VerticalAlignment = 'bottom';
            app.play_Waterfall_MeshStyleLabel.WordWrap = 'on';
            app.play_Waterfall_MeshStyleLabel.FontSize = 10;
            app.play_Waterfall_MeshStyleLabel.Layout.Row = 5;
            app.play_Waterfall_MeshStyleLabel.Layout.Column = 1;
            app.play_Waterfall_MeshStyleLabel.Text = 'MeshStyle:';

            % Create play_Waterfall_MeshStyle
            app.play_Waterfall_MeshStyle = uidropdown(app.play_WaterFallGrid);
            app.play_Waterfall_MeshStyle.Items = {'row', 'both'};
            app.play_Waterfall_MeshStyle.ValueChangedFcn = createCallbackFcn(app, @play_Waterfall_Callbacks, true);
            app.play_Waterfall_MeshStyle.Enable = 'off';
            app.play_Waterfall_MeshStyle.FontSize = 11;
            app.play_Waterfall_MeshStyle.BackgroundColor = [1 1 1];
            app.play_Waterfall_MeshStyle.Layout.Row = 6;
            app.play_Waterfall_MeshStyle.Layout.Column = 1;
            app.play_Waterfall_MeshStyle.Value = 'both';

            % Create play_Waterfall_cLim_Label
            app.play_Waterfall_cLim_Label = uilabel(app.play_WaterFallGrid);
            app.play_Waterfall_cLim_Label.VerticalAlignment = 'bottom';
            app.play_Waterfall_cLim_Label.FontSize = 10;
            app.play_Waterfall_cLim_Label.Layout.Row = 5;
            app.play_Waterfall_cLim_Label.Layout.Column = 2;
            app.play_Waterfall_cLim_Label.Text = 'Limites (dB):';

            % Create play_Waterfall_cLim_Mode
            app.play_Waterfall_cLim_Mode = uiimage(app.play_WaterFallGrid);
            app.play_Waterfall_cLim_Mode.ImageClickedFcn = createCallbackFcn(app, @play_Waterfall_Callbacks, true);
            app.play_Waterfall_cLim_Mode.Enable = 'off';
            app.play_Waterfall_cLim_Mode.Layout.Row = 5;
            app.play_Waterfall_cLim_Mode.Layout.Column = 4;
            app.play_Waterfall_cLim_Mode.HorizontalAlignment = 'right';
            app.play_Waterfall_cLim_Mode.VerticalAlignment = 'bottom';
            app.play_Waterfall_cLim_Mode.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Refresh_18.png');

            % Create play_Waterfall_cLim_Grid2
            app.play_Waterfall_cLim_Grid2 = uigridlayout(app.play_WaterFallGrid);
            app.play_Waterfall_cLim_Grid2.ColumnWidth = {'1x', 10, '1x'};
            app.play_Waterfall_cLim_Grid2.RowHeight = {'1x'};
            app.play_Waterfall_cLim_Grid2.ColumnSpacing = 0;
            app.play_Waterfall_cLim_Grid2.RowSpacing = 5;
            app.play_Waterfall_cLim_Grid2.Padding = [0 0 0 0];
            app.play_Waterfall_cLim_Grid2.Layout.Row = 6;
            app.play_Waterfall_cLim_Grid2.Layout.Column = [2 4];
            app.play_Waterfall_cLim_Grid2.BackgroundColor = [1 1 1];

            % Create play_Waterfall_cLim1
            app.play_Waterfall_cLim1 = uispinner(app.play_Waterfall_cLim_Grid2);
            app.play_Waterfall_cLim1.Step = 5;
            app.play_Waterfall_cLim1.RoundFractionalValues = 'on';
            app.play_Waterfall_cLim1.ValueDisplayFormat = '%.0f';
            app.play_Waterfall_cLim1.ValueChangedFcn = createCallbackFcn(app, @play_Waterfall_cLimValueChanged, true);
            app.play_Waterfall_cLim1.FontSize = 11;
            app.play_Waterfall_cLim1.Enable = 'off';
            app.play_Waterfall_cLim1.Tooltip = {''};
            app.play_Waterfall_cLim1.Layout.Row = 1;
            app.play_Waterfall_cLim1.Layout.Column = 1;

            % Create play_Waterfall_cLim_Separation
            app.play_Waterfall_cLim_Separation = uilabel(app.play_Waterfall_cLim_Grid2);
            app.play_Waterfall_cLim_Separation.HorizontalAlignment = 'center';
            app.play_Waterfall_cLim_Separation.FontSize = 10;
            app.play_Waterfall_cLim_Separation.Enable = 'off';
            app.play_Waterfall_cLim_Separation.Layout.Row = 1;
            app.play_Waterfall_cLim_Separation.Layout.Column = 2;
            app.play_Waterfall_cLim_Separation.Text = '-';

            % Create play_Waterfall_cLim2
            app.play_Waterfall_cLim2 = uispinner(app.play_Waterfall_cLim_Grid2);
            app.play_Waterfall_cLim2.Step = 5;
            app.play_Waterfall_cLim2.RoundFractionalValues = 'on';
            app.play_Waterfall_cLim2.ValueDisplayFormat = '%.0f';
            app.play_Waterfall_cLim2.ValueChangedFcn = createCallbackFcn(app, @play_Waterfall_cLimValueChanged, true);
            app.play_Waterfall_cLim2.FontSize = 11;
            app.play_Waterfall_cLim2.Enable = 'off';
            app.play_Waterfall_cLim2.Tooltip = {''};
            app.play_Waterfall_cLim2.Layout.Row = 1;
            app.play_Waterfall_cLim2.Layout.Column = 3;
            app.play_Waterfall_cLim2.Value = 1;

            % Create play_Customization
            app.play_Customization = uicheckbox(app.play_ControlsTab1Info);
            app.play_Customization.ValueChangedFcn = createCallbackFcn(app, @play_CustomizationValueChanged, true);
            app.play_Customization.Text = 'Customizar controles do plot.';
            app.play_Customization.WordWrap = 'on';
            app.play_Customization.FontSize = 11;
            app.play_Customization.Layout.Row = 8;
            app.play_Customization.Layout.Column = 1;

            % Create play_ControlsTab2Grid
            app.play_ControlsTab2Grid = uigridlayout(app.play_ControlsGrid);
            app.play_ControlsTab2Grid.ColumnWidth = {18, '1x', 16};
            app.play_ControlsTab2Grid.RowHeight = {'1x'};
            app.play_ControlsTab2Grid.ColumnSpacing = 5;
            app.play_ControlsTab2Grid.RowSpacing = 5;
            app.play_ControlsTab2Grid.Padding = [2 2 2 2];
            app.play_ControlsTab2Grid.Tag = 'COLORLOCKED';
            app.play_ControlsTab2Grid.Layout.Row = 3;
            app.play_ControlsTab2Grid.Layout.Column = 1;
            app.play_ControlsTab2Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create play_ControlsTab2Label
            app.play_ControlsTab2Label = uilabel(app.play_ControlsTab2Grid);
            app.play_ControlsTab2Label.FontSize = 11;
            app.play_ControlsTab2Label.Layout.Row = 1;
            app.play_ControlsTab2Label.Layout.Column = 2;
            app.play_ControlsTab2Label.Text = 'CANAIS';

            % Create play_Channel_ShowPlotWarn
            app.play_Channel_ShowPlotWarn = uiimage(app.play_ControlsTab2Grid);
            app.play_Channel_ShowPlotWarn.Enable = 'off';
            app.play_Channel_ShowPlotWarn.Visible = 'off';
            app.play_Channel_ShowPlotWarn.Tooltip = {'O plot dos canais é possível apenas se definida,'; 'na canalização, a sua largura de banda.'};
            app.play_Channel_ShowPlotWarn.Layout.Row = 1;
            app.play_Channel_ShowPlotWarn.Layout.Column = 3;
            app.play_Channel_ShowPlotWarn.VerticalAlignment = 'bottom';
            app.play_Channel_ShowPlotWarn.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Warn_18.png');

            % Create play_ControlsTab2Image
            app.play_ControlsTab2Image = uiimage(app.play_ControlsTab2Grid);
            app.play_ControlsTab2Image.ImageClickedFcn = createCallbackFcn(app, @play_TabGroupVisibility, true);
            app.play_ControlsTab2Image.Layout.Row = 1;
            app.play_ControlsTab2Image.Layout.Column = [1 2];
            app.play_ControlsTab2Image.HorizontalAlignment = 'left';
            app.play_ControlsTab2Image.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Channel_32.png');

            % Create play_ControlsTab2Info
            app.play_ControlsTab2Info = uigridlayout(app.play_ControlsGrid);
            app.play_ControlsTab2Info.ColumnWidth = {'1x', 16, 16};
            app.play_ControlsTab2Info.RowHeight = {22, 32, 210, 80, 8, '1x', 22, 42, 8, '0.5x'};
            app.play_ControlsTab2Info.ColumnSpacing = 5;
            app.play_ControlsTab2Info.RowSpacing = 5;
            app.play_ControlsTab2Info.Padding = [0 0 0 0];
            app.play_ControlsTab2Info.Layout.Row = 4;
            app.play_ControlsTab2Info.Layout.Column = 1;
            app.play_ControlsTab2Info.BackgroundColor = [1 1 1];

            % Create play_Channel_Label
            app.play_Channel_Label = uilabel(app.play_ControlsTab2Info);
            app.play_Channel_Label.VerticalAlignment = 'bottom';
            app.play_Channel_Label.FontSize = 10;
            app.play_Channel_Label.FontColor = [0.149 0.149 0.149];
            app.play_Channel_Label.Layout.Row = 1;
            app.play_Channel_Label.Layout.Column = 1;
            app.play_Channel_Label.Text = 'INCLUSÃO DE CANAIS';

            % Create play_Channel_RadioGroup
            app.play_Channel_RadioGroup = uibuttongroup(app.play_ControlsTab2Info);
            app.play_Channel_RadioGroup.AutoResizeChildren = 'off';
            app.play_Channel_RadioGroup.SelectionChangedFcn = createCallbackFcn(app, @play_Channel_RadioGroupSelectionChanged, true);
            app.play_Channel_RadioGroup.BackgroundColor = [1 1 1];
            app.play_Channel_RadioGroup.Layout.Row = 2;
            app.play_Channel_RadioGroup.Layout.Column = [1 3];
            app.play_Channel_RadioGroup.FontWeight = 'bold';
            app.play_Channel_RadioGroup.FontSize = 10;

            % Create play_Channel_ReferenceList
            app.play_Channel_ReferenceList = uiradiobutton(app.play_Channel_RadioGroup);
            app.play_Channel_ReferenceList.Text = {'Canalização'; 'de referência'};
            app.play_Channel_ReferenceList.FontSize = 10;
            app.play_Channel_ReferenceList.Position = [11 4 80 25];
            app.play_Channel_ReferenceList.Value = true;

            % Create play_Channel_Multiples
            app.play_Channel_Multiples = uiradiobutton(app.play_Channel_RadioGroup);
            app.play_Channel_Multiples.Text = {'Faixa de'; 'frequência'};
            app.play_Channel_Multiples.FontSize = 10;
            app.play_Channel_Multiples.Position = [108 4 69 25];

            % Create play_Channel_Single
            app.play_Channel_Single = uiradiobutton(app.play_Channel_RadioGroup);
            app.play_Channel_Single.Text = 'Canal';
            app.play_Channel_Single.FontSize = 10;
            app.play_Channel_Single.Position = [194 5 48 22];

            % Create play_Channel_File
            app.play_Channel_File = uiradiobutton(app.play_Channel_RadioGroup);
            app.play_Channel_File.Text = 'Arquivo';
            app.play_Channel_File.FontSize = 10;
            app.play_Channel_File.Position = [257 5 56 22];

            % Create play_Channel_Panel
            app.play_Channel_Panel = uipanel(app.play_ControlsTab2Info);
            app.play_Channel_Panel.AutoResizeChildren = 'off';
            app.play_Channel_Panel.Layout.Row = 3;
            app.play_Channel_Panel.Layout.Column = [1 3];

            % Create play_Channel_Grid
            app.play_Channel_Grid = uigridlayout(app.play_Channel_Panel);
            app.play_Channel_Grid.ColumnWidth = {'1x', '1x', 66, 16};
            app.play_Channel_Grid.RowHeight = {17, 22, 0, 27, 22, 27, 22, '1x'};
            app.play_Channel_Grid.RowSpacing = 5;
            app.play_Channel_Grid.Padding = [10 10 10 5];
            app.play_Channel_Grid.BackgroundColor = [1 1 1];

            % Create play_Channel_ListLabel
            app.play_Channel_ListLabel = uilabel(app.play_Channel_Grid);
            app.play_Channel_ListLabel.VerticalAlignment = 'bottom';
            app.play_Channel_ListLabel.FontSize = 10;
            app.play_Channel_ListLabel.Layout.Row = 1;
            app.play_Channel_ListLabel.Layout.Column = [1 2];
            app.play_Channel_ListLabel.Text = 'Referência:';

            % Create play_Channel_ListUpdate
            app.play_Channel_ListUpdate = uiimage(app.play_Channel_Grid);
            app.play_Channel_ListUpdate.ImageClickedFcn = createCallbackFcn(app, @play_Channel_AutomaticChannelListUpdate, true);
            app.play_Channel_ListUpdate.Tooltip = {'Retorna à configuração padrão'};
            app.play_Channel_ListUpdate.Layout.Row = 1;
            app.play_Channel_ListUpdate.Layout.Column = 4;
            app.play_Channel_ListUpdate.VerticalAlignment = 'bottom';
            app.play_Channel_ListUpdate.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Refresh_18.png');

            % Create play_Channel_List
            app.play_Channel_List = uidropdown(app.play_Channel_Grid);
            app.play_Channel_List.Items = {};
            app.play_Channel_List.ValueChangedFcn = createCallbackFcn(app, @play_Channel_AutomaticChannelListValueChanged, true);
            app.play_Channel_List.FontSize = 11;
            app.play_Channel_List.BackgroundColor = [1 1 1];
            app.play_Channel_List.Layout.Row = 2;
            app.play_Channel_List.Layout.Column = [1 4];
            app.play_Channel_List.Value = {};

            % Create play_Channel_Name
            app.play_Channel_Name = uieditfield(app.play_Channel_Grid, 'text');
            app.play_Channel_Name.CharacterLimits = [0 128];
            app.play_Channel_Name.Layout.Row = 3;
            app.play_Channel_Name.Layout.Column = [1 4];

            % Create play_Channel_nChannelsLabel
            app.play_Channel_nChannelsLabel = uilabel(app.play_Channel_Grid);
            app.play_Channel_nChannelsLabel.VerticalAlignment = 'bottom';
            app.play_Channel_nChannelsLabel.WordWrap = 'on';
            app.play_Channel_nChannelsLabel.FontSize = 10;
            app.play_Channel_nChannelsLabel.Layout.Row = 4;
            app.play_Channel_nChannelsLabel.Layout.Column = 1;
            app.play_Channel_nChannelsLabel.Text = {'Qtd.'; 'canais:'};

            % Create play_Channel_nChannels
            app.play_Channel_nChannels = uieditfield(app.play_Channel_Grid, 'numeric');
            app.play_Channel_nChannels.Limits = [-1 Inf];
            app.play_Channel_nChannels.RoundFractionalValues = 'on';
            app.play_Channel_nChannels.ValueDisplayFormat = '%d';
            app.play_Channel_nChannels.Editable = 'off';
            app.play_Channel_nChannels.FontSize = 11;
            app.play_Channel_nChannels.Layout.Row = 5;
            app.play_Channel_nChannels.Layout.Column = 1;
            app.play_Channel_nChannels.Value = 1;

            % Create play_Channel_FirstChannelLabel
            app.play_Channel_FirstChannelLabel = uilabel(app.play_Channel_Grid);
            app.play_Channel_FirstChannelLabel.VerticalAlignment = 'bottom';
            app.play_Channel_FirstChannelLabel.WordWrap = 'on';
            app.play_Channel_FirstChannelLabel.FontSize = 10;
            app.play_Channel_FirstChannelLabel.Layout.Row = 4;
            app.play_Channel_FirstChannelLabel.Layout.Column = [2 4];
            app.play_Channel_FirstChannelLabel.Text = {'Frequência central'; '1º canal (MHz):'};

            % Create play_Channel_FirstChannel
            app.play_Channel_FirstChannel = uieditfield(app.play_Channel_Grid, 'numeric');
            app.play_Channel_FirstChannel.Limits = [0 Inf];
            app.play_Channel_FirstChannel.ValueDisplayFormat = '%.3f';
            app.play_Channel_FirstChannel.ValueChangedFcn = createCallbackFcn(app, @play_Channel_FirstChannelValueChanged, true);
            app.play_Channel_FirstChannel.FontSize = 11;
            app.play_Channel_FirstChannel.Layout.Row = 5;
            app.play_Channel_FirstChannel.Layout.Column = 2;

            % Create play_Channel_LastChannelLabel
            app.play_Channel_LastChannelLabel = uilabel(app.play_Channel_Grid);
            app.play_Channel_LastChannelLabel.VerticalAlignment = 'bottom';
            app.play_Channel_LastChannelLabel.WordWrap = 'on';
            app.play_Channel_LastChannelLabel.FontSize = 10;
            app.play_Channel_LastChannelLabel.Layout.Row = 4;
            app.play_Channel_LastChannelLabel.Layout.Column = [3 4];
            app.play_Channel_LastChannelLabel.Text = {'Frequência central'; 'n-ésimo canal:'};

            % Create play_Channel_LastChannel
            app.play_Channel_LastChannel = uieditfield(app.play_Channel_Grid, 'numeric');
            app.play_Channel_LastChannel.Limits = [0 Inf];
            app.play_Channel_LastChannel.ValueDisplayFormat = '%.3f';
            app.play_Channel_LastChannel.ValueChangedFcn = createCallbackFcn(app, @play_Channel_FirstChannelValueChanged, true);
            app.play_Channel_LastChannel.FontSize = 11;
            app.play_Channel_LastChannel.Layout.Row = 5;
            app.play_Channel_LastChannel.Layout.Column = [3 4];

            % Create play_Channel_ClassLabel
            app.play_Channel_ClassLabel = uilabel(app.play_Channel_Grid);
            app.play_Channel_ClassLabel.VerticalAlignment = 'bottom';
            app.play_Channel_ClassLabel.WordWrap = 'on';
            app.play_Channel_ClassLabel.FontSize = 10;
            app.play_Channel_ClassLabel.Layout.Row = 6;
            app.play_Channel_ClassLabel.Layout.Column = 1;
            app.play_Channel_ClassLabel.Text = {'Classe de '; 'emissão:'};

            % Create play_Channel_Class
            app.play_Channel_Class = uidropdown(app.play_Channel_Grid);
            app.play_Channel_Class.Items = {};
            app.play_Channel_Class.FontSize = 11;
            app.play_Channel_Class.BackgroundColor = [1 1 1];
            app.play_Channel_Class.Layout.Row = 7;
            app.play_Channel_Class.Layout.Column = 1;
            app.play_Channel_Class.Value = {};

            % Create play_Channel_StepWidthLabel
            app.play_Channel_StepWidthLabel = uilabel(app.play_Channel_Grid);
            app.play_Channel_StepWidthLabel.VerticalAlignment = 'bottom';
            app.play_Channel_StepWidthLabel.WordWrap = 'on';
            app.play_Channel_StepWidthLabel.FontSize = 10;
            app.play_Channel_StepWidthLabel.Layout.Row = 6;
            app.play_Channel_StepWidthLabel.Layout.Column = 2;
            app.play_Channel_StepWidthLabel.Text = {'Espaçamento '; 'canais (kHz):'};

            % Create play_Channel_StepWidth
            app.play_Channel_StepWidth = uieditfield(app.play_Channel_Grid, 'numeric');
            app.play_Channel_StepWidth.Limits = [-1 Inf];
            app.play_Channel_StepWidth.ValueDisplayFormat = '%.1f';
            app.play_Channel_StepWidth.ValueChangedFcn = createCallbackFcn(app, @play_Channel_FirstChannelValueChanged, true);
            app.play_Channel_StepWidth.FontSize = 11;
            app.play_Channel_StepWidth.Layout.Row = 7;
            app.play_Channel_StepWidth.Layout.Column = 2;

            % Create play_Channel_BWLabel
            app.play_Channel_BWLabel = uilabel(app.play_Channel_Grid);
            app.play_Channel_BWLabel.VerticalAlignment = 'bottom';
            app.play_Channel_BWLabel.WordWrap = 'on';
            app.play_Channel_BWLabel.FontSize = 10;
            app.play_Channel_BWLabel.Layout.Row = 6;
            app.play_Channel_BWLabel.Layout.Column = [3 4];
            app.play_Channel_BWLabel.Text = {'Largura canal'; '(kHz):'};

            % Create play_Channel_BW
            app.play_Channel_BW = uieditfield(app.play_Channel_Grid, 'numeric');
            app.play_Channel_BW.Limits = [-1 Inf];
            app.play_Channel_BW.ValueDisplayFormat = '%.1f';
            app.play_Channel_BW.FontSize = 11;
            app.play_Channel_BW.Layout.Row = 7;
            app.play_Channel_BW.Layout.Column = [3 4];

            % Create play_Channel_Sample
            app.play_Channel_Sample = uilabel(app.play_Channel_Grid);
            app.play_Channel_Sample.WordWrap = 'on';
            app.play_Channel_Sample.FontSize = 11;
            app.play_Channel_Sample.FontColor = [0.651 0.651 0.651];
            app.play_Channel_Sample.Layout.Row = 8;
            app.play_Channel_Sample.Layout.Column = [1 4];
            app.play_Channel_Sample.Interpreter = 'html';
            app.play_Channel_Sample.Text = '<p style="text-align: justify;">101.700 MHz, 101.900 MHz, 102.100 MHz, 102.300 MHz, 102.500 MHz, 102.700 MHz...</font>';

            % Create play_Channel_ExternalFilePanel
            app.play_Channel_ExternalFilePanel = uipanel(app.play_ControlsTab2Info);
            app.play_Channel_ExternalFilePanel.Layout.Row = 4;
            app.play_Channel_ExternalFilePanel.Layout.Column = [1 3];

            % Create play_Channel_ExternalFileGrid
            app.play_Channel_ExternalFileGrid = uigridlayout(app.play_Channel_ExternalFilePanel);
            app.play_Channel_ExternalFileGrid.ColumnWidth = {'1x'};
            app.play_Channel_ExternalFileGrid.RowHeight = {17, 22, '1x'};
            app.play_Channel_ExternalFileGrid.RowSpacing = 5;
            app.play_Channel_ExternalFileGrid.Padding = [10 10 10 5];
            app.play_Channel_ExternalFileGrid.BackgroundColor = [1 1 1];

            % Create play_Channel_ExternalFileLabel
            app.play_Channel_ExternalFileLabel = uilabel(app.play_Channel_ExternalFileGrid);
            app.play_Channel_ExternalFileLabel.VerticalAlignment = 'bottom';
            app.play_Channel_ExternalFileLabel.FontSize = 10;
            app.play_Channel_ExternalFileLabel.Layout.Row = 1;
            app.play_Channel_ExternalFileLabel.Layout.Column = 1;
            app.play_Channel_ExternalFileLabel.Text = 'Formato:';

            % Create play_Channel_ExternalFile
            app.play_Channel_ExternalFile = uidropdown(app.play_Channel_ExternalFileGrid);
            app.play_Channel_ExternalFile.Items = {'Generic (json)'};
            app.play_Channel_ExternalFile.FontSize = 11;
            app.play_Channel_ExternalFile.BackgroundColor = [1 1 1];
            app.play_Channel_ExternalFile.Layout.Row = 2;
            app.play_Channel_ExternalFile.Layout.Column = 1;
            app.play_Channel_ExternalFile.Value = 'Generic (json)';

            % Create play_Channel_FileTemplate
            app.play_Channel_FileTemplate = uihyperlink(app.play_Channel_ExternalFileGrid);
            app.play_Channel_FileTemplate.HyperlinkClickedFcn = createCallbackFcn(app, @play_DownloadFileTemplate, true);
            app.play_Channel_FileTemplate.VerticalAlignment = 'top';
            app.play_Channel_FileTemplate.FontSize = 10;
            app.play_Channel_FileTemplate.Layout.Row = 3;
            app.play_Channel_FileTemplate.Layout.Column = 1;
            app.play_Channel_FileTemplate.Text = 'Download modelo do arquivo';

            % Create play_Channel_add
            app.play_Channel_add = uiimage(app.play_ControlsTab2Info);
            app.play_Channel_add.ScaleMethod = 'scaledown';
            app.play_Channel_add.ImageClickedFcn = createCallbackFcn(app, @play_Channel_addChannel, true);
            app.play_Channel_add.Layout.Row = 5;
            app.play_Channel_add.Layout.Column = 3;
            app.play_Channel_add.HorizontalAlignment = 'right';
            app.play_Channel_add.VerticalAlignment = 'bottom';
            app.play_Channel_add.ImageSource = fullfile(pathToMLAPP, 'Icons', 'addSymbol_32.png');

            % Create play_Channel_Tree
            app.play_Channel_Tree = uitree(app.play_ControlsTab2Info);
            app.play_Channel_Tree.SelectionChangedFcn = createCallbackFcn(app, @play_Channel_TreeSelectionChanged, true);
            app.play_Channel_Tree.FontSize = 10;
            app.play_Channel_Tree.Layout.Row = 6;
            app.play_Channel_Tree.Layout.Column = [1 3];

            % Create play_BandLimits_Status
            app.play_BandLimits_Status = uicheckbox(app.play_ControlsTab2Info);
            app.play_BandLimits_Status.ValueChangedFcn = createCallbackFcn(app, @play_BandLimits_StatusValueChanged, true);
            app.play_BandLimits_Status.Text = 'Limitar detecção de emissões a subfaixa(s)';
            app.play_BandLimits_Status.FontSize = 11;
            app.play_BandLimits_Status.Layout.Row = 7;
            app.play_BandLimits_Status.Layout.Column = [1 3];

            % Create play_BandLimits_Panel
            app.play_BandLimits_Panel = uipanel(app.play_ControlsTab2Info);
            app.play_BandLimits_Panel.AutoResizeChildren = 'off';
            app.play_BandLimits_Panel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.play_BandLimits_Panel.Layout.Row = 8;
            app.play_BandLimits_Panel.Layout.Column = [1 3];
            app.play_BandLimits_Panel.FontSize = 10;

            % Create play_BandLimits_Grid
            app.play_BandLimits_Grid = uigridlayout(app.play_BandLimits_Panel);
            app.play_BandLimits_Grid.ColumnWidth = {'1x', 70, '1x'};
            app.play_BandLimits_Grid.RowHeight = {22};
            app.play_BandLimits_Grid.RowSpacing = 5;
            app.play_BandLimits_Grid.BackgroundColor = [1 1 1];

            % Create play_BandLimits_xLim1
            app.play_BandLimits_xLim1 = uieditfield(app.play_BandLimits_Grid, 'numeric');
            app.play_BandLimits_xLim1.ValueDisplayFormat = '%.3f';
            app.play_BandLimits_xLim1.FontSize = 11;
            app.play_BandLimits_xLim1.Enable = 'off';
            app.play_BandLimits_xLim1.Layout.Row = 1;
            app.play_BandLimits_xLim1.Layout.Column = 1;

            % Create play_BandLimits_xLabel
            app.play_BandLimits_xLabel = uilabel(app.play_BandLimits_Grid);
            app.play_BandLimits_xLabel.HorizontalAlignment = 'center';
            app.play_BandLimits_xLabel.FontSize = 10;
            app.play_BandLimits_xLabel.Layout.Row = 1;
            app.play_BandLimits_xLabel.Layout.Column = 2;
            app.play_BandLimits_xLabel.Text = 'Frequência';

            % Create play_BandLimits_xLim2
            app.play_BandLimits_xLim2 = uieditfield(app.play_BandLimits_Grid, 'numeric');
            app.play_BandLimits_xLim2.ValueDisplayFormat = '%.3f';
            app.play_BandLimits_xLim2.FontSize = 11;
            app.play_BandLimits_xLim2.Enable = 'off';
            app.play_BandLimits_xLim2.Layout.Row = 1;
            app.play_BandLimits_xLim2.Layout.Column = 3;

            % Create play_BandLimits_add
            app.play_BandLimits_add = uiimage(app.play_ControlsTab2Info);
            app.play_BandLimits_add.ScaleMethod = 'scaledown';
            app.play_BandLimits_add.ImageClickedFcn = createCallbackFcn(app, @play_BandLimits_addImageClicked, true);
            app.play_BandLimits_add.Enable = 'off';
            app.play_BandLimits_add.Layout.Row = 9;
            app.play_BandLimits_add.Layout.Column = 3;
            app.play_BandLimits_add.HorizontalAlignment = 'right';
            app.play_BandLimits_add.VerticalAlignment = 'bottom';
            app.play_BandLimits_add.ImageSource = fullfile(pathToMLAPP, 'Icons', 'addSymbol_32.png');

            % Create play_BandLimits_Tree
            app.play_BandLimits_Tree = uitree(app.play_ControlsTab2Info);
            app.play_BandLimits_Tree.Multiselect = 'on';
            app.play_BandLimits_Tree.Enable = 'off';
            app.play_BandLimits_Tree.FontSize = 10;
            app.play_BandLimits_Tree.Layout.Row = 10;
            app.play_BandLimits_Tree.Layout.Column = [1 3];

            % Create play_Channel_ShowPlot
            app.play_Channel_ShowPlot = uiimage(app.play_ControlsTab2Info);
            app.play_Channel_ShowPlot.ImageClickedFcn = createCallbackFcn(app, @play_Channel_ShowPlotImageClicked, true);
            app.play_Channel_ShowPlot.Tooltip = {'Mostra canais no plot'};
            app.play_Channel_ShowPlot.Layout.Row = 1;
            app.play_Channel_ShowPlot.Layout.Column = 3;
            app.play_Channel_ShowPlot.VerticalAlignment = 'bottom';
            app.play_Channel_ShowPlot.ImageSource = fullfile(pathToMLAPP, 'Icons', 'EyeNegative_32.png');

            % Create play_ControlsTab3Grid
            app.play_ControlsTab3Grid = uigridlayout(app.play_ControlsGrid);
            app.play_ControlsTab3Grid.ColumnWidth = {18, '1x'};
            app.play_ControlsTab3Grid.RowHeight = {'1x'};
            app.play_ControlsTab3Grid.ColumnSpacing = 5;
            app.play_ControlsTab3Grid.RowSpacing = 5;
            app.play_ControlsTab3Grid.Padding = [2 2 2 2];
            app.play_ControlsTab3Grid.Tag = 'COLORLOCKED';
            app.play_ControlsTab3Grid.Layout.Row = 5;
            app.play_ControlsTab3Grid.Layout.Column = 1;
            app.play_ControlsTab3Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create play_ControlsTab3Label
            app.play_ControlsTab3Label = uilabel(app.play_ControlsTab3Grid);
            app.play_ControlsTab3Label.FontSize = 11;
            app.play_ControlsTab3Label.Layout.Row = 1;
            app.play_ControlsTab3Label.Layout.Column = 2;
            app.play_ControlsTab3Label.Text = 'EMISSÕES';

            % Create play_ControlsTab3Image
            app.play_ControlsTab3Image = uiimage(app.play_ControlsTab3Grid);
            app.play_ControlsTab3Image.ImageClickedFcn = createCallbackFcn(app, @play_TabGroupVisibility, true);
            app.play_ControlsTab3Image.Layout.Row = 1;
            app.play_ControlsTab3Image.Layout.Column = [1 2];
            app.play_ControlsTab3Image.HorizontalAlignment = 'left';
            app.play_ControlsTab3Image.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Detection_32.png');

            % Create play_ControlsTab3Info
            app.play_ControlsTab3Info = uigridlayout(app.play_ControlsGrid);
            app.play_ControlsTab3Info.ColumnWidth = {'1x', 100, 89, 16};
            app.play_ControlsTab3Info.RowHeight = {22, 32, 270, 80, 8, '1x', 22, 22, 44};
            app.play_ControlsTab3Info.ColumnSpacing = 5;
            app.play_ControlsTab3Info.RowSpacing = 5;
            app.play_ControlsTab3Info.Padding = [0 0 0 0];
            app.play_ControlsTab3Info.Layout.Row = 6;
            app.play_ControlsTab3Info.Layout.Column = 1;
            app.play_ControlsTab3Info.BackgroundColor = [1 1 1];

            % Create play_FindPeaks_Label
            app.play_FindPeaks_Label = uilabel(app.play_ControlsTab3Info);
            app.play_FindPeaks_Label.VerticalAlignment = 'bottom';
            app.play_FindPeaks_Label.FontSize = 10;
            app.play_FindPeaks_Label.FontColor = [0.149 0.149 0.149];
            app.play_FindPeaks_Label.Layout.Row = 1;
            app.play_FindPeaks_Label.Layout.Column = [1 3];
            app.play_FindPeaks_Label.Text = 'DETECÇÃO DE EMISSÕES';

            % Create play_FindPeaks_RadioGroup
            app.play_FindPeaks_RadioGroup = uibuttongroup(app.play_ControlsTab3Info);
            app.play_FindPeaks_RadioGroup.AutoResizeChildren = 'off';
            app.play_FindPeaks_RadioGroup.SelectionChangedFcn = createCallbackFcn(app, @play_FindPeaks_RadioGroupSelectionChanged, true);
            app.play_FindPeaks_RadioGroup.BackgroundColor = [1 1 1];
            app.play_FindPeaks_RadioGroup.Layout.Row = 2;
            app.play_FindPeaks_RadioGroup.Layout.Column = [1 4];
            app.play_FindPeaks_RadioGroup.FontWeight = 'bold';
            app.play_FindPeaks_RadioGroup.FontSize = 10;

            % Create play_FindPeaks_auto
            app.play_FindPeaks_auto = uiradiobutton(app.play_FindPeaks_RadioGroup);
            app.play_FindPeaks_auto.Text = 'Automática';
            app.play_FindPeaks_auto.FontSize = 10;
            app.play_FindPeaks_auto.Position = [11 5 83 22];
            app.play_FindPeaks_auto.Value = true;

            % Create play_FindPeaks_ROI
            app.play_FindPeaks_ROI = uiradiobutton(app.play_FindPeaks_RadioGroup);
            app.play_FindPeaks_ROI.Text = 'ROI';
            app.play_FindPeaks_ROI.FontSize = 10;
            app.play_FindPeaks_ROI.Position = [105 5 40 22];

            % Create play_FindPeaks_DataTips
            app.play_FindPeaks_DataTips = uiradiobutton(app.play_FindPeaks_RadioGroup);
            app.play_FindPeaks_DataTips.Text = 'DataTips';
            app.play_FindPeaks_DataTips.FontSize = 10;
            app.play_FindPeaks_DataTips.Position = [171 5 62 22];

            % Create play_FindPeaks_File
            app.play_FindPeaks_File = uiradiobutton(app.play_FindPeaks_RadioGroup);
            app.play_FindPeaks_File.Text = 'Arquivo';
            app.play_FindPeaks_File.FontSize = 10;
            app.play_FindPeaks_File.Position = [257 5 56 22];

            % Create play_FindPeaks_ParametersPanel
            app.play_FindPeaks_ParametersPanel = uipanel(app.play_ControlsTab3Info);
            app.play_FindPeaks_ParametersPanel.AutoResizeChildren = 'off';
            app.play_FindPeaks_ParametersPanel.Layout.Row = 3;
            app.play_FindPeaks_ParametersPanel.Layout.Column = [1 4];

            % Create play_FindPeaks_ParametersGrid
            app.play_FindPeaks_ParametersGrid = uigridlayout(app.play_FindPeaks_ParametersPanel);
            app.play_FindPeaks_ParametersGrid.ColumnWidth = {'1x', '1x', '1x'};
            app.play_FindPeaks_ParametersGrid.RowHeight = {17, 22, 25, 22, 25, 22, 88};
            app.play_FindPeaks_ParametersGrid.RowSpacing = 5;
            app.play_FindPeaks_ParametersGrid.Padding = [10 10 10 5];
            app.play_FindPeaks_ParametersGrid.BackgroundColor = [1 1 1];

            % Create play_FindPeaks_AlgorithmLabel
            app.play_FindPeaks_AlgorithmLabel = uilabel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_AlgorithmLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_AlgorithmLabel.FontSize = 10;
            app.play_FindPeaks_AlgorithmLabel.Layout.Row = 1;
            app.play_FindPeaks_AlgorithmLabel.Layout.Column = [1 3];
            app.play_FindPeaks_AlgorithmLabel.Text = 'Algoritmo:';

            % Create play_FindPeaks_Algorithm
            app.play_FindPeaks_Algorithm = uidropdown(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_Algorithm.Items = {'FindPeaks', 'FindPeaks+OCC'};
            app.play_FindPeaks_Algorithm.ValueChangedFcn = createCallbackFcn(app, @play_FindPeaks_AlgorithmValueChanged, true);
            app.play_FindPeaks_Algorithm.FontSize = 11;
            app.play_FindPeaks_Algorithm.BackgroundColor = [1 1 1];
            app.play_FindPeaks_Algorithm.Layout.Row = 2;
            app.play_FindPeaks_Algorithm.Layout.Column = [1 3];
            app.play_FindPeaks_Algorithm.Value = 'FindPeaks';

            % Create play_FindPeaks_TraceLabel
            app.play_FindPeaks_TraceLabel = uilabel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_TraceLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_TraceLabel.FontSize = 10;
            app.play_FindPeaks_TraceLabel.Layout.Row = 3;
            app.play_FindPeaks_TraceLabel.Layout.Column = 1;
            app.play_FindPeaks_TraceLabel.Text = {'Tipo de '; 'traço:'};

            % Create play_FindPeaks_Trace
            app.play_FindPeaks_Trace = uidropdown(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_Trace.Items = {'MinHold', 'Média', 'MaxHold'};
            app.play_FindPeaks_Trace.FontSize = 11;
            app.play_FindPeaks_Trace.BackgroundColor = [1 1 1];
            app.play_FindPeaks_Trace.Layout.Row = 4;
            app.play_FindPeaks_Trace.Layout.Column = 1;
            app.play_FindPeaks_Trace.Value = 'Média';

            % Create play_FindPeaks_NumbersLabel
            app.play_FindPeaks_NumbersLabel = uilabel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_NumbersLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_NumbersLabel.FontSize = 10;
            app.play_FindPeaks_NumbersLabel.Layout.Row = 3;
            app.play_FindPeaks_NumbersLabel.Layout.Column = 2;
            app.play_FindPeaks_NumbersLabel.Text = {'Número de '; 'picos:'};

            % Create play_FindPeaks_Numbers
            app.play_FindPeaks_Numbers = uispinner(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_Numbers.Limits = [1 100];
            app.play_FindPeaks_Numbers.RoundFractionalValues = 'on';
            app.play_FindPeaks_Numbers.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_Numbers.FontSize = 11;
            app.play_FindPeaks_Numbers.Layout.Row = 4;
            app.play_FindPeaks_Numbers.Layout.Column = 2;
            app.play_FindPeaks_Numbers.Value = 10;

            % Create play_FindPeaks_THRLabel
            app.play_FindPeaks_THRLabel = uilabel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_THRLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_THRLabel.FontSize = 10;
            app.play_FindPeaks_THRLabel.Layout.Row = 3;
            app.play_FindPeaks_THRLabel.Layout.Column = 3;
            app.play_FindPeaks_THRLabel.Text = {'Threshold'; '(dB):'};

            % Create play_FindPeaks_THR
            app.play_FindPeaks_THR = uispinner(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_THR.Step = 10;
            app.play_FindPeaks_THR.RoundFractionalValues = 'on';
            app.play_FindPeaks_THR.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_THR.FontSize = 11;
            app.play_FindPeaks_THR.Layout.Row = 4;
            app.play_FindPeaks_THR.Layout.Column = 3;
            app.play_FindPeaks_THR.Value = -Inf;

            % Create play_FindPeaks_prominenceLabel
            app.play_FindPeaks_prominenceLabel = uilabel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_prominenceLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_prominenceLabel.WordWrap = 'on';
            app.play_FindPeaks_prominenceLabel.FontSize = 10;
            app.play_FindPeaks_prominenceLabel.Layout.Row = 5;
            app.play_FindPeaks_prominenceLabel.Layout.Column = 1;
            app.play_FindPeaks_prominenceLabel.Text = {'Proeminência '; '(dB):'};

            % Create play_FindPeaks_prominence
            app.play_FindPeaks_prominence = uispinner(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_prominence.Step = 10;
            app.play_FindPeaks_prominence.Limits = [1 Inf];
            app.play_FindPeaks_prominence.RoundFractionalValues = 'on';
            app.play_FindPeaks_prominence.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_prominence.FontSize = 11;
            app.play_FindPeaks_prominence.Layout.Row = 6;
            app.play_FindPeaks_prominence.Layout.Column = 1;
            app.play_FindPeaks_prominence.Value = 30;

            % Create play_FindPeaks_distanceLabel
            app.play_FindPeaks_distanceLabel = uilabel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_distanceLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_distanceLabel.WordWrap = 'on';
            app.play_FindPeaks_distanceLabel.FontSize = 10;
            app.play_FindPeaks_distanceLabel.Layout.Row = 5;
            app.play_FindPeaks_distanceLabel.Layout.Column = 2;
            app.play_FindPeaks_distanceLabel.Text = {'Distância entre'; 'picos (kHz):'};

            % Create play_FindPeaks_distance
            app.play_FindPeaks_distance = uispinner(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_distance.Step = 25;
            app.play_FindPeaks_distance.Limits = [0 Inf];
            app.play_FindPeaks_distance.RoundFractionalValues = 'on';
            app.play_FindPeaks_distance.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_distance.FontSize = 11;
            app.play_FindPeaks_distance.Layout.Row = 6;
            app.play_FindPeaks_distance.Layout.Column = 2;
            app.play_FindPeaks_distance.Value = 25;

            % Create play_FindPeaks_BWLabel
            app.play_FindPeaks_BWLabel = uilabel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_BWLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_BWLabel.WordWrap = 'on';
            app.play_FindPeaks_BWLabel.FontSize = 10;
            app.play_FindPeaks_BWLabel.Layout.Row = 5;
            app.play_FindPeaks_BWLabel.Layout.Column = 3;
            app.play_FindPeaks_BWLabel.Text = 'Largura ocupada (kHz):';

            % Create play_FindPeaks_BW
            app.play_FindPeaks_BW = uispinner(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_BW.Step = 10;
            app.play_FindPeaks_BW.Limits = [0 Inf];
            app.play_FindPeaks_BW.RoundFractionalValues = 'on';
            app.play_FindPeaks_BW.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_BW.FontSize = 11;
            app.play_FindPeaks_BW.Layout.Row = 6;
            app.play_FindPeaks_BW.Layout.Column = 3;
            app.play_FindPeaks_BW.Value = 10;

            % Create play_FindPeaks_MeanPanel
            app.play_FindPeaks_MeanPanel = uipanel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_MeanPanel.AutoResizeChildren = 'off';
            app.play_FindPeaks_MeanPanel.Title = 'MÉDIA';
            app.play_FindPeaks_MeanPanel.Layout.Row = 7;
            app.play_FindPeaks_MeanPanel.Layout.Column = 1;
            app.play_FindPeaks_MeanPanel.FontSize = 10;

            % Create play_FindPeaks_MeanGrid
            app.play_FindPeaks_MeanGrid = uigridlayout(app.play_FindPeaks_MeanPanel);
            app.play_FindPeaks_MeanGrid.ColumnWidth = {'1x'};
            app.play_FindPeaks_MeanGrid.RowHeight = {27, 22};
            app.play_FindPeaks_MeanGrid.RowSpacing = 5;
            app.play_FindPeaks_MeanGrid.Padding = [10 10 10 5];
            app.play_FindPeaks_MeanGrid.BackgroundColor = [1 1 1];

            % Create play_FindPeaks_Prominence1Label
            app.play_FindPeaks_Prominence1Label = uilabel(app.play_FindPeaks_MeanGrid);
            app.play_FindPeaks_Prominence1Label.VerticalAlignment = 'bottom';
            app.play_FindPeaks_Prominence1Label.WordWrap = 'on';
            app.play_FindPeaks_Prominence1Label.FontSize = 10;
            app.play_FindPeaks_Prominence1Label.Layout.Row = 1;
            app.play_FindPeaks_Prominence1Label.Layout.Column = 1;
            app.play_FindPeaks_Prominence1Label.Text = {'Proeminência'; '(dB):'};

            % Create play_FindPeaks_Prominence1
            app.play_FindPeaks_Prominence1 = uispinner(app.play_FindPeaks_MeanGrid);
            app.play_FindPeaks_Prominence1.Step = 10;
            app.play_FindPeaks_Prominence1.Limits = [1 Inf];
            app.play_FindPeaks_Prominence1.RoundFractionalValues = 'on';
            app.play_FindPeaks_Prominence1.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_Prominence1.FontSize = 11;
            app.play_FindPeaks_Prominence1.Layout.Row = 2;
            app.play_FindPeaks_Prominence1.Layout.Column = 1;
            app.play_FindPeaks_Prominence1.Value = 10;

            % Create play_FindPeaks_MaxHoldPanel
            app.play_FindPeaks_MaxHoldPanel = uipanel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_MaxHoldPanel.AutoResizeChildren = 'off';
            app.play_FindPeaks_MaxHoldPanel.Title = 'MAXHOLD';
            app.play_FindPeaks_MaxHoldPanel.Layout.Row = 7;
            app.play_FindPeaks_MaxHoldPanel.Layout.Column = [2 3];
            app.play_FindPeaks_MaxHoldPanel.FontSize = 10;

            % Create play_FindPeaks_MaxHoldGrid
            app.play_FindPeaks_MaxHoldGrid = uigridlayout(app.play_FindPeaks_MaxHoldPanel);
            app.play_FindPeaks_MaxHoldGrid.ColumnWidth = {60, 10, '1x', 5, '1x'};
            app.play_FindPeaks_MaxHoldGrid.RowHeight = {27, 22};
            app.play_FindPeaks_MaxHoldGrid.ColumnSpacing = 0;
            app.play_FindPeaks_MaxHoldGrid.RowSpacing = 5;
            app.play_FindPeaks_MaxHoldGrid.Padding = [10 10 8 5];
            app.play_FindPeaks_MaxHoldGrid.BackgroundColor = [1 1 1];

            % Create play_FindPeaks_Prominence2Label
            app.play_FindPeaks_Prominence2Label = uilabel(app.play_FindPeaks_MaxHoldGrid);
            app.play_FindPeaks_Prominence2Label.VerticalAlignment = 'bottom';
            app.play_FindPeaks_Prominence2Label.WordWrap = 'on';
            app.play_FindPeaks_Prominence2Label.FontSize = 10;
            app.play_FindPeaks_Prominence2Label.Layout.Row = 1;
            app.play_FindPeaks_Prominence2Label.Layout.Column = [1 5];
            app.play_FindPeaks_Prominence2Label.Text = {'Proeminência'; '(dB):'};

            % Create play_FindPeaks_Prominence2
            app.play_FindPeaks_Prominence2 = uispinner(app.play_FindPeaks_MaxHoldGrid);
            app.play_FindPeaks_Prominence2.Step = 10;
            app.play_FindPeaks_Prominence2.Limits = [1 Inf];
            app.play_FindPeaks_Prominence2.RoundFractionalValues = 'on';
            app.play_FindPeaks_Prominence2.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_Prominence2.FontSize = 11;
            app.play_FindPeaks_Prominence2.Layout.Row = 2;
            app.play_FindPeaks_Prominence2.Layout.Column = 1;
            app.play_FindPeaks_Prominence2.Value = 30;

            % Create play_FindPeaks_OCCLabel
            app.play_FindPeaks_OCCLabel = uilabel(app.play_FindPeaks_MaxHoldGrid);
            app.play_FindPeaks_OCCLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_OCCLabel.FontSize = 10;
            app.play_FindPeaks_OCCLabel.Layout.Row = 1;
            app.play_FindPeaks_OCCLabel.Layout.Column = [3 5];
            app.play_FindPeaks_OCCLabel.Interpreter = 'html';
            app.play_FindPeaks_OCCLabel.Text = {'Ocupação (%):'; '<p style="line-height:10px; font-size:9px; color:gray;">(Mínima | Máxima)</p>'};

            % Create play_FindPeaks_meanOCC
            app.play_FindPeaks_meanOCC = uispinner(app.play_FindPeaks_MaxHoldGrid);
            app.play_FindPeaks_meanOCC.Step = 10;
            app.play_FindPeaks_meanOCC.Limits = [0 100];
            app.play_FindPeaks_meanOCC.RoundFractionalValues = 'on';
            app.play_FindPeaks_meanOCC.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_meanOCC.ValueChangedFcn = createCallbackFcn(app, @play_FindPeaks_OCCValueChanged, true);
            app.play_FindPeaks_meanOCC.FontSize = 11;
            app.play_FindPeaks_meanOCC.Layout.Row = 2;
            app.play_FindPeaks_meanOCC.Layout.Column = 3;
            app.play_FindPeaks_meanOCC.Value = 1;

            % Create play_FindPeaks_maxOCC
            app.play_FindPeaks_maxOCC = uispinner(app.play_FindPeaks_MaxHoldGrid);
            app.play_FindPeaks_maxOCC.Step = 10;
            app.play_FindPeaks_maxOCC.Limits = [0 100];
            app.play_FindPeaks_maxOCC.RoundFractionalValues = 'on';
            app.play_FindPeaks_maxOCC.ValueDisplayFormat = '%.0f';
            app.play_FindPeaks_maxOCC.ValueChangedFcn = createCallbackFcn(app, @play_FindPeaks_OCCValueChanged, true);
            app.play_FindPeaks_maxOCC.FontSize = 11;
            app.play_FindPeaks_maxOCC.Layout.Row = 2;
            app.play_FindPeaks_maxOCC.Layout.Column = 5;
            app.play_FindPeaks_maxOCC.Value = 10;

            % Create play_FindPeaks_ClassLabel
            app.play_FindPeaks_ClassLabel = uilabel(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_ClassLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_ClassLabel.FontSize = 10;
            app.play_FindPeaks_ClassLabel.Visible = 'off';
            app.play_FindPeaks_ClassLabel.Layout.Row = 5;
            app.play_FindPeaks_ClassLabel.Layout.Column = 1;
            app.play_FindPeaks_ClassLabel.Text = {'Classe de '; 'emissão:'};

            % Create play_FindPeaks_Class
            app.play_FindPeaks_Class = uidropdown(app.play_FindPeaks_ParametersGrid);
            app.play_FindPeaks_Class.Items = {};
            app.play_FindPeaks_Class.ValueChangedFcn = createCallbackFcn(app, @play_FindPeaks_ClassValueChanged, true);
            app.play_FindPeaks_Class.Visible = 'off';
            app.play_FindPeaks_Class.FontSize = 11;
            app.play_FindPeaks_Class.BackgroundColor = [1 1 1];
            app.play_FindPeaks_Class.Layout.Row = 6;
            app.play_FindPeaks_Class.Layout.Column = 1;
            app.play_FindPeaks_Class.Value = {};

            % Create play_FindPeaks_add
            app.play_FindPeaks_add = uiimage(app.play_ControlsTab3Info);
            app.play_FindPeaks_add.ScaleMethod = 'scaledown';
            app.play_FindPeaks_add.ImageClickedFcn = createCallbackFcn(app, @play_FindPeaks_addEmission, true);
            app.play_FindPeaks_add.Layout.Row = 5;
            app.play_FindPeaks_add.Layout.Column = 4;
            app.play_FindPeaks_add.HorizontalAlignment = 'right';
            app.play_FindPeaks_add.VerticalAlignment = 'bottom';
            app.play_FindPeaks_add.ImageSource = fullfile(pathToMLAPP, 'Icons', 'addSymbol_32.png');

            % Create play_FindPeaks_Tree
            app.play_FindPeaks_Tree = uitree(app.play_ControlsTab3Info);
            app.play_FindPeaks_Tree.Multiselect = 'on';
            app.play_FindPeaks_Tree.SelectionChangedFcn = createCallbackFcn(app, @play_FindPeaks_TreeSelectionChanged, true);
            app.play_FindPeaks_Tree.FontSize = 10;
            app.play_FindPeaks_Tree.Layout.Row = 6;
            app.play_FindPeaks_Tree.Layout.Column = [1 4];

            % Create play_FindPeaks_PeakCFLabel
            app.play_FindPeaks_PeakCFLabel = uilabel(app.play_ControlsTab3Info);
            app.play_FindPeaks_PeakCFLabel.FontSize = 11;
            app.play_FindPeaks_PeakCFLabel.Layout.Row = 7;
            app.play_FindPeaks_PeakCFLabel.Layout.Column = [1 2];
            app.play_FindPeaks_PeakCFLabel.Text = 'Frequência central (MHz):';

            % Create play_FindPeaks_PeakCF
            app.play_FindPeaks_PeakCF = uieditfield(app.play_ControlsTab3Info, 'numeric');
            app.play_FindPeaks_PeakCF.ValueDisplayFormat = '%.3f';
            app.play_FindPeaks_PeakCF.ValueChangedFcn = createCallbackFcn(app, @play_FindPeaks_editEmission, true);
            app.play_FindPeaks_PeakCF.FontSize = 11;
            app.play_FindPeaks_PeakCF.Enable = 'off';
            app.play_FindPeaks_PeakCF.Layout.Row = 7;
            app.play_FindPeaks_PeakCF.Layout.Column = [3 4];

            % Create play_FindPeaks_PeakBWLabel
            app.play_FindPeaks_PeakBWLabel = uilabel(app.play_ControlsTab3Info);
            app.play_FindPeaks_PeakBWLabel.FontSize = 11;
            app.play_FindPeaks_PeakBWLabel.Layout.Row = 8;
            app.play_FindPeaks_PeakBWLabel.Layout.Column = [1 2];
            app.play_FindPeaks_PeakBWLabel.Text = 'Largura ocupada (kHz):';

            % Create play_FindPeaks_PeakBW
            app.play_FindPeaks_PeakBW = uieditfield(app.play_ControlsTab3Info, 'numeric');
            app.play_FindPeaks_PeakBW.ValueDisplayFormat = '%.3f';
            app.play_FindPeaks_PeakBW.ValueChangedFcn = createCallbackFcn(app, @play_FindPeaks_editEmission, true);
            app.play_FindPeaks_PeakBW.FontSize = 11;
            app.play_FindPeaks_PeakBW.Enable = 'off';
            app.play_FindPeaks_PeakBW.Layout.Row = 8;
            app.play_FindPeaks_PeakBW.Layout.Column = [3 4];

            % Create play_FindPeaks_DescriptionLabel
            app.play_FindPeaks_DescriptionLabel = uilabel(app.play_ControlsTab3Info);
            app.play_FindPeaks_DescriptionLabel.VerticalAlignment = 'top';
            app.play_FindPeaks_DescriptionLabel.WordWrap = 'on';
            app.play_FindPeaks_DescriptionLabel.FontSize = 11;
            app.play_FindPeaks_DescriptionLabel.Layout.Row = 9;
            app.play_FindPeaks_DescriptionLabel.Layout.Column = 1;
            app.play_FindPeaks_DescriptionLabel.Text = {'Informações'; 'complementares:'};

            % Create play_FindPeaks_Description
            app.play_FindPeaks_Description = uitextarea(app.play_ControlsTab3Info);
            app.play_FindPeaks_Description.ValueChangedFcn = createCallbackFcn(app, @play_FindPeaks_editEmission, true);
            app.play_FindPeaks_Description.FontSize = 11;
            app.play_FindPeaks_Description.Enable = 'off';
            app.play_FindPeaks_Description.Layout.Row = 9;
            app.play_FindPeaks_Description.Layout.Column = [2 4];

            % Create play_FindPeaks_ExternalFilePanel
            app.play_FindPeaks_ExternalFilePanel = uipanel(app.play_ControlsTab3Info);
            app.play_FindPeaks_ExternalFilePanel.Layout.Row = 4;
            app.play_FindPeaks_ExternalFilePanel.Layout.Column = [1 4];

            % Create play_FindPeaks_ExternalFileGrid
            app.play_FindPeaks_ExternalFileGrid = uigridlayout(app.play_FindPeaks_ExternalFilePanel);
            app.play_FindPeaks_ExternalFileGrid.ColumnWidth = {'1x'};
            app.play_FindPeaks_ExternalFileGrid.RowHeight = {17, 22, '1x'};
            app.play_FindPeaks_ExternalFileGrid.RowSpacing = 5;
            app.play_FindPeaks_ExternalFileGrid.Padding = [10 10 10 5];
            app.play_FindPeaks_ExternalFileGrid.BackgroundColor = [1 1 1];

            % Create play_FindPeaks_ExternalFileLabel
            app.play_FindPeaks_ExternalFileLabel = uilabel(app.play_FindPeaks_ExternalFileGrid);
            app.play_FindPeaks_ExternalFileLabel.VerticalAlignment = 'bottom';
            app.play_FindPeaks_ExternalFileLabel.FontSize = 10;
            app.play_FindPeaks_ExternalFileLabel.Layout.Row = 1;
            app.play_FindPeaks_ExternalFileLabel.Layout.Column = 1;
            app.play_FindPeaks_ExternalFileLabel.Text = 'Formato:';

            % Create play_FindPeaks_ExternalFile
            app.play_FindPeaks_ExternalFile = uidropdown(app.play_FindPeaks_ExternalFileGrid);
            app.play_FindPeaks_ExternalFile.Items = {'Generic (csv, txt, json, xls, xlsx)', 'Romes (csv)'};
            app.play_FindPeaks_ExternalFile.FontSize = 11;
            app.play_FindPeaks_ExternalFile.BackgroundColor = [1 1 1];
            app.play_FindPeaks_ExternalFile.Layout.Row = 2;
            app.play_FindPeaks_ExternalFile.Layout.Column = 1;
            app.play_FindPeaks_ExternalFile.Value = 'Generic (csv, txt, json, xls, xlsx)';

            % Create play_FindPeaks_FileTemplate
            app.play_FindPeaks_FileTemplate = uihyperlink(app.play_FindPeaks_ExternalFileGrid);
            app.play_FindPeaks_FileTemplate.HyperlinkClickedFcn = createCallbackFcn(app, @play_DownloadFileTemplate, true);
            app.play_FindPeaks_FileTemplate.VerticalAlignment = 'top';
            app.play_FindPeaks_FileTemplate.FontSize = 10;
            app.play_FindPeaks_FileTemplate.Layout.Row = 3;
            app.play_FindPeaks_FileTemplate.Layout.Column = 1;
            app.play_FindPeaks_FileTemplate.Text = 'Download modelo do arquivo';

            % Create report_ControlsTab1Grid
            app.report_ControlsTab1Grid = uigridlayout(app.play_ControlsGrid);
            app.report_ControlsTab1Grid.ColumnWidth = {18, '1x', 16};
            app.report_ControlsTab1Grid.RowHeight = {'1x'};
            app.report_ControlsTab1Grid.ColumnSpacing = 5;
            app.report_ControlsTab1Grid.RowSpacing = 5;
            app.report_ControlsTab1Grid.Padding = [2 2 2 2];
            app.report_ControlsTab1Grid.Tag = 'COLORLOCKED';
            app.report_ControlsTab1Grid.Layout.Row = 7;
            app.report_ControlsTab1Grid.Layout.Column = 1;
            app.report_ControlsTab1Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create report_ControlsTab1Label
            app.report_ControlsTab1Label = uilabel(app.report_ControlsTab1Grid);
            app.report_ControlsTab1Label.FontSize = 11;
            app.report_ControlsTab1Label.Layout.Row = 1;
            app.report_ControlsTab1Label.Layout.Column = 2;
            app.report_ControlsTab1Label.Text = 'PROJETO';

            % Create report_ProjectWarnIcon
            app.report_ProjectWarnIcon = uiimage(app.report_ControlsTab1Grid);
            app.report_ProjectWarnIcon.Visible = 'off';
            app.report_ProjectWarnIcon.Tooltip = {'Pendente salvar projeto'};
            app.report_ProjectWarnIcon.Layout.Row = 1;
            app.report_ProjectWarnIcon.Layout.Column = 3;
            app.report_ProjectWarnIcon.VerticalAlignment = 'bottom';
            app.report_ProjectWarnIcon.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Warn_18.png');

            % Create report_ControlsTab1Image
            app.report_ControlsTab1Image = uiimage(app.report_ControlsTab1Grid);
            app.report_ControlsTab1Image.ImageClickedFcn = createCallbackFcn(app, @play_TabGroupVisibility, true);
            app.report_ControlsTab1Image.Layout.Row = 1;
            app.report_ControlsTab1Image.Layout.Column = [1 3];
            app.report_ControlsTab1Image.HorizontalAlignment = 'left';
            app.report_ControlsTab1Image.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Report_32.png');

            % Create report_ControlsTab1Info
            app.report_ControlsTab1Info = uigridlayout(app.play_ControlsGrid);
            app.report_ControlsTab1Info.ColumnWidth = {110, '1x', 16, 16, 16};
            app.report_ControlsTab1Info.RowHeight = {22, 44, 22, 224, 9, 8, '1x', 32};
            app.report_ControlsTab1Info.ColumnSpacing = 5;
            app.report_ControlsTab1Info.RowSpacing = 5;
            app.report_ControlsTab1Info.Padding = [0 0 0 0];
            app.report_ControlsTab1Info.Layout.Row = 8;
            app.report_ControlsTab1Info.Layout.Column = 1;
            app.report_ControlsTab1Info.BackgroundColor = [1 1 1];

            % Create report_ThreadAlgorithmsLabel
            app.report_ThreadAlgorithmsLabel = uilabel(app.report_ControlsTab1Info);
            app.report_ThreadAlgorithmsLabel.VerticalAlignment = 'bottom';
            app.report_ThreadAlgorithmsLabel.FontSize = 10;
            app.report_ThreadAlgorithmsLabel.Layout.Row = [5 6];
            app.report_ThreadAlgorithmsLabel.Layout.Column = [1 2];
            app.report_ThreadAlgorithmsLabel.Text = 'FLUXOS A PROCESSAR';

            % Create report_ProjectNameLabel
            app.report_ProjectNameLabel = uilabel(app.report_ControlsTab1Info);
            app.report_ProjectNameLabel.VerticalAlignment = 'bottom';
            app.report_ProjectNameLabel.FontSize = 10;
            app.report_ProjectNameLabel.Layout.Row = 1;
            app.report_ProjectNameLabel.Layout.Column = 1;
            app.report_ProjectNameLabel.Text = 'ARQUIVO';

            % Create report_ProjectName
            app.report_ProjectName = uitextarea(app.report_ControlsTab1Info);
            app.report_ProjectName.Tag = 'file';
            app.report_ProjectName.Editable = 'off';
            app.report_ProjectName.FontSize = 11;
            app.report_ProjectName.Layout.Row = 2;
            app.report_ProjectName.Layout.Column = [1 5];

            % Create report_ProjectNew
            app.report_ProjectNew = uiimage(app.report_ControlsTab1Info);
            app.report_ProjectNew.ImageClickedFcn = createCallbackFcn(app, @report_ProjectToolbarImageClicked, true);
            app.report_ProjectNew.Tooltip = {'Cria novo projeto'};
            app.report_ProjectNew.Layout.Row = 1;
            app.report_ProjectNew.Layout.Column = 3;
            app.report_ProjectNew.VerticalAlignment = 'bottom';
            app.report_ProjectNew.ImageSource = fullfile(pathToMLAPP, 'Icons', 'addFiles_32.png');

            % Create report_ProjectOpen
            app.report_ProjectOpen = uiimage(app.report_ControlsTab1Info);
            app.report_ProjectOpen.ImageClickedFcn = createCallbackFcn(app, @report_ProjectToolbarImageClicked, true);
            app.report_ProjectOpen.Tooltip = {'Abre projeto'};
            app.report_ProjectOpen.Layout.Row = 1;
            app.report_ProjectOpen.Layout.Column = 4;
            app.report_ProjectOpen.VerticalAlignment = 'bottom';
            app.report_ProjectOpen.ImageSource = fullfile(pathToMLAPP, 'Icons', 'OpenFile_36x36.png');

            % Create report_ProjectSave
            app.report_ProjectSave = uiimage(app.report_ControlsTab1Info);
            app.report_ProjectSave.ImageClickedFcn = createCallbackFcn(app, @report_ProjectToolbarImageClicked, true);
            app.report_ProjectSave.Tooltip = {'Salva projeto'};
            app.report_ProjectSave.Layout.Row = 1;
            app.report_ProjectSave.Layout.Column = 5;
            app.report_ProjectSave.VerticalAlignment = 'bottom';
            app.report_ProjectSave.ImageSource = fullfile(pathToMLAPP, 'Icons', 'saveFile_32.png');

            % Create report_DocumentPanelLabel
            app.report_DocumentPanelLabel = uilabel(app.report_ControlsTab1Info);
            app.report_DocumentPanelLabel.VerticalAlignment = 'bottom';
            app.report_DocumentPanelLabel.FontSize = 10;
            app.report_DocumentPanelLabel.Layout.Row = 3;
            app.report_DocumentPanelLabel.Layout.Column = [1 2];
            app.report_DocumentPanelLabel.Text = 'ATIVIDADE DE INSPEÇÃO';

            % Create report_DocumentPanel
            app.report_DocumentPanel = uipanel(app.report_ControlsTab1Info);
            app.report_DocumentPanel.AutoResizeChildren = 'off';
            app.report_DocumentPanel.Layout.Row = 4;
            app.report_DocumentPanel.Layout.Column = [1 5];

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.report_DocumentPanel);
            app.GridLayout4.ColumnWidth = {90, '1x', 64, 16};
            app.GridLayout4.RowHeight = {17, 22, 17, 22, 4, 8, '1x'};
            app.GridLayout4.RowSpacing = 5;
            app.GridLayout4.Padding = [10 10 10 5];
            app.GridLayout4.BackgroundColor = [1 1 1];

            % Create report_ModelNameLabel
            app.report_ModelNameLabel = uilabel(app.GridLayout4);
            app.report_ModelNameLabel.VerticalAlignment = 'bottom';
            app.report_ModelNameLabel.FontSize = 10;
            app.report_ModelNameLabel.Layout.Row = 3;
            app.report_ModelNameLabel.Layout.Column = [1 2];
            app.report_ModelNameLabel.Text = 'Modelo do relatório:';

            % Create report_ModelName
            app.report_ModelName = uidropdown(app.GridLayout4);
            app.report_ModelName.Items = {};
            app.report_ModelName.ValueChangedFcn = createCallbackFcn(app, @report_ModelNameValueChanged, true);
            app.report_ModelName.Tag = 'documentModel';
            app.report_ModelName.FontSize = 11;
            app.report_ModelName.BackgroundColor = [1 1 1];
            app.report_ModelName.Layout.Row = 4;
            app.report_ModelName.Layout.Column = [1 2];
            app.report_ModelName.Value = {};

            % Create report_VersionLabel
            app.report_VersionLabel = uilabel(app.GridLayout4);
            app.report_VersionLabel.VerticalAlignment = 'bottom';
            app.report_VersionLabel.FontSize = 10;
            app.report_VersionLabel.Layout.Row = 3;
            app.report_VersionLabel.Layout.Column = 3;
            app.report_VersionLabel.Text = 'Versão:';

            % Create report_Version
            app.report_Version = uidropdown(app.GridLayout4);
            app.report_Version.Items = {'Preliminar', 'Definitiva'};
            app.report_Version.FontSize = 11;
            app.report_Version.BackgroundColor = [1 1 1];
            app.report_Version.Layout.Row = 4;
            app.report_Version.Layout.Column = [3 4];
            app.report_Version.Value = 'Preliminar';

            % Create report_AddProjectAttachment
            app.report_AddProjectAttachment = uiimage(app.GridLayout4);
            app.report_AddProjectAttachment.ImageClickedFcn = createCallbackFcn(app, @report_ExternalFilesMenuSelected, true);
            app.report_AddProjectAttachment.Layout.Row = 6;
            app.report_AddProjectAttachment.Layout.Column = 4;
            app.report_AddProjectAttachment.ImageSource = fullfile(pathToMLAPP, 'Icons', 'addSymbol_32.png');

            % Create report_ExternalFilesLabel
            app.report_ExternalFilesLabel = uilabel(app.GridLayout4);
            app.report_ExternalFilesLabel.VerticalAlignment = 'bottom';
            app.report_ExternalFilesLabel.WordWrap = 'on';
            app.report_ExternalFilesLabel.FontSize = 10;
            app.report_ExternalFilesLabel.Layout.Row = [5 6];
            app.report_ExternalFilesLabel.Layout.Column = [1 2];
            app.report_ExternalFilesLabel.Text = 'Arquivos externos:';

            % Create report_ExternalFiles
            app.report_ExternalFiles = uitable(app.GridLayout4);
            app.report_ExternalFiles.ColumnName = {'ID'; 'TAG'; 'ARQUIVO'};
            app.report_ExternalFiles.ColumnWidth = {40, 90, 'auto'};
            app.report_ExternalFiles.RowName = {};
            app.report_ExternalFiles.Tag = 'externalFiles';
            app.report_ExternalFiles.Layout.Row = 7;
            app.report_ExternalFiles.Layout.Column = [1 4];
            app.report_ExternalFiles.FontSize = 10;

            % Create report_Issue
            app.report_Issue = uieditfield(app.GridLayout4, 'numeric');
            app.report_Issue.Limits = [-1 Inf];
            app.report_Issue.RoundFractionalValues = 'on';
            app.report_Issue.ValueDisplayFormat = '%d';
            app.report_Issue.ValueChangedFcn = createCallbackFcn(app, @report_SaveWarn, true);
            app.report_Issue.Tag = 'issue';
            app.report_Issue.FontSize = 11;
            app.report_Issue.FontColor = [0.149 0.149 0.149];
            app.report_Issue.Layout.Row = 2;
            app.report_Issue.Layout.Column = 1;
            app.report_Issue.Value = -1;

            % Create report_IssueLabel
            app.report_IssueLabel = uilabel(app.GridLayout4);
            app.report_IssueLabel.VerticalAlignment = 'bottom';
            app.report_IssueLabel.WordWrap = 'on';
            app.report_IssueLabel.FontSize = 10;
            app.report_IssueLabel.FontColor = [0.149 0.149 0.149];
            app.report_IssueLabel.Layout.Row = 1;
            app.report_IssueLabel.Layout.Column = 1;
            app.report_IssueLabel.Text = 'Inspeção:';

            % Create report_TreeAddImage
            app.report_TreeAddImage = uiimage(app.report_ControlsTab1Info);
            app.report_TreeAddImage.ImageClickedFcn = createCallbackFcn(app, @report_TreeAddImagePushed, true);
            app.report_TreeAddImage.Tooltip = {''};
            app.report_TreeAddImage.Layout.Row = 6;
            app.report_TreeAddImage.Layout.Column = 5;
            app.report_TreeAddImage.VerticalAlignment = 'bottom';
            app.report_TreeAddImage.ImageSource = fullfile(pathToMLAPP, 'Icons', 'addSymbol_32.png');

            % Create report_Tree
            app.report_Tree = uitree(app.report_ControlsTab1Info, 'checkbox');
            app.report_Tree.FontSize = 10;
            app.report_Tree.Layout.Row = [7 8];
            app.report_Tree.Layout.Column = [1 5];

            % Create report_ControlsTab2Grid
            app.report_ControlsTab2Grid = uigridlayout(app.play_ControlsGrid);
            app.report_ControlsTab2Grid.ColumnWidth = {18, '1x'};
            app.report_ControlsTab2Grid.RowHeight = {'1x'};
            app.report_ControlsTab2Grid.ColumnSpacing = 5;
            app.report_ControlsTab2Grid.RowSpacing = 5;
            app.report_ControlsTab2Grid.Padding = [2 2 2 2];
            app.report_ControlsTab2Grid.Tag = 'COLORLOCKED';
            app.report_ControlsTab2Grid.Layout.Row = 9;
            app.report_ControlsTab2Grid.Layout.Column = 1;
            app.report_ControlsTab2Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create report_ControlsTab2Label
            app.report_ControlsTab2Label = uilabel(app.report_ControlsTab2Grid);
            app.report_ControlsTab2Label.FontSize = 11;
            app.report_ControlsTab2Label.Layout.Row = 1;
            app.report_ControlsTab2Label.Layout.Column = 2;
            app.report_ControlsTab2Label.Text = 'API FISCALIZA';

            % Create report_ControlsTab2Image
            app.report_ControlsTab2Image = uiimage(app.report_ControlsTab2Grid);
            app.report_ControlsTab2Image.ImageClickedFcn = createCallbackFcn(app, @play_TabGroupVisibility, true);
            app.report_ControlsTab2Image.Layout.Row = 1;
            app.report_ControlsTab2Image.Layout.Column = [1 2];
            app.report_ControlsTab2Image.HorizontalAlignment = 'left';
            app.report_ControlsTab2Image.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Redmine_18.png');

            % Create report_ControlsTab2Info
            app.report_ControlsTab2Info = uigridlayout(app.play_ControlsGrid);
            app.report_ControlsTab2Info.ColumnWidth = {'1x', 16};
            app.report_ControlsTab2Info.RowHeight = {22, '1x'};
            app.report_ControlsTab2Info.ColumnSpacing = 5;
            app.report_ControlsTab2Info.RowSpacing = 5;
            app.report_ControlsTab2Info.Padding = [0 0 0 0];
            app.report_ControlsTab2Info.Layout.Row = 10;
            app.report_ControlsTab2Info.Layout.Column = 1;
            app.report_ControlsTab2Info.BackgroundColor = [1 1 1];

            % Create report_Fiscaliza_PanelLabel
            app.report_Fiscaliza_PanelLabel = uilabel(app.report_ControlsTab2Info);
            app.report_Fiscaliza_PanelLabel.VerticalAlignment = 'bottom';
            app.report_Fiscaliza_PanelLabel.FontSize = 10;
            app.report_Fiscaliza_PanelLabel.Layout.Row = 1;
            app.report_Fiscaliza_PanelLabel.Layout.Column = 1;
            app.report_Fiscaliza_PanelLabel.Text = 'ASPECTOS GERAIS';

            % Create report_FiscalizaRefresh
            app.report_FiscalizaRefresh = uiimage(app.report_ControlsTab2Info);
            app.report_FiscalizaRefresh.ImageClickedFcn = createCallbackFcn(app, @report_FiscalizaStaticButtonPushed, true);
            app.report_FiscalizaRefresh.Tooltip = {'Atualiza informações da inspeção'};
            app.report_FiscalizaRefresh.Layout.Row = 1;
            app.report_FiscalizaRefresh.Layout.Column = 2;
            app.report_FiscalizaRefresh.VerticalAlignment = 'bottom';
            app.report_FiscalizaRefresh.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Refresh_18.png');

            % Create report_FiscalizaPanel
            app.report_FiscalizaPanel = uipanel(app.report_ControlsTab2Info);
            app.report_FiscalizaPanel.AutoResizeChildren = 'off';
            app.report_FiscalizaPanel.Layout.Row = 2;
            app.report_FiscalizaPanel.Layout.Column = [1 2];

            % Create report_FiscalizaGrid
            app.report_FiscalizaGrid = uigridlayout(app.report_FiscalizaPanel);
            app.report_FiscalizaGrid.ColumnWidth = {'1x'};
            app.report_FiscalizaGrid.RowHeight = {'1x'};
            app.report_FiscalizaGrid.BackgroundColor = [1 1 1];

            % Create report_FiscalizaIcon
            app.report_FiscalizaIcon = uiimage(app.report_FiscalizaGrid);
            app.report_FiscalizaIcon.Tag = 'FiscalizaPlaceHolder';
            app.report_FiscalizaIcon.Enable = 'off';
            app.report_FiscalizaIcon.Layout.Row = 1;
            app.report_FiscalizaIcon.Layout.Column = 1;
            app.report_FiscalizaIcon.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Redmine_512.png');

            % Create misc_ControlsTab1Grid
            app.misc_ControlsTab1Grid = uigridlayout(app.play_ControlsGrid);
            app.misc_ControlsTab1Grid.ColumnWidth = {18, '1x'};
            app.misc_ControlsTab1Grid.RowHeight = {'1x'};
            app.misc_ControlsTab1Grid.ColumnSpacing = 5;
            app.misc_ControlsTab1Grid.RowSpacing = 5;
            app.misc_ControlsTab1Grid.Padding = [2 2 2 2];
            app.misc_ControlsTab1Grid.Tag = 'COLORLOCKED';
            app.misc_ControlsTab1Grid.Layout.Row = 11;
            app.misc_ControlsTab1Grid.Layout.Column = 1;
            app.misc_ControlsTab1Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create misc_ControlsTab1Label
            app.misc_ControlsTab1Label = uilabel(app.misc_ControlsTab1Grid);
            app.misc_ControlsTab1Label.FontSize = 11;
            app.misc_ControlsTab1Label.Layout.Row = 1;
            app.misc_ControlsTab1Label.Layout.Column = 2;
            app.misc_ControlsTab1Label.Text = 'MISCELÂNEAS';

            % Create misc_ControlsTab1Image
            app.misc_ControlsTab1Image = uiimage(app.misc_ControlsTab1Grid);
            app.misc_ControlsTab1Image.Layout.Row = 1;
            app.misc_ControlsTab1Image.Layout.Column = [1 2];
            app.misc_ControlsTab1Image.HorizontalAlignment = 'left';
            app.misc_ControlsTab1Image.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Misc_32.png');

            % Create misc_ControlsTab1Info
            app.misc_ControlsTab1Info = uigridlayout(app.play_ControlsGrid);
            app.misc_ControlsTab1Info.ColumnWidth = {'1x'};
            app.misc_ControlsTab1Info.RowHeight = {22, '1x'};
            app.misc_ControlsTab1Info.ColumnSpacing = 5;
            app.misc_ControlsTab1Info.RowSpacing = 5;
            app.misc_ControlsTab1Info.Padding = [0 0 0 0];
            app.misc_ControlsTab1Info.Layout.Row = 12;
            app.misc_ControlsTab1Info.Layout.Column = 1;
            app.misc_ControlsTab1Info.BackgroundColor = [1 1 1];

            % Create misc_Label1
            app.misc_Label1 = uilabel(app.misc_ControlsTab1Info);
            app.misc_Label1.VerticalAlignment = 'bottom';
            app.misc_Label1.FontSize = 10;
            app.misc_Label1.Layout.Row = 1;
            app.misc_Label1.Layout.Column = 1;
            app.misc_Label1.Text = 'OPERAÇÃO';

            % Create misc_Panel1
            app.misc_Panel1 = uipanel(app.misc_ControlsTab1Info);
            app.misc_Panel1.AutoResizeChildren = 'off';
            app.misc_Panel1.Layout.Row = 2;
            app.misc_Panel1.Layout.Column = 1;

            % Create misc_Grid1
            app.misc_Grid1 = uigridlayout(app.misc_Panel1);
            app.misc_Grid1.ColumnWidth = {3, 28, 3, 3, 28, 3, 3, 28, 3, 3, 28, 3, '1x', 3, 28, 3, 3, 28, 3};
            app.misc_Grid1.RowHeight = {1, 34, 26, 1, 34, 26, '1x', 34, 26};
            app.misc_Grid1.ColumnSpacing = 5;
            app.misc_Grid1.RowSpacing = 5;
            app.misc_Grid1.Padding = [10 10 10 5];
            app.misc_Grid1.BackgroundColor = [1 1 1];

            % Create misc_Save
            app.misc_Save = uibutton(app.misc_Grid1, 'push');
            app.misc_Save.ButtonPushedFcn = createCallbackFcn(app, @misc_OperationsCallbacks, true);
            app.misc_Save.Icon = fullfile(pathToMLAPP, 'Icons', 'saveFile_32.png');
            app.misc_Save.IconAlignment = 'top';
            app.misc_Save.BackgroundColor = [1 1 1];
            app.misc_Save.FontSize = 10;
            app.misc_Save.Tooltip = {''};
            app.misc_Save.Layout.Row = 2;
            app.misc_Save.Layout.Column = 2;
            app.misc_Save.Text = '';

            % Create misc_SaveLabel
            app.misc_SaveLabel = uilabel(app.misc_Grid1);
            app.misc_SaveLabel.HorizontalAlignment = 'center';
            app.misc_SaveLabel.WordWrap = 'on';
            app.misc_SaveLabel.FontSize = 10;
            app.misc_SaveLabel.Layout.Row = 3;
            app.misc_SaveLabel.Layout.Column = [1 3];
            app.misc_SaveLabel.Text = {'Salvar'; 'fluxo(s)'};

            % Create misc_Duplicate
            app.misc_Duplicate = uibutton(app.misc_Grid1, 'push');
            app.misc_Duplicate.ButtonPushedFcn = createCallbackFcn(app, @misc_OperationsCallbacks, true);
            app.misc_Duplicate.Icon = fullfile(pathToMLAPP, 'Icons', 'duplicateFile_32.png');
            app.misc_Duplicate.IconAlignment = 'top';
            app.misc_Duplicate.BackgroundColor = [1 1 1];
            app.misc_Duplicate.FontSize = 10;
            app.misc_Duplicate.Tooltip = {''};
            app.misc_Duplicate.Layout.Row = 2;
            app.misc_Duplicate.Layout.Column = 5;
            app.misc_Duplicate.Text = '';

            % Create misc_DuplicateLabel
            app.misc_DuplicateLabel = uilabel(app.misc_Grid1);
            app.misc_DuplicateLabel.HorizontalAlignment = 'center';
            app.misc_DuplicateLabel.WordWrap = 'on';
            app.misc_DuplicateLabel.FontSize = 10;
            app.misc_DuplicateLabel.Layout.Row = 3;
            app.misc_DuplicateLabel.Layout.Column = [4 6];
            app.misc_DuplicateLabel.Text = {'Duplicar'; 'fluxo(s)'};

            % Create misc_Merge
            app.misc_Merge = uibutton(app.misc_Grid1, 'push');
            app.misc_Merge.ButtonPushedFcn = createCallbackFcn(app, @misc_OperationsCallbacks, true);
            app.misc_Merge.Icon = fullfile(pathToMLAPP, 'Icons', 'Merge_32.png');
            app.misc_Merge.IconAlignment = 'top';
            app.misc_Merge.BackgroundColor = [1 1 1];
            app.misc_Merge.FontSize = 10;
            app.misc_Merge.Tooltip = {''};
            app.misc_Merge.Layout.Row = 2;
            app.misc_Merge.Layout.Column = 8;
            app.misc_Merge.Text = '';

            % Create misc_MergeLabel
            app.misc_MergeLabel = uilabel(app.misc_Grid1);
            app.misc_MergeLabel.HorizontalAlignment = 'center';
            app.misc_MergeLabel.WordWrap = 'on';
            app.misc_MergeLabel.FontSize = 10;
            app.misc_MergeLabel.Layout.Row = 3;
            app.misc_MergeLabel.Layout.Column = [7 9];
            app.misc_MergeLabel.Text = {'Mesclar'; 'fluxos'};

            % Create misc_Del
            app.misc_Del = uibutton(app.misc_Grid1, 'push');
            app.misc_Del.ButtonPushedFcn = createCallbackFcn(app, @misc_OperationsCallbacks, true);
            app.misc_Del.Icon = fullfile(pathToMLAPP, 'Icons', 'Delete_32Red.png');
            app.misc_Del.IconAlignment = 'top';
            app.misc_Del.BackgroundColor = [1 1 1];
            app.misc_Del.FontSize = 10;
            app.misc_Del.Tooltip = {''};
            app.misc_Del.Layout.Row = 2;
            app.misc_Del.Layout.Column = 11;
            app.misc_Del.Text = '';

            % Create misc_DelLabel
            app.misc_DelLabel = uilabel(app.misc_Grid1);
            app.misc_DelLabel.HorizontalAlignment = 'center';
            app.misc_DelLabel.WordWrap = 'on';
            app.misc_DelLabel.FontSize = 10;
            app.misc_DelLabel.Layout.Row = 3;
            app.misc_DelLabel.Layout.Column = [10 12];
            app.misc_DelLabel.Text = {'Excluir'; 'fluxo(s)'};

            % Create misc_Serarator
            app.misc_Serarator = uiimage(app.misc_Grid1);
            app.misc_Serarator.ScaleMethod = 'stretch';
            app.misc_Serarator.Enable = 'off';
            app.misc_Serarator.Layout.Row = [1 3];
            app.misc_Serarator.Layout.Column = 13;
            app.misc_Serarator.ImageSource = fullfile(pathToMLAPP, 'Icons', 'LineV.png');

            % Create misc_Export
            app.misc_Export = uibutton(app.misc_Grid1, 'push');
            app.misc_Export.ButtonPushedFcn = createCallbackFcn(app, @misc_OperationsCallbacks, true);
            app.misc_Export.Icon = fullfile(pathToMLAPP, 'Icons', 'Export_16.png');
            app.misc_Export.IconAlignment = 'top';
            app.misc_Export.BackgroundColor = [1 1 1];
            app.misc_Export.FontSize = 10;
            app.misc_Export.Tooltip = {''};
            app.misc_Export.Layout.Row = 2;
            app.misc_Export.Layout.Column = 15;
            app.misc_Export.Text = '';

            % Create misc_ExportLabel
            app.misc_ExportLabel = uilabel(app.misc_Grid1);
            app.misc_ExportLabel.HorizontalAlignment = 'center';
            app.misc_ExportLabel.WordWrap = 'on';
            app.misc_ExportLabel.FontSize = 10;
            app.misc_ExportLabel.Layout.Row = 3;
            app.misc_ExportLabel.Layout.Column = [14 16];
            app.misc_ExportLabel.Text = {'Exportar'; 'análise'};

            % Create misc_Import
            app.misc_Import = uibutton(app.misc_Grid1, 'push');
            app.misc_Import.ButtonPushedFcn = createCallbackFcn(app, @misc_OperationsCallbacks, true);
            app.misc_Import.Icon = fullfile(pathToMLAPP, 'Icons', 'Import_16.png');
            app.misc_Import.IconAlignment = 'top';
            app.misc_Import.BackgroundColor = [1 1 1];
            app.misc_Import.FontSize = 10;
            app.misc_Import.Tooltip = {''};
            app.misc_Import.Layout.Row = 2;
            app.misc_Import.Layout.Column = 18;
            app.misc_Import.Text = '';

            % Create misc_ImportLabel
            app.misc_ImportLabel = uilabel(app.misc_Grid1);
            app.misc_ImportLabel.HorizontalAlignment = 'center';
            app.misc_ImportLabel.WordWrap = 'on';
            app.misc_ImportLabel.FontSize = 10;
            app.misc_ImportLabel.Layout.Row = 3;
            app.misc_ImportLabel.Layout.Column = [17 19];
            app.misc_ImportLabel.Text = {'Importar'; 'análise'};

            % Create misc_Filter
            app.misc_Filter = uibutton(app.misc_Grid1, 'push');
            app.misc_Filter.Icon = fullfile(pathToMLAPP, 'Icons', 'Filter_18.png');
            app.misc_Filter.BackgroundColor = [1 1 1];
            app.misc_Filter.Tooltip = {'Exclui todas as informações espectrais'};
            app.misc_Filter.Layout.Row = 5;
            app.misc_Filter.Layout.Column = 2;
            app.misc_Filter.Text = '';

            % Create misc_FilterLabel
            app.misc_FilterLabel = uilabel(app.misc_Grid1);
            app.misc_FilterLabel.HorizontalAlignment = 'center';
            app.misc_FilterLabel.WordWrap = 'on';
            app.misc_FilterLabel.FontSize = 10;
            app.misc_FilterLabel.Layout.Row = 6;
            app.misc_FilterLabel.Layout.Column = [1 3];
            app.misc_FilterLabel.Text = 'Filtrar fluxo(s)';

            % Create misc_EditLocal
            app.misc_EditLocal = uibutton(app.misc_Grid1, 'push');
            app.misc_EditLocal.Icon = fullfile(pathToMLAPP, 'Icons', 'Pin_32.png');
            app.misc_EditLocal.BackgroundColor = [1 1 1];
            app.misc_EditLocal.Tooltip = {'Exclui todas as informações espectrais'};
            app.misc_EditLocal.Layout.Row = 5;
            app.misc_EditLocal.Layout.Column = 5;
            app.misc_EditLocal.Text = '';

            % Create misc_EditLocalLabel
            app.misc_EditLocalLabel = uilabel(app.misc_Grid1);
            app.misc_EditLocalLabel.HorizontalAlignment = 'center';
            app.misc_EditLocalLabel.WordWrap = 'on';
            app.misc_EditLocalLabel.FontSize = 10;
            app.misc_EditLocalLabel.Layout.Row = 6;
            app.misc_EditLocalLabel.Layout.Column = [4 6];
            app.misc_EditLocalLabel.Text = {'Editar'; 'Local'};

            % Create misc_AddCurve
            app.misc_AddCurve = uibutton(app.misc_Grid1, 'push');
            app.misc_AddCurve.Icon = fullfile(pathToMLAPP, 'Icons', 'RFFilter_32.png');
            app.misc_AddCurve.BackgroundColor = [1 1 1];
            app.misc_AddCurve.Tooltip = {'Exclui todas as informações espectrais'};
            app.misc_AddCurve.Layout.Row = 5;
            app.misc_AddCurve.Layout.Column = 8;
            app.misc_AddCurve.Text = '';

            % Create misc_AddCurveLabel
            app.misc_AddCurveLabel = uilabel(app.misc_Grid1);
            app.misc_AddCurveLabel.HorizontalAlignment = 'center';
            app.misc_AddCurveLabel.WordWrap = 'on';
            app.misc_AddCurveLabel.FontSize = 10;
            app.misc_AddCurveLabel.Layout.Row = 6;
            app.misc_AddCurveLabel.Layout.Column = [7 9];
            app.misc_AddCurveLabel.Text = {'Aplicar'; 'correção'};

            % Create misc_DeleteAll
            app.misc_DeleteAll = uibutton(app.misc_Grid1, 'push');
            app.misc_DeleteAll.ButtonPushedFcn = createCallbackFcn(app, @misc_DeleteAllButtonPushed, true);
            app.misc_DeleteAll.Icon = fullfile(pathToMLAPP, 'Icons', 'Trash_32.png');
            app.misc_DeleteAll.BackgroundColor = [1 1 1];
            app.misc_DeleteAll.Tooltip = {'Exclui todas as informações espectrais'};
            app.misc_DeleteAll.Layout.Row = 8;
            app.misc_DeleteAll.Layout.Column = 2;
            app.misc_DeleteAll.Text = '';

            % Create misc_DeleteAllLabel
            app.misc_DeleteAllLabel = uilabel(app.misc_Grid1);
            app.misc_DeleteAllLabel.HorizontalAlignment = 'center';
            app.misc_DeleteAllLabel.WordWrap = 'on';
            app.misc_DeleteAllLabel.FontSize = 10;
            app.misc_DeleteAllLabel.Layout.Row = 9;
            app.misc_DeleteAllLabel.Layout.Column = [1 3];
            app.misc_DeleteAllLabel.Text = 'Reiniciar análise';

            % Create play_ControlsTab1Grid
            app.play_ControlsTab1Grid = uigridlayout(app.play_ControlsGrid);
            app.play_ControlsTab1Grid.ColumnWidth = {18, '1x'};
            app.play_ControlsTab1Grid.RowHeight = {'1x'};
            app.play_ControlsTab1Grid.ColumnSpacing = 5;
            app.play_ControlsTab1Grid.RowSpacing = 5;
            app.play_ControlsTab1Grid.Padding = [2 2 2 2];
            app.play_ControlsTab1Grid.Tag = 'COLORLOCKED';
            app.play_ControlsTab1Grid.Layout.Row = 1;
            app.play_ControlsTab1Grid.Layout.Column = 1;
            app.play_ControlsTab1Grid.BackgroundColor = [0.749 0.749 0.749];

            % Create play_ControlsTab1Label
            app.play_ControlsTab1Label = uilabel(app.play_ControlsTab1Grid);
            app.play_ControlsTab1Label.FontSize = 11;
            app.play_ControlsTab1Label.Layout.Row = 1;
            app.play_ControlsTab1Label.Layout.Column = 2;
            app.play_ControlsTab1Label.Text = 'PLAYBACK';

            % Create play_ControlsTab1Image
            app.play_ControlsTab1Image = uiimage(app.play_ControlsTab1Grid);
            app.play_ControlsTab1Image.ImageClickedFcn = createCallbackFcn(app, @play_TabGroupVisibility, true);
            app.play_ControlsTab1Image.Layout.Row = 1;
            app.play_ControlsTab1Image.Layout.Column = [1 2];
            app.play_ControlsTab1Image.HorizontalAlignment = 'left';
            app.play_ControlsTab1Image.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Playback_32.png');

            % Create play_toolGrid
            app.play_toolGrid = uigridlayout(app.play_Grid);
            app.play_toolGrid.ColumnWidth = {22, 22, 22, 248, '1x', 24, 24, 24, 24, 24, 24, '1x', 167, 22, 22, 22, 22, 22, 22};
            app.play_toolGrid.RowHeight = {4, 17, '1x'};
            app.play_toolGrid.ColumnSpacing = 5;
            app.play_toolGrid.RowSpacing = 0;
            app.play_toolGrid.Padding = [0 5 0 5];
            app.play_toolGrid.Layout.Row = 3;
            app.play_toolGrid.Layout.Column = [1 7];

            % Create tool_LayoutLeft
            app.tool_LayoutLeft = uiimage(app.play_toolGrid);
            app.tool_LayoutLeft.ImageClickedFcn = createCallbackFcn(app, @play_PanelsVisibility, true);
            app.tool_LayoutLeft.Layout.Row = 2;
            app.tool_LayoutLeft.Layout.Column = 1;
            app.tool_LayoutLeft.ImageSource = fullfile(pathToMLAPP, 'Icons', 'ArrowLeft_32.png');

            % Create tool_Play
            app.tool_Play = uiimage(app.play_toolGrid);
            app.tool_Play.ImageClickedFcn = createCallbackFcn(app, @play_PlaybackToolbarButtonCallback, true);
            app.tool_Play.Tooltip = {'Playback'};
            app.tool_Play.Layout.Row = 2;
            app.tool_Play.Layout.Column = 2;
            app.tool_Play.ImageSource = fullfile(pathToMLAPP, 'Icons', 'play_32.png');

            % Create tool_LoopControl
            app.tool_LoopControl = uiimage(app.play_toolGrid);
            app.tool_LoopControl.ImageClickedFcn = createCallbackFcn(app, @play_PlaybackToolbarButtonCallback, true);
            app.tool_LoopControl.Tag = 'loop';
            app.tool_LoopControl.Tooltip = {'Loop do playback'};
            app.tool_LoopControl.Layout.Row = 2;
            app.tool_LoopControl.Layout.Column = 3;
            app.tool_LoopControl.ImageSource = fullfile(pathToMLAPP, 'Icons', 'playbackLoop_32Blue.png');

            % Create tool_TimestampSlider
            app.tool_TimestampSlider = uislider(app.play_toolGrid);
            app.tool_TimestampSlider.MajorTicks = [0 50 100];
            app.tool_TimestampSlider.MajorTickLabels = {''};
            app.tool_TimestampSlider.ValueChangingFcn = createCallbackFcn(app, @tool_TimestampSliderValueChanging, true);
            app.tool_TimestampSlider.MinorTicks = [0 2.5 5 7.5 10 12.5 15 17.5 20 22.5 25 27.5 30 32.5 35 37.5 40 42.5 45 47.5 50 52.5 55 57.5 60 62.5 65 67.5 70 72.5 75 77.5 80 82.5 85 87.5 90 92.5 95 97.5 100];
            app.tool_TimestampSlider.FontSize = 8;
            app.tool_TimestampSlider.Layout.Row = 2;
            app.tool_TimestampSlider.Layout.Column = 4;

            % Create tool_TimestampLabel
            app.tool_TimestampLabel = uilabel(app.play_toolGrid);
            app.tool_TimestampLabel.WordWrap = 'on';
            app.tool_TimestampLabel.FontSize = 10;
            app.tool_TimestampLabel.Layout.Row = [1 3];
            app.tool_TimestampLabel.Layout.Column = 5;
            app.tool_TimestampLabel.Text = {'22 de 328 '; '22/02/2022 08:00:00 '};

            % Create tool_RFDataHub
            app.tool_RFDataHub = uiimage(app.play_toolGrid);
            app.tool_RFDataHub.ImageClickedFcn = createCallbackFcn(app, @play_RFDataHubButtonPushed, true);
            app.tool_RFDataHub.Tag = 'PLAYBACK';
            app.tool_RFDataHub.Enable = 'off';
            app.tool_RFDataHub.Tooltip = {'Consulta frequência na base do RFDataHub'};
            app.tool_RFDataHub.Layout.Row = 2;
            app.tool_RFDataHub.Layout.Column = 17;
            app.tool_RFDataHub.ImageSource = fullfile(pathToMLAPP, 'Icons', 'mosaic_32.png');

            % Create tool_DriveTest
            app.tool_DriveTest = uiimage(app.play_toolGrid);
            app.tool_DriveTest.ImageClickedFcn = createCallbackFcn(app, @play_DriveTestButtonPushed, true);
            app.tool_DriveTest.Tag = 'PLAYBACK';
            app.tool_DriveTest.Enable = 'off';
            app.tool_DriveTest.Tooltip = {'Abre módulo Drive-test'};
            app.tool_DriveTest.Layout.Row = 2;
            app.tool_DriveTest.Layout.Column = 18;
            app.tool_DriveTest.ImageSource = fullfile(pathToMLAPP, 'Icons', 'DriveTestDensity_32.png');

            % Create tool_ExceptionList
            app.tool_ExceptionList = uiimage(app.play_toolGrid);
            app.tool_ExceptionList.ImageClickedFcn = createCallbackFcn(app, @report_OpenSignalAnalysis, true);
            app.tool_ExceptionList.Tag = 'REPORT';
            app.tool_ExceptionList.Visible = 'off';
            app.tool_ExceptionList.Tooltip = {'Abre módulo Análise de sinais'};
            app.tool_ExceptionList.Layout.Row = 2;
            app.tool_ExceptionList.Layout.Column = 14;
            app.tool_ExceptionList.ImageSource = fullfile(pathToMLAPP, 'Icons', 'exceptionList_32.png');

            % Create tool_ReportAnalysis
            app.tool_ReportAnalysis = uiimage(app.play_toolGrid);
            app.tool_ReportAnalysis.ImageClickedFcn = createCallbackFcn(app, @report_playButtonPushed, true);
            app.tool_ReportAnalysis.Tag = 'REPORT';
            app.tool_ReportAnalysis.Enable = 'off';
            app.tool_ReportAnalysis.Visible = 'off';
            app.tool_ReportAnalysis.Tooltip = {'Identifica emissões do(s) fluxo(s) selecionado(s)'};
            app.tool_ReportAnalysis.Layout.Row = 2;
            app.tool_ReportAnalysis.Layout.Column = 15;
            app.tool_ReportAnalysis.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Zoom_32.png');

            % Create tool_ReportGenerator
            app.tool_ReportGenerator = uiimage(app.play_toolGrid);
            app.tool_ReportGenerator.ImageClickedFcn = createCallbackFcn(app, @report_playButtonPushed, true);
            app.tool_ReportGenerator.Tag = 'REPORT';
            app.tool_ReportGenerator.Enable = 'off';
            app.tool_ReportGenerator.Visible = 'off';
            app.tool_ReportGenerator.Tooltip = {'Gera relatório'};
            app.tool_ReportGenerator.Layout.Row = 2;
            app.tool_ReportGenerator.Layout.Column = 16;
            app.tool_ReportGenerator.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Publish_HTML_16.png');

            % Create tool_FiscalizaAutoFill
            app.tool_FiscalizaAutoFill = uiimage(app.play_toolGrid);
            app.tool_FiscalizaAutoFill.ImageClickedFcn = createCallbackFcn(app, @report_FiscalizaStaticButtonPushed, true);
            app.tool_FiscalizaAutoFill.Tag = 'FISCALIZA';
            app.tool_FiscalizaAutoFill.Enable = 'off';
            app.tool_FiscalizaAutoFill.Visible = 'off';
            app.tool_FiscalizaAutoFill.Tooltip = {'Preenche campos automaticamente'};
            app.tool_FiscalizaAutoFill.Layout.Row = 2;
            app.tool_FiscalizaAutoFill.Layout.Column = 17;
            app.tool_FiscalizaAutoFill.ImageSource = fullfile(pathToMLAPP, 'Icons', 'AutoFill_36Blue.png');

            % Create tool_FiscalizaUpdate
            app.tool_FiscalizaUpdate = uiimage(app.play_toolGrid);
            app.tool_FiscalizaUpdate.ImageClickedFcn = createCallbackFcn(app, @report_FiscalizaStaticButtonPushed, true);
            app.tool_FiscalizaUpdate.Tag = 'FISCALIZA';
            app.tool_FiscalizaUpdate.Enable = 'off';
            app.tool_FiscalizaUpdate.Visible = 'off';
            app.tool_FiscalizaUpdate.Tooltip = {'Atualiza inspeção no FISCALIZA'};
            app.tool_FiscalizaUpdate.Layout.Row = 2;
            app.tool_FiscalizaUpdate.Layout.Column = 18;
            app.tool_FiscalizaUpdate.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Up_24.png');

            % Create tool_LayoutRight
            app.tool_LayoutRight = uiimage(app.play_toolGrid);
            app.tool_LayoutRight.ImageClickedFcn = createCallbackFcn(app, @play_PanelsVisibility, true);
            app.tool_LayoutRight.Layout.Row = 2;
            app.tool_LayoutRight.Layout.Column = 19;
            app.tool_LayoutRight.ImageSource = fullfile(pathToMLAPP, 'Icons', 'ArrowRight_32.png');

            % Create Tab3_DriveTest
            app.Tab3_DriveTest = uitab(app.TabGroup);
            app.Tab3_DriveTest.Title = 'DRIVE-TEST';

            % Create drivetest_Grid
            app.drivetest_Grid = uigridlayout(app.Tab3_DriveTest);
            app.drivetest_Grid.ColumnWidth = {'1x', 22, 22};
            app.drivetest_Grid.RowHeight = {20, '1x'};
            app.drivetest_Grid.ColumnSpacing = 2;
            app.drivetest_Grid.RowSpacing = 0;
            app.drivetest_Grid.Padding = [0 0 0 20];

            % Create drivetest_Container
            app.drivetest_Container = uipanel(app.drivetest_Grid);
            app.drivetest_Container.BorderType = 'none';
            app.drivetest_Container.Title = ' ';
            app.drivetest_Container.BackgroundColor = [0.9412 0.9412 0.9412];
            app.drivetest_Container.Layout.Row = [1 2];
            app.drivetest_Container.Layout.Column = [1 3];

            % Create drivetest_Undock
            app.drivetest_Undock = uiimage(app.drivetest_Grid);
            app.drivetest_Undock.ScaleMethod = 'none';
            app.drivetest_Undock.ImageClickedFcn = createCallbackFcn(app, @menu_DockButtonPushed, true);
            app.drivetest_Undock.Tag = 'DRIVETEST';
            app.drivetest_Undock.Tooltip = {'Reabre módulo em outra janela'};
            app.drivetest_Undock.Layout.Row = 1;
            app.drivetest_Undock.Layout.Column = 2;
            app.drivetest_Undock.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Undock_18.png');

            % Create drivetest_Close
            app.drivetest_Close = uiimage(app.drivetest_Grid);
            app.drivetest_Close.ScaleMethod = 'none';
            app.drivetest_Close.ImageClickedFcn = createCallbackFcn(app, @menu_DockButtonPushed, true);
            app.drivetest_Close.Tag = 'DRIVETEST';
            app.drivetest_Close.Tooltip = {'Fecha módulo'};
            app.drivetest_Close.Layout.Row = 1;
            app.drivetest_Close.Layout.Column = 3;
            app.drivetest_Close.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Delete_12SVG.svg');

            % Create Tab4_SignalAnalysis
            app.Tab4_SignalAnalysis = uitab(app.TabGroup);
            app.Tab4_SignalAnalysis.Title = 'SIGNALANALYSIS';

            % Create signalanalysis_Grid
            app.signalanalysis_Grid = uigridlayout(app.Tab4_SignalAnalysis);
            app.signalanalysis_Grid.ColumnWidth = {'1x', 22, 22};
            app.signalanalysis_Grid.RowHeight = {20, '1x'};
            app.signalanalysis_Grid.ColumnSpacing = 2;
            app.signalanalysis_Grid.RowSpacing = 0;
            app.signalanalysis_Grid.Padding = [0 0 0 20];

            % Create signalanalysis_Container
            app.signalanalysis_Container = uipanel(app.signalanalysis_Grid);
            app.signalanalysis_Container.BorderType = 'none';
            app.signalanalysis_Container.Title = ' ';
            app.signalanalysis_Container.Layout.Row = [1 2];
            app.signalanalysis_Container.Layout.Column = [1 3];

            % Create signalanalysis_Undock
            app.signalanalysis_Undock = uiimage(app.signalanalysis_Grid);
            app.signalanalysis_Undock.ScaleMethod = 'none';
            app.signalanalysis_Undock.ImageClickedFcn = createCallbackFcn(app, @menu_DockButtonPushed, true);
            app.signalanalysis_Undock.Tag = 'SIGNALANALYSIS';
            app.signalanalysis_Undock.Tooltip = {'Reabre módulo em outra janela'};
            app.signalanalysis_Undock.Layout.Row = 1;
            app.signalanalysis_Undock.Layout.Column = 2;
            app.signalanalysis_Undock.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Undock_18.png');

            % Create signalanalysis_Close
            app.signalanalysis_Close = uiimage(app.signalanalysis_Grid);
            app.signalanalysis_Close.ScaleMethod = 'none';
            app.signalanalysis_Close.ImageClickedFcn = createCallbackFcn(app, @menu_DockButtonPushed, true);
            app.signalanalysis_Close.Tag = 'SIGNALANALYSIS';
            app.signalanalysis_Close.Tooltip = {'Fecha módulo'};
            app.signalanalysis_Close.Layout.Row = 1;
            app.signalanalysis_Close.Layout.Column = 3;
            app.signalanalysis_Close.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Delete_12SVG.svg');

            % Create Tab5_RFDataHub
            app.Tab5_RFDataHub = uitab(app.TabGroup);
            app.Tab5_RFDataHub.Title = 'RFDATAHUB';

            % Create rfdatahub_Grid
            app.rfdatahub_Grid = uigridlayout(app.Tab5_RFDataHub);
            app.rfdatahub_Grid.ColumnWidth = {'1x', 22, 22};
            app.rfdatahub_Grid.RowHeight = {20, '1x'};
            app.rfdatahub_Grid.ColumnSpacing = 2;
            app.rfdatahub_Grid.RowSpacing = 0;
            app.rfdatahub_Grid.Padding = [0 0 0 20];

            % Create rfdatahub_Container
            app.rfdatahub_Container = uipanel(app.rfdatahub_Grid);
            app.rfdatahub_Container.BorderType = 'none';
            app.rfdatahub_Container.Title = ' ';
            app.rfdatahub_Container.Layout.Row = [1 2];
            app.rfdatahub_Container.Layout.Column = [1 3];

            % Create rfdatahub_Undock
            app.rfdatahub_Undock = uiimage(app.rfdatahub_Grid);
            app.rfdatahub_Undock.ScaleMethod = 'none';
            app.rfdatahub_Undock.ImageClickedFcn = createCallbackFcn(app, @menu_DockButtonPushed, true);
            app.rfdatahub_Undock.Tag = 'RFDATAHUB';
            app.rfdatahub_Undock.Tooltip = {'Reabre módulo em outra janela'};
            app.rfdatahub_Undock.Layout.Row = 1;
            app.rfdatahub_Undock.Layout.Column = 2;
            app.rfdatahub_Undock.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Undock_18.png');

            % Create rfdatahub_Close
            app.rfdatahub_Close = uiimage(app.rfdatahub_Grid);
            app.rfdatahub_Close.ScaleMethod = 'none';
            app.rfdatahub_Close.ImageClickedFcn = createCallbackFcn(app, @menu_DockButtonPushed, true);
            app.rfdatahub_Close.Tag = 'RFDATAHUB';
            app.rfdatahub_Close.Tooltip = {'Fecha módulo'};
            app.rfdatahub_Close.Layout.Row = 1;
            app.rfdatahub_Close.Layout.Column = 3;
            app.rfdatahub_Close.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Delete_12SVG.svg');

            % Create Tab6_Config
            app.Tab6_Config = uitab(app.TabGroup);
            app.Tab6_Config.Title = 'CONFIG';

            % Create config_Grid
            app.config_Grid = uigridlayout(app.Tab6_Config);
            app.config_Grid.ColumnWidth = {'1x', 22, 22};
            app.config_Grid.RowHeight = {20, '1x'};
            app.config_Grid.ColumnSpacing = 2;
            app.config_Grid.RowSpacing = 0;
            app.config_Grid.Padding = [0 0 0 20];

            % Create config_Container
            app.config_Container = uipanel(app.config_Grid);
            app.config_Container.BorderType = 'none';
            app.config_Container.Title = ' ';
            app.config_Container.Layout.Row = [1 2];
            app.config_Container.Layout.Column = [1 3];

            % Create config_Undock
            app.config_Undock = uiimage(app.config_Grid);
            app.config_Undock.ScaleMethod = 'none';
            app.config_Undock.ImageClickedFcn = createCallbackFcn(app, @menu_DockButtonPushed, true);
            app.config_Undock.Tag = 'CONFIG';
            app.config_Undock.Tooltip = {'Reabre módulo em outra janela'};
            app.config_Undock.Layout.Row = 1;
            app.config_Undock.Layout.Column = 2;
            app.config_Undock.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Undock_18.png');

            % Create config_Close
            app.config_Close = uiimage(app.config_Grid);
            app.config_Close.ScaleMethod = 'none';
            app.config_Close.ImageClickedFcn = createCallbackFcn(app, @menu_DockButtonPushed, true);
            app.config_Close.Tag = 'CONFIG';
            app.config_Close.Tooltip = {'Fecha módulo'};
            app.config_Close.Layout.Row = 1;
            app.config_Close.Layout.Column = 3;
            app.config_Close.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Delete_12SVG.svg');

            % Create menu_Grid
            app.menu_Grid = uigridlayout(app.GridLayout);
            app.menu_Grid.ColumnWidth = {28, 5, 28, 28, 28, 5, 28, 28, 28, 28, '1x', 20, 20, 20};
            app.menu_Grid.RowHeight = {7, '1x', 7};
            app.menu_Grid.ColumnSpacing = 5;
            app.menu_Grid.RowSpacing = 0;
            app.menu_Grid.Padding = [5 5 5 5];
            app.menu_Grid.Tag = 'COLORLOCKED';
            app.menu_Grid.Layout.Row = 1;
            app.menu_Grid.Layout.Column = 1;
            app.menu_Grid.BackgroundColor = [0.2 0.2 0.2];

            % Create menu_Button1
            app.menu_Button1 = uibutton(app.menu_Grid, 'state');
            app.menu_Button1.ValueChangedFcn = createCallbackFcn(app, @menu_mainButtonPushed, true);
            app.menu_Button1.Tag = 'FILE';
            app.menu_Button1.Tooltip = {'Leitura de arquivos'};
            app.menu_Button1.Icon = fullfile(pathToMLAPP, 'Icons', 'OpenFile_32Yellow.png');
            app.menu_Button1.IconAlignment = 'top';
            app.menu_Button1.Text = '';
            app.menu_Button1.BackgroundColor = [0.2 0.2 0.2];
            app.menu_Button1.FontSize = 11;
            app.menu_Button1.Layout.Row = [1 3];
            app.menu_Button1.Layout.Column = 1;
            app.menu_Button1.Value = true;

            % Create menu_Separator1
            app.menu_Separator1 = uiimage(app.menu_Grid);
            app.menu_Separator1.ScaleMethod = 'fill';
            app.menu_Separator1.Enable = 'off';
            app.menu_Separator1.Layout.Row = [1 3];
            app.menu_Separator1.Layout.Column = 2;
            app.menu_Separator1.ImageSource = fullfile(pathToMLAPP, 'Icons', 'LineV_White.png');

            % Create menu_Button2
            app.menu_Button2 = uibutton(app.menu_Grid, 'state');
            app.menu_Button2.ValueChangedFcn = createCallbackFcn(app, @menu_mainButtonPushed, true);
            app.menu_Button2.Tag = 'PLAYBACK';
            app.menu_Button2.Enable = 'off';
            app.menu_Button2.Tooltip = {'Playback'};
            app.menu_Button2.Icon = fullfile(pathToMLAPP, 'Icons', 'Playback_32White.png');
            app.menu_Button2.IconAlignment = 'top';
            app.menu_Button2.Text = '';
            app.menu_Button2.BackgroundColor = [0.2 0.2 0.2];
            app.menu_Button2.FontSize = 11;
            app.menu_Button2.Layout.Row = [1 3];
            app.menu_Button2.Layout.Column = 3;

            % Create menu_Button3
            app.menu_Button3 = uibutton(app.menu_Grid, 'state');
            app.menu_Button3.ValueChangedFcn = createCallbackFcn(app, @menu_mainButtonPushed, true);
            app.menu_Button3.Tag = 'REPORT';
            app.menu_Button3.Enable = 'off';
            app.menu_Button3.Tooltip = {'Relatório'};
            app.menu_Button3.Icon = fullfile(pathToMLAPP, 'Icons', 'Report_32White.png');
            app.menu_Button3.IconAlignment = 'top';
            app.menu_Button3.Text = '';
            app.menu_Button3.BackgroundColor = [0.2 0.2 0.2];
            app.menu_Button3.FontSize = 11;
            app.menu_Button3.Layout.Row = [1 3];
            app.menu_Button3.Layout.Column = 4;

            % Create menu_Button4
            app.menu_Button4 = uibutton(app.menu_Grid, 'state');
            app.menu_Button4.ValueChangedFcn = createCallbackFcn(app, @menu_mainButtonPushed, true);
            app.menu_Button4.Tag = 'MISC';
            app.menu_Button4.Enable = 'off';
            app.menu_Button4.Tooltip = {'Miscelâneas'};
            app.menu_Button4.Icon = fullfile(pathToMLAPP, 'Icons', 'Misc_32White.png');
            app.menu_Button4.IconAlignment = 'top';
            app.menu_Button4.Text = '';
            app.menu_Button4.BackgroundColor = [0.2 0.2 0.2];
            app.menu_Button4.FontSize = 11;
            app.menu_Button4.Layout.Row = [1 3];
            app.menu_Button4.Layout.Column = 5;

            % Create menu_Separator2
            app.menu_Separator2 = uiimage(app.menu_Grid);
            app.menu_Separator2.ScaleMethod = 'fill';
            app.menu_Separator2.Enable = 'off';
            app.menu_Separator2.Layout.Row = [1 3];
            app.menu_Separator2.Layout.Column = 6;
            app.menu_Separator2.ImageSource = fullfile(pathToMLAPP, 'Icons', 'LineV_White.png');

            % Create menu_Button5
            app.menu_Button5 = uibutton(app.menu_Grid, 'state');
            app.menu_Button5.ValueChangedFcn = createCallbackFcn(app, @menu_mainButtonPushed, true);
            app.menu_Button5.Tag = 'DRIVETEST';
            app.menu_Button5.Enable = 'off';
            app.menu_Button5.Tooltip = {'Drive-test'};
            app.menu_Button5.Icon = fullfile(pathToMLAPP, 'Icons', 'DriveTestDensity_32White.png');
            app.menu_Button5.IconAlignment = 'top';
            app.menu_Button5.Text = '';
            app.menu_Button5.BackgroundColor = [0.2 0.2 0.2];
            app.menu_Button5.FontSize = 11;
            app.menu_Button5.Layout.Row = [1 3];
            app.menu_Button5.Layout.Column = 7;

            % Create menu_Button6
            app.menu_Button6 = uibutton(app.menu_Grid, 'state');
            app.menu_Button6.ValueChangedFcn = createCallbackFcn(app, @menu_mainButtonPushed, true);
            app.menu_Button6.Tag = 'SIGNALANALYSIS';
            app.menu_Button6.Enable = 'off';
            app.menu_Button6.Tooltip = {'Análise de sinais'};
            app.menu_Button6.Icon = fullfile(pathToMLAPP, 'Icons', 'exceptionList_32White.png');
            app.menu_Button6.IconAlignment = 'top';
            app.menu_Button6.Text = '';
            app.menu_Button6.BackgroundColor = [0.2 0.2 0.2];
            app.menu_Button6.FontSize = 11;
            app.menu_Button6.Layout.Row = [1 3];
            app.menu_Button6.Layout.Column = 8;

            % Create menu_Button7
            app.menu_Button7 = uibutton(app.menu_Grid, 'state');
            app.menu_Button7.ValueChangedFcn = createCallbackFcn(app, @menu_OpenRFDataHubModule, true);
            app.menu_Button7.Tag = 'RFDATAHUB';
            app.menu_Button7.Tooltip = {'RFDataHub'};
            app.menu_Button7.Icon = fullfile(pathToMLAPP, 'Icons', 'mosaic_32White.png');
            app.menu_Button7.IconAlignment = 'top';
            app.menu_Button7.Text = '';
            app.menu_Button7.BackgroundColor = [0.2 0.2 0.2];
            app.menu_Button7.FontSize = 11;
            app.menu_Button7.Layout.Row = [1 3];
            app.menu_Button7.Layout.Column = 9;

            % Create menu_Button8
            app.menu_Button8 = uibutton(app.menu_Grid, 'state');
            app.menu_Button8.ValueChangedFcn = createCallbackFcn(app, @menu_Button8ValueChanged, true);
            app.menu_Button8.Tag = 'CONFIG';
            app.menu_Button8.Tooltip = {'Configurações gerais'};
            app.menu_Button8.Icon = fullfile(pathToMLAPP, 'Icons', 'Settings_36White.png');
            app.menu_Button8.IconAlignment = 'top';
            app.menu_Button8.Text = '';
            app.menu_Button8.BackgroundColor = [0.2 0.2 0.2];
            app.menu_Button8.FontSize = 11;
            app.menu_Button8.Layout.Row = [1 3];
            app.menu_Button8.Layout.Column = 10;

            % Create jsBackDoor
            app.jsBackDoor = uihtml(app.menu_Grid);
            app.jsBackDoor.Layout.Row = [1 3];
            app.jsBackDoor.Layout.Column = 12;

            % Create FigurePosition
            app.FigurePosition = uiimage(app.menu_Grid);
            app.FigurePosition.ImageClickedFcn = createCallbackFcn(app, @menu_ToolbarImageCliced, true);
            app.FigurePosition.Visible = 'off';
            app.FigurePosition.Layout.Row = 2;
            app.FigurePosition.Layout.Column = 13;
            app.FigurePosition.ImageSource = fullfile(pathToMLAPP, 'Icons', 'layout1_32White.png');

            % Create AppInfo
            app.AppInfo = uiimage(app.menu_Grid);
            app.AppInfo.ImageClickedFcn = createCallbackFcn(app, @menu_ToolbarImageCliced, true);
            app.AppInfo.Layout.Row = 2;
            app.AppInfo.Layout.Column = 14;
            app.AppInfo.ImageSource = fullfile(pathToMLAPP, 'Icons', 'Dots_32White.png');

            % Create popupContainerGrid
            app.popupContainerGrid = uigridlayout(app.GridLayout);
            app.popupContainerGrid.ColumnWidth = {'1x', 880, '1x'};
            app.popupContainerGrid.RowHeight = {'1x', 90, 300, 90, '1x'};
            app.popupContainerGrid.ColumnSpacing = 0;
            app.popupContainerGrid.RowSpacing = 0;
            app.popupContainerGrid.Padding = [13 10 0 10];
            app.popupContainerGrid.Layout.Row = 3;
            app.popupContainerGrid.Layout.Column = 1;
            app.popupContainerGrid.BackgroundColor = [1 1 1];

            % Create popupContainer
            app.popupContainer = uipanel(app.popupContainerGrid);
            app.popupContainer.Visible = 'off';
            app.popupContainer.BackgroundColor = [1 1 1];
            app.popupContainer.Layout.Row = [2 4];
            app.popupContainer.Layout.Column = 2;

            % Create SplashScreen
            app.SplashScreen = uiimage(app.popupContainerGrid);
            app.SplashScreen.Layout.Row = 3;
            app.SplashScreen.Layout.Column = 2;
            app.SplashScreen.ImageSource = fullfile(pathToMLAPP, 'Icons', 'SplashScreen.gif');

            % Create file_ContextMenu_Tree1
            app.file_ContextMenu_Tree1 = uicontextmenu(app.UIFigure);

            % Create file_ContextMenu_delTree1Node
            app.file_ContextMenu_delTree1Node = uimenu(app.file_ContextMenu_Tree1);
            app.file_ContextMenu_delTree1Node.MenuSelectedFcn = createCallbackFcn(app, @file_ContextMenu_delTree1NodeSelected, true);
            app.file_ContextMenu_delTree1Node.Text = 'Excluir';

            % Create file_ContextMenu_Tree2
            app.file_ContextMenu_Tree2 = uicontextmenu(app.UIFigure);

            % Create file_ContextMenu_delTree2Node
            app.file_ContextMenu_delTree2Node = uimenu(app.file_ContextMenu_Tree2);
            app.file_ContextMenu_delTree2Node.MenuSelectedFcn = createCallbackFcn(app, @file_ContextMenu_delTree2NodeSelected, true);
            app.file_ContextMenu_delTree2Node.Text = 'Excluir';

            % Create play_FindPeaks_ContextMenu
            app.play_FindPeaks_ContextMenu = uicontextmenu(app.UIFigure);

            % Create play_FindPeaks_ContextMenu_edit
            app.play_FindPeaks_ContextMenu_edit = uimenu(app.play_FindPeaks_ContextMenu);
            app.play_FindPeaks_ContextMenu_edit.Text = 'Editar';

            % Create play_FindPeaks_ContextMenu_analog
            app.play_FindPeaks_ContextMenu_analog = uimenu(app.play_FindPeaks_ContextMenu_edit);
            app.play_FindPeaks_ContextMenu_analog.MenuSelectedFcn = createCallbackFcn(app, @play_FindPeaks_TruncatedEmission, true);
            app.play_FindPeaks_ContextMenu_analog.Text = 'Não truncar';

            % Create play_FindPeaks_ContextMenu_digital
            app.play_FindPeaks_ContextMenu_digital = uimenu(app.play_FindPeaks_ContextMenu_edit);
            app.play_FindPeaks_ContextMenu_digital.MenuSelectedFcn = createCallbackFcn(app, @play_FindPeaks_TruncatedEmission, true);
            app.play_FindPeaks_ContextMenu_digital.Text = 'Truncar frequência';

            % Create play_FindPeaks_ContextMenu_del
            app.play_FindPeaks_ContextMenu_del = uimenu(app.play_FindPeaks_ContextMenu);
            app.play_FindPeaks_ContextMenu_del.MenuSelectedFcn = createCallbackFcn(app, @play_FindPeaks_delEmission, true);
            app.play_FindPeaks_ContextMenu_del.Text = 'Excluir';

            % Create play_Channel_ContextMenu
            app.play_Channel_ContextMenu = uicontextmenu(app.UIFigure);

            % Create play_Channel_ContextMenu_del
            app.play_Channel_ContextMenu_del = uimenu(app.play_Channel_ContextMenu);
            app.play_Channel_ContextMenu_del.MenuSelectedFcn = createCallbackFcn(app, @play_Channel_ContextMenu_delChannelSelected, true);
            app.play_Channel_ContextMenu_del.Text = 'Excluir';

            % Create play_Channel_ContextMenu_addBandLimit
            app.play_Channel_ContextMenu_addBandLimit = uimenu(app.play_Channel_ContextMenu);
            app.play_Channel_ContextMenu_addBandLimit.MenuSelectedFcn = createCallbackFcn(app, @play_Channel_ContextMenu_addBandLimitSelected, true);
            app.play_Channel_ContextMenu_addBandLimit.Separator = 'on';
            app.play_Channel_ContextMenu_addBandLimit.Text = 'Adicionar limites à detecção';

            % Create play_Channel_ContextMenu_addEmission
            app.play_Channel_ContextMenu_addEmission = uimenu(app.play_Channel_ContextMenu);
            app.play_Channel_ContextMenu_addEmission.MenuSelectedFcn = createCallbackFcn(app, @play_Channel_ContextMenu_addEmissionSelected, true);
            app.play_Channel_ContextMenu_addEmission.Text = 'Adicionar canais como emissões';

            % Create report_ContextMenu
            app.report_ContextMenu = uicontextmenu(app.UIFigure);

            % Create report_ContextMenu_del
            app.report_ContextMenu_del = uimenu(app.report_ContextMenu);
            app.report_ContextMenu_del.MenuSelectedFcn = createCallbackFcn(app, @report_ContextMenu_delSelected, true);
            app.report_ContextMenu_del.Separator = 'on';
            app.report_ContextMenu_del.Text = 'Excluir';

            % Create report_ContextMenu_ExternalFiles
            app.report_ContextMenu_ExternalFiles = uimenu(app.report_ContextMenu);
            app.report_ContextMenu_ExternalFiles.MenuSelectedFcn = createCallbackFcn(app, @report_ExternalFilesMenuSelected, true);
            app.report_ContextMenu_ExternalFiles.Text = 'Arquivos externos';

            % Create play_BandLimits_ContextMenu
            app.play_BandLimits_ContextMenu = uicontextmenu(app.UIFigure);

            % Create play_BandLimits_ContextMenu_del
            app.play_BandLimits_ContextMenu_del = uimenu(app.play_BandLimits_ContextMenu);
            app.play_BandLimits_ContextMenu_del.MenuSelectedFcn = createCallbackFcn(app, @play_BandLimits_ContextMenu_delSelected, true);
            app.play_BandLimits_ContextMenu_del.Text = 'Excluir';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = winAppAnalise_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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
