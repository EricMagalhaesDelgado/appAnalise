function issueStruct = Misc_py2matRedmine(issueDict, Flag)
%% MISC_PY2MATREDMINE Misc_py2matRedmine
% Trata-se de função que faz as conversões dos tipos de dados gerados pelo módulo 
% desenvolvido pelo servidor Ronaldo (GR01), a partir da API *Python/Redmine*.
%% 
% * Python Dictionary >> Matlab Struct
% * Python List >> Matlab Cell
% * Python String >> Matlab String
%% 
% Versão: 28/05/2021
    % py.dict >> struct e py.str>>char | py.list>>cell
    issueStruct = struct(issueDict);
    
    if isempty(issueStruct)
        error('Dicionário vazio!')
    end
% % Campos Redmine:
    issueStruct.id      = char(issueStruct.id);
    issueStruct.subject = char(issueStruct.subject);
    if ~contains(issueStruct.subject, 'INSP')
        error('Não se trata de inspeção!')
    end
    issueStruct.status = char(issueStruct.status);
    if Flag & ismember(issueStruct.status, ["Cancelada", "Relatada", "Conferida"])
        error('A inspeção nº %s não é passível de relato por já estar no estado "%s".', issueStruct.id, issueStruct.status)
    end
    
    issueStruct.description = char(issueStruct.description);
    issueStruct.priority    = char(issueStruct.priority);
    issueStruct.start_date  = char(issueStruct.start_date);
    issueStruct.due_date    = char(issueStruct.due_date);
    
    
% % Campos personalizados existentes já no estado "Rascunho", após a criação da Inspeção:
    issueStruct.Classe_da_Inspecao = char(issueStruct.Classe_da_Inspecao);
    issueStruct.Tipo_de_Inspecao   = char(issueStruct.Tipo_de_Inspecao);
    issueStruct.Ano                = char(issueStruct.Ano);
    
    issueStruct.Numero_Sei_do_Processo = replace(char(issueStruct.Numero_Sei_do_Processo), '=>', ':');
    if ~isempty(issueStruct.Numero_Sei_do_Processo)
        issueStruct.Numero_Sei_do_Processo = jsondecode(issueStruct.Numero_Sei_do_Processo);
    end
    
    issueStruct.Fiscal_Responsavel    = char(issueStruct.Fiscal_Responsavel);
    issueStruct.Fiscais               = cellfun(@(x) char(x), cell(issueStruct.Fiscais),              'UniformOutput', false);
    issueStruct.Entidade_da_Inspecao  = cellfun(@(x) char(x), cell(issueStruct.Entidade_da_Inspecao), 'UniformOutput', false);
    issueStruct.UF_Municipio          = cellfun(@(x) char(x), cell(issueStruct.UF_Municipio),         'UniformOutput', false);
    issueStruct.Servicos_da_Inspecao  = cellfun(@(x) char(x), cell(issueStruct.Servicos_da_Inspecao), 'UniformOutput', false);
    issueStruct.Horas_de_Preparacao   = char(issueStruct.Horas_de_Preparacao);
    issueStruct.Horas_de_Deslocamento = char(issueStruct.Horas_de_Deslocamento);
    issueStruct.Horas_de_Execucao     = char(issueStruct.Horas_de_Execucao);
    issueStruct.Horas_de_Conclusao    = char(issueStruct.Horas_de_Conclusao);
    issueStruct.SAV                   = char(issueStruct.SAV);
    issueStruct.PCDP                  = char(issueStruct.PCDP);
    issueStruct.Procedimentos         = cellfun(@(x) char(x), cell(issueStruct.Procedimentos),        'UniformOutput', false);
    issueStruct.Agrupamento           = char(issueStruct.Agrupamento);
    
    
% % Outros campos personalizados (em especial àqueles relacionados a uma Inspeção do tipo "Uso do espectro - monitoração"):
    issueStruct.Coordenacao = '';
    if isfield(issueStruct, 'Coordenacao')
        issueStruct.Coordenacao = char(issueStruct.Coordenacao);
    end
    
    if isfield(issueStruct, 'Qnt_de_emissoes_na_faixa');      issueStruct.Qnt_de_emissoes_na_faixa      = char(issueStruct.Qnt_de_emissoes_na_faixa);      end
    if isfield(issueStruct, 'Emissoes_nao_autorizadas');      issueStruct.Emissoes_nao_autorizadas      = char(issueStruct.Emissoes_nao_autorizadas);      end
    if isfield(issueStruct, 'Latitude');                      issueStruct.Latitude                      = char(issueStruct.Latitude);                      end
    if isfield(issueStruct, 'Longitude');                     issueStruct.Longitude                     = char(issueStruct.Longitude);                     end
    if isfield(issueStruct, 'Uso_de_PF');                     issueStruct.Uso_de_PF                     = char(issueStruct.Uso_de_PF);                     end
    if isfield(issueStruct, 'Acao_de_risco_a_vida_criada');   issueStruct.Acao_de_risco_a_vida_criada   = char(issueStruct.Acao_de_risco_a_vida_criada);   end
    if isfield(issueStruct, 'Frequencia_Inicial');            issueStruct.Frequencia_Inicial            = char(issueStruct.Frequencia_Inicial);            end
    if isfield(issueStruct, 'Unidade_da_Frequencia_Inicial'); issueStruct.Unidade_da_Frequencia_Inicial = char(issueStruct.Unidade_da_Frequencia_Inicial); end
    if isfield(issueStruct, 'Frequencia_Final');              issueStruct.Frequencia_Final              = char(issueStruct.Frequencia_Final);              end
    if isfield(issueStruct, 'Unidade_da_Frequencia_Final');   issueStruct.Unidade_da_Frequencia_Final   = char(issueStruct.Unidade_da_Frequencia_Final);   end
    if isfield(issueStruct, 'AppFiscaliza');                  issueStruct.AppFiscaliza                  = char(issueStruct.AppFiscaliza);                  end
    
    if isfield(issueStruct, 'Relatorio_de_Monitoramento')
        issueStruct.Relatorio_de_Monitoramento = replace(char(issueStruct.Relatorio_de_Monitoramento), '=>', ':');
        if ~isempty(issueStruct.Relatorio_de_Monitoramento)
            issueStruct.Relatorio_de_Monitoramento = jsondecode(issueStruct.Relatorio_de_Monitoramento);
        end
    end
    
    if isfield(issueStruct, 'Reservar_Instrumentos');      issueStruct.Reservar_Instrumentos      = char(issueStruct.Reservar_Instrumentos);      end
    if isfield(issueStruct, 'Utilizou_algum_instrumento'); issueStruct.Utilizou_algum_instrumento = char(issueStruct.Utilizou_algum_instrumento); end
    if isfield(issueStruct, 'Atualizado');                 issueStruct.Atualizado                 = char(issueStruct.Atualizado);                 end
    
    
% % Outras informações relacionadas à Inspeção:
    issueStruct.Users = cellfun(@(x) char(x), cell(issueStruct.Users), 'UniformOutput', false);
    
    if isfield(issueStruct, 'id_ACAO');        issueStruct.id_ACAO        = double(issueStruct.id_ACAO);      end
    if isfield(issueStruct, 'nome_ACAO');      issueStruct.nome_ACAO      = char(issueStruct.nome_ACAO);      end
    if isfield(issueStruct, 'descricao_ACAO'); issueStruct.descricao_ACAO = char(issueStruct.descricao_ACAO); end
    
end