function report_StaticButtonPushed(app, event)

    switch event.Source
        case app.report_ControlsTab3Image
            if ~report_checkValidIssueID(app)
                appUtil.modalWindow(app.UIFigure, 'warning', 'Pendente inserir o número da Inspeção.');
                return
            end

            if isempty(app.fiscalizaObj) || ~strcmp(app.fiscalizaObj.issueID, num2str(app.report_Issue.Value))
                msgQuestion = sprintf('Deseja obter informações da Inspeção nº %.0f?', app.report_Issue.Value);
                selection   = uiconfirm(app.UIFigure, textFormatGUI.HTMLParagraph(msgQuestion), '', 'Interpreter', 'html',               ...
                                                                                                    'Options', {'   OK   ', 'CANCELAR'}, ...
                                                                                                    'DefaultOption', 1, 'CancelOption', 2, 'Icon', 'question');
                if strcmp(selection, 'CANCELAR')
                    return
                end

                if isempty(app.fiscalizaObj)
                    sendEventToHTMLSource(app.jsBackDoor, 'credentialDialog', struct('UUID', char(matlab.lang.internal.uuid())));
                else
                    fiscalizaLibConnection.report_Connect(app, [], 'GetIssue')
                end
            end

            fiscalizaLibConnection.report_ToolbarStatus(app)


        case app.report_FiscalizaRefresh
            if isempty(app.fiscalizaObj)
                fiscalizaLibConnection.report_StaticButtonPushed(app, struct('Source', app.report_ControlsTab3Image))
            else
                fiscalizaLibConnection.report_Connect(app, [], 'RefreshIssue')
            end

        case app.report_FiscalizaAutoFillImage
            fiscalizaLibConnection.report_AutoFill(app)

        case app.report_FiscalizaUpdateImage
            fiscalizaLibConnection.report_Update(app)
    end
end


%-------------------------------------------------------------------------%
function status = report_checkValidIssueID(app)
    status = (app.report_Issue.Value > 0) && (app.report_Issue.Value < inf);
end