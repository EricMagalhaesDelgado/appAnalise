function occStartup(app, idx)

    % Ajuste dos itens de app.play_OCC_Method, o qual depende da existência
    % de fluxos de ocupação relacionados aos fluxos de espectro. Lembrando
    % que atualmente os fluxos de ocupação são aqueles gerados pelo Logger.
    if isempty(app.specData(idx).UserData.occMethod.RelatedThreadIndex)
        app.play_OCC_Method.Items      = {'Linear fixo', 'Linear adaptativo', 'Envoltória do ruído'};
        app.play_OCC_THRCaptured.Items = {};

    else
        app.play_OCC_Method.Items      = {'Linear fixo (COLETA)', 'Linear fixo', 'Linear adaptativo', 'Envoltória do ruído'};
        app.play_OCC_THRCaptured.Items = arrayfun(@(x) num2str(x.MetaData.Threshold), app.specData(app.specData(idx).UserData.occMethod.RelatedThreadIndex), 'UniformOutput', false);
    end

    
    % Caso não esteja habilitado o botão de ocupação, então o painel de
    % ocupação é desabilitado. Se o fluxo de espectro possui habilitado a 
    % customização do playback, então os campos de todos os principais painéis 
    % (Persistência, Ocupação e Waterfall) serão atualizados em 
    % "layoutFcn.customPlayback".
    % Caso essa funcionalidade não tenha sido habilitada, é necessária
    % atualizadar os valores do painel de Ocupação.
    if app.play_Occupancy.Enable
        ComponentsUpdate(app, idx)
        layoutFcn.occVisibility(app, app.specData(idx).MetaData.LevelUnit)

    else
        hComponents = findobj(app.play_OCCGrid, '-not', {'Type', 'uilabel', '-or', 'Type', 'uigrid', '-or', 'Type', 'uipanel'});
        set(hComponents, Enable=0)
    end
end


%-------------------------------------------------------------------------%
function ComponentsUpdate(app, idx)

    if isempty(app.specData(idx).UserData.occMethod.CacheIndex)
        SelectedThreadIndex = app.specData(idx).UserData.occMethod.SelectedThreadIndex;
        
        if ~isempty(SelectedThreadIndex)
            app.play_OCC_Method.Value                  = 'Linear fixo (COLETA)';
            app.play_OCC_IntegrationTimeCaptured.Value = mean(app.specData(SelectedThreadIndex).RelatedFiles.RevisitTime)/60;
            app.play_OCC_THRCaptured.Value             = num2str(app.specData(SelectedThreadIndex).MetaData.Threshold);
        end

    else
        occIndex = app.specData(idx).UserData.occMethod.CacheIndex;
        occInfo  = app.specData(idx).UserData.occCache(occIndex).Info;
    
        app.play_OCC_Method.Value = occInfo.Method;
    
        switch occInfo.Method
            case 'Linear fixo (COLETA)'
                app.play_OCC_IntegrationTimeCaptured.Value = occInfo.IntegrationTimeCaptured;
                app.play_OCC_THRCaptured.Value             = num2str(occInfo.THRCaptured);
    
            case 'Linear fixo'
                app.play_OCC_IntegrationTime.Value         = num2str(occInfo.IntegrationTime);
                app.play_OCC_THR.Value                     = occInfo.THR;
    
            otherwise % 'Linear adaptativo' | 'Envoltória do ruído'            
                app.play_OCC_IntegrationTime.Value         = num2str(occInfo.IntegrationTime);
                app.play_OCC_Offset.Value                  = occInfo.Offset;
                app.play_OCC_noiseFcn.Value                = occInfo.noiseFcn;
                app.play_OCC_noiseTrashSamples.Value       = 100 * occInfo.noiseTrashSamples;
                app.play_OCC_noiseUsefulSamples.Value      = 100 * occInfo.noiseUsefulSamples;
    
                if strcmp(occInfo.Method, 'Envoltória do ruído')
                    app.play_OCC_ceilFactor.Value          = occInfo.ceilFactor;
                end
        end
    end
end