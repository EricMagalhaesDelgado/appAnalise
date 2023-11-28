function [infoTable, countTable] = ReportGenerator_Table_Summary(peaksTable, exceptionList)

    infoTable = table('Size', [0, 22],                                                                                                                 ...
                      'VariableTypes', {'cell',   'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16',  ...
                                        'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16'}, ...
                      'VariableNames', {'Banda', 'N1_Licenciada', 'N1_NaoLicenciada', 'N1_NaoLicenciavel',                                             ...
                                                 'N2_Fundamental', 'N2_Harmonico', 'N2_Produto', 'N2_Espuria', 'N2_NaoIdentificada', 'N2_NaoManifestada', 'N2_Pendente', ...
                                                 'N3_Licenciada', 'N3_NaoLicenciada', 'N3_NaoLicenciavel',                                                               ...
                                                 'N4_Baixo', 'N4_Medio', 'N4_Alto',                                                                                      ...
                                                 'N5_Radcom', 'N5_ClasseC', 'N5_ClasseB', 'N5_ClasseA', 'N5_ClasseE'});
    countTable = peaksTable;

    if ~isempty(peaksTable)
        for ii = 1:height(exceptionList)
            idx = find(strcmp(countTable.Tag,  exceptionList.Tag(ii)) & (abs(countTable.Frequency - exceptionList.Frequency(ii)) <= 1e-5))';
            
            for jj = idx
                countTable.Type{jj}        = exceptionList.Type{ii};
                countTable.Regulatory{jj}  = exceptionList.Regulatory{ii};
                countTable.Service(jj)     = exceptionList.Service(ii);
                countTable.Station(jj)     = exceptionList.Station(ii);
                countTable.Description{jj} = exceptionList.Description{ii};
                countTable.Distance{jj}    = exceptionList.Distance{ii};
                countTable.Irregular{jj}   = exceptionList.Irregular{ii};
                countTable.RiskLevel{jj}   = exceptionList.RiskLevel{ii};
            end
        end
        countTable.Tag = extractAfter(countTable.Tag, ': ');
        
        % Journal table 1:
        Bands = unique(countTable.Tag, 'stable');
        for ii = 1:numel(Bands)
            tagIdx = strcmp(countTable.Tag, Bands{ii});

            N1_Licenciada      = sum(tagIdx & strcmp(countTable.Regulatory, 'Licenciada'));
            N1_NaoLicenciada   = sum(tagIdx & strcmp(countTable.Regulatory, 'Não licenciada'));
            N1_NaoLicenciavel  = sum(tagIdx & strcmp(countTable.Regulatory, 'Não passível de licenciamento'));

            N2_Fundamental     = sum(tagIdx & strcmp(countTable.Type,       'Fundamental'));
            N2_Harmonico       = sum(tagIdx & strcmp(countTable.Type,       'Harmônico de fundamental'));
            N2_Produto         = sum(tagIdx & strcmp(countTable.Type,       'Produto de intermodulação'));
            N2_Espuria         = sum(tagIdx & strcmp(countTable.Type,       'Espúrio'));
            N2_NaoIdentificada = sum(tagIdx & strcmp(countTable.Type,       'Não identificado'));
            N2_NaoManifestada  = sum(tagIdx & strcmp(countTable.Type,       'Não se manifestou'));
            N2_Pendente        = sum(tagIdx & strcmp(countTable.Type,       'Pendente de identificação'));

            N3_Licenciada      = sum(tagIdx & strcmp(countTable.Regulatory, 'Licenciada')                    & strcmp(countTable.Irregular, 'Sim'));
            N3_NaoLicenciada   = sum(tagIdx & strcmp(countTable.Regulatory, 'Não licenciada')                & strcmp(countTable.Irregular, 'Sim'));
            N3_NaoLicenciavel  = sum(tagIdx & strcmp(countTable.Regulatory, 'Não passível de licenciamento') & strcmp(countTable.Irregular, 'Sim'));
            
            N4_Baixo           = sum(tagIdx & strcmp(countTable.RiskLevel,  'Baixo'));
            N4_Medio           = sum(tagIdx & strcmp(countTable.RiskLevel,  'Médio'));
            N4_Alto            = sum(tagIdx & strcmp(countTable.RiskLevel,  'Alto'));

            N5_Radcom          = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(countTable.Description, '\[SRD\] RADCOM', 'match')));
            N5_ClasseC         = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(countTable.Description, '\[MOSAICO-SRD\] (FM|TV)-C[0-9]{1,2}, C', 'match')));
            N5_ClasseB         = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(countTable.Description, '\[MOSAICO-SRD\] (FM|TV)-C[0-9]{1,2}, B', 'match')));
            N5_ClasseA         = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(countTable.Description, '\[MOSAICO-SRD\] (FM|TV)-C[0-9]{1,2}, A', 'match')));
            N5_ClasseE         = sum(tagIdx & cellfun(@(x) ~isempty(x), regexp(countTable.Description, '\[MOSAICO-SRD\] (FM|TV)-C[0-9]{1,2}, E', 'match')));
            
            infoTable(ii,:) = {Bands{ii}, N1_Licenciada, N1_NaoLicenciada, N1_NaoLicenciavel,                                                       ...
                                          N2_Fundamental, N2_Harmonico, N2_Produto, N2_Espuria, N2_NaoIdentificada, N2_NaoManifestada, N2_Pendente, ...
                                          N3_Licenciada, N3_NaoLicenciada, N3_NaoLicenciavel,                                                       ...
                                          N4_Baixo, N4_Medio, N4_Alto,                                                                              ...
                                          N5_Radcom, N5_ClasseC, N5_ClasseB, N5_ClasseA, N5_ClasseE};
        end
    end
end