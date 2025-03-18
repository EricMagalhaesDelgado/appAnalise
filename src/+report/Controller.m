function Controller(app, operationType)

    arguments
        app
        operationType char {mustBeMember(operationType, {'Report'})}
    end

    d = uiprogressdlg(app.UIFigure, 'Indeterminate', 'on', 'Interpreter', 'html', 'Cancelable', 'on', 'CancelText', 'Cancelar', 'Message', 'Em andamento...');

    try
        if isempty(app.General.AppVersion.fiscaliza) && strcmp(operationType, 'Report')
            app.General.AppVersion = util.getAppVersion(app.rootFolder, app.entryPointFolder, app.General.fileFolder.tempPath, 'full+Python');
        end
    
        reportTemplateIndex = find(strcmp(app.report_ModelName.Items, app.report_ModelName.Value), 1) - 1;
        [idxThreads, reportInfo]   = report.GeneralInfo(app, operationType, reportTemplateIndex);        

        % Verifica se o template e relatório selecionado demanda
        % arquivos externos (imagens e tabelas).
        if contains(reportInfo.Model.Script, '"Origin": "External"')
            msg = '<p style="font-size:12px; text-align: justify;">Confirma que foram relacionados os arquivos externos ao appAnalise estabelecidos no modelo?</p>';
            selection = uiconfirm(app.UIFigure, msg, '', 'Options', {'OK', 'Cancelar'}, 'DefaultOption', 1, 'CancelOption', 2, 'Icon', 'question', 'Interpreter', 'html');
            
            if selection == "Cancelar"
                return
            end
        end

        % Verifica...
        htmlReport = report.ReportGenerator(app, idxThreads, reportInfo, d);

        switch app.report_Version.Value
            case 'Definitiva'
                [baseFullFileName, baseFileName] = appUtil.DefaultFileName(app.General.fileFolder.tempPath, 'Report', app.report_Issue.Value);
                HTMLDocFullPath = [baseFullFileName '.html'];
                fileID = fopen(HTMLDocFullPath, 'w', 'native', 'ISO-8859-1');

            case 'Preliminar'
                [baseFullFileName, baseFileName] = appUtil.DefaultFileName(app.General.fileFolder.tempPath, '~Report', app.report_Issue.Value);
                HTMLDocFullPath = [baseFullFileName '.html'];
                fileID = fopen(HTMLDocFullPath, 'w');
        end
        
        fprintf(fileID, '%s', htmlReport);
        fclose(fileID);

        switch app.report_Version.Value
            case 'Definitiva'
                JSONFile = [baseFullFileName '.json'];
                MATFile  = [baseFullFileName '.mat'];
                ZIPFile  = fullfile(app.General.fileFolder.userPath, [baseFileName '.zip']);
                
                [ReportProject, emissionFiscalizaTable] = ReportGenerator_Aux2(app, idxThreads, reportInfo);
                save(MATFile, 'ReportProject', '-mat', '-v7.3')
                writematrix(emissionFiscalizaTable, JSONFile, "FileType", "text", "QuoteStrings", "none")

                app.projectData.generatedFiles.lastHTMLDocFullPath = HTMLDocFullPath;
                app.projectData.generatedFiles.lastTableFullPath   = JSONFile;
                app.projectData.generatedFiles.lastMATFullPath     = MATFile;

                nameFormatMap = {'*.zip', 'appAnalise (*.zip)'};
                ZIPFullPath  = appUtil.modalWindow(app.UIFigure, 'uiputfile', '', nameFormatMap, ZIPFile);
                if isempty(ZIPFullPath)
                    return
                end
                
                zip(ZIPFullPath, {HTMLDocFullPath, JSONFile, MATFile})
                app.projectData.generatedFiles.lastZIPFullPath     = ZIPFullPath;

            case 'Preliminar'
                web(HTMLDocFullPath, '-new')
        end
        
    catch ME
        struct2table(ME.stack)
        appUtil.modalWindow(app.UIFigure, 'error', getReport(ME));
    end

    delete(d)
end