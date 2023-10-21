function StartUp(app, idx)

    cla(app.axes1)
    cla(app.axes2)
    cla(app.axes3)


    % Controle do tempo.
    app.timeIndex = 1;
    app.play_PlaybackSlider.Value = 0;


    % Controle dos handles.
    app.restoreView        = {[0,1], [0,1], [0,1]};

    app.line_ClrWrite      = [];
    app.line_MinHold       = [];
    app.line_Average       = [];
    app.line_MaxHold       = [];
    app.obj_Persistance    = [];

    app.mkr_ROI            = [];
    app.mkr_Label          = [];
    
    app.line_OCC           = [];
    app.line_OCCLabel      = [];
        
    app.img_WaterFall      = [];
    app.line_WaterFallTime = [];


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
    app.play_PlotPanel.UserData  = app.play_Tree.SelectedNodes;


    % Painel de metadados.
    nodeSummary = fcn.SelectedNodeSummary(app, 'app.specData', idx);
    app.play_Metadata.HTMLSource = fcn.metadataInfo(nodeSummary, 'delete');


    % Barra de status.
    app.play_SelectedNode.Text   = sprintf('%s\nID %d: %.3f - %.3f MHz', app.specData(idx).Receiver,                  ...
                                                                         app.specData(idx).RelatedFiles.ID(1),        ...
                                                                         app.specData(idx).MetaData.FreqStart / 1e+6, ...
                                                                         app.specData(idx).MetaData.FreqStop  / 1e+6);
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
        play_Channel_TreeSelectionChanged(app)
    end
end