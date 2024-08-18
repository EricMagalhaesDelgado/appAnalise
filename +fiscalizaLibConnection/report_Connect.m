function report_Connect(app, credentials, connectionType)

    app.progressDialog.Visible = 'visible';
    try
        switch connectionType
            case 'OpenConnection'
                if app.config_FiscalizaPD.Value
                    homFlag = false;
                else
                    homFlag = true;
                end        
                app.fiscalizaObj = fiscalizaGUI(credentials.login, credentials.password, homFlag, app.report_FiscalizaGrid, app.report_Issue.Value);

            case 'GetIssue'
                getIssue(app.fiscalizaObj, app.report_Issue.Value)
                Data2GUI(app.fiscalizaObj)

            case 'RefreshIssue'
                RefreshGUI(app.fiscalizaObj)
        end

        fiscalizaLibConnection.report_ToolbarStatus(app)

    catch ME
        % Se a operação registrar um erro, faz-se necessária a realização
        % de três operações:
        % (1) Apagar algum componente renderizado em tela, caso o objeto
        %     app.fiscalizaObj exista;
        % (2) Apresentar o ícone do REDMINE como placeholder; e
        % (3) Desabilitar o botão que possibilita o relato.
        fiscalizaLibConnection.report_ResetGUI(app)
        appUtil.modalWindow(app.UIFigure, 'error', ME.message);
    end
    app.progressDialog.Visible = 'hidden';

end