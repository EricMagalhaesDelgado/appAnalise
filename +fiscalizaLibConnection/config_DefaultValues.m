function config_DefaultValues(app)

    set(app.config_CadastroSTEL, 'Items', app.General.fiscaliza.defaultValues.entidade_com_cadastro_stel.options, ...
                                 'Value', app.General.fiscaliza.defaultValues.entidade_com_cadastro_stel.value)

    set(app.config_GerarPLAI,    'Items', app.General.fiscaliza.defaultValues.gerar_plai.options, ...
                                 'Value', app.General.fiscaliza.defaultValues.gerar_plai.value)

    set(app.config_TipoPLAI,     'Items', app.General.fiscaliza.defaultValues.tipo_do_processo_plai.options, ...
                                 'Value', app.General.fiscaliza.defaultValues.tipo_do_processo_plai.value)
    
    % app.config_MotivoLAI
    config_FiscalizaFillTree(app, 'config_MotivoLAI',       'motivo_de_lai')
    config_FiscalizaFillTree(app, 'config_ServicoInspecao', 'servicos_da_inspecao')

end



%-------------------------------------------------------------------------%
function config_FiscalizaFillTree(app, componentName, fieldName)

    fieldOptions = app.General.fiscaliza.defaultValues.(fieldName).options;
    fieldValue   = app.General.fiscaliza.defaultValues.(fieldName).value;

    for ii = 1:numel(fieldOptions)
        childNode = uitreenode(app.(componentName), 'Text', fieldOptions{ii});

        if ismember(fieldOptions{ii}, fieldValue)
            app.(componentName).CheckedNodes = [app.(componentName).CheckedNodes; childNode];
        end
    end

end