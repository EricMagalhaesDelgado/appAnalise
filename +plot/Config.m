function varargout = Config(plotTag, defaultProperties, customProperties)

    arguments
        plotTag
        defaultProperties     % "GeneralSettings.json"        
        customProperties = [] % Customização disponibilizada no modo PLAYBACK do app
    end

    selectedProperties  = customPropertiesParser(plotTag, defaultProperties, customProperties);
    tempPlotConfig      = selectedProperties.Plot.(plotTag);

    switch plotTag
        case 'Persistance'
            plotConfig  = {'CDataMapping', 'scaled', 'PickableParts', 'none', 'Interpolation', tempPlotConfig.Interpolation};

            % Aspectos relacionados ao cLim da curva de persistência:
            % (a) O arquivo "GeneralSettings.json" tem como padrão o vetor [-1,-1]. 
            % (b) A customização desse parâmetro é possível apenas quando o tamanho 
            %     da janela da persistência é "full". 
            if ~issorted(tempPlotConfig.LevelLimits, 'strictascend') || ~strcmp(tempPlotConfig.WindowSize, 'full')
                tempPlotConfig.LevelLimits = [];
            end

            varargout   = {plotConfig, tempPlotConfig.WindowSize, tempPlotConfig.Colormap, tempPlotConfig.Transparency, tempPlotConfig.LevelLimits};

        case 'Waterfall'
            switch tempPlotConfig.Fcn
                case 'mesh'
                    plotConfig = {'MeshStyle', tempPlotConfig.MeshStyle, 'SelectionHighlight', 'off'};
                case 'image'
                    plotConfig = {'CDataMapping', 'scaled'};
            end

            if ~issorted(tempPlotConfig.LevelLimits, 'strictascend')
                tempPlotConfig.LevelLimits = [];
            end

            varargout   = {plotConfig, tempPlotConfig.Fcn, tempPlotConfig.Decimation, tempPlotConfig.Colormap, tempPlotConfig.LevelLimits};

        case 'WaterfallTime'
            plotType    = 'line';
            plotConfig  = {'Color', 'red', 'LineWidth', 1, 'PickableParts', 'none', 'Visible', tempPlotConfig.Visible};
            varargout   = {plotConfig, plotType};

        case {'ClearWrite', 'Average', 'MinHold', 'MaxHold'}
            switch tempPlotConfig.Fcn
                case 'line'
                    tempPlotConfig = rmfield(tempPlotConfig, {'EdgeColor', 'FaceColor'});
                case 'area'
                    tempPlotConfig = rmfield(tempPlotConfig, {'Color'});
                otherwise
                    error('UnexpectedPlotType')
            end

            plotType   = tempPlotConfig.Fcn;
            plotConfig = structUtil.struct2cellWithFields(rmfield(tempPlotConfig, 'Fcn'));
            varargout  = {plotConfig, plotType};
    end

    varargout{1} = [varargout{1}, {'Tag', plotTag}];
end


%-------------------------------------------------------------------------%
function selectedProperties = customPropertiesParser(plotTag, defaultProperties, customProperties)
    selectedProperties = defaultProperties;
    if ~isempty(customProperties)
        if ismember(plotTag, {'Persistance', 'Waterfall', 'WaterfallTime'})
            selectedProperties.Plot.(plotTag) = customProperties.(plotTag);
        end
    end
end