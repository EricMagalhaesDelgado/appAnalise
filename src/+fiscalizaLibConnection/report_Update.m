function report_Update(app)

    msgQuestion = '<p style="font-size: 12px; text-align: justify;">Confirma a tentativa de atualizar informações da inspeção?</p>';            
    selection   = uiconfirm(app.UIFigure, msgQuestion, '', 'Interpreter', 'html',     ...
                                                           'Options', {'SIM', 'NÃO'}, ...
                                                           'DefaultOption', 1, 'CancelOption', 2, 'Icon', 'question');
    if strcmp(selection, 'NÃO')
        return
    end

    app.progressDialog.Visible = 'visible';
    try
        UploadFiscaliza(app.fiscalizaObj)

    catch ME
        appUtil.modalWindow(app.UIFigure, 'error', ME.message);
    end
    app.progressDialog.Visible = 'hidden';
    
end