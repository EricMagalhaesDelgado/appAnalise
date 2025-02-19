function report_AutoFill(app)

    app.progressDialog.Visible = 'visible';
    try
        automaticData = report_Info2AutoFill(app);
        AutoFillFields(app.fiscalizaObj, automaticData, 1)

    catch ME
        appUtil.modalWindow(app.UIFigure, 'error', ME.message);
    end
    app.progressDialog.Visible = 'hidden';

end


%-----------------------------------------------------------------%
function automaticData = report_Info2AutoFill(app)
    automaticData = struct('tipo_de_inspecao',            'Uso do Espectro - Monitoração', ...
                           'procedimentos',               {{'Monitorado'}},                ...
                           'acao_de_risco_a_vida_criada', 'Não');


    if ~isempty(app.projectData.generatedFiles)
        % RELATÓRIO (VERSÃO DEFINITIVA)
        if isfile(app.projectData.generatedFiles.lastHTMLDocFullPath)
            automaticData.html_path = app.projectData.generatedFiles.lastHTMLDocFullPath;
        end
    
        % INFORMAÇÕES RELACIONADAS À MONITORAÇÃO
        if isfile(app.projectData.generatedFiles.lastMATFullPath)
            load(app.projectData.generatedFiles.lastMATFullPath, 'ReportProject')
            
            automaticData.latitude_coordenadas          = ReportProject.Latitude;
            automaticData.longitude_coordenadas         = ReportProject.Longitude;
            automaticData.ufmunicipio                   = ReportProject.City;
    
            automaticData.frequencia_inicial            = ReportProject.F0 / 1e+6;
            automaticData.frequencia_final              = ReportProject.F1 / 1e+6;
            automaticData.unidade_da_frequencia_inicial = 'MHz';
            automaticData.unidade_da_frequencia_final   = 'MHz';
    
            automaticData.qtd_de_emissoes               = ReportProject.emissionsValue1;
            automaticData.qtd_identificadas             = ReportProject.emissionsValue2;
            automaticData.qtd_licenciadas               = ReportProject.emissionsValue3;
    
            automaticData.servicos_da_inspecao          = ReportProject.Services;
        end
    end

    % SERVIÇOS DA INSPEÇÃO
    if ~isfield(automaticData, 'servicos_da_inspecao')
        automaticData.servicos_da_inspecao              = app.General.fiscaliza.defaultValues.servicos_da_inspecao.value;
    end

    % FISCAL RESPONSÁVEL E FISCAIS
    hDropDown   = findobj(app.report_FiscalizaGrid, 'Type', 'uidropdown',     'Tag', 'fiscal_responsavel');
    hTree       = findobj(app.report_FiscalizaGrid, 'Type', 'uicheckboxtree', 'Tag', 'fiscais');
    currentUser = getCurrentUser(app.fiscalizaObj);
    try                
        if ~isempty(currentUser)
            if ~isempty(hDropDown) && ~isempty(hDropDown.Items)
                idxFiscal1 = find(strcmp(hDropDown.Items, currentUser), 1);
                if ~isempty(idxFiscal1)
                    automaticData.fiscal_responsavel = currentUser;
                end
            end
        end
    catch
    end

    try
        if ~isempty(currentUser)
            if ~isempty(hTree) && ~isempty(hTree.Children)
                idxFiscal2 = find(strcmp({hTree.Children.Text}, currentUser), 1);
                if ~isempty(idxFiscal2)
                    automaticData.fiscais = {currentUser};
                end
            end
        end
    catch
    end    
end