function report_ToolbarStatus(app)

    % Habilita botões de "AutoFill" e "Update" apenas se a
    % inspeção estiver num estado relatável. Lembrando que se der 
    % algum erro no processo, o grid app.report_Fiscaliza.Grid
    % terá um único filho - a imagem do Redmine (placeholder).
    
    if numel(app.report_FiscalizaGrid.Children) <= 1
        app.report_FiscalizaAutoFillImage.Enable = 0;
        app.report_FiscalizaUpdateImage.Enable   = 0;
        
    else
        app.report_FiscalizaAutoFillImage.Enable = 1;
        app.report_FiscalizaUpdateImage.Enable   = 1;
    end

end