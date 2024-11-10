function report_AutoFill(app)

    % app.progressDialog.Visible = 'visible';
    try
        automaticData = report_Info2AutoFill(app);
        AutoFillFields(app.fiscalizaObj, automaticData, 1)

    catch ME
        appUtil.modalWindow(app.UIFigure, 'error', ME.message);
    end
    % app.progressDialog.Visible = 'hidden';

end


%-----------------------------------------------------------------%
function automaticData = report_Info2AutoFill(app)

    automaticData = struct('tipo_de_inspecao',           'Uso do Espectro - Monitoração', ...
                           'entidade_com_cadastro_stel', app.config_CadastroSTEL.Value);
    % Transcrito da versão antiga do appAnalise.
    automaticData = struct('Classe_da_Inspecao',            'Técnica',                       ...
                           'tipo_de_inspecao',              'Uso do Espectro - Monitoração', ...
                           'Uso_de_PF',                     'Não se aplica PF - uso apenas de formulários', ...
                           'Acao_de_risco_a_vida_criada',   'Não',   ...
                           'Impossibilidade_acesso_online', '0',     ...
                           'Reservar_Instrumentos',         '0',     ...
                           'Utilizou_algum_instrumento',    int8(0), ...
                           'entidade_com_cadastro_stel',    app.config_CadastroSTEL.Value);


    % RELATÓRIO (VERSÃO DEFINITIVA)
    if ~isempty(app.General.fiscaliza.lastHTMLDocFullPath)
        automaticData.html_path = app.General.fiscaliza.lastHTMLDocFullPath;
    end

    % QUALIFICAÇÃO DA FISCALIZADA
    nEntity = strtrim(app.report_Entity.Value);
    if ~isempty(nEntity)
        automaticData.nome_da_entidade = nEntity;
    end

    try
        [~, nCNPJ] = checkCNPJ(app.report_EntityID.Value, false);
        
        automaticData.entidade_da_inspecao = {nCNPJ};
        automaticData.cnpjcpf_da_entidade  = nCNPJ;
    catch
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

    % MEDIDA CAUTELAR
    qtdLacrados    = sum(app.listOfProducts{:, 'Qtd. lacradas'});
    qtdApreendidas = sum(app.listOfProducts{:, 'Qtd. apreendidas'});
    
    procedimentos = {};
    if qtdLacrados
        procedimentos = [procedimentos, {'Lacração'}];
    end

    if qtdApreendidas
        procedimentos = [procedimentos, {'Apreensão'}];
    end

    if ~isempty(procedimentos)
        automaticData.procedimentos = procedimentos;
    end

    automaticData.qnt_produt_lacradosapreend = qtdLacrados + qtdApreendidas;
    if qtdLacrados || qtdApreendidas
        if ~isempty(app.config_MotivoLAI.CheckedNodes)
            automaticData.motivo_de_lai = {app.config_MotivoLAI.CheckedNodes.Text};
        end

        if strcmp(app.config_GerarPLAI.Value, '1')
            automaticData.gerar_plai = '1';
            automaticData.tipo_do_processo_plai = app.config_TipoPLAI.Value;

            hComponent = findobj(app.report_FiscalizaGrid, 'Tag', 'coordenacao_responsavel');
            if ~isempty(hComponent)
                automaticData.coord_fi_plai = hComponent.Value;
            end
        end
    end

    % SERVIÇOS
    if ~isempty(app.config_ServicoInspecao.CheckedNodes)
        automaticData.servicos_da_inspecao = {app.config_ServicoInspecao.CheckedNodes.Text};
    end

    % SITUAÇÃO
    if ismember('Irregular', app.listOfProducts.('Situação'))
        automaticData.situacao_constatada = 'Irregular';

        irregularidade = {};
        if ismember('Comercialização', app.listOfProducts.('Infração'))
            irregularidade = [irregularidade, {'Comercialização de produtos'}];
        end

        if ismember('Uso', app.listOfProducts.('Infração'))
            irregularidade = [irregularidade, {'Utilização de produtos'}];
        end

        if ~isempty(irregularidade)
            automaticData.irregularidade = irregularidade;
        end
    else
        automaticData.situacao_constatada = 'Regular';
    end
    
end