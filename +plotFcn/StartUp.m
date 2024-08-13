function StartUp(app, idx)

    plotFcn.DeleteAll(app)

    % Habilita/desabilita funcionalidades que dependem do número de
    % varreduradas.
    nSweeps = sum(app.specData(idx).RelatedFiles.nSweeps);
    if nSweeps > 2
        app.play_Occupancy.Enable   = 1;
        app.play_Persistance.Enable = 1;
        app.play_Waterfall.Enable   = 1;

    else
        set(app.play_Persistance, Enable=0, Value=0)
        set(app.play_Occupancy,   Enable=0, Value=0)
        set(app.play_Waterfall,   Enable=0, Value=0)

        plotFcn.Persistance(app, idx, 'Delete')
        plotFcn.OCC(app, idx, 'Delete', '', [])
        plotFcn.WaterFall(app, idx, 'Delete', '')
    end


    % Habilita/desabilita funcionalidades relacionadas ao tipo de fluxo 
    % espectral. Por exemplo: não tem sentido fazer uma análise de ocupação 
    % de um fluxo espectral de ocupação!
    if ismember(app.specData(idx).MetaData.DataType, class.Constants.occDataTypes)
        set(app.play_Occupancy, Enable=0, Value=0)
    end


    % Aspecto mais importante da seleção de um novo fluxo! Handle do nó
    % selecionado da árvore acessível através da propriedade "UserData", do
    % componente app.play_PlotPanel.
    app.play_PlotPanel.UserData  = TreeNode(app, idx);


    % Painel de metadados.
    nodeSummary = fcn.SelectedNodeSummary(app, 'app.specData', idx);
    app.play_Metadata.HTMLSource = textFormatGUI.struct2PrettyPrintList(nodeSummary, 'delete', '11px');


    % Barra de status.
    FreqStart = app.specData(idx).MetaData.FreqStart / 1e+6;
    FreqStop  = app.specData(idx).MetaData.FreqStop  / 1e+6;
    app.play_Timestamp.Text      = sprintf('1 de %d\n%s', nSweeps, app.specData(idx).Data{1}(1));


    % Painel de ocupação.
    layoutFcn.occStartup(app, idx)


    % Customização do playback.
    switch app.specData(idx).UserData.customPlayback.Type
        case 'auto'
            app.play_Customization.Value = 0;
            app.play_Waterfall_Decimation.Value = 'auto';

        case 'manual'
            app.play_Customization.Value = 1;
            layoutFcn.customPlayback(app, idx)
    end

    
    % Atualiza-se a árvore com a relação de canais relacionados ao fluxo espectral.
    % A árvore com a relação de emissões, por outro lado, será atualizada 
    % apenas ao plotar a curva ClrWrite - "plotFcn.clrWrite".
    play_Channel_TreeBuilding(app,  idx)
    if ~isempty(app.play_Channel_Tree.Children)
        app.play_Channel_Tree.SelectedNodes = app.play_Channel_Tree.Children(1);
        auxiliarWinFunction(app, app, 'plotFcn.StartUp')
    end


    % Atualiza-se a árvore com as subfaixas sob análise, caso aplicável.
    app.play_BandLimits_Status.Value = app.specData(idx).UserData.bandLimitsStatus;

    app.play_BandLimits_xLim1.Limits = [-Inf, Inf];
    app.play_BandLimits_xLim2.Limits = [-Inf, Inf];
    set(app.play_BandLimits_xLim1, Value=FreqStart, Limits=[FreqStart, FreqStop])    
    set(app.play_BandLimits_xLim2, Value=FreqStop,  Limits=[FreqStart, FreqStop])

    play_BandLimits_Layout(app, idx)
    play_BandLimits_TreeBuilding(app, idx)
end


%-------------------------------------------------------------------------%
function treeNode = TreeNode(app, idx)
    hTreeNodes     = findobj(app.play_Tree, '-not', 'Type', 'uitree');
    hTreeNodeData  = arrayfun(@(x) x.NodeData, hTreeNodes, "UniformOutput", false);
    hTreeNodeIndex = find(cellfun(@(x) isequal(idx, x), hTreeNodeData))';

    for ii = hTreeNodeIndex
        generation = play_findGenerationTreeNode(app, hTreeNodes(ii));
        if generation == 1
            treeNode = hTreeNodes(ii);
            break
        end
    end
end