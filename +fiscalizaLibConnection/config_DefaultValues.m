function config_DefaultValues(app)

    set(app.config_CadastroSTEL, 'Items', app.CallingApp.General_I.fiscaliza.defaultValues.entidade_com_cadastro_stel.options, ...
                                 'Value', app.CallingApp.General_I.fiscaliza.defaultValues.entidade_com_cadastro_stel.value)

    set(app.config_GerarPLAI,    'Items', app.CallingApp.General_I.fiscaliza.defaultValues.gerar_plai.options, ...
                                 'Value', app.CallingApp.General_I.fiscaliza.defaultValues.gerar_plai.value)

    set(app.config_TipoPLAI,     'Items', app.CallingApp.General_I.fiscaliza.defaultValues.tipo_do_processo_plai.options, ...
                                 'Value', app.CallingApp.General_I.fiscaliza.defaultValues.tipo_do_processo_plai.value)
    
    % app.config_MotivoLAI
    config_FiscalizaFillTree(app, 'config_MotivoLAI',       'motivo_de_lai')
    config_FiscalizaFillTree(app, 'config_ServicoInspecao', 'servicos_da_inspecao')

end



%-------------------------------------------------------------------------%
function config_FiscalizaFillTree(app, componentName, fieldName)

    fieldOptions = app.CallingApp.General_I.fiscaliza.defaultValues.(fieldName).options;
    fieldValue   = app.CallingApp.General_I.fiscaliza.defaultValues.(fieldName).value;

    for ii = 1:numel(fieldOptions)
        childNode = uitreenode(app.(componentName), 'Text', fieldOptions{ii});

        if ismember(fieldOptions{ii}, fieldValue)
            app.(componentName).CheckedNodes = [app.(componentName).CheckedNodes; childNode];
        end
    end

end