function config_SystemMode(app)

    selectedButton = app.config_FiscalizaVersion.SelectedObject;
    switch selectedButton
        case app.config_FiscalizaPD
            app.report_ControlsTab3Label.Text   = 'API FISCALIZA';
            app.General.fiscaliza.systemVersion = 'PROD';

        case app.config_FiscalizaHM
            app.report_ControlsTab3Label.Text   = 'API FISCALIZA HOMOLOGAÇÃO';
            app.General.fiscaliza.systemVersion = 'HOM';
    end
    
end