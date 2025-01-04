function report_StaticButtonPushed(app, event)

    switch event.Source
        case app.report_ControlsTab2Image
            if ~report_checkValidIssueID(app)
                appUtil.modalWindow(app.UIFigure, 'warning', 'Pendente inserir o número da Inspeção.');
                return
            end

            report_FiscalizaStartup(app)
            
        case app.report_FiscalizaRefresh
            if isempty(app.fiscalizaObj) || ~strcmp(app.fiscalizaObj.issueID, num2str(app.report_Issue.Value))
                report_FiscalizaStartup(app)
            else
                fiscalizaLibConnection.report_Connect(app, [], 'RefreshIssue')
            end

        case app.tool_FiscalizaAutoFill
            fiscalizaLibConnection.report_AutoFill(app)

        case app.tool_FiscalizaUpdate
            fiscalizaLibConnection.report_Update(app)
    end
end


%-------------------------------------------------------------------------%
function status = report_checkValidIssueID(app)
    status = (app.report_Issue.Value > 0) && (app.report_Issue.Value < inf);
end


%-------------------------------------------------------------------------%
function report_FiscalizaStartup(app)
    if isempty(app.fiscalizaObj) || ~strcmp(app.fiscalizaObj.issueID, num2str(app.report_Issue.Value))
        msgQuestion   = sprintf('Deseja obter informações da Inspeção nº %.0f?', app.report_Issue.Value);
        userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
        
        switch userSelection
            case 'Sim'
                if isempty(app.fiscalizaObj)
                    dialogBox    = struct('id', 'login',    'label', 'Usuário: ', 'type', 'text');
                    dialogBox(2) = struct('id', 'password', 'label', 'Senha: ',   'type', 'password');
                    sendEventToHTMLSource(app.jsBackDoor, "customForm", struct('UUID', char(matlab.lang.internal.uuid()), 'Fields', dialogBox))
                else
                    fiscalizaLibConnection.report_Connect(app, [], 'GetIssue')
                end

            case 'Não'
                if ~isempty(app.fiscalizaObj)
                    app.report_Issue.Value = str2double(app.fiscalizaObj.issueID);
                end
        end
    end

    fiscalizaLibConnection.report_ToolbarStatus(app)
    app.play_ControlsGrid.RowHeight(2:2:12) = {0,0,0,0,'1x',0};
end