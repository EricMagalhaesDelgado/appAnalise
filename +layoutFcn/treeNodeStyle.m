function treeNodeStyle(app)

    % specIndex..: índices dos fluxos de dados de espectro.
    % occIndex...: índices dos fluxos de dados de ocupação.
    % reportIndex: subconjunto de specIndex, representando os índices dos 
    %              fluxos de dados que serão analisados no modo "RELATÓRIO".

    removeStyle(app.play_Tree)

    hTree1 = allchild(app.play_Tree);
    hTree2 = [];
    for ii = 1:numel(hTree1)
        hTree2 = [hTree2; allchild(hTree1(ii))];
    end

    specIndex   = find(arrayfun(@(x) ismember(x.MetaData.DataType, class.Constants.specDataTypes), app.specData));
    reportIndex = find(arrayfun(@(x) x.UserData.reportFlag, app.specData));
    occIndex    = setdiff(1:numel(app.specData), specIndex);

    set(hTree2(setdiff(specIndex, reportIndex)), Icon=fcn.treeNodeIcon('DataType', 'SpectralData'))
    set(hTree2(reportIndex),                     Icon='LT_report.png')
    set(hTree2(occIndex),                        Icon=fcn.treeNodeIcon('DataType', 'Occupancy'))
end