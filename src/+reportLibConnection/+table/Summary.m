function varargout = Summary(peaksTable, exceptionList, requestedOutput)

    arguments
        peaksTable    
        exceptionList 
        requestedOutput char {mustBeMember(requestedOutput, {'EditedEmissionsTable', 'TotalSummaryTable', 'EditedEmissionsTable+TotalSummaryTable', 'IrregularTable'})} = 'TotalSummaryTable'
    end

    EditedEmissionsTable = peaksTable;

    if isempty(peaksTable)
        return
    end

    for ii = 1:height(exceptionList)
        exceptionIndex = find(strcmp(EditedEmissionsTable.Tag,  exceptionList.Tag(ii)) & (abs(EditedEmissionsTable.Frequency - exceptionList.Frequency(ii)) <= 1e-5))';

        for jj = exceptionIndex
            EditedEmissionsTable.Type{jj}        = exceptionList.Type{ii};
            EditedEmissionsTable.Regulatory{jj}  = exceptionList.Regulatory{ii};
            EditedEmissionsTable.Service(jj)     = exceptionList.Service(ii);
            EditedEmissionsTable.Station(jj)     = exceptionList.Station(ii);
            EditedEmissionsTable.Description{jj} = exceptionList.Description{ii};
            EditedEmissionsTable.Distance{jj}    = exceptionList.Distance{ii};
            EditedEmissionsTable.Irregular{jj}   = exceptionList.Irregular{ii};
            EditedEmissionsTable.RiskLevel{jj}   = exceptionList.RiskLevel{ii};
        end
    end

    % Itera em relação à lista de emissões, buscando aquelas que foram
    % incluídas por arquivo.
    for kk = 1:height(EditedEmissionsTable)
        fileDetectionInfo = jsondecode(EditedEmissionsTable.Detection{kk});

        if isfield(fileDetectionInfo, 'Description')
            % Outra camada de segurança...
            userDescription = fileDetectionInfo.Description;
            if iscellstr(userDescription) || (isstring(userDescription) && ~isscalar(userDescription))
                userDescription = strjoin(userDescription);
            end

            EditedEmissionsTable.Detection{kk}   = jsonencode(rmfield(fileDetectionInfo, 'Description'));
            EditedEmissionsTable.Description{kk} = sprintf('%s (%s)', EditedEmissionsTable.Description{kk}, userDescription);
        end
    end

    EditedEmissionsTable.Tag = extractAfter(EditedEmissionsTable.Tag, newline);
    
    % Itera em relação às faixas de frequências monitoradas, montando tabela que 
    % pode ser renderizada no Relatório de Monitoração ou no "journal" (ou histórico) 
    % da ação de inspeção no Fiscaliza.
    if contains(requestedOutput, 'TotalSummaryTable')
        TotalSummaryTable = table('Size', [0, 22],                                                                                                                                   ...
                                  'VariableTypes', {'cell',   'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16',                    ...
                                                    'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16'},                   ...
                                  'VariableNames', {'Banda', 'N1_Licenciada', 'N1_NaoLicenciada', 'N1_NaoLicenciavel',                                                               ...
                                                             'N2_Fundamental', 'N2_Harmonico', 'N2_Produto', 'N2_Espuria', 'N2_NaoIdentificada', 'N2_NaoManifestada', 'N2_Pendente', ...
                                                             'N3_Licenciada', 'N3_NaoLicenciada', 'N3_NaoLicenciavel',                                                               ...
                                                             'N4_Baixo', 'N4_Medio', 'N4_Alto',                                                                                      ...
                                                             'N5_Radcom', 'N5_ClasseC', 'N5_ClasseB', 'N5_ClasseA', 'N5_ClasseE'});


        Bands = unique(EditedEmissionsTable.Tag, 'stable');

        for mm = 1:numel(Bands)
            tagIdx = strcmp(EditedEmissionsTable.Tag, Bands{mm});
    
            N1_Licenciada      = sum(tagIdx & strcmp(EditedEmissionsTable.Regulatory, 'Licenciada'));
            N1_NaoLicenciada   = sum(tagIdx & strcmp(EditedEmissionsTable.Regulatory, 'Não licenciada'));
            N1_NaoLicenciavel  = sum(tagIdx & strcmp(EditedEmissionsTable.Regulatory, 'Não passível de licenciamento'));
    
            N2_Fundamental     = sum(tagIdx & strcmp(EditedEmissionsTable.Type,       'Fundamental'));
            N2_Harmonico       = sum(tagIdx & strcmp(EditedEmissionsTable.Type,       'Harmônico de fundamental'));
            N2_Produto         = sum(tagIdx & strcmp(EditedEmissionsTable.Type,       'Produto de intermodulação'));
            N2_Espuria         = sum(tagIdx & strcmp(EditedEmissionsTable.Type,       'Espúrio'));
            N2_NaoIdentificada = sum(tagIdx & strcmp(EditedEmissionsTable.Type,       'Não identificado'));
            N2_NaoManifestada  = sum(tagIdx & strcmp(EditedEmissionsTable.Type,       'Não se manifestou'));
            N2_Pendente        = sum(tagIdx & strcmp(EditedEmissionsTable.Type,       'Pendente de identificação'));
    
            N3_Licenciada      = sum(tagIdx & strcmp(EditedEmissionsTable.Regulatory, 'Licenciada')                    & strcmp(EditedEmissionsTable.Irregular, 'Sim'));
            N3_NaoLicenciada   = sum(tagIdx & strcmp(EditedEmissionsTable.Regulatory, 'Não licenciada')                & strcmp(EditedEmissionsTable.Irregular, 'Sim'));
            N3_NaoLicenciavel  = sum(tagIdx & strcmp(EditedEmissionsTable.Regulatory, 'Não passível de licenciamento') & strcmp(EditedEmissionsTable.Irregular, 'Sim'));
            
            N4_Baixo           = sum(tagIdx & strcmp(EditedEmissionsTable.RiskLevel,  'Baixo'));
            N4_Medio           = sum(tagIdx & strcmp(EditedEmissionsTable.RiskLevel,  'Médio'));
            N4_Alto            = sum(tagIdx & strcmp(EditedEmissionsTable.RiskLevel,  'Alto'));
    
            N5_Radcom          = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(EditedEmissionsTable.Description, '\[SRD\] RADCOM', 'match')));
            N5_ClasseC         = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(EditedEmissionsTable.Description, '\[MOSAICO-SRD\] (FM|TV)-C[0-9]{1,2}, C', 'match')));
            N5_ClasseB         = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(EditedEmissionsTable.Description, '\[MOSAICO-SRD\] (FM|TV)-C[0-9]{1,2}, B', 'match')));
            N5_ClasseA         = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(EditedEmissionsTable.Description, '\[MOSAICO-SRD\] (FM|TV)-C[0-9]{1,2}, A', 'match')));
            N5_ClasseE         = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(EditedEmissionsTable.Description, '\[MOSAICO-SRD\] (FM|TV)-C[0-9]{1,2}, E', 'match')));
            
            TotalSummaryTable(mm,:) = {Bands{mm}, N1_Licenciada, N1_NaoLicenciada, N1_NaoLicenciavel,                                                       ...
                                                  N2_Fundamental, N2_Harmonico, N2_Produto, N2_Espuria, N2_NaoIdentificada, N2_NaoManifestada, N2_Pendente, ...
                                                  N3_Licenciada, N3_NaoLicenciada, N3_NaoLicenciavel,                                                       ...
                                                  N4_Baixo, N4_Medio, N4_Alto,                                                                              ...
                                                  N5_Radcom, N5_ClasseC, N5_ClasseB, N5_ClasseA, N5_ClasseE};
        end
    end

    if contains(requestedOutput, 'IrregularTable')
        irregularIndex = strcmp(EditedEmissionsTable.Irregular, 'Sim');
        irregularTable = EditedEmissionsTable(irregularIndex, {'Frequency',   ...
                                                               'Truncated',   ...
                                                               'BW',          ...
                                                               'Description', ...
                                                               'Regulatory',  ...
                                                               'Type',        ...
                                                               'RiskLevel',   ...
                                                               'UserDescription'});
    end

    % Saída:
    requestedOutput = strsplit(requestedOutput, '+');
    varargout = {};
    for oo = 1:numel(requestedOutput)
        switch requestedOutput{oo}
            case 'TotalSummaryTable'
                varargout = [varargout, {TotalSummaryTable}];
            case 'EditedEmissionsTable'
                varargout = [varargout, {EditedEmissionsTable}];
            case 'IrregularTable'
                varargout = [varargout, {irregularTable}];
        end
    end
end