function varargout = Config(plotTag, defaultProperties, customProperties)

    arguments
        plotTag
        defaultProperties % "GeneralSettings.json"        
        customProperties = []
    end

    selectedProperties = customPropertiesParser(plotTag, defaultProperties, customProperties);
    tempPlotConfig     = selectedProperties.Plot.(plotTag);

    switch plotTag
        case 'Persistance'

%                                                               'Transparency',     app.play_Persistance_Transparency.Value, ...
%                                                               'LevelLimits'


        plotConfig = {'CDataMapping', 'scaled', 'PickableParts', 'none', 'Interpolation', tempPlotConfig.Interpolation, 'Tag', plotTag};
        varargout  = {plotConfig, tempPlotConfig.Samples, tempPlotConfig.Colormap, tempPlotConfig.Transparency, tempPlotConfig.LevelLimits};        

        case 'Waterfall'
            % pendente

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
            plotConfig = [structUtil.struct2cellWithFields(rmfield(tempPlotConfig, 'Fcn')), {'Tag'}, {plotTag}];
            varargout  = {plotType, plotConfig};
    end
end


%-------------------------------------------------------------------------%
function selectedProperties = customPropertiesParser(plotTag, defaultProperties, customProperties)
    if isempty(customProperties)
        selectedProperties = defaultProperties;

    else
        switch plotTag
            case 'Persistance'
                selectedProperties.Plot.(plotTag) = customProperties.Persistance;
            
            case 'Waterfall'
                selectedProperties.Plot.(plotTag) = customProperties.Waterfall;
            
            case {'ClearWrite', 'Average', 'MinHold', 'MaxHold'}
                selectedProperties.Plot.(plotTag).XLim = customProperties.Controls.FrequencyLimits;
                selectedProperties.Plot.(plotTag).YLim = customProperties.Controls.LevelLimits;

            otherwise
                % ...
        end
    end
end