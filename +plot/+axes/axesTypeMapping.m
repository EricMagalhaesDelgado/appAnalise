function [axesType, axesXLabel] = axesTypeMapping(plotNamesPerAxes)

    axesType   = {};
    axesXLabel = {};

    for ii = 1:numel(plotNamesPerAxes)
        plotNames = strsplit(plotNamesPerAxes{ii}, '+');

        switch plotNames{1}
            case {'DriveTest', 'Stations', 'DriveTestRoute'}
                axesType{ii}   = 'Geographic';
                axesXLabel{ii} = '';
            
            case {'MinHold',             ...
                  'Average',             ...
                  'ClearWrite',          ...
                  'MaxHold',             ...
                  'Persistance',         ...
                  'Channel',             ...
                  'Emission',            ...
                  'OccupancyPerBin',     ...
                  'OccupancyPerChannel', ...
                  'Waterfall',           ...
                  'SamplesPerLevel'}
                axesType{ii}   = 'Cartesian';
                axesXLabel{ii} = 'Frequência (MHz)';

            case {'ChannelPower', 'Link'}
                axesType{ii}   = 'Cartesian';
                axesXLabel{ii} = '';
            
            otherwise
                error('Unexpected plotName %s', plotNamesPerAxes{ii})
        end
    end

end