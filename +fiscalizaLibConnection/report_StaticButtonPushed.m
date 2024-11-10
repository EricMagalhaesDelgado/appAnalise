function report_StaticButtonPushed(app, event)

    switch event.Source
        case app.report_ControlsTab2Image
            if ~report_checkValidIssueID(app)
                appUtil.modalWindow(app.UIFigure, 'warning', 'Pendente inserir o número da Inspeção.');
                return
            end
    
            if ~isempty(app.fiscalizaObj) && strcmp(app.fiscalizaObj.issueID, num2str(app.report_Issue.Value))
                app.play_ControlsGrid.RowHeight(2:2:12) = {0,0,0,0,'1x',0};
                fiscalizaLibConnection.report_ToolbarStatus(app)
    
            else
                msgQuestion   = sprintf('Deseja obter informações da Inspeção nº %.0f?', app.report_Issue.Value);
                userSelection = appUtil.modalWindow(app.UIFigure, 'uiconfirm', msgQuestion, {'Sim', 'Não'}, 1, 2);
                if userSelection == "Não"
                    return
                end
    
                if isempty(app.fiscalizaObj)
                    sendEventToHTMLSource(app.jsBackDoor, 'credentialDialog', struct('UUID', char(matlab.lang.internal.uuid())));
                else
                    fiscalizaLibConnection.report_Connect(app, [], 'GetIssue')
                end
            end
            
        case app.report_FiscalizaRefresh
            if isempty(app.fiscalizaObj)
                fiscalizaLibConnection.report_StaticButtonPushed(app, struct('Source', app.report_ControlsTab2Image))
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