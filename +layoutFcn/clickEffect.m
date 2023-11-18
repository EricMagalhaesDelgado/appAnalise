function clickEffect(app, idx, hComp)

    % Evidencia células que tiveram os seus valores editados...
    set(hComp, BackgroundColor='#bfbfbf')
    drawnow

    % Desenha novamente a árvore, deixando selecionados os mesmos fluxos espectrais
    % que estavam selecionados quando da edição das suas informações de GPS.
    play_TreeBuilding(app)    
    hTreeNodes     = findobj(app.play_Tree, '-not', 'Type', 'uitree');
    hTreeNodeData  = arrayfun(@(x) x.NodeData, hTreeNodes, "UniformOutput", false);
    hTreeNodeIndex = [];
    for ii = idx
        hTreeNodeIndex = [hTreeNodeIndex, find(cellfun(@(x) isequal(ii, x), hTreeNodeData), 1)]; 
    end
    app.play_Tree.SelectedNodes = hTreeNodes(hTreeNodeIndex);
    auxiliarWinFunction(app, app, 'fcn.clickEffect')    
    report_TreeBuilding(app)

    % Retira evidência às supracitadas células.
    set(hComp, BackgroundColor='white') 
end