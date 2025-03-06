classdef winSignalAnalysis_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        GridLayout                    matlab.ui.container.GridLayout
        toolGrid                      matlab.ui.container.GridLayout
        tool_ControlPanelVisibility   matlab.ui.control.Image
        jsBackDoor                    matlab.ui.control.HTML
        tool_ExportJSONFile           matlab.ui.control.Image
        tool_ShowGlobalExceptionList  matlab.ui.control.Image
        ControlGrid                   matlab.ui.container.GridLayout
        EditableParametersPanel       matlab.ui.container.Panel
        EditableParametersGrid        matlab.ui.container.GridLayout
        AdditionalDescription         matlab.ui.control.TextArea
        AdditionalDescriptionLabel    matlab.ui.control.Label
        RiskLevel                     matlab.ui.control.DropDown
        RiskLevelLabel                matlab.ui.control.Label
        Compliance                    matlab.ui.control.DropDown
        ComplianceLabel               matlab.ui.control.Label
        Type                          matlab.ui.control.DropDown
        TypeLabel                     matlab.ui.control.Label
        StationID                     matlab.ui.control.EditField
        StationIDLabel                matlab.ui.control.Label
        Regulatory                    matlab.ui.control.DropDown
        RegulatoryLabel               matlab.ui.control.Label
        DelAnnotation                 matlab.ui.control.Image
        EditableParametersLabel       matlab.ui.control.Label
        selectedEmissionPanel         matlab.ui.container.Panel
        selectedEmissionGrid          matlab.ui.container.GridLayout
        selectedEmissionInfo          matlab.ui.control.HTML
        selectedEmissionLabel         matlab.ui.control.Label
        Document                      matlab.ui.container.GridLayout
        TXGrid                        matlab.ui.container.GridLayout
        TXPanel                       matlab.ui.container.Panel
        TXSubGrid                     matlab.ui.container.GridLayout
        TXHeight                      matlab.ui.control.NumericEditField
        TXHeightLabel                 matlab.ui.control.Label
        TXLongitude                   matlab.ui.control.NumericEditField
        TXLongitudeLabel              matlab.ui.control.Label
        TXLatitude                    matlab.ui.control.NumericEditField
        TXLatitudeLabel               matlab.ui.control.Label
        plotPanel                     matlab.ui.container.Panel
        axesToolSupport               matlab.ui.container.GridLayout
        axesTool_redrawPlot           matlab.ui.control.Image
        axesTool_Config               matlab.ui.control.Image
        axesTool_Warning              matlab.ui.control.Image
        axesTool_Pan                  matlab.ui.control.Image
        axesTool_RestoreView          matlab.ui.control.Image
        UITable                       matlab.ui.control.Table
        tableInfoNRows                matlab.ui.control.Label
        tableInfoMetadata             matlab.ui.control.Label
        ContextMenu_UITable           matlab.ui.container.ContextMenu
        ContextMenu_editEmission      matlab.ui.container.Menu
        ContextMenu_analogEmission    matlab.ui.container.Menu
        ContextMenu_digitalEmission   matlab.ui.container.Menu
        ContextMenu_deleteEmission    matlab.ui.container.Menu
    end

    
    properties (Access = public)
        %-----------------------------------------------------------------%
        Container
        isDocked = false

        mainApp
        General
        General_I
        rootFolder
        specData
        projectData

        % A função do timer é executada uma única vez após a renderização
        % da figura, lendo arquivos de configuração, iniciando modo de operação
        % paralelo etc. A ideia é deixar o MATLAB focar apenas na criação dos 
        % componentes essenciais da GUI (especificados em "createComponents"), 
        % mostrando a GUI para o usuário o mais rápido possível.
        timerObj

        % Janela de progresso já criada no DOM. Dessa forma, controla-se 
        % apenas a sua visibilidade - e tornando desnecessário criá-la a
        % cada chamada (usando uiprogressdlg, por exemplo).
        progressDialog

        %-----------------------------------------------------------------%
        % ESPECIFICIDADES AUXAPP.WINSIGNALANALYSIS
        %-----------------------------------------------------------------%
        tempBandObj
        elevationObj = RF.Elevation

        UIAxes1
        UIAxes2
        restoreView = struct('ID', {}, 'xLim', {}, 'yLim', {}, 'cLim', {})
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        % JSBACKDOOR: CUSTOMIZAÇÃO GUI (ESTÉTICA/COMPORTAMENTAL)
        %-----------------------------------------------------------------%
        function jsBackDoor_Initialization(app)
            if app.isDocked
                delete(app.jsBackDoor)
                app.jsBackDoor = app.mainApp.jsBackDoor;
            else
                app.jsBackDoor.HTMLSource = appUtil.jsBackDoorHTMLSource();
            end            
        end

        %-----------------------------------------------------------------%
        function jsBackDoor_Customizations(app)
            if app.isDocked
                app.progressDialog = app.mainApp.progressDialog;
            else
                app.progressDialog = ccTools.ProgressDialog(app.jsBackDoor);

                sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mw-theme-light',                                                   ...
                                                                                       'classAttributes', ['--mw-backgroundColor-dataWidget-selected: rgb(180 222 255 / 45%); ' ...
                                                                                                           '--mw-backgroundColor-selected: rgb(180 222 255 / 45%); '            ...
                                                                                                           '--mw-backgroundColor-selectedFocus: rgb(180 222 255 / 45%);']));
    
                sendEventToHTMLSource(app.jsBackDoor, 'htmlClassCustomization', struct('className',        '.mw-default-header-cell', ...
                                                                                       'classAttributes',  'font-size: 10px; white-space: pre-wrap; margin-bottom: 5px;'));
            end

            ccTools.compCustomizationV2(app.jsBackDoor, app.AdditionalDescription, 'textAlign', 'justify')
            ccTools.compCustomizationV2(app.jsBackDoor, app.TXGrid,    'backgroundColor', 'transparent')
            ccTools.compCustomizationV2(app.jsBackDoor, app.TXPanel,   'backgroundColor', 'rgba(0,0,0,0.5)')
            ccTools.compCustomizationV2(app.jsBackDoor, app.TXSubGrid, 'backgroundColor', 'transparent')
        end
    end
    

    methods (Access = private)
        %-----------------------------------------------------------------%
        % INICIALIZAÇÃO
        %-----------------------------------------------------------------%
        function startup_timerCreation(app, idxPrjPeaks)            
            % A criação desse timer tem como objetivo garantir uma renderização 
            % mais rápida dos componentes principais da GUI, possibilitando a 
            % visualização da sua tela inicialpelo usuário. Trata-se de aspecto 
            % essencial quando o app é compilado como webapp.

            app.timerObj = timer("ExecutionMode", "fixedSpacing", ...
                                 "StartDelay",    1.5,            ...
                                 "Period",        .1,             ...
                                 "TimerFcn",      @(~,~)app.startup_timerFcn(idxPrjPeaks));
            start(app.timerObj)
        end

        %-----------------------------------------------------------------%
        function startup_timerFcn(app, idxPrjPeaks)
            if ccTools.fcn.UIFigureRenderStatus(app.UIFigure)
                stop(app.timerObj)
                delete(app.timerObj)                
                startup_Controller(app, idxPrjPeaks)
            end
        end

        %-----------------------------------------------------------------%
        function startup_Controller(app, idxPrjPeaks)
            drawnow

            % Customiza as aspectos estéticos de alguns dos componentes da GUI 
            % (diretamente em JS).
            jsBackDoor_Customizations(app)

            % Define tamanho mínimo do app (não aplicável à versão webapp).
            if ~strcmp(app.mainApp.executionMode, 'webApp') && ~app.isDocked
                appUtil.winMinSize(app.UIFigure, class.Constants.windowMinSize)
            end

            app.progressDialog.Visible = 'visible';

            % Criação do eixo e leitura dos dados...
            startup_AppProperties(app)
            startup_GUIComponents(app)
            startup_Axes(app)
            drawnow

            pause(.100)
            % renderProjectDataOnScreen(app, idxPrjPeaks)
            focus(app.UITable)

            app.progressDialog.Visible = 'hidden';
        end

        %-----------------------------------------------------------------%
        function startup_AppProperties(app)
            app.tempBandObj = class.Band('appAnalise:SIGNALANALYSIS', app);
        end

        %-----------------------------------------------------------------%
        function startup_GUIComponents(app)
            app.axesTool_Pan.UserData    = false;
            app.axesTool_Config.UserData = false;
        end

        %-----------------------------------------------------------------%
        function startup_Axes(app)
            % Axes creation:
            hParent     = tiledlayout(app.plotPanel, 1, 3, "Padding", "compact", "TileSpacing", "compact");
            app.UIAxes2 = plot.axes.Creation(hParent, 'Cartesian', {'XGrid', 'off', 'XMinorGrid', 'off',                           ...
                                                                    'YGrid', 'off', 'YMinorGrid', 'off', 'YAxisLocation', "right", ...
                                                                    'Clipping', 'off'});
            app.UIAxes2.Layout.Tile = 2;
            app.UIAxes2.Layout.TileSpan = [1 2];
            app.UIAxes2.XAxis.TickLabelFormat = '%.1f';

            app.UIAxes1 = plot.axes.Creation(hParent, 'Cartesian', {'XGrid', 'off', 'XMinorGrid', 'off', ...
                                                                    'YGrid', 'off', 'YMinorGrid', 'off', ...
                                                                    'Box', 'on', 'TickDir', 'none'});

            % Axes fixed labels:
            xlabel(app.UIAxes1, 'Frequência (MHz)')
            ylabel(app.UIAxes1, 'Nível (dB)')

            xlabel(app.UIAxes2, 'Distância (km)')
            ylabel(app.UIAxes2, 'Elevação (m)')

            % Axes interactions:
            plot.axes.Interactivity.DefaultCreation(app.UIAxes1, [dataTipInteraction, regionZoomInteraction])
            plot.axes.Interactivity.DefaultCreation(app.UIAxes2, [dataTipInteraction, regionZoomInteraction])
        end

        %-----------------------------------------------------------------%
        function layout_Regulatory(app)
            switch app.Regulatory.Value
                case 'Licenciada'
                    set(app.Type, 'Value', 'Fundamental', 'Enable', 0)
                    app.TypeLabel.Enable   = 0;    
                    set(app.Compliance, 'Items', {'Não', 'Sim'}, 'Value', 'Não')

                case {'Não licenciada', 'Não passível de licenciamento'}    
                    app.Type.Enable      = 1;
                    app.TypeLabel.Enable = 1;
                    app.StationID.Value  = '-1';
    
                    switch app.Regulatory.Value
                        case 'Não licenciada'
                            app.Compliance.Items = {'Sim'};                            
                        case 'Não passível de licenciamento'
                            set(app.Compliance, 'Items', {'Não', 'Sim'}, 'Value', 'Não')
                    end
            end
        end

        %-----------------------------------------------------------------%
        function layout_Compliance(app)
            if strcmp(app.Compliance.Value, 'Não')
                set(app.RiskLevel,      'Enable', 0, 'Items', {'-'})
                set(app.RiskLevelLabel, 'Enable', 0)
            else
                set(app.RiskLevel,      'Enable', 1, 'Items', {'Baixo', 'Médio', 'Alto'})
                set(app.RiskLevelLabel, 'Enable', 1)
            end
        end

        %-----------------------------------------------------------------%
        function layout_TableStyle(app)
            removeStyle(app.UITable)
                
            idxEditedPeaks = [];
            idxInvalidStationNumber = [];
            if ~isempty(app.projectData.exceptionList)
                for ii = 1:height(app.projectData.exceptionList)
                    idxRelatedPeaks = find(strcmp(app.projectData.peaksTable.Tag, app.projectData.exceptionList.Tag(ii)) & (abs(app.projectData.peaksTable.Frequency - app.projectData.exceptionList.Frequency(ii)) <= class.Constants.floatDiffTolerance));
                    idxEditedPeaks = [idxEditedPeaks; idxRelatedPeaks];

                    if app.projectData.exceptionList.Station(ii) == -1
                        idxInvalidStationNumber = [idxInvalidStationNumber; idxRelatedPeaks];
                    end
                end
                
                if ~isempty(idxEditedPeaks)
                    listOfCells1 = [idxEditedPeaks, ones(numel(idxEditedPeaks), 1)];
                    addStyle(app.UITable, uistyle('Icon', 'Edit_32.png',  'IconAlignment', 'leftmargin'), 'cell', listOfCells1) 
                end
            end

            idxInvalidStationNumber = unique([idxInvalidStationNumber; find(app.projectData.peaksTable.Station == -1)]);
            if ~isempty(idxInvalidStationNumber)
                listOfCells2 = [idxInvalidStationNumber, repmat(2, numel(idxInvalidStationNumber), 1)];
                addStyle(app.UITable, uistyle('Icon', 'Circle_18Red.png',  'IconAlignment', 'leftmargin'), 'cell', listOfCells2) 
            end
        end


        %-----------------------------------------------------------------%
        function userDescription = UserDescriptionParser(app)
            userDescription = strtrim(app.AdditionalDescription.Value);
            userDescription(cellfun(@(x) isempty(x), userDescription)) = [];
            userDescription = strjoin(userDescription);
        end
        
        %-----------------------------------------------------------------%
        function FillComponents(app)
            global RFDataHub

            idxPrjPeaks     = app.UITable.Selection;
            idxPrjException = exceptionListIndex(app);
            [idxThread, ...
             idxEmission]   = specDataIndex(app, idxPrjPeaks);

            [htmlContent,     ...
             emissionTag,     ...
             userDescription, ...
             stationInfo]   = auxApp.signalanalysis.htmlCode_EmissionInfo(app.specData, idxThread, idxEmission, app.projectData, idxPrjPeaks, idxPrjException);

            app.selectedEmissionInfo.HTMLSource = htmlContent;
            set(app.AdditionalDescription, 'Value', userDescription, 'UserData', userDescription) 

            % TABLE CONTEXT MENU
            if app.specData(idxThread).UserData.Emissions.isTruncated(idxEmission)
                app.ContextMenu_analogEmission.Enable  = 1;
                app.ContextMenu_digitalEmission.Enable = 0;
            else
                app.ContextMenu_analogEmission.Enable  = 0;
                app.ContextMenu_digitalEmission.Enable = 1;
            end

            % CONTROL PANEL
            if isempty(idxPrjException)
                app.DelAnnotation.Visible = 0;
                app.Regulatory.Value      = app.projectData.peaksTable.Regulatory{idxPrjPeaks};
                layout_Regulatory(app)
                app.StationID.Value       = num2str(app.projectData.peaksTable.Station(idxPrjPeaks));                
                app.Type.Value            = app.projectData.peaksTable.Type{idxPrjPeaks};
                app.Compliance.Value      = app.projectData.peaksTable.Irregular{idxPrjPeaks};
                layout_Compliance(app)
                app.RiskLevel.Value       = app.projectData.peaksTable.RiskLevel{idxPrjPeaks};
                
            else
                app.DelAnnotation.Visible = 1;
                app.Regulatory.Value      = app.projectData.exceptionList.Regulatory(idxPrjException);
                layout_Regulatory(app)
                app.StationID.Value       = num2str(app.projectData.exceptionList.Station(idxPrjException));
                app.Type.Value            = app.projectData.exceptionList.Type(idxPrjException);
                app.Compliance.Value      = app.projectData.exceptionList.Irregular(idxPrjException);
                layout_Compliance(app)
                app.RiskLevel.Value       = app.projectData.exceptionList.RiskLevel(idxPrjException);
            end

            % PLOT CONFIG PANEL
            idxStation = [];
            if ~isempty(stationInfo.ID)
                idx = stationInfo.ID;

                if RFDataHub.Fistel(idx)  == stationInfo.Fistel  && ...
                   RFDataHub.Service(idx) == stationInfo.Service && ...
                   RFDataHub.Station(idx) == stationInfo.Station
                    idxStation = idx;
                
                else
                    idxStation = find((RFDataHub.Fistel(idx)  == stationInfo.Fistel                                                 && ...
                                       RFDataHub.Service(idx) == stationInfo.Service                                                && ...
                                       RFDataHub.Station(idx) == stationInfo.Station                                                && ...
                                       abs(RFDataHub.Latitude(idx)  - stationInfo.Latitude)  <=  class.Constants.floatDiffTolerance && ...
                                       abs(RFDataHub.Longitude(idx) - stationInfo.Longitude) <=  class.Constants.floatDiffTolerance), 1);
                end
            end
            app.axesTool_redrawPlot.UserData = idxStation;

            if ~isempty(idxStation)                
                app.TXLatitude.Value  = round(double(RFDataHub.Latitude(idxStation)),  6);
                app.TXLongitude.Value = round(double(RFDataHub.Longitude(idxStation)), 6);

                txAntennaHeight = str2double(char(RFDataHub.AntennaHeight(idxStation)));
                if txAntennaHeight < 0
                    txAntennaHeight = app.General.RFDataHub.DefaultTX.Height;
                end
                app.TXHeight.Value = txAntennaHeight;
            else
                app.TXLatitude.Value  = -1;
                app.TXLongitude.Value = -1;
                app.TXHeight.Value    = app.General.RFDataHub.DefaultTX.Height;
            end

            % PLOT
            plot_createSpectrumPlot(app, idxPrjPeaks, idxThread, idxEmission, emissionTag)
            plot_createRFLinkPlot(app, idxPrjPeaks, idxThread, idxStation)
        end

        %-----------------------------------------------------------------%
        function plot_createSpectrumPlot(app, idxPrjPeaks, idxThread, idxEmission, emissionTag)
            cla(app.UIAxes1)
            if ~isempty(idxThread) && ~isempty(idxEmission)
                % pre-Plot (XLim, YLim, YLabel)
                axesLimits = update(app.tempBandObj, idxThread, idxEmission);
                app.restoreView(1) = struct('ID', 'app.UIAxes1', 'xLim', axesLimits.xLim, 'yLim', axesLimits.yLevelLim, 'cLim', 'auto');
                set(app.UIAxes1, 'XLim', app.restoreView(1).xLim, 'YLim', app.restoreView(1).yLim)

                ylabel(app.UIAxes1, sprintf('Nível (%s)', app.tempBandObj.LevelUnit))
                ysecondarylabel(app.UIAxes1, [app.projectData.peaksTable.Tag{idxPrjPeaks} ' @ ' emissionTag])

                % Plot "MinHold", "Average" e "MaxHold"
                for plotTag = ["MinHold", "Average", "MaxHold"]
                    eval(sprintf('hLine = plot.draw2D.OrdinaryLine(app.UIAxes1, app.tempBandObj, idxThread, "%s");', plotTag))
                    plot.datatip.Template(hLine, "Frequency+Level", app.tempBandObj.LevelUnit)
                end

                % Plot "ROI"
                plot.draw2D.rectangularROI(app.UIAxes1, app.tempBandObj, app.specData(idxThread).UserData.Emissions, idxEmission, 'EmissionROI', {'EdgeAlpha', 0, 'InteractionsAllowed', 'none'})

            else
                msgWarning = 'Não identificado o fluxo de dados relacionado à emissão...';
                appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
            end
        end

        %-----------------------------------------------------------------%
        function plot_createRFLinkPlot(app, idxPrjPeaks, idxThread, idxStation)
            try
                % OBJETOS TX e RX
                [txObj, rxObj] = RFLinkObjects(app, idxPrjPeaks, idxThread, idxStation);
    
                % ELEVAÇÃO DO LINK TX-RX
                [wayPoints3D, msgWarning] = Get(app.elevationObj, txObj, rxObj, app.General.Elevation.Points, app.General.Elevation.ForceSearch, app.General.Elevation.Server);
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
        function [txSite, rxSite] = RFLinkObjects(app, idxPrjPeaks, idxThread, idxStation)
            if isempty(idxStation)
                error('winSignalAnalysis:RFLinkObjects:UnexpectedEmptyIndex', 'Unexpected empty index')
            end

            % txSite e rxSite estão como struct, mas basta mudar para "txsite" e 
            % "rxsite" que eles poderão ser usados em predições, uma vez que os 
            % campos da estrutura são idênticos às propriedades dos objetos.

            % TX
            txSite = struct('Name',                 'TX',                                                             ...
                            'TransmitterFrequency', double(app.projectData.peaksTable.Truncated(idxPrjPeaks) * 1e+6), ...
                            'Latitude',             app.TXLatitude.Value,                                             ...
                            'Longitude',            app.TXLongitude.Value,                                            ...
                            'AntennaHeight',        app.TXHeight.Value);

            % RX
            rxSite = struct('Name',                 'RX',                                  ...
                            'Latitude',             app.specData(idxThread).GPS.Latitude,  ...
                            'Longitude',            app.specData(idxThread).GPS.Longitude, ...
                            'AntennaHeight',        AntennaHeight(app.specData, idxThread, 10));
        end

        %-----------------------------------------------------------------%
        function AddException(app, stationInfo, triggeredComponent)
            idxPrjPeaks     = app.UITable.Selection;
            idxPrjException = exceptionListIndex(app);
            [idxThread, ...
             idxEmission]   = specDataIndex(app, idxPrjPeaks);
            userDescription = UserDescriptionParser(app);

            if ~strcmp(app.projectData.peaksTable.Regulatory{idxPrjPeaks}, app.Regulatory.Value)  || ...
               app.projectData.peaksTable.Station(idxPrjPeaks) ~= str2double(app.StationID.Value) || ...
               ~strcmp(app.projectData.peaksTable.Type{idxPrjPeaks},      app.Type.Value)         || ...
               ~strcmp(app.projectData.peaksTable.Irregular{idxPrjPeaks}, app.Compliance.Value)   || ...
               ~strcmp(app.projectData.peaksTable.RiskLevel{idxPrjPeaks}, app.RiskLevel.Value)    || ...
               ~strcmp(userDescription, app.AdditionalDescription.UserData)
    
                % Modificação direta de app.StationID.Value ocasionará num 
                % registro relacionado a uma estação "Licenciada" ou "Não 
                % licenciada" (extraída de base aeronáutica). Neste caso, 
                % "stationInfo" é uma estrutura não vazia.

                % Caso a modificação tenha sido em outro campo, a alteração
                % somente terá efeito se o campo "Informações complementares"
                % estiver preenchido!          
                switch triggeredComponent
                    case app.StationID
                        switch stationInfo.Service 
                            case -1
                                newRegulatory = 'Não licenciada';
                                newCompliance = 'Sim';
                                newRiskLevel  = 'Baixo';
                            otherwise
                                newRegulatory = 'Licenciada';
                                newCompliance = 'Não';
                                newRiskLevel  = '-';
                        end    
                        exceptionValue = {app.projectData.peaksTable.Tag{idxPrjPeaks},       ...
                                          app.projectData.peaksTable.Frequency(idxPrjPeaks), ...
                                          'Fundamental',                                     ...
                                          newRegulatory,                                     ...
                                          stationInfo.Service,                               ...
                                          stationInfo.Station,                               ...
                                          stationInfo.Description,                           ...
                                          sprintf('%.1f', stationInfo.Distance),             ...
                                          newCompliance,                                     ...
                                          newRiskLevel};
                        AddExceptionValue2Table(app, idxPrjException, exceptionValue)

                    case app.AdditionalDescription
                        if ~isempty(idxThread) && ~isempty(idxEmission)
                            if ~strcmp(userDescription, app.AdditionalDescription.UserData)                                
                                app.specData(idxThread).UserData.Emissions.UserData(idxEmission).Description = userDescription;
                                ipcMainMatlabCallsHandler(app.mainApp, app, 'PeakDescriptionChanged')
                            end
                        end

                    otherwise
                        exceptionValue = {app.projectData.peaksTable.Tag{idxPrjPeaks},       ...
                                          app.projectData.peaksTable.Frequency(idxPrjPeaks), ...
                                          app.Type.Value,                                    ...
                                          app.Regulatory.Value,                              ...
                                          [], [], [], [],                                    ...
                                          app.Compliance.Value,                              ...
                                          app.RiskLevel.Value};
        
                        switch app.Regulatory.Value
                            case 'Licenciada'
                                if isempty(idxPrjException)
                                    exceptionValue(5:8) = {app.projectData.peaksTable.Service(idxPrjPeaks),     ...
                                                           app.projectData.peaksTable.Station(idxPrjPeaks),     ...
                                                           app.projectData.peaksTable.Description{idxPrjPeaks}, ...
                                                           app.projectData.peaksTable.Distance{idxPrjPeaks}};
                                else
                                    exceptionValue(5:8) = {app.projectData.exceptionList.Service(idxPrjException),     ...
                                                           app.projectData.exceptionList.Station(idxPrjException),     ...
                                                           app.projectData.exceptionList.Description{idxPrjException}, ...
                                                           app.projectData.exceptionList.Distance{idxPrjException}};
                                end
    
                            otherwise
                                exceptionValue(5:8) = {-1, -1, '[EXC]', '-'};
                        end
                        AddExceptionValue2Table(app, idxPrjException, exceptionValue)
                end

                layout_TableStyle(app)            
                FillComponents(app)
            end
        end

        %-----------------------------------------------------------------%
        function AddExceptionValue2Table(app, idxPrjException, exceptionValue)
            if isempty(idxPrjException)
                app.projectData.exceptionList(end+1,:)           = exceptionValue;
            else
                app.projectData.exceptionList(idxPrjException,:) = exceptionValue;
            end
        end

        %-----------------------------------------------------------------%
        function [idxThread, idxEmission] = specDataIndex(app, idxPrjPeaks)
            idxThread   = [];
            idxEmission = [];

            for ii = 1:numel(app.specData)
                Tag = sprintf('%s\n%.3f - %.3f MHz', app.specData(ii).Receiver,                  ...
                                                     app.specData(ii).MetaData.FreqStart / 1e+6, ...
                                                     app.specData(ii).MetaData.FreqStop  / 1e+6);
                if strcmp(Tag, app.projectData.peaksTable.Tag{idxPrjPeaks})
                    idxThread   = ii;
                    idxEmission = find(app.specData(idxThread).UserData.Emissions.Index == app.projectData.peaksTable.Index(idxPrjPeaks), 1);
                    break
                end
            end
        end

        %-----------------------------------------------------------------%
        function idxPrjException = exceptionListIndex(app)
            idxPrjPeaks     = app.UITable.Selection;
            idxPrjException = intersect(find(strcmp(app.projectData.exceptionList.Tag,  app.projectData.peaksTable.Tag(idxPrjPeaks))), ...
                                        find(abs(app.projectData.exceptionList.Frequency - app.projectData.peaksTable.Frequency(idxPrjPeaks)) <= class.Constants.floatDiffTolerance));

            if ~isempty(idxPrjException)
                idxPrjException = idxPrjException(1);
            end
        end
    end


    methods (Access = public)
        %-----------------------------------------------------------------%
        function renderProjectDataOnScreen(app, idxPrjPeaks)
            if isempty(app.projectData.peaksTable)
                closeFcn(app)
                return
            end

            if idxPrjPeaks > height(app.projectData.peaksTable)
                idxPrjPeaks = height(app.projectData.peaksTable);
            end

            if app.progressDialog.Visible == "visible"
                progressDialogAlreadyVisible = true;
            else
                progressDialogAlreadyVisible = false;
                app.progressDialog.Visible = 'visible';
            end

            % !! PONTO DE EVOLUÇÃO !!
            % Converter para string, controlando o número de casas decimais, 
            % apenas na geração do relatório. De resto, manter como numérico 
            % para garantir coerência nas operações com a tabela (como a 
            % filtragem).
            tempData           = app.projectData.peaksTable(:, {'Frequency', 'Truncated', 'BW', 'minLevel', 'meanLevel', 'maxLevel', 'meanOCC', 'maxOCC', 'Tag'});
            tempData.BW        = int32(tempData.BW);
            tempData.minLevel  = str2double(tempData.minLevel);
            tempData.meanLevel = str2double(tempData.meanLevel);
            tempData.maxLevel  = str2double(tempData.maxLevel);
            tempData.meanOCC   = str2double(tempData.meanOCC);
            tempData.maxOCC    = str2double(tempData.maxOCC);
            % !! PONTO DE EVOLUÇÃO !!

            set(app.tableInfoNRows, 'Text', sprintf('# %d', height(tempData)), 'Visible', 1)
            set(app.UITable, 'Data', tempData, 'Selection', idxPrjPeaks)
            layout_TableStyle(app)
            FillComponents(app)

            if ~progressDialogAlreadyVisible
                app.progressDialog.Visible = 'hidden';
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainApp, idxPrjPeaks)
            
            app.mainApp     = mainApp;
            app.General     = mainApp.General;
            app.General_I   = mainApp.General_I;
            app.rootFolder  = mainApp.rootFolder;
            app.specData    = mainApp.specData;
            app.projectData = mainApp.projectData;

            jsBackDoor_Initialization(app)

            if app.isDocked
                app.GridLayout.Padding(4) = 19;
                startup_Controller(app, idxPrjPeaks)
            else
                appUtil.winPosition(app.UIFigure)
                startup_timerCreation(app, idxPrjPeaks)
            end
            
        end

        % Close request function: UIFigure
        function closeFcn(app, event)
            
            ipcMainMatlabCallsHandler(app.mainApp, app, 'closeFcn')
            delete(app)
            
        end

        % Image clicked function: tool_ControlPanelVisibility, 
        % ...and 2 other components
        function toolbarCallbacks(app, event)
            
            focus(app.jsBackDoor)

            switch event.Source
                %---------------------------------------------------------%
                case app.tool_ShowGlobalExceptionList
                    exceptionGlobalList = app.mainApp.channelObj.Exception;        
                    if isempty(exceptionGlobalList)
                        msgWarning = 'Não identificada emissão na lista global de exceções contida no arquivo "ChannelLib.json".';        
                    else
                        msgWarning = [];
                        for ii = 1:height(exceptionGlobalList)
                            msgWarning = sprintf('%s\n%s', msgWarning, sprintf('<b>%.3f MHz</b>: "%s"', exceptionGlobalList.FreqCenter(ii), exceptionGlobalList.Description{ii}));
                        end
                    end
                    appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);

                %---------------------------------------------------------%
                case app.tool_ExportJSONFile
                    report.Controller(app, 'signalAnalysis.externalJSON')

                %---------------------------------------------------------%
                case app.tool_ControlPanelVisibility
                    if app.GridLayout.ColumnWidth{4}
                        app.GridLayout.ColumnWidth(3:4) = {0,0};
                        app.tool_ControlPanelVisibility.ImageSource = 'ArrowLeft_32.png';
                    else
                        app.GridLayout.ColumnWidth(3:4) = {10,320};
                        app.tool_ControlPanelVisibility.ImageSource = 'ArrowRight_32.png';
                    end
            end

        end

        % Image clicked function: axesTool_Config, axesTool_Pan, 
        % ...and 2 other components
        function axesToolbarCallbacks(app, event)
            
            switch event.Source
                case app.axesTool_RestoreView
                    plot.axes.Interactivity.CustomRestoreViewFcn(app.UIAxes1, app.UIAxes2, app)
                
                case app.axesTool_Pan
                    app.axesTool_Pan.UserData = ~app.axesTool_Pan.UserData;
                    if app.axesTool_Pan.UserData
                        app.axesTool_Pan.ImageSource = 'Pan_32Filled.png';
                    else
                        app.axesTool_Pan.ImageSource = 'Pan_32.png';
                    end

                    plot.axes.Interactivity.CustomPanFcn(struct('Value', app.axesTool_Pan.UserData), app.UIAxes1, app.UIAxes2);

                case app.axesTool_redrawPlot
                    idxPrjPeaks = app.UITable.Selection;
                    idxThread   = specDataIndex(app, idxPrjPeaks);
                    idxStation  = app.axesTool_redrawPlot.UserData;
                    if isempty(idxStation)
                        idxStation = -1;
                    end

                    plot_createRFLinkPlot(app, idxPrjPeaks, idxThread, idxStation)

                case app.axesTool_Config
                    app.axesTool_Config.UserData = ~app.axesTool_Config.UserData;
                    if app.axesTool_Config.UserData
                        app.TXGrid.Visible = 1;
                        %app.Document.ColumnWidth{4} = 260;
                    else
                        app.TXGrid.Visible = 0;
                        %app.Document.ColumnWidth{4} = 0;
                    end
            end

        end

        % Selection changed function: UITable
        function UITableSelectionValueChanged(app, event)

            if isempty(event.Selection)
                app.UITable.Selection = event.PreviousSelection;
            else
                FillComponents(app)
            end
            
        end

        % Menu selected function: ContextMenu_analogEmission, 
        % ...and 2 other components
        function UITableContextMenuClicked(app, event)
            
            if ~isempty(app.UITable.Selection)
                app.progressDialog.Visible = 'visible';

                idxPrjPeaks   = app.UITable.Selection;
                [idxThread, ...
                 idxEmission] = specDataIndex(app, idxPrjPeaks);

                switch event.Source
                    case app.ContextMenu_deleteEmission
                        operationType = 'DeleteButtonPushed';
                        app.specData(idxThread).UserData.Emissions(idxEmission,:) = [];
                        idxEmission = 1;

                    case app.ContextMenu_digitalEmission
                        operationType = 'PeakValueChanged';
                        app.specData(idxThread).UserData.Emissions.isTruncated(idxEmission) = 1;

                    case app.ContextMenu_analogEmission
                        operationType = 'PeakValueChanged';
                        app.specData(idxThread).UserData.Emissions.isTruncated(idxEmission) = 0;
                end
                
                ipcMainMatlabCallsHandler(app.mainApp, app, operationType, idxThread, idxEmission)

                % Ao excluir emissões diretamente deste módulo, chegando ao
                % limite de não ter emissões, o módulo será fechado. A validação 
                % a seguir evita erro.
                if isvalid(app)
                    figure(app.UIFigure)
                    app.progressDialog.Visible = 'hidden';
                end
            end

        end

        % Value changed function: StationID
        function StationIDValueChanged(app, event)
            
            global RFDataHub

            try
                app.StationID.Value = strtrim(app.StationID.Value);
                if isempty(regexp(app.StationID.Value, '^\#?\d+$', 'once'))
                    error(['Esse campo deve ser preenchido com o número da estação ou a ID do registro no RFDataHub. ' ...
                           'O seu formato é numérico, com a ressalva de que quando inserido a ID do registro '         ...
                           'deve ser colocado o caractere "#" à frente do número. Por exemplo: 123456 ou #123456.'])
                end
                
                idxPrjPeaks   = app.UITable.Selection;
                latitudeNode  = app.projectData.peaksTable.Latitude(idxPrjPeaks);
                longitudeNode = app.projectData.peaksTable.Longitude(idxPrjPeaks);
                stationInfo   = class.RFDataHub.query(RFDataHub, app.StationID.Value, latitudeNode, longitudeNode);

                dataStruct(1) = struct('group', 'INDICAÇÃO AUTOMÁTICA',                                                                          ...
                                        'value', struct('Regulatory',  app.projectData.peaksTable.Regulatory{idxPrjPeaks},                     ...
                                                        'Frequency',   sprintf('%.3f MHz', app.projectData.peaksTable.Frequency(idxPrjPeaks))));
                
                if app.projectData.peaksTable.Regulatory{idxPrjPeaks} == "Licenciada"
                    dataStruct(1).value.Description = app.projectData.peaksTable.Description{idxPrjPeaks};
                    dataStruct(1).value.Distance    = sprintf('%s km', app.projectData.peaksTable.Distance{idxPrjPeaks});
                end

                switch stationInfo.Service
                    case -1
                        emissionRegulatory = '<font style="color: #c94756;">Não Licenciada</font>';
                    otherwise
                        emissionRegulatory = 'Licenciada';
                end
                dataStruct(2)  = struct('group', 'MANUAL',                                                       ...
                                        'value', struct('Regulatory',  emissionRegulatory,                       ...
                                                        'Frequency',   sprintf('%s MHz', stationInfo.Frequency), ...
                                                        'Description', stationInfo.Description,                  ...
                                                        'Distance',    sprintf('%.1f km', stationInfo.Distance)));

                msgQuestion    = sprintf('%s<br><font style="font-size: 12px;">Confirma edição?<font>', textFormatGUI.struct2PrettyPrintList(dataStruct));
                userSelection  = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                switch userSelection
                    case 'Sim'
                        AddException(app, stationInfo, app.StationID)
                    case 'Não'
                        app.StationID.Value = num2str(app.projectData.peaksTable.Station(idxPrjPeaks));
                end

            catch ME
                app.StationID.Value = num2str(app.projectData.peaksTable.Station(idxPrjPeaks));                
                appUtil.modalWindow(app.UIFigure, 'warning', getReport(ME));
            end
            
        end

        % Value changed function: Regulatory
        function RegulatoryValueChanged(app, event)
            
            switch event.Value
                case 'Licenciada'
                    app.Regulatory.Value = event.PreviousValue;
    
                    msgWarning = ['A alteração da situção de uma emissão para "Licenciada" deve ser feita diretamente no ' ...
                                  'campo "Estação / ID", inserindo o número da estação ou a ID do registro no RFDataHub. ' ...
                                  'O seu formato é numérico, com a ressalva de que quando inserido a ID do registro '      ...
                                  'deve ser colocado o caractere "#" à frente do número. Por exemplo: 123456 ou #123456.'];
                    appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                    return

                otherwise % case {'Não licenciada', 'Não passível de licenciamento'}
                    userDescription = UserDescriptionParser(app);
                    if isempty(userDescription)
                        app.Regulatory.Value = event.PreviousValue;
    
                        msgWarning = ['O campo "Informações complementares" não pode ficar vazio para registros ' ...
                                      'relacionados a uma estação "Não licenciada" ou "Não passível de licenciamento".'];
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                        return
                    end
            end

            layout_Regulatory(app)
            OthersParametersValueChanged(app, struct('Source', app.Compliance))
            
        end

        % Value changed function: AdditionalDescription, Compliance, 
        % ...and 2 other components
        function OthersParametersValueChanged(app, event)
            
            switch event.Source
                case app.Compliance
                    layout_Compliance(app)

                case {app.Type, app.RiskLevel}
                    % Algo?! Acho que não. Apenas atualização do registro
                    % da exceção...

                case app.AdditionalDescription
                    userDescription = UserDescriptionParser(app);
                    if isempty(userDescription) && ~strcmp(app.Regulatory.Value, 'Licenciada')
                        app.AdditionalDescription.Value = event.PreviousValue;
    
                        msgWarning = ['O campo "Informações complementares" não pode ficar vazio para registros ' ...
                                      'relacionados a uma estação "Não licenciada" ou "Não passível de licenciamento".'];
                        appUtil.modalWindow(app.UIFigure, 'warning', msgWarning);
                        return
                    end

                    app.AdditionalDescription.Value = userDescription;
            end

            AddException(app, [], event.Source)

        end

        % Image clicked function: DelAnnotation
        function DeleteException(app, event)
            
            idxPrjException = exceptionListIndex(app);
            app.projectData.exceptionList(idxPrjException,:) = [];

            layout_TableStyle(app)            
            FillComponents(app)

        end

        % Value changed function: TXHeight, TXLatitude, TXLongitude
        function TXParameterValueChanged(app, event)
            
            app.axesTool_redrawPlot.Enable = 1;
            
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
                if ~isprop(Container, 'RunningAppInstance')
                    addprop(app.Container, 'RunningAppInstance');
                end
                app.Container.RunningAppInstance = app;
                app.isDocked  = true;
            end

            % Create GridLayout
            app.GridLayout = uigridlayout(app.Container);
            app.GridLayout.ColumnWidth = {5, '1x', 10, 320, 5};
            app.GridLayout.RowHeight = {5, '1x', 5, 34};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.BackgroundColor = [1 1 1];

            % Create Document
            app.Document = uigridlayout(app.GridLayout);
            app.Document.ColumnWidth = {22, 22, '1x', 240};
            app.Document.RowHeight = {63, '1x', 14, 18, 16, 72, 100};
            app.Document.ColumnSpacing = 0;
            app.Document.RowSpacing = 0;
            app.Document.Padding = [0 0 0 0];
            app.Document.Layout.Row = 2;
            app.Document.Layout.Column = 2;
            app.Document.BackgroundColor = [1 1 1];

            % Create tableInfoMetadata
            app.tableInfoMetadata = uilabel(app.Document);
            app.tableInfoMetadata.VerticalAlignment = 'top';
            app.tableInfoMetadata.WordWrap = 'on';
            app.tableInfoMetadata.FontSize = 14;
            app.tableInfoMetadata.Layout.Row = 1;
            app.tableInfoMetadata.Layout.Column = [1 4];
            app.tableInfoMetadata.Interpreter = 'html';
            app.tableInfoMetadata.Text = {'Exibindo emissões relacionadas aos fluxos espectrais a processar'; '<p style="color: #808080; font-size:10px; text-align: justify; margin-right: 2px;">A célula "Frequência (MHz)" apresentará <font style="color: red;">ÍCONE DE EDIÇÃO</font> toda vez que alterada a classificação da emissão. Além disso, a célula "Frequência canal (MHz)" apresentará <font style="color: red;">ÍCONE VERMELHO</font> toda vez que o nº da estação for igual a -1, o que ocorre quando a situação da emissão é "Não licenciada" ou "Não passível de licenciamento", ou quando essa informação não consta na base de dados.</p>'};

            % Create tableInfoNRows
            app.tableInfoNRows = uilabel(app.Document);
            app.tableInfoNRows.HorizontalAlignment = 'right';
            app.tableInfoNRows.VerticalAlignment = 'bottom';
            app.tableInfoNRows.FontSize = 10;
            app.tableInfoNRows.Visible = 'off';
            app.tableInfoNRows.Layout.Row = 1;
            app.tableInfoNRows.Layout.Column = [3 4];
            app.tableInfoNRows.Text = '# 0 ';

            % Create UITable
            app.UITable = uitable(app.Document);
            app.UITable.ColumnName = {'FREQUÊNCIA (MHz)'; 'FREQUÊNCIA CANAL (MHz)'; 'LARGURA OCUPADA (kHz)'; 'NÍVEL MÍNIMO (dB)'; 'NÍVEL MÉDIO (dB)'; 'NÍVEL MÁXIMO (dB)'; 'OCUPAÇÃO MÉDIA (%)'; 'OCUPAÇÃO MÁXIMA (%)'; 'TAG'};
            app.UITable.ColumnWidth = {110, 110, 110, 110, 110, 110, 110, 110, 'auto'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = true;
            app.UITable.SelectionType = 'row';
            app.UITable.SelectionChangedFcn = createCallbackFcn(app, @UITableSelectionValueChanged, true);
            app.UITable.Multiselect = 'off';
            app.UITable.Layout.Row = 2;
            app.UITable.Layout.Column = [1 4];
            app.UITable.FontSize = 10;

            % Create axesTool_RestoreView
            app.axesTool_RestoreView = uiimage(app.Document);
            app.axesTool_RestoreView.ImageClickedFcn = createCallbackFcn(app, @axesToolbarCallbacks, true);
            app.axesTool_RestoreView.Tooltip = {'RestoreView'};
            app.axesTool_RestoreView.Layout.Row = 4;
            app.axesTool_RestoreView.Layout.Column = 1;
            app.axesTool_RestoreView.ImageSource = 'Home_18.png';

            % Create axesTool_Pan
            app.axesTool_Pan = uiimage(app.Document);
            app.axesTool_Pan.ImageClickedFcn = createCallbackFcn(app, @axesToolbarCallbacks, true);
            app.axesTool_Pan.Tooltip = {'Pan'};
            app.axesTool_Pan.Layout.Row = 4;
            app.axesTool_Pan.Layout.Column = 2;
            app.axesTool_Pan.ImageSource = 'Pan_32.png';

            % Create axesToolSupport
            app.axesToolSupport = uigridlayout(app.Document);
            app.axesToolSupport.ColumnWidth = {'1x', 16, 16, 16};
            app.axesToolSupport.RowHeight = {'1x'};
            app.axesToolSupport.ColumnSpacing = 5;
            app.axesToolSupport.Padding = [0 0 0 0];
            app.axesToolSupport.Layout.Row = 4;
            app.axesToolSupport.Layout.Column = [3 4];
            app.axesToolSupport.BackgroundColor = [1 1 1];

            % Create axesTool_Warning
            app.axesTool_Warning = uiimage(app.axesToolSupport);
            app.axesTool_Warning.Visible = 'off';
            app.axesTool_Warning.Tooltip = {'Evidenciada obstrução total da 1ª Zona de Fresnel'};
            app.axesTool_Warning.Layout.Row = 1;
            app.axesTool_Warning.Layout.Column = 2;
            app.axesTool_Warning.VerticalAlignment = 'bottom';
            app.axesTool_Warning.ImageSource = 'Warn_18.png';

            % Create axesTool_Config
            app.axesTool_Config = uiimage(app.axesToolSupport);
            app.axesTool_Config.ImageClickedFcn = createCallbackFcn(app, @axesToolbarCallbacks, true);
            app.axesTool_Config.Tooltip = {'Edita parâmetros da estação transmissora'; '(a nova informação não é salva no RFDataHub)'};
            app.axesTool_Config.Layout.Row = 1;
            app.axesTool_Config.Layout.Column = 4;
            app.axesTool_Config.ImageSource = 'Settings_18.png';

            % Create axesTool_redrawPlot
            app.axesTool_redrawPlot = uiimage(app.axesToolSupport);
            app.axesTool_redrawPlot.ImageClickedFcn = createCallbackFcn(app, @axesToolbarCallbacks, true);
            app.axesTool_redrawPlot.Enable = 'off';
            app.axesTool_redrawPlot.Tooltip = {'Recria perfil de terreno para estação transmissora editada'; '(a nova informação não fica atrelada à emissão)'};
            app.axesTool_redrawPlot.Layout.Row = 1;
            app.axesTool_redrawPlot.Layout.Column = 3;
            app.axesTool_redrawPlot.ImageSource = 'Refresh_18.png';

            % Create plotPanel
            app.plotPanel = uipanel(app.Document);
            app.plotPanel.AutoResizeChildren = 'off';
            app.plotPanel.BorderType = 'none';
            app.plotPanel.BackgroundColor = [0 0 0];
            app.plotPanel.Layout.Row = [5 7];
            app.plotPanel.Layout.Column = [1 4];

            % Create TXGrid
            app.TXGrid = uigridlayout(app.Document);
            app.TXGrid.ColumnWidth = {'1x'};
            app.TXGrid.RowHeight = {'1x'};
            app.TXGrid.Padding = [5 5 5 5];
            app.TXGrid.Visible = 'off';
            app.TXGrid.Layout.Row = [5 6];
            app.TXGrid.Layout.Column = 4;
            app.TXGrid.BackgroundColor = [0 0 0];

            % Create TXPanel
            app.TXPanel = uipanel(app.TXGrid);
            app.TXPanel.AutoResizeChildren = 'off';
            app.TXPanel.ForegroundColor = [0.9412 0.9412 0.9412];
            app.TXPanel.Title = 'TX';
            app.TXPanel.BackgroundColor = [0 0 0];
            app.TXPanel.Layout.Row = 1;
            app.TXPanel.Layout.Column = 1;
            app.TXPanel.FontSize = 10;

            % Create TXSubGrid
            app.TXSubGrid = uigridlayout(app.TXPanel);
            app.TXSubGrid.ColumnWidth = {70, 70, '1x'};
            app.TXSubGrid.RowHeight = {17, 22};
            app.TXSubGrid.RowSpacing = 5;
            app.TXSubGrid.Padding = [10 10 10 5];
            app.TXSubGrid.BackgroundColor = [0 0 0];

            % Create TXLatitudeLabel
            app.TXLatitudeLabel = uilabel(app.TXSubGrid);
            app.TXLatitudeLabel.VerticalAlignment = 'bottom';
            app.TXLatitudeLabel.FontSize = 10;
            app.TXLatitudeLabel.FontColor = [0.9412 0.9412 0.9412];
            app.TXLatitudeLabel.Layout.Row = 1;
            app.TXLatitudeLabel.Layout.Column = 1;
            app.TXLatitudeLabel.Text = 'Latitude:';

            % Create TXLatitude
            app.TXLatitude = uieditfield(app.TXSubGrid, 'numeric');
            app.TXLatitude.ValueDisplayFormat = '%.6f';
            app.TXLatitude.ValueChangedFcn = createCallbackFcn(app, @TXParameterValueChanged, true);
            app.TXLatitude.FontSize = 11;
            app.TXLatitude.Layout.Row = 2;
            app.TXLatitude.Layout.Column = 1;

            % Create TXLongitudeLabel
            app.TXLongitudeLabel = uilabel(app.TXSubGrid);
            app.TXLongitudeLabel.VerticalAlignment = 'bottom';
            app.TXLongitudeLabel.FontSize = 10;
            app.TXLongitudeLabel.FontColor = [0.9412 0.9412 0.9412];
            app.TXLongitudeLabel.Layout.Row = 1;
            app.TXLongitudeLabel.Layout.Column = 2;
            app.TXLongitudeLabel.Text = 'Longitude:';

            % Create TXLongitude
            app.TXLongitude = uieditfield(app.TXSubGrid, 'numeric');
            app.TXLongitude.ValueDisplayFormat = '%.6f';
            app.TXLongitude.ValueChangedFcn = createCallbackFcn(app, @TXParameterValueChanged, true);
            app.TXLongitude.FontSize = 11;
            app.TXLongitude.Layout.Row = 2;
            app.TXLongitude.Layout.Column = 2;

            % Create TXHeightLabel
            app.TXHeightLabel = uilabel(app.TXSubGrid);
            app.TXHeightLabel.VerticalAlignment = 'bottom';
            app.TXHeightLabel.FontSize = 10;
            app.TXHeightLabel.FontColor = [0.9412 0.9412 0.9412];
            app.TXHeightLabel.Layout.Row = 1;
            app.TXHeightLabel.Layout.Column = 3;
            app.TXHeightLabel.Text = 'Altura (m):';

            % Create TXHeight
            app.TXHeight = uieditfield(app.TXSubGrid, 'numeric');
            app.TXHeight.Limits = [0 1000];
            app.TXHeight.ValueDisplayFormat = '%.1f';
            app.TXHeight.ValueChangedFcn = createCallbackFcn(app, @TXParameterValueChanged, true);
            app.TXHeight.FontSize = 11;
            app.TXHeight.Layout.Row = 2;
            app.TXHeight.Layout.Column = 3;

            % Create ControlGrid
            app.ControlGrid = uigridlayout(app.GridLayout);
            app.ControlGrid.ColumnWidth = {'1x', 16};
            app.ControlGrid.RowHeight = {58, 5, '1x', 5, 9, 13, 5, 188};
            app.ControlGrid.RowSpacing = 0;
            app.ControlGrid.Padding = [0 0 0 0];
            app.ControlGrid.Layout.Row = 2;
            app.ControlGrid.Layout.Column = 4;
            app.ControlGrid.BackgroundColor = [1 1 1];

            % Create selectedEmissionLabel
            app.selectedEmissionLabel = uilabel(app.ControlGrid);
            app.selectedEmissionLabel.VerticalAlignment = 'bottom';
            app.selectedEmissionLabel.FontSize = 10;
            app.selectedEmissionLabel.Layout.Row = 1;
            app.selectedEmissionLabel.Layout.Column = 1;
            app.selectedEmissionLabel.Text = 'EMISSÃO SELECIONADA';

            % Create selectedEmissionPanel
            app.selectedEmissionPanel = uipanel(app.ControlGrid);
            app.selectedEmissionPanel.AutoResizeChildren = 'off';
            app.selectedEmissionPanel.Layout.Row = 3;
            app.selectedEmissionPanel.Layout.Column = [1 2];

            % Create selectedEmissionGrid
            app.selectedEmissionGrid = uigridlayout(app.selectedEmissionPanel);
            app.selectedEmissionGrid.ColumnWidth = {'1x'};
            app.selectedEmissionGrid.RowHeight = {'1x'};
            app.selectedEmissionGrid.Padding = [0 0 0 0];
            app.selectedEmissionGrid.BackgroundColor = [1 1 1];

            % Create selectedEmissionInfo
            app.selectedEmissionInfo = uihtml(app.selectedEmissionGrid);
            app.selectedEmissionInfo.HTMLSource = ' ';
            app.selectedEmissionInfo.Layout.Row = 1;
            app.selectedEmissionInfo.Layout.Column = 1;

            % Create EditableParametersLabel
            app.EditableParametersLabel = uilabel(app.ControlGrid);
            app.EditableParametersLabel.VerticalAlignment = 'bottom';
            app.EditableParametersLabel.FontSize = 10;
            app.EditableParametersLabel.Layout.Row = [5 6];
            app.EditableParametersLabel.Layout.Column = 1;
            app.EditableParametersLabel.Text = 'PARÂMETROS EDITÁVEIS';

            % Create DelAnnotation
            app.DelAnnotation = uiimage(app.ControlGrid);
            app.DelAnnotation.ImageClickedFcn = createCallbackFcn(app, @DeleteException, true);
            app.DelAnnotation.Tooltip = {'Retorna à classificação automática'};
            app.DelAnnotation.Layout.Row = [6 7];
            app.DelAnnotation.Layout.Column = 2;
            app.DelAnnotation.VerticalAlignment = 'bottom';
            app.DelAnnotation.ImageSource = 'Refresh_18.png';

            % Create EditableParametersPanel
            app.EditableParametersPanel = uipanel(app.ControlGrid);
            app.EditableParametersPanel.AutoResizeChildren = 'off';
            app.EditableParametersPanel.Layout.Row = 8;
            app.EditableParametersPanel.Layout.Column = [1 2];

            % Create EditableParametersGrid
            app.EditableParametersGrid = uigridlayout(app.EditableParametersPanel);
            app.EditableParametersGrid.ColumnWidth = {'1x', '1x', 70, 28, 16, 16};
            app.EditableParametersGrid.RowHeight = {17, 22, 25, 22, 17, 44};
            app.EditableParametersGrid.ColumnSpacing = 5;
            app.EditableParametersGrid.RowSpacing = 5;
            app.EditableParametersGrid.Padding = [10 10 10 5];
            app.EditableParametersGrid.BackgroundColor = [1 1 1];

            % Create RegulatoryLabel
            app.RegulatoryLabel = uilabel(app.EditableParametersGrid);
            app.RegulatoryLabel.VerticalAlignment = 'bottom';
            app.RegulatoryLabel.WordWrap = 'on';
            app.RegulatoryLabel.FontSize = 10;
            app.RegulatoryLabel.FontColor = [0.149 0.149 0.149];
            app.RegulatoryLabel.Layout.Row = 1;
            app.RegulatoryLabel.Layout.Column = 1;
            app.RegulatoryLabel.Text = 'Situação:';

            % Create Regulatory
            app.Regulatory = uidropdown(app.EditableParametersGrid);
            app.Regulatory.Items = {'Licenciada', 'Não licenciada', 'Não passível de licenciamento'};
            app.Regulatory.ValueChangedFcn = createCallbackFcn(app, @RegulatoryValueChanged, true);
            app.Regulatory.FontSize = 11;
            app.Regulatory.FontColor = [0.149 0.149 0.149];
            app.Regulatory.BackgroundColor = [1 1 1];
            app.Regulatory.Layout.Row = 2;
            app.Regulatory.Layout.Column = [1 3];
            app.Regulatory.Value = 'Não passível de licenciamento';

            % Create StationIDLabel
            app.StationIDLabel = uilabel(app.EditableParametersGrid);
            app.StationIDLabel.VerticalAlignment = 'bottom';
            app.StationIDLabel.FontSize = 10;
            app.StationIDLabel.Layout.Row = 1;
            app.StationIDLabel.Layout.Column = [4 6];
            app.StationIDLabel.Text = 'Estação / ID:';

            % Create StationID
            app.StationID = uieditfield(app.EditableParametersGrid, 'text');
            app.StationID.ValueChangedFcn = createCallbackFcn(app, @StationIDValueChanged, true);
            app.StationID.HorizontalAlignment = 'right';
            app.StationID.FontSize = 11;
            app.StationID.Layout.Row = 2;
            app.StationID.Layout.Column = [4 6];

            % Create TypeLabel
            app.TypeLabel = uilabel(app.EditableParametersGrid);
            app.TypeLabel.VerticalAlignment = 'bottom';
            app.TypeLabel.WordWrap = 'on';
            app.TypeLabel.FontSize = 10;
            app.TypeLabel.FontColor = [0.149 0.149 0.149];
            app.TypeLabel.Layout.Row = 3;
            app.TypeLabel.Layout.Column = [1 2];
            app.TypeLabel.Text = {'Tipo de '; 'emissão:'};

            % Create Type
            app.Type = uidropdown(app.EditableParametersGrid);
            app.Type.Items = {'Fundamental', 'Harmônico de fundamental', 'Produto de intermodulação', 'Espúrio', 'Não identificado', 'Não se manifestou', 'Pendente identificação'};
            app.Type.ValueChangedFcn = createCallbackFcn(app, @OthersParametersValueChanged, true);
            app.Type.FontSize = 11;
            app.Type.BackgroundColor = [1 1 1];
            app.Type.Layout.Row = 4;
            app.Type.Layout.Column = [1 2];
            app.Type.Value = 'Pendente identificação';

            % Create ComplianceLabel
            app.ComplianceLabel = uilabel(app.EditableParametersGrid);
            app.ComplianceLabel.VerticalAlignment = 'bottom';
            app.ComplianceLabel.WordWrap = 'on';
            app.ComplianceLabel.FontSize = 10;
            app.ComplianceLabel.FontColor = [0.149 0.149 0.149];
            app.ComplianceLabel.Layout.Row = 3;
            app.ComplianceLabel.Layout.Column = [3 6];
            app.ComplianceLabel.Text = {'Indício de'; 'irregularidade?'};

            % Create Compliance
            app.Compliance = uidropdown(app.EditableParametersGrid);
            app.Compliance.Items = {'Não', 'Sim'};
            app.Compliance.ValueChangedFcn = createCallbackFcn(app, @OthersParametersValueChanged, true);
            app.Compliance.FontSize = 11;
            app.Compliance.FontColor = [0.149 0.149 0.149];
            app.Compliance.BackgroundColor = [1 1 1];
            app.Compliance.Layout.Row = 4;
            app.Compliance.Layout.Column = 3;
            app.Compliance.Value = 'Não';

            % Create RiskLevelLabel
            app.RiskLevelLabel = uilabel(app.EditableParametersGrid);
            app.RiskLevelLabel.VerticalAlignment = 'bottom';
            app.RiskLevelLabel.WordWrap = 'on';
            app.RiskLevelLabel.FontSize = 10;
            app.RiskLevelLabel.FontColor = [0.149 0.149 0.149];
            app.RiskLevelLabel.Layout.Row = 3;
            app.RiskLevelLabel.Layout.Column = [4 6];
            app.RiskLevelLabel.Text = 'Potencial lesivo:';

            % Create RiskLevel
            app.RiskLevel = uidropdown(app.EditableParametersGrid);
            app.RiskLevel.Items = {'-', 'Baixo', 'Médio', 'Alto'};
            app.RiskLevel.ValueChangedFcn = createCallbackFcn(app, @OthersParametersValueChanged, true);
            app.RiskLevel.FontSize = 11;
            app.RiskLevel.FontColor = [0.149 0.149 0.149];
            app.RiskLevel.BackgroundColor = [1 1 1];
            app.RiskLevel.Layout.Row = 4;
            app.RiskLevel.Layout.Column = [4 6];
            app.RiskLevel.Value = '-';

            % Create AdditionalDescriptionLabel
            app.AdditionalDescriptionLabel = uilabel(app.EditableParametersGrid);
            app.AdditionalDescriptionLabel.VerticalAlignment = 'bottom';
            app.AdditionalDescriptionLabel.WordWrap = 'on';
            app.AdditionalDescriptionLabel.FontSize = 10;
            app.AdditionalDescriptionLabel.Layout.Row = 5;
            app.AdditionalDescriptionLabel.Layout.Column = [1 6];
            app.AdditionalDescriptionLabel.Text = 'Informações complementares:';

            % Create AdditionalDescription
            app.AdditionalDescription = uitextarea(app.EditableParametersGrid);
            app.AdditionalDescription.ValueChangedFcn = createCallbackFcn(app, @OthersParametersValueChanged, true);
            app.AdditionalDescription.FontSize = 11;
            app.AdditionalDescription.Layout.Row = 6;
            app.AdditionalDescription.Layout.Column = [1 6];

            % Create toolGrid
            app.toolGrid = uigridlayout(app.GridLayout);
            app.toolGrid.ColumnWidth = {22, 22, '1x', 22, 22};
            app.toolGrid.RowHeight = {4, 17, '1x'};
            app.toolGrid.ColumnSpacing = 5;
            app.toolGrid.RowSpacing = 0;
            app.toolGrid.Padding = [0 5 0 5];
            app.toolGrid.Layout.Row = 4;
            app.toolGrid.Layout.Column = [1 5];
            app.toolGrid.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create tool_ShowGlobalExceptionList
            app.tool_ShowGlobalExceptionList = uiimage(app.toolGrid);
            app.tool_ShowGlobalExceptionList.ImageClickedFcn = createCallbackFcn(app, @toolbarCallbacks, true);
            app.tool_ShowGlobalExceptionList.Tooltip = {'Mostra lista global de exceções'; '(emissão não é considerada "Não licenciada")'};
            app.tool_ShowGlobalExceptionList.Layout.Row = 2;
            app.tool_ShowGlobalExceptionList.Layout.Column = 1;
            app.tool_ShowGlobalExceptionList.ImageSource = 'Info_32.png';

            % Create tool_ExportJSONFile
            app.tool_ExportJSONFile = uiimage(app.toolGrid);
            app.tool_ExportJSONFile.ScaleMethod = 'none';
            app.tool_ExportJSONFile.ImageClickedFcn = createCallbackFcn(app, @toolbarCallbacks, true);
            app.tool_ExportJSONFile.Tooltip = {'Exporta arquivo JSON com informações das emissões sob análise'};
            app.tool_ExportJSONFile.Layout.Row = 2;
            app.tool_ExportJSONFile.Layout.Column = 2;
            app.tool_ExportJSONFile.ImageSource = 'Export_16.png';

            % Create jsBackDoor
            app.jsBackDoor = uihtml(app.toolGrid);
            app.jsBackDoor.Layout.Row = 2;
            app.jsBackDoor.Layout.Column = 4;

            % Create tool_ControlPanelVisibility
            app.tool_ControlPanelVisibility = uiimage(app.toolGrid);
            app.tool_ControlPanelVisibility.ImageClickedFcn = createCallbackFcn(app, @toolbarCallbacks, true);
            app.tool_ControlPanelVisibility.Layout.Row = 2;
            app.tool_ControlPanelVisibility.Layout.Column = 5;
            app.tool_ControlPanelVisibility.ImageSource = 'ArrowRight_32.png';

            % Create ContextMenu_UITable
            app.ContextMenu_UITable = uicontextmenu(app.UIFigure);

            % Create ContextMenu_editEmission
            app.ContextMenu_editEmission = uimenu(app.ContextMenu_UITable);
            app.ContextMenu_editEmission.Text = 'Editar';

            % Create ContextMenu_analogEmission
            app.ContextMenu_analogEmission = uimenu(app.ContextMenu_editEmission);
            app.ContextMenu_analogEmission.MenuSelectedFcn = createCallbackFcn(app, @UITableContextMenuClicked, true);
            app.ContextMenu_analogEmission.Text = 'Não truncar';

            % Create ContextMenu_digitalEmission
            app.ContextMenu_digitalEmission = uimenu(app.ContextMenu_editEmission);
            app.ContextMenu_digitalEmission.MenuSelectedFcn = createCallbackFcn(app, @UITableContextMenuClicked, true);
            app.ContextMenu_digitalEmission.Enable = 'off';
            app.ContextMenu_digitalEmission.Text = 'Truncar frequência';

            % Create ContextMenu_deleteEmission
            app.ContextMenu_deleteEmission = uimenu(app.ContextMenu_UITable);
            app.ContextMenu_deleteEmission.MenuSelectedFcn = createCallbackFcn(app, @UITableContextMenuClicked, true);
            app.ContextMenu_deleteEmission.Text = 'Excluir';
            
            % Assign app.ContextMenu_UITable
            app.UITable.ContextMenu = app.ContextMenu_UITable;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = winSignalAnalysis_exported(Container, varargin)

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
