function varargout = Summary(specData, idxThreads, callingModule, requestedOutput, outputFinality)

    arguments
        specData
        idxThreads
        callingModule   char {mustBeMember(callingModule,   {'REPORT'})}
        requestedOutput char {mustBeMember(requestedOutput, {'EditedEmissionsTable', 'TotalSummaryTable', 'EditedEmissionsTable+TotalSummaryTable', 'IrregularTable'})} = 'TotalSummaryTable'
        outputFinality  char {mustBeMember(outputFinality,  {'SIGNALANALYSIS: GUI', 'SIGNALANALYSIS: JSONFile', 'REPORT: JSONFile', 'REPORT: HTMLFile'})}               = 'REPORT: HTMLFile'
    end

    varargout = {};
    emissionsTable = util.createEmissionsTable(specData, idxThreads, outputFinality);

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


        Bands = unique(emissionsTable.Band, 'stable');

        for Band = Bands'
            tagIdx = strcmp(emissionsTable.Band, Band);
    
            N1_Licenciada      = sum(tagIdx & ismember(emissionsTable.Regulatory, {'Licenciada', 'Licenciada UTE'})); % 'Licenciada' | 'Licenciada UTE'
            N1_NaoLicenciada   = sum(tagIdx &  strcmpi(emissionsTable.Regulatory, 'Não licenciada'));
            N1_NaoLicenciavel  = sum(tagIdx & contains(emissionsTable.Regulatory, 'Não passível', 'IgnoreCase', true));
    
            N2_Fundamental     = sum(tagIdx &  strcmpi(emissionsTable.Type,       'Fundamental'));
            N2_Harmonico       = sum(tagIdx &  strcmpi(emissionsTable.Type,       'Harmônico de fundamental'));
            N2_Produto         = sum(tagIdx &  strcmpi(emissionsTable.Type,       'Produto de intermodulação'));
            N2_Espuria         = sum(tagIdx &  strcmpi(emissionsTable.Type,       'Espúrio'));
            N2_NaoIdentificada = sum(tagIdx &  strcmpi(emissionsTable.Type,       'Não identificado'));
            N2_NaoManifestada  = sum(tagIdx &  strcmpi(emissionsTable.Type,       'Não se manifestou'));
            N2_Pendente        = sum(tagIdx & contains(emissionsTable.Type,       'Pendente', 'IgnoreCase', true));
    
            N3_Licenciada      = sum(tagIdx & ismember(emissionsTable.Regulatory, {'Licenciada', 'Licenciada UTE'})   & strcmpi(emissionsTable.Irregular, 'Sim'));
            N3_NaoLicenciada   = sum(tagIdx &  strcmpi(emissionsTable.Regulatory, 'Não licenciada')                   & strcmpi(emissionsTable.Irregular, 'Sim'));
            N3_NaoLicenciavel  = sum(tagIdx & contains(emissionsTable.Regulatory, 'Não passível', 'IgnoreCase', true) & strcmpi(emissionsTable.Irregular, 'Sim'));
            
            N4_Baixo           = sum(tagIdx &  strcmpi(emissionsTable.RiskLevel,  'Baixo'));
            N4_Medio           = sum(tagIdx &  strcmpi(emissionsTable.RiskLevel,  'Médio'));
            N4_Alto            = sum(tagIdx &  strcmpi(emissionsTable.RiskLevel,  'Alto'));
    
            N5_Radcom          = sum(tagIdx & (emissionsTable.Service == 231));
            N5_ClasseC         = sum(tagIdx & (emissionsTable.RFDataHubSource == "MOSAICO-SRD") & (emissionsTable.RFDataHubClass == "C"));
            N5_ClasseB         = sum(tagIdx & (emissionsTable.RFDataHubSource == "MOSAICO-SRD") & ismember(emissionsTable.RFDataHubClass, ["B", "B1", "B2"]));
            N5_ClasseA         = sum(tagIdx & (emissionsTable.RFDataHubSource == "MOSAICO-SRD") & ismember(emissionsTable.RFDataHubClass, ["A", "A1", "A2", "A3", "A4"]));
            N5_ClasseE         = sum(tagIdx & (emissionsTable.RFDataHubSource == "MOSAICO-SRD") & ismember(emissionsTable.RFDataHubClass, ["E", "E1", "E2", "E3"]));
            
            TotalSummaryTable(end+1, :) = {Band, N1_Licenciada, N1_NaoLicenciada, N1_NaoLicenciavel,                                                       ...
                                                 N2_Fundamental, N2_Harmonico, N2_Produto, N2_Espuria, N2_NaoIdentificada, N2_NaoManifestada, N2_Pendente, ...
                                                 N3_Licenciada, N3_NaoLicenciada, N3_NaoLicenciavel,                                                       ...
                                                 N4_Baixo, N4_Medio, N4_Alto,                                                                              ...
                                                 N5_Radcom, N5_ClasseC, N5_ClasseB, N5_ClasseA, N5_ClasseE};
        end
    end

    if contains(requestedOutput, 'IrregularTable')
        irregularIndex = strcmpi(emissionsTable.Irregular, 'Sim');
        irregularTable = emissionsTable(irregularIndex, {'Frequency',          ...
                                                         'Truncated',          ...
                                                         'BW_kHz',             ...
                                                         'MergedDescriptions', ...
                                                         'Regulatory',         ...
                                                         'Type',               ...
                                                         'RiskLevel'});
    end


    % Saída:
    requestedOutput = strsplit(requestedOutput, '+');
    for jj = 1:numel(requestedOutput)
        switch requestedOutput{jj}
            case 'TotalSummaryTable'
                varargout = [varargout, {TotalSummaryTable}];
            case 'EditedEmissionsTable'
                varargout = [varargout, {emissionsTable}];
            case 'IrregularTable'
                varargout = [varargout, {irregularTable}];
        end
    end
end