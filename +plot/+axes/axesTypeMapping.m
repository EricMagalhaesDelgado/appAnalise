function [axesType, axesXLabel] = axesTypeMapping(plotName)

    axesType   = {};
    axesXLabel = {};

    for ii = 1:numel(plotName)
        switch plotName{ii}
            case {'DriveTest', 'Stations', 'DriveTestRoute'}
                axesType{ii}   = 'Geographic';
                axesXLabel{ii} = '';
            
            case {'Spectrum',         ...
                  'Persistance',      ...
                  'OccupancyPerBin',  ...
                  'Waterfall',        ...
                  'OccupancyPerHour', ...
                  'OccupancyPerDay',  ...
                  'SamplesPerLevel'}
                axesType{ii}   = 'Cartesian';
                axesXLabel{ii} = 'Frequência (MHz)';

            case {'ChannelPower',     ...
                  'Link'}
                axesType{ii}   = 'Cartesian';
                axesXLabel{ii} = '';
            
            otherwise
                error('Unexpected plotName %s', plotName)
        end
    end

end