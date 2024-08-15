function varargout = customPlayback(controlType, specData, varargin)

    arguments
        controlType char {mustBeMember(controlType, {'updateGUI', 'updateXYLimits'})}
        specData    class.specData
    end

    arguments (Repeating)
        varargin
    end

    varargout = {};

    % Em relação à customização do PLAYBACK,
    % (a) Até a v. 1.67, o appAnalise possibilitava a customização de onze parâmetros
    %     do PLAYBACK. Desde a v. 1.80, o app aumentou esse número para vinte
    %     (praticamente todos!). Além disso, os nomes dos parâmetros foram compactados, 
    %     o que demandou ajuste no leitor .MAT, mantendo a compatibilidade com os .MAT
    %     gerado em versões anteriores do app.
    
    % (b) A atualização do componente app.play_LayoutRatio deve ser posterior
    %     à atualização dos componentes app.play_Occupancy e app.play_Waterfall.
    
    % (c) A atualização dos limites dos eixos x e y é realizada automaticamente,
    %     seguindo os limites do eixos app.axes1.
    %     addlistener(app.axes1, 'XLim', 'PostSet', @app.plot_xLimitsUpdate);
    %     addlistener(app.axes1, 'YLim', 'PostSet', @app.plot_yLimitsUpdate);

    switch controlType
        case 'updateGUI'
            app = varargin{1};

            % Informação gerada na v. 1.67:
            app.tool_MinHold.Value     = specData.UserData.customPlayback.Parameters.Controls.MinHold;
            app.tool_Average.Value     = specData.UserData.customPlayback.Parameters.Controls.Average;
            app.tool_MaxHold.Value     = specData.UserData.customPlayback.Parameters.Controls.MaxHold;
            app.tool_Persistance.Value = specData.UserData.customPlayback.Parameters.Controls.Persistance;
            app.tool_Occupancy.Value   = specData.UserData.customPlayback.Parameters.Controls.Occupancy;
            app.tool_Waterfall.Value   = specData.UserData.customPlayback.Parameters.Controls.Waterfall;

            app.play_LayoutRatio.Items = plot_axesAspectRatio(app);
            app.play_LayoutRatio.Value = specData.UserData.customPlayback.Parameters.Controls.LayoutRatio;
            
            app.play_Persistance_Interpolation.Value = specData.UserData.customPlayback.Parameters.Persistance.Interpolation;
            app.play_Persistance_Samples.Value       = specData.UserData.customPlayback.Parameters.Persistance.Samples;
            app.play_Persistance_Transparency.Value  = specData.UserData.customPlayback.Parameters.Persistance.Transparency;
            app.play_Waterfall_Decimation.Value      = specData.UserData.customPlayback.Parameters.Waterfall.Decimation;

            % Informação complementar gerada a partir da v. 1.80 (com validações
            % para evitar erro): (1 de 2)
            if isfield(specData.UserData.customPlayback.Parameters.Persistance, 'Colormap')
                app.play_Persistance_Colormap.Value  = specData.UserData.customPlayback.Parameters.Persistance.Colormap;
            end

            if isfield(specData.UserData.customPlayback.Parameters.Persistance, 'LevelLimits')
                app.play_Persistance_cLim1.Value = specData.UserData.customPlayback.Parameters.Persistance.LevelLimits(1);
                app.play_Persistance_cLim2.Value = specData.UserData.customPlayback.Parameters.Persistance.LevelLimits(2);
            end

            if isfield(specData.UserData.customPlayback.Parameters.Waterfall,   'Timestamp')
                app.play_Waterfall_Timestamp.Value = specData.UserData.customPlayback.Parameters.Waterfall.Timestamp;
            end

            if isfield(specData.UserData.customPlayback.Parameters.Waterfall,   'Colormap')
                app.play_Waterfall_Colormap.Value  = specData.UserData.customPlayback.Parameters.Waterfall.Colormap;
            end

            if isfield(specData.UserData.customPlayback.Parameters.Waterfall,   'Interpolation')
                app.play_Waterfall_Interpolation.Value = specData.UserData.customPlayback.Parameters.Waterfall.Interpolation;
            end
            
            if isfield(specData.UserData.customPlayback.Parameters.Persistance, 'LevelLimits')
                app.play_Waterfall_cLim1.Value = specData.UserData.customPlayback.Parameters.Waterfall.LevelLimits(1);
                app.play_Waterfall_cLim2.Value = specData.UserData.customPlayback.Parameters.Waterfall.LevelLimits(2);
            end

        case 'updateXYLimits'
            % Informação complementar gerada a partir da v. 1.80 (com validações
            % para evitar erro): (2 de 2)
            varargout{1} = [];

            if all(isfield(specData.UserData.customPlayback.Parameters.Controls, {'FrequencyLimits', 'LevelLimits'}))
                varargout{1}.xLim = specData.UserData.customPlayback.Parameters.Controls.FrequencyLimits;
                varargout{1}.yLevelLim = specData.UserData.customPlayback.Parameters.Controls.LevelLimits;
            end
    end
end